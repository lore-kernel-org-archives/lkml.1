Return-Path: <linux-kernel-owner+w=401wt.eu-S1751526AbXB0KIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526AbXB0KIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 05:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXB0KIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 05:08:24 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:25742 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbXB0KIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 05:08:23 -0500
Date: Tue, 27 Feb 2007 11:02:02 +0100
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
Message-ID: <20070227100202.GV3822@kernel.dk>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <20070225175559.GC12392@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070225175559.GC12392@stusta.de>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25 2007, Adrian Bunk wrote:
> This email lists some known regressions in 2.6.21-rc1 compared to 2.6.20
> that are not yet fixed in Linus' tree.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way possibly
> involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
> 
> 
> Subject    : ThinkPad T60: system doesn't come out of suspend to RAM
>              (CONFIG_NO_HZ)
> References : http://lkml.org/lkml/2007/2/22/391
> Submitter  : Michael S. Tsirkin <mst@mellanox.co.il>
>              Thomas Gleixner <tglx@linutronix.de>
> Handled-By : Ingo Molnar <mingo@elte.hu>
> Status     : unknown

x60 doesn't resume from S2R either, it doesn't matter if CONFIG_NO_HZ is
set or not though. 2.6.20 worked fine.

-- 
Jens Axboe

