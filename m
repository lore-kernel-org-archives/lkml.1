Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbXFGKF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbXFGKF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 06:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbXFGKFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 06:05:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:35987 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXFGKFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 06:05:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=YLlr51StdF0jN2HQ7H4L8+Bb8Ch0DNfaPPLrSa5fPDesKN67nLU9XxG7FKliYPbgSnBCB5Jd24yZ2CUp2QByRVZLN44+c0m2gxylBSSdpo/2CrBTqQT3eFlYvOQKoY6sUMVhgm3uNRu8TNMja+ECeplioXoeNmmlTFfw8XljdlA=
Date: Thu, 7 Jun 2007 18:05:12 +0800
From: "Peer Chen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>,
       "htejun" <htejun@gmail.com>
Subject: [PATCH] ahci: Add MCP73/MCP77 support to AHCI driver
Message-ID: <200706071805105304242@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the MCP73/MCP77 support to ahci driver.
The patch base on kernel 2.6.22-rc4
 
Signed-off-by: Peer Chen <peerchen@gmail.com>
------------------------------------------------
--- linux-2.6.22-rc4/drivers/ata/ahci.c.orig
+++ linux-2.6.22-rc4/drivers/ata/ahci.c
@@ -426,6 +426,30 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci },		/* MCP67 */
 	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci },		/* MCP67 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f3), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f4), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f5), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f6), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f7), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f8), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07f9), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fa), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x07fb), board_ahci },		/* MCP73 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad0), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad1), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad2), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad3), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad4), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad5), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad6), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad7), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad8), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ad9), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0ada), board_ahci },		/* MCP77 */
+	{ PCI_VDEVICE(NVIDIA, 0x0adb), board_ahci },		/* MCP77 */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */

