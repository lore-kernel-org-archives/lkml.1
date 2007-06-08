Return-Path: <linux-kernel-owner+w=401wt.eu-S967517AbXFHIxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967517AbXFHIxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932730AbXFHIwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:52:54 -0400
Received: from styx.suse.cz ([82.119.242.94]:58236 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935906AbXFHIwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:52:53 -0400
Date: Fri, 8 Jun 2007 10:53:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] X86_64: fix wrong comment regarding set_fixmap()
In-Reply-To: <20070608104803.3dfe7955.dada1@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0706081052310.10204@jikos.suse.cz>
References: <Pine.LNX.4.64.0706081034570.10204@jikos.suse.cz>
 <20070608104803.3dfe7955.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Eric Dumazet wrote:

> Why not taking the opportunity of spelling fix  ( highger -> higher ) ?

I missed that one, thanks. Andi, could you please take the one below 
instead? Thanks.

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
