Return-Path: <linux-kernel-owner+w=401wt.eu-S1759119AbXGBOIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759119AbXGBOIG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 10:08:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753630AbXGBOHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 10:07:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51749 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037AbXGBOHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 10:07:53 -0400
Message-ID: <468906B6.1050700@garzik.org>
Date: Mon, 02 Jul 2007 10:07:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Florian Attenberger <valdyn@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc6] add PCI-ID for Adaptec 1430SA 4-Port SATA
 Controller
References: <20070630144436.GA13479@master.home>
In-Reply-To: <20070630144436.GA13479@master.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Attenberger wrote:
> Hi,
> 
> added this pci id to support my:
> lspci:
> 01:00.0 RAID bus controller: Adaptec Unknown device 0243 (rev 02)
> lspci -n:
> 01:00.0 0104: 9005:0243 (rev 02)
> 
> seems to work fine.
> 
> florian attenberger
> 
> 
> --- 2.6.22-rc6/drivers/ata/sata_mv.c	2007-06-30 16:21:47.462020256 +0200
> +++ 2.6.22-rc6.mine/drivers/ata/sata_mv.c	2007-06-30 16:25:25.999165444 +0200
> @@ -582,6 +582,9 @@ static const struct pci_device_id mv_pci
>  
>  	{ PCI_VDEVICE(ADAPTEC2, 0x0241), chip_604x },
>  
> +	/* Adaptec 1430SA */
> +	{ PCI_VDEVICE(ADAPTEC2, 0x0243), chip_7042 },
> +
>  	{ PCI_VDEVICE(TTI, 0x2310), chip_7042 },

Please do me a favor and resend with the Signed-off-by line as described 
by Documentation/SubmittingPatches and
http://linux.yyz.us/patch-format.html

Also, since your email is copied verbatim into the permanent kernel 
changelog, please remove all superfluous comments like "Hi," and 
"florian attenberger", or add a "---" separator and move the comments 
after the separator.

