Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXHVDt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXHVDt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbXHVDtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:49:10 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:23568 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbXHVDtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:49:08 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 1/11 RESEND] cxgb3 - Update rx coalescing length
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 21 Aug 2007 20:49:05 -0700
Message-ID: <20070822034905.9260.77225.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Reduce Rx coalescing length to 12288
Large bursts from the adapter to the host create back pressure
on the chip. Reducing the burst size avoids the issue.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/common.h b/drivers/net/cxgb3/common.h
index c46c249..55922ed 100644
--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -104,7 +104,7 @@ enum {
 	PROTO_SRAM_LINES = 128, /* size of TP sram */
 };
 
-#define MAX_RX_COALESCING_LEN 16224U
+#define MAX_RX_COALESCING_LEN 12288U
 
 enum {
 	PAUSE_RX = 1 << 0,
