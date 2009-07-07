Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZGGOgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZGGOgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758459AbZGGOfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:35:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:42711 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758358AbZGGOfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:35:01 -0400
Subject: [PATCH 11/22] trivial: fix typo "has has" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:47:18 +0530
Message-Id: <1246976238.3613.27.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "has has" with "has" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/scsi/libiscsi_tcp.c |    2 +-
 include/linux/dmaengine.h   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e0746d..af99baf 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -545,7 +545,7 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
 	if (!rc) {
 		iscsi_conn_printk(KERN_ERR, conn, "Could not allocate R2T. "
 				  "Target has sent more R2Ts than it "
-				  "negotiated for or driver has has leaked.\n");
+				  "negotiated for or driver has leaked.\n");
 		return ISCSI_ERR_PROTO;
 	}
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index ffefba8..3e69257 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -74,7 +74,7 @@ enum dma_transaction_type {
  * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
  * 	this transaction
  * @DMA_CTRL_ACK - the descriptor cannot be reused until the client
- * 	acknowledges receipt, i.e. has has a chance to establish any
+ * 	acknowledges receipt, i.e. has a chance to establish any
  * 	dependency chains
  * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
  * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
-- 
1.6.0.6



