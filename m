Return-Path: <linux-kernel-owner+w=401wt.eu-S1764347AbZFLKfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764347AbZFLKfi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZFLKfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:35:31 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41410 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbZFLKfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:35:30 -0400
Date: Fri, 12 Jun 2009 12:35:21 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Nicolas Pitre <nico@cam.org>, Ryan Mallon <ryan@bluewatersys.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612103521.GD18682@elf.ucw.cz>
References: <20090611132134.GA11199@atomide.com> <20090611133736.GP795@n2100.arm.linux.org.uk> <20090611140038.GB11199@atomide.com> <20090611140624.GS795@n2100.arm.linux.org.uk> <alpine.LFD.2.00.0906111314510.31536@xanadu.home> <4A3175AC.9070100@bluewatersys.com> <alpine.LFD.2.00.0906112105220.31536@xanadu.home> <4A31AECA.6070303@bluewatersys.com> <alpine.LFD.2.00.0906112138090.31536@xanadu.home> <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906111916y2f49e5a9q362e12b52fb5414a@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> Thats my point though: In the meantime, it falls on Russell by default
> >> to be the one to verify all the patches going through. I think the same
> >> is true for new architectures, if nobody else has the interest/hardware
> >> besides those posting the patches, then who is meant to do the
> >> reviewing/acking?
> >
> > I think that, at some point, if nobody else has the interest/hardware,
> > then you are on your own.  Just make sure that your code respects the
> > kernel coding style, has no obvious API misuses, and that it does not
> > affect anyone else.  At that point if you can convince people that your
> > code is actually useful and that you'll be around to quickly respond
> > if/when issues are reported then it should just be merged.
> 
> My hope with the msm support is to get buildable, bootable (we're
> there now), style-clean (we probably have stuff that needs help yet,

I still can't get it to boot :-(.

> At that point, I think we'll get more people looking at, testing, and
> hopefully contributing and reviewing patches in that domain -- I know
> there are a lot of folks out there hacking on ADP1 (the unlocked dev
> phone) or "rooted" G1s, and some of them tinker with things at the
> kernel level.
> 
> >From a practical standpoint, some questions about trying to get a
> bunch of msm stuff cleaned up possibly for 2.6.31:
> - would having some ifdefs around code using wakelock support be
> acceptable for the time being?  The wakelock/suspendblock review does
> seem to be making progress on linux-pm if not super quickly, and I'd
> rather maintain some ifdefs than maintain two different versions of
> drivers while it's getting sorted out.

#ifdefs are too ugly, I'm afraid. And there will be need for for
second tree, at least temporarily.

> - from where we are now, with .30 about to be wrapped up, what's the
> reasonable timeline for putting together a patch series for mach-msm
> and for drivers/staging/msm7k or the like?  When should I be sending
> what to where?  Presumably to lakml at the least?

Well, I guess "start ASAP and maybe we can make it into .32".

> - is it essential to completely flatten down to single patches for new
> drivers?  We do have history including contributions from Qualcomm,
> HTC, etc, which would be nice to preserve in some cases, but if that's
> impractical, we can do a complete rebase and flatten on top of tip of
> tree.

I guess preserving history is not top priority.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
