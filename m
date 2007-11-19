Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXKSQ7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXKSQ7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 11:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXKSQ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 11:58:58 -0500
Received: from hu-out-0506.google.com ([72.14.214.228]:18403 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbXKSQ66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 11:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ZdFyoKOZjS4evimsHcsRkSP89meiGT1pYrvdRIopbaWCAolJv20/UVMsFzhzqDBURkp4LHglj8X3x2zt+WJPI7HZFtf32c5JhZ9tvA19H0s6EZDszLs5xy2EKw8vXxEz4dpk0vhYi5Rt3HszgPV2TOUt7xKMw5VnGpkKZoWqm6c=
Date: Mon, 19 Nov 2007 10:58:48 -0600
From: Josh Boyer <jwboyer@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250_gsc: Coding style
Message-ID: <20071119105848.51a20901@weaponx>
In-Reply-To: <20071119150751.60c2df48@the-village.bc.nu>
References: <20071119150751.60c2df48@the-village.bc.nu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; powerpc-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 15:07:51 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

You forgot the Signed-off-by line.

josh

> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c linux-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c
> --- linux.vanilla-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c	2007-11-16 17:20:48.000000000 +0000
> +++ linux-2.6.24-rc2-mm1/drivers/serial/8250_gsc.c	2007-11-16 18:35:39.000000000 +0000
> @@ -25,8 +25,7 @@
>  
>  #include "8250.h"
>  
> -static int __init 
> -serial_init_chip(struct parisc_device *dev)
> +static int __init serial_init_chip(struct parisc_device *dev)
>  {
>  	struct uart_port port;
>  	unsigned long address;
> @@ -38,18 +37,17 @@
>  		 * what we have here is a missing parent device, so tell
>  		 * the user what they're missing.
>  		 */
> -		if (parisc_parent(dev)->id.hw_type != HPHW_IOA) {
> -			printk(KERN_INFO "Serial: device 0x%lx not configured.\n"
> +		if (parisc_parent(dev)->id.hw_type != HPHW_IOA)
> +			printk(KERN_INFO
> +				"Serial: device 0x%lx not configured.\n"
>  				"Enable support for Wax, Lasi, Asp or Dino.\n",
>  				dev->hpa.start);
> -		}
>  		return -ENODEV;
>  	}
>  
>  	address = dev->hpa.start;
> -	if (dev->id.sversion != 0x8d) {
> +	if (dev->id.sversion != 0x8d)
>  		address += 0x800;
> -	}
>  
>  	memset(&port, 0, sizeof(port));
>  	port.iotype	= UPIO_MEM;
> @@ -63,11 +61,12 @@
>  
>  	err = serial8250_register_port(&port);
>  	if (err < 0) {
> -		printk(KERN_WARNING "serial8250_register_port returned error %d\n", err);
> +		printk(KERN_WARNING
> +			"serial8250_register_port returned error %d\n", err);
>  		iounmap(port.membase);
>  		return err;
>  	}
> -        
> +
>  	return 0;
>  }
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
