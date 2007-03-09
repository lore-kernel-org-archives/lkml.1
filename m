Return-Path: <linux-kernel-owner+w=401wt.eu-S2993008AbXCIGoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993008AbXCIGoy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:44:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993014AbXCIGoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:44:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39739 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2993008AbXCIGow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:44:52 -0500
Date: Fri, 9 Mar 2007 07:44:40 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>
Cc: Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-pm@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [linux-pm] 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070309064440.GD1983@elf.ucw.cz>
References: <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227102109.GG6745@elf.ucw.cz> <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu> <20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk> <20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz> <20070305084257.GA4464@mellanox.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305084257.GA4464@mellanox.co.il>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Pavel, I tried with your .config, and indeed the system came back to life after
> 2-3 minutes after I press Fn/F4, indeed the issue seems to be with the disk.
> It could be that the same takes place with my original .config - maybe
> I just wasn't patient enough. I'll need to re-test that.
> 
> However, I noticed that, after resume, when the system is presumably functional,
> if I try to suspend to ram again, this second suspend hangs, displaying
> the following on screen:
> 
> [   17.170000] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
> [   17.170000] PCI: Setting latency timer of device 0000:02:00.0 to 64
> [   17.250000] e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:41:5
> 4:6c:47
> [   17.330000] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
> 
> the crescent LED starts blinking and does not seem to stop for at lest 10 min,
> I've run out of patience after that. It could be that it's just very slow again.
> 
> Pavel, did you try suspend to RAM after a successfull resume from
> RAM?

Seems to work ok in -rc3... as long as I do not mix s2ram with s2disk.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
