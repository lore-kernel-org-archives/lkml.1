Return-Path: <linux-kernel-owner+w=401wt.eu-S1762161AbXFJRhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762161AbXFJRhD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbXFJRgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:36:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47283 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753924AbXFJRgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:36:53 -0400
Date: Sun, 10 Jun 2007 18:42:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] pata_it821x: (partially) fix DMA in RAID mode
Message-ID: <20070610184208.2224e023@the-village.bc.nu>
In-Reply-To: <200706101843.20947.bzolnier@gmail.com>
References: <200706101843.20947.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Tejun Heo <htejun@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


Acked-by: Alan Cox <alan@redhat.com>


> -	/* Bits 5 and 6 indicate if DMA is active on master/slave */
> -	/* It is possible that BMDMA isn't allocated */
> -	if (ap->ioaddr.bmdma_addr)
> -		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
> -
>  	for (i = 0; i < ATA_MAX_DEVICES; i++) {
