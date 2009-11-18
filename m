Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZKRRzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZKRRzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932144AbZKRRzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:55:21 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:45335 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbZKRRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:55:20 -0500
Date: Wed, 18 Nov 2009 11:55:23 -0600
From: Scott Wood <scottwood@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 06/13] powerpc: Fixup last users of irq_chip->typename
Message-ID: <20091118175523.GA12857@b07421-ec1.am.freescale.net>
References: <20091117224852.846805939@linutronix.de> <20091117224916.566205413@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117224916.566205413@linutronix.de>
User-Agent: Mutt/1.4.1i
X-Brightmail-Tracker: AAAAAQAAAWE=
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 10:50:53PM +0000, Thomas Gleixner wrote:
> Index: linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> +++ linux-2.6/arch/powerpc/platforms/82xx/pq2ads-pci-pic.c
> @@ -69,7 +69,7 @@ static void pq2ads_pci_unmask_irq(unsign
>  }
>  
>  static struct irq_chip pq2ads_pci_ic = {
> -	.typename = "PQ2 ADS PCI",
> +	.name = "PQ2 ADS PCI",
>  	.name = "PQ2 ADS PCI",
>  	.end = pq2ads_pci_unmask_irq,
>  	.mask = pq2ads_pci_mask_irq,

Duplicate ".name"...

-Scott
