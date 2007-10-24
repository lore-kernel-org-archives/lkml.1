Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXJXJYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXJXJYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXJXJY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:24:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:54384 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbXJXJY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:24:27 -0400
Message-ID: <471F0F44.4010102@garzik.org>
Date: Wed, 24 Oct 2007 05:24:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, shannon.nelson@intel.com,
       anil.s.keshavamurthy@intel.com
Subject: Re: [PATCH] Remove bogus default y for DMAR and NET_DMA
References: <200710241112.39451.ak@suse.de>
In-Reply-To: <200710241112.39451.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Index: linux-2.6.24-rc1-hack/arch/x86_64/Kconfig
> ===================================================================
> --- linux-2.6.24-rc1-hack.orig/arch/x86_64/Kconfig
> +++ linux-2.6.24-rc1-hack/arch/x86_64/Kconfig
> @@ -753,7 +753,6 @@ config PCI_DOMAINS
>  config DMAR
>  	bool "Support for DMA Remapping Devices (EXPERIMENTAL)"
>  	depends on PCI_MSI && ACPI && EXPERIMENTAL
> -	default y
>  	help
>  	  DMA remapping (DMAR) devices support enables independent address
>  	  translations for Direct Memory Access (DMA) from devices.

ACK


> Index: linux-2.6.24-rc1-hack/drivers/dma/Kconfig
> ===================================================================
> --- linux-2.6.24-rc1-hack.orig/drivers/dma/Kconfig
> +++ linux-2.6.24-rc1-hack/drivers/dma/Kconfig
> @@ -43,7 +43,6 @@ comment "DMA Clients"
>  config NET_DMA
>  	bool "Network: TCP receive copy offload"
>  	depends on DMA_ENGINE && NET
> -	default y
>  	help
>  	  This enables the use of DMA engines in the network stack to
>  	  offload receive copy-to-user operations, freeing CPU cycles.

ACK -- but its arguable that given the current code, its worth setting 
this if DMA_ENGINE is also set.

