Return-Path: <linux-kernel-owner+w=401wt.eu-S1030332AbXDNV3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030332AbXDNV3k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXDNVVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:05 -0400
Received: from gw.goop.org ([64.81.55.164]:59579 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbXDNVUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:22 -0400
Message-Id: <20070414204925.334896811@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:20 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 26/28] From: Andrew Morton <akpm@linux-foundation.org>
Content-Disposition: inline; filename=rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64:

arch/x86_64/kernel/../../i386/kernel/alternative.c: In function 'alternative_instructions':
arch/x86_64/kernel/../../i386/kernel/alternative.c:374: error: '__parainstructions' undeclared (first use in this function)
arch/x86_64/kernel/../../i386/kernel/alternative.c:374: error: (Each undeclared identifier is reported only once
arch/x86_64/kernel/../../i386/kernel/alternative.c:374: error: for each function it appears in.)
arch/x86_64/kernel/../../i386/kernel/alternative.c:374: error: '__parainstructions_end' undeclared (first use in this function)

Cc: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/asm-x86_64/alternative.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/include/asm-x86_64/alternative.h~rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix
+++ a/include/asm-x86_64/alternative.h
@@ -141,8 +141,8 @@ void apply_paravirt(struct paravirt_patc
 static inline void
 apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
 {}
-#define __start_parainstructions NULL
-#define __stop_parainstructions NULL
+#define __parainstructions NULL
+#define __parainstructions_end NULL
 #endif
 
 #endif /* _X86_64_ALTERNATIVE_H */
_

-- 

