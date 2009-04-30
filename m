Return-Path: <linux-kernel-owner+w=401wt.eu-S1765571AbZD3TDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765571AbZD3TDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 15:03:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764514AbZD3TC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 15:02:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60202 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbZD3TC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 15:02:56 -0400
Message-Id: <20090430185716.451791007@arndb.de>
References: <20090430185628.866082445@arndb.de>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 20:56:29 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2 1/9] asm-generic: rename atomic.h to atomic-long.h
Content-Disposition: inline; filename=0001-asm-generic-rename-atomic.h-to-atomic-long.h.patch
X-Provags-ID: V01U2FsdGVkX1/9QroQs+z+UaWbFa7YjBnCEwg6lzBnR79ysKj
 P2SR/1lrdzb4MPKr1P3LGTxnXQXcOkArMjVfJdD87V8DQPgKLT
 Ct1KTWFVgaRSM6/CIZH3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The existing asm-generic/atomic.h only defines the
atomic_long type. This renames it to atomic-long.h
so we have a place to add a truly generic atomic.h
that can be used on all non-SMP systems.

Signed-off-by: Remis Lima Baima <remis.developer@googlemail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/alpha/include/asm/atomic.h                 |    2 +-
 arch/arm/include/asm/atomic.h                   |    2 +-
 arch/avr32/include/asm/atomic.h                 |    2 +-
 arch/blackfin/include/asm/atomic.h              |    2 +-
 arch/cris/include/asm/atomic.h                  |    2 +-
 arch/frv/include/asm/atomic.h                   |    2 +-
 arch/h8300/include/asm/atomic.h                 |    2 +-
 arch/ia64/include/asm/atomic.h                  |    2 +-
 arch/m32r/include/asm/atomic.h                  |    2 +-
 arch/m68k/include/asm/atomic_mm.h               |    2 +-
 arch/m68k/include/asm/atomic_no.h               |    2 +-
 arch/microblaze/include/asm/atomic.h            |    2 +-
 arch/mips/include/asm/atomic.h                  |    2 +-
 arch/mn10300/include/asm/atomic.h               |    2 +-
 arch/parisc/include/asm/atomic.h                |    2 +-
 arch/powerpc/include/asm/atomic.h               |    2 +-
 arch/s390/include/asm/atomic.h                  |    2 +-
 arch/sh/include/asm/atomic.h                    |    2 +-
 arch/sparc/include/asm/atomic_32.h              |    2 +-
 arch/sparc/include/asm/atomic_64.h              |    2 +-
 arch/x86/include/asm/atomic_32.h                |    2 +-
 arch/x86/include/asm/atomic_64.h                |    2 +-
 arch/xtensa/include/asm/atomic.h                |    2 +-
 include/asm-generic/{atomic.h => atomic-long.h} |    6 +++---
 include/asm-generic/bitops/atomic.h             |    1 +
 25 files changed, 27 insertions(+), 26 deletions(-)
 rename include/asm-generic/{atomic.h => atomic-long.h} (97%)

diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 62b3635..610dff4 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -256,5 +256,5 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* _ALPHA_ATOMIC_H */
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index ee99723..828e1e7 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -206,6 +206,6 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif
 #endif
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index 3188151..b131c27 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -196,6 +196,6 @@ static inline int atomic_sub_if_positive(int i, atomic_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 
 #endif /*  __ASM_AVR32_ATOMIC_H */
diff --git a/arch/blackfin/include/asm/atomic.h b/arch/blackfin/include/asm/atomic.h
index 94b2a9b..7bbf44e 100644
--- a/arch/blackfin/include/asm/atomic.h
+++ b/arch/blackfin/include/asm/atomic.h
@@ -208,6 +208,6 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 #define atomic_sub_and_test(i,v) (atomic_sub_return((i), (v)) == 0)
 #define atomic_dec_and_test(v) (atomic_sub_return(1, (v)) == 0)
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 
 #endif				/* __ARCH_BLACKFIN_ATOMIC __ */
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index 5718dd8..a6aca81 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -158,5 +158,5 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc()     barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index 296c35c..0409d98 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -194,5 +194,5 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 
 #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index 833186c..33c8c0f 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -141,5 +141,5 @@ static __inline__ void atomic_set_mask(unsigned long mask, unsigned long *v)
 #define smp_mb__before_atomic_inc()    barrier()
 #define smp_mb__after_atomic_inc() barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __ARCH_H8300_ATOMIC __ */
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index d37292b..88405cb 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -216,5 +216,5 @@ atomic64_add_negative (__s64 i, atomic64_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* _ASM_IA64_ATOMIC_H */
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 2eed30f..63f0cf0 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -314,5 +314,5 @@ static __inline__ void atomic_set_mask(unsigned long  mask, atomic_t *addr)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif	/* _ASM_M32R_ATOMIC_H */
diff --git a/arch/m68k/include/asm/atomic_mm.h b/arch/m68k/include/asm/atomic_mm.h
index eb0ab9d..88b7af2 100644
--- a/arch/m68k/include/asm/atomic_mm.h
+++ b/arch/m68k/include/asm/atomic_mm.h
@@ -192,5 +192,5 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __ARCH_M68K_ATOMIC __ */
diff --git a/arch/m68k/include/asm/atomic_no.h b/arch/m68k/include/asm/atomic_no.h
index 6bb6748..5674cb9 100644
--- a/arch/m68k/include/asm/atomic_no.h
+++ b/arch/m68k/include/asm/atomic_no.h
@@ -151,5 +151,5 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 #define atomic_dec_return(v) atomic_sub_return(1,(v))
 #define atomic_inc_return(v) atomic_add_return(1,(v))
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __ARCH_M68KNOMMU_ATOMIC __ */
diff --git a/arch/microblaze/include/asm/atomic.h b/arch/microblaze/include/asm/atomic.h
index a448d94..0de612a 100644
--- a/arch/microblaze/include/asm/atomic.h
+++ b/arch/microblaze/include/asm/atomic.h
@@ -118,6 +118,6 @@ static inline int atomic_dec_if_positive(atomic_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 
 #endif /* _ASM_MICROBLAZE_ATOMIC_H */
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 1b332e1..eb7f01c 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -793,6 +793,6 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	smp_llsc_mb()
 #define smp_mb__after_atomic_inc()	smp_llsc_mb()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/mn10300/include/asm/atomic.h b/arch/mn10300/include/asm/atomic.h
index bc06482..5bf5be9 100644
--- a/arch/mn10300/include/asm/atomic.h
+++ b/arch/mn10300/include/asm/atomic.h
@@ -151,7 +151,7 @@ static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_ATOMIC_H */
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index ada3e53..7eeaff9 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -338,6 +338,6 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #endif /* CONFIG_64BIT */
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 
 #endif /* _ASM_PARISC_ATOMIC_H_ */
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index b401950..b7d2d07 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -472,6 +472,6 @@ static __inline__ int atomic64_add_unless(atomic64_t *v, long a, long u)
 
 #endif /* __powerpc64__ */
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 #endif /* _ASM_POWERPC_ATOMIC_H_ */
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index de432f2..fca9dff 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -275,6 +275,6 @@ static __inline__ int atomic64_add_unless(atomic64_t *v,
 #define smp_mb__before_atomic_inc()	smp_mb()
 #define smp_mb__after_atomic_inc()	smp_mb()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 #endif /* __ARCH_S390_ATOMIC__  */
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index 6327ffb..a5647d0 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -84,5 +84,5 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __ASM_SH_ATOMIC_H */
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index bb91b12..f0d343c 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -161,5 +161,5 @@ static inline int __atomic24_sub(int i, atomic24_t *v)
 
 #endif /* !(__KERNEL__) */
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* !(__ARCH_SPARC_ATOMIC__) */
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index a0a7064..f2e4800 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -114,5 +114,5 @@ static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* !(__ARCH_SPARC64_ATOMIC__) */
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 85b46fb..c83d314 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -247,5 +247,5 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
index 8c21731..0d63602 100644
--- a/arch/x86/include/asm/atomic_64.h
+++ b/arch/x86/include/asm/atomic_64.h
@@ -455,5 +455,5 @@ static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* _ASM_X86_ATOMIC_64_H */
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index 67ad67b..22d6dde 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -292,7 +292,7 @@ static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
 #define smp_mb__before_atomic_inc()	barrier()
 #define smp_mb__after_atomic_inc()	barrier()
 
-#include <asm-generic/atomic.h>
+#include <asm-generic/atomic-long.h>
 #endif /* __KERNEL__ */
 
 #endif /* _XTENSA_ATOMIC_H */
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic-long.h
similarity index 97%
rename from include/asm-generic/atomic.h
rename to include/asm-generic/atomic-long.h
index 7abdaa9..a24a51c 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic-long.h
@@ -1,5 +1,5 @@
-#ifndef _ASM_GENERIC_ATOMIC_H
-#define _ASM_GENERIC_ATOMIC_H
+#ifndef _ASM_GENERIC_ATOMIC_LONG_H
+#define _ASM_GENERIC_ATOMIC_LONG_H
 /*
  * Copyright (C) 2005 Silicon Graphics, Inc.
  *	Christoph Lameter
@@ -255,4 +255,4 @@ static inline long atomic_long_add_unless(atomic_long_t *l, long a, long u)
 
 #endif  /*  BITS_PER_LONG == 64  */
 
-#endif  /*  _ASM_GENERIC_ATOMIC_H  */
+#endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index 4657f3e..c894646 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -2,6 +2,7 @@
 #define _ASM_GENERIC_BITOPS_ATOMIC_H_
 
 #include <asm/types.h>
+#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
-- 
1.5.6.3

-- 

