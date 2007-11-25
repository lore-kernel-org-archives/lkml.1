Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbXKYRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbXKYRWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 12:22:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKYRWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 12:22:42 -0500
Received: from brick.kernel.dk ([87.55.233.238]:1604 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbXKYRWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:22:41 -0500
Date: Sun, 25 Nov 2007 18:22:37 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071125172237.GC6658@kernel.dk>
References: <20071125161801.GB21947@stusta.de> <20071125162105.GA6658@kernel.dk> <20071125163153.GD21947@stusta.de> <20071125164532.GB6658@kernel.dk> <20071125165654.GE21947@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071125165654.GE21947@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25 2007, Adrian Bunk wrote:
> On Sun, Nov 25, 2007 at 05:45:32PM +0100, Jens Axboe wrote:
> > On Sun, Nov 25 2007, Adrian Bunk wrote:
> > > On Sun, Nov 25, 2007 at 05:21:07PM +0100, Jens Axboe wrote:
> > > > On Sun, Nov 25 2007, Adrian Bunk wrote:
> > > > > There isn't any big advantage and doesn't seem to be much usage of 
> > > > > modular schedulers.
> > > > > 
> > > > > OTOH, the overhead made the kernel image of an x86 defconfig (that 
> > > > > doesn't use modular schedulers) bigger by nearly 2 kB.
> > > > 
> > > > Big nack, I use it all the time for testing.
> > > 
> > > OK.
> > > 
> > > > Just because you don't
> > > > happen to use it is not a reason to remove it.
> > > 
> > > s/you/you and all distributions you checked/
> > 
> > Well they should make them modules (two of them, that is).
> >...
> 
> Is there any technical reason why we need 4 different schedulers at all?

Until we have the perfect scheduler :-)

With some hard work and testing, we should be able to get rid of 'as'.
It still beats cfq for some of the workloads that deadline is good at,
so not quite yet.

> I have the gut feeling that the usual thing happens and people e.g. not 
> report some cfq problems because as works for them...

There's always a risk with "duplicate", like several drivers for the
same hardware. I'm not disputing that.

-- 
Jens Axboe

