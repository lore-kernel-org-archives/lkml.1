Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXLCOU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXLCOU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbXLCOUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:20:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:37542 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298AbXLCOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:20:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=yG0GsR8bQypLg/MG08VNs6My8z6QZb0yB+7ahQ9SCafXfBqQSCFqk8Yf/Cm9/dljY4YfR2wHWUCh2ASwYbkNavZ1B/7qkdercxE9foqNLiZXhuuPygqxDIBO3jiYU3NX8tmh0oJsYST4FMMtKZsNRo0pWU7bnzNu+ZZIVgXkcFU=
Date: Mon, 3 Dec 2007 22:20:37 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: [PATCH] ahci: add the Device IDs of MCP79 AHCI controller to ahci.c
Message-ID: <200712032220233286345@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device IDs of legacy mode of MCP79 AHCI controller to ahci.c

The patch base on kernel 2.6.24-rc3

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.24-rc3/drivers/ata/ahci.c.orig	2007-12-03 16:20:15.000000000 -0500
+++ linux-2.6.24-rc3/drivers/ata/ahci.c	2007-12-03 16:32:11.000000000 -0500
@@ -536,6 +536,10 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
 	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab4), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab5), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab6), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ab7), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab8), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0ab9), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0aba), board_ahci },		/* MCP79 */
-

