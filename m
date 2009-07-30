Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbZG3KZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbZG3KZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZG3KZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:25:20 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:37908 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbZG3KZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:25:18 -0400
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, David.Woodhouse@intel.com, sr@denx.de,
       bigeasy@linutronix.de, kay.sievers@vrfy.org, gregkh@suse.de,
       linux-mtd@lists.infradead.org
Subject: [PATCH 2/4] [mtd] fixed faulty check
Date: Thu, 30 Jul 2009 05:25:06 -0500
Message-ID: <1248949506-20827-1-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patche fixes a spelling error that has resulted from copy and pasting. The location of the error was found using a semantic patch but the semantic patch was not trying to find these errors. After looking things over it seemed logical that this change was needed. Please review it and then include the patch if it is in fact the correct change.

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 drivers/mtd/maps/physmap_of.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 39d357b..2cc0b0d 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -215,7 +215,7 @@ static int __devinit of_flash_probe(struct of_device *dev,
 		goto err_out;
 
 	mtd_list = kzalloc(sizeof(struct mtd_info) * count, GFP_KERNEL);
-	if (!info)
+	if (!mtd_list)
 		goto err_out;
 
 	dev_set_drvdata(&dev->dev, info);
-- 
1.6.3.3

