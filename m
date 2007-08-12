Return-Path: <linux-kernel-owner+w=401wt.eu-S936379AbXHLPYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936379AbXHLPYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762665AbXHLPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:24:33 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:59658 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758319AbXHLPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:24:32 -0400
Message-id: <2526621523428728253@wsc.cz>
In-reply-to: <261712744987112084@wsc.cz>
Subject: [PATCH 2/3] Char: mxser_new, move to PCI_VDEVICE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 12 Aug 2007 17:25:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, move to PCI_VDEVICE

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 49b870ecc51c0e1aeb28ae329d825e9ca35cc973
tree 3beb5439b988f082464f1a8bc805e43c1afd1753
parent 77a1c21e95d4f0eb4f4dc1d98463bb4046e033bd
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 17:16:03 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 17:19:57 +0200

 drivers/char/mxser_new.c |   54 +++++++++++++++-------------------------------
 1 files changed, 18 insertions(+), 36 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 7677df3..a03e391 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -147,42 +147,24 @@ static const struct mxser_cardinfo mxser_cards[] = {
 /* driver_data correspond to the lines in the structure above
    see also ISA probe function before you change something */
 static struct pci_device_id mxser_pcibrds[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C168),
-		.driver_data = 3 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_C104),
-		.driver_data = 4 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP132),
-		.driver_data = 8 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP114),
-		.driver_data = 9 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CT114),
-		.driver_data = 10 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP102),
-		.driver_data = 11 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP104U),
-		.driver_data = 12 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP168U),
-		.driver_data = 13 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP132U),
-		.driver_data = 14 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP134U),
-		.driver_data = 15 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP104JU),
-		.driver_data = 16 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_RC7000),
-		.driver_data = 17 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP118U),
-		.driver_data = 18 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP102UL),
-		.driver_data = 19 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP102U),
-		.driver_data = 20 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP118EL),
-		.driver_data = 21 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP168EL),
-		.driver_data = 22 },
-	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP104EL),
-		.driver_data = 23 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_C168),	.driver_data = 3 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_C104),	.driver_data = 4 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP132),	.driver_data = 8 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP114),	.driver_data = 9 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CT114),	.driver_data = 10 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP102),	.driver_data = 11 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP104U),	.driver_data = 12 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP168U),	.driver_data = 13 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP132U),	.driver_data = 14 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP134U),	.driver_data = 15 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP104JU),.driver_data = 16 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_RC7000),	.driver_data = 17 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP118U),	.driver_data = 18 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP102UL),.driver_data = 19 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP102U),	.driver_data = 20 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP118EL),.driver_data = 21 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP168EL),.driver_data = 22 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_MOXA_CP104EL),.driver_data = 23 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB108),	.driver_data = 24 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB114),	.driver_data = 25 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB134I),	.driver_data = 26 },
