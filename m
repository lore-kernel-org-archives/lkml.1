Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZFYFOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZFYFOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZFYFNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:40 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1436 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZFYFNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:38 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/19] drivers/block: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:19 -0700
Message-Id: <6b8cd2e29d941d68530d5b963f92a03b0ca6c906.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/sx8.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index da403b6..55fab42 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -410,8 +410,8 @@ static void carm_remove_one (struct pci_dev *pdev);
 static int carm_bdev_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static struct pci_device_id carm_pci_tbl[] = {
-	{ PCI_VENDOR_ID_PROMISE, 0x8000, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
-	{ PCI_VENDOR_ID_PROMISE, 0x8002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
+	{ PCI_VDEVICE(PROMISE, 0x8000), },
+	{ PCI_VDEVICE(PROMISE, 0x8002), },
 	{ }	/* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, carm_pci_tbl);
-- 
1.6.3.1.10.g659a0.dirty

