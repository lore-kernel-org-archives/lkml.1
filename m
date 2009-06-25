Return-Path: <linux-kernel-owner+w=401wt.eu-S1759144AbZFYFOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759144AbZFYFOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZFYFNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:41 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1437 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZFYFNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:39 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linux-geode@lists.infradead.org
Subject: [PATCH 04/19] drivers/char/hw_random: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:20 -0700
Message-Id: <6498b0c571fd010583c911cabc346c26ce8f25a7.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/hw_random/amd-rng.c   |    4 ++--
 drivers/char/hw_random/geode-rng.c |    3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
index cd0ba51..0d8c578 100644
--- a/drivers/char/hw_random/amd-rng.c
+++ b/drivers/char/hw_random/amd-rng.c
@@ -44,8 +44,8 @@
  * want to register another driver on the same PCI id.
  */
 static const struct pci_device_id pci_tbl[] = {
-	{ 0x1022, 0x7443, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
-	{ 0x1022, 0x746b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
+	{ PCI_VDEVICE(AMD, 0x7443), 0, },
+	{ PCI_VDEVICE(AMD, 0x746b), 0, },
 	{ 0, },	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
diff --git a/drivers/char/hw_random/geode-rng.c b/drivers/char/hw_random/geode-rng.c
index 64d513f..4c4d4e1 100644
--- a/drivers/char/hw_random/geode-rng.c
+++ b/drivers/char/hw_random/geode-rng.c
@@ -46,8 +46,7 @@
  * want to register another driver on the same PCI id.
  */
 static const struct pci_device_id pci_tbl[] = {
-	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0, },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_LX_AES), 0, },
 	{ 0, },	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, pci_tbl);
-- 
1.6.3.1.10.g659a0.dirty

