Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXJ3LFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXJ3LFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbXJ3LE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:04:56 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:47143 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXJ3LEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:04:55 -0400
Date: Tue, 30 Oct 2007 11:54:32 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: James.Bottomley@SteelEye.com, James.Smart@emulex.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071030104816.30937.77821.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/scsi/lpfc/lpfc_hw.h: Some minor cleanup.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Diffed against linus-git
Checked with script/checkpatch.pl


diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 451accd..6f56528 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -3158,31 +3158,30 @@ struct lpfc_sli2_slim {
  *
  * Parameters:
  * device : struct pci_dev 's device field
- *
- * return 1 => TRUE
- *        0 => FALSE
  */
-static inline int
+static inline bool
 lpfc_is_LC_HBA(unsigned short device)
 {
-	if ((device == PCI_DEVICE_ID_TFLY) ||
-	    (device == PCI_DEVICE_ID_PFLY) ||
-	    (device == PCI_DEVICE_ID_LP101) ||
-	    (device == PCI_DEVICE_ID_BMID) ||
-	    (device == PCI_DEVICE_ID_BSMB) ||
-	    (device == PCI_DEVICE_ID_ZMID) ||
-	    (device == PCI_DEVICE_ID_ZSMB) ||
-	    (device == PCI_DEVICE_ID_RFLY))
-		return 1;
-	else
-		return 0;
+	switch (device) {
+	case PCI_DEVICE_ID_TFLY:
+	case PCI_DEVICE_ID_PFLY:
+	case PCI_DEVICE_ID_LP101:
+	case PCI_DEVICE_ID_BMID:
+	case PCI_DEVICE_ID_BSMB:
+	case PCI_DEVICE_ID_ZMID:
+	case PCI_DEVICE_ID_ZSMB:
+	case PCI_DEVICE_ID_RFLY:
+		return true;
+	}
+
+	return false;
 }
 
 /*
  * Determine if an IOCB failed because of a link event or firmware reset.
  */
 
-static inline int
+static inline bool
 lpfc_error_lost_link(IOCB_t *iocbp)
 {
 	return (iocbp->ulpStatus == IOSTAT_LOCAL_REJECT &&
