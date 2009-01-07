Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbZAGQl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbZAGQl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbZAGQlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:41:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:65183 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758081AbZAGQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=sHvmqFxYyFQhyebXJ4Ggv8t6QmNqZncp8lzAukK0bWJoU0TafpzbDpyMUzUFtthnZh
         wDG1+ZGDYtbC+j1zQSHFccA/pBbFo8XLvf1Si447lo+naLbC/MRd6jBZRwUQj43LsRhr
         E34V7TtU3afAKcBtgRP3DCMxu8CEbzfiAIrF4=
From: Bryan Wu <cooloney@kernel.org>
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 2/3] Blackfin NFC Driver: mark bf5xx_nand_add_partition() as __devinit
Date: Thu,  8 Jan 2009 00:41:58 +0800
Message-Id: <1231346519-28603-3-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
References: <1231346519-28603-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier.adi@gmail.com>

the bf5xx_nand_add_partition() func is only called by __devinit
functions, so put it into the __devinit section as well

Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/mtd/nand/bf5xx_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 5c6056e..520314d 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -630,7 +630,7 @@ static int bf5xx_nand_hw_init(struct bf5xx_nand_info *info)
 /*
  * Device management interface
  */
-static int bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
+static int __devinit bf5xx_nand_add_partition(struct bf5xx_nand_info *info)
 {
 	struct mtd_info *mtd = &info->mtd;
 
-- 
1.5.6

