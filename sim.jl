using Pkg
Pkg.add("ModelingToolkit")
Pkg.add("OrdinaryDiffEq")
Pkg.add("Plots")

print(1+1)

using ModelingToolkit
using ModelingToolkit: t_nounits as t, D_nounits as D

@mtkmodel FOL begin
    @parameters begin
        τ = 3.0 # parameters
    end
    @variables begin
        x(t) = 0.0 # dependent variables
    end
    @equations begin
        D(x) ~ (1 - x) / τ
    end
end

using OrdinaryDiffEq
@mtkcompile fol = FOL()

# prob = ODEProblem(fol, [], (0.0, 10.0), [])

# Warning: `ODEProblem(sys, u0, tspan, p; kw...)` is deprecated. Use
# │ `ODEProblem(sys, merge(if isempty(u0)
# │     Dict()
# │ else
# │     Dict(unknowns(sys) .=> u0)
# │ end, if isempty(p)
# │     Dict()
# │ else
# │     Dict(parameters(sys) .=> p)
# │ end), tspan)` instead.

prob = ODEProblem(fol, merge(if isempty([])
  Dict()
else
    Dict(unknowns(fol) .=> [])
end, if isempty([])
    Dict()
else
    Dict(parameters(fol) .=> [])
end), (0.0, 10.0))

sol = solve(prob)

using Plots
plot(sol)

