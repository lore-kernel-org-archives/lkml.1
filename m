Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbXB0KVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbXB0KVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932942AbXB0KVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:21:24 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58100 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932862AbXB0KVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:21:23 -0500
Date: Tue, 27 Feb 2007 11:21:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070227102109.GG6745@elf.ucw.cz>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227100202.GV3822@kernel.dk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This email lists some known regressions in 2.6.21-rc1 compared to 2.6.20
> > that are not yet fixed in Linus' tree.
> > 
> > If you find your name in the Cc header, you are either submitter of one
> > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > of you caused a breakage or I'm considering you in any other way possibly
> > involved with one or more of these issues.
> > 
> > Due to the huge amount of recipients, please trim the Cc when answering.
> > 
> > 
> > Subject    : ThinkPad T60: system doesn't come out of suspend to RAM
> >              (CONFIG_NO_HZ)
> > References : http://lkml.org/lkml/2007/2/22/391
> > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> >              Thomas Gleixner <tglx@linutronix.de>
> > Handled-By : Ingo Molnar <mingo@elte.hu>
> > Status     : unknown
> 
> x60 doesn't resume from S2R either, it doesn't matter if CONFIG_NO_HZ is
> set or not though. 2.6.20 worked fine.

It somehow works for me. As long as I do not play with bluetooth and
suspend to disk...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
