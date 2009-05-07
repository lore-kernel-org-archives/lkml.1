Return-Path: <linux-kernel-owner+w=401wt.eu-S1761751AbZEGBuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761751AbZEGBuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 21:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761523AbZEGBuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 21:50:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:5959 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761399AbZEGBuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 21:50:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,305,1239001200"; 
   d="scan'208";a="140041780"
Message-Id: <20090507014914.492422232@intel.com>
References: <20090507012116.996644836@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 07 May 2009 09:21:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Wu Fengguang <fengguang.wu@intel.com>
Cc: Matt Mackall <mpm@selenic.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andi Kleen <andi@firstfloor.org>, <linux-mm@kvack.org>
Subject: [PATCH 5/7] pagemap: document clarifications
Content-Disposition: inline; filename=kpageflags-doc-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bit ranges were inclusive and some not.
Fix them to be consistently inclusive.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/pagemap.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux.orig/Documentation/vm/pagemap.txt
+++ linux/Documentation/vm/pagemap.txt
@@ -12,9 +12,9 @@ There are three components to pagemap:
    value for each virtual page, containing the following data (from
    fs/proc/task_mmu.c, above pagemap_read):
 
-    * Bits 0-55  page frame number (PFN) if present
+    * Bits 0-54  page frame number (PFN) if present
     * Bits 0-4   swap type if swapped
-    * Bits 5-55  swap offset if swapped
+    * Bits 5-54  swap offset if swapped
     * Bits 55-60 page shift (page size = 1<<page shift)
     * Bit  61    reserved for future use
     * Bit  62    page swapped
@@ -36,7 +36,7 @@ There are three components to pagemap:
  * /proc/kpageflags.  This file contains a 64-bit set of flags for each
    page, indexed by PFN.
 
-   The flags are (from fs/proc/proc_misc, above kpageflags_read):
+   The flags are (from fs/proc/page.c, above kpageflags_read):
 
      0. LOCKED
      1. ERROR

-- 

