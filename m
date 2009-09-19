Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZISVol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZISVol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZISVoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:44:23 -0400
Received: from kroah.org ([198.145.64.141]:40564 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbZISVoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:44:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 69/79] tty: Char: mxser, add support for CP112UL
Date: Sat, 19 Sep 2009 14:37:14 -0700
Message-Id: <1253396244-7885-69-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

Add support for MOXA:0x1120 pci device. It's a 2-port device and differs
in no way from the others. So this turns out to be a trivial
pci_device_id change.

Increase also the version number.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.4.2

