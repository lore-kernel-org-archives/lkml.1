Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbYAZQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbYAZQBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYAZPzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:23 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754867AbYAZPzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:18 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 40/52] [microblaze] atomic.h bitops.h byteorder.h
Date: Thu, 24 Jan 2008 16:03:15 +0100
Message-Id: <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
 <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
 <db7f441df21cfe296a44744747b28f379e75fd49.1201107832.git.monstr@monstr.eu>
 <e6309af7cc6550ef5b399fc0902f1926f9e52e58.1201107832.git.monstr@monstr.eu>
 <2d11eef3abada1f41658a532a483c6121ded8054.1201107832.git.monstr@monstr.eu>
 <48db19662b808ab6f5455dd7f2116e6544c50e95.1201107832.git.monstr@monstr.eu>
 <7b0cfa6ae11749e20c941d0a4f03577141e022f8.1201107832.git.monstr@monstr.eu>
 <2f3db7ba4fe41cb9888adabf0e4e052d4da5c37c.1201107832.git.monstr@monstr.eu>
 <d67010417928d04766e6dd74820b12c249d61814.1201107832.git.monstr@monstr.eu>
 <37627293f081fa40f21234944ddb878d5e711740.1201107832.git.monstr@monstr.eu>
 <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/atomic.h    |  108 ++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/bitops.h    |   29 ++++++++++
 include/asm-microblaze/byteorder.h |   23 ++++++++
 3 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/atomic.h
 create mode 100644 include/asm-microblaze/bitops.h
 create mode 100644 include/asm-microblaze/byteorder.h

diff --git a/include/asm-microblaze/atomic.h b/include/asm-microblaze/atomic.h
new file mode 100644
index 0000000..f7be329
--- /dev/null
+++ b/include/asm-microblaze/atomic.h
@@ -0,0 +1,108 @@
+/*
+ * include/asm-microblaze/atomic.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_ATOMIC_H
+#define _ASM_ATOMIC_H
+
+#include <linux/compiler.h> /* likely */
+#include <asm/system.h> /* local_irq_XXX and friends */
+
+typedef struct { volatile int counter; } atomic_t;
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
+static __inline__ int atomic_add_return(int i, atomic_t *v)
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
+#endif /* _ASM_ATOMIC_H */
diff --git a/include/asm-microblaze/bitops.h b/include/asm-microblaze/bitops.h
new file mode 100644
index 0000000..4078d90
--- /dev/null
+++ b/include/asm-microblaze/bitops.h
@@ -0,0 +1,29 @@
+/*
+ * include/asm-microblaze/auxvec.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _MICROBLAZE_BITOPS_H
+#define _MICROBLAZE_BITOPS_H
+
+/*
+ * Copyright 1992, Linus Torvalds.
+ */
+
+#include <linux/autoconf.h>
+#include <asm/byteorder.h> /* swab32 */
+#include <asm/system.h> /* save_flags */
+
+/*
+ * clear_bit() doesn't provide any barrier for the compiler.
+ */
+#define smp_mb__before_clear_bit()	barrier()
+#define smp_mb__after_clear_bit()	barrier()
+#include <asm-generic/bitops.h>
+
+#endif /* _MICROBLAZE_BITOPS_H */
diff --git a/include/asm-microblaze/byteorder.h b/include/asm-microblaze/byteorder.h
new file mode 100644
index 0000000..df9dbbe
--- /dev/null
+++ b/include/asm-microblaze/byteorder.h
@@ -0,0 +1,23 @@
+/*
+ * include/asm-microblaze/byteorder.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_BYTEORDER_H
+#define _ASM_BYTEORDER_H
+
+#include <asm/types.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __BYTEORDER_HAS_U64__
+#define __SWAB_64_THRU_32__
+#endif
+
+#include <linux/byteorder/big_endian.h>
+
+#endif /* _ASM_BYTEORDER_H */
-- 
1.5.4.rc4.14.g6fc74

