Return-Path: <linux-kernel-owner+w=401wt.eu-S1761320AbXETDET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761320AbXETDET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 23:04:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759043AbXETDEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 23:04:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59420 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755675AbXETDEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 23:04:07 -0400
Message-ID: <464FBA9C.9090208@garzik.org>
Date: Sat, 19 May 2007 23:03:56 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [SMP BUG]  [clockevents: i386 drivers patch]  introduces  irqbalance-does-not-work-properly
 problem
References: <1178202559.3767.21.camel@localhost.localdomain>	<20070504233238.ca55c2d1.komurojun-mbn@nifty.com>	<1178463619.3793.14.camel@localhost.localdomain>	<1178777214.2951.18.camel@ymzhang>	<20070510160615.6aa9cef6.akpm@linux-foundation.org>	<20070513200444.9d2db4c3.komurojun-mbn@nifty.com> <20070520111409.1793a2f6.komurojun-mbn@nifty.com>
In-Reply-To: <20070520111409.1793a2f6.komurojun-mbn@nifty.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Komuro wrote:
> [clockevents: i386 drivers patch] introduces
>   irqbalance-does-not-work-properly problem.
> 
>  
> (The irq is not distributed to two Core
>   ,most of the irq is distributed to CPU1)
>  
> 
>  Mr. Thomas Gleixner,
>  any idea to fix this problem?

Do you mean userspace irqbalance daemon?

It might need to be modified to work properly with a new and unusual 
event source.

Also, for some irq events, it may be good to send most interrupts to one 
core/CPU.  That enhances caching effects, among other benefits.  Again, 
this is highly dependent on the event source, I'm not saying that is the 
case here.

Regards,

	Jeff


