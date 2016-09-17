using ParameterizedFunctions
using Base.Test

### ODE Macros

f = @ode_def LotkaVoltera begin
  dx = a*x - b*x*y
  dy = -c*y + d*x*y
end a=>1.5 b=>1 c=3 d=1


type  LotkaVoltera2 <: ParameterizedFunction
         a::Float64
         b::Int64
end
(p::LotkaVoltera2)(t,u,du) = begin
         du[1] = p.a * u[1] - p.b * u[1]*u[2]
         du[2] = -3 * u[2] + u[1]*u[2]
end

t = 1.0
u = [2.0,3.0]
du = zeros(2)
f(t,u,du)
@test du == [-3.0,-3.0]
g = LotkaVoltera(1.0,2.0)
g(t,u,du)
@test du == [-10.0,-3.0]
h = LotkaVoltera2(1.0,2.0)
h(t,u,du)
@test du == [-10.0,-3.0]


### FEM Macros

f = @fem_def (t,x) TestType begin
  du = exp(-t-5*(1-2x+2x.^2 - 2y +2y.^2)).*(-161 + a*(x - x.^2 + y - y.^2))
end a=400
g = (t,x) -> exp(-t-5*(1-2x[:,1]+2x[:,1].^2 - 2x[:,2] +2x[:,2].^2)).*(-161 + 400*(x[:,1] - x[:,1].^2 + x[:,2] - x[:,2].^2))
x = rand(4,2)

h = (t,x,u)  -> [1-.5*2.0*u[:,1]   -1-u[:,2]]

l = @fem_def (t,x,u) TestType2 begin
  du = 1-α*β*u
  dv = -1-v
end α=>0.5 β=2.0

@test f(1.0,x) == g(1.0,x)
@test h(1.0,x,x) == l(1.0,x,x)