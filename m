Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbXGCOKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbXGCOKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXGCOK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:10:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60263 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758390AbXGCOK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:10:28 -0400
Message-ID: <468A58D1.4070802@garzik.org>
Date: Tue, 03 Jul 2007 10:10:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Check the right register for the DMA enabled flags
References: <20070703151130.513fe2df@the-village.bc.nu>
In-Reply-To: <20070703151130.513fe2df@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Mirrors change in IT821X
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/ata_generic.c linux-2.6.22-rc6-mm1/drivers/ata/ata_generic.c
> --- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/ata_generic.c	2007-07-02 20:50:11.000000000 +0100
> +++ linux-2.6.22-rc6-mm1/drivers/ata/ata_generic.c	2007-07-02 21:02:10.000000000 +0100
> @@ -50,7 +50,7 @@
>  
>  	/* Bits 5 and 6 indicate if DMA is active on master/slave */
>  	if (ap->ioaddr.bmdma_addr)
> -		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
> +		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);

applied

Please put driver or subsystem name in subject, to disambiguate.  Email 
subject goes straight into kernel changelog verbatim, and is in essence 
a global namespace.


