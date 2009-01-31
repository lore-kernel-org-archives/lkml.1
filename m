Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZAaHMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZAaHMM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 02:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbZAaHL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 02:11:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:37140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbZAaHLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 02:11:55 -0500
Subject: [git pull -tip] headers_check fixes for other architectures
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       ralf@linux-mips.org, dhowells@redhat.com, matthew@wil.cx,
       chris@zankel.net, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 31 Jan 2009 12:40:16 +0530
Message-Id: <1233385816.17794.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are clean patches, I did not included anything which leads to any
confusion or conflicts. I hope maintainers do not mind if these patches
go to mainstream via Ingo's -tip along with other headers_check fixes.

Ingo please pull:
The following changes since commit 83c21698257b3bbd96926480b26eaffb5a8c3946:
  Ingo Molnar (1):
        Merge branch 'x86/apic'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (27):
      headers_check fix: alpha, statfs.h
      headers_check fix: alpha, swab.h
      headers_check fix: arm, a.out.h
      headers_check fix: arm, setup.h
      headers_check fix: arm, swab.h
      headers_check fix: avr32, swab.h
      headers_check fix: blackfin, swab.h
      headers_check fix: frv, swab.h
      headers_check fix: h8300, swab.h
      headers_check fix: ia64, fpu.h
      headers_check fix: ia64, gcc_intrin.h
      headers_check fix: ia64, intrinsics.h
      headers_check fix: ia64, kvm.h
      headers_check fix: ia64, swab.h
      headers_check fix: m32r, swab.h
      headers_check fix: mips, sigcontext.h
      headers_check fix: mips, swab.h
      headers_check fix: mn10300, swab.h
      headers_check fix: parisc, pdc.h
      headers_check fix: parisc, swab.h
      headers_check fix: powerpc, bootx.h
      headers_check fix: powerpc, elf.h
      headers_check fix: powerpc, kvm.h
      headers_check fix: powerpc, ps3fb.h
      headers_check fix: powerpc, spu_info.h
      headers_check fix: powerpc, swab.h
      headers_check fix: xtensa, swab.h

 arch/alpha/include/asm/statfs.h     |    2 ++
 arch/alpha/include/asm/swab.h       |    2 +-
 arch/arm/include/asm/a.out.h        |    2 +-
 arch/arm/include/asm/setup.h        |    2 +-
 arch/arm/include/asm/swab.h         |    2 +-
 arch/avr32/include/asm/swab.h       |    2 +-
 arch/blackfin/include/asm/swab.h    |    2 +-
 arch/h8300/include/asm/swab.h       |    2 +-
 arch/ia64/include/asm/fpu.h         |    2 +-
 arch/ia64/include/asm/gcc_intrin.h  |    1 +
 arch/ia64/include/asm/intrinsics.h  |    1 +
 arch/ia64/include/asm/kvm.h         |    3 +--
 arch/ia64/include/asm/swab.h        |    2 +-
 arch/mips/include/asm/sigcontext.h  |    1 +
 arch/mips/include/asm/swab.h        |    2 +-
 arch/parisc/include/asm/pdc.h       |    3 ++-
 arch/parisc/include/asm/swab.h      |    2 +-
 arch/powerpc/include/asm/bootx.h    |    2 +-
 arch/powerpc/include/asm/elf.h      |    2 +-
 arch/powerpc/include/asm/kvm.h      |    2 +-
 arch/powerpc/include/asm/ps3fb.h    |    1 +
 arch/powerpc/include/asm/spu_info.h |    3 ++-
 arch/powerpc/include/asm/swab.h     |    2 +-
 arch/xtensa/include/asm/swab.h      |    2 +-
 include/asm-frv/swab.h              |    2 +-
 include/asm-m32r/swab.h             |    2 +-
 include/asm-mn10300/swab.h          |    2 +-
 27 files changed, 30 insertions(+), 23 deletions(-)

