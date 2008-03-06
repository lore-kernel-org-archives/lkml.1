Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbYCFNW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbYCFNW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYCFNWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:22:47 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:35635 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbYCFNWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:22:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=ShdI2D1UMYS1uxHgfjz8W1GymUqT6bWwBW/L7rWREr/38WVdP5c4iMk1L4sYDELvhDBzDPPhgODYeoMOwJIxyJpfy/QTyZZADOikbpPzB1ZP4EACXF/rB3DUSmQiYJIhWgxw462kQ1KZNqFp/viR7BYhDMz+WoIACVwkR2RLb3c=
Date: Thu, 6 Mar 2008 21:22:41 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: [PATCH] ahci: add the Device IDs of nvidia MCP7B AHCI controller to ahci.c
Message-ID: <200803062122359218883@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the device IDs of nvidia MCP79 AHCI controller to ahci.c

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.25-rc4/drivers/ata/ahci.c.orig	2008-03-04 21:46:30.000000000 -0500
+++ linux-2.6.25-rc4/drivers/ata/ahci.c	2008-03-04 21:50:42.000000000 -0500
@@ -563,6 +563,18 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0abd), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abe), board_ahci },		/* MCP79 */
 	{ PCI_VDEVICE(NVIDIA, 0x0abf), board_ahci },		/* MCP79 */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc8), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc9), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bca), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcb), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcc), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
-

