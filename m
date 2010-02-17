Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab0BRARL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:17:11 -0500
Received: from kroah.org ([198.145.64.141]:49902 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752832Ab0BRAQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:16:17 -0500
Date: Wed, 17 Feb 2010 15:35:47 -0800
From: Greg KH <greg@kroah.com>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Manuel Traut <manut@linutronix.de>
Subject: Re: [PATCH] UIO: Add a driver for Hilscher netX-based fieldbus
 cards
Message-ID: <20100217233547.GD12197@kroah.com>
References: <20100209191349.GE3229@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209191349.GE3229@local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- linux-2.6.33-rc.orig/include/linux/pci_ids.h	2010-02-09 12:43:51.000000000 +0100
> +++ linux-2.6.33-rc/include/linux/pci_ids.h	2010-02-09 12:44:51.000000000 +0100
> @@ -137,6 +137,11 @@
>  
>  /* Vendors and devices.  Sort key: vendor first, device next. */
>  
> +#define PCI_VENDOR_ID_HILSCHER		0x15CF
> +#define PCI_DEVICE_ID_HILSCHER_NETX	0x0000
> +#define PCI_SUBDEVICE_ID_NXSB_PCA	0x3235
> +#define PCI_SUBDEVICE_ID_NXPCA		0x3335

This isn't needed, we don't add new device ids to the file, unless they
are used by more than one driver (see the comment at the top of the
file.)

I've fixed up the patch to not include this anymore.

thanks,

greg k-h