These patches fixes 41 headers_check warnings:
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-alpha/statfs.h:6: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-alpha/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-alpha/swab.h:10: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-arm/a.out.h:5: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-arm/a.out.h:9: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-arm/setup.h:17: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-arm/setup.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-arm/swab.h:19: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-arm/swab.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-avr32/swab.h:7: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-avr32/swab.h:22: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-blackfin/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-blackfin/swab.h:13: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-frv/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-h8300/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/fpu.h:9: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/gcc_intrin.h:63: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/intrinsics.h:57: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/kvm.h:24: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/kvm.h:34: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/swab.h:9: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-ia64/swab.h:13: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-m32r/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-mips/sigcontext.h:57: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-mips/swab.h:12: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-mips/swab.h:18: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-mn10300/swab.h:14: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-mn10300/swab.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-parisc/pdc.h:420: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-parisc/swab.h:4: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-parisc/swab.h:9: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/bootx.h:12: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/bootx.h:57: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/elf.h:5: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/kvm.h:23: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/kvm.h:26: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/ps3fb.h:33: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/spu_info.h:27: found __[us]{8,16,32,64} type without #include <linux/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-powerpc/swab.h:11: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-xtensa/swab.h:14: include of <linux/types.h> is preferred over <asm/types.h>
/home/jaswinder/jaswinder-git/linux-2.6/usr/include/asm-xtensa/swab.h:19: found __[us]{8,16,32,64} type without #include <linux/types.h>

Complete diff:
diff --git a/arch/alpha/include/asm/statfs.h b/arch/alpha/include/asm/statfs.h
index de35cd4..ccd2e18 100644
--- a/arch/alpha/include/asm/statfs.h
+++ b/arch/alpha/include/asm/statfs.h
@@ -1,6 +1,8 @@
 #ifndef _ALPHA_STATFS_H
 #define _ALPHA_STATFS_H
 
+#include <linux/types.h>
+
 /* Alpha is the only 64-bit platform with 32-bit statfs. And doesn't
    even seem to implement statfs64 */
 #define __statfs_word __u32
diff --git a/arch/alpha/include/asm/swab.h b/arch/alpha/include/asm/swab.h
index 68e7089..4d682b1 100644
--- a/arch/alpha/include/asm/swab.h
+++ b/arch/alpha/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _ALPHA_SWAB_H
 #define _ALPHA_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 #include <asm/compiler.h>
 
