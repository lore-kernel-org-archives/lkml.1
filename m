Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbXIUGGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbXIUGGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 02:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXIUGGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 02:06:17 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:12553 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXIUGGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 02:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer;
        b=jdWMeGiTv8Nws95wMbOlZ58kFTtKXWwj3yhUio5BP4cvwnVGin24LsGidiebMJ1Idyq0V2O0J+SVwKpN//UgzI1+OvTXbbqsA9TbNBuAoliuGoww55jo50PDUkxXbJlxHmy85MqkUHoYqYAFVOBn2GlN4O7I+Psb6Crfd5UNsPw=
Date: Fri, 21 Sep 2007 14:06:10 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: [PATCH] ahci: Add MCP79 support to AHCI driver
Message-ID: <200709211406065332552@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the MCP79 support to ahci driver.
The patch base on kernel 2.6.23-rc7
 
Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.23-rc7/drivers/ata/ahci.c.orig	2007-09-20 11:01:55.000000000 -0400
+++ linux-2.6.23-rc7/drivers/ata/ahci.c	2007-09-21 13:54:58.000000000 -0400
@@ -472,6 +472,18 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
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

