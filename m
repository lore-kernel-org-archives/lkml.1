Return-Path: <linux-kernel-owner+w=401wt.eu-S1030284AbXBTQyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030284AbXBTQyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030282AbXBTQyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:54:11 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45061 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030284AbXBTQx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:53:59 -0500
Message-ID: <45DB27A4.801@garzik.org>
Date: Tue, 20 Feb 2007 11:53:56 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_sil680: Assorted fixes
References: <20070220174925.227a7b4d@localhost.localdomain>
In-Reply-To: <20070220174925.227a7b4d@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Correct iordy handling and DMA bit flag handling.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_sil680.c linux-2.6.20-mm2/drivers/ata/pata_sil680.c
> --- linux.vanilla-2.6.20-mm2/drivers/ata/pata_sil680.c	2007-02-20 13:37:58.000000000 +0000
> +++ linux-2.6.20-mm2/drivers/ata/pata_sil680.c	2007-02-20 13:56:39.000000000 +0000
> @@ -33,7 +33,7 @@
>  #include <linux/libata.h>
>  
>  #define DRV_NAME "pata_sil680"
> -#define DRV_VERSION "0.4.1"
> +#define DRV_VERSION "0.4.5"

applied

