Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXFGKS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXFGKS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXFGKSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:18:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:23813 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXFGKSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=k7lIshoXxf3IoyBpYv3Eis77ZUqC5IGkpegmbps0lia42YFunJ8C0/H1yAgkXoiDzdkfzFAw3C1qC2vvXV3ePjMTXy9MNPCjmTYJD2UIou/HxR0O7+Eh286FmmSoeANjLZl6DRnMOYbEj6RQrbzSLNEGyEYY+sr66ggX/E6Feek=
Message-ID: <4667DB6F.8090204@gmail.com>
Date: Thu, 07 Jun 2007 19:18:23 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Peer Chen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, jeff <jeff@garzik.org>
Subject: Re: [PATCH] ahci: Add MCP73/MCP77 support to AHCI driver
References: <200706071805105304242@gmail.com>
In-Reply-To: <200706071805105304242@gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This one looks much better.  Just few more things.

Peer Chen wrote:
> Add the MCP73/MCP77 support to ahci driver.
> The patch base on kernel 2.6.22-rc4
>  
> Signed-off-by: Peer Chen <peerchen@gmail.com>
> ------------------------------------------------

The separator is '---'.  Automated tools are used, so sticking to it
makes things easier.

> --- linux-2.6.22-rc4/drivers/ata/ahci.c.orig
> +++ linux-2.6.22-rc4/drivers/ata/ahci.c
> @@ -426,6 +426,30 @@ static const struct pci_device_id ahci_p
>  	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci },		/* MCP67 */
>  	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci },		/* MCP67 */
>  	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci },		/* MCP67 */
> +	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci },		/* MCP73 */
> +	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci },		/* MCP73 */
[--snip--]

Whoa, that's a lot of PCI IDs.  AHCI PCI class code doesn't catch them?

-- 
tejun
