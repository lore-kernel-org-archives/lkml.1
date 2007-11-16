Return-Path: <linux-kernel-owner+w=401wt.eu-S934918AbXKPUGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934918AbXKPUGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934558AbXKPUFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:05:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46517 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934550AbXKPUFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:05:17 -0500
Message-Id: <20071116200513.588191335@polymtl.ca>
References: <20071116200238.740495156@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:02:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [rfc-patch 4/9] x86: add <asm/asm.h>
Content-Disposition: inline; filename=add-x86-asm-asm-h.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:05:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

x86: add <asm/asm.h>

Create <asm/asm.h>, with common definitions suitable for assembly
unification.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---

diff --git a/include/asm-x86/asm.h b/include/asm-x86/asm.h
new file mode 100644
index 0000000..b5006eb
--- /dev/null
+++ b/include/asm-x86/asm.h
@@ -0,0 +1,18 @@
+#ifndef _ASM_X86_ASM_H
+#define _ASM_X86_ASM_H
+
+#ifdef CONFIG_X86_32
+/* 32 bits */
+
+# define _ASM_PTR	" .long "
+# define _ASM_ALIGN	" .balign 4 "
+
+#else
+/* 64 bits */
+
+# define _ASM_PTR	" .quad "
+# define _ASM_ALIGN	" .balign 8 "
+
+#endif /* CONFIG_X86_32 */
+
+#endif /* _ASM_X86_ASM_H */

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
