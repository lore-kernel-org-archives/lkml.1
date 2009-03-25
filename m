Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbZCYAbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbZCYAbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbZCYA3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:39 -0400
Received: from kroah.org ([198.145.64.141]:54045 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756633AbZCYA3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:38 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org
Subject: [PATCH 06/61] mtd: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:10 -0700
Message-Id: <1237940825-22904-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: dwmw2@infradead.org
Cc: linux-mtd@lists.infradead.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/mtd/nand/ndfc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index 582cf80..89bf85a 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -187,7 +187,7 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 		return -ENODEV;
 
 	ndfc->mtd.name = kasprintf(GFP_KERNEL, "%s.%s",
-				   ndfc->ofdev->dev.bus_id, flash_np->name);
+			dev_name(&ndfc->ofdev->dev), flash_np->name);
 	if (!ndfc->mtd.name) {
 		ret = -ENOMEM;
 		goto err;
-- 
1.6.2

