Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbZAZJJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbZAZJJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 04:09:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZAZJJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 04:09:05 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:45834 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753332AbZAZJJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 04:09:03 -0500
X-YMail-OSG: kcZnWp4VM1lQbWUtJHBKsUDEEBvHHLGOM3sewmMnTmv3QcSKaenCH05mo.16itGDtvsWCrAa_vAUcuyWPQCsXqBdZwis6DDI5PcnU5I9hE3RGaiokUq_ZbF6p8oY_YlsgZyN5DE1qaiQ9QSZHAaTPSZvO4vwe85iE55BdiIekXK2Ku9y8n.A7hHmJOgxowwt2xqOXGxxxpwJyZsDxgkJ_9n9A77wzo2cQ.DFwkpj_J3i.xpVwJs-
X-Yahoo-Newman-Property: ymail-3
Subject: [PATCH 4/7] [Target_Core_Mod/FILEIO]: Convert to use Linux/SCSI
	SCSI_2 define
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Linux-iSCSI.org Target Dev" 
	<linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 01:08:41 -0800
Message-Id: <1232960921.24642.128.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a778c9bbfaab5ff74fdd0c6be6da3708d54a9890 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 26 Jan 2009 00:37:24 -0800
Subject: [PATCH 4/7] [Target_Core_Mod/FILEIO]: Convert to use Linux/SCSI SCSI_2 define

Make fd_get_device_rev() return include/scsi/scsi.h:SCSI_2 and
fd_get_device_type() return SCSI device type: TYPE_DISK following
Linux/SCSI includes.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_file.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/lio-core/target_core_file.c b/drivers/lio-core/target_core_file.c
index b7199d4..5cf95f2 100644
--- a/drivers/lio-core/target_core_file.c
+++ b/drivers/lio-core/target_core_file.c
@@ -1177,7 +1177,7 @@ extern u32 fd_get_blocksize (se_device_t *dev)
  */
 extern u32 fd_get_device_rev (se_device_t *dev)
 {
-	return(02); 
+	return(SCSI_2); 
 }
 
 /*	fd_get_device_type(): (Part of se_subsystem_api_t template)
@@ -1186,7 +1186,7 @@ extern u32 fd_get_device_rev (se_device_t *dev)
  */
 extern u32 fd_get_device_type (se_device_t *dev)
 {
-	return(0); /* TYPE_DISK */
+	return(TYPE_DISK);
 }
 
 /*	fd_get_dma_length(): (Part of se_subsystem_api_t template)
-- 
1.5.4.1



