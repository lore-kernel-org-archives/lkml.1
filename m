Return-Path: <linux-kernel-owner+w=401wt.eu-S1764543AbXETHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764543AbXETHDT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbXETHDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 03:03:12 -0400
Received: from www.osadl.org ([213.239.205.134]:42012 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758787AbXETHDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 03:03:12 -0400
Subject: Re: [SMP BUG]  [clockevents: i386 drivers patch]  introduces 
	irqbalance-does-not-work-properly problem
From: Thomas Gleixner <tglx@linutronix.de>
To: Komuro <komurojun-mbn@nifty.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <20070520111409.1793a2f6.komurojun-mbn@nifty.com>
References: <1178202559.3767.21.camel@localhost.localdomain>
	 <20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	 <1178463619.3793.14.camel@localhost.localdomain>
	 <1178777214.2951.18.camel@ymzhang>
	 <20070510160615.6aa9cef6.akpm@linux-foundation.org>
	 <20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
	 <20070520111409.1793a2f6.komurojun-mbn@nifty.com>
Content-Type: text/plain
Date: Sun, 20 May 2007 09:09:16 +0200
Message-Id: <1179644956.21827.5.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-20 at 11:14 +0900, Komuro wrote:
> Hi,
> 
> 
> [clockevents: i386 drivers patch] introduces
>   irqbalance-does-not-work-properly problem.

it disables irq balancing for IRQ0, but this does not affect any other
interrupts. It is almost irrelevant as the PIT/HPET timer interrupt
(irq0) is disabled anyway and the local apic timer is used.

> >            CPU0       CPU1       
> >   0:         85          0   IO-APIC-edge      timer

There is no interrupt happening after bootup, so balancing is not a
problem here.

> Mr. Thomas Gleixner,
>  any idea to fix this problem?

Which problem ?

	tglx


