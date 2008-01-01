Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYAANvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYAANvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 08:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYAANtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 08:49:42 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37140 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbYAANtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 08:49:39 -0500
Date: Tue, 1 Jan 2008 15:49:24 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Shannon Nelson <shannon.nelson@intel.com>, dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 dma_async_memcpy_buf_to_buf()
Message-ID: <20080101134924.GR2360@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused dma_async_memcpy_buf_to_buf().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Aug 2007

 drivers/dma/dmaengine.c   |    2 ++
 include/linux/dmaengine.h |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

b91933344bed48adf2b64ca0f98c45b92ef69b79 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 8248992..f0cda56 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -459,6 +459,7 @@ void dma_async_device_unregister(struct dma_device *device)
 }
 EXPORT_SYMBOL(dma_async_device_unregister);
 
+#if 0
 /**
  * dma_async_memcpy_buf_to_buf - offloaded copy between virtual addresses
  * @chan: DMA channel to offload copy to
@@ -501,6 +502,7 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 	return cookie;
 }
 EXPORT_SYMBOL(dma_async_memcpy_buf_to_buf);
+#endif  /*  0  */
 
 /**
  * dma_async_memcpy_buf_to_pg - offloaded copy from address to page
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index a3b6035..75bdd65 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -302,8 +302,6 @@ struct dma_device {
 void dma_async_client_register(struct dma_client *client);
 void dma_async_client_unregister(struct dma_client *client);
 void dma_async_client_chan_request(struct dma_client *client);
-dma_cookie_t dma_async_memcpy_buf_to_buf(struct dma_chan *chan,
-	void *dest, void *src, size_t len);
 dma_cookie_t dma_async_memcpy_buf_to_pg(struct dma_chan *chan,
 	struct page *page, unsigned int offset, void *kdata, size_t len);
 dma_cookie_t dma_async_memcpy_pg_to_pg(struct dma_chan *chan,

