Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbYIVUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbYIVUJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYIVUI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:08:56 -0400
Received: from www.tglx.de ([62.245.132.106]:44587 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYIVUIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:08:55 -0400
Date: Mon, 22 Sep 2008 22:08:36 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Magnus Damm <damm@igel.co.jp>
Subject: Re: [PATCH] UIO: Resend: Change driver name of uio_pdrv
Message-ID: <20080922200836.GB2985@local>
References: <20080918210306.GC2991@local> <20080919074034.GA8945@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080919074034.GA8945@strlen.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 09:40:34AM +0200, Uwe Kleine-König wrote:
> Hello Hans,
> 
> [Added Magnus Damm (= author of uio_pdrv_genirq) to Cc:]
> 
> On Thu, Sep 18, 2008 at 11:03:07PM +0200, Hans J. Koch wrote:
> > The patch below was already discussed and accepted:
> > http://lkml.org/lkml/2008/7/7/409
> > 
> > It somehow got lost (probably because I forgot it when I sent my queue
> > to Greg...). So, here it is again:
> > 
> > -------------8<------------------------
> > 
> > The generic UIO platform device driver should be given a unique driver ID and
> > not just "uio". This is especially important since we now have a similar driver
> > named uio_pdrv_genirq. Currently, there's no user of this driver in the
> > mainline kernel.
> I want to suggest to rename uio_pdrv_genirq to uio_genirq instead.  In
> my eyes this would be more clear.  IMHO the pdrv suffix doesn't yield
> more clearity because it is only used in a certain namespace---namely
> that of platform devices.  So e.g.
> 
> 	/sys/bus/platform/devices/uio_pdrv.0
> 
> isn't any better than
> 
> 	/sys/bus/platform/devices/uio.0

Well, I just want to avoid using the generic "uio" identifier for a
single driver. A sysfs entry like this last one looks like a kind of
"standard way" how a UIO platform device driver should be done. I'd like
to avoid that impression. It can be "uio_pdrv" or "uio_pdrv_genirq", but
there's no standard "uio" way of handling platform devices.

> 
> .  Looking at the name of other platform drivers using
> 
> 	git grep -E '_pdrv(_.*)?"' 
> 
> I get three false positives[1] and uio_pdrv_genirq (driver and some
> users in arch/sh/kernel/cpu/sh4a/setup-sh7343.c).  So the _pdrv suffix
> doesn't seem very common.

I don't really understand what you mean here.

> 
> Just my 0.02€

Thanks,
Hans

