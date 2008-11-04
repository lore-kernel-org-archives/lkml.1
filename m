Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYKDQn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYKDQn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYKDQns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:43:48 -0500
Received: from DSL212-235-53-3.bb.netvision.net.il ([212.235.53.3]:37357 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKDQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:43:47 -0500
X-Greylist: delayed 1423 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Nov 2008 11:43:46 EST
From: Boaz Harrosh <bharrosh@panasas.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Christie <michaelc@cs.wisc.edu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>, open-osd ml <osd-dev@open-osd.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Sami.Iren@seagate.com,
       Pete Wyckoff <pw@padd.com>
Subject: [PATCH 02/18] scsi: OSD_TYPE
Date: Tue,  4 Nov 2008 18:42:17 +0200
Message-Id: <1225816937-5909-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <491073BB.4000900@panasas.com>
References: <491073BB.4000900@panasas.com>
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
index b14dc02..633cb87 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -783,6 +783,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
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

