Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0CKXL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 18:11:27 -0500
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:43514 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0CKXLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 18:11:25 -0500
X-Greylist: delayed 1168 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Mar 2010 18:11:25 EST
X-SMTPAUTH-B2: 
X-SENDER-IP: 83.226.250.189
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ako1AKMCmUtT4vq9PGdsb2JhbACHYZMBDAEBAQE3La57jXSEewQ
X-IronPort-AV: E=Sophos;i="4.49,622,1262559600"; 
   d="scan'208";a="49162275"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com
Cc: devel@driverdev.osusl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH 2/2] staging: hv: trivial whitespace fixes found by checkpatch.pl Signed-off-by: Lars Lindley <lindley@coyote.org>
Date: Thu, 11 Mar 2010 23:51:23 +0100
Message-Id: <1268347883-20969-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/hv/Connection.c  |    4 ++--
 drivers/staging/hv/NetVsc.c      |    4 ++--
 drivers/staging/hv/RingBuffer.c  |    2 +-
 drivers/staging/hv/StorVsc.c     |    4 ++--
 drivers/staging/hv/VersionInfo.h |    4 ++--
 drivers/staging/hv/blkvsc_drv.c  |   10 +++++-----
 drivers/staging/hv/rndis.h       |    2 +-
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 drivers/staging/hv/vmbus_drv.c   |   14 +++++++-------
 9 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/hv/Connection.c b/drivers/staging/hv/Connection.c
index 43c2e68..2696356 100644
--- a/drivers/staging/hv/Connection.c
+++ b/drivers/staging/hv/Connection.c
@@ -258,8 +258,8 @@ static void VmbusProcessChannelEvent(void *context)
 		VmbusChannelOnChannelEvent(channel);
 		/*
 		 * WorkQueueQueueWorkItem(channel->dataWorkQueue,
-		 * 			  VmbusChannelOnChannelEvent,
-		 * 			  (void*)channel);
+		 *			  VmbusChannelOnChannelEvent,
+		 *			  (void*)channel);
 		 */
 	} else {
 		DPRINT_ERR(VMBUS, "channel not found for relid - %d.", relId);
diff --git a/drivers/staging/hv/NetVsc.c b/drivers/staging/hv/NetVsc.c
index 1c717f9..e57b70f 100644
--- a/drivers/staging/hv/NetVsc.c
+++ b/drivers/staging/hv/NetVsc.c
@@ -1086,7 +1086,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 	}
 
 	/* Remove the 1st packet to represent the xfer page packet itself */
-	xferpagePacket = (struct xferpage_packet*)listHead.next;
+	xferpagePacket = (struct xferpage_packet *)listHead.next;
 	list_del(&xferpagePacket->ListEntry);
 
 	/* This is how much we can satisfy */
