Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbXFLLHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbXFLLHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 07:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXFLLHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 07:07:23 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60558 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbXFLLHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 07:07:22 -0400
Date: Tue, 12 Jun 2007 13:07:33 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-kernel@vger.kernel.org
Subject: [-mm patch] #if 0 mm/backing-dev.c:congestion_wait_interruptible()
Message-ID: <20070612110733.GU3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

congestion_wait_interruptible() is no longer used.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 include/linux/backing-dev.h |    1 -
 mm/backing-dev.c            |    2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.22-rc4-mm2/include/linux/backing-dev.h.old	2007-06-12 01:21:52.000000000 +0200
+++ linux-2.6.22-rc4-mm2/include/linux/backing-dev.h	2007-06-12 01:22:00.000000000 +0200
@@ -93,7 +93,6 @@
 void clear_bdi_congested(struct backing_dev_info *bdi, int rw);
 void set_bdi_congested(struct backing_dev_info *bdi, int rw);
 long congestion_wait(int rw, long timeout);
-long congestion_wait_interruptible(int rw, long timeout);
 void congestion_end(int rw);
 
 #define bdi_cap_writeback_dirty(bdi) \
--- linux-2.6.22-rc4-mm2/mm/backing-dev.c.old	2007-06-12 01:22:07.000000000 +0200
+++ linux-2.6.22-rc4-mm2/mm/backing-dev.c	2007-06-12 01:22:25.000000000 +0200
@@ -55,6 +55,7 @@
 }
 EXPORT_SYMBOL(congestion_wait);
 
+#if 0
 long congestion_wait_interruptible(int rw, long timeout)
 {
 	long ret;
@@ -70,6 +71,7 @@
 	return ret;
 }
 EXPORT_SYMBOL(congestion_wait_interruptible);
+#endif  /*  0  */
 
 /**
  * congestion_end - wake up sleepers on a congested backing_dev_info

