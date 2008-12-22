Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYLVMkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYLVMkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYLVMj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:39:58 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:2792 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751453AbYLVMj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:39:57 -0500
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       open-osd ml <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/18] scsi: OSD_TYPE
Date: Mon, 22 Dec 2008 14:39:50 +0200
Message-Id: <1229949590-15705-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <494F88C0.4070507@panasas.com>
References: <494F88C0.4070507@panasas.com>
X-OriginalArrivalTime: 22 Dec 2008 12:39:53.0129 (UTC) FILETIME=[63252190:01C96432]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Define the OSD_TYPE scsi device and let it show up in scans

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/scsi_scan.c |    1 +
 include/scsi/scsi.h      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 18486b5..4db6e3e 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -794,6 +794,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	case TYPE_ENCLOSURE:
 	case TYPE_COMM:
 	case TYPE_RAID:
+	case TYPE_OSD:
 		sdev->writeable = 1;
 		break;
 	case TYPE_ROM:
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index a109165..de1cef2 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -263,6 +263,7 @@ static inline int scsi_status_is_good(int status)
 #define TYPE_RAID           0x0c
 #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
 #define TYPE_RBC	    0x0e
+#define TYPE_OSD            0x11
 #define TYPE_NO_LUN         0x7f
 
 /* SCSI protocols; these are taken from SPC-3 section 7.5 */
-- 
1.6.0.1

