Return-Path: <linux-kernel-owner+w=401wt.eu-S1753873AbXDNV21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbXDNV21 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbXDNVVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:13 -0400
Received: from gw.goop.org ([64.81.55.164]:59567 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbXDNVU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:28 -0400
Message-Id: <20070414204924.424081934@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 14/28] fix paravirt-documentation
Content-Disposition: inline; filename=paravirt-fix-paravirt_lazy.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove #defines, add enum for PARAVIRT_LAZY_FLUSH.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 include/asm-i386/paravirt.h |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -30,6 +30,7 @@ enum paravirt_lazy_mode {
 	PARAVIRT_LAZY_NONE = 0,
 	PARAVIRT_LAZY_MMU = 1,
 	PARAVIRT_LAZY_CPU = 2,
+	PARAVIRT_LAZY_FLUSH = 3,
 };
 
 struct paravirt_ops
@@ -906,12 +907,6 @@ static inline void set_pmd(pmd_t *pmdp, 
 }
 #endif	/* CONFIG_X86_PAE */
 
-/* Lazy mode for batching updates / context switch */
-#define PARAVIRT_LAZY_NONE 0
-#define PARAVIRT_LAZY_MMU  1
-#define PARAVIRT_LAZY_CPU  2
-#define PARAVIRT_LAZY_FLUSH 3
-
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
 static inline void arch_enter_lazy_cpu_mode(void)
 {

-- 