@@ -1102,7 +1102,7 @@ static void NetVscOnReceive(struct hv_device *Device,
 
 	/* Each range represents 1 RNDIS pkt that contains 1 ethernet frame */
 	for (i = 0; i < (count - 1); i++) {
-		netvscPacket = (struct hv_netvsc_packet*)listHead.next;
+		netvscPacket = (struct hv_netvsc_packet *)listHead.next;
 		list_del(&netvscPacket->ListEntry);
 
 		/* Initialize the netvsc packet */
diff --git a/drivers/staging/hv/RingBuffer.c b/drivers/staging/hv/RingBuffer.c
index 80b8a2c..08b3c55 100644
--- a/drivers/staging/hv/RingBuffer.c
+++ b/drivers/staging/hv/RingBuffer.c
@@ -32,7 +32,7 @@
 
 
 /* Amount of space to write to */
-#define BYTES_AVAIL_TO_WRITE(r, w, z) ((w) >= (r))?((z) - ((w) - (r))):((r) - (w))
+#define BYTES_AVAIL_TO_WRITE(r, w, z) ((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w))
 
 
 /*++
diff --git a/drivers/staging/hv/StorVsc.c b/drivers/staging/hv/StorVsc.c
index 38ea140..20413b1 100644
--- a/drivers/staging/hv/StorVsc.c
+++ b/drivers/staging/hv/StorVsc.c
@@ -553,7 +553,7 @@ static int StorVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 
 	/* Save the channel properties to our storvsc channel */
 	/* props = (struct vmstorage_channel_properties *)
-	 * 		channel->offerMsg.Offer.u.Standard.UserDefined; */
+	 *		channel->offerMsg.Offer.u.Standard.UserDefined; */
 
 	/* FIXME: */
 	/*
@@ -716,7 +716,7 @@ static int StorVscOnIORequest(struct hv_device *Device,
 	}
 
 	/* print_hex_dump_bytes("", DUMP_PREFIX_NONE, Request->Cdb,
-	 * 			Request->CdbLen); */
+	 *			Request->CdbLen); */
 
 	requestExtension->Request = Request;
 	requestExtension->Device  = Device;
diff --git a/drivers/staging/hv/VersionInfo.h b/drivers/staging/hv/VersionInfo.h
index 10d7b19..82e74b1 100644
--- a/drivers/staging/hv/VersionInfo.h
+++ b/drivers/staging/hv/VersionInfo.h
@@ -29,11 +29,11 @@
  *
  * Definition of versioning is as follows;
  *
- * 	Major Number 	Changes for these scenarios;
+ *	Major Number	Changes for these scenarios;
  *			1.	When a new version of Windows Hyper-V
  *				is released.
  *			2.	A Major change has occurred in the
- *			       	Linux IC's.
+ *				Linux IC's.
  *			(For example the merge for the first time
  *			into the kernel) Every time the Major Number
  *			changes, the Revision number is reset to 0.
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
 
diff --git a/drivers/staging/hv/rndis.h b/drivers/staging/hv/rndis.h
index 7c73277..723e1f1 100644
--- a/drivers/staging/hv/rndis.h
+++ b/drivers/staging/hv/rndis.h
@@ -622,7 +622,7 @@ struct rndis_message {
 /* get the size of an RNDIS message. Pass in the message type, */
 /* struct rndis_set_request, struct rndis_packet for example */
 #define RNDIS_MESSAGE_SIZE(Message)				\
-	(sizeof(Message) + (sizeof(struct rndis_message) - 	\
+	(sizeof(Message) + (sizeof(struct rndis_message) -	\
 	 sizeof(union rndis_message_container)))
 
 /* get pointer to info buffer with message pointer */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 3988f4b..9f815ef 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -111,7 +111,7 @@ static struct scsi_host_template scsi_driver = {
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		1,
 	/* 64 max_queue * 1 target */
-	.can_queue = 		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
+	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
 	/* currently 32 */
@@ -766,7 +766,7 @@ static int storvsc_queuecommand(struct scsi_cmnd *scmnd,
 		request->DataBuffer.Offset = sgl[0].offset;
 
 		for (i = 0; i < scsi_sg_count(scmnd); i++) {
-			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d \n",
+			DPRINT_DBG(STORVSC_DRV, "sgl[%d] len %d offset %d\n",
 				   i, sgl[i].length, sgl[i].offset);
 			request->DataBuffer.PfnArray[i] =
 					page_to_pfn(sg_page((&sgl[i])));
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 2c90619..cab1312 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -236,13 +236,13 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  * vmbus_bus_init -Main vmbus driver initialization routine.
  *
  * Here, we
- * 	- initialize the vmbus driver context
- * 	- setup various driver entry points
- * 	- invoke the vmbus hv main init routine
- * 	- get the irq resource
- * 	- invoke the vmbus to add the vmbus root device
- * 	- setup the vmbus root device
- * 	- retrieve the channel offers
+ *	- initialize the vmbus driver context
+ *	- setup various driver entry points
+ *	- invoke the vmbus hv main init routine
+ *	- get the irq resource
+ *	- invoke the vmbus to add the vmbus root device
+ *	- setup the vmbus root device
+ *	- retrieve the channel offers
  */
 static int vmbus_bus_init(int (*drv_init)(struct hv_driver *drv))
 {
-- 
1.7.0.2

