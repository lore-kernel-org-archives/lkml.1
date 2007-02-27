Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbXB0WJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbXB0WJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 17:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbXB0WJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 17:09:47 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:46244 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751878AbXB0WJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 17:09:46 -0500
Date: Tue, 27 Feb 2007 23:09:44 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       pavel@suse.cz, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070227220943.GP29575@stusta.de>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070227100202.GV3822@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27, 2007 at 11:02:02AM +0100, Jens Axboe wrote:
> On Sun, Feb 25 2007, Adrian Bunk wrote:
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

Is this

Subject    : ThinkPad T60: no screen after suspend to RAM
References : http://lkml.org/lkml/2007/2/22/391
Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
             Ingo Molnar <mingo@elte.hu>
Handled-By : Ingo Molnar <mingo@elte.hu>
Status     : unknown

or doesn't it resume at all?

> Jens Axboe

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

