Return-Path: <linux-kernel-owner+w=401wt.eu-S1030281AbXBTQxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030281AbXBTQxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030280AbXBTQxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:53:47 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45047 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030281AbXBTQxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:53:46 -0500
Message-ID: <45DB2797.4040306@garzik.org>
Date: Tue, 20 Feb 2007 11:53:43 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_oldpiix: Call both PIO and DMA setup functions on
 switch as they are called on set up
References: <20070220174737.143b60b7@localhost.localdomain>
In-Reply-To: <20070220174737.143b60b7@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Keeps the behaviour consistent and easier to understand.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_oldpiix.c linux-2.6.20-mm2/drivers/ata/pata_oldpiix.c
> --- linux.vanilla-2.6.20-mm2/drivers/ata/pata_oldpiix.c	2007-02-20 13:37:58.000000000 +0000
> +++ linux-2.6.20-mm2/drivers/ata/pata_oldpiix.c	2007-02-20 13:54:49.000000000 +0000
> @@ -25,7 +25,7 @@
>  #include <linux/ata.h>
>  
>  #define DRV_NAME	"pata_oldpiix"
> -#define DRV_VERSION	"0.5.3"
> +#define DRV_VERSION	"0.5.4"

applied

