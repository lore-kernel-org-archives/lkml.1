Return-Path: <linux-kernel-owner+w=401wt.eu-S937728AbXFHIf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937728AbXFHIf2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763664AbXFHIfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:35:11 -0400
Received: from styx.suse.cz ([82.119.242.94]:57454 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763353AbXFHIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:35:10 -0400
Date: Fri, 8 Jun 2007 10:35:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] X86_64: fix wrong comment regarding set_fixmap()
Message-ID: <Pine.LNX.4.64.0706081034570.10204@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

X86_64: fix wrong comment regarding set_fixmap()
    
The function name is set_fixmap(), not fixmap_set() as stated in the comment.
    
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/include/asm-x86_64/fixmap.h b/include/asm-x86_64/fixmap.h
index e90e167..dfd7660 100644
--- a/include/asm-x86_64/fixmap.h
+++ b/include/asm-x86_64/fixmap.h
@@ -24,7 +24,7 @@
  *
  * these 'compile-time allocated' memory buffers are
  * fixed-size 4k pages. (or larger if used with an increment
- * highger than 1) use fixmap_set(idx,phys) to associate
+ * highger than 1) use set_fixmap(idx,phys) to associate
  * physical memory with fixmap indices.
  *
  * TLB entries of such buffers will not be flushed across
