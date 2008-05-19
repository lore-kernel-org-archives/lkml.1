Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbYESGpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbYESGpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYESGpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:45:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:28268 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYESGpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:45:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=bEZEvxKH9dpf5vcHwIvbzatrhdZb0F9Kwy5UxgJ0jvAEd/eyEymecQEVhLIQA0Vv97zBuYcF934abpK1zZZ/jUq/kl2BW4apYpIHFsW3kDV27vgmCyAsf3yBAGKU4gzwtiKixPl/2o8y/p74cRikFfV6YjdV954dhar6coQtHiQ=
Date: Mon, 19 May 2008 14:44:57 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: [PATCH] ahci: change the Device IDs of nvidia MCP7B AHCI controller in ahci.c
Message-ID: <200805191444539981741@gmail.com>
X-mailer: Foxmail 6, 10, 201, 20 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the partial Device IDs of nvidia MCP7B AHCI controller in ahci.c

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.26-rc3/drivers/ata/ahci.c.orig	2008-05-07 13:24:19.000000000 -0400
+++ linux-2.6.26-rc3/drivers/ata/ahci.c	2008-05-07 13:25:17.000000000 -0400
@@ -502,10 +502,10 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(NVIDIA, 0x0bcd), board_ahci },		/* MCP7B */
 	{ PCI_VDEVICE(NVIDIA, 0x0bce), board_ahci },		/* MCP7B */
 	{ PCI_VDEVICE(NVIDIA, 0x0bcf), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd0), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd1), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd2), board_ahci },		/* MCP7B */
-	{ PCI_VDEVICE(NVIDIA, 0x0bd3), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc4), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc5), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc6), board_ahci },		/* MCP7B */
+	{ PCI_VDEVICE(NVIDIA, 0x0bc7), board_ahci },		/* MCP7B */
 
 	/* SiS */
 	{ PCI_VDEVICE(SI, 0x1184), board_ahci }, /* SiS 966 */
-

