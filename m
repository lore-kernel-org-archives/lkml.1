Return-Path: <linux-kernel-owner+w=401wt.eu-S965576AbXBTACp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbXBTACp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:02:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965584AbXBTACk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:02:40 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35995 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965576AbXBTACO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:02:14 -0500
Date: Tue, 20 Feb 2007 01:02:13 +0100
From: Adrian Bunk <bunk@stusta.de>
To: "Michael S. Tsirkin" <mst@mellanox.co.il>,
       Roland Dreier <rolandd@cisco.com>
Cc: mshefty@ichips.intel.com, halr@voltaire.com, openib-general@openib.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] infiniband/hw/mthca/mthca_mr.c: make 2 functions static
Message-ID: <20070220000213.GA13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes two needlessly global functions static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/infiniband/hw/mthca/mthca_mr.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.20-mm1/drivers/infiniband/hw/mthca/mthca_mr.c.old	2007-02-17 17:41:39.000000000 +0100
+++ linux-2.6.20-mm1/drivers/infiniband/hw/mthca/mthca_mr.c	2007-02-17 17:42:22.000000000 +0100
@@ -310,8 +310,9 @@
 	return mthca_is_memfree(dev) ? (PAGE_SIZE / sizeof (u64)) : 0x7ffffff;
 }
 
-void mthca_tavor_write_mtt_seg(struct mthca_dev *dev, struct mthca_mtt *mtt,
-			      int start_index, u64 *buffer_list, int list_len)
+static void mthca_tavor_write_mtt_seg(struct mthca_dev *dev,
+				      struct mthca_mtt *mtt, int start_index,
+				      u64 *buffer_list, int list_len)
 {
 	u64 __iomem *mtts;
 	int i;
@@ -323,8 +324,9 @@
 				  mtts + i);
 }
 
-void mthca_arbel_write_mtt_seg(struct mthca_dev *dev, struct mthca_mtt *mtt,
-			      int start_index, u64 *buffer_list, int list_len)
+static void mthca_arbel_write_mtt_seg(struct mthca_dev *dev,
+				      struct mthca_mtt *mtt, int start_index,
+				      u64 *buffer_list, int list_len)
 {
 	__be64 *mtts;
 	dma_addr_t dma_handle;

