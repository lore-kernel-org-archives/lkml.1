Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXKLPVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXKLPVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbXKLPVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:21:22 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60387 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755286AbXKLPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:21:21 -0500
Date: Mon, 12 Nov 2007 16:20:57 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112152057.GJ9771@stusta.de>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 01:51:25PM +0000, Tuomo Valkonen wrote:
> On 2007-11-12, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > I think a megafreeze development model is sane.  Finding a collection
> > of software versions that are all known to work together is very
> > interesting, and useful.  Making it so you can deliver something that
> > just works to end users is always interesting.
> 
> The distros only do that for the most important and most popular
> packages, most of which have become rather "generic" and faceless
> behemots in the sense that they do not have definite authors and so
> on, and for which it takes years to respond to bug reports in any case
> (if someone even bothers to enter the bug in registration-required
> Suckzilla, Debian's reportbug becoming much more usable in this case,
> even though it typically takes another year for the package maintainer
> to report things back upstream, if it ever even happens).
> 
> Other more marginal software with a face, the distros just throw in
> and expect the author to deal with users having problems with ancient
> development snapshots and even bugs in stable versions that the distros
> simply refuse to fix. They should not distribute that kind of software
> at all. That is, distros should stick to providing stable base systems, 
> and fully supported (and renamed if not generic) customised versions of
> other software for their target audience. For the rest, there should
> be better mechanisms for authors to distribute binary or otherwise
> easily and reliably installable packages of their software. 

The problem is not what the distributions ship, the problem is simply 
that problems with distribution packaged software should be reported 
to the distribution, not upstream.

And for becoming at least marginally on-topic again:
Assuming your "stable base systems" contains the Linux kernel, how would
you prevent users from reporting bugs in their ancient kernels [1] here?

> Closed-source operating systems are more decentralised than Linux,
> where the par^W^W a few big distros have de facto central control 
> over the software that users can conveniently install.

You should rephrase it:
Closed-source operating systems offer less software both available for 
convenient installation and supported by the vendor of the operating 
system.

Noone forces any users to install the software their distribution 
supports - people can (and sometimes do) install other software or
other versions of some software when they need it.

But the good thing about open source software is that when you believe 
your ideas are better than what current distributions do you can 
implement your ideas and create your own distribution. Then time will 
tell whether you were right or wrong.

> Tuomo

cu
Adrian

[1] keep in mind that when using a 6 months old kernel, this kernel
    differs by more than one million lines of code (sic) from the 
    current kernel

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

