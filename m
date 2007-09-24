Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbXIXCQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbXIXCQk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 22:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbXIXCQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 22:16:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:30963 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXIXCQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 22:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:references:subject:message-id:x-mailer;
        b=gz//M/tMPcmFSIZi5qSy0bdTCgv4rmalk7dYdELozr3ZHGKafVZJAm03Iqtf9UdR/RlEmTwd3NovgqvqCctp1BBRA9C2EKUO1vlyEix2QVnq0foYWMNmv3y/e2jOwyC0ei0UFARMw19DK3UAw456fPy2Ku5zMyM6CYzBFQZMlUM=
Date: Mon, 24 Sep 2007 10:16:25 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>,
       "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
References: <200709211406065332552@gmail.com>,
 <20070921113908.180cd154@the-village.bc.nu>
Subject: Re: Re: [PATCH] ahci: Add MCP79 support to AHCI driver
Message-ID: <200709241016214230742@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Code change, remove some Device IDs.

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
+++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-24 10:08:03.000000000 -0400
@@ -472,6 +472,14 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abb), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abc), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
-

------------------				 
Peer Chen
2007-09-24

-------------------------------------------------------------
发件人：Alan Cox
发送日期：2007-09-21 18:32:09
收件人：Peer Chen
抄送：linux-kernel; linux-ide; akpm; jeff
主题：Re: [PATCH] ahci: Add MCP79 support to AHCI driver

On Fri, 21 Sep 2007 14:06:10 +0800
"Peer Chen" <peerchen@gmail.com> wrote:

> Add the MCP79 support to ahci driver.
> The patch base on kernel 2.6.23-rc7

Is this actually needed or as they are standard ahci devices will the
class match get them anyway ?

