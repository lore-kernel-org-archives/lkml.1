Return-Path: <linux-kernel-owner+w=401wt.eu-S1754732AbYGYCqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbYGYCqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYGYCqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:46:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:26269 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYGYCqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:46:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pejl0bPNOQ0XN3rHVACywEG3yE3w6ZFg4Ou/NR0lbNf39mY9/g3dvM7GiB2ukSRlKI
         jlGeewZ+u/1L7SGPd2sXkWSd3zgfflm9unp5bShEpziGQ1Pf+hr8HkIrz+CH07Zmmc1h
         g2UFWVQDh90+Wo3tyQALDMWxI+5C4rjEfMtBI=
From: Denis ChengRq <crquan@gmail.com>
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] drivers/scsi/megaraid/: replace __FUNCTION__ with __func__
Date: Fri, 25 Jul 2008 10:45:45 +0800
Message-Id: <1216953945-31873-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/scsi/megaraid/mega_common.h   |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c |   16 ++++++++--------
 drivers/scsi/megaraid/megaraid_mm.c   |    4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index f62ed46..5ead128 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -265,7 +265,7 @@ typedef struct {
 #define ASSERT(expression)						\
 	if (!(expression)) {						\
 	ASSERT_ACTION("assertion failed:(%s), file: %s, line: %d:%s\n",	\
-			#expression, __FILE__, __LINE__, __FUNCTION__);	\
+			#expression, __FILE__, __LINE__, __func__);	\
 	}
 #else
 #define ASSERT(expression)
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 70a0f11..805bb61 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -458,7 +458,7 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	if (adapter == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-		"megaraid: out of memory, %s %d.\n", __FUNCTION__, __LINE__));
+		"megaraid: out of memory, %s %d.\n", __func__, __LINE__));
 
 		goto out_probe_one;
 	}
@@ -1002,7 +1002,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 
 	if (!raid_dev->una_mbox64) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		return -1;
 	}
@@ -1030,7 +1030,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 	if (!adapter->ibuf) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		goto out_free_common_mbox;
@@ -1052,7 +1052,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 
 	if (adapter->kscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		goto out_free_ibuf;
 	}
@@ -1060,7 +1060,7 @@ megaraid_alloc_cmd_packets(adapter_t *adapter)
 	// memory allocation for our command packets
 	if (megaraid_mbox_setup_dma_pools(adapter) != 0) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		goto out_free_scb_list;
 	}
@@ -2981,7 +2981,7 @@ megaraid_mbox_product_info(adapter_t *adapter)
 
 	if (pinfo == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		return -1;
@@ -3508,7 +3508,7 @@ megaraid_cmm_register(adapter_t *adapter)
 
 	if (adapter->uscb_list == NULL) {
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 		return -1;
 	}
@@ -3879,7 +3879,7 @@ megaraid_sysfs_alloc_resources(adapter_t *adapter)
 		!raid_dev->sysfs_buffer) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		rval = -ENOMEM;
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index ac3b280..f680561 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -929,7 +929,7 @@ mraid_mm_register_adp(mraid_mmadp_t *lld_adp)
 			!adapter->pthru_dma_pool) {
 
 		con_log(CL_ANN, (KERN_WARNING
-			"megaraid cmm: out of memory, %s %d\n", __FUNCTION__,
+			"megaraid cmm: out of memory, %s %d\n", __func__,
 			__LINE__));
 
 		rval = (-ENOMEM);
@@ -957,7 +957,7 @@ mraid_mm_register_adp(mraid_mmadp_t *lld_adp)
 
 			con_log(CL_ANN, (KERN_WARNING
 				"megaraid cmm: out of memory, %s %d\n",
-					__FUNCTION__, __LINE__));
+					__func__, __LINE__));
 
 			rval = (-ENOMEM);
 
-- 
1.5.6.3

