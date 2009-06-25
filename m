Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZFYFPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZFYFPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZFYFNq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:46 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1444 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629AbZFYFNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:44 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 08/19] drivers/misc: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:24 -0700
Message-Id: <bdd48484fe7fa4472031e5d16b104450f9023f28.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/misc/tifm_7xx1.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index a6ef182..de74445 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -415,12 +415,9 @@ static void tifm_7xx1_remove(struct pci_dev *dev)
 }
 
 static struct pci_device_id tifm_7xx1_pci_tbl [] = {
-	{ PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XX21_XX11_FM, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 }, /* xx21 - the one I have */
-        { PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XX12_FM, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_TI, PCI_DEVICE_ID_TI_XX20_FM, PCI_ANY_ID,
-	  PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(TI, PCI_DEVICE_ID_TI_XX21_XX11_FM), 0 }, /* xx21 - the one I have */
+        { PCI_VDEVICE(TI, PCI_DEVICE_ID_TI_XX12_FM), 0 },
+	{ PCI_VDEVICE(TI, PCI_DEVICE_ID_TI_XX20_FM), 0 },
 	{ }
 };
 
-- 
1.6.3.1.10.g659a0.dirty

