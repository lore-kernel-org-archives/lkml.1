Return-Path: <linux-kernel-owner+w=401wt.eu-S1754381AbYIVUi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381AbYIVUi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752162AbYIVUiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:38:51 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58232 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbYIVUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:38:51 -0400
Date: Mon, 22 Sep 2008 22:38:49 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@strlen.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] UIO: Resend: Change driver name of uio_pdrv
Message-ID: <20080922203849.GC792@strlen.de>
References: <20080918210306.GC2991@local> <20080919074034.GA8945@strlen.de> <20080922200836.GB2985@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080922200836.GB2985@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 22, 2008 at 10:08:36PM +0200, Hans J. Koch wrote:
> On Fri, Sep 19, 2008 at 09:40:34AM +0200, Uwe Kleine-König wrote:
> > Hello Hans,
> > 
> > [Added Magnus Damm (= author of uio_pdrv_genirq) to Cc:]
Note:  Magnus' address seems to be wrong.  I don't know a working one.

> > > The generic UIO platform device driver should be given a unique driver ID and
> > > not just "uio". This is especially important since we now have a similar driver
> > > named uio_pdrv_genirq. Currently, there's no user of this driver in the
> > > mainline kernel.
> > I want to suggest to rename uio_pdrv_genirq to uio_genirq instead.  In
> > my eyes this would be more clear.  IMHO the pdrv suffix doesn't yield
> > more clearity because it is only used in a certain namespace---namely
> > that of platform devices.  So e.g.
> > 
> > 	/sys/bus/platform/devices/uio_pdrv.0
> > 
> > isn't any better than
> > 
> > 	/sys/bus/platform/devices/uio.0
> 
> Well, I just want to avoid using the generic "uio" identifier for a
> single driver. A sysfs entry like this last one looks like a kind of
> "standard way" how a UIO platform device driver should be done.
I wonder that you don't have this impression with "uio_pdrv".

>                                                                 I'd like
> to avoid that impression. It can be "uio_pdrv" or "uio_pdrv_genirq", but
> there's no standard "uio" way of handling platform devices.
I thought the driver in discussion is kind of a standard way to create a
platform driver using uio.
(At least you called it "generic UIO platform device driver" above :-)

> > 
> > .  Looking at the name of other platform drivers using
> > 
> > 	git grep -E '_pdrv(_.*)?"' 
> > 
> > I get three false positives[1] and uio_pdrv_genirq (driver and some
> > users in arch/sh/kernel/cpu/sh4a/setup-sh7343.c).  So the _pdrv suffix
> > doesn't seem very common.
> 
> I don't really understand what you mean here.
I tried to point out that uio_pdrv_genirq is (probably) the only
platform driver that has _pdrv in its name.

Best regards
Uwe
