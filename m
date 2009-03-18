Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbZCRVv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbZCRVv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756904AbZCRVnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:43:20 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756989AbZCRVnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:43:17 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 39/57] microblaze_v7: atomic.h bitops.h swab.h byteorder.h
Date: Wed, 18 Mar 2009 21:31:06 +0100
Message-Id: <1ca9913fc2b9ec220fdb9909f7929abfc38e41b1.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
 <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
 <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu>
 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
 <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu>
 <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu>
 <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu>
 <f7c1685bd3f387be8633db5fb3dd4cb5e7c2d792.1237407249.git.monstr@monstr.eu>
 <2f48efc353c11dfdfc7b052bdfe052b71c09ab23.1237407249.git.monstr@monstr.eu>
 <f7f2d17e21a3df9931c75976c37a003d11190cc9.1237407249.git.monstr@monstr.eu>
 <58cf06c85e07477170677b72ce3437af10476bec.1237407249.git.monstr@monstr.eu>
 <eaa0169a360a328883ab0eabd2a189c21bad4c30.1237407249.git.monstr@monstr.eu>
 <20227d6f2615060d6560785090513e251cbe2654.1237407249.git.monstr@monstr.eu>
 <69ef4f976d86c870a97fbe4974c242c74acc477d.1237407249.git.monstr@monstr.eu>
 <eb4ccc67cf39abc816c8d7653fdc7561d14c1da2.1237407249.git.monstr@monstr.eu>
 <1477ec41e7ba0ec847a064e1f8e422dc2a5dcc9f.1237407249.git.monstr@monstr.eu>
 <75127eae09c978220d452d92f95763dde24f1d52.1237407249.git.monstr@monstr.eu>
 <b726b7b271cf303c36af54c4e155140541a6769b.1237407249.git.monstr@monstr.eu>
 <644f08d7f8cd338e606ed703e221914f75588fb5.1237407249.git.monstr@monstr.eu>
 <6d19f608a4ba3e7718aa55794c2845f19b5ed5e2.1237407249.git.monstr@monstr.eu>
 <039bc2fea33d23a3e7d2d85ac6fb275b8d21b5ed.1237407249.git.monstr@monstr.eu>
 <513d4067a84be1ecb47577e1edf131d2b3572808.1237407249.git.monstr@monstr.eu>
 <c6a6fbe7b56db27d9b74ee593cf068963f86ee58.1237407249.git.monstr@monstr.eu>
 <e9d4d452140c50451741dd6024ab89efd24ac8e6.1237407249.git.monstr@monstr.eu>
 <f8494212852d4cec890ae5e152353c91153c7c0d.1237407249.git.monstr@monstr.eu>
 <5c66d0329884feb553ae745584f6db589a892eb1.1237407249.git.monstr@monstr.eu>
 <72b06b8fa7b051005ebfa5c23c53a40d6a27f94a.1237407249.git.monstr@monstr.eu>
 <aa044d06327435cee76599fb6220630007f38ba7.1237407249.git.monstr@monstr.eu>
 <99fdae6e9b1da3ae5e2d3ebc841d1afdc694dfae.1237407249.git.monstr@monstr.eu>
 <29d86e7cd1124e596c9dde627f397ca98dccf572.1237407249.git.monstr@monstr.eu>
 <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
 <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
 <592d2a1c72581b6abf73841e640e7b7306c3ec3b.1237407249.git.monstr@monstr.eu>
 <fde2defbb60d9476df3aac0dc7d87241ed247d3e.1237407249.git.monstr@monstr.eu>
 <cde249b42d873cf948bd37d5e997307207de1bd3.1237407249.git.monstr@monstr.eu>
 <1165ce05edc67098d818cf42fd41a621868ab2a6.1237407249.git.monstr@monstr.eu>
 <35b0490d6a70779bdf2e2f55265c7c70a0dcbf1a.1237407249.git.monstr@monstr.eu>
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/atomic.h    |  123 +++++++++++++++++++++++++++++++
 arch/microblaze/include/asm/bitops.h    |   27 +++++++
 arch/microblaze/include/asm/byteorder.h |    6 ++
 arch/microblaze/include/asm/swab.h      |    8 ++
 4 files changed, 164 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/atomic.h
 create mode 100644 arch/microblaze/include/asm/bitops.h
 create mode 100644 arch/microblaze/include/asm/byteorder.h
 create mode 100644 arch/microblaze/include/asm/swab.h

diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
new file mode 100644
index 0000000..a448d94
--- /dev/null
+++ b/arch/microblaze/include/asm/atomic.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_ATOMIC_H
+#define _ASM_MICROBLAZE_ATOMIC_H
+
+#include <linux/types.h>
+#include <linux/compiler.h> /* likely */
+#include <asm/system.h> /* local_irq_XXX and friends */
+
+#define ATOMIC_INIT(i)		{ (i) }
+#define atomic_read(v)		((v)->counter)
+#define atomic_set(v, i)	(((v)->counter) = (i))
+
+#define atomic_inc(v)		(atomic_add_return(1, (v)))
+#define atomic_dec(v)		(atomic_sub_return(1, (v)))
+
+#define atomic_add(i, v)	(atomic_add_return(i, (v)))
+#define atomic_sub(i, v)	(atomic_sub_return(i, (v)))
+
+#define atomic_inc_return(v)	(atomic_add_return(1, (v)))
+#define atomic_dec_return(v)	(atomic_sub_return(1, (v)))
+
+#define atomic_inc_and_test(v)	(atomic_add_return(1, (v)) == 0)
+#define atomic_dec_and_test(v)	(atomic_sub_return(1, (v)) == 0)
+
+#define atomic_inc_not_zero(v)	(atomic_add_unless((v), 1, 0))
+
+#define atomic_sub_and_test(i, v) (atomic_sub_return((i), (v)) == 0)
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	int ret;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	ret = v->counter;
+	if (likely(ret == old))
+		v->counter = new;
+	local_irq_restore(flags);
+
+	return ret;
+}
+
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+
+	c = atomic_read(v);
+	while (c != u && (old = atomic_cmpxchg((v), c, c + a)) != c)
+		c = old;
+	return c != u;
+}
+
+static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	*addr &= ~mask;
+	local_irq_restore(flags);
+}
+
+/**
+ * atomic_add_return - add and return
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	unsigned long flags;
+	int val;
+
+	local_irq_save(flags);
+	val = v->counter;
+	v->counter = val += i;
+	local_irq_restore(flags);
+
+	return val;
+}
+
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	return atomic_add_return(-i, v);
+}
+
+/*
+ * Atomically test *v and decrement if it is greater than 0.
+ * The function returns the old value of *v minus 1.
+ */
+static inline int atomic_dec_if_positive(atomic_t *v)
+{
+	unsigned long flags;
+	int res;
+
+	local_irq_save(flags);
+	res = v->counter - 1;
+	if (res >= 0)
+		v->counter = res;
+	local_irq_restore(flags);
+
+	return res;
+}
+
+#define atomic_add_negative(a, v)	(atomic_add_return((a), (v)) < 0)
+#define atomic_xchg(v, new) (xchg(&((v)->counter), new))
+
+/* Atomic operations are already serializing */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
+#include <asm-generic/atomic.h>
+
+#endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff --git a/arch/microblaze/include/asm/bitops.h b/arch/microblaze/include/asm/bitops.h
new file mode 100644
index 0000000..d6df1fd
--- /dev/null
+++ b/arch/microblaze/include/asm/bitops.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_BITOPS_H
+#define _ASM_MICROBLAZE_BITOPS_H
+
+/*
+ * Copyright 1992, Linus Torvalds.
+ */
+
+#include <asm/byteorder.h> /* swab32 */
+#include <asm/system.h> /* save_flags */
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+#include <asm-generic/bitops.h>
+#include <asm-generic/bitops/__fls.h>
+
+#endif /* _ASM_MICROBLAZE_BITOPS_H */
diff --git a/arch/microblaze/include/asm/byteorder.h b/arch/microblaze/include/asm/byteorder.h
new file mode 100644
index 0000000..ce9c587
--- /dev/null
+++ b/arch/microblaze/include/asm/byteorder.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_MICROBLAZE_BYTEORDER_H
+#define _ASM_MICROBLAZE_BYTEORDER_H
+
+#include <linux/byteorder/big_endian.h>
+
+#endif /* _ASM_MICROBLAZE_BYTEORDER_H */
diff --git a/arch/microblaze/include/asm/swab.h b/arch/microblaze/include/asm/swab.h
new file mode 100644
index 0000000..b375d7b
--- /dev/null
+++ b/arch/microblaze/include/asm/swab.h
@@ -0,0 +1,8 @@
+#ifndef _ASM_MICROBLAZE_SWAB_H
+#define _ASM_MICROBLAZE_SWAB_H
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __SWAB_64_THRU_32__
+#endif
+
+#endif /* _ASM_MICROBLAZE_SWAB_H */
-- 
1.5.5.1

