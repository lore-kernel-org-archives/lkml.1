Return-Path: <linux-kernel-owner+w=401wt.eu-S1764644AbZFQIlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764644AbZFQIlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbZFQIlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:41:03 -0400
Received: from hera.kernel.org ([140.211.167.34]:45588 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbZFQIlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:41:01 -0400
Subject: [PATCH -tip] x86: msr.h linux/types is only required for __KERNEL__
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "H. Peter Anvin" <hpa@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:11:10 +0530
Message-Id: <1245228070.2662.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


<linux/types.h> is only required for __KERNEL__ as whole file is covered with it

Also fixed some spacing issues for usr/include/asm-x86/msr.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/msr.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2260376..48ad9d2 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -3,13 +3,10 @@
 
 #include <asm/msr-index.h>
 
-#ifndef __ASSEMBLY__
-# include <linux/types.h>
-#endif
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
+#include <linux/types.h>
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/cpumask.h>
@@ -264,6 +261,4 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 #endif  /* CONFIG_SMP */
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
-
-
 #endif /* _ASM_X86_MSR_H */
-- 
1.6.0.6



