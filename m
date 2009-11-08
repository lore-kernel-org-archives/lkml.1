Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZKHU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZKHU0V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 15:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbZKHU0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 15:26:19 -0500
Received: from [190.108.161.231] ([190.108.161.231]:40534 "EHLO
	localhost.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755387AbZKHU0P convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 15:26:15 -0500
Subject: [PATCH 02/20] scsi/NCR53c406a No longer use Scsi_Cmd typedef
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       normunds@fi.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 08 Nov 2009 17:17:00 -0300
Message-ID: <1257711420.4759.108.camel@dbueso-pc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change Scsi_Cmnd for struct scsi_cmnd.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>

--- 
drivers/scsi/NCR53c406a.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 6961f78..8ef7dc9 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -201,7 +201,7 @@ static int dma_chan;
 static int fast_pio = USE_FAST_PIO;
 #endif
 
-static Scsi_Cmnd *current_SC;
+static struct scsi_cmnd *current_SC;
 static char info_msg[256];
 
 /* ================================================================= */
@@ -693,7 +693,7 @@ static void wait_intr(void)
 }
 #endif
 
-static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
+static int NCR53c406a_queue(struct scsi_cmnd * SCpnt, void (*done) (struct scsi_cmnd *))
 {
 	int i;
 
@@ -726,7 +726,7 @@ static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 	return 0;
 }
 
-static int NCR53c406a_host_reset(Scsi_Cmnd * SCpnt)
+static int NCR53c406a_host_reset(struct scsi_cmnd * SCpnt)
 {
 	DEB(printk("NCR53c406a_reset called\n"));
 





