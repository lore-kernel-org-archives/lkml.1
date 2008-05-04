Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbYEDAgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbYEDAgF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 20:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbYEDAfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 20:35:52 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:37281 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbYEDAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 20:35:51 -0400
Date: Sun, 4 May 2008 03:34:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080504003452.GB5838@cs181133002.pp.htv.fi>
References: <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805040018420.6003@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805040018420.6003@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 01:22:15AM +0200, Thomas Gleixner wrote:
> On Sun, 4 May 2008, Adrian Bunk wrote:
> > > at minimum a warning needs to be emitted by the kconfig tool if such 
> > > incomplete selects are used. I've stopped counting the number of times 
> > > such issues have broken the build and have held up kernel development. 
> > 
> > It might held up your randconfig compiles.
> > 
> > Actual kernel development isn't much affected.
> 
> Interesting. You confidently define how kernel development works and
> what affects it and what not. 
> 
> I just caught a build wreckage via randconfig builds on a patch which
> was sent through Andrew to x86 for merging into mainline.
> 
> So you think that we should stop sharing with the wider kernel
> community the fixes that result out of our automated randconfig builds
> and should instead wait for Joe User or another kernel developer to
> trip into some subtle missing Kconfig dependency, just because a fix
> might not be the right one and might need another iteration before it
> can go upstream?
> 
> You are wrong as usual.
> 
> I for one prefer getting a (even wrong) patch which points to the
> problem instead of some (often grumpy) "this broke" message.

Ingo' message that caused me to change the subject of this thread was
  http://lkml.org/lkml/2008/4/30/446

Ingo's patch did not point at the actual problem at all (it was a x86 
bug and Ingo's patch was for input). But he tried to push his bogus 
patch through Dmitry who had correctly stated that the patch was wrong.

This way of "sharing fixes" even against a correct maintainer NAK is 
what annoys me.

Am I really wrong as usual on that?

And most issues randconfig finds are some cornercases unlikely to happen 
for users (hey, this thread is about a bug only occuring in 
configurations that include support for an X-Box gamepad in a kernel for 
an RDC R-321x SoC), so there's usually no need to hurry but time to look 
at the problem and fix it properly.

> > Before you started your randconfig builds and sending (often buggy) 
> > kconfig patches like crazy there wasn't a problem (and Toralf's 
> > randconfig builds already catched these problems in the past).
> 
> FYI, Ingo has been doing randconfig build and boot tests for a long,
> long time. There are dozens and dozens of (non-build) fixes in the
> upstream kernel that resulted from that effort - it's really valuable
> in practice.

Since when is he actually doing regular randconfig builds?

The only person from whom I'm aware of regularly seeing reports of build 
breakages with randconfig on linux-kernel for many years is Toralf.

> So what you say is complete nonsense.
> 
> The RDC subarch commit was buggy, but that does not justify your
> insulting and self-righteous behaviour at all. If you think that your
> behaviour vs. Ingo is improving kernel development, then you are on
> the completely wrong track. It might earn you an entry in his
> killfile, but nothing else.

When talking about "self-righteous behaviour" please also talk about how 
Ingo rants about kconfig and makes statements like "All the information 
is already in the Kconfig files for the kconfig tool/subsystem to make 
an intelligent decision." [1] that are simply wrong.

> Thanks,
> 
> 	tglx

cu
Adrian

[1] http://lkml.org/lkml/2008/5/3/215

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

