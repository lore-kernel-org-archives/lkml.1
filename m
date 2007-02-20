Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbXBTTRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbXBTTRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXBTTRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:17:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbXBTTRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:17:48 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Add some missng lazy MMU hooks for NOMMU mode
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com
Date: Tue, 20 Feb 2007 19:17:37 +0000
Message-ID: <20070220191737.19376.95782.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Add some missing lazy MMU hooks for NOMMU mode.

Signed-Off-By: David Howells <dhowells@redhat.com>
---

 include/asm-frv/pgtable.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/include/asm-frv/pgtable.h b/include/asm-frv/pgtable.h
index ba1b37d..8a05aa1 100644
--- a/include/asm-frv/pgtable.h
+++ b/include/asm-frv/pgtable.h
@@ -70,7 +70,11 @@ static inline int pte_file(pte_t pte) { return 0; }
 
 #define swapper_pg_dir		((pgd_t *) NULL)
 
-#define pgtable_cache_init()	do {} while(0)
+#define pgtable_cache_init()		do {} while (0)
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/
