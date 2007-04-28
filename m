Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXD1Wsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXD1Wsy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXD1Wsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:48:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37636 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754326AbXD1Wsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:48:53 -0400
Date: Sun, 29 Apr 2007 00:49:04 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070428224904.GE3468@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070428202701.GA30343@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 09:27:01PM +0100, Russell King wrote:
> On Sat, Apr 28, 2007 at 09:53:20PM +0200, Adrian Bunk wrote:
> > We are already quite good at ignoring bug reports that come through 
> > linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
> > than 1600 open bugs because this tells how bad we are at handling bugs.
> > How many thousand bug reports have been ignored during the same time on 
> > linux-kernel?
> 
> However, look at this bug:
> 
>   http://bugme.osdl.org/show_bug.cgi?id=7760
> 
> It's outside my knowledge to be able to fix for various reasons:
>...
> I'm personally very tempted to close it as "won't fix" (I wish there was
> a "can't fix" category.)
>...

So this is a completely debugged bug in a well-maintained subsystem
(no matter what the status in Bugzilla is).

The problem is that the other 1600 open bugs aren't in this state.

> I'm no longer serial maintainer.  Bug IDs after about 7000 reflect bugs
> submitted since I've resigned my serial maintainership, and therefore
> I've ignored them.
>...

That's one of the problems: Unmaintained subsystems.

Since you stepped down as serial maintainer (and it's your right as 
maintainer to do so), the serial subsystem is unmaintained.

That's exactly where Linus' "drop any bug reports that are more than a 
week old" suggestion is completely flawed - no matter what the submitter 
does, how often he tests latest kernels, noone will help him.

> It's far easier to ignore bug reports in bugzilla
> than it is to get categories reassigned (to whom? - dunno) or even
> deleted (if no one steps up presumably that's what needs to happen?)
>...

New subsystems always get default owners like   	 
drivers_ieee1394@kernel-bugs.osdl.org, and people interested in such 
bugs can edit their preferences to watching all (pseudo) users in whose 
bugs they are interested. drivers_serial@kernel-bugs.osdl.org [1] would 
be the logical defult owner.

> Russell King

cu
Adrian

[1] or @linux-foundation.org

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

