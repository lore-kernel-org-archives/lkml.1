Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbYKLWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbYKLWu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYKLWuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:50:20 -0500
Received: from h155.mvista.com ([63.81.120.155]:4197 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752469AbYKLWuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:50:19 -0500
Message-ID: <491B5DA4.3020405@ru.mvista.com>
Date: Thu, 13 Nov 2008 01:50:12 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH 2/6] ide: remove chipset type fixup from ide_host_register()
References: <200811122215.15671.bzolnier@gmail.com>
In-Reply-To: <200811122215.15671.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Set chipset type explicitly in tx4938ide and tx4939ide host drivers
>   (all other host drivers were updated already).
>
> * Remove no longer used chipset type fixup from ide_host_register().
>
> CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
> Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   
[...]
> Index: b/drivers/ide/tx4938ide.c
> ===================================================================
> --- a/drivers/ide/tx4938ide.c
> +++ b/drivers/ide/tx4938ide.c
> @@ -226,6 +226,7 @@ static const struct ide_port_info tx4938
>  #endif
>  	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
>  	.pio_mask		= ATA_PIO5,
> +	.chipset		= ide_generic,
>  };
>  
>  static int __init tx4938ide_probe(struct platform_device *pdev)
> Index: b/drivers/ide/tx4939ide.c
> ===================================================================
> --- a/drivers/ide/tx4939ide.c
> +++ b/drivers/ide/tx4939ide.c
> @@ -644,6 +644,7 @@ static const struct ide_port_info tx4939
>  	.pio_mask		= ATA_PIO4,
>  	.mwdma_mask		= ATA_MWDMA2,
>  	.udma_mask		= ATA_UDMA5,
> +	.chipset		= ide_generic,
>   

   I'm not really sure those are "generic".

MBR, Sergei


