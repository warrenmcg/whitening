\name{scca}
\alias{scca}
\alias{cca}

\title{Estimate Canonical Correlations and Directions (Shrinkage and Empirical Estimates)}
\usage{
scca(X, Y, lambda.cor, scale=TRUE, verbose=TRUE)
cca(X, Y, scale=TRUE)
}
\arguments{
  \item{X}{First data matrix, with samples in rows and variables in columns.}  
  \item{Y}{Second data matrix, with samples in rows and variables in columns.}  
  \item{lambda.cor}{Shrinkage intensity for estimating the joint correlation matrix - 
                    see \code{\link[corpcor]{cor.shrink}}. 
                    If not specified this will be estimated from the data.}
  \item{scale}{Determines whether canonical directions are computed for standardized or raw data.
               Note that if data are not standardized the canonical directions contain the scale
               of the variables.}
  \item{verbose}{Report shrinkage intensities-}
}

\description{
  \code{scca} computes canonical correlations and directions using a shrinkage estimate of the joint 
              correlation matrix of \eqn{X} and \eqn{Y}.

  \code{cca}  computes canonical correlations and directions based on empirical correlations.

}

\value{
  \code{scca} and \code{cca} return a list with the following components:

  \code{K} - the correlation-adjusted cross-correlations.

  \code{lambda} - the canonical correlations. 
                 
  \code{WX} - the whitening matrix for  \eqn{X}, with canonical directions in the rows.

  \code{WY} - the whitening matrix for  \eqn{Y}, with canonical directions in the rows.

  \code{scale} - whether data was standardized (if code{scale=FALSE} then canonical directions include scale of the data).
  
  \code{scca} additionally returns the shrinkage intensity in the
  variable \code{lambda.cor} where
  \code{lambda.cor.estimated} indicates whether it was specified or estimated.

}

\details{
   
The canonical directions in this function are scaled in such a way that they correspond to whitening matrices - see Jendoubi and Strimmer (2018) for details. Note that the sign convention for the canonical directions employed here allows purposely for both positive and negative canonical correlations.

The function \code{scca} uses some clever matrix algebra to avoid computation of full correlation
matrices, and hence can be applied to high-dimensional data sets - see Jendoubi and Strimmer (2018) for details.

\code{cca} it is a shortcut for running \code{scca} with \code{lambda.cor=0} and \code{verbose=FALSE}.

If \code{scale=FALSE} the standard deviations needed for the canonical directions are estimated 
by  \code{apply(X, 2, sd)} and \code{apply(X, 2, sd)}.

If \eqn{X} or \eqn{Y} contains only a single variable the correlation-adjusted cross-correlations \eqn{K}
reduce to the CAR score (see \code{\link[care]{carscore}}) described in Strimmer and Zuber (2011).

}

\author{
  Korbinian Strimmer (\url{http://strimmerlab.org}) with Takoua Jendoubi.
}
\seealso{\code{\link[stats]{cancor}} and \code{\link[care]{carscore}}.}


\references{
Jendoubi, T., and K. Strimmer 2018. Probabilistic canonical correlation 
analysis: a whitening approach. \url{https://arxiv.org/abs/1802.03490}

Zuber, V., and K. Strimmer. 2011.  High-dimensional regression and 
variable selection using CAR scores.  Statist. Appl. Genet. Mol. Biol. 10: 34.
\url{https://doi.org/10.2202/1544-6115.1730}

}


\examples{
# load whitening library
library("whitening")


# example data set
data(LifeCycleSavings)
X = as.matrix( LifeCycleSavings[, 2:3] )
Y = as.matrix( LifeCycleSavings[, -(2:3)] )
n = nrow(X)
colnames(X) # "pop15" "pop75"
colnames(Y) # "sr"   "dpi"  "ddpi" 

# CCA

cca.out = cca(X, Y, scale=TRUE)
cca.out$lambda  # canonical correlations
cca.out$WX      # whitening matrix / canonical directions X
cca.out$WY      # whitening matrix / canonical directions Y
cca.out$K       # correlation-adjusted cross-correlations

# CCA whitened data
CCAX = scale(X) %*% t(cca.out$WX)
CCAY = scale(Y) %*% t(cca.out$WY)
zapsmall(cov(CCAX))
zapsmall(cov(CCAY))
zapsmall(cov(CCAX,CCAY)) # canonical correlations


# compare with built-in function cancor 
# note different signs in correlations and directions!
cancor.out = cancor(scale(X), scale(Y))
cancor.out$cor                  # canonical correlations
t(cancor.out$xcoef)*sqrt(n-1)   # canonical directions X
t(cancor.out$ycoef)*sqrt(n-1)   # canonical directions Y


## see "User guides, package vignettes and other documentation"
## for examples with high-dimensional data using the scca function


}
\keyword{multivariate}
