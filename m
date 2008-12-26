Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYLZRLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYLZRLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 12:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbYLZRLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 12:11:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:34870 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752880AbYLZRLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 12:11:05 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18Ql9gUcjcQWzDmjZ9kVi71UMvKWdDVLhnlnrU6W9
	tvjPGPTDUKAsDz
Date: Fri, 26 Dec 2008 18:11:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/4 v6] dmaengine: add async_tx_clear_ack() macro
In-Reply-To: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
Message-ID: <Pine.LNX.4.64.0812261720240.4895@axis700.grange>
References: <Pine.LNX.4.64.0812261714290.4895@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <lg@denx.de>

To complete the DMA_CTRL_ACK handling API add a async_tx_clear_ack() macro.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

No change since v2

 include/linux/dmaengine.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 64dea2a..c820a3f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -287,6 +287,11 @@ static inline void async_tx_ack(struct dma_async_tx_descriptor *tx)
 	tx->flags |= DMA_CTRL_ACK;
 }
 
+static inline void async_tx_clear_ack(struct dma_async_tx_descriptor *tx)
+{
+	tx->flags &= ~DMA_CTRL_ACK;
+}
+
 static inline bool async_tx_test_ack(struct dma_async_tx_descriptor *tx)
 {
 	return (tx->flags & DMA_CTRL_ACK) == DMA_CTRL_ACK;
-- 
1.5.4

