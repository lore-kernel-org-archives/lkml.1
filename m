Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbYESTMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbYESTMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 15:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYESTL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 15:11:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38402 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbYESTLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 15:11:55 -0400
Message-ID: <4831D0F8.4060706@garzik.org>
Date: Mon, 19 May 2008 15:11:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: peerchen <peerchen@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] ahci: change the Device IDs of nvidia MCP7B AHCI controller
 in ahci.c
References: <200805191444539981741@gmail.com>
In-Reply-To: <200805191444539981741@gmail.com>
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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



