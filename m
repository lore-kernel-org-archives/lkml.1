Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZBWLzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZBWLzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 06:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbZBWLzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 06:55:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:50465 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbZBWLzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 06:55:31 -0500
Subject: [PATCH] mm: clean up __GFP_* flags a bit
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
In-Reply-To: <1235344649-18265-5-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
	 <1235344649-18265-5-git-send-email-mel@csn.ul.ie>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 12:55:01 +0100
Message-Id: <1235390101.4645.79.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: mm: clean up __GFP_* flags a bit
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Feb 23 12:28:33 CET 2009

re-sort them and poke at some whitespace alignment for easier reading.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/gfp.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h
+++ linux-2.6/include/linux/gfp.h
@@ -25,6 +25,8 @@ struct vm_area_struct;
 #define __GFP_HIGHMEM	((__force gfp_t)0x02u)
 #define __GFP_DMA32	((__force gfp_t)0x04u)
 
+#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
+
 /*
  * Action modifiers - doesn't change the zoning
  *
@@ -50,16 +52,15 @@ struct vm_area_struct;
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
-#define __GFP_MOVABLE	((__force gfp_t)0x08u)  /* Page is movable */
 
 #ifdef CONFIG_KMEMCHECK
-#define __GFP_NOTRACK	((__force gfp_t)0x200000u)  /* Don't track with kmemcheck */
+#define __GFP_NOTRACK	  ((__force gfp_t)0x100000u) /* Don't track with kmemcheck */
 #else
-#define __GFP_NOTRACK	((__force gfp_t)0)
+#define __GFP_NOTRACK	  ((__force gfp_t)0)
 #endif
 
 #define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */


