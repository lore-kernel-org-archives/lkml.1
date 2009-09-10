Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbZIJKUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbZIJKUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:20:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755379AbZIJKUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:20:00 -0400
Received: from server1.wserver.cz ([82.113.45.157]:47406 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbZIJKT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:19:59 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/2] Char: mxser, add support for CP112UL
Date: Thu, 10 Sep 2009 12:20:07 +0200
Message-Id: <1252578008-6207-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for MOXA:0x1120 pci device. It's a 2-port device and differs
in no way from the others. So this turns out to be a trivial
pci_device_id change.

Increase also the version number.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 37058ff..e218ae2 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -48,7 +48,7 @@
 
 #include "mxser.h"
 
-#define	MXSER_VERSION	"2.0.4"		/* 1.12 */
+#define	MXSER_VERSION	"2.0.5"		/* 1.14 */
 #define	MXSERMAJOR	 174
 
 #define MXSER_BOARDS		4	/* Max. boards */
@@ -69,6 +69,7 @@
 #define PCI_DEVICE_ID_POS104UL	0x1044
 #define PCI_DEVICE_ID_CB108	0x1080
 #define PCI_DEVICE_ID_CP102UF	0x1023
+#define PCI_DEVICE_ID_CP112UL	0x1120
 #define PCI_DEVICE_ID_CB114	0x1142
 #define PCI_DEVICE_ID_CP114UL	0x1143
 #define PCI_DEVICE_ID_CB134I	0x1341
@@ -139,7 +140,8 @@ static const struct mxser_cardinfo mxser_cards[] = {
 	{ "CP-138U series",	8, },
 	{ "POS-104UL series",	4, },
 	{ "CP-114UL series",	4, },
-/*30*/	{ "CP-102UF series",	2, }
+/*30*/	{ "CP-102UF series",	2, },
+	{ "CP-112UL series",	2, },
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -170,6 +172,7 @@ static struct pci_device_id mxser_pcibrds[] = {
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP114UL),	.driver_data = 29 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP102UF),	.driver_data = 30 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP112UL),	.driver_data = 31 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
-- 
1.6.3.3

