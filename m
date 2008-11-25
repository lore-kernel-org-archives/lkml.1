Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbYKYOI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbYKYOI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 09:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYKYOIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 09:08:21 -0500
Received: from ryu.zarb.org ([212.85.158.22]:35890 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbYKYOIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 09:08:21 -0500
Subject: [PATCH] Fix comment on #endif
From: Pascal Terjan <pterjan@mandriva.com>
To: linux-mm@kvack.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Mandriva
Date: Tue, 25 Nov 2008 15:08:19 +0100
Message-Id: <1227622099.15127.8.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.1-1mdv2009.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This #endif in slab.h is described as closing the inner block while it's for 
the big CONFIG_NUMA one. That makes reading the code a bit harder.

This trivial patch fixes the comment.

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
---
 include/linux/slab.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 000da12..9d8ca14 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -285,7 +285,7 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, void *);
 #define kmalloc_node_track_caller(size, flags, node) \
 	kmalloc_track_caller(size, flags)
 
-#endif /* DEBUG_SLAB */
+#endif /* CONFIG_NUMA */
 
 /*
  * Shortcuts
-- 
1.6.0.4

