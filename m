Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbZF1Qbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbZF1Qbb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZF1Q11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:27:27 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1095 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102AbZF1Q1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:27:25 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/62] drivers/block: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:18 -0700
Message-Id: <2b906568224c847be1eadec9a62d7e12fe83e3f2.1246173680.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/DAC960.c |    4 ++--
 drivers/block/swim3.c  |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 668dc23..c0e3449 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6652,7 +6652,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	else ErrorCode = get_user(ControllerNumber,
 			     &UserSpaceControllerInfo->ControllerNumber);
 	if (ErrorCode != 0)
-		break;;
+		break;
 	ErrorCode = -ENXIO;
 	if (ControllerNumber < 0 ||
 	    ControllerNumber > DAC960_ControllerCount - 1) {
@@ -6660,7 +6660,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	}
 	Controller = DAC960_Controllers[ControllerNumber];
 	if (Controller == NULL)
-		break;;
+		break;
 	memset(&ControllerInfo, 0, sizeof(DAC960_ControllerInfo_T));
 	ControllerInfo.ControllerNumber = ControllerNumber;
 	ControllerInfo.FirmwareType = Controller->FirmwareType;
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 80df93e..572ec61 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1062,7 +1062,7 @@ static int swim3_add_device(struct macio_dev *mdev, int index)
 		goto out_release;
 	}
 	fs->swim3_intr = macio_irq(mdev, 0);
-	fs->dma_intr = macio_irq(mdev, 1);;
+	fs->dma_intr = macio_irq(mdev, 1);
 	fs->cur_cyl = -1;
 	fs->cur_sector = -1;
 	fs->secpercyl = 36;
-- 
1.6.3.1.10.g659a0.dirty

