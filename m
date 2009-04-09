Return-Path: <linux-kernel-owner+w=401wt.eu-S937344AbZDIXYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937344AbZDIXYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 19:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937295AbZDIXXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 19:23:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60339 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937248AbZDIXXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 19:23:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, sam@ravnborg.org, linux-kernel@vger.kernel.org
Date: Fri, 10 Apr 2009 00:21:52 +0100
Message-ID: <20090409232152.13220.28141.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm-frv/pgtable.h could just #include <asm-generic/pgtable.h> in NOMMU mode
rather than #defining macros for lazy MMU and CPU stuff.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 include/asm-frv/pgtable.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index e16fdb1..3323301 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -71,10 +71,8 @@ static inline int pte_file(pte_t pte) { return 0; }
 #define swapper_pg_dir		((pgd_t *) NULL)
 
 #define pgtable_cache_init()		do {} while (0)
-#define arch_enter_lazy_mmu_mode()	do {} while (0)
-#define arch_leave_lazy_mmu_mode()	do {} while (0)
-#define arch_enter_lazy_cpu_mode()	do {} while (0)
-#define arch_leave_lazy_cpu_mode()	do {} while (0)
+
+#include <asm-generic/pgtable.h>
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/

