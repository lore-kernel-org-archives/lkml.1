Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXJ1RP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXJ1RP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbXJ1RPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:15:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:45267 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755757AbXJ1RPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:15:48 -0400
Date: Sun, 28 Oct 2007 09:51:42 -0700
From: Greg KH <gregkh@suse.de>
To: Barak Fargoun <barak@neocleus.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH] Align PCI memory regions to page size (4K)
Message-ID: <20071028165142.GA11785@suse.de>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96EFC@mse10be1.mse10.exchange.ms>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9392A06CB0FDC847B3A530B3DC174E7B03C96EFC@mse10be1.mse10.exchange.ms>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 11:00:38AM -0400, Barak Fargoun wrote:
> Add a boot parameter ('pci-mem-align') which forces PCI memory regions
> to be aligned to 4K. 
> 
>  
> 
> This is very useful when developing an hypervisor, since in case we want
> to let native domains direct access to specific hardware, we don't want
> PCI devices to share their memory region page with other devices. In Xen
> for example, PCI devices mmio resources are mapped by remapping complete
> pages (by Intel VT-d & the Neocleus pass-through patch for Xen).
> 
>  
> 
> Signed-off-by: Barak Fargoun     (barak@neocleus.com)
> 
> ---
> 
> Kernel version: 2.6.18

Patches against year old kernel versions usually do not work :)


> 
> ---
> 
> diff -r 840b9df48b6a drivers/pci/bus.c
> 
> --- a/drivers/pci/bus.c   Tue Aug 07 09:37:41 2007 +0100
> 
> +++ b/drivers/pci/bus.c                Sun Oct 28 08:40:52 2007 -0400
> 
> @@ -16,6 +16,8 @@
> 
>  #include <linux/init.h>
> 
>  
> 
>  #include "pci.h"
> 
> +

Your patch is majorly corrupted by your email client.  Can you please
fix this and try again?

thanks,

greg k-h
