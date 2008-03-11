Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYCKAwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYCKAwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751651AbYCKAwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:52:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50862 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbYCKAvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:51:49 -0400
Message-ID: <47D5D7A3.1030705@garzik.org>
Date: Mon, 10 Mar 2008 20:51:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: peerchen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] ahci: add the Device IDs of nvidia MCP7B AHCI controller
 to ahci.c
References: <200803062122359218883@gmail.com>
In-Reply-To: <200803062122359218883@gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peerchen wrote:
> Add the device IDs of nvidia MCP79 AHCI controller to ahci.c
> 
> Signed-off-by: Peer Chen <peerchen@gmail.com>
> ---
> --- linux-2.6.25-rc4/drivers/ata/ahci.c.orig	2008-03-04 21:46:30.000000000 -0500
> +++ linux-2.6.25-rc4/drivers/ata/ahci.c	2008-03-04 21:50:42.000000000 -0500
> @@ -563,6 +563,18 @@ static const struct pci_device_id ahci_p
>  	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
>  	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
>  	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bc8), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bc9), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bca), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bcb), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bcc), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
> +	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */

applied


