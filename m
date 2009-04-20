Return-Path: <linux-kernel-owner+w=401wt.eu-S1759357AbZDTW2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759357AbZDTW2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZDTWUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:20:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37309 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759AbZDTWUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:20:30 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 24/25] Re-sort GFP flags and fix whitespace alignment for easier reading.
Date: Mon, 20 Apr 2009 23:20:10 +0100
Message-Id: <1240266011-11140-25-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resort the GFP flags after __GFP_MOVABLE got redefined so how the bits
are used are a bit cleared.

From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 include/linux/gfp.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index c7429b8..cfc1dd3 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -47,11 +47,11 @@ struct vm_area_struct;
 #define __GFP_NORETRY	((__force gfp_t)0x1000u)/* See above */
 #define __GFP_COMP	((__force gfp_t)0x4000u)/* Add compound page metadata */
 #define __GFP_ZERO	((__force gfp_t)0x8000u)/* Return zeroed page on success */
-#define __GFP_NOMEMALLOC ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
-#define __GFP_HARDWALL   ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
-#define __GFP_THISNODE	((__force gfp_t)0x40000u)/* No fallback, no policies */
+#define __GFP_NOMEMALLOC  ((__force gfp_t)0x10000u) /* Don't use emergency reserves */
+#define __GFP_HARDWALL    ((__force gfp_t)0x20000u) /* Enforce hardwall cpuset memory allocs */
+#define __GFP_THISNODE	  ((__force gfp_t)0x40000u) /* No fallback, no policies */
 #define __GFP_RECLAIMABLE ((__force gfp_t)0x80000u) /* Page is reclaimable */
-#define __GFP_MOVABLE	((__force gfp_t)0x100000u)  /* Page is movable */
+#define __GFP_MOVABLE	  ((__force gfp_t)0x100000u)/* Page is movable */
 
 #define __GFP_BITS_SHIFT 21	/* Room for 21 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
-- 
1.5.6.5

