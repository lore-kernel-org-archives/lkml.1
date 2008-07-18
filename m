Return-Path: <linux-kernel-owner+w=401wt.eu-S1758746AbYGRPic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746AbYGRPic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 11:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbYGRPiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 11:38:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:29087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754895AbYGRPiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 11:38:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,210,1215414000"; 
   d="scan'208";a="419373140"
From: Maciej Sosnowski <maciej.sosnowski@intel.com>
Subject: [PATCH v2 2/4] I/OAT: Increase sleep time in ioat_dma_self_test
To: dan.j.williams@intel.com
Cc: shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Date: Fri, 18 Jul 2008 17:28:30 +0200
Message-ID: <20080718152801.21235.80935.stgit@linux.site>
In-Reply-To: <20080718152541.21235.85961.stgit@linux.site>
References: <20080718152541.21235.85961.stgit@linux.site>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sleep time in self_test has been increased to 10ms
since in some cases 1ms appeared not to be enough.

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
---

 drivers/dma/ioat_dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/ioat_dma.c b/drivers/dma/ioat_dma.c
index f1d6382..2fe3aac 100644
--- a/drivers/dma/ioat_dma.c
+++ b/drivers/dma/ioat_dma.c
@@ -1331,7 +1331,7 @@ static int ioat_dma_self_test(struct ioa
 		goto free_resources;
 	}
 	device->common.device_issue_pending(dma_chan);
-	msleep(1);
+	msleep(10);
 
 	if (device->common.device_is_tx_complete(dma_chan, cookie, NULL, NULL)
 					!= DMA_SUCCESS) {

