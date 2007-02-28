Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbXB1IHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbXB1IHg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 03:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXB1IHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 03:07:36 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:41756 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbXB1IHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 03:07:35 -0500
Date: Wed, 28 Feb 2007 08:41:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       pavel@suse.cz, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: 2.6.21-rc1: known regressions (part 2)
Message-ID: <20070228074127.GL3733@kernel.dk>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de> <20070227100202.GV3822@kernel.dk> <20070227220943.GP29575@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070227220943.GP29575@stusta.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 27 2007, Adrian Bunk wrote:
> On Tue, Feb 27, 2007 at 11:02:02AM +0100, Jens Axboe wrote:
> > On Sun, Feb 25 2007, Adrian Bunk wrote:
> > > This email lists some known regressions in 2.6.21-rc1 compared to 2.6.20
> > > that are not yet fixed in Linus' tree.
> > > 
> > > If you find your name in the Cc header, you are either submitter of one
> > > of the bugs, maintainer of an affectected subsystem or driver, a patch
> > > of you caused a breakage or I'm considering you in any other way possibly
> > > involved with one or more of these issues.
> > > 
> > > Due to the huge amount of recipients, please trim the Cc when answering.
> > > 
> > > 
> > > Subject    : ThinkPad T60: system doesn't come out of suspend to RAM
> > >              (CONFIG_NO_HZ)
> > > References : http://lkml.org/lkml/2007/2/22/391
> > > Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
> > >              Thomas Gleixner <tglx@linutronix.de>
> > > Handled-By : Ingo Molnar <mingo@elte.hu>
> > > Status     : unknown
> > 
> > x60 doesn't resume from S2R either, it doesn't matter if CONFIG_NO_HZ is
> > set or not though. 2.6.20 worked fine.
> 
> Is this
> 
> Subject    : ThinkPad T60: no screen after suspend to RAM
> References : http://lkml.org/lkml/2007/2/22/391
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
>              Ingo Molnar <mingo@elte.hu>
> Handled-By : Ingo Molnar <mingo@elte.hu>
> Status     : unknown
> 
> or doesn't it resume at all?

It doesn't resume at all.

-- 
Jens Axboe

