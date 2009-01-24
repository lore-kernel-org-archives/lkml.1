Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZAXOvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZAXOvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZAXOvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:51:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58095 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbZAXOvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:51:05 -0500
Date: Sat, 24 Jan 2009 14:50:51 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] icside: use struct ide_port_info also for PCB version 5
Message-ID: <20090124145051.GA26833@flint.arm.linux.org.uk>
References: <200901241514.23036.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901241514.23036.bzolnier@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2009 at 03:14:22PM +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] icside: use struct ide_port_info also for PCB version 5
> 
> This fixes hwif->channel and drive->dn assignments.

I really don't care about this driver anymore - people should
be using the PATA version instead.

Nevertheless, this patch looks broken.

> @@ -534,7 +538,7 @@ icside_register_v6(struct icside_state *
                      ^^^^^^^^^^^^^^^^^^ v6 function

>  		d.dma_ops = NULL;
>  	}
>  
> -	ret = ide_host_register(host, NULL, hws);
> +	ret = ide_host_register(host, &icside_v5_port_info, hws);
                                      ^^^^^^^^^^^^^^^^^^^^^ v5 info

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
