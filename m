Return-Path: <linux-kernel-owner+w=401wt.eu-S1760917AbXLTMNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760917AbXLTMNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761270AbXLTMBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761153AbXLTMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 26/43] x86-64 wired cpu_has macros
Message-Id: <20071220115935.790FD26F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds hard-wired definitions for the remaining cpu_has_* macros
that correspond to flags required-features.h demands are set for
64-bit.  Using these can efficiently avoid some #ifdef's when
merging 32-bit and 64-bit code together.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/cpufeature.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 87dd900..75e2f78 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -192,9 +192,21 @@
 #undef  cpu_has_centaur_mcr
 #define cpu_has_centaur_mcr	0
 
+#undef  cpu_has_pse
+#define cpu_has_pse		1
+
 #undef  cpu_has_pge
 #define cpu_has_pge		1
 
+#undef  cpu_has_xmm
+#define cpu_has_xmm		1
+
+#undef  cpu_has_xmm2
+#define cpu_has_xmm2		1
+
+#undef  cpu_has_fxsr
+#define cpu_has_fxsr		1
+
 #endif /* CONFIG_X86_64 */
 
 #endif /* _ASM_X86_CPUFEATURE_H */
-- 
1.5.3.6

