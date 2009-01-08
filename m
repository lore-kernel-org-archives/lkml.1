Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZAHSEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZAHSEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbZAHSEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:04:14 -0500
Received: from mail.gmx.net ([213.165.64.20]:35020 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755444AbZAHSEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:04:12 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18UQNdiQZIU8GyZAszS1D6n6ih6bG790GlRi3VGQa
	YQ0YVcx7XP4pvq
Date: Thu, 8 Jan 2009 19:04:25 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-arm-kernel@lists.arm.linux.org.uk
cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Dan Williams <dan.j.williams@intel.com>,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 v8] dmaengine: add async_tx_clear_ack() macro
In-Reply-To: <Pine.LNX.4.64.0901081850280.6387@axis700.grange>
Message-ID: <Pine.LNX.4.64.0901081856020.6387@axis700.grange>
References: <Pine.LNX.4.64.0901081850280.6387@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <lg@denx.de>

To complete the DMA_CTRL_ACK handling API add a async_tx_clear_ack() macro.

Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
---

No change. Here for completeness.

 include/linux/dmaengine.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index adb0b08..bd76c01 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -380,6 +380,11 @@ static inline void async_tx_ack(struct dma_async_tx_descriptor *tx)
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

