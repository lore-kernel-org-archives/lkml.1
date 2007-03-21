Return-Path: <linux-kernel-owner+w=401wt.eu-S933165AbXCURqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933165AbXCURqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 13:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933100AbXCURp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 13:45:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43173 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933236AbXCURp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 13:45:59 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix unannotated variable declarations
To: torvalds@osdl.org, akpm@osdl.org, y-goto@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Wed, 21 Mar 2007 17:06:59 +0000
Message-ID: <20070321170659.21330.93301.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Fix unannotated variable declarations.  Variables that have allocation section
annotations (such as __meminitdata) on their definitions must also have them on
their declarations as not doing so may affect the addressing mode used by the
compiler and may result in a linker error.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/linux/bootmem.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 2275f27..81c07cd 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -108,7 +108,7 @@ static inline void *alloc_remap(int nid, unsigned long size)
 #endif /* CONFIG_HAVE_ARCH_ALLOC_REMAP */
 
 extern unsigned long __meminitdata nr_kernel_pages;
-extern unsigned long nr_all_pages;
+extern unsigned long __meminitdata nr_all_pages;
 
 extern void *alloc_large_system_hash(const char *tablename,
 				     unsigned long bucketsize,

