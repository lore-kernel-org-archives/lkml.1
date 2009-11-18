Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbZKRUld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbZKRUld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 15:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZKRUld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 15:41:33 -0500
Received: from www.tglx.de ([62.245.132.106]:35081 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465AbZKRUlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 15:41:32 -0500
Date: Wed, 18 Nov 2009 21:41:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Scott Wood <scottwood@freescale.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 06/13] powerpc: Fixup last users of irq_chip->typename
In-Reply-To: <20091118175523.GA12857@b07421-ec1.am.freescale.net>
Message-ID: <alpine.LFD.2.00.0911182141060.24119@localhost.localdomain>
References: <20091117224852.846805939@linutronix.de> <20091117224916.566205413@linutronix.de> <20091118175523.GA12857@b07421-ec1.am.freescale.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009, Scott Wood wrote:
> On Tue, Nov 17, 2009 at 10:50:53PM +0000, Thomas Gleixner wrote:
> > Index: linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> > ===================================================================
> > --- linux-2.6.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> > +++ linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> > @@ -69,7 +69,7 @@ static void pq2ads_pci_unmask_irq(unsign
> >  }
> >  
> >  static struct irq_chip pq2ads_pci_ic = {
> > -	.typename = "PQ2 ADS PCI",
> > +	.name = "PQ2 ADS PCI",
> >  	.name = "PQ2 ADS PCI",
> >  	.end = pq2ads_pci_unmask_irq,
> >  	.mask = pq2ads_pci_mask_irq,
> 
> Duplicate ".name"...

Darn.
