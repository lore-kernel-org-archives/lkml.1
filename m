Return-Path: <linux-kernel-owner+w=401wt.eu-S1751318AbZAZJJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbZAZJJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:09:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZAZJIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:08:38 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:21494 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753222AbZAZJIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:08:36 -0500
X-YMail-OSG: sS7t5vYVM1lzZASwYuW4k27BKI3rr8LONGoLN0cs.ZOlp.qcxNXXMAa_O8NR6KlV68S3.BcZ594mbfL5gcOGaSlTdBtgI6eoaPMBR0JtyXGylJfK_Of.KGc_t.Njgb7baL.GePXjZl3pUtQ82rLylbMqWfvW971XIXrzmd3UQgiuW1qrZHuf.hDl9gTzeD4EO5BhrFRNXnm_QDPMVXY18NVn8HflDDxxibUPSji.S.9_ojIltnc-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 3/7] [Target_Core_Mod/RAMDISK]: Convert to use Linux/SCSI
	SCSI_2 define
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 01:08:13 -0800
Message-Id: <1232960893.24642.126.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a47fe38c787c6052c3a3b1652212c9c748eb92ac Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:35:49 -0800
Subject: [PATCH 3/7] [Target_Core_Mod/RAMDISK]: Convert to use Linux/SCSI SCSI_2 define

Make rd_get_device_rev() return include/scsi/scsi.h:SCSI_2 and
rd_get_device_type() return SCSI device type: TYPE_DISK following
Linux/SCSI includes.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_rd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_rd.c b/drivers/lio-core/target_core_rd.c
index e065d7d..e991bb6 100644
--- a/drivers/lio-core/target_core_rd.c
+++ b/drivers/lio-core/target_core_rd.c
@@ -1347,12 +1347,12 @@ extern u32 rd_get_blocksize (se_device_t *dev)
 
 extern u32 rd_get_device_rev (se_device_t *dev)
 {
-	return(02);
+	return(SCSI_2);
 }
 
 extern u32 rd_get_device_type (se_device_t *dev)
 {
-	return(0); /* TYPE_DISK */
+	return(TYPE_DISK);
 }
 
 /*	rd_get_dma_length(): (Part of se_subsystem_api_t template)
-- 
1.5.4.1



