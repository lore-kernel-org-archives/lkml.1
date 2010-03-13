Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935920Ab0CMVBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 16:01:10 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:35832 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935876Ab0CMVBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 16:01:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y3x8syhJP7uXEu2HAbrlzWYDtL0ex3Qf46/XgH2H46uDbCPsiUvg9lISwC0gbhS9Fc
         n3ZPnN7rCbpwWd7ULPPH2uWGadEGJqHiehglZqhspBwqCPx07tV1WFJ+aSNPKqTduTzo
         bglKU9WeuUos62AcOQYh+Md1KvDkTln9g/cj8=
From: Steven Harms <sjharms@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu, hjanssen@microsoft.com,
       haiyangz@microsoft.com, npalix@diku.dk
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       sharms@ubuntu.com
Subject: [PATCH] STAGING: hv: Update blkvsc_drive.c to remove spaces before newlines
Date: Sat, 13 Mar 2010 16:01:12 -0500
Message-Id: <1268514073-29212-1-git-send-email-sharms@ubuntu.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove warnings for newlines with spaces before them, as indicated by the checkpatch.pl tool.
Signed-off-by: Steven Harms <sharms@ubuntu.com>
---
 drivers/staging/hv/blkvsc_drv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index abeac12..345ce9e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -554,7 +554,7 @@ static int blkvsc_do_inquiry(struct block_device_context *blkdev)
 		blkdev->device_type = UNKNOWN_DEV_TYPE;
 	}

-	DPRINT_DBG(BLKVSC_DRV, "device type %d \n", device_type);
+	DPRINT_DBG(BLKVSC_DRV, "device type %d\n", device_type);

 	blkdev->device_id_len = buf[7];
 	if (blkdev->device_id_len > 64)
@@ -939,7 +939,7 @@ static int blkvsc_do_request(struct block_device_context *blkdev,
 	int pending = 0;
 	struct blkvsc_request_group *group = NULL;

-	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu \n", blkdev, req,
+	DPRINT_DBG(BLKVSC_DRV, "blkdev %p req %p sect %lu\n", blkdev, req,
 		  (unsigned long)blk_rq_pos(req));

 	/* Create a group to tie req to list of blkvsc_reqs */
@@ -1143,7 +1143,7 @@ static void blkvsc_request_completion(struct hv_storvsc_request *request)
 					 &blkvsc_req->group->blkvsc_req_list,
 					 req_entry) {
 			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld \n",
+				   "sect_start %lu sect_count %ld\n",
 				   comp_req,
 				   (unsigned long)comp_req->sector_start,
 				   comp_req->sector_count);
@@ -1197,7 +1197,7 @@ static int blkvsc_cancel_pending_reqs(struct block_device_context *blkdev)
 					 &pend_req->group->blkvsc_req_list,
 					 req_entry) {
 			DPRINT_DBG(BLKVSC_DRV, "completing blkvsc_req %p "
-				   "sect_start %lu sect_count %ld \n",
+				   "sect_start %lu sect_count %ld\n",
 				   comp_req,
 				   (unsigned long) comp_req->sector_start,
 				   comp_req->sector_count);
@@ -1275,7 +1275,7 @@ static void blkvsc_request(struct request_queue *queue)
 	struct request *req;
 	int ret = 0;

-	DPRINT_DBG(BLKVSC_DRV, "- enter \n");
+	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
 	while ((req = blk_peek_request(queue)) != NULL) {
 		DPRINT_DBG(BLKVSC_DRV, "- req %p\n", req);

--
1.6.3.3

