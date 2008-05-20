Return-Path: <linux-kernel-owner+w=401wt.eu-S1760379AbYETCvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379AbYETCvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYETCvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:51:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:57295 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYETCvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:references:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=f+RN8YTfHg37EEwjJCSWEv19SgeN9UB3rggSScZ2xO/o75lwBqXjgCx6VhpA4np43poElYtEgGKqyZJcNtDHjoWxzGcY+4vvyXEnFS5INdsScJOagUW0btPwKb6AFT4Pv8vQrH8g15IAkouUYwB6MRjXTcsj0Iqtoi1EknVDXYQ=
Date: Tue, 20 May 2008 10:50:56 +0800
From: "peerchen" <peerchen@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>
References: <200805191444539981741@gmail.com>,
 <4831D0F8.4060706@garzik.org>
Subject: Re: Re: [PATCH] ahci: change the Device IDs of nvidia MCP7B AHCI controllerin ahci.c
Message-ID: <200805201050523570380@gmail.com>
X-mailer: Foxmail 6, 10, 201, 20 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4K2pLHl012722

We make a mistake, the IDs need to be changed are not correct, those IDs belong to other devices.

------------------				 
peerchen
2008-05-20

-------------------------------------------------------------
·¢¼şÈË£ºJeff Garzik
·¢ËÍÈÕÆÚ£º2008-05-20 03:11:56
ÊÕ¼şÈË£ºpeerchen
³­ËÍ£ºlinux-kernel; linux-ide; akpm
Ö÷Ìâ£ºRe: [PATCH] ahci: change the Device IDs of nvidia MCP7B AHCI controllerin ahci.c

peerchen wrote:
> Change the partial Device IDs of nvidia MCP7B AHCI controller in ahci.c
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>
> ---
> --- linux-2.6.26-rc3/drivers/ata/ahci.c.orig	2008-05-07 13:24:19.000000000 -0400
> +++ linux-2.6.26-rc3/drivers/ata/ahci.c	2008-05-07 13:25:17.000000000 -0400
> @@ -502,10 +502,10 @@ static const struct pci_device_id ahci_p
>  	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
>  	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
>  	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
> -	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
> -	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
> -	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
> -	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bc4), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bc5), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bc6), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */

A little bit more patch description, please?

Why is this change needed?  A change with a description of
(paraphrasing) "do this change" is rather vague ;)

	Jeff



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
