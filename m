Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbZDBQVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbZDBQVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759532AbZDBQVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:21:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:41369 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753865AbZDBQVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:21:07 -0400
Subject: Re: [tip:irq/genirq] genirq: do not execute DEBUG_SHIRQ when irq
 setup failed
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       henrix@sapo.pt, linux-tip-commits@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0904021753020.12916@localhost.localdomain>
References: <20090401170635.GA4392@hades.domain.com>
	 <tip-ba71604fad348656071a2a76eef9a67dab85a773@git.kernel.org>
	 <1238682747.3099.16.camel@ht.satnam>
	 <alpine.LFD.2.00.0904021718230.12916@localhost.localdomain>
	 <1238686904.3099.22.camel@ht.satnam>
	 <alpine.LFD.2.00.0904021753020.12916@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 21:50:16 +0530
Message-Id: <1238689216.3099.34.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 18:08 +0200, Thomas Gleixner wrote:
> On Thu, 2 Apr 2009, Jaswinder Singh Rajput wrote:
> > > > >  #ifdef CONFIG_DEBUG_SHIRQ
> > > > > -	if (irqflags & IRQF_SHARED) {
> > > > > +	if (!retval & (irqflags & IRQF_SHARED)) {
> > > > >  		/*
> > > > >  		 * It's a shared IRQ -- the driver ought to be prepared for it
> > > > >  		 * to happen immediately, so let's make sure....
> > > > 
> > > > What is this ?
> > > 
> > > You looking at the wrong place.
> > >  
> > > > There is no retval:
> > > > 
> > > > http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=kernel/irq/manage.c;h=a3eb7baf1e46f2c735edb4cc44e0386cfbc4989e;hb=HEAD
> > > 
> > > Care to read patches you want to comment on carefully _BEFORE_ you
> > > start yelling at people and sending useless copies of the wrong
> > > function around the world.
> > > 
> > > The patch is perfectly fine and already applied.
> > > 
> > 
> > Yes, I know somehow you applied it. When you will merge this branch with
> > -tip/master then you will understand what I am saying.
> 
> Jaswinder. I really start to get annoyed. 
> 
> That patch applies fine on master as well.
>  
> > Even function name is changed from:
> >
> > 713 int request_irq(unsigned int irq, irq_handler_t handler,
> > 
> > 857 int request_threaded_irq(unsigned int irq, irq_handler_t handler,
> 
> And why is this fcking relevant ? 
> 

I am dead sure, you really need some good manners and need to learn many
things.

> Take the patch and try to apply it. It applies perfectly fine on
> tip/master. And it is still _CORRECT_ there.
> 
> If you don't know how to read a patch and don't know the code it
> applies to then taking it and applying it is the minimum you could do
> before wasting everybodys time.
> 
> Stop this nonsense before I get really grumpy,
> 

That's the only thing you can do.

--
JSR

