Return-Path: <linux-kernel-owner+w=401wt.eu-S1757470AbYCUNcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbYCUNcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 09:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYCUNcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 09:32:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39745 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753900AbYCUNcD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 09:32:03 -0400
Date: Fri, 21 Mar 2008 08:31:57 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, ak@suse.de, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - Increase max physical memory size of x86_64
Message-ID: <20080321133157.GA10911@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Increase the maximum physical address size of x86_64 system
to 44-bits. This is in preparation for future chips that
support larger physical memory sizes.

	Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 include/asm-x86/sparsemem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/include/asm-x86/sparsemem.h
===================================================================
--- linux.orig/include/asm-x86/sparsemem.h	2008-03-10 00:22:27.000000000 -0500
+++ linux/include/asm-x86/sparsemem.h	2008-03-11 14:46:29.000000000 -0500
@@ -26,8 +26,8 @@
 # endif
 #else /* CONFIG_X86_32 */
 # define SECTION_SIZE_BITS	27 /* matt - 128 is convenient right now */
-# define MAX_PHYSADDR_BITS	40
-# define MAX_PHYSMEM_BITS	40
+# define MAX_PHYSADDR_BITS	44
+# define MAX_PHYSMEM_BITS	44
 #endif
 
 #endif /* CONFIG_SPARSEMEM */
