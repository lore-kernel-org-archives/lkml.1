Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXBTAT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXBTAT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXBTAHM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:07:12 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36036 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750938AbXBTAGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:06:49 -0500
Date: Tue, 20 Feb 2007 01:06:49 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] drivers/char/drm/drm_mm.c: remove unused exports
Message-ID: <20070220000649.GJ13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes two unused exports.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 11 Jan 2007
- 21 Nov 2006

--- linux-2.6.19-rc5-mm2/drivers/char/drm/drm_mm.c.old	2006-11-21 20:08:02.000000000 +0100
+++ linux-2.6.19-rc5-mm2/drivers/char/drm/drm_mm.c	2006-11-21 20:09:19.000000000 +0100
@@ -177,8 +177,6 @@
 	return 0;
 }
 
-EXPORT_SYMBOL(drm_mm_init);
-
 void drm_mm_takedown(drm_mm_t * mm)
 {
 	struct list_head *bnode = mm->root_node.fl_entry.next;
@@ -197,5 +195,3 @@
 
 	drm_free(entry, sizeof(*entry), DRM_MEM_MM);
 }
-
-EXPORT_SYMBOL(drm_mm_takedown);


