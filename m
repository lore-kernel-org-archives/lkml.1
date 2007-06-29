Return-Path: <linux-kernel-owner+w=401wt.eu-S932573AbXF2BOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573AbXF2BOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 21:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764917AbXF2BOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 21:14:17 -0400
Received: from styx.suse.cz ([82.119.242.94]:43694 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764390AbXF2BOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 21:14:17 -0400
Date: Fri, 29 Jun 2007 03:17:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] [RESEND] X86_64: fix wrong comment regarding
 set_fixmap()
Message-ID: <Pine.LNX.4.64.0706290312050.11634@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ resend, it seems to have been lost in time, lost in space ]


From: Jiri Kosina <jkosina@suse.cz>

X86_64: fix wrong comment regarding set_fixmap()
    
The function name is set_fixmap(), not fixmap_set() as stated in the comment.
    
Also fix a typo, punctuation and lower/uppercase a bit.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/include/asm-x86_64/fixmap.h b/include/asm-x86_64/fixmap.h
index e90e167..c3574e5 100644
--- a/include/asm-x86_64/fixmap.h
+++ b/include/asm-x86_64/fixmap.h
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
