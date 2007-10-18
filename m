Return-Path: <linux-kernel-owner+w=401wt.eu-S934154AbXJSANU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934154AbXJSANU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 20:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754432AbXJSANM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 20:13:12 -0400
Received: from smtp20.orange.fr ([80.12.242.27]:23620 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbXJSANL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 20:13:11 -0400
X-Greylist: delayed 1838 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 20:13:11 EDT
X-ME-UUID: 20071018234228809.C58FF1C0008A@mwinf2011.orange.fr
Date: Fri, 19 Oct 2007 01:42:28 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Paul Sokolovsky <pmiscml@gmail.com>, Ben Dooks <ben@trinity.fluff.org>
Subject: Re: [RFC] [PATCH -mm] ASIC3 driver
Message-ID: <20071018234227.GB19183@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20071018091239.GA11360@caravaggio> <20071018150544.6852d5c9.akpm@linux-foundation.org> <alpine.LFD.0.9999.0710190013420.22770@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0710190013420.22770@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2007 at 12:15:47AM +0200, Thomas Gleixner wrote:
> On Thu, 18 Oct 2007, Andrew Morton wrote:
> > > +
> > > +#include <linux/module.h>
> > > +#include <linux/version.h>
> > > +#include <linux/irq.h>
> > 
> > Please see the large comment at the top of linux/irq.h.  I believe this
> > driver will fial to compile on at least arm.
> > 
> > We really should fix this.
> 
> drivers are fine with: #include <linux/interrupt.h>
> 
> If they need linux/irq.h, then they do probably something really
> nasty.
The asic3 adds irqs to a board, through GPIOs. Is that a valid case ?

Cheers,
Samuel.

 
>    	tglx

