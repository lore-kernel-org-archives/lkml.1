Return-Path: <linux-kernel-owner+w=401wt.eu-S936419AbZDIQoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936419AbZDIQoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 12:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935914AbZDIQe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 12:34:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59181 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935940AbZDIQel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 12:34:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] FRV: Use <asm-generic/pgtable.h> in NOMMU mode
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, sam@ravnborg.org, linux-kernel@vger.kernel.org
Date: Thu, 09 Apr 2009 17:32:55 +0100
Message-ID: <20090409163255.22778.39921.stgit@warthog.procyon.org.uk>
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

