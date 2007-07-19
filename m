Return-Path: <linux-kernel-owner+w=401wt.eu-S938243AbXGSN4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938243AbXGSN4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937200AbXGSNsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:46 -0400
Received: from ns2.suse.de ([195.135.220.15]:48619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763272AbXGSNsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:45 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: jkosina@suse.cz, ak@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [15/48] x86_64: fix wrong comment regarding set_fixmap()
Message-Id: <20070719134844.85E3614E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:44 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jiri Kosina <jkosina@suse.cz>

The function name is set_fixmap(), not fixmap_set() as stated in the comment.

Also fix a typo, punctuation and lower/uppercase a bit.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 include/asm-x86_64/fixmap.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/include/asm-x86_64/fixmap.h
===================================================================
--- linux.orig/include/asm-x86_64/fixmap.h
+++ linux/include/asm-x86_64/fixmap.h
@@ -22,9 +22,9 @@
  * compile time, but to set the physical address only
  * in the boot process.
  *
- * these 'compile-time allocated' memory buffers are
- * fixed-size 4k pages. (or larger if used with an increment
- * highger than 1) use fixmap_set(idx,phys) to associate
+ * These 'compile-time allocated' memory buffers are
+ * fixed-size 4k pages (or larger if used with an increment
+ * higher than 1). Use set_fixmap(idx,phys) to associate
  * physical memory with fixmap indices.
  *
  * TLB entries of such buffers will not be flushed across
