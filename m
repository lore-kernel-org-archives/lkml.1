Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXIYC6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXIYC6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 22:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753357AbXIYC6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 22:58:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:63011 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898AbXIYC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 22:58:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:references:subject:message-id:x-mailer;
        b=UrehqI82UfvRGRB96+MEGdJFpxQ0YMKSJ47/r9MrGDJUzEpzY2O0eLTE9BpiaDmSjbGikSE7ewqvOFV4AQ1vpbUuWmuBGFWUwkbz/cg+R49CLDVDlpzpN3lJOdxL9nNqXj4SYTUec1dkszjh93+ZWjhcX2zEJ7uaJE2DH1IXZTg=
Date: Tue, 25 Sep 2007 10:58:13 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
References: <200709211406065332552@gmail.com>,
 <20070921113908.180cd154@the-village.bc.nu>,
 <200709241016214230742@gmail.com>,
 <46F7B344.7050903@ru.mvista.com>
Subject: Re: Re: [PATCH] ahci: Add MCP79 support to AHCI driver
Message-ID: <200709251058091899290@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes,they all belong to AHCI controllers, 4 of them use ahci class code and others use RAID class code.

------------------				 
Peer Chen
2007-09-25

-------------------------------------------------------------
发件人：Sergei Shtylyov
发送日期：2007-09-24 20:53:44
收件人：Peer Chen
抄送：Alan Cox; linux-kernel; linux-ide; akpm; jeff
主题：Re: [PATCH] ahci: Add MCP79 support to AHCI driver

Hello.

Peer Chen wrote:

> Code change, remove some Device IDs.

> Signed-off-by: Peer Chen <peerchen@gmail.com>
> ---
> --- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
> +++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-24 10:08:03.000000000 -0400
> @@ -472,6 +472,14 @@ static const struct pci_device_id ahci_p
>  	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
>  	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
>  	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */

    I wonder whether all of those 8 IDs belong to AHCI controllers...

MBR, Sergei

