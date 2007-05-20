Return-Path: <linux-kernel-owner+w=401wt.eu-S1764824AbXETKnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764824AbXETKnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbXETKmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:42:54 -0400
Received: from userg501.nifty.com ([202.248.238.81]:57334 "EHLO
	userg501.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757093AbXETKmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:42:53 -0400
DomainKey-Signature: a=rsa-sha1; s=userg501; d=nifty.com; c=nofws; q=dns;
	b=gLAjjuizF5t5Qqiki68314LyTYfO68jcuw6bBdxK9UHky2ClhDgOXSXxjWOPBDZQb
	zUmc4ZQSDjitS2zTBEMew==
Date: Sun, 20 May 2007 19:42:33 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [SMP BUG]  [clockevents: i386 drivers patch]  introduces 
 irqbalance-does-not-work-properly problem
Message-Id: <20070520194233.27012723.komurojun-mbn@nifty.com>
In-Reply-To: <464FBA9C.9090208@garzik.org>
References: <1178202559.3767.21.camel@localhost.localdomain>
	<20070504233238.ca55c2d1.komurojun-mbn@nifty.com>
	<1178463619.3793.14.camel@localhost.localdomain>
	<1178777214.2951.18.camel@ymzhang>
	<20070510160615.6aa9cef6.akpm@linux-foundation.org>
	<20070513200444.9d2db4c3.komurojun-mbn@nifty.com>
	<20070520111409.1793a2f6.komurojun-mbn@nifty.com>
	<464FBA9C.9090208@garzik.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 23:03:56 -0400
Jeff Garzik <jeff@garzik.org> wrote:


> Do you mean userspace irqbalance daemon?

Yes. I mean userspace irqbalance daemon.


Best Regards
Komuro

> Komuro wrote:
> > [clockevents: i386 drivers patch] introduces
> >   irqbalance-does-not-work-properly problem.
> > 
> >  
> > (The irq is not distributed to two Core
> >   ,most of the irq is distributed to CPU1)
> >  
> > 
> >  Mr. Thomas Gleixner,
> >  any idea to fix this problem?
> 
> Do you mean userspace irqbalance daemon?
> 
> It might need to be modified to work properly with a new and unusual 
> event source.
> 
> Also, for some irq events, it may be good to send most interrupts to one 
> core/CPU.  That enhances caching effects, among other benefits.  Again, 
> this is highly dependent on the event source, I'm not saying that is the 
> case here.
> 
> Regards,
> 
> 	Jeff
> 
> 
