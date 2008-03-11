Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbYCKJoy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbYCKJoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:44:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYCKJoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:44:46 -0400
Received: from www.tglx.de ([62.245.132.106]:59237 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbYCKJoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:44:46 -0400
Date: Tue, 11 Mar 2008 10:44:29 +0100
From: Sebastian Siewior <bigeasy@tglx.de>
To: Jesper Juhl <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [DMA ENGINE] typo fixes
Message-ID: <20080311094429.GB9656@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 drivers/dma/dmaengine.c   |    6 +++---
 include/linux/dmaengine.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 2996523..1299d43 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -42,9 +42,9 @@
  *
  * Each device has a kref, which is initialized to 1 when the device is
  * registered. A kref_get is done for each device registered.  When the
- * device is released, the coresponding kref_put is done in the release
+ * device is released, the corresponding kref_put is done in the release
  * method. Every time one of the device's channels is allocated to a client,
- * a kref_get occurs.  When the channel is freed, the coresponding kref_put
+ * a kref_get occurs.  When the channel is freed, the corresponding kref_put
  * happens. The device's release function does a completion, so
  * unregister_device does a remove event, device_unregister, a kref_put
  * for the first reference, then waits on the completion for all other
@@ -53,7 +53,7 @@
  * Each channel has an open-coded implementation of Rusty Russell's "bigref,"
  * with a kref and a per_cpu local_t.  A dma_chan_get is called when a client
  * signals that it wants to use a channel, and dma_chan_put is called when
- * a channel is removed or a client using it is unregesitered.  A client can
+ * a channel is removed or a client using it is unregistered.  A client can
  * take extra references per outstanding transaction, as is the case with
  * the NET DMA client.  The release function does a kref_put on the device.
  *	-ChrisL, DanW
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 261e43a..8b2481f 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -398,7 +398,7 @@ static inline enum dma_status dma_async_is_tx_complete(struct dma_chan *chan,
  * @last_used: last cookie value handed out
  *
  * dma_async_is_complete() is used in dma_async_memcpy_complete()
- * the test logic is seperated for lightweight testing of multiple cookies
+ * the test logic is separated for lightweight testing of multiple cookies
  */
 static inline enum dma_status dma_async_is_complete(dma_cookie_t cookie,
 			dma_cookie_t last_complete, dma_cookie_t last_used)
-- 
1.5.4.3

