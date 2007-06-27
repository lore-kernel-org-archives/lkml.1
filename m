Return-Path: <linux-kernel-owner+w=401wt.eu-S1761207AbXF0GpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207AbXF0GpX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbXF0GpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:45:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37932 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbXF0GpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:45:04 -0400
Message-ID: <4682076D.2080104@garzik.org>
Date: Wed, 27 Jun 2007 02:45:01 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HPT374 is UDMA100 not UDMA133
References: <20070622141728.34b1b91c@the-village.bc.nu>
In-Reply-To: <20070622141728.34b1b91c@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Propogate change from drivers/ide
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c linux-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c
> --- linux.vanilla-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c	2007-06-07 14:26:08.000000000 +0100
> +++ linux-2.6.22-rc4-mm2/drivers/ata/pata_hpt37x.c	2007-06-14 12:58:22.000000000 +0100
> @@ -931,13 +931,13 @@
>  		.udma_mask = 0x7f,
>  		.port_ops = &hpt372_port_ops
>  	};
> -	/* HPT374 - UDMA133 */
> +	/* HPT374 - UDMA100 */
>  	static const struct ata_port_info info_hpt374 = {
>  		.sht = &hpt37x_sht,
>  		.flags = ATA_FLAG_SLAVE_POSS,
>  		.pio_mask = 0x1f,
>  		.mwdma_mask = 0x07,
> -		.udma_mask = 0x7f,
> +		.udma_mask = 0x3f,

applied manually, since this does not apply to any upstream tree. 
Please diff against upstream or libata-dev.git...


