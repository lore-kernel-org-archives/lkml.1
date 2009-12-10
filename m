Return-Path: <linux-kernel-owner+w=401wt.eu-S1761345AbZLJRfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761345AbZLJRfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761324AbZLJRez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:34:55 -0500
Received: from mail.gmx.net ([213.165.64.20]:39867 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761325AbZLJRet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:34:49 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/rUHVhtYDrMFc+j9pmqd1259WVV0YdJ6NhLokfih
	8c/COW4VHKU1d+
Date: Thu, 10 Dec 2009 18:35:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 3/3] dmaengine: clarify the meaning of the DMA_CTRL_ACK flag
In-Reply-To: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
Message-ID: <Pine.LNX.4.64.0912101833520.4487@axis700.grange>
References: <Pine.LNX.4.64.0912101826010.4487@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA_CTRL_ACK's description applies to its clear state, not to its set state.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 include/linux/dmaengine.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 2b9f2ac..7878498 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -74,7 +74,7 @@ enum dma_transaction_type {
  *  control completion, and communicate status.
  * @DMA_PREP_INTERRUPT - trigger an interrupt (callback) upon completion of
  *  this transaction
- * @DMA_CTRL_ACK - the descriptor cannot be reused until the client
+ * @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the client
  *  acknowledges receipt, i.e. has has a chance to establish any dependency
  *  chains
  * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
-- 
1.6.2.4

