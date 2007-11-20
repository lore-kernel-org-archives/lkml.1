Return-Path: <linux-kernel-owner+w=401wt.eu-S1759999AbXKTMeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759999AbXKTMeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757248AbXKTMeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:34:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36487 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756306AbXKTMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:34:13 -0500
Date: Tue, 20 Nov 2007 12:32:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: trenn@suse.de
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "yakui.zhao" <yakui.zhao@intel.com>,
       Rene Herman <rene.herman@keyaccess.nl>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] PNP cleanups - Make use of
 pnp_{port,mem,irq,dma}_{start,end,flags} macros wherever possible
Message-ID: <20071120123213.0744adc3@the-village.bc.nu>
In-Reply-To: <1195552273.23700.164.camel@queen.suse.de>
References: <1195552273.23700.164.camel@queen.suse.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  #define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
> +#define pnp_irq_start(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
> +#define pnp_irq_end(dev,bar)	 ((dev)->res.irq_resource[(bar)].end)

NAK as discussed earlier.

>  #define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
>  #define pnp_irq_valid(dev,bar) \
>  	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
>  		== IORESOURCE_IRQ)
>  
>  #define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
> +#define pnp_dma_start(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
> +#define pnp_dma_end(dev,bar)	 ((dev)->res.dma_resource[(bar)].end)

Ditto DMA is not range based.
