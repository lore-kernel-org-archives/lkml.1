Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXKLRPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXKLRPb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:15:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXKLRPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:15:21 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:60098 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757943AbXKLRPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:15:20 -0500
Date: Mon, 12 Nov 2007 18:14:57 +0100
From: Adrian Bunk <bunk@kernel.org>
To: "Rogelio M. Serrano Jr." <rogelio@smsglobal.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112171456.GN9771@stusta.de>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <47387BB5.4090908@smsglobal.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47387BB5.4090908@smsglobal.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 12:13:41AM +0800, Rogelio M. Serrano Jr. wrote:
> Adrian Bunk wrote:
> > On Mon, Nov 12, 2007 at 01:51:25PM +0000, Tuomo Valkonen wrote:
> >   
> >> On 2007-11-12, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >>     
> >>> I think a megafreeze development model is sane.  Finding a collection
> >>> of software versions that are all known to work together is very
> >>> interesting, and useful.  Making it so you can deliver something that
> >>> just works to end users is always interesting.
> >>>       
> >> The distros only do that for the most important and most popular
> >> packages, most of which have become rather "generic" and faceless
> >> behemots in the sense that they do not have definite authors and so
> >> on, and for which it takes years to respond to bug reports in any case
> >> (if someone even bothers to enter the bug in registration-required
> >> Suckzilla, Debian's reportbug becoming much more usable in this case,
> >> even though it typically takes another year for the package maintainer
> >> to report things back upstream, if it ever even happens).
> >>
> >> Other more marginal software with a face, the distros just throw in
> >> and expect the author to deal with users having problems with ancient
> >> development snapshots and even bugs in stable versions that the distros
> >> simply refuse to fix. They should not distribute that kind of software
> >> at all. That is, distros should stick to providing stable base systems, 
> >> and fully supported (and renamed if not generic) customised versions of
> >> other software for their target audience. For the rest, there should
> >> be better mechanisms for authors to distribute binary or otherwise
> >> easily and reliably installable packages of their software. 
> >>     
> >
> > The problem is not what the distributions ship, the problem is simply 
> > that problems with distribution packaged software should be reported 
> > to the distribution, not upstream.
> >
> > And for becoming at least marginally on-topic again:
> > Assuming your "stable base systems" contains the Linux kernel, how would
> > you prevent users from reporting bugs in their ancient kernels [1] here?
> >
> Isn't the kernel easier to sync with latest and greatest?
> 
> The core libc and supporting libraries is the core. and the toolchain
> the core dev. Those can be updated twice or even once a year. The kernel
> can be updated once a month if you like.

A new release of the Linux kernel has more than half a million lines of 
code changed. If you do any estimates based on how many lines of changed 
code equal one newly introduced bug you see the problem...

And the difference between an upstream kernel and a distribution kernel 
are 3-6 months of testing and bugfixing.

> I stopped using debian myself and used DIY linux based toolchain and
> libc. Thats the stable core that i have been using for 4 months. If
> debian can reduce the footprint of the "stable core" and do monthly
> releases of package bundles i will use it again.

Geeks like you and me want the latest software
(I'm using Debian unstable/testing).

But most users want a Linux installation that simply works - and this 
includes all software on the system at all times.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

