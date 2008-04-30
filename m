Return-Path: <linux-kernel-owner+w=401wt.eu-S1764691AbYD3XWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764691AbYD3XWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbYD3XVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:21:53 -0400
Received: from 1wt.eu ([62.212.114.60]:3649 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYD3XVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:21:52 -0400
Date: Thu, 1 May 2008 01:21:43 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, rjw@sisk.pl, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430232143.GN7501@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430224610.GO8474@1wt.eu> <20080430155252.76469ead.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080430155252.76469ead.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 03:52:52PM -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 00:46:10 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > On Wed, Apr 30, 2008 at 03:31:22PM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> > > > 
> > > > > And there's no way to avoid the fact that during the merge window, we will 
> > > > > get something on the order of ten thousand commits (eg 2.6.24->25-rc1 was 
> > > > > 9629 commits).
> > > > 
> > > > Well, do we _have_ _to_ take that much?  I know we _can_, but is this really
> > > > necessary?
> > > 
> > > Do you want me to stop merging your code?
> > > 
> > > Do you think anybody else does?
> > > 
> > > Any suggestions on how to convince people that their code is not worth 
> > > merging?
> > 
> > I think you're approaching a solution Linus. If developers take a refusal
> > as a punishment, maybe you can use that for trees which have too many
> > unresolved regressions. This would be really unfair to subsystem maintainers
> > which themselves merge a lot of work, but recursively they may apply the
> > same principle to their own developers, so that everybody knows that it's
> > not worth working on next code past a point where too many regressions are
> > reported.
> > 
> 
> Well.  If we were good enough at tracking bug reports and regressions we
> could look at the status of subsytem X and say "no new features for you".
> 
> That would be a drastic step even if we had the information to do it (which
> we don't).

We already have some information, Rafael is tracking this info. But we need
other developers to look at others' bugs. If we considered that for each
release, the *worst* subsystem does not get any new features merged, maybe
the ones who really want to get theirs merged will quickly take a look at
their not-so-friend coworkers's work to try to get their score up and
avoid getting spotted.

After all, that's what we want to achieve : better cross-testing. For
2.6.27, we would probably have Davem happy to report one hundred of
bugs brought by Ingo and ban him from next merge. But if that's the
only way to find 100 buts in one release cycle, hey that's quite
efficient! And in turn, Ingo would have more time to fix (or deny)
bugs assigned to him, then take a look at his accuser's code for next
release.

Not very moral, but the kernel team has evolved from a small team of
buddies to a large enterprise. And to survive this evolution, we may
need to apply the immoral principles found in big companies.

Willy