diff --git a/arch/arm/include/asm/a.out.h b/arch/arm/include/asm/a.out.h
index 79489fd..083894b 100644
--- a/arch/arm/include/asm/a.out.h
+++ b/arch/arm/include/asm/a.out.h
@@ -2,7 +2,7 @@
 #define __ARM_A_OUT_H__
 
 #include <linux/personality.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 struct exec
 {
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index f2cd18a..ee1304f 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -14,7 +14,7 @@
 #ifndef __ASMARM_SETUP_H
 #define __ASMARM_SETUP_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define COMMAND_LINE_SIZE 1024
 
diff --git a/arch/arm/include/asm/swab.h b/arch/arm/include/asm/swab.h
index 27a689b..ca2bf2f 100644
--- a/arch/arm/include/asm/swab.h
+++ b/arch/arm/include/asm/swab.h
@@ -16,7 +16,7 @@
 #define __ASM_ARM_SWAB_H
 
 #include <linux/compiler.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
 #  define __SWAB_64_THRU_32__
diff --git a/arch/avr32/include/asm/swab.h b/arch/avr32/include/asm/swab.h
index a14aa5b..14cc737 100644
--- a/arch/avr32/include/asm/swab.h
+++ b/arch/avr32/include/asm/swab.h
@@ -4,7 +4,7 @@
 #ifndef __ASM_AVR32_SWAB_H
 #define __ASM_AVR32_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #define __SWAB_64_THRU_32__
diff --git a/arch/blackfin/include/asm/swab.h b/arch/blackfin/include/asm/swab.h
index 69a051b..6403ad2 100644
--- a/arch/blackfin/include/asm/swab.h
+++ b/arch/blackfin/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _BLACKFIN_SWAB_H
 #define _BLACKFIN_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
diff --git a/arch/h8300/include/asm/swab.h b/arch/h8300/include/asm/swab.h
index c108f39..39abbf5 100644
--- a/arch/h8300/include/asm/swab.h
+++ b/arch/h8300/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _H8300_SWAB_H
 #define _H8300_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
 #  define __SWAB_64_THRU_32__
diff --git a/arch/ia64/include/asm/fpu.h b/arch/ia64/include/asm/fpu.h
index 3859558..b6395ad 100644
--- a/arch/ia64/include/asm/fpu.h
+++ b/arch/ia64/include/asm/fpu.h
@@ -6,7 +6,7 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 /* floating point status register: */
 #define FPSR_TRAP_VD	(1 << 0)	/* invalid op trap disabled */
diff --git a/arch/ia64/include/asm/gcc_intrin.h b/arch/ia64/include/asm/gcc_intrin.h
index 0f5b559..c2c5fd8 100644
--- a/arch/ia64/include/asm/gcc_intrin.h
+++ b/arch/ia64/include/asm/gcc_intrin.h
@@ -6,6 +6,7 @@
  * Copyright (C) 2002,2003 Suresh Siddha <suresh.b.siddha@intel.com>
  */
 
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 /* define this macro to get some asm stmts included in 'c' files */
diff --git a/arch/ia64/include/asm/intrinsics.h b/arch/ia64/include/asm/intrinsics.h
index a3e44a5..c47830e 100644
--- a/arch/ia64/include/asm/intrinsics.h
+++ b/arch/ia64/include/asm/intrinsics.h
@@ -10,6 +10,7 @@
 
 #ifndef __ASSEMBLY__
 
+#include <linux/types.h>
 /* include compiler specific intrinsics */
 #include <asm/ia64regs.h>
 #ifdef __INTEL_COMPILER
diff --git a/arch/ia64/include/asm/kvm.h b/arch/ia64/include/asm/kvm.h
index 68aa6da..116761c 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -21,8 +21,7 @@
  *
  */
 
-#include <asm/types.h>
-
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* Architectural interrupt line count. */
diff --git a/arch/ia64/include/asm/swab.h b/arch/ia64/include/asm/swab.h
index 6aa58b6..c89a8cb 100644
--- a/arch/ia64/include/asm/swab.h
+++ b/arch/ia64/include/asm/swab.h
@@ -6,7 +6,7 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>, Hewlett-Packard Co.
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/intrinsics.h>
 #include <linux/compiler.h>
 
diff --git a/arch/mips/include/asm/sigcontext.h b/arch/mips/include/asm/sigcontext.h
index 9ce0607..9e89cf9 100644
--- a/arch/mips/include/asm/sigcontext.h
+++ b/arch/mips/include/asm/sigcontext.h
@@ -9,6 +9,7 @@
 #ifndef _ASM_SIGCONTEXT_H
 #define _ASM_SIGCONTEXT_H
 
+#include <linux/types.h>
 #include <asm/sgidefs.h>
 
 #if _MIPS_SIM == _MIPS_SIM_ABI32
diff --git a/arch/mips/include/asm/swab.h b/arch/mips/include/asm/swab.h
index 88f1f7d..99993c0 100644
--- a/arch/mips/include/asm/swab.h
+++ b/arch/mips/include/asm/swab.h
@@ -9,7 +9,7 @@
 #define _ASM_SWAB_H
 
 #include <linux/compiler.h>
-#include <asm/types.h>
+#include <linux/types.h>
 
 #define __SWAB_64_THRU_32__
 
diff --git a/arch/parisc/include/asm/pdc.h b/arch/parisc/include/asm/pdc.h
index c584b00..430f1ae 100644
--- a/arch/parisc/include/asm/pdc.h
+++ b/arch/parisc/include/asm/pdc.h
@@ -336,10 +336,11 @@
 #define NUM_PDC_RESULT	32
 
 #if !defined(__ASSEMBLY__)
-#ifdef __KERNEL__
 
 #include <linux/types.h>
 
+#ifdef __KERNEL__
+
 extern int pdc_type;
 
 /* Values for pdc_type */
diff --git a/arch/parisc/include/asm/swab.h b/arch/parisc/include/asm/swab.h
index 3ff16c5..e78403b 100644
--- a/arch/parisc/include/asm/swab.h
+++ b/arch/parisc/include/asm/swab.h
@@ -1,7 +1,7 @@
 #ifndef _PARISC_SWAB_H
 #define _PARISC_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #define __SWAB_64_THRU_32__
diff --git a/arch/powerpc/include/asm/bootx.h b/arch/powerpc/include/asm/bootx.h
index 57b82e3..60a3c9e 100644
--- a/arch/powerpc/include/asm/bootx.h
+++ b/arch/powerpc/include/asm/bootx.h
@@ -9,7 +9,7 @@
 #ifndef __ASM_BOOTX_H__
 #define __ASM_BOOTX_H__
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #ifdef macintosh
 #include <Types.h>
diff --git a/arch/powerpc/include/asm/elf.h b/arch/powerpc/include/asm/elf.h
index cd46f02..b5600ce 100644
--- a/arch/powerpc/include/asm/elf.h
+++ b/arch/powerpc/include/asm/elf.h
@@ -7,7 +7,7 @@
 #include <asm/string.h>
 #endif
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <asm/ptrace.h>
 #include <asm/cputable.h>
 #include <asm/auxvec.h>
diff --git a/arch/powerpc/include/asm/kvm.h b/arch/powerpc/include/asm/kvm.h
index f993e41..4e0cf65 100644
--- a/arch/powerpc/include/asm/kvm.h
+++ b/arch/powerpc/include/asm/kvm.h
@@ -20,7 +20,7 @@
 #ifndef __LINUX_KVM_POWERPC_H
 #define __LINUX_KVM_POWERPC_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 struct kvm_regs {
 	__u64 pc;
diff --git a/arch/powerpc/include/asm/ps3fb.h b/arch/powerpc/include/asm/ps3fb.h
index 3f121fe..e7233a8 100644
--- a/arch/powerpc/include/asm/ps3fb.h
+++ b/arch/powerpc/include/asm/ps3fb.h
@@ -19,6 +19,7 @@
 #ifndef _ASM_POWERPC_PS3FB_H_
 #define _ASM_POWERPC_PS3FB_H_
 
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* ioctl */
diff --git a/arch/powerpc/include/asm/spu_info.h b/arch/powerpc/include/asm/spu_info.h
index 3545efb..1286c82 100644
--- a/arch/powerpc/include/asm/spu_info.h
+++ b/arch/powerpc/include/asm/spu_info.h
@@ -23,9 +23,10 @@
 #ifndef _SPU_INFO_H
 #define _SPU_INFO_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 #include <asm/spu.h>
-#include <linux/types.h>
 #else
 struct mfc_cq_sr {
 	__u64 mfc_cq_data0_RW;
diff --git a/arch/powerpc/include/asm/swab.h b/arch/powerpc/include/asm/swab.h
index ef824ae..c581e3e 100644
--- a/arch/powerpc/include/asm/swab.h
+++ b/arch/powerpc/include/asm/swab.h
@@ -8,7 +8,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #ifdef __GNUC__
diff --git a/arch/xtensa/include/asm/swab.h b/arch/xtensa/include/asm/swab.h
index f50b697..226a391 100644
--- a/arch/xtensa/include/asm/swab.h
+++ b/arch/xtensa/include/asm/swab.h
@@ -11,7 +11,7 @@
 #ifndef _XTENSA_SWAB_H
 #define _XTENSA_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 #include <linux/compiler.h>
 
 #define __SWAB_64_THRU_32__
diff --git a/include/asm-frv/swab.h b/include/asm-frv/swab.h
index afb3396..f305834 100644
--- a/include/asm-frv/swab.h
+++ b/include/asm-frv/swab.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_SWAB_H
 #define _ASM_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
 #  define __SWAB_64_THRU_32__
diff --git a/include/asm-m32r/swab.h b/include/asm-m32r/swab.h
index 97973e1..54dab00 100644
--- a/include/asm-m32r/swab.h
+++ b/include/asm-m32r/swab.h
@@ -1,7 +1,7 @@
 #ifndef _ASM_M32R_SWAB_H
 #define _ASM_M32R_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
 #  define __SWAB_64_THRU_32__
diff --git a/include/asm-mn10300/swab.h b/include/asm-mn10300/swab.h
index 4504d1b..bd818a8 100644
--- a/include/asm-mn10300/swab.h
+++ b/include/asm-mn10300/swab.h
@@ -11,7 +11,7 @@
 #ifndef _ASM_SWAB_H
 #define _ASM_SWAB_H
 
-#include <asm/types.h>
+#include <linux/types.h>
 
 #ifdef __GNUC__
 


