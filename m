Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZCZRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZCZRri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbZCZRrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:47:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45432 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755083AbZCZRrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:47:20 -0400
Date: Thu, 26 Mar 2009 18:46:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Sam Ravnborg <sam@ravnborg.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: [GIT PULL] header cleanups/fixes for v2.6.30
Message-ID: <20090326174633.GA19436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest header-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git header-fixes-for-linus

Highlights:

 - Standardize/fix type usage in exported headers and drop the
   number of headers_check warnings on x86 from 75 to 2. (but the
   fixes are not restricted to x86 only)

Risks:

 - There were no unusual patterns of breakage here - most of the
   back and forth during development was about which warnings we
   accept as real problems and which set of base types we accept.

 - There was one instance of a header change breaking a user-space 
   package build (this change was removed).

 - No kernel breakages were observed. There are no known regressions.

 Thanks,

	Ingo

------------------>
Arnd Bergmann (7):
      make exported headers use strict posix types
      make most exported headers use strict integer types
      make MTD headers use strict integer types
      make drm headers use strict integer types
      make netfilter use strict integer types
      remove __KERNEL_STRICT_NAMES
      emu101k1.h: fix duplicate include of <linux/types.h>

Cyrill Gorcunov (1):
      x86: headers cleanup - setup.h

H. Peter Anvin (1):
      compiler-gcc4: conditionalize #error on __KERNEL__

Jaswinder Singh Rajput (40):
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
      headers_check fix: linux/coda_psdev.h
      headers_check fix: linux/in6.h
      headers_check fix: linux/nubus.h
      headers_check fix: linux/socket.h
      headers_check fix: linux/reinserfs_fs.h
      headers_check fix: x86, prctl.h
      headers_check fix: x86, setup.h
      headers_check fix cleanup: linux/coda_psdev.h
      headers_check fix cleanup: linux/nubus.h
      headers_check fix cleanup: linux/reiserfs_fs.h
      Neither asm/types.h nor linux/types.h is required for arch/ia64/include/asm/fpu.h
      make linux/types.h as assembly safe
      unconditionally include asm/types.h from linux/types.h

Sam Ravnborg (1):
      kbuild: drop check for CONFIG_ in headers_check


 arch/alpha/include/asm/statfs.h            |    2 +
 arch/alpha/include/asm/swab.h              |    2 +-
 arch/arm/include/asm/a.out.h               |    2 +-
 arch/arm/include/asm/setup.h               |    2 +-
 arch/arm/include/asm/swab.h                |    2 +-
 arch/avr32/include/asm/swab.h              |    2 +-
 arch/blackfin/include/asm/swab.h           |    2 +-
 arch/h8300/include/asm/swab.h              |    2 +-
 arch/ia64/include/asm/fpu.h                |    2 -
 arch/ia64/include/asm/gcc_intrin.h         |    1 +
 arch/ia64/include/asm/intrinsics.h         |    1 +
 arch/ia64/include/asm/kvm.h                |    3 +-
 arch/ia64/include/asm/swab.h               |    2 +-
 arch/mips/include/asm/sigcontext.h         |    1 +
 arch/mips/include/asm/swab.h               |    2 +-
 arch/parisc/include/asm/pdc.h              |    3 +-
 arch/parisc/include/asm/swab.h             |    2 +-
 arch/powerpc/include/asm/bootx.h           |    2 +-
 arch/powerpc/include/asm/elf.h             |    2 +-
 arch/powerpc/include/asm/kvm.h             |    2 +-
 arch/powerpc/include/asm/ps3fb.h           |    1 +
 arch/powerpc/include/asm/spu_info.h        |    3 +-
 arch/powerpc/include/asm/swab.h            |    2 +-
 arch/x86/include/asm/prctl.h               |    4 -
 arch/x86/include/asm/setup.h               |   49 +++---
 arch/x86/include/asm/syscalls.h            |    1 +
 arch/xtensa/include/asm/swab.h             |    2 +-
 include/asm-frv/swab.h                     |    2 +-
 include/asm-generic/fcntl.h                |   12 +-
 include/asm-generic/siginfo.h              |   14 +-
 include/asm-generic/statfs.h               |    5 +-
 include/asm-m32r/swab.h                    |    2 +-
 include/asm-mn10300/swab.h                 |    2 +-
 include/drm/drm.h                          |   21 ++--
 include/drm/drm_mode.h                     |  153 +++++++++---------
 include/drm/i915_drm.h                     |  140 ++++++++--------
 include/drm/mga_drm.h                      |   18 ++-
 include/drm/radeon_drm.h                   |    4 +-
 include/drm/via_drm.h                      |   42 +++---
 include/linux/agpgart.h                    |   14 +-
 include/linux/atmlec.h                     |    5 +-
 include/linux/atmmpc.h                     |   45 +++---
 include/linux/cm4000_cs.h                  |   10 +-
 include/linux/cn_proc.h                    |   20 ++--
 include/linux/coda_psdev.h                 |   15 +-
 include/linux/compiler-gcc4.h              |    6 +-
 include/linux/cyclades.h                   |    6 +-
 include/linux/dlm_netlink.h                |   18 ++-
 include/linux/dm-ioctl.h                   |   42 +++---
 include/linux/dvb/audio.h                  |    2 +-
 include/linux/dvb/video.h                  |   24 ++--
 include/linux/if_arcnet.h                  |   27 ++--
 include/linux/if_pppol2tp.h                |    2 +-
 include/linux/in6.h                        |    2 +-
 include/linux/ip_vs.h                      |   26 ++--
 include/linux/ivtvfb.h                     |    2 +-
 include/linux/jffs2.h                      |   27 ++--
 include/linux/matroxfb.h                   |    2 +-
 include/linux/mroute6.h                    |    2 +-
 include/linux/netfilter/nf_conntrack_tcp.h |    6 +-
 include/linux/netfilter/nfnetlink.h        |    4 +-
 include/linux/netfilter/nfnetlink_compat.h |    7 +-
 include/linux/netfilter/nfnetlink_log.h    |   32 ++--
 include/linux/netfilter/nfnetlink_queue.h  |   24 ++--
 include/linux/netfilter/x_tables.h         |   30 ++--
 include/linux/netfilter/xt_CLASSIFY.h      |    4 +-
 include/linux/netfilter/xt_CONNMARK.h      |    8 +-
 include/linux/netfilter/xt_CONNSECMARK.h   |    4 +-
 include/linux/netfilter/xt_DSCP.h          |    7 +-
 include/linux/netfilter/xt_MARK.h          |    6 +-
 include/linux/netfilter/xt_NFLOG.h         |   12 +-
 include/linux/netfilter/xt_NFQUEUE.h       |    4 +-
 include/linux/netfilter/xt_RATEEST.h       |    6 +-
 include/linux/netfilter/xt_SECMARK.h       |    6 +-
 include/linux/netfilter/xt_TCPMSS.h        |    4 +-
 include/linux/netfilter/xt_connbytes.h     |    6 +-
 include/linux/netfilter/xt_connmark.h      |    8 +-
 include/linux/netfilter/xt_conntrack.h     |   12 +-
 include/linux/netfilter/xt_dccp.h          |   14 +-
 include/linux/netfilter/xt_dscp.h          |   12 +-
 include/linux/netfilter/xt_esp.h           |    6 +-
 include/linux/netfilter/xt_hashlimit.h     |   32 ++--
 include/linux/netfilter/xt_iprange.h       |    4 +-
 include/linux/netfilter/xt_length.h        |    6 +-
 include/linux/netfilter/xt_limit.h         |   10 +-
 include/linux/netfilter/xt_mark.h          |    8 +-
 include/linux/netfilter/xt_multiport.h     |   18 ++-
 include/linux/netfilter/xt_owner.h         |    8 +-
 include/linux/netfilter/xt_physdev.h       |    6 +-
 include/linux/netfilter/xt_policy.h        |   14 +-
 include/linux/netfilter/xt_rateest.h       |   14 +-
 include/linux/netfilter/xt_realm.h         |    8 +-
 include/linux/netfilter/xt_recent.h        |   12 +-
 include/linux/netfilter/xt_sctp.h          |   36 +++--
 include/linux/netfilter/xt_statistic.h     |   14 +-
 include/linux/netfilter/xt_string.h        |   12 +-
 include/linux/netfilter/xt_tcpmss.h        |    6 +-
 include/linux/netfilter/xt_tcpudp.h        |   20 ++-
 include/linux/netfilter_ipv4/ipt_owner.h   |    8 +-
 include/linux/netfilter_ipv6/ip6t_owner.h  |    8 +-
 include/linux/nubus.h                      |    2 +
 include/linux/pfkeyv2.h                    |  242 ++++++++++++++--------------
 include/linux/ppp_defs.h                   |    4 +-
 include/linux/reiserfs_fs.h                |   56 ++++---
 include/linux/selinux_netlink.h            |    6 +-
 include/linux/socket.h                     |    6 +-
 include/linux/suspend_ioctls.h             |   11 +-
 include/linux/time.h                       |    8 +-
 include/linux/times.h                      |    8 +-
 include/linux/types.h                      |   19 +--
 include/linux/utime.h                      |    4 +-
 include/linux/xfrm.h                       |    2 +-
 include/mtd/inftl-user.h                   |   36 ++--
 include/mtd/jffs2-user.h                   |    5 +-
 include/mtd/mtd-abi.h                      |   70 ++++----
 include/mtd/nftl-user.h                    |   32 ++--
 include/mtd/ubi-user.h                     |   72 +++++----
 include/sound/asound.h                     |    9 +-
 include/sound/emu10k1.h                    |   11 +-
 scripts/headers_check.pl                   |    2 +-
 120 files changed, 990 insertions(+), 894 deletions(-)

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
index 3859558..0c26157 100644
--- a/arch/ia64/include/asm/fpu.h
+++ b/arch/ia64/include/asm/fpu.h
@@ -6,8 +6,6 @@
  *	David Mosberger-Tang <davidm@hpl.hp.com>
  */
 
-#include <asm/types.h>
-
 /* floating point status register: */
 #define FPSR_TRAP_VD	(1 << 0)	/* invalid op trap disabled */
 #define FPSR_TRAP_DD	(1 << 1)	/* denormal trap disabled */
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
index bfa86b6..2b0a38e 100644
--- a/arch/ia64/include/asm/kvm.h
+++ b/arch/ia64/include/asm/kvm.h
@@ -21,8 +21,7 @@
  *
  */
 
-#include <asm/types.h>
-
+#include <linux/types.h>
 #include <linux/ioctl.h>
 
 /* Select x86 specific features in <linux/kvm.h> */
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
diff --git a/arch/x86/include/asm/prctl.h b/arch/x86/include/asm/prctl.h
index a889464..3ac5032 100644
--- a/arch/x86/include/asm/prctl.h
+++ b/arch/x86/include/asm/prctl.h
@@ -6,8 +6,4 @@
 #define ARCH_GET_FS 0x1003
 #define ARCH_GET_GS 0x1004
 
-#ifdef CONFIG_X86_64
-extern long sys_arch_prctl(int, unsigned long);
-#endif /* CONFIG_X86_64 */
-
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index ebe858c..c2308f5 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -1,27 +1,12 @@
 #ifndef _ASM_X86_SETUP_H
 #define _ASM_X86_SETUP_H
 
+#ifdef __KERNEL__
+
 #define COMMAND_LINE_SIZE 2048
 
 #ifndef __ASSEMBLY__
 
-/* Interrupt control for vSMPowered x86_64 systems */
-void vsmp_init(void);
-
-
-void setup_bios_corruption_check(void);
-
-
-#ifdef CONFIG_X86_VISWS
-extern void visws_early_detect(void);
-extern int is_visws_box(void);
-#else
-static inline void visws_early_detect(void) { }
-static inline int is_visws_box(void) { return 0; }
-#endif
-
-extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
-extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
 /*
  * Any setup quirks to be performed?
  */
@@ -48,16 +33,8 @@ struct x86_quirks {
 	int (*update_genapic)(void);
 };
 
-extern struct x86_quirks *x86_quirks;
-extern unsigned long saved_video_mode;
-
-#ifndef CONFIG_PARAVIRT
-#define paravirt_post_allocator_init()	do {} while (0)
-#endif
 #endif /* __ASSEMBLY__ */
 
-#ifdef __KERNEL__
-
 #ifdef __i386__
 
 #include <linux/pfn.h>
@@ -78,6 +55,28 @@ extern unsigned long saved_video_mode;
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 
+/* Interrupt control for vSMPowered x86_64 systems */
+void vsmp_init(void);
+
+void setup_bios_corruption_check(void);
+
+#ifdef CONFIG_X86_VISWS
+extern void visws_early_detect(void);
+extern int is_visws_box(void);
+#else
+static inline void visws_early_detect(void) { }
+static inline int is_visws_box(void) { return 0; }
+#endif
+
+extern int wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip);
+extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
+extern struct x86_quirks *x86_quirks;
+extern unsigned long saved_video_mode;
+
+#ifndef CONFIG_PARAVIRT
+#define paravirt_post_allocator_init()	do {} while (0)
+#endif
+
 #ifndef _SETUP
 
 /*
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index c0b0bda..e26d34b 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -74,6 +74,7 @@ asmlinkage long sys_vfork(struct pt_regs *);
 asmlinkage long sys_execve(char __user *, char __user * __user *,
 			   char __user * __user *,
 			   struct pt_regs *);
+long sys_arch_prctl(int, unsigned long);
 
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
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
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index b847741..4d3e483 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -117,9 +117,9 @@
 struct flock {
 	short	l_type;
 	short	l_whence;
-	off_t	l_start;
-	off_t	l_len;
-	pid_t	l_pid;
+	__kernel_off_t	l_start;
+	__kernel_off_t	l_len;
+	__kernel_pid_t	l_pid;
 	__ARCH_FLOCK_PAD
 };
 #endif
@@ -140,9 +140,9 @@ struct flock {
 struct flock64 {
 	short  l_type;
 	short  l_whence;
-	loff_t l_start;
-	loff_t l_len;
-	pid_t  l_pid;
+	__kernel_loff_t l_start;
+	__kernel_loff_t l_len;
+	__kernel_pid_t  l_pid;
 	__ARCH_FLOCK64_PAD
 };
 #endif
diff --git a/include/asm-generic/siginfo.h b/include/asm-generic/siginfo.h
index 9695701..35752da 100644
--- a/include/asm-generic/siginfo.h
+++ b/include/asm-generic/siginfo.h
@@ -23,7 +23,7 @@ typedef union sigval {
 #endif
 
 #ifndef __ARCH_SI_UID_T
-#define __ARCH_SI_UID_T	uid_t
+#define __ARCH_SI_UID_T	__kernel_uid32_t
 #endif
 
 /*
@@ -47,13 +47,13 @@ typedef struct siginfo {
 
 		/* kill() */
 		struct {
-			pid_t _pid;		/* sender's pid */
+			__kernel_pid_t _pid;	/* sender's pid */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 		} _kill;
 
 		/* POSIX.1b timers */
 		struct {
-			timer_t _tid;		/* timer id */
+			__kernel_timer_t _tid;	/* timer id */
 			int _overrun;		/* overrun count */
 			char _pad[sizeof( __ARCH_SI_UID_T) - sizeof(int)];
 			sigval_t _sigval;	/* same as below */
@@ -62,18 +62,18 @@ typedef struct siginfo {
 
 		/* POSIX.1b signals */
 		struct {
-			pid_t _pid;		/* sender's pid */
+			__kernel_pid_t _pid;	/* sender's pid */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			sigval_t _sigval;
 		} _rt;
 
 		/* SIGCHLD */
 		struct {
-			pid_t _pid;		/* which child */
+			__kernel_pid_t _pid;	/* which child */
 			__ARCH_SI_UID_T _uid;	/* sender's uid */
 			int _status;		/* exit code */
-			clock_t _utime;
-			clock_t _stime;
+			__kernel_clock_t _utime;
+			__kernel_clock_t _stime;
 		} _sigchld;
 
 		/* SIGILL, SIGFPE, SIGSEGV, SIGBUS */
diff --git a/include/asm-generic/statfs.h b/include/asm-generic/statfs.h
index 6129d68..3b4fb3e 100644
--- a/include/asm-generic/statfs.h
+++ b/include/asm-generic/statfs.h
@@ -1,8 +1,9 @@
 #ifndef _GENERIC_STATFS_H
 #define _GENERIC_STATFS_H
 
-#ifndef __KERNEL_STRICT_NAMES
-# include <linux/types.h>
+#include <linux/types.h>
+
+#ifdef __KERNEL__
 typedef __kernel_fsid_t	fsid_t;
 #endif
 
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
 
diff --git a/include/drm/drm.h b/include/drm/drm.h
index 8e77357..7cb50bd 100644
--- a/include/drm/drm.h
+++ b/include/drm/drm.h
@@ -36,8 +36,7 @@
 #ifndef _DRM_H_
 #define _DRM_H_
 
-#if defined(__KERNEL__)
-#endif
+#include <linux/types.h>
 #include <asm/ioctl.h>		/* For _IO* macros */
 #define DRM_IOCTL_NR(n)		_IOC_NR(n)
 #define DRM_IOC_VOID		_IOC_NONE
@@ -497,8 +496,8 @@ union drm_wait_vblank {
  * \sa drmModesetCtl().
  */
 struct drm_modeset_ctl {
-	uint32_t crtc;
-	uint32_t cmd;
+	__u32 crtc;
+	__u32 cmd;
 };
 
 /**
@@ -574,29 +573,29 @@ struct drm_set_version {
 /** DRM_IOCTL_GEM_CLOSE ioctl argument type */
 struct drm_gem_close {
 	/** Handle of the object to be closed. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 };
 
 /** DRM_IOCTL_GEM_FLINK ioctl argument type */
 struct drm_gem_flink {
 	/** Handle for the object being named */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Returned global name */
-	uint32_t name;
+	__u32 name;
 };
 
 /** DRM_IOCTL_GEM_OPEN ioctl argument type */
 struct drm_gem_open {
 	/** Name of object being opened */
-	uint32_t name;
+	__u32 name;
 
 	/** Returned handle for the object */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Returned size of the object */
-	uint64_t size;
+	__u64 size;
 };
 
 #include "drm_mode.h"
diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
index 601d2bd..ae304cc 100644
--- a/include/drm/drm_mode.h
+++ b/include/drm/drm_mode.h
@@ -27,11 +27,8 @@
 #ifndef _DRM_MODE_H
 #define _DRM_MODE_H
 
-#if !defined(__KERNEL__) && !defined(_KERNEL)
-#include <stdint.h>
-#else
 #include <linux/kernel.h>
-#endif
+#include <linux/types.h>
 
 #define DRM_DISPLAY_INFO_LEN	32
 #define DRM_CONNECTOR_NAME_LEN	32
@@ -81,41 +78,41 @@
 #define DRM_MODE_DITHERING_ON	1
 
 struct drm_mode_modeinfo {
-	uint32_t clock;
-	uint16_t hdisplay, hsync_start, hsync_end, htotal, hskew;
-	uint16_t vdisplay, vsync_start, vsync_end, vtotal, vscan;
+	__u32 clock;
+	__u16 hdisplay, hsync_start, hsync_end, htotal, hskew;
+	__u16 vdisplay, vsync_start, vsync_end, vtotal, vscan;
 
-	uint32_t vrefresh; /* vertical refresh * 1000 */
+	__u32 vrefresh; /* vertical refresh * 1000 */
 
-	uint32_t flags;
-	uint32_t type;
+	__u32 flags;
+	__u32 type;
 	char name[DRM_DISPLAY_MODE_LEN];
 };
 
 struct drm_mode_card_res {
-	uint64_t fb_id_ptr;
-	uint64_t crtc_id_ptr;
-	uint64_t connector_id_ptr;
-	uint64_t encoder_id_ptr;
-	uint32_t count_fbs;
-	uint32_t count_crtcs;
-	uint32_t count_connectors;
-	uint32_t count_encoders;
-	uint32_t min_width, max_width;
-	uint32_t min_height, max_height;
+	__u64 fb_id_ptr;
+	__u64 crtc_id_ptr;
+	__u64 connector_id_ptr;
+	__u64 encoder_id_ptr;
+	__u32 count_fbs;
+	__u32 count_crtcs;
+	__u32 count_connectors;
+	__u32 count_encoders;
+	__u32 min_width, max_width;
+	__u32 min_height, max_height;
 };
 
 struct drm_mode_crtc {
-	uint64_t set_connectors_ptr;
-	uint32_t count_connectors;
+	__u64 set_connectors_ptr;
+	__u32 count_connectors;
 
-	uint32_t crtc_id; /**< Id */
-	uint32_t fb_id; /**< Id of framebuffer */
+	__u32 crtc_id; /**< Id */
+	__u32 fb_id; /**< Id of framebuffer */
 
-	uint32_t x, y; /**< Position on the frameuffer */
+	__u32 x, y; /**< Position on the frameuffer */
 
-	uint32_t gamma_size;
-	uint32_t mode_valid;
+	__u32 gamma_size;
+	__u32 mode_valid;
 	struct drm_mode_modeinfo mode;
 };
 
@@ -126,13 +123,13 @@ struct drm_mode_crtc {
 #define DRM_MODE_ENCODER_TVDAC	4
 
 struct drm_mode_get_encoder {
-	uint32_t encoder_id;
-	uint32_t encoder_type;
+	__u32 encoder_id;
+	__u32 encoder_type;
 
-	uint32_t crtc_id; /**< Id of crtc */
+	__u32 crtc_id; /**< Id of crtc */
 
-	uint32_t possible_crtcs;
-	uint32_t possible_clones;
+	__u32 possible_crtcs;
+	__u32 possible_clones;
 };
 
 /* This is for connectors with multiple signal types. */
@@ -161,23 +158,23 @@ struct drm_mode_get_encoder {
 
 struct drm_mode_get_connector {
 
-	uint64_t encoders_ptr;
-	uint64_t modes_ptr;
-	uint64_t props_ptr;
-	uint64_t prop_values_ptr;
+	__u64 encoders_ptr;
+	__u64 modes_ptr;
+	__u64 props_ptr;
+	__u64 prop_values_ptr;
 
-	uint32_t count_modes;
-	uint32_t count_props;
-	uint32_t count_encoders;
+	__u32 count_modes;
+	__u32 count_props;
+	__u32 count_encoders;
 
-	uint32_t encoder_id; /**< Current Encoder */
-	uint32_t connector_id; /**< Id */
-	uint32_t connector_type;
-	uint32_t connector_type_id;
+	__u32 encoder_id; /**< Current Encoder */
+	__u32 connector_id; /**< Id */
+	__u32 connector_type;
+	__u32 connector_type_id;
 
-	uint32_t connection;
-	uint32_t mm_width, mm_height; /**< HxW in millimeters */
-	uint32_t subpixel;
+	__u32 connection;
+	__u32 mm_width, mm_height; /**< HxW in millimeters */
+	__u32 subpixel;
 };
 
 #define DRM_MODE_PROP_PENDING	(1<<0)
@@ -187,46 +184,46 @@ struct drm_mode_get_connector {
 #define DRM_MODE_PROP_BLOB	(1<<4)
 
 struct drm_mode_property_enum {
-	uint64_t value;
+	__u64 value;
 	char name[DRM_PROP_NAME_LEN];
 };
 
 struct drm_mode_get_property {
-	uint64_t values_ptr; /* values and blob lengths */
-	uint64_t enum_blob_ptr; /* enum and blob id ptrs */
+	__u64 values_ptr; /* values and blob lengths */
+	__u64 enum_blob_ptr; /* enum and blob id ptrs */
 
-	uint32_t prop_id;
-	uint32_t flags;
+	__u32 prop_id;
+	__u32 flags;
 	char name[DRM_PROP_NAME_LEN];
 
-	uint32_t count_values;
-	uint32_t count_enum_blobs;
+	__u32 count_values;
+	__u32 count_enum_blobs;
 };
 
 struct drm_mode_connector_set_property {
-	uint64_t value;
-	uint32_t prop_id;
-	uint32_t connector_id;
+	__u64 value;
+	__u32 prop_id;
+	__u32 connector_id;
 };
 
 struct drm_mode_get_blob {
-	uint32_t blob_id;
-	uint32_t length;
-	uint64_t data;
+	__u32 blob_id;
+	__u32 length;
+	__u64 data;
 };
 
 struct drm_mode_fb_cmd {
-	uint32_t fb_id;
-	uint32_t width, height;
-	uint32_t pitch;
-	uint32_t bpp;
-	uint32_t depth;
+	__u32 fb_id;
+	__u32 width, height;
+	__u32 pitch;
+	__u32 bpp;
+	__u32 depth;
 	/* driver specific handle */
-	uint32_t handle;
+	__u32 handle;
 };
 
 struct drm_mode_mode_cmd {
-	uint32_t connector_id;
+	__u32 connector_id;
 	struct drm_mode_modeinfo mode;
 };
 
@@ -248,24 +245,24 @@ struct drm_mode_mode_cmd {
  *    y
  */
 struct drm_mode_cursor {
-	uint32_t flags;
-	uint32_t crtc_id;
-	int32_t x;
-	int32_t y;
-	uint32_t width;
-	uint32_t height;
+	__u32 flags;
+	__u32 crtc_id;
+	__s32 x;
+	__s32 y;
+	__u32 width;
+	__u32 height;
 	/* driver specific handle */
-	uint32_t handle;
+	__u32 handle;
 };
 
 struct drm_mode_crtc_lut {
-	uint32_t crtc_id;
-	uint32_t gamma_size;
+	__u32 crtc_id;
+	__u32 gamma_size;
 
 	/* pointers to arrays */
-	uint64_t red;
-	uint64_t green;
-	uint64_t blue;
+	__u64 red;
+	__u64 green;
+	__u64 blue;
 };
 
 #endif
diff --git a/include/drm/i915_drm.h b/include/drm/i915_drm.h
index 912cd52..67e3353 100644
--- a/include/drm/i915_drm.h
+++ b/include/drm/i915_drm.h
@@ -30,7 +30,7 @@
 /* Please note that modifications to all structs defined here are
  * subject to backwards-compatibility constraints.
  */
-
+#include <linux/types.h>
 #include "drm.h"
 
 /* Each region is a minimum of 16k, and there are at most 255 of them.
@@ -116,15 +116,15 @@ typedef struct _drm_i915_sarea {
 
 	/* fill out some space for old userspace triple buffer */
 	drm_handle_t unused_handle;
-	uint32_t unused1, unused2, unused3;
+	__u32 unused1, unused2, unused3;
 
 	/* buffer object handles for static buffers. May change
 	 * over the lifetime of the client.
 	 */
-	uint32_t front_bo_handle;
-	uint32_t back_bo_handle;
-	uint32_t unused_bo_handle;
-	uint32_t depth_bo_handle;
+	__u32 front_bo_handle;
+	__u32 back_bo_handle;
+	__u32 unused_bo_handle;
+	__u32 depth_bo_handle;
 
 } drm_i915_sarea_t;
 
@@ -327,7 +327,7 @@ typedef struct drm_i915_vblank_swap {
 } drm_i915_vblank_swap_t;
 
 typedef struct drm_i915_hws_addr {
-	uint64_t addr;
+	__u64 addr;
 } drm_i915_hws_addr_t;
 
 struct drm_i915_gem_init {
@@ -335,12 +335,12 @@ struct drm_i915_gem_init {
 	 * Beginning offset in the GTT to be managed by the DRM memory
 	 * manager.
 	 */
-	uint64_t gtt_start;
+	__u64 gtt_start;
 	/**
 	 * Ending offset in the GTT to be managed by the DRM memory
 	 * manager.
 	 */
-	uint64_t gtt_end;
+	__u64 gtt_end;
 };
 
 struct drm_i915_gem_create {
@@ -349,94 +349,94 @@ struct drm_i915_gem_create {
 	 *
 	 * The (page-aligned) allocated size for the object will be returned.
 	 */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Returned handle for the object.
 	 *
 	 * Object handles are nonzero.
 	 */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 };
 
 struct drm_i915_gem_pread {
 	/** Handle for the object being read. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset into the object to read from */
-	uint64_t offset;
+	__u64 offset;
 	/** Length of data to read */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Pointer to write the data into.
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t data_ptr;
+	__u64 data_ptr;
 };
 
 struct drm_i915_gem_pwrite {
 	/** Handle for the object being written to. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset into the object to write to */
-	uint64_t offset;
+	__u64 offset;
 	/** Length of data to write */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Pointer to read the data from.
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t data_ptr;
+	__u64 data_ptr;
 };
 
 struct drm_i915_gem_mmap {
 	/** Handle for the object being mapped. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/** Offset in the object to map. */
-	uint64_t offset;
+	__u64 offset;
 	/**
 	 * Length of data to map.
 	 *
 	 * The value will be page-aligned.
 	 */
-	uint64_t size;
+	__u64 size;
 	/**
 	 * Returned pointer the data was mapped at.
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t addr_ptr;
+	__u64 addr_ptr;
 };
 
 struct drm_i915_gem_mmap_gtt {
 	/** Handle for the object being mapped. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 	/**
 	 * Fake offset to use for subsequent mmap call
 	 *
 	 * This is a fixed-size type for 32/64 compatibility.
 	 */
-	uint64_t offset;
+	__u64 offset;
 };
 
 struct drm_i915_gem_set_domain {
 	/** Handle for the object */
-	uint32_t handle;
+	__u32 handle;
 
 	/** New read domains */
-	uint32_t read_domains;
+	__u32 read_domains;
 
 	/** New write domain */
-	uint32_t write_domain;
+	__u32 write_domain;
 };
 
 struct drm_i915_gem_sw_finish {
 	/** Handle for the object */
-	uint32_t handle;
+	__u32 handle;
 };
 
 struct drm_i915_gem_relocation_entry {
@@ -448,16 +448,16 @@ struct drm_i915_gem_relocation_entry {
 	 * a relocation list for state buffers and not re-write it per
 	 * exec using the buffer.
 	 */
-	uint32_t target_handle;
+	__u32 target_handle;
 
 	/**
 	 * Value to be added to the offset of the target buffer to make up
 	 * the relocation entry.
 	 */
-	uint32_t delta;
+	__u32 delta;
 
 	/** Offset in the buffer the relocation entry will be written into */
-	uint64_t offset;
+	__u64 offset;
 
 	/**
 	 * Offset value of the target buffer that the relocation entry was last
@@ -467,12 +467,12 @@ struct drm_i915_gem_relocation_entry {
 	 * and writing the relocation.  This value is written back out by
 	 * the execbuffer ioctl when the relocation is written.
 	 */
-	uint64_t presumed_offset;
+	__u64 presumed_offset;
 
 	/**
 	 * Target memory domains read by this operation.
 	 */
-	uint32_t read_domains;
+	__u32 read_domains;
 
 	/**
 	 * Target memory domains written by this operation.
@@ -481,7 +481,7 @@ struct drm_i915_gem_relocation_entry {
 	 * execbuffer operation, so that where there are conflicts,
 	 * the application will get -EINVAL back.
 	 */
-	uint32_t write_domain;
+	__u32 write_domain;
 };
 
 /** @{
@@ -512,24 +512,24 @@ struct drm_i915_gem_exec_object {
 	 * User's handle for a buffer to be bound into the GTT for this
 	 * operation.
 	 */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Number of relocations to be performed on this buffer */
-	uint32_t relocation_count;
+	__u32 relocation_count;
 	/**
 	 * Pointer to array of struct drm_i915_gem_relocation_entry containing
 	 * the relocations to be performed in this buffer.
 	 */
-	uint64_t relocs_ptr;
+	__u64 relocs_ptr;
 
 	/** Required alignment in graphics aperture */
-	uint64_t alignment;
+	__u64 alignment;
 
 	/**
 	 * Returned value of the updated offset of the object, for future
 	 * presumed_offset writes.
 	 */
-	uint64_t offset;
+	__u64 offset;
 };
 
 struct drm_i915_gem_execbuffer {
@@ -543,44 +543,44 @@ struct drm_i915_gem_execbuffer {
 	 * a buffer is performing refer to buffers that have already appeared
 	 * in the validate list.
 	 */
-	uint64_t buffers_ptr;
-	uint32_t buffer_count;
+	__u64 buffers_ptr;
+	__u32 buffer_count;
 
 	/** Offset in the batchbuffer to start execution from. */
-	uint32_t batch_start_offset;
+	__u32 batch_start_offset;
 	/** Bytes used in batchbuffer from batch_start_offset */
-	uint32_t batch_len;
-	uint32_t DR1;
-	uint32_t DR4;
-	uint32_t num_cliprects;
+	__u32 batch_len;
+	__u32 DR1;
+	__u32 DR4;
+	__u32 num_cliprects;
 	/** This is a struct drm_clip_rect *cliprects */
-	uint64_t cliprects_ptr;
+	__u64 cliprects_ptr;
 };
 
 struct drm_i915_gem_pin {
 	/** Handle of the buffer to be pinned. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 
 	/** alignment required within the aperture */
-	uint64_t alignment;
+	__u64 alignment;
 
 	/** Returned GTT offset of the buffer. */
-	uint64_t offset;
+	__u64 offset;
 };
 
 struct drm_i915_gem_unpin {
 	/** Handle of the buffer to be unpinned. */
-	uint32_t handle;
-	uint32_t pad;
+	__u32 handle;
+	__u32 pad;
 };
 
 struct drm_i915_gem_busy {
 	/** Handle of the buffer to check for busy */
-	uint32_t handle;
+	__u32 handle;
 
 	/** Return busy status (1 if busy, 0 if idle) */
-	uint32_t busy;
+	__u32 busy;
 };
 
 #define I915_TILING_NONE	0
@@ -597,7 +597,7 @@ struct drm_i915_gem_busy {
 
 struct drm_i915_gem_set_tiling {
 	/** Handle of the buffer to have its tiling state updated */
-	uint32_t handle;
+	__u32 handle;
 
 	/**
 	 * Tiling mode for the object (I915_TILING_NONE, I915_TILING_X,
@@ -611,47 +611,47 @@ struct drm_i915_gem_set_tiling {
 	 *
 	 * Buffer contents become undefined when changing tiling_mode.
 	 */
-	uint32_t tiling_mode;
+	__u32 tiling_mode;
 
 	/**
 	 * Stride in bytes for the object when in I915_TILING_X or
 	 * I915_TILING_Y.
 	 */
-	uint32_t stride;
+	__u32 stride;
 
 	/**
 	 * Returned address bit 6 swizzling required for CPU access through
 	 * mmap mapping.
 	 */
-	uint32_t swizzle_mode;
+	__u32 swizzle_mode;
 };
 
 struct drm_i915_gem_get_tiling {
 	/** Handle of the buffer to get tiling state for. */
-	uint32_t handle;
+	__u32 handle;
 
 	/**
 	 * Current tiling mode for the object (I915_TILING_NONE, I915_TILING_X,
 	 * I915_TILING_Y).
 	 */
-	uint32_t tiling_mode;
+	__u32 tiling_mode;
 
 	/**
 	 * Returned address bit 6 swizzling required for CPU access through
 	 * mmap mapping.
 	 */
-	uint32_t swizzle_mode;
+	__u32 swizzle_mode;
 };
 
 struct drm_i915_gem_get_aperture {
 	/** Total size of the aperture used by i915_gem_execbuffer, in bytes */
-	uint64_t aper_size;
+	__u64 aper_size;
 
 	/**
 	 * Available space in the aperture used by i915_gem_execbuffer, in
 	 * bytes
 	 */
-	uint64_t aper_available_size;
+	__u64 aper_available_size;
 };
 
 #endif				/* _I915_DRM_H_ */
diff --git a/include/drm/mga_drm.h b/include/drm/mga_drm.h
index 944b50a..325fd6f 100644
--- a/include/drm/mga_drm.h
+++ b/include/drm/mga_drm.h
@@ -35,6 +35,8 @@
 #ifndef __MGA_DRM_H__
 #define __MGA_DRM_H__
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the Xserver file (mga_sarea.h)
  */
@@ -255,8 +257,8 @@ typedef struct _drm_mga_sarea {
 #define DRM_IOCTL_MGA_ILOAD    DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_ILOAD, drm_mga_iload_t)
 #define DRM_IOCTL_MGA_BLIT     DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_BLIT, drm_mga_blit_t)
 #define DRM_IOCTL_MGA_GETPARAM DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_GETPARAM, drm_mga_getparam_t)
-#define DRM_IOCTL_MGA_SET_FENCE     DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_SET_FENCE, uint32_t)
-#define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, uint32_t)
+#define DRM_IOCTL_MGA_SET_FENCE     DRM_IOW( DRM_COMMAND_BASE + DRM_MGA_SET_FENCE, __u32)
+#define DRM_IOCTL_MGA_WAIT_FENCE    DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_WAIT_FENCE, __u32)
 #define DRM_IOCTL_MGA_DMA_BOOTSTRAP DRM_IOWR(DRM_COMMAND_BASE + DRM_MGA_DMA_BOOTSTRAP, drm_mga_dma_bootstrap_t)
 
 typedef struct _drm_mga_warp_index {
@@ -310,7 +312,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 */
 	/*@{ */
 	unsigned long texture_handle; /**< Handle used to map AGP textures. */
-	uint32_t texture_size;	      /**< Size of the AGP texture region. */
+	__u32 texture_size;	      /**< Size of the AGP texture region. */
 	/*@} */
 
 	/**
@@ -319,7 +321,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 * On return from the DRM_MGA_DMA_BOOTSTRAP ioctl, this field will be
 	 * filled in with the actual AGP mode.  If AGP was not available
 	 */
-	uint32_t primary_size;
+	__u32 primary_size;
 
 	/**
 	 * Requested number of secondary DMA buffers.
@@ -329,7 +331,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 * allocated.  Particularly when PCI DMA is used, this may be
 	 * (subtantially) less than the number requested.
 	 */
-	uint32_t secondary_bin_count;
+	__u32 secondary_bin_count;
 
 	/**
 	 * Requested size of each secondary DMA buffer.
@@ -338,7 +340,7 @@ typedef struct drm_mga_dma_bootstrap {
 	 * dma_mga_dma_bootstrap::secondary_bin_count, it is \b not allowed
 	 * to reduce dma_mga_dma_bootstrap::secondary_bin_size.
 	 */
-	uint32_t secondary_bin_size;
+	__u32 secondary_bin_size;
 
 	/**
 	 * Bit-wise mask of AGPSTAT2_* values.  Currently only \c AGPSTAT2_1X,
@@ -350,12 +352,12 @@ typedef struct drm_mga_dma_bootstrap {
 	 * filled in with the actual AGP mode.  If AGP was not available
 	 * (i.e., PCI DMA was used), this value will be zero.
 	 */
-	uint32_t agp_mode;
+	__u32 agp_mode;
 
 	/**
 	 * Desired AGP GART size, measured in megabytes.
 	 */
-	uint8_t agp_size;
+	__u8 agp_size;
 } drm_mga_dma_bootstrap_t;
 
 typedef struct drm_mga_clear {
diff --git a/include/drm/radeon_drm.h b/include/drm/radeon_drm.h
index 73ff51f..72ecf67 100644
--- a/include/drm/radeon_drm.h
+++ b/include/drm/radeon_drm.h
@@ -33,6 +33,8 @@
 #ifndef __RADEON_DRM_H__
 #define __RADEON_DRM_H__
 
+#include <linux/types.h>
+
 /* WARNING: If you change any of these defines, make sure to change the
  * defines in the X server file (radeon_sarea.h)
  */
@@ -722,7 +724,7 @@ typedef struct drm_radeon_irq_wait {
 
 typedef struct drm_radeon_setparam {
 	unsigned int param;
-	int64_t value;
+	__s64 value;
 } drm_radeon_setparam_t;
 
 #define RADEON_SETPARAM_FB_LOCATION    1	/* determined framebuffer location */
diff --git a/include/drm/via_drm.h b/include/drm/via_drm.h
index a3b5c10..170786e 100644
--- a/include/drm/via_drm.h
+++ b/include/drm/via_drm.h
@@ -24,6 +24,8 @@
 #ifndef _VIA_DRM_H_
 #define _VIA_DRM_H_
 
+#include <linux/types.h>
+
 /* WARNING: These defines must be the same as what the Xserver uses.
  * if you change them, you must change the defines in the Xserver.
  */
@@ -114,19 +116,19 @@
 #define VIA_MEM_UNKNOWN 4
 
 typedef struct {
-	uint32_t offset;
-	uint32_t size;
+	__u32 offset;
+	__u32 size;
 } drm_via_agp_t;
 
 typedef struct {
-	uint32_t offset;
-	uint32_t size;
+	__u32 offset;
+	__u32 size;
 } drm_via_fb_t;
 
 typedef struct {
-	uint32_t context;
-	uint32_t type;
-	uint32_t size;
+	__u32 context;
+	__u32 type;
+	__u32 size;
 	unsigned long index;
 	unsigned long offset;
 } drm_via_mem_t;
@@ -148,9 +150,9 @@ typedef struct _drm_via_futex {
 		VIA_FUTEX_WAIT = 0x00,
 		VIA_FUTEX_WAKE = 0X01
 	} func;
-	uint32_t ms;
-	uint32_t lock;
-	uint32_t val;
+	__u32 ms;
+	__u32 lock;
+	__u32 val;
 } drm_via_futex_t;
 
 typedef struct _drm_via_dma_init {
@@ -211,7 +213,7 @@ typedef struct _drm_via_cmdbuf_size {
 		VIA_CMDBUF_LAG = 0x02
 	} func;
 	int wait;
-	uint32_t size;
+	__u32 size;
 } drm_via_cmdbuf_size_t;
 
 typedef enum {
@@ -236,8 +238,8 @@ enum drm_via_irqs {
 struct drm_via_wait_irq_request {
 	unsigned irq;
 	via_irq_seq_type_t type;
-	uint32_t sequence;
-	uint32_t signal;
+	__u32 sequence;
+	__u32 signal;
 };
 
 typedef union drm_via_irqwait {
@@ -246,7 +248,7 @@ typedef union drm_via_irqwait {
 } drm_via_irqwait_t;
 
 typedef struct drm_via_blitsync {
-	uint32_t sync_handle;
+	__u32 sync_handle;
 	unsigned engine;
 } drm_via_blitsync_t;
 
@@ -257,16 +259,16 @@ typedef struct drm_via_blitsync {
  */
 
 typedef struct drm_via_dmablit {
-	uint32_t num_lines;
-	uint32_t line_length;
+	__u32 num_lines;
+	__u32 line_length;
 
-	uint32_t fb_addr;
-	uint32_t fb_stride;
+	__u32 fb_addr;
+	__u32 fb_stride;
 
 	unsigned char *mem_addr;
-	uint32_t mem_stride;
+	__u32 mem_stride;
 
-	uint32_t flags;
+	__u32 flags;
 	int to_fb;
 
 	drm_via_blitsync_t sync;
diff --git a/include/linux/agpgart.h b/include/linux/agpgart.h
index 110c600..f6778ec 100644
--- a/include/linux/agpgart.h
+++ b/include/linux/agpgart.h
@@ -77,20 +77,20 @@ typedef struct _agp_setup {
  * The "prot" down below needs still a "sleep" flag somehow ...
  */
 typedef struct _agp_segment {
-	off_t pg_start;		/* starting page to populate    */
-	size_t pg_count;	/* number of pages              */
-	int prot;		/* prot flags for mmap          */
+	__kernel_off_t pg_start;	/* starting page to populate    */
+	__kernel_size_t pg_count;	/* number of pages              */
+	int prot;			/* prot flags for mmap          */
 } agp_segment;
 
 typedef struct _agp_region {
-	pid_t pid;		/* pid of process               */
-	size_t seg_count;	/* number of segments           */
+	__kernel_pid_t pid;		/* pid of process       */
+	__kernel_size_t seg_count;	/* number of segments   */
 	struct _agp_segment *seg_list;
 } agp_region;
 
 typedef struct _agp_allocate {
 	int key;		/* tag of allocation            */
-	size_t pg_count;	/* number of pages              */
+	__kernel_size_t pg_count;/* number of pages             */
 	__u32 type;		/* 0 == normal, other devspec   */
    	__u32 physical;         /* device specific (some devices  
 				 * need a phys address of the     
@@ -100,7 +100,7 @@ typedef struct _agp_allocate {
 
 typedef struct _agp_bind {
 	int key;		/* tag of allocation            */
-	off_t pg_start;		/* starting page to populate    */
+	__kernel_off_t pg_start;/* starting page to populate    */
 } agp_bind;
 
 typedef struct _agp_unbind {
diff --git a/include/linux/atmlec.h b/include/linux/atmlec.h
index 6f5a1ba..39c917f 100644
--- a/include/linux/atmlec.h
+++ b/include/linux/atmlec.h
@@ -11,6 +11,7 @@
 #include <linux/atmioc.h>
 #include <linux/atm.h>
 #include <linux/if_ether.h>
+#include <linux/types.h>
 
 /* ATM lec daemon control socket */
 #define ATMLEC_CTRL	_IO('a', ATMIOC_LANE)
@@ -78,8 +79,8 @@ struct atmlec_msg {
 		} normal;
 		struct atmlec_config_msg config;
 		struct {
-			uint16_t lec_id;			/* requestor lec_id  */
-			uint32_t tran_id;			/* transaction id    */
+			__u16 lec_id;				/* requestor lec_id  */
+			__u32 tran_id;				/* transaction id    */
 			unsigned char mac_addr[ETH_ALEN];	/* dst mac addr      */
 			unsigned char atm_addr[ATM_ESA_LEN];	/* reqestor ATM addr */
 		} proxy;	/*
diff --git a/include/linux/atmmpc.h b/include/linux/atmmpc.h
index ea16504..2aba578 100644
--- a/include/linux/atmmpc.h
+++ b/include/linux/atmmpc.h
@@ -4,6 +4,7 @@
 #include <linux/atmapi.h>
 #include <linux/atmioc.h>
 #include <linux/atm.h>
+#include <linux/types.h>
 
 #define ATMMPC_CTRL _IO('a', ATMIOC_MPOA)
 #define ATMMPC_DATA _IO('a', ATMIOC_MPOA+1)
@@ -18,39 +19,39 @@ struct atmmpc_ioc {
 };
 
 typedef struct in_ctrl_info {
-        uint8_t   Last_NHRP_CIE_code;
-        uint8_t   Last_Q2931_cause_value;     
-        uint8_t   eg_MPC_ATM_addr[ATM_ESA_LEN];
+        __u8   Last_NHRP_CIE_code;
+        __u8   Last_Q2931_cause_value;
+        __u8   eg_MPC_ATM_addr[ATM_ESA_LEN];
         __be32  tag;
         __be32  in_dst_ip;      /* IP address this ingress MPC sends packets to */
-        uint16_t  holding_time;
-        uint32_t  request_id;
+        __u16  holding_time;
+        __u32  request_id;
 } in_ctrl_info;
 
 typedef struct eg_ctrl_info {
-        uint8_t   DLL_header[256];
-        uint8_t   DH_length;
+        __u8   DLL_header[256];
+        __u8   DH_length;
         __be32  cache_id;
         __be32  tag;
         __be32  mps_ip;
         __be32  eg_dst_ip;      /* IP address to which ingress MPC sends packets */
-        uint8_t   in_MPC_data_ATM_addr[ATM_ESA_LEN];
-        uint16_t  holding_time;
+        __u8   in_MPC_data_ATM_addr[ATM_ESA_LEN];
+        __u16  holding_time;
 } eg_ctrl_info;
 
 struct mpc_parameters {
-        uint16_t mpc_p1;   /* Shortcut-Setup Frame Count    */
-        uint16_t mpc_p2;   /* Shortcut-Setup Frame Time     */
-        uint8_t mpc_p3[8]; /* Flow-detection Protocols      */
-        uint16_t mpc_p4;   /* MPC Initial Retry Time        */
-        uint16_t mpc_p5;   /* MPC Retry Time Maximum        */
-        uint16_t mpc_p6;   /* Hold Down Time                */      
+        __u16 mpc_p1;   /* Shortcut-Setup Frame Count    */
+        __u16 mpc_p2;   /* Shortcut-Setup Frame Time     */
+        __u8 mpc_p3[8]; /* Flow-detection Protocols      */
+        __u16 mpc_p4;   /* MPC Initial Retry Time        */
+        __u16 mpc_p5;   /* MPC Retry Time Maximum        */
+        __u16 mpc_p6;   /* Hold Down Time                */
 } ;
 
 struct k_message {
-        uint16_t type;
+        __u16 type;
         __be32 ip_mask;
-        uint8_t  MPS_ctrl[ATM_ESA_LEN];
+        __u8  MPS_ctrl[ATM_ESA_LEN];
         union {
                 in_ctrl_info in_info;
                 eg_ctrl_info eg_info;
@@ -61,11 +62,11 @@ struct k_message {
 
 struct llc_snap_hdr {
 	/* RFC 1483 LLC/SNAP encapsulation for routed IP PDUs */
-        uint8_t  dsap;    /* Destination Service Access Point (0xAA)     */
-        uint8_t  ssap;    /* Source Service Access Point      (0xAA)     */
-        uint8_t  ui;      /* Unnumbered Information           (0x03)     */
-        uint8_t  org[3];  /* Organizational identification    (0x000000) */
-        uint8_t  type[2]; /* Ether type (for IP)              (0x0800)   */
+        __u8  dsap;    /* Destination Service Access Point (0xAA)     */
+        __u8  ssap;    /* Source Service Access Point      (0xAA)     */
+        __u8  ui;      /* Unnumbered Information           (0x03)     */
+        __u8  org[3];  /* Organizational identification    (0x000000) */
+        __u8  type[2]; /* Ether type (for IP)              (0x0800)   */
 };
 
 /* TLVs this MPC recognizes */
diff --git a/include/linux/cm4000_cs.h b/include/linux/cm4000_cs.h
index 605ebe2..72bfefd 100644
--- a/include/linux/cm4000_cs.h
+++ b/include/linux/cm4000_cs.h
@@ -1,6 +1,8 @@
 #ifndef	_CM4000_H_
 #define	_CM4000_H_
 
+#include <linux/types.h>
+
 #define	MAX_ATR			33
 
 #define	CM4000_MAX_DEV		4
@@ -10,9 +12,9 @@
  * not to break compilation of userspace apps. -HW */
 
 typedef struct atreq {
-	int32_t atr_len;
+	__s32 atr_len;
 	unsigned char atr[64];
-	int32_t power_act;
+	__s32 power_act;
 	unsigned char bIFSD;
 	unsigned char bIFSC;
 } atreq_t;
@@ -22,13 +24,13 @@ typedef struct atreq {
  * member sizes. This leads to CONFIG_COMPAT breakage, since 32bit userspace
  * will lay out the structure members differently than the 64bit kernel.
  *
- * I've changed "ptsreq.protocol" from "unsigned long" to "u_int32_t".
+ * I've changed "ptsreq.protocol" from "unsigned long" to "__u32".
  * On 32bit this will make no difference.  With 64bit kernels, it will make
  * 32bit apps work, too.
  */
 
 typedef struct ptsreq {
-	u_int32_t protocol; /*T=0: 2^0, T=1:  2^1*/
+	__u32 protocol; /*T=0: 2^0, T=1:  2^1*/
  	unsigned char flags;
  	unsigned char pts1;
  	unsigned char pts2;
diff --git a/include/linux/cn_proc.h b/include/linux/cn_proc.h
index 1c86d65..b8125b2 100644
--- a/include/linux/cn_proc.h
+++ b/include/linux/cn_proc.h
@@ -65,20 +65,20 @@ struct proc_event {
 		} ack;
 
 		struct fork_proc_event {
-			pid_t parent_pid;
-			pid_t parent_tgid;
-			pid_t child_pid;
-			pid_t child_tgid;
+			__kernel_pid_t parent_pid;
+			__kernel_pid_t parent_tgid;
+			__kernel_pid_t child_pid;
+			__kernel_pid_t child_tgid;
 		} fork;
 
 		struct exec_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 		} exec;
 
 		struct id_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 			union {
 				__u32 ruid; /* task uid */
 				__u32 rgid; /* task gid */
@@ -90,8 +90,8 @@ struct proc_event {
 		} id;
 
 		struct exit_proc_event {
-			pid_t process_pid;
-			pid_t process_tgid;
+			__kernel_pid_t process_pid;
+			__kernel_pid_t process_tgid;
 			__u32 exit_code, exit_signal;
 		} exit;
 	} event_data;
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 07ae8f8..5b5d473 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -6,6 +6,7 @@
 #define CODA_PSDEV_MAJOR 67
 #define MAX_CODADEVS  5	   /* how many do we allow */
 
+#ifdef __KERNEL__
 struct kstatfs;
 
 /* communication pending/processing queues */
@@ -24,7 +25,6 @@ static inline struct venus_comm *coda_vcp(struct super_block *sb)
 	return (struct venus_comm *)((sb)->s_fs_info);
 }
 
-
 /* upcalls */
 int venus_rootfid(struct super_block *sb, struct CodaFid *fidp);
 int venus_getattr(struct super_block *sb, struct CodaFid *fid,
@@ -64,6 +64,12 @@ int coda_downcall(int opcode, union outputArgs *out, struct super_block *sb);
 int venus_fsync(struct super_block *sb, struct CodaFid *fid);
 int venus_statfs(struct dentry *dentry, struct kstatfs *sfs);
 
+/*
+ * Statistics
+ */
+
+extern struct venus_comm coda_comms[];
+#endif /* __KERNEL__ */
 
 /* messages between coda filesystem in kernel and Venus */
 struct upc_req {
@@ -82,11 +88,4 @@ struct upc_req {
 #define REQ_WRITE  0x4
 #define REQ_ABORT  0x8
 
-
-/*
- * Statistics
- */
-
-extern struct venus_comm coda_comms[];
-
 #endif
diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 0999271..450fa59 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -3,8 +3,10 @@
 #endif
 
 /* GCC 4.1.[01] miscompiles __weak */
-#if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
-# error Your version of gcc miscompiles the __weak directive
+#ifdef __KERNEL__
+# if __GNUC_MINOR__ == 1 && __GNUC_PATCHLEVEL__ <= 1
+#  error Your version of gcc miscompiles the __weak directive
+# endif
 #endif
 
 #define __used			__attribute__((__used__))
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index d06fbf2..788850b 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -82,9 +82,9 @@ struct cyclades_monitor {
  * open)
  */
 struct cyclades_idle_stats {
-    time_t	   in_use;	/* Time device has been in use (secs) */
-    time_t	   recv_idle;	/* Time since last char received (secs) */
-    time_t	   xmit_idle;	/* Time since last char transmitted (secs) */
+    __kernel_time_t in_use;	/* Time device has been in use (secs) */
+    __kernel_time_t recv_idle;	/* Time since last char received (secs) */
+    __kernel_time_t xmit_idle;	/* Time since last char transmitted (secs) */
     unsigned long  recv_bytes;	/* Bytes received */
     unsigned long  xmit_bytes;	/* Bytes transmitted */
     unsigned long  overruns;	/* Input overruns */
diff --git a/include/linux/dlm_netlink.h b/include/linux/dlm_netlink.h
index 1927633..647c8ef 100644
--- a/include/linux/dlm_netlink.h
+++ b/include/linux/dlm_netlink.h
@@ -9,6 +9,8 @@
 #ifndef _DLM_NETLINK_H
 #define _DLM_NETLINK_H
 
+#include <linux/types.h>
+
 enum {
 	DLM_STATUS_WAITING = 1,
 	DLM_STATUS_GRANTED = 2,
@@ -18,16 +20,16 @@ enum {
 #define DLM_LOCK_DATA_VERSION 1
 
 struct dlm_lock_data {
-	uint16_t version;
-	uint32_t lockspace_id;
+	__u16 version;
+	__u32 lockspace_id;
 	int nodeid;
 	int ownpid;
-	uint32_t id;
-	uint32_t remid;
-	uint64_t xid;
-	int8_t status;
-	int8_t grmode;
-	int8_t rqmode;
+	__u32 id;
+	__u32 remid;
+	__u64 xid;
+	__s8 status;
+	__s8 grmode;
+	__s8 rqmode;
 	unsigned long timestamp;
 	int resource_namelen;
 	char resource_name[DLM_RESNAME_MAXLEN];
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index 28c2940..48e44ee 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -113,20 +113,20 @@ struct dm_ioctl {
 	 * return -ENOTTY) fill out this field, even if the
 	 * command failed.
 	 */
-	uint32_t version[3];	/* in/out */
-	uint32_t data_size;	/* total size of data passed in
+	__u32 version[3];	/* in/out */
+	__u32 data_size;	/* total size of data passed in
 				 * including this struct */
 
-	uint32_t data_start;	/* offset to start of data
+	__u32 data_start;	/* offset to start of data
 				 * relative to start of this struct */
 
-	uint32_t target_count;	/* in/out */
-	int32_t open_count;	/* out */
-	uint32_t flags;		/* in/out */
-	uint32_t event_nr;      	/* in/out */
-	uint32_t padding;
+	__u32 target_count;	/* in/out */
+	__s32 open_count;	/* out */
+	__u32 flags;		/* in/out */
+	__u32 event_nr;      	/* in/out */
+	__u32 padding;
 
-	uint64_t dev;		/* in/out */
+	__u64 dev;		/* in/out */
 
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
@@ -139,9 +139,9 @@ struct dm_ioctl {
  * dm_ioctl.
  */
 struct dm_target_spec {
-	uint64_t sector_start;
-	uint64_t length;
-	int32_t status;		/* used when reading from kernel only */
+	__u64 sector_start;
+	__u64 length;
+	__s32 status;		/* used when reading from kernel only */
 
 	/*
 	 * Location of the next dm_target_spec.
@@ -153,7 +153,7 @@ struct dm_target_spec {
 	 *   (that follows the dm_ioctl struct) to the start of the "next"
 	 *   dm_target_spec.
 	 */
-	uint32_t next;
+	__u32 next;
 
 	char target_type[DM_MAX_TYPE_NAME];
 
@@ -168,17 +168,17 @@ struct dm_target_spec {
  * Used to retrieve the target dependencies.
  */
 struct dm_target_deps {
-	uint32_t count;	/* Array size */
-	uint32_t padding;	/* unused */
-	uint64_t dev[0];	/* out */
+	__u32 count;	/* Array size */
+	__u32 padding;	/* unused */
+	__u64 dev[0];	/* out */
 };
 
 /*
  * Used to get a list of all dm devices.
  */
 struct dm_name_list {
-	uint64_t dev;
-	uint32_t next;		/* offset to the next record from
+	__u64 dev;
+	__u32 next;		/* offset to the next record from
 				   the _start_ of this */
 	char name[0];
 };
@@ -187,8 +187,8 @@ struct dm_name_list {
  * Used to retrieve the target versions
  */
 struct dm_target_versions {
-        uint32_t next;
-        uint32_t version[3];
+        __u32 next;
+        __u32 version[3];
 
         char name[0];
 };
@@ -197,7 +197,7 @@ struct dm_target_versions {
  * Used to pass message to a target
  */
 struct dm_target_msg {
-	uint64_t sector;	/* Device sector */
+	__u64 sector;	/* Device sector */
 
 	char message[0];
 };
diff --git a/include/linux/dvb/audio.h b/include/linux/dvb/audio.h
index bb0df2a..fec66bd 100644
--- a/include/linux/dvb/audio.h
+++ b/include/linux/dvb/audio.h
@@ -76,7 +76,7 @@ struct audio_karaoke{  /* if Vocal1 or Vocal2 are non-zero, they get mixed  */
 } audio_karaoke_t;     /* into left and right  */
 
 
-typedef uint16_t audio_attributes_t;
+typedef __u16 audio_attributes_t;
 /*   bits: descr. */
 /*   15-13 audio coding mode (0=ac3, 2=mpeg1, 3=mpeg2ext, 4=LPCM, 6=DTS, */
 /*   12    multichannel extension */
diff --git a/include/linux/dvb/video.h b/include/linux/dvb/video.h
index bd49c3e..1d750c0 100644
--- a/include/linux/dvb/video.h
+++ b/include/linux/dvb/video.h
@@ -132,12 +132,12 @@ struct video_command {
 #define VIDEO_VSYNC_FIELD_PROGRESSIVE	(3)
 
 struct video_event {
-	int32_t type;
+	__s32 type;
 #define VIDEO_EVENT_SIZE_CHANGED	1
 #define VIDEO_EVENT_FRAME_RATE_CHANGED	2
 #define VIDEO_EVENT_DECODER_STOPPED 	3
 #define VIDEO_EVENT_VSYNC 		4
-	time_t timestamp;
+	__kernel_time_t timestamp;
 	union {
 		video_size_t size;
 		unsigned int frame_rate;	/* in frames per 1000sec */
@@ -157,25 +157,25 @@ struct video_status {
 
 struct video_still_picture {
 	char __user *iFrame;        /* pointer to a single iframe in memory */
-	int32_t size;
+	__s32 size;
 };
 
 
 typedef
 struct video_highlight {
 	int     active;      /*    1=show highlight, 0=hide highlight */
-	uint8_t contrast1;   /*    7- 4  Pattern pixel contrast */
+	__u8    contrast1;   /*    7- 4  Pattern pixel contrast */
 			     /*    3- 0  Background pixel contrast */
-	uint8_t contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
+	__u8    contrast2;   /*    7- 4  Emphasis pixel-2 contrast */
 			     /*    3- 0  Emphasis pixel-1 contrast */
-	uint8_t color1;      /*    7- 4  Pattern pixel color */
+	__u8    color1;      /*    7- 4  Pattern pixel color */
 			     /*    3- 0  Background pixel color */
-	uint8_t color2;      /*    7- 4  Emphasis pixel-2 color */
+	__u8    color2;      /*    7- 4  Emphasis pixel-2 color */
 			     /*    3- 0  Emphasis pixel-1 color */
-	uint32_t ypos;       /*   23-22  auto action mode */
+	__u32    ypos;       /*   23-22  auto action mode */
 			     /*   21-12  start y */
 			     /*    9- 0  end y */
-	uint32_t xpos;       /*   23-22  button color number */
+	__u32    xpos;       /*   23-22  button color number */
 			     /*   21-12  start x */
 			     /*    9- 0  end x */
 } video_highlight_t;
@@ -189,17 +189,17 @@ typedef struct video_spu {
 
 typedef struct video_spu_palette {      /* SPU Palette information */
 	int length;
-	uint8_t __user *palette;
+	__u8 __user *palette;
 } video_spu_palette_t;
 
 
 typedef struct video_navi_pack {
 	int length;          /* 0 ... 1024 */
-	uint8_t data[1024];
+	__u8 data[1024];
 } video_navi_pack_t;
 
 
-typedef uint16_t video_attributes_t;
+typedef __u16 video_attributes_t;
 /*   bits: descr. */
 /*   15-14 Video compression mode (0=MPEG-1, 1=MPEG-2) */
 /*   13-12 TV system (0=525/60, 1=625/50) */
diff --git a/include/linux/if_arcnet.h b/include/linux/if_arcnet.h
index 27ea2ac..0835deb 100644
--- a/include/linux/if_arcnet.h
+++ b/include/linux/if_arcnet.h
@@ -16,6 +16,7 @@
 #ifndef _LINUX_IF_ARCNET_H
 #define _LINUX_IF_ARCNET_H
 
+#include <linux/types.h>
 #include <linux/if_ether.h>
 
 
@@ -57,10 +58,10 @@
  */
 struct arc_rfc1201
 {
-    uint8_t  proto;		/* protocol ID field - varies		*/
-    uint8_t  split_flag;	/* for use with split packets		*/
+    __u8  proto;		/* protocol ID field - varies		*/
+    __u8  split_flag;	/* for use with split packets		*/
     __be16   sequence;		/* sequence number			*/
-    uint8_t  payload[0];	/* space remaining in packet (504 bytes)*/
+    __u8  payload[0];	/* space remaining in packet (504 bytes)*/
 };
 #define RFC1201_HDR_SIZE 4
 
@@ -70,8 +71,8 @@ struct arc_rfc1201
  */
 struct arc_rfc1051
 {
-    uint8_t proto;		/* ARC_P_RFC1051_ARP/RFC1051_IP	*/
-    uint8_t payload[0];		/* 507 bytes			*/
+    __u8 proto;		/* ARC_P_RFC1051_ARP/RFC1051_IP	*/
+    __u8 payload[0];		/* 507 bytes			*/
 };
 #define RFC1051_HDR_SIZE 1
 
@@ -82,20 +83,20 @@ struct arc_rfc1051
  */
 struct arc_eth_encap
 {
-    uint8_t proto;		/* Always ARC_P_ETHER			*/
+    __u8 proto;		/* Always ARC_P_ETHER			*/
     struct ethhdr eth;		/* standard ethernet header (yuck!)	*/
-    uint8_t payload[0];		/* 493 bytes				*/
+    __u8 payload[0];		/* 493 bytes				*/
 };
 #define ETH_ENCAP_HDR_SIZE 14
 
 
 struct arc_cap
 {
-	uint8_t proto;
-	uint8_t cookie[sizeof(int)];   /* Actually NOT sent over the network */
+	__u8 proto;
+	__u8 cookie[sizeof(int)];   /* Actually NOT sent over the network */
 	union {
-		uint8_t ack;
-		uint8_t raw[0];		/* 507 bytes */
+		__u8 ack;
+		__u8 raw[0];		/* 507 bytes */
 	} mes;
 };
 
@@ -109,7 +110,7 @@ struct arc_cap
  */
 struct arc_hardware
 {
-    uint8_t  source,		/* source ARCnet - filled in automagically */
+    __u8  source,		/* source ARCnet - filled in automagically */
              dest,		/* destination ARCnet - 0 for broadcast    */
     	     offset[2];		/* offset bytes (some weird semantics)     */
 };
@@ -130,7 +131,7 @@ struct archdr
 	struct arc_rfc1051   rfc1051;
 	struct arc_eth_encap eth_encap;
 	struct arc_cap       cap;
-	uint8_t raw[0];		/* 508 bytes				*/
+	__u8 raw[0];		/* 508 bytes				*/
     } soft;
 };
 
diff --git a/include/linux/if_pppol2tp.h b/include/linux/if_pppol2tp.h
index c7a6688..3a14b08 100644
--- a/include/linux/if_pppol2tp.h
+++ b/include/linux/if_pppol2tp.h
@@ -26,7 +26,7 @@
  */
 struct pppol2tp_addr
 {
-	pid_t	pid;			/* pid that owns the fd.
+	__kernel_pid_t	pid;		/* pid that owns the fd.
 					 * 0 => current */
 	int	fd;			/* FD of UDP socket to use */
 
diff --git a/include/linux/in6.h b/include/linux/in6.h
index bc49204..718bf21 100644
--- a/include/linux/in6.h
+++ b/include/linux/in6.h
@@ -44,11 +44,11 @@ struct in6_addr
  * NOTE: Be aware the IN6ADDR_* constants and in6addr_* externals are defined
  * in network byte order, not in host byte order as are the IPv4 equivalents
  */
+#ifdef __KERNEL__
 extern const struct in6_addr in6addr_any;
 #define IN6ADDR_ANY_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 } } }
 extern const struct in6_addr in6addr_loopback;
 #define IN6ADDR_LOOPBACK_INIT { { { 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 } } }
-#ifdef __KERNEL__
 extern const struct in6_addr in6addr_linklocal_allnodes;
 #define IN6ADDR_LINKLOCAL_ALLNODES_INIT	\
 		{ { { 0xff,2,0,0,0,0,0,0,0,0,0,0,0,0,0,1 } } }
diff --git a/include/linux/ip_vs.h b/include/linux/ip_vs.h
index 0f434a2..148265e 100644
--- a/include/linux/ip_vs.h
+++ b/include/linux/ip_vs.h
@@ -96,10 +96,10 @@
  */
 struct ip_vs_service_user {
 	/* virtual service addresses */
-	u_int16_t		protocol;
+	__u16		protocol;
 	__be32			addr;		/* virtual ip address */
 	__be16			port;
-	u_int32_t		fwmark;		/* firwall mark of service */
+	__u32		fwmark;		/* firwall mark of service */
 
 	/* virtual service options */
 	char			sched_name[IP_VS_SCHEDNAME_MAXLEN];
@@ -119,8 +119,8 @@ struct ip_vs_dest_user {
 	int			weight;		/* destination weight */
 
 	/* thresholds for active connections */
-	u_int32_t		u_threshold;	/* upper threshold */
-	u_int32_t		l_threshold;	/* lower threshold */
+	__u32		u_threshold;	/* upper threshold */
+	__u32		l_threshold;	/* lower threshold */
 };
 
 
@@ -159,10 +159,10 @@ struct ip_vs_getinfo {
 /* The argument to IP_VS_SO_GET_SERVICE */
 struct ip_vs_service_entry {
 	/* which service: user fills in these */
-	u_int16_t		protocol;
+	__u16		protocol;
 	__be32			addr;		/* virtual address */
 	__be16			port;
-	u_int32_t		fwmark;		/* firwall mark of service */
+	__u32		fwmark;		/* firwall mark of service */
 
 	/* service options */
 	char			sched_name[IP_VS_SCHEDNAME_MAXLEN];
@@ -184,12 +184,12 @@ struct ip_vs_dest_entry {
 	unsigned		conn_flags;	/* connection flags */
 	int			weight;		/* destination weight */
 
-	u_int32_t		u_threshold;	/* upper threshold */
-	u_int32_t		l_threshold;	/* lower threshold */
+	__u32		u_threshold;	/* upper threshold */
+	__u32		l_threshold;	/* lower threshold */
 
-	u_int32_t		activeconns;	/* active connections */
-	u_int32_t		inactconns;	/* inactive connections */
-	u_int32_t		persistconns;	/* persistent connections */
+	__u32		activeconns;	/* active connections */
+	__u32		inactconns;	/* inactive connections */
+	__u32		persistconns;	/* persistent connections */
 
 	/* statistics */
 	struct ip_vs_stats_user stats;
@@ -199,10 +199,10 @@ struct ip_vs_dest_entry {
 /* The argument to IP_VS_SO_GET_DESTS */
 struct ip_vs_get_dests {
 	/* which service: user fills in these */
-	u_int16_t		protocol;
+	__u16		protocol;
 	__be32			addr;		/* virtual address */
 	__be16			port;
-	u_int32_t		fwmark;		/* firwall mark of service */
+	__u32		fwmark;		/* firwall mark of service */
 
 	/* number of real servers */
 	unsigned int		num_dests;
diff --git a/include/linux/ivtvfb.h b/include/linux/ivtvfb.h
index e20af47..9d88b29 100644
--- a/include/linux/ivtvfb.h
+++ b/include/linux/ivtvfb.h
@@ -33,6 +33,6 @@ struct ivtvfb_dma_frame {
 };
 
 #define IVTVFB_IOC_DMA_FRAME 	_IOW('V', BASE_VIDIOC_PRIVATE+0, struct ivtvfb_dma_frame)
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, u_int32_t)
+#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
 
 #endif
diff --git a/include/linux/jffs2.h b/include/linux/jffs2.h
index da720bc..2b32d63 100644
--- a/include/linux/jffs2.h
+++ b/include/linux/jffs2.h
@@ -12,6 +12,7 @@
 #ifndef __LINUX_JFFS2_H__
 #define __LINUX_JFFS2_H__
 
+#include <linux/types.h>
 #include <linux/magic.h>
 
 /* You must include something which defines the C99 uintXX_t types. 
@@ -91,15 +92,15 @@
    byteswapping */
 
 typedef struct {
-	uint32_t v32;
+	__u32 v32;
 } __attribute__((packed)) jint32_t;
 
 typedef struct {
-	uint32_t m;
+	__u32 m;
 } __attribute__((packed)) jmode_t;
 
 typedef struct {
-	uint16_t v16;
+	__u16 v16;
 } __attribute__((packed)) jint16_t;
 
 struct jffs2_unknown_node
@@ -121,12 +122,12 @@ struct jffs2_raw_dirent
 	jint32_t version;
 	jint32_t ino; /* == zero for unlink */
 	jint32_t mctime;
-	uint8_t nsize;
-	uint8_t type;
-	uint8_t unused[2];
+	__u8 nsize;
+	__u8 type;
+	__u8 unused[2];
 	jint32_t node_crc;
 	jint32_t name_crc;
-	uint8_t name[0];
+	__u8 name[0];
 };
 
 /* The JFFS2 raw inode structure: Used for storage on physical media.  */
@@ -153,12 +154,12 @@ struct jffs2_raw_inode
 	jint32_t offset;     /* Where to begin to write.  */
 	jint32_t csize;      /* (Compressed) data size */
 	jint32_t dsize;	     /* Size of the node's data. (after decompression) */
-	uint8_t compr;       /* Compression algorithm used */
-	uint8_t usercompr;   /* Compression algorithm requested by the user */
+	__u8 compr;       /* Compression algorithm used */
+	__u8 usercompr;   /* Compression algorithm requested by the user */
 	jint16_t flags;	     /* See JFFS2_INO_FLAG_* */
 	jint32_t data_crc;   /* CRC for the (compressed) data.  */
 	jint32_t node_crc;   /* CRC for the raw inode (excluding data)  */
-	uint8_t data[0];
+	__u8 data[0];
 };
 
 struct jffs2_raw_xattr {
@@ -168,12 +169,12 @@ struct jffs2_raw_xattr {
 	jint32_t hdr_crc;
 	jint32_t xid;		/* XATTR identifier number */
 	jint32_t version;
-	uint8_t xprefix;
-	uint8_t name_len;
+	__u8 xprefix;
+	__u8 name_len;
 	jint16_t value_len;
 	jint32_t data_crc;
 	jint32_t node_crc;
-	uint8_t data[0];
+	__u8 data[0];
 } __attribute__((packed));
 
 struct jffs2_raw_xref
diff --git a/include/linux/matroxfb.h b/include/linux/matroxfb.h
index 404f678..2203121 100644
--- a/include/linux/matroxfb.h
+++ b/include/linux/matroxfb.h
@@ -37,7 +37,7 @@ enum matroxfb_ctrl_id {
   MATROXFB_CID_LAST
 };
 
-#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, u_int32_t)
+#define FBIO_WAITFORVSYNC	_IOW('F', 0x20, __u32)
 
 #endif
 
diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index 5375fac..43dc97e 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -65,7 +65,7 @@ struct mif6ctl {
 	mifi_t	mif6c_mifi;		/* Index of MIF */
 	unsigned char mif6c_flags;	/* MIFF_ flags */
 	unsigned char vifc_threshold;	/* ttl limit */
-	u_short	 mif6c_pifi;		/* the index of the physical IF */
+	__u16	 mif6c_pifi;		/* the index of the physical IF */
 	unsigned int vifc_rate_limit;	/* Rate limiter values (NI) */
 };
 
diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index a049df4..3066789 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -2,6 +2,8 @@
 #define _NF_CONNTRACK_TCP_H
 /* TCP tracking. */
 
+#include <linux/types.h>
+
 /* This is exposed to userspace (ctnetlink) */
 enum tcp_conntrack {
 	TCP_CONNTRACK_NONE,
@@ -34,8 +36,8 @@ enum tcp_conntrack {
 #define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
 
 struct nf_ct_tcp_flags {
-	u_int8_t flags;
-	u_int8_t mask;
+	__u8 flags;
+	__u8 mask;
 };
 
 #ifdef __KERNEL__
diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 7d8e045..e53546c 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -25,8 +25,8 @@ enum nfnetlink_groups {
 /* General form of address family dependent message.
  */
 struct nfgenmsg {
-	u_int8_t  nfgen_family;		/* AF_xxx */
-	u_int8_t  version;		/* nfnetlink version */
+	__u8  nfgen_family;		/* AF_xxx */
+	__u8  version;		/* nfnetlink version */
 	__be16    res_id;		/* resource id */
 };
 
diff --git a/include/linux/netfilter/nfnetlink_compat.h b/include/linux/netfilter/nfnetlink_compat.h
index e145176..eda55ca 100644
--- a/include/linux/netfilter/nfnetlink_compat.h
+++ b/include/linux/netfilter/nfnetlink_compat.h
@@ -1,5 +1,8 @@
 #ifndef _NFNETLINK_COMPAT_H
 #define _NFNETLINK_COMPAT_H
+
+#include <linux/types.h>
+
 #ifndef __KERNEL__
 /* Old nfnetlink macros for userspace */
 
@@ -20,8 +23,8 @@
 
 struct nfattr
 {
-	u_int16_t nfa_len;
-	u_int16_t nfa_type;	/* we use 15 bits for the type, and the highest
+	__u16 nfa_len;
+	__u16 nfa_type;	/* we use 15 bits for the type, and the highest
 				 * bit to indicate whether the payload is nested */
 };
 
diff --git a/include/linux/netfilter/nfnetlink_log.h b/include/linux/netfilter/nfnetlink_log.h
index f661731..d3bab7a 100644
--- a/include/linux/netfilter/nfnetlink_log.h
+++ b/include/linux/netfilter/nfnetlink_log.h
@@ -17,14 +17,14 @@ enum nfulnl_msg_types {
 
 struct nfulnl_msg_packet_hdr {
 	__be16		hw_protocol;	/* hw protocol (network order) */
-	u_int8_t	hook;		/* netfilter hook */
-	u_int8_t	_pad;
+	__u8	hook;		/* netfilter hook */
+	__u8	_pad;
 };
 
 struct nfulnl_msg_packet_hw {
 	__be16		hw_addrlen;
-	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
+	__u16	_pad;
+	__u8	hw_addr[8];
 };
 
 struct nfulnl_msg_packet_timestamp {
@@ -35,12 +35,12 @@ struct nfulnl_msg_packet_timestamp {
 enum nfulnl_attr_type {
 	NFULA_UNSPEC,
 	NFULA_PACKET_HDR,
-	NFULA_MARK,			/* u_int32_t nfmark */
+	NFULA_MARK,			/* __u32 nfmark */
 	NFULA_TIMESTAMP,		/* nfulnl_msg_packet_timestamp */
-	NFULA_IFINDEX_INDEV,		/* u_int32_t ifindex */
-	NFULA_IFINDEX_OUTDEV,		/* u_int32_t ifindex */
-	NFULA_IFINDEX_PHYSINDEV,	/* u_int32_t ifindex */
-	NFULA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
+	NFULA_IFINDEX_INDEV,		/* __u32 ifindex */
+	NFULA_IFINDEX_OUTDEV,		/* __u32 ifindex */
+	NFULA_IFINDEX_PHYSINDEV,	/* __u32 ifindex */
+	NFULA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFULA_HWADDR,			/* nfulnl_msg_packet_hw */
 	NFULA_PAYLOAD,			/* opaque data payload */
 	NFULA_PREFIX,			/* string prefix */
@@ -65,23 +65,23 @@ enum nfulnl_msg_config_cmds {
 };
 
 struct nfulnl_msg_config_cmd {
-	u_int8_t	command;	/* nfulnl_msg_config_cmds */
+	__u8	command;	/* nfulnl_msg_config_cmds */
 } __attribute__ ((packed));
 
 struct nfulnl_msg_config_mode {
 	__be32		copy_range;
-	u_int8_t	copy_mode;
-	u_int8_t	_pad;
+	__u8	copy_mode;
+	__u8	_pad;
 } __attribute__ ((packed));
 
 enum nfulnl_attr_config {
 	NFULA_CFG_UNSPEC,
 	NFULA_CFG_CMD,			/* nfulnl_msg_config_cmd */
 	NFULA_CFG_MODE,			/* nfulnl_msg_config_mode */
-	NFULA_CFG_NLBUFSIZ,		/* u_int32_t buffer size */
-	NFULA_CFG_TIMEOUT,		/* u_int32_t in 1/100 s */
-	NFULA_CFG_QTHRESH,		/* u_int32_t */
-	NFULA_CFG_FLAGS,		/* u_int16_t */
+	NFULA_CFG_NLBUFSIZ,		/* __u32 buffer size */
+	NFULA_CFG_TIMEOUT,		/* __u32 in 1/100 s */
+	NFULA_CFG_QTHRESH,		/* __u32 */
+	NFULA_CFG_FLAGS,		/* __u16 */
 	__NFULA_CFG_MAX
 };
 #define NFULA_CFG_MAX (__NFULA_CFG_MAX -1)
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 83e7896..2455fe5 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -15,13 +15,13 @@ enum nfqnl_msg_types {
 struct nfqnl_msg_packet_hdr {
 	__be32		packet_id;	/* unique ID of packet in queue */
 	__be16		hw_protocol;	/* hw protocol (network order) */
-	u_int8_t	hook;		/* netfilter hook */
+	__u8	hook;		/* netfilter hook */
 } __attribute__ ((packed));
 
 struct nfqnl_msg_packet_hw {
 	__be16		hw_addrlen;
-	u_int16_t	_pad;
-	u_int8_t	hw_addr[8];
+	__u16	_pad;
+	__u8	hw_addr[8];
 };
 
 struct nfqnl_msg_packet_timestamp {
@@ -33,12 +33,12 @@ enum nfqnl_attr_type {
 	NFQA_UNSPEC,
 	NFQA_PACKET_HDR,
 	NFQA_VERDICT_HDR,		/* nfqnl_msg_verdict_hrd */
-	NFQA_MARK,			/* u_int32_t nfmark */
+	NFQA_MARK,			/* __u32 nfmark */
 	NFQA_TIMESTAMP,			/* nfqnl_msg_packet_timestamp */
-	NFQA_IFINDEX_INDEV,		/* u_int32_t ifindex */
-	NFQA_IFINDEX_OUTDEV,		/* u_int32_t ifindex */
-	NFQA_IFINDEX_PHYSINDEV,		/* u_int32_t ifindex */
-	NFQA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
+	NFQA_IFINDEX_INDEV,		/* __u32 ifindex */
+	NFQA_IFINDEX_OUTDEV,		/* __u32 ifindex */
+	NFQA_IFINDEX_PHYSINDEV,		/* __u32 ifindex */
+	NFQA_IFINDEX_PHYSOUTDEV,	/* __u32 ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
 
@@ -61,8 +61,8 @@ enum nfqnl_msg_config_cmds {
 };
 
 struct nfqnl_msg_config_cmd {
-	u_int8_t	command;	/* nfqnl_msg_config_cmds */
-	u_int8_t	_pad;
+	__u8	command;	/* nfqnl_msg_config_cmds */
+	__u8	_pad;
 	__be16		pf;		/* AF_xxx for PF_[UN]BIND */
 };
 
@@ -74,7 +74,7 @@ enum nfqnl_config_mode {
 
 struct nfqnl_msg_config_params {
 	__be32		copy_range;
-	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
+	__u8	copy_mode;	/* enum nfqnl_config_mode */
 } __attribute__ ((packed));
 
 
@@ -82,7 +82,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
-	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
+	NFQA_CFG_QUEUE_MAXLEN,		/* __u32 */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c7ee874..33fd9c9 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -1,6 +1,8 @@
 #ifndef _X_TABLES_H
 #define _X_TABLES_H
 
+#include <linux/types.h>
+
 #define XT_FUNCTION_MAXNAMELEN 30
 #define XT_TABLE_MAXNAMELEN 32
 
@@ -8,22 +10,22 @@ struct xt_entry_match
 {
 	union {
 		struct {
-			u_int16_t match_size;
+			__u16 match_size;
 
 			/* Used by userspace */
 			char name[XT_FUNCTION_MAXNAMELEN-1];
 
-			u_int8_t revision;
+			__u8 revision;
 		} user;
 		struct {
-			u_int16_t match_size;
+			__u16 match_size;
 
 			/* Used inside the kernel */
 			struct xt_match *match;
 		} kernel;
 
 		/* Total length */
-		u_int16_t match_size;
+		__u16 match_size;
 	} u;
 
 	unsigned char data[0];
@@ -33,22 +35,22 @@ struct xt_entry_target
 {
 	union {
 		struct {
-			u_int16_t target_size;
+			__u16 target_size;
 
 			/* Used by userspace */
 			char name[XT_FUNCTION_MAXNAMELEN-1];
 
-			u_int8_t revision;
+			__u8 revision;
 		} user;
 		struct {
-			u_int16_t target_size;
+			__u16 target_size;
 
 			/* Used inside the kernel */
 			struct xt_target *target;
 		} kernel;
 
 		/* Total length */
-		u_int16_t target_size;
+		__u16 target_size;
 	} u;
 
 	unsigned char data[0];
@@ -74,7 +76,7 @@ struct xt_get_revision
 {
 	char name[XT_FUNCTION_MAXNAMELEN-1];
 
-	u_int8_t revision;
+	__u8 revision;
 };
 
 /* CONTINUE verdict for targets */
@@ -90,10 +92,10 @@ struct xt_get_revision
  */
 struct _xt_align
 {
-	u_int8_t u8;
-	u_int16_t u16;
-	u_int32_t u32;
-	u_int64_t u64;
+	__u8 u8;
+	__u16 u16;
+	__u32 u32;
+	__u64 u64;
 };
 
 #define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1)) 	\
@@ -109,7 +111,7 @@ struct _xt_align
 
 struct xt_counters
 {
-	u_int64_t pcnt, bcnt;			/* Packet and byte counters */
+	__u64 pcnt, bcnt;			/* Packet and byte counters */
 };
 
 /* The argument to IPT_SO_ADD_COUNTERS. */
diff --git a/include/linux/netfilter/xt_CLASSIFY.h b/include/linux/netfilter/xt_CLASSIFY.h
index 5811135..a813bf1 100644
--- a/include/linux/netfilter/xt_CLASSIFY.h
+++ b/include/linux/netfilter/xt_CLASSIFY.h
@@ -1,8 +1,10 @@
 #ifndef _XT_CLASSIFY_H
 #define _XT_CLASSIFY_H
 
+#include <linux/types.h>
+
 struct xt_classify_target_info {
-	u_int32_t priority;
+	__u32 priority;
 };
 
 #endif /*_XT_CLASSIFY_H */
diff --git a/include/linux/netfilter/xt_CONNMARK.h b/include/linux/netfilter/xt_CONNMARK.h
index 4e58ba4..7635c8f 100644
--- a/include/linux/netfilter/xt_CONNMARK.h
+++ b/include/linux/netfilter/xt_CONNMARK.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNMARK_H_target
 #define _XT_CONNMARK_H_target
 
+#include <linux/types.h>
+
 /* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  *
@@ -19,12 +21,12 @@ enum {
 struct xt_connmark_target_info {
 	unsigned long mark;
 	unsigned long mask;
-	u_int8_t mode;
+	__u8 mode;
 };
 
 struct xt_connmark_tginfo1 {
-	u_int32_t ctmark, ctmask, nfmask;
-	u_int8_t mode;
+	__u32 ctmark, ctmask, nfmask;
+	__u8 mode;
 };
 
 #endif /*_XT_CONNMARK_H_target*/
diff --git a/include/linux/netfilter/xt_CONNSECMARK.h b/include/linux/netfilter/xt_CONNSECMARK.h
index c6bd754..b973ff8 100644
--- a/include/linux/netfilter/xt_CONNSECMARK.h
+++ b/include/linux/netfilter/xt_CONNSECMARK.h
@@ -1,13 +1,15 @@
 #ifndef _XT_CONNSECMARK_H_target
 #define _XT_CONNSECMARK_H_target
 
+#include <linux/types.h>
+
 enum {
 	CONNSECMARK_SAVE = 1,
 	CONNSECMARK_RESTORE,
 };
 
 struct xt_connsecmark_target_info {
-	u_int8_t mode;
+	__u8 mode;
 };
 
 #endif /*_XT_CONNSECMARK_H_target */
diff --git a/include/linux/netfilter/xt_DSCP.h b/include/linux/netfilter/xt_DSCP.h
index 14da196..648e0b3 100644
--- a/include/linux/netfilter/xt_DSCP.h
+++ b/include/linux/netfilter/xt_DSCP.h
@@ -11,15 +11,16 @@
 #ifndef _XT_DSCP_TARGET_H
 #define _XT_DSCP_TARGET_H
 #include <linux/netfilter/xt_dscp.h>
+#include <linux/types.h>
 
 /* target info */
 struct xt_DSCP_info {
-	u_int8_t dscp;
+	__u8 dscp;
 };
 
 struct xt_tos_target_info {
-	u_int8_t tos_value;
-	u_int8_t tos_mask;
+	__u8 tos_value;
+	__u8 tos_mask;
 };
 
 #endif /* _XT_DSCP_TARGET_H */
diff --git a/include/linux/netfilter/xt_MARK.h b/include/linux/netfilter/xt_MARK.h
index 778b278..028304b 100644
--- a/include/linux/netfilter/xt_MARK.h
+++ b/include/linux/netfilter/xt_MARK.h
@@ -1,6 +1,8 @@
 #ifndef _XT_MARK_H_target
 #define _XT_MARK_H_target
 
+#include <linux/types.h>
+
 /* Version 0 */
 struct xt_mark_target_info {
 	unsigned long mark;
@@ -15,11 +17,11 @@ enum {
 
 struct xt_mark_target_info_v1 {
 	unsigned long mark;
-	u_int8_t mode;
+	__u8 mode;
 };
 
 struct xt_mark_tginfo2 {
-	u_int32_t mark, mask;
+	__u32 mark, mask;
 };
 
 #endif /*_XT_MARK_H_target */
diff --git a/include/linux/netfilter/xt_NFLOG.h b/include/linux/netfilter/xt_NFLOG.h
index 4b36aeb..87b5831 100644
--- a/include/linux/netfilter/xt_NFLOG.h
+++ b/include/linux/netfilter/xt_NFLOG.h
@@ -1,17 +1,19 @@
 #ifndef _XT_NFLOG_TARGET
 #define _XT_NFLOG_TARGET
 
+#include <linux/types.h>
+
 #define XT_NFLOG_DEFAULT_GROUP		0x1
 #define XT_NFLOG_DEFAULT_THRESHOLD	0
 
 #define XT_NFLOG_MASK			0x0
 
 struct xt_nflog_info {
-	u_int32_t	len;
-	u_int16_t	group;
-	u_int16_t	threshold;
-	u_int16_t	flags;
-	u_int16_t	pad;
+	__u32	len;
+	__u16	group;
+	__u16	threshold;
+	__u16	flags;
+	__u16	pad;
 	char		prefix[64];
 };
 
diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
index 9a9af79..982a89f 100644
--- a/include/linux/netfilter/xt_NFQUEUE.h
+++ b/include/linux/netfilter/xt_NFQUEUE.h
@@ -8,9 +8,11 @@
 #ifndef _XT_NFQ_TARGET_H
 #define _XT_NFQ_TARGET_H
 
+#include <linux/types.h>
+
 /* target info */
 struct xt_NFQ_info {
-	u_int16_t queuenum;
+	__u16 queuenum;
 };
 
 #endif /* _XT_NFQ_TARGET_H */
diff --git a/include/linux/netfilter/xt_RATEEST.h b/include/linux/netfilter/xt_RATEEST.h
index f79e313..6605e20 100644
--- a/include/linux/netfilter/xt_RATEEST.h
+++ b/include/linux/netfilter/xt_RATEEST.h
@@ -1,10 +1,12 @@
 #ifndef _XT_RATEEST_TARGET_H
 #define _XT_RATEEST_TARGET_H
 
+#include <linux/types.h>
+
 struct xt_rateest_target_info {
 	char			name[IFNAMSIZ];
-	int8_t			interval;
-	u_int8_t		ewma_log;
+	__s8			interval;
+	__u8		ewma_log;
 
 	/* Used internally by the kernel */
 	struct xt_rateest	*est __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
index c53fbff..6fcd344 100644
--- a/include/linux/netfilter/xt_SECMARK.h
+++ b/include/linux/netfilter/xt_SECMARK.h
@@ -1,6 +1,8 @@
 #ifndef _XT_SECMARK_H_target
 #define _XT_SECMARK_H_target
 
+#include <linux/types.h>
+
 /*
  * This is intended for use by various security subsystems (but not
  * at the same time).
@@ -12,12 +14,12 @@
 #define SECMARK_SELCTX_MAX	256
 
 struct xt_secmark_target_selinux_info {
-	u_int32_t selsid;
+	__u32 selsid;
 	char selctx[SECMARK_SELCTX_MAX];
 };
 
 struct xt_secmark_target_info {
-	u_int8_t mode;
+	__u8 mode;
 	union {
 		struct xt_secmark_target_selinux_info sel;
 	} u;
diff --git a/include/linux/netfilter/xt_TCPMSS.h b/include/linux/netfilter/xt_TCPMSS.h
index 53a292c..9a6960a 100644
--- a/include/linux/netfilter/xt_TCPMSS.h
+++ b/include/linux/netfilter/xt_TCPMSS.h
@@ -1,8 +1,10 @@
 #ifndef _XT_TCPMSS_H
 #define _XT_TCPMSS_H
 
+#include <linux/types.h>
+
 struct xt_tcpmss_info {
-	u_int16_t mss;
+	__u16 mss;
 };
 
 #define XT_TCPMSS_CLAMP_PMTU 0xffff
diff --git a/include/linux/netfilter/xt_connbytes.h b/include/linux/netfilter/xt_connbytes.h
index c022c98..52bd615 100644
--- a/include/linux/netfilter/xt_connbytes.h
+++ b/include/linux/netfilter/xt_connbytes.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNBYTES_H
 #define _XT_CONNBYTES_H
 
+#include <linux/types.h>
+
 enum xt_connbytes_what {
 	XT_CONNBYTES_PKTS,
 	XT_CONNBYTES_BYTES,
@@ -19,7 +21,7 @@ struct xt_connbytes_info
 		aligned_u64 from;	/* count to be matched */
 		aligned_u64 to;		/* count to be matched */
 	} count;
-	u_int8_t what;		/* ipt_connbytes_what */
-	u_int8_t direction;	/* ipt_connbytes_direction */
+	__u8 what;		/* ipt_connbytes_what */
+	__u8 direction;	/* ipt_connbytes_direction */
 };
 #endif
diff --git a/include/linux/netfilter/xt_connmark.h b/include/linux/netfilter/xt_connmark.h
index 359ef86..571e266 100644
--- a/include/linux/netfilter/xt_connmark.h
+++ b/include/linux/netfilter/xt_connmark.h
@@ -1,6 +1,8 @@
 #ifndef _XT_CONNMARK_H
 #define _XT_CONNMARK_H
 
+#include <linux/types.h>
+
 /* Copyright (C) 2002,2004 MARA Systems AB <http://www.marasystems.com>
  * by Henrik Nordstrom <hno@marasystems.com>
  *
@@ -12,12 +14,12 @@
 
 struct xt_connmark_info {
 	unsigned long mark, mask;
-	u_int8_t invert;
+	__u8 invert;
 };
 
 struct xt_connmark_mtinfo1 {
-	u_int32_t mark, mask;
-	u_int8_t invert;
+	__u32 mark, mask;
+	__u8 invert;
 };
 
 #endif /*_XT_CONNMARK_H*/
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 8f53452..3430c77 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -63,9 +63,9 @@ struct xt_conntrack_info
 	unsigned long expires_min, expires_max;
 
 	/* Flags word */
-	u_int8_t flags;
+	__u8 flags;
 	/* Inverse flags */
-	u_int8_t invflags;
+	__u8 invflags;
 };
 
 struct xt_conntrack_mtinfo1 {
@@ -73,12 +73,12 @@ struct xt_conntrack_mtinfo1 {
 	union nf_inet_addr origdst_addr, origdst_mask;
 	union nf_inet_addr replsrc_addr, replsrc_mask;
 	union nf_inet_addr repldst_addr, repldst_mask;
-	u_int32_t expires_min, expires_max;
-	u_int16_t l4proto;
+	__u32 expires_min, expires_max;
+	__u16 l4proto;
 	__be16 origsrc_port, origdst_port;
 	__be16 replsrc_port, repldst_port;
-	u_int16_t match_flags, invert_flags;
-	u_int8_t state_mask, status_mask;
+	__u16 match_flags, invert_flags;
+	__u8 state_mask, status_mask;
 };
 
 #endif /*_XT_CONNTRACK_H*/
diff --git a/include/linux/netfilter/xt_dccp.h b/include/linux/netfilter/xt_dccp.h
index e0221b9..a579e1b 100644
--- a/include/linux/netfilter/xt_dccp.h
+++ b/include/linux/netfilter/xt_dccp.h
@@ -1,6 +1,8 @@
 #ifndef _XT_DCCP_H_
 #define _XT_DCCP_H_
 
+#include <linux/types.h>
+
 #define XT_DCCP_SRC_PORTS	        0x01
 #define XT_DCCP_DEST_PORTS	        0x02
 #define XT_DCCP_TYPE			0x04
@@ -9,14 +11,14 @@
 #define XT_DCCP_VALID_FLAGS		0x0f
 
 struct xt_dccp_info {
-	u_int16_t dpts[2];  /* Min, Max */
-	u_int16_t spts[2];  /* Min, Max */
+	__u16 dpts[2];  /* Min, Max */
+	__u16 spts[2];  /* Min, Max */
 
-	u_int16_t flags;
-	u_int16_t invflags;
+	__u16 flags;
+	__u16 invflags;
 
-	u_int16_t typemask;
-	u_int8_t option;
+	__u16 typemask;
+	__u8 option;
 };
 
 #endif /* _XT_DCCP_H_ */
diff --git a/include/linux/netfilter/xt_dscp.h b/include/linux/netfilter/xt_dscp.h
index f49bc1a..15f8932 100644
--- a/include/linux/netfilter/xt_dscp.h
+++ b/include/linux/netfilter/xt_dscp.h
@@ -10,20 +10,22 @@
 #ifndef _XT_DSCP_H
 #define _XT_DSCP_H
 
+#include <linux/types.h>
+
 #define XT_DSCP_MASK	0xfc	/* 11111100 */
 #define XT_DSCP_SHIFT	2
 #define XT_DSCP_MAX	0x3f	/* 00111111 */
 
 /* match info */
 struct xt_dscp_info {
-	u_int8_t dscp;
-	u_int8_t invert;
+	__u8 dscp;
+	__u8 invert;
 };
 
 struct xt_tos_match_info {
-	u_int8_t tos_mask;
-	u_int8_t tos_value;
-	u_int8_t invert;
+	__u8 tos_mask;
+	__u8 tos_value;
+	__u8 invert;
 };
 
 #endif /* _XT_DSCP_H */
diff --git a/include/linux/netfilter/xt_esp.h b/include/linux/netfilter/xt_esp.h
index 9380fb1..ef6fa47 100644
--- a/include/linux/netfilter/xt_esp.h
+++ b/include/linux/netfilter/xt_esp.h
@@ -1,10 +1,12 @@
 #ifndef _XT_ESP_H
 #define _XT_ESP_H
 
+#include <linux/types.h>
+
 struct xt_esp
 {
-	u_int32_t spis[2];	/* Security Parameter Index */
-	u_int8_t  invflags;	/* Inverse flags */
+	__u32 spis[2];	/* Security Parameter Index */
+	__u8  invflags;	/* Inverse flags */
 };
 
 /* Values for "invflags" field in struct xt_esp. */
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index 51b18d8..b1925b5 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -1,6 +1,8 @@
 #ifndef _XT_HASHLIMIT_H
 #define _XT_HASHLIMIT_H
 
+#include <linux/types.h>
+
 /* timings are in milliseconds. */
 #define XT_HASHLIMIT_SCALE 10000
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
@@ -18,15 +20,15 @@ enum {
 };
 
 struct hashlimit_cfg {
-	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
+	__u32 mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
 
 	/* user specified */
-	u_int32_t size;		/* how many buckets */
-	u_int32_t max;		/* max number of entries */
-	u_int32_t gc_interval;	/* gc interval */
-	u_int32_t expire;	/* when do entries expire? */
+	__u32 size;		/* how many buckets */
+	__u32 max;		/* max number of entries */
+	__u32 gc_interval;	/* gc interval */
+	__u32 expire;	/* when do entries expire? */
 };
 
 struct xt_hashlimit_info {
@@ -42,17 +44,17 @@ struct xt_hashlimit_info {
 };
 
 struct hashlimit_cfg1 {
-	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
+	__u32 mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
 
 	/* user specified */
-	u_int32_t size;		/* how many buckets */
-	u_int32_t max;		/* max number of entries */
-	u_int32_t gc_interval;	/* gc interval */
-	u_int32_t expire;	/* when do entries expire? */
+	__u32 size;		/* how many buckets */
+	__u32 max;		/* max number of entries */
+	__u32 gc_interval;	/* gc interval */
+	__u32 expire;	/* when do entries expire? */
 
-	u_int8_t srcmask, dstmask;
+	__u8 srcmask, dstmask;
 };
 
 struct xt_hashlimit_mtinfo1 {
diff --git a/include/linux/netfilter/xt_iprange.h b/include/linux/netfilter/xt_iprange.h
index a4299c7..c1f21a7 100644
--- a/include/linux/netfilter/xt_iprange.h
+++ b/include/linux/netfilter/xt_iprange.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NETFILTER_XT_IPRANGE_H
 #define _LINUX_NETFILTER_XT_IPRANGE_H 1
 
+#include <linux/types.h>
+
 enum {
 	IPRANGE_SRC     = 1 << 0,	/* match source IP address */
 	IPRANGE_DST     = 1 << 1,	/* match destination IP address */
@@ -11,7 +13,7 @@ enum {
 struct xt_iprange_mtinfo {
 	union nf_inet_addr src_min, src_max;
 	union nf_inet_addr dst_min, dst_max;
-	u_int8_t flags;
+	__u8 flags;
 };
 
 #endif /* _LINUX_NETFILTER_XT_IPRANGE_H */
diff --git a/include/linux/netfilter/xt_length.h b/include/linux/netfilter/xt_length.h
index 7c2b439..b82ed7c 100644
--- a/include/linux/netfilter/xt_length.h
+++ b/include/linux/netfilter/xt_length.h
@@ -1,9 +1,11 @@
 #ifndef _XT_LENGTH_H
 #define _XT_LENGTH_H
 
+#include <linux/types.h>
+
 struct xt_length_info {
-    u_int16_t	min, max;
-    u_int8_t	invert;
+    __u16	min, max;
+    __u8	invert;
 };
 
 #endif /*_XT_LENGTH_H*/
diff --git a/include/linux/netfilter/xt_limit.h b/include/linux/netfilter/xt_limit.h
index b3ce653..190e98b 100644
--- a/include/linux/netfilter/xt_limit.h
+++ b/include/linux/netfilter/xt_limit.h
@@ -1,19 +1,21 @@
 #ifndef _XT_RATE_H
 #define _XT_RATE_H
 
+#include <linux/types.h>
+
 /* timings are in milliseconds. */
 #define XT_LIMIT_SCALE 10000
 
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
    seconds, or one every 59 hours. */
 struct xt_rateinfo {
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
+	__u32 avg;    /* Average secs between packets * scale */
+	__u32 burst;  /* Period multiplier for upper limit. */
 
 	/* Used internally by the kernel */
 	unsigned long prev;
-	u_int32_t credit;
-	u_int32_t credit_cap, cost;
+	__u32 credit;
+	__u32 credit_cap, cost;
 
 	/* Ugly, ugly fucker. */
 	struct xt_rateinfo *master;
diff --git a/include/linux/netfilter/xt_mark.h b/include/linux/netfilter/xt_mark.h
index fae74bc..6fa460a 100644
--- a/include/linux/netfilter/xt_mark.h
+++ b/include/linux/netfilter/xt_mark.h
@@ -1,14 +1,16 @@
 #ifndef _XT_MARK_H
 #define _XT_MARK_H
 
+#include <linux/types.h>
+
 struct xt_mark_info {
     unsigned long mark, mask;
-    u_int8_t invert;
+    __u8 invert;
 };
 
 struct xt_mark_mtinfo1 {
-	u_int32_t mark, mask;
-	u_int8_t invert;
+	__u32 mark, mask;
+	__u8 invert;
 };
 
 #endif /*_XT_MARK_H*/
diff --git a/include/linux/netfilter/xt_multiport.h b/include/linux/netfilter/xt_multiport.h
index d49ee41..185db49 100644
--- a/include/linux/netfilter/xt_multiport.h
+++ b/include/linux/netfilter/xt_multiport.h
@@ -1,6 +1,8 @@
 #ifndef _XT_MULTIPORT_H
 #define _XT_MULTIPORT_H
 
+#include <linux/types.h>
+
 enum xt_multiport_flags
 {
 	XT_MULTIPORT_SOURCE,
@@ -13,18 +15,18 @@ enum xt_multiport_flags
 /* Must fit inside union xt_matchinfo: 16 bytes */
 struct xt_multiport
 {
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
+	__u8 flags;				/* Type of comparison */
+	__u8 count;				/* Number of ports */
+	__u16 ports[XT_MULTI_PORTS];	/* Ports */
 };
 
 struct xt_multiport_v1
 {
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
-	u_int8_t pflags[XT_MULTI_PORTS];	/* Port flags */
-	u_int8_t invert;			/* Invert flag */
+	__u8 flags;				/* Type of comparison */
+	__u8 count;				/* Number of ports */
+	__u16 ports[XT_MULTI_PORTS];	/* Ports */
+	__u8 pflags[XT_MULTI_PORTS];	/* Port flags */
+	__u8 invert;			/* Invert flag */
 };
 
 #endif /*_XT_MULTIPORT_H*/
diff --git a/include/linux/netfilter/xt_owner.h b/include/linux/netfilter/xt_owner.h
index c84e52c..2081761 100644
--- a/include/linux/netfilter/xt_owner.h
+++ b/include/linux/netfilter/xt_owner.h
@@ -1,6 +1,8 @@
 #ifndef _XT_OWNER_MATCH_H
 #define _XT_OWNER_MATCH_H
 
+#include <linux/types.h>
+
 enum {
 	XT_OWNER_UID    = 1 << 0,
 	XT_OWNER_GID    = 1 << 1,
@@ -8,9 +10,9 @@ enum {
 };
 
 struct xt_owner_match_info {
-	u_int32_t uid_min, uid_max;
-	u_int32_t gid_min, gid_max;
-	u_int8_t match, invert;
+	__u32 uid_min, uid_max;
+	__u32 gid_min, gid_max;
+	__u8 match, invert;
 };
 
 #endif /* _XT_OWNER_MATCH_H */
diff --git a/include/linux/netfilter/xt_physdev.h b/include/linux/netfilter/xt_physdev.h
index 25a7a18..8555e39 100644
--- a/include/linux/netfilter/xt_physdev.h
+++ b/include/linux/netfilter/xt_physdev.h
@@ -1,6 +1,8 @@
 #ifndef _XT_PHYSDEV_H
 #define _XT_PHYSDEV_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 #include <linux/if.h>
 #endif
@@ -17,8 +19,8 @@ struct xt_physdev_info {
 	char in_mask[IFNAMSIZ];
 	char physoutdev[IFNAMSIZ];
 	char out_mask[IFNAMSIZ];
-	u_int8_t invert;
-	u_int8_t bitmask;
+	__u8 invert;
+	__u8 bitmask;
 };
 
 #endif /*_XT_PHYSDEV_H*/
diff --git a/include/linux/netfilter/xt_policy.h b/include/linux/netfilter/xt_policy.h
index 053d8cc..7bb64e7 100644
--- a/include/linux/netfilter/xt_policy.h
+++ b/include/linux/netfilter/xt_policy.h
@@ -1,6 +1,8 @@
 #ifndef _XT_POLICY_H
 #define _XT_POLICY_H
 
+#include <linux/types.h>
+
 #define XT_POLICY_MAX_ELEM	4
 
 enum xt_policy_flags
@@ -19,7 +21,7 @@ enum xt_policy_modes
 
 struct xt_policy_spec
 {
-	u_int8_t	saddr:1,
+	__u8	saddr:1,
 			daddr:1,
 			proto:1,
 			mode:1,
@@ -55,9 +57,9 @@ struct xt_policy_elem
 #endif
 	};
 	__be32			spi;
-	u_int32_t		reqid;
-	u_int8_t		proto;
-	u_int8_t		mode;
+	__u32		reqid;
+	__u8		proto;
+	__u8		mode;
 
 	struct xt_policy_spec	match;
 	struct xt_policy_spec	invert;
@@ -66,8 +68,8 @@ struct xt_policy_elem
 struct xt_policy_info
 {
 	struct xt_policy_elem pol[XT_POLICY_MAX_ELEM];
-	u_int16_t flags;
-	u_int16_t len;
+	__u16 flags;
+	__u16 len;
 };
 
 #endif /* _XT_POLICY_H */
diff --git a/include/linux/netfilter/xt_rateest.h b/include/linux/netfilter/xt_rateest.h
index 2010cb7..d40a619 100644
--- a/include/linux/netfilter/xt_rateest.h
+++ b/include/linux/netfilter/xt_rateest.h
@@ -1,6 +1,8 @@
 #ifndef _XT_RATEEST_MATCH_H
 #define _XT_RATEEST_MATCH_H
 
+#include <linux/types.h>
+
 enum xt_rateest_match_flags {
 	XT_RATEEST_MATCH_INVERT	= 1<<0,
 	XT_RATEEST_MATCH_ABS	= 1<<1,
@@ -20,12 +22,12 @@ enum xt_rateest_match_mode {
 struct xt_rateest_match_info {
 	char			name1[IFNAMSIZ];
 	char			name2[IFNAMSIZ];
-	u_int16_t		flags;
-	u_int16_t		mode;
-	u_int32_t		bps1;
-	u_int32_t		pps1;
-	u_int32_t		bps2;
-	u_int32_t		pps2;
+	__u16		flags;
+	__u16		mode;
+	__u32		bps1;
+	__u32		pps1;
+	__u32		bps2;
+	__u32		pps2;
 
 	/* Used internally by the kernel */
 	struct xt_rateest	*est1 __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_realm.h b/include/linux/netfilter/xt_realm.h
index 220e872..d4a82ee 100644
--- a/include/linux/netfilter/xt_realm.h
+++ b/include/linux/netfilter/xt_realm.h
@@ -1,10 +1,12 @@
 #ifndef _XT_REALM_H
 #define _XT_REALM_H
 
+#include <linux/types.h>
+
 struct xt_realm_info {
-	u_int32_t id;
-	u_int32_t mask;
-	u_int8_t invert;
+	__u32 id;
+	__u32 mask;
+	__u8 invert;
 };
 
 #endif /* _XT_REALM_H */
diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
index 5cfeb81..d2c2766 100644
--- a/include/linux/netfilter/xt_recent.h
+++ b/include/linux/netfilter/xt_recent.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_NETFILTER_XT_RECENT_H
 #define _LINUX_NETFILTER_XT_RECENT_H 1
 
+#include <linux/types.h>
+
 enum {
 	XT_RECENT_CHECK    = 1 << 0,
 	XT_RECENT_SET      = 1 << 1,
@@ -15,12 +17,12 @@ enum {
 };
 
 struct xt_recent_mtinfo {
-	u_int32_t seconds;
-	u_int32_t hit_count;
-	u_int8_t check_set;
-	u_int8_t invert;
+	__u32 seconds;
+	__u32 hit_count;
+	__u8 check_set;
+	__u8 invert;
 	char name[XT_RECENT_NAME_LEN];
-	u_int8_t side;
+	__u8 side;
 };
 
 #endif /* _LINUX_NETFILTER_XT_RECENT_H */
diff --git a/include/linux/netfilter/xt_sctp.h b/include/linux/netfilter/xt_sctp.h
index 32000ba..29287be 100644
--- a/include/linux/netfilter/xt_sctp.h
+++ b/include/linux/netfilter/xt_sctp.h
@@ -1,6 +1,8 @@
 #ifndef _XT_SCTP_H_
 #define _XT_SCTP_H_
 
+#include <linux/types.h>
+
 #define XT_SCTP_SRC_PORTS	        0x01
 #define XT_SCTP_DEST_PORTS	        0x02
 #define XT_SCTP_CHUNK_TYPES		0x04
@@ -8,49 +10,49 @@
 #define XT_SCTP_VALID_FLAGS		0x07
 
 struct xt_sctp_flag_info {
-	u_int8_t chunktype;
-	u_int8_t flag;
-	u_int8_t flag_mask;
+	__u8 chunktype;
+	__u8 flag;
+	__u8 flag_mask;
 };
 
 #define XT_NUM_SCTP_FLAGS	4
 
 struct xt_sctp_info {
-	u_int16_t dpts[2];  /* Min, Max */
-	u_int16_t spts[2];  /* Min, Max */
+	__u16 dpts[2];  /* Min, Max */
+	__u16 spts[2];  /* Min, Max */
 
-	u_int32_t chunkmap[256 / sizeof (u_int32_t)];  /* Bit mask of chunks to be matched according to RFC 2960 */
+	__u32 chunkmap[256 / sizeof (__u32)];  /* Bit mask of chunks to be matched according to RFC 2960 */
 
 #define SCTP_CHUNK_MATCH_ANY   0x01  /* Match if any of the chunk types are present */
 #define SCTP_CHUNK_MATCH_ALL   0x02  /* Match if all of the chunk types are present */
 #define SCTP_CHUNK_MATCH_ONLY  0x04  /* Match if these are the only chunk types present */
 
-	u_int32_t chunk_match_type;
+	__u32 chunk_match_type;
 	struct xt_sctp_flag_info flag_info[XT_NUM_SCTP_FLAGS];
 	int flag_count;
 
-	u_int32_t flags;
-	u_int32_t invflags;
+	__u32 flags;
+	__u32 invflags;
 };
 
 #define bytes(type) (sizeof(type) * 8)
 
 #define SCTP_CHUNKMAP_SET(chunkmap, type) 		\
 	do { 						\
-		(chunkmap)[type / bytes(u_int32_t)] |= 	\
-			1 << (type % bytes(u_int32_t));	\
+		(chunkmap)[type / bytes(__u32)] |= 	\
+			1 << (type % bytes(__u32));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_CLEAR(chunkmap, type)		 	\
 	do {							\
-		(chunkmap)[type / bytes(u_int32_t)] &= 		\
-			~(1 << (type % bytes(u_int32_t)));	\
+		(chunkmap)[type / bytes(__u32)] &= 		\
+			~(1 << (type % bytes(__u32)));	\
 	} while (0)
 
 #define SCTP_CHUNKMAP_IS_SET(chunkmap, type) 			\
 ({								\
-	((chunkmap)[type / bytes (u_int32_t)] & 		\
-		(1 << (type % bytes (u_int32_t)))) ? 1: 0;	\
+	((chunkmap)[type / bytes (__u32)] & 		\
+		(1 << (type % bytes (__u32)))) ? 1: 0;	\
 })
 
 #define SCTP_CHUNKMAP_RESET(chunkmap) \
@@ -65,7 +67,7 @@ struct xt_sctp_info {
 #define SCTP_CHUNKMAP_IS_CLEAR(chunkmap) \
 	__sctp_chunkmap_is_clear((chunkmap), ARRAY_SIZE(chunkmap))
 static inline bool
-__sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
+__sctp_chunkmap_is_clear(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
 	for (i = 0; i < n; ++i)
@@ -77,7 +79,7 @@ __sctp_chunkmap_is_clear(const u_int32_t *chunkmap, unsigned int n)
 #define SCTP_CHUNKMAP_IS_ALL_SET(chunkmap) \
 	__sctp_chunkmap_is_all_set((chunkmap), ARRAY_SIZE(chunkmap))
 static inline bool
-__sctp_chunkmap_is_all_set(const u_int32_t *chunkmap, unsigned int n)
+__sctp_chunkmap_is_all_set(const __u32 *chunkmap, unsigned int n)
 {
 	unsigned int i;
 	for (i = 0; i < n; ++i)
diff --git a/include/linux/netfilter/xt_statistic.h b/include/linux/netfilter/xt_statistic.h
index 3d38bc9..095f3c6 100644
--- a/include/linux/netfilter/xt_statistic.h
+++ b/include/linux/netfilter/xt_statistic.h
@@ -1,6 +1,8 @@
 #ifndef _XT_STATISTIC_H
 #define _XT_STATISTIC_H
 
+#include <linux/types.h>
+
 enum xt_statistic_mode {
 	XT_STATISTIC_MODE_RANDOM,
 	XT_STATISTIC_MODE_NTH,
@@ -14,17 +16,17 @@ enum xt_statistic_flags {
 #define XT_STATISTIC_MASK		0x1
 
 struct xt_statistic_info {
-	u_int16_t			mode;
-	u_int16_t			flags;
+	__u16			mode;
+	__u16			flags;
 	union {
 		struct {
-			u_int32_t	probability;
+			__u32	probability;
 		} random;
 		struct {
-			u_int32_t	every;
-			u_int32_t	packet;
+			__u32	every;
+			__u32	packet;
 			/* Used internally by the kernel */
-			u_int32_t	count;
+			__u32	count;
 		} nth;
 	} u;
 	struct xt_statistic_info	*master __attribute__((aligned(8)));
diff --git a/include/linux/netfilter/xt_string.h b/include/linux/netfilter/xt_string.h
index 8a6ba7b..ecbb95f 100644
--- a/include/linux/netfilter/xt_string.h
+++ b/include/linux/netfilter/xt_string.h
@@ -1,6 +1,8 @@
 #ifndef _XT_STRING_H
 #define _XT_STRING_H
 
+#include <linux/types.h>
+
 #define XT_STRING_MAX_PATTERN_SIZE 128
 #define XT_STRING_MAX_ALGO_NAME_SIZE 16
 
@@ -11,18 +13,18 @@ enum {
 
 struct xt_string_info
 {
-	u_int16_t from_offset;
-	u_int16_t to_offset;
+	__u16 from_offset;
+	__u16 to_offset;
 	char	  algo[XT_STRING_MAX_ALGO_NAME_SIZE];
 	char 	  pattern[XT_STRING_MAX_PATTERN_SIZE];
-	u_int8_t  patlen;
+	__u8  patlen;
 	union {
 		struct {
-			u_int8_t  invert;
+			__u8  invert;
 		} v0;
 
 		struct {
-			u_int8_t  flags;
+			__u8  flags;
 		} v1;
 	} u;
 
diff --git a/include/linux/netfilter/xt_tcpmss.h b/include/linux/netfilter/xt_tcpmss.h
index e03274c..fbac56b 100644
--- a/include/linux/netfilter/xt_tcpmss.h
+++ b/include/linux/netfilter/xt_tcpmss.h
@@ -1,9 +1,11 @@
 #ifndef _XT_TCPMSS_MATCH_H
 #define _XT_TCPMSS_MATCH_H
 
+#include <linux/types.h>
+
 struct xt_tcpmss_match_info {
-    u_int16_t mss_min, mss_max;
-    u_int8_t invert;
+    __u16 mss_min, mss_max;
+    __u8 invert;
 };
 
 #endif /*_XT_TCPMSS_MATCH_H*/
diff --git a/include/linux/netfilter/xt_tcpudp.h b/include/linux/netfilter/xt_tcpudp.h
index 78bc65f..a490a0b 100644
--- a/include/linux/netfilter/xt_tcpudp.h
+++ b/include/linux/netfilter/xt_tcpudp.h
@@ -1,15 +1,17 @@
 #ifndef _XT_TCPUDP_H
 #define _XT_TCPUDP_H
 
+#include <linux/types.h>
+
 /* TCP matching stuff */
 struct xt_tcp
 {
-	u_int16_t spts[2];			/* Source port range. */
-	u_int16_t dpts[2];			/* Destination port range. */
-	u_int8_t option;			/* TCP Option iff non-zero*/
-	u_int8_t flg_mask;			/* TCP flags mask byte */
-	u_int8_t flg_cmp;			/* TCP flags compare byte */
-	u_int8_t invflags;			/* Inverse flags */
+	__u16 spts[2];			/* Source port range. */
+	__u16 dpts[2];			/* Destination port range. */
+	__u8 option;			/* TCP Option iff non-zero*/
+	__u8 flg_mask;			/* TCP flags mask byte */
+	__u8 flg_cmp;			/* TCP flags compare byte */
+	__u8 invflags;			/* Inverse flags */
 };
 
 /* Values for "inv" field in struct ipt_tcp. */
@@ -22,9 +24,9 @@ struct xt_tcp
 /* UDP matching stuff */
 struct xt_udp
 {
-	u_int16_t spts[2];			/* Source port range. */
-	u_int16_t dpts[2];			/* Destination port range. */
-	u_int8_t invflags;			/* Inverse flags */
+	__u16 spts[2];			/* Source port range. */
+	__u16 dpts[2];			/* Destination port range. */
+	__u8 invflags;			/* Inverse flags */
 };
 
 /* Values for "invflags" field in struct ipt_udp. */
diff --git a/include/linux/netfilter_ipv4/ipt_owner.h b/include/linux/netfilter_ipv4/ipt_owner.h
index 92f4bda..a78445b 100644
--- a/include/linux/netfilter_ipv4/ipt_owner.h
+++ b/include/linux/netfilter_ipv4/ipt_owner.h
@@ -9,10 +9,10 @@
 #define IPT_OWNER_COMM	0x10
 
 struct ipt_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
+    __kernel_uid32_t uid;
+    __kernel_gid32_t gid;
+    __kernel_pid_t pid;
+    __kernel_pid_t sid;
     char comm[16];
     u_int8_t match, invert;	/* flags */
 };
diff --git a/include/linux/netfilter_ipv6/ip6t_owner.h b/include/linux/netfilter_ipv6/ip6t_owner.h
index 19937da..ec5cc7a 100644
--- a/include/linux/netfilter_ipv6/ip6t_owner.h
+++ b/include/linux/netfilter_ipv6/ip6t_owner.h
@@ -8,10 +8,10 @@
 #define IP6T_OWNER_SID	0x08
 
 struct ip6t_owner_info {
-    uid_t uid;
-    gid_t gid;
-    pid_t pid;
-    pid_t sid;
+    __kernel_uid32_t uid;
+    __kernel_gid32_t gid;
+    __kernel_pid_t pid;
+    __kernel_pid_t sid;
     u_int8_t match, invert;	/* flags */
 };
 
diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index 7382af3..e137b3c 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -237,6 +237,7 @@ struct nubus_dirent
 	int mask;
 };
 
+#ifdef __KERNEL__
 struct nubus_board {
 	struct nubus_board* next;
 	struct nubus_dev* first_dev;
@@ -351,6 +352,7 @@ void nubus_get_rsrc_mem(void* dest,
 void nubus_get_rsrc_str(void* dest,
 			const struct nubus_dirent *dirent,
 			int maxlen);
+#endif /* __KERNEL__ */
 
 /* We'd like to get rid of this eventually.  Only daynaport.c uses it now. */
 static inline void *nubus_slot_addr(int slot)
diff --git a/include/linux/pfkeyv2.h b/include/linux/pfkeyv2.h
index 01b2629..228b0b6 100644
--- a/include/linux/pfkeyv2.h
+++ b/include/linux/pfkeyv2.h
@@ -12,187 +12,187 @@
 #define PFKEYV2_REVISION	199806L
 
 struct sadb_msg {
-	uint8_t		sadb_msg_version;
-	uint8_t		sadb_msg_type;
-	uint8_t		sadb_msg_errno;
-	uint8_t		sadb_msg_satype;
-	uint16_t	sadb_msg_len;
-	uint16_t	sadb_msg_reserved;
-	uint32_t	sadb_msg_seq;
-	uint32_t	sadb_msg_pid;
+	__u8		sadb_msg_version;
+	__u8		sadb_msg_type;
+	__u8		sadb_msg_errno;
+	__u8		sadb_msg_satype;
+	__u16	sadb_msg_len;
+	__u16	sadb_msg_reserved;
+	__u32	sadb_msg_seq;
+	__u32	sadb_msg_pid;
 } __attribute__((packed));
 /* sizeof(struct sadb_msg) == 16 */
 
 struct sadb_ext {
-	uint16_t	sadb_ext_len;
-	uint16_t	sadb_ext_type;
+	__u16	sadb_ext_len;
+	__u16	sadb_ext_type;
 } __attribute__((packed));
 /* sizeof(struct sadb_ext) == 4 */
 
 struct sadb_sa {
-	uint16_t	sadb_sa_len;
-	uint16_t	sadb_sa_exttype;
+	__u16	sadb_sa_len;
+	__u16	sadb_sa_exttype;
 	__be32		sadb_sa_spi;
-	uint8_t		sadb_sa_replay;
-	uint8_t		sadb_sa_state;
-	uint8_t		sadb_sa_auth;
-	uint8_t		sadb_sa_encrypt;
-	uint32_t	sadb_sa_flags;
+	__u8		sadb_sa_replay;
+	__u8		sadb_sa_state;
+	__u8		sadb_sa_auth;
+	__u8		sadb_sa_encrypt;
+	__u32	sadb_sa_flags;
 } __attribute__((packed));
 /* sizeof(struct sadb_sa) == 16 */
 
 struct sadb_lifetime {
-	uint16_t	sadb_lifetime_len;
-	uint16_t	sadb_lifetime_exttype;
-	uint32_t	sadb_lifetime_allocations;
-	uint64_t	sadb_lifetime_bytes;
-	uint64_t	sadb_lifetime_addtime;
-	uint64_t	sadb_lifetime_usetime;
+	__u16	sadb_lifetime_len;
+	__u16	sadb_lifetime_exttype;
+	__u32	sadb_lifetime_allocations;
+	__u64	sadb_lifetime_bytes;
+	__u64	sadb_lifetime_addtime;
+	__u64	sadb_lifetime_usetime;
 } __attribute__((packed));
 /* sizeof(struct sadb_lifetime) == 32 */
 
 struct sadb_address {
-	uint16_t	sadb_address_len;
-	uint16_t	sadb_address_exttype;
-	uint8_t		sadb_address_proto;
-	uint8_t		sadb_address_prefixlen;
-	uint16_t	sadb_address_reserved;
+	__u16	sadb_address_len;
+	__u16	sadb_address_exttype;
+	__u8		sadb_address_proto;
+	__u8		sadb_address_prefixlen;
+	__u16	sadb_address_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_address) == 8 */
 
 struct sadb_key {
-	uint16_t	sadb_key_len;
-	uint16_t	sadb_key_exttype;
-	uint16_t	sadb_key_bits;
-	uint16_t	sadb_key_reserved;
+	__u16	sadb_key_len;
+	__u16	sadb_key_exttype;
+	__u16	sadb_key_bits;
+	__u16	sadb_key_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_key) == 8 */
 
 struct sadb_ident {
-	uint16_t	sadb_ident_len;
-	uint16_t	sadb_ident_exttype;
-	uint16_t	sadb_ident_type;
-	uint16_t	sadb_ident_reserved;
-	uint64_t	sadb_ident_id;
+	__u16	sadb_ident_len;
+	__u16	sadb_ident_exttype;
+	__u16	sadb_ident_type;
+	__u16	sadb_ident_reserved;
+	__u64	sadb_ident_id;
 } __attribute__((packed));
 /* sizeof(struct sadb_ident) == 16 */
 
 struct sadb_sens {
-	uint16_t	sadb_sens_len;
-	uint16_t	sadb_sens_exttype;
-	uint32_t	sadb_sens_dpd;
-	uint8_t		sadb_sens_sens_level;
-	uint8_t		sadb_sens_sens_len;
-	uint8_t		sadb_sens_integ_level;
-	uint8_t		sadb_sens_integ_len;
-	uint32_t	sadb_sens_reserved;
+	__u16	sadb_sens_len;
+	__u16	sadb_sens_exttype;
+	__u32	sadb_sens_dpd;
+	__u8		sadb_sens_sens_level;
+	__u8		sadb_sens_sens_len;
+	__u8		sadb_sens_integ_level;
+	__u8		sadb_sens_integ_len;
+	__u32	sadb_sens_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_sens) == 16 */
 
 /* followed by:
-	uint64_t	sadb_sens_bitmap[sens_len];
-	uint64_t	sadb_integ_bitmap[integ_len];  */
+	__u64	sadb_sens_bitmap[sens_len];
+	__u64	sadb_integ_bitmap[integ_len];  */
 
 struct sadb_prop {
-	uint16_t	sadb_prop_len;
-	uint16_t	sadb_prop_exttype;
-	uint8_t		sadb_prop_replay;
-	uint8_t		sadb_prop_reserved[3];
+	__u16	sadb_prop_len;
+	__u16	sadb_prop_exttype;
+	__u8		sadb_prop_replay;
+	__u8		sadb_prop_reserved[3];
 } __attribute__((packed));
 /* sizeof(struct sadb_prop) == 8 */
 
 /* followed by:
 	struct sadb_comb sadb_combs[(sadb_prop_len +
-		sizeof(uint64_t) - sizeof(struct sadb_prop)) /
+		sizeof(__u64) - sizeof(struct sadb_prop)) /
 		sizeof(struct sadb_comb)]; */
 
 struct sadb_comb {
-	uint8_t		sadb_comb_auth;
-	uint8_t		sadb_comb_encrypt;
-	uint16_t	sadb_comb_flags;
-	uint16_t	sadb_comb_auth_minbits;
-	uint16_t	sadb_comb_auth_maxbits;
-	uint16_t	sadb_comb_encrypt_minbits;
-	uint16_t	sadb_comb_encrypt_maxbits;
-	uint32_t	sadb_comb_reserved;
-	uint32_t	sadb_comb_soft_allocations;
-	uint32_t	sadb_comb_hard_allocations;
-	uint64_t	sadb_comb_soft_bytes;
-	uint64_t	sadb_comb_hard_bytes;
-	uint64_t	sadb_comb_soft_addtime;
-	uint64_t	sadb_comb_hard_addtime;
-	uint64_t	sadb_comb_soft_usetime;
-	uint64_t	sadb_comb_hard_usetime;
+	__u8		sadb_comb_auth;
+	__u8		sadb_comb_encrypt;
+	__u16	sadb_comb_flags;
+	__u16	sadb_comb_auth_minbits;
+	__u16	sadb_comb_auth_maxbits;
+	__u16	sadb_comb_encrypt_minbits;
+	__u16	sadb_comb_encrypt_maxbits;
+	__u32	sadb_comb_reserved;
+	__u32	sadb_comb_soft_allocations;
+	__u32	sadb_comb_hard_allocations;
+	__u64	sadb_comb_soft_bytes;
+	__u64	sadb_comb_hard_bytes;
+	__u64	sadb_comb_soft_addtime;
+	__u64	sadb_comb_hard_addtime;
+	__u64	sadb_comb_soft_usetime;
+	__u64	sadb_comb_hard_usetime;
 } __attribute__((packed));
 /* sizeof(struct sadb_comb) == 72 */
 
 struct sadb_supported {
-	uint16_t	sadb_supported_len;
-	uint16_t	sadb_supported_exttype;
-	uint32_t	sadb_supported_reserved;
+	__u16	sadb_supported_len;
+	__u16	sadb_supported_exttype;
+	__u32	sadb_supported_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_supported) == 8 */
 
 /* followed by:
 	struct sadb_alg sadb_algs[(sadb_supported_len +
-		sizeof(uint64_t) - sizeof(struct sadb_supported)) /
+		sizeof(__u64) - sizeof(struct sadb_supported)) /
 		sizeof(struct sadb_alg)]; */
 
 struct sadb_alg {
-	uint8_t		sadb_alg_id;
-	uint8_t		sadb_alg_ivlen;
-	uint16_t	sadb_alg_minbits;
-	uint16_t	sadb_alg_maxbits;
-	uint16_t	sadb_alg_reserved;
+	__u8		sadb_alg_id;
+	__u8		sadb_alg_ivlen;
+	__u16	sadb_alg_minbits;
+	__u16	sadb_alg_maxbits;
+	__u16	sadb_alg_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_alg) == 8 */
 
 struct sadb_spirange {
-	uint16_t	sadb_spirange_len;
-	uint16_t	sadb_spirange_exttype;
-	uint32_t	sadb_spirange_min;
-	uint32_t	sadb_spirange_max;
-	uint32_t	sadb_spirange_reserved;
+	__u16	sadb_spirange_len;
+	__u16	sadb_spirange_exttype;
+	__u32	sadb_spirange_min;
+	__u32	sadb_spirange_max;
+	__u32	sadb_spirange_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_spirange) == 16 */
 
 struct sadb_x_kmprivate {
-	uint16_t	sadb_x_kmprivate_len;
-	uint16_t	sadb_x_kmprivate_exttype;
-	uint32_t	sadb_x_kmprivate_reserved;
+	__u16	sadb_x_kmprivate_len;
+	__u16	sadb_x_kmprivate_exttype;
+	__u32	sadb_x_kmprivate_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_kmprivate) == 8 */
 
 struct sadb_x_sa2 {
-	uint16_t	sadb_x_sa2_len;
-	uint16_t	sadb_x_sa2_exttype;
-	uint8_t		sadb_x_sa2_mode;
-	uint8_t		sadb_x_sa2_reserved1;
-	uint16_t	sadb_x_sa2_reserved2;
-	uint32_t	sadb_x_sa2_sequence;
-	uint32_t	sadb_x_sa2_reqid;
+	__u16	sadb_x_sa2_len;
+	__u16	sadb_x_sa2_exttype;
+	__u8		sadb_x_sa2_mode;
+	__u8		sadb_x_sa2_reserved1;
+	__u16	sadb_x_sa2_reserved2;
+	__u32	sadb_x_sa2_sequence;
+	__u32	sadb_x_sa2_reqid;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_sa2) == 16 */
 
 struct sadb_x_policy {
-	uint16_t	sadb_x_policy_len;
-	uint16_t	sadb_x_policy_exttype;
-	uint16_t	sadb_x_policy_type;
-	uint8_t		sadb_x_policy_dir;
-	uint8_t		sadb_x_policy_reserved;
-	uint32_t	sadb_x_policy_id;
-	uint32_t	sadb_x_policy_priority;
+	__u16	sadb_x_policy_len;
+	__u16	sadb_x_policy_exttype;
+	__u16	sadb_x_policy_type;
+	__u8		sadb_x_policy_dir;
+	__u8		sadb_x_policy_reserved;
+	__u32	sadb_x_policy_id;
+	__u32	sadb_x_policy_priority;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_policy) == 16 */
 
 struct sadb_x_ipsecrequest {
-	uint16_t	sadb_x_ipsecrequest_len;
-	uint16_t	sadb_x_ipsecrequest_proto;
-	uint8_t		sadb_x_ipsecrequest_mode;
-	uint8_t		sadb_x_ipsecrequest_level;
-	uint16_t	sadb_x_ipsecrequest_reserved1;
-	uint32_t	sadb_x_ipsecrequest_reqid;
-	uint32_t	sadb_x_ipsecrequest_reserved2;
+	__u16	sadb_x_ipsecrequest_len;
+	__u16	sadb_x_ipsecrequest_proto;
+	__u8		sadb_x_ipsecrequest_mode;
+	__u8		sadb_x_ipsecrequest_level;
+	__u16	sadb_x_ipsecrequest_reserved1;
+	__u32	sadb_x_ipsecrequest_reqid;
+	__u32	sadb_x_ipsecrequest_reserved2;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_ipsecrequest) == 16 */
 
@@ -200,38 +200,38 @@ struct sadb_x_ipsecrequest {
  * type of NAT-T is supported, draft-ietf-ipsec-udp-encaps-06
  */
 struct sadb_x_nat_t_type {
-	uint16_t	sadb_x_nat_t_type_len;
-	uint16_t	sadb_x_nat_t_type_exttype;
-	uint8_t		sadb_x_nat_t_type_type;
-	uint8_t		sadb_x_nat_t_type_reserved[3];
+	__u16	sadb_x_nat_t_type_len;
+	__u16	sadb_x_nat_t_type_exttype;
+	__u8		sadb_x_nat_t_type_type;
+	__u8		sadb_x_nat_t_type_reserved[3];
 } __attribute__((packed));
 /* sizeof(struct sadb_x_nat_t_type) == 8 */
 
 /* Pass a NAT Traversal port (Source or Dest port) */
 struct sadb_x_nat_t_port {
-	uint16_t	sadb_x_nat_t_port_len;
-	uint16_t	sadb_x_nat_t_port_exttype;
+	__u16	sadb_x_nat_t_port_len;
+	__u16	sadb_x_nat_t_port_exttype;
 	__be16		sadb_x_nat_t_port_port;
-	uint16_t	sadb_x_nat_t_port_reserved;
+	__u16	sadb_x_nat_t_port_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_nat_t_port) == 8 */
 
 /* Generic LSM security context */
 struct sadb_x_sec_ctx {
-	uint16_t	sadb_x_sec_len;
-	uint16_t	sadb_x_sec_exttype;
-	uint8_t		sadb_x_ctx_alg;  /* LSMs: e.g., selinux == 1 */
-	uint8_t		sadb_x_ctx_doi;
-	uint16_t	sadb_x_ctx_len;
+	__u16	sadb_x_sec_len;
+	__u16	sadb_x_sec_exttype;
+	__u8		sadb_x_ctx_alg;  /* LSMs: e.g., selinux == 1 */
+	__u8		sadb_x_ctx_doi;
+	__u16	sadb_x_ctx_len;
 } __attribute__((packed));
 /* sizeof(struct sadb_sec_ctx) = 8 */
 
 /* Used by MIGRATE to pass addresses IKE will use to perform
  * negotiation with the peer */
 struct sadb_x_kmaddress {
-	uint16_t	sadb_x_kmaddress_len;
-	uint16_t	sadb_x_kmaddress_exttype;
-	uint32_t	sadb_x_kmaddress_reserved;
+	__u16	sadb_x_kmaddress_len;
+	__u16	sadb_x_kmaddress_exttype;
+	__u32	sadb_x_kmaddress_reserved;
 } __attribute__((packed));
 /* sizeof(struct sadb_x_kmaddress) == 8 */
 
diff --git a/include/linux/ppp_defs.h b/include/linux/ppp_defs.h
index 1c866bd..0f93ed6 100644
--- a/include/linux/ppp_defs.h
+++ b/include/linux/ppp_defs.h
@@ -177,8 +177,8 @@ struct ppp_comp_stats {
  * the last NP packet was sent or received.
  */
 struct ppp_idle {
-    time_t xmit_idle;		/* time since last NP packet sent */
-    time_t recv_idle;		/* time since last NP packet received */
+    __kernel_time_t xmit_idle;	/* time since last NP packet sent */
+    __kernel_time_t recv_idle;	/* time since last NP packet received */
 };
 
 #endif /* _PPP_DEFS_H_ */
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index bc5114d..e356c99 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -28,8 +28,6 @@
 #include <linux/reiserfs_fs_sb.h>
 #endif
 
-struct fid;
-
 /*
  *  include/linux/reiser_fs.h
  *
@@ -37,6 +35,33 @@ struct fid;
  *
  */
 
+/* ioctl's command */
+#define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)
+/* define following flags to be the same as in ext2, so that chattr(1),
+   lsattr(1) will work with us. */
+#define REISERFS_IOC_GETFLAGS		FS_IOC_GETFLAGS
+#define REISERFS_IOC_SETFLAGS		FS_IOC_SETFLAGS
+#define REISERFS_IOC_GETVERSION		FS_IOC_GETVERSION
+#define REISERFS_IOC_SETVERSION		FS_IOC_SETVERSION
+
+#ifdef __KERNEL__
+/* the 32 bit compat definitions with int argument */
+#define REISERFS_IOC32_UNPACK		_IOW(0xCD, 1, int)
+#define REISERFS_IOC32_GETFLAGS		FS_IOC32_GETFLAGS
+#define REISERFS_IOC32_SETFLAGS		FS_IOC32_SETFLAGS
+#define REISERFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
+#define REISERFS_IOC32_SETVERSION	FS_IOC32_SETVERSION
+
+/* Locking primitives */
+/* Right now we are still falling back to (un)lock_kernel, but eventually that
+   would evolve into real per-fs locks */
+#define reiserfs_write_lock( sb ) lock_kernel()
+#define reiserfs_write_unlock( sb ) unlock_kernel()
+
+/* xattr stuff */
+#define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
+struct fid;
+
 /* in reading the #defines, it may help to understand that they employ
    the following abbreviations:
 
@@ -698,6 +723,7 @@ static inline void cpu_key_k_offset_dec(struct cpu_key *key)
 /* object identifier for root dir */
 #define REISERFS_ROOT_OBJECTID 2
 #define REISERFS_ROOT_PARENT_OBJECTID 1
+
 extern struct reiserfs_key root_key;
 
 /* 
@@ -1540,7 +1566,6 @@ struct reiserfs_iget_args {
 /*                    FUNCTION DECLARATIONS                                */
 /***************************************************************************/
 
-/*#ifdef __KERNEL__*/
 #define get_journal_desc_magic(bh) (bh->b_data + bh->b_size - 12)
 
 #define journal_trans_half(blocksize) \
@@ -2178,29 +2203,6 @@ long reiserfs_compat_ioctl(struct file *filp,
 		   unsigned int cmd, unsigned long arg);
 int reiserfs_unpack(struct inode *inode, struct file *filp);
 
-/* ioctl's command */
-#define REISERFS_IOC_UNPACK		_IOW(0xCD,1,long)
-/* define following flags to be the same as in ext2, so that chattr(1),
-   lsattr(1) will work with us. */
-#define REISERFS_IOC_GETFLAGS		FS_IOC_GETFLAGS
-#define REISERFS_IOC_SETFLAGS		FS_IOC_SETFLAGS
-#define REISERFS_IOC_GETVERSION		FS_IOC_GETVERSION
-#define REISERFS_IOC_SETVERSION		FS_IOC_SETVERSION
-
-/* the 32 bit compat definitions with int argument */
-#define REISERFS_IOC32_UNPACK		_IOW(0xCD, 1, int)
-#define REISERFS_IOC32_GETFLAGS		FS_IOC32_GETFLAGS
-#define REISERFS_IOC32_SETFLAGS		FS_IOC32_SETFLAGS
-#define REISERFS_IOC32_GETVERSION	FS_IOC32_GETVERSION
-#define REISERFS_IOC32_SETVERSION	FS_IOC32_SETVERSION
-
-/* Locking primitives */
-/* Right now we are still falling back to (un)lock_kernel, but eventually that
-   would evolve into real per-fs locks */
-#define reiserfs_write_lock( sb ) lock_kernel()
-#define reiserfs_write_unlock( sb ) unlock_kernel()
-
-/* xattr stuff */
-#define REISERFS_XATTR_DIR_SEM(s) (REISERFS_SB(s)->xattr_dir_sem)
 
+#endif /* __KERNEL__ */
 #endif				/* _LINUX_REISER_FS_H */
diff --git a/include/linux/selinux_netlink.h b/include/linux/selinux_netlink.h
index bbf489d..d239797 100644
--- a/include/linux/selinux_netlink.h
+++ b/include/linux/selinux_netlink.h
@@ -12,6 +12,8 @@
 #ifndef _LINUX_SELINUX_NETLINK_H
 #define _LINUX_SELINUX_NETLINK_H
 
+#include <linux/types.h>
+
 /* Message types. */
 #define SELNL_MSG_BASE 0x10
 enum {
@@ -38,11 +40,11 @@ enum selinux_nlgroups {
 
 /* Message structures */
 struct selnl_msg_setenforce {
-	int32_t		val;
+	__s32		val;
 };
 
 struct selnl_msg_policyload {
-	u_int32_t	seqno;
+	__u32	seqno;
 };
 
 #endif /* _LINUX_SELINUX_NETLINK_H */
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 20fc4bb..afc0190 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -24,10 +24,12 @@ struct __kernel_sockaddr_storage {
 #include <linux/types.h>		/* pid_t			*/
 #include <linux/compiler.h>		/* __user			*/
 
-#ifdef CONFIG_PROC_FS
+#ifdef __KERNEL__
+# ifdef CONFIG_PROC_FS
 struct seq_file;
 extern void socket_seq_show(struct seq_file *seq);
-#endif
+# endif
+#endif /* __KERNEL__ */
 
 typedef unsigned short	sa_family_t;
 
diff --git a/include/linux/suspend_ioctls.h b/include/linux/suspend_ioctls.h
index 2c6faec..0b30382 100644
--- a/include/linux/suspend_ioctls.h
+++ b/include/linux/suspend_ioctls.h
@@ -1,14 +1,15 @@
 #ifndef _LINUX_SUSPEND_IOCTLS_H
 #define _LINUX_SUSPEND_IOCTLS_H
 
+#include <linux/types.h>
 /*
  * This structure is used to pass the values needed for the identification
  * of the resume swap area from a user space to the kernel via the
  * SNAPSHOT_SET_SWAP_AREA ioctl
  */
 struct resume_swap_area {
-	loff_t offset;
-	u_int32_t dev;
+	__kernel_loff_t offset;
+	__u32 dev;
 } __attribute__((packed));
 
 #define SNAPSHOT_IOC_MAGIC	'3'
@@ -20,13 +21,13 @@ struct resume_swap_area {
 #define SNAPSHOT_S2RAM			_IO(SNAPSHOT_IOC_MAGIC, 11)
 #define SNAPSHOT_SET_SWAP_AREA		_IOW(SNAPSHOT_IOC_MAGIC, 13, \
 							struct resume_swap_area)
-#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, loff_t)
+#define SNAPSHOT_GET_IMAGE_SIZE		_IOR(SNAPSHOT_IOC_MAGIC, 14, __kernel_loff_t)
 #define SNAPSHOT_PLATFORM_SUPPORT	_IO(SNAPSHOT_IOC_MAGIC, 15)
 #define SNAPSHOT_POWER_OFF		_IO(SNAPSHOT_IOC_MAGIC, 16)
 #define SNAPSHOT_CREATE_IMAGE		_IOW(SNAPSHOT_IOC_MAGIC, 17, int)
 #define SNAPSHOT_PREF_IMAGE_SIZE	_IO(SNAPSHOT_IOC_MAGIC, 18)
-#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, loff_t)
-#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, loff_t)
+#define SNAPSHOT_AVAIL_SWAP_SIZE	_IOR(SNAPSHOT_IOC_MAGIC, 19, __kernel_loff_t)
+#define SNAPSHOT_ALLOC_SWAP_PAGE	_IOR(SNAPSHOT_IOC_MAGIC, 20, __kernel_loff_t)
 #define SNAPSHOT_IOC_MAXNR	20
 
 #endif /* _LINUX_SUSPEND_IOCTLS_H */
diff --git a/include/linux/time.h b/include/linux/time.h
index fbbd2a1..242f624 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -12,14 +12,14 @@
 #ifndef _STRUCT_TIMESPEC
 #define _STRUCT_TIMESPEC
 struct timespec {
-	time_t	tv_sec;		/* seconds */
-	long	tv_nsec;	/* nanoseconds */
+	__kernel_time_t	tv_sec;			/* seconds */
+	long		tv_nsec;		/* nanoseconds */
 };
 #endif
 
 struct timeval {
-	time_t		tv_sec;		/* seconds */
-	suseconds_t	tv_usec;	/* microseconds */
+	__kernel_time_t		tv_sec;		/* seconds */
+	__kernel_suseconds_t	tv_usec;	/* microseconds */
 };
 
 struct timezone {
diff --git a/include/linux/times.h b/include/linux/times.h
index e2d3020..87b6261 100644
--- a/include/linux/times.h
+++ b/include/linux/times.h
@@ -4,10 +4,10 @@
 #include <linux/types.h>
 
 struct tms {
-	clock_t tms_utime;
-	clock_t tms_stime;
-	clock_t tms_cutime;
-	clock_t tms_cstime;
+	__kernel_clock_t tms_utime;
+	__kernel_clock_t tms_stime;
+	__kernel_clock_t tms_cutime;
+	__kernel_clock_t tms_cstime;
 };
 
 #endif
diff --git a/include/linux/types.h b/include/linux/types.h
index 712ca53..5abe354 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -1,6 +1,9 @@
 #ifndef _LINUX_TYPES_H
 #define _LINUX_TYPES_H
 
+#include <asm/types.h>
+
+#ifndef __ASSEMBLY__
 #ifdef	__KERNEL__
 
 #define DECLARE_BITMAP(name,bits) \
@@ -9,9 +12,8 @@
 #endif
 
 #include <linux/posix_types.h>
-#include <asm/types.h>
 
-#ifndef __KERNEL_STRICT_NAMES
+#ifdef __KERNEL__
 
 typedef __u32 __kernel_dev_t;
 
@@ -29,7 +31,6 @@ typedef __kernel_timer_t	timer_t;
 typedef __kernel_clockid_t	clockid_t;
 typedef __kernel_mqd_t		mqd_t;
 
-#ifdef __KERNEL__
 typedef _Bool			bool;
 
 typedef __kernel_uid32_t	uid_t;
@@ -45,14 +46,6 @@ typedef __kernel_old_uid_t	old_uid_t;
 typedef __kernel_old_gid_t	old_gid_t;
 #endif /* CONFIG_UID16 */
 
-/* libc5 includes this file to define uid_t, thus uid_t can never change
- * when it is included by non-kernel code
- */
-#else
-typedef __kernel_uid_t		uid_t;
-typedef __kernel_gid_t		gid_t;
-#endif /* __KERNEL__ */
-
 #if defined(__GNUC__)
 typedef __kernel_loff_t		loff_t;
 #endif
@@ -154,7 +147,7 @@ typedef unsigned long blkcnt_t;
 #define pgoff_t unsigned long
 #endif
 
-#endif /* __KERNEL_STRICT_NAMES */
+#endif /* __KERNEL__ */
 
 /*
  * Below are truly Linux-specific types that should never collide with
@@ -212,5 +205,5 @@ struct ustat {
 };
 
 #endif	/* __KERNEL__ */
-
+#endif /*  __ASSEMBLY__ */
 #endif /* _LINUX_TYPES_H */
diff --git a/include/linux/utime.h b/include/linux/utime.h
index 640be6a..5cdf673 100644
--- a/include/linux/utime.h
+++ b/include/linux/utime.h
@@ -4,8 +4,8 @@
 #include <linux/types.h>
 
 struct utimbuf {
-	time_t actime;
-	time_t modtime;
+	__kernel_time_t actime;
+	__kernel_time_t modtime;
 };
 
 #endif
diff --git a/include/linux/xfrm.h b/include/linux/xfrm.h
index 52f3abd..2d4ec15 100644
--- a/include/linux/xfrm.h
+++ b/include/linux/xfrm.h
@@ -58,7 +58,7 @@ struct xfrm_selector
 	__u8	prefixlen_s;
 	__u8	proto;
 	int	ifindex;
-	uid_t	user;
+	__kernel_uid32_t	user;
 };
 
 #define XFRM_INF (~(__u64)0)
diff --git a/include/mtd/inftl-user.h b/include/mtd/inftl-user.h
index d409d48..8376bd1 100644
--- a/include/mtd/inftl-user.h
+++ b/include/mtd/inftl-user.h
@@ -16,33 +16,33 @@
 /* Block Control Information */
 
 struct inftl_bci {
-	uint8_t ECCsig[6];
-	uint8_t Status;
-	uint8_t Status1;
+	__u8 ECCsig[6];
+	__u8 Status;
+	__u8 Status1;
 } __attribute__((packed));
 
 struct inftl_unithead1 {
-	uint16_t virtualUnitNo;
-	uint16_t prevUnitNo;
-	uint8_t ANAC;
-	uint8_t NACs;
-	uint8_t parityPerField;
-	uint8_t discarded;
+	__u16 virtualUnitNo;
+	__u16 prevUnitNo;
+	__u8 ANAC;
+	__u8 NACs;
+	__u8 parityPerField;
+	__u8 discarded;
 } __attribute__((packed));
 
 struct inftl_unithead2 {
-	uint8_t parityPerField;
-	uint8_t ANAC;
-	uint16_t prevUnitNo;
-	uint16_t virtualUnitNo;
-	uint8_t NACs;
-	uint8_t discarded;
+	__u8 parityPerField;
+	__u8 ANAC;
+	__u16 prevUnitNo;
+	__u16 virtualUnitNo;
+	__u8 NACs;
+	__u8 discarded;
 } __attribute__((packed));
 
 struct inftl_unittail {
-	uint8_t Reserved[4];
-	uint16_t EraseMark;
-	uint16_t EraseMark1;
+	__u8 Reserved[4];
+	__u16 EraseMark;
+	__u16 EraseMark1;
 } __attribute__((packed));
 
 union inftl_uci {
diff --git a/include/mtd/jffs2-user.h b/include/mtd/jffs2-user.h
index 001685d..fa94b0e 100644
--- a/include/mtd/jffs2-user.h
+++ b/include/mtd/jffs2-user.h
@@ -7,6 +7,7 @@
 
 /* This file is blessed for inclusion by userspace */
 #include <linux/jffs2.h>
+#include <linux/types.h>
 #include <endian.h>
 #include <byteswap.h>
 
@@ -19,8 +20,8 @@
 
 extern int target_endian;
 
-#define t16(x) ({ uint16_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
-#define t32(x) ({ uint32_t __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
+#define t16(x) ({ __u16 __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_16(__b); })
+#define t32(x) ({ __u32 __b = (x); (target_endian==__BYTE_ORDER)?__b:bswap_32(__b); })
 
 #define cpu_to_je16(x) ((jint16_t){t16(x)})
 #define cpu_to_je32(x) ((jint32_t){t32(x)})
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index c6c61cd..b6595b3 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -5,14 +5,16 @@
 #ifndef __MTD_ABI_H__
 #define __MTD_ABI_H__
 
+#include <linux/types.h>
+
 struct erase_info_user {
-	uint32_t start;
-	uint32_t length;
+	__u32 start;
+	__u32 length;
 };
 
 struct mtd_oob_buf {
-	uint32_t start;
-	uint32_t length;
+	__u32 start;
+	__u32 length;
 	unsigned char __user *ptr;
 };
 
@@ -48,30 +50,30 @@ struct mtd_oob_buf {
 #define MTD_OTP_USER		2
 
 struct mtd_info_user {
-	uint8_t type;
-	uint32_t flags;
-	uint32_t size;	 // Total size of the MTD
-	uint32_t erasesize;
-	uint32_t writesize;
-	uint32_t oobsize;   // Amount of OOB data per block (e.g. 16)
+	__u8 type;
+	__u32 flags;
+	__u32 size;	 // Total size of the MTD
+	__u32 erasesize;
+	__u32 writesize;
+	__u32 oobsize;   // Amount of OOB data per block (e.g. 16)
 	/* The below two fields are obsolete and broken, do not use them
 	 * (TODO: remove at some point) */
-	uint32_t ecctype;
-	uint32_t eccsize;
+	__u32 ecctype;
+	__u32 eccsize;
 };
 
 struct region_info_user {
-	uint32_t offset;		/* At which this region starts,
+	__u32 offset;		/* At which this region starts,
 					 * from the beginning of the MTD */
-	uint32_t erasesize;		/* For this region */
-	uint32_t numblocks;		/* Number of blocks in this region */
-	uint32_t regionindex;
+	__u32 erasesize;		/* For this region */
+	__u32 numblocks;		/* Number of blocks in this region */
+	__u32 regionindex;
 };
 
 struct otp_info {
-	uint32_t start;
-	uint32_t length;
-	uint32_t locked;
+	__u32 start;
+	__u32 length;
+	__u32 locked;
 };
 
 #define MEMGETINFO		_IOR('M', 1, struct mtd_info_user)
@@ -84,8 +86,8 @@ struct otp_info {
 #define MEMGETREGIONINFO	_IOWR('M', 8, struct region_info_user)
 #define MEMSETOOBSEL		_IOW('M', 9, struct nand_oobinfo)
 #define MEMGETOOBSEL		_IOR('M', 10, struct nand_oobinfo)
-#define MEMGETBADBLOCK		_IOW('M', 11, loff_t)
-#define MEMSETBADBLOCK		_IOW('M', 12, loff_t)
+#define MEMGETBADBLOCK		_IOW('M', 11, __kernel_loff_t)
+#define MEMSETBADBLOCK		_IOW('M', 12, __kernel_loff_t)
 #define OTPSELECT		_IOR('M', 13, int)
 #define OTPGETREGIONCOUNT	_IOW('M', 14, int)
 #define OTPGETREGIONINFO	_IOW('M', 15, struct otp_info)
@@ -99,15 +101,15 @@ struct otp_info {
  * interfaces
  */
 struct nand_oobinfo {
-	uint32_t useecc;
-	uint32_t eccbytes;
-	uint32_t oobfree[8][2];
-	uint32_t eccpos[32];
+	__u32 useecc;
+	__u32 eccbytes;
+	__u32 oobfree[8][2];
+	__u32 eccpos[32];
 };
 
 struct nand_oobfree {
-	uint32_t offset;
-	uint32_t length;
+	__u32 offset;
+	__u32 length;
 };
 
 #define MTD_MAX_OOBFREE_ENTRIES	8
@@ -116,9 +118,9 @@ struct nand_oobfree {
  * diagnosis and to allow creation of raw images
  */
 struct nand_ecclayout {
-	uint32_t eccbytes;
-	uint32_t eccpos[64];
-	uint32_t oobavail;
+	__u32 eccbytes;
+	__u32 eccpos[64];
+	__u32 oobavail;
 	struct nand_oobfree oobfree[MTD_MAX_OOBFREE_ENTRIES];
 };
 
@@ -131,10 +133,10 @@ struct nand_ecclayout {
  * @bbtblocks:	number of blocks reserved for bad block tables
  */
 struct mtd_ecc_stats {
-	uint32_t corrected;
-	uint32_t failed;
-	uint32_t badblocks;
-	uint32_t bbtblocks;
+	__u32 corrected;
+	__u32 failed;
+	__u32 badblocks;
+	__u32 bbtblocks;
 };
 
 /*
diff --git a/include/mtd/nftl-user.h b/include/mtd/nftl-user.h
index 390d21c..98e9e57 100644
--- a/include/mtd/nftl-user.h
+++ b/include/mtd/nftl-user.h
@@ -6,33 +6,35 @@
 #ifndef __MTD_NFTL_USER_H__
 #define __MTD_NFTL_USER_H__
 
+#include <linux/types.h>
+
 /* Block Control Information */
 
 struct nftl_bci {
 	unsigned char ECCSig[6];
-	uint8_t Status;
-	uint8_t Status1;
+	__u8 Status;
+	__u8 Status1;
 }__attribute__((packed));
 
 /* Unit Control Information */
 
 struct nftl_uci0 {
-	uint16_t VirtUnitNum;
-	uint16_t ReplUnitNum;
-	uint16_t SpareVirtUnitNum;
-	uint16_t SpareReplUnitNum;
+	__u16 VirtUnitNum;
+	__u16 ReplUnitNum;
+	__u16 SpareVirtUnitNum;
+	__u16 SpareReplUnitNum;
 } __attribute__((packed));
 
 struct nftl_uci1 {
-	uint32_t WearInfo;
-	uint16_t EraseMark;
-	uint16_t EraseMark1;
+	__u32 WearInfo;
+	__u16 EraseMark;
+	__u16 EraseMark1;
 } __attribute__((packed));
 
 struct nftl_uci2 {
-        uint16_t FoldMark;
-        uint16_t FoldMark1;
-	uint32_t unused;
+        __u16 FoldMark;
+        __u16 FoldMark1;
+	__u32 unused;
 } __attribute__((packed));
 
 union nftl_uci {
@@ -50,9 +52,9 @@ struct nftl_oob {
 
 struct NFTLMediaHeader {
 	char DataOrgID[6];
-	uint16_t NumEraseUnits;
-	uint16_t FirstPhysicalEUN;
-	uint32_t FormattedSize;
+	__u16 NumEraseUnits;
+	__u16 FirstPhysicalEUN;
+	__u32 FormattedSize;
 	unsigned char UnitSizeFactor;
 } __attribute__((packed));
 
diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index 296efae..466a832 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -21,6 +21,8 @@
 #ifndef __UBI_USER_H__
 #define __UBI_USER_H__
 
+#include <linux/types.h>
+
 /*
  * UBI device creation (the same as MTD device attachment)
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -152,7 +154,7 @@
 /* Create an UBI volume */
 #define UBI_IOCMKVOL _IOW(UBI_IOC_MAGIC, 0, struct ubi_mkvol_req)
 /* Remove an UBI volume */
-#define UBI_IOCRMVOL _IOW(UBI_IOC_MAGIC, 1, int32_t)
+#define UBI_IOCRMVOL _IOW(UBI_IOC_MAGIC, 1, __s32)
 /* Re-size an UBI volume */
 #define UBI_IOCRSVOL _IOW(UBI_IOC_MAGIC, 2, struct ubi_rsvol_req)
 /* Re-name volumes */
@@ -165,24 +167,24 @@
 /* Attach an MTD device */
 #define UBI_IOCATT _IOW(UBI_CTRL_IOC_MAGIC, 64, struct ubi_attach_req)
 /* Detach an MTD device */
-#define UBI_IOCDET _IOW(UBI_CTRL_IOC_MAGIC, 65, int32_t)
+#define UBI_IOCDET _IOW(UBI_CTRL_IOC_MAGIC, 65, __s32)
 
 /* ioctl commands of UBI volume character devices */
 
 #define UBI_VOL_IOC_MAGIC 'O'
 
 /* Start UBI volume update */
-#define UBI_IOCVOLUP _IOW(UBI_VOL_IOC_MAGIC, 0, int64_t)
+#define UBI_IOCVOLUP _IOW(UBI_VOL_IOC_MAGIC, 0, __s64)
 /* LEB erasure command, used for debugging, disabled by default */
-#define UBI_IOCEBER _IOW(UBI_VOL_IOC_MAGIC, 1, int32_t)
+#define UBI_IOCEBER _IOW(UBI_VOL_IOC_MAGIC, 1, __s32)
 /* Atomic LEB change command */
-#define UBI_IOCEBCH _IOW(UBI_VOL_IOC_MAGIC, 2, int32_t)
+#define UBI_IOCEBCH _IOW(UBI_VOL_IOC_MAGIC, 2, __s32)
 /* Map LEB command */
 #define UBI_IOCEBMAP _IOW(UBI_VOL_IOC_MAGIC, 3, struct ubi_map_req)
 /* Unmap LEB command */
-#define UBI_IOCEBUNMAP _IOW(UBI_VOL_IOC_MAGIC, 4, int32_t)
+#define UBI_IOCEBUNMAP _IOW(UBI_VOL_IOC_MAGIC, 4, __s32)
 /* Check if LEB is mapped command */
-#define UBI_IOCEBISMAP _IOR(UBI_VOL_IOC_MAGIC, 5, int32_t)
+#define UBI_IOCEBISMAP _IOR(UBI_VOL_IOC_MAGIC, 5, __s32)
 /* Set an UBI volume property */
 #define UBI_IOCSETPROP _IOW(UBI_VOL_IOC_MAGIC, 6, struct ubi_set_prop_req)
 
@@ -260,10 +262,10 @@ enum {
  * sub-page of the first page and add needed padding.
  */
 struct ubi_attach_req {
-	int32_t ubi_num;
-	int32_t mtd_num;
-	int32_t vid_hdr_offset;
-	int8_t padding[12];
+	__s32 ubi_num;
+	__s32 mtd_num;
+	__s32 vid_hdr_offset;
+	__s8 padding[12];
 };
 
 /**
@@ -298,13 +300,13 @@ struct ubi_attach_req {
  * BLOBs, without caring about how to properly align them.
  */
 struct ubi_mkvol_req {
-	int32_t vol_id;
-	int32_t alignment;
-	int64_t bytes;
-	int8_t vol_type;
-	int8_t padding1;
-	int16_t name_len;
-	int8_t padding2[4];
+	__s32 vol_id;
+	__s32 alignment;
+	__s64 bytes;
+	__s8 vol_type;
+	__s8 padding1;
+	__s16 name_len;
+	__s8 padding2[4];
 	char name[UBI_MAX_VOLUME_NAME + 1];
 } __attribute__ ((packed));
 
@@ -320,8 +322,8 @@ struct ubi_mkvol_req {
  * zero number of bytes).
  */
 struct ubi_rsvol_req {
-	int64_t bytes;
-	int32_t vol_id;
+	__s64 bytes;
+	__s32 vol_id;
 } __attribute__ ((packed));
 
 /**
@@ -356,12 +358,12 @@ struct ubi_rsvol_req {
  * re-name request.
  */
 struct ubi_rnvol_req {
-	int32_t count;
-	int8_t padding1[12];
+	__s32 count;
+	__s8 padding1[12];
 	struct {
-		int32_t vol_id;
-		int16_t name_len;
-		int8_t  padding2[2];
+		__s32 vol_id;
+		__s16 name_len;
+		__s8  padding2[2];
 		char    name[UBI_MAX_VOLUME_NAME + 1];
 	} ents[UBI_MAX_RNVOL];
 } __attribute__ ((packed));
@@ -375,10 +377,10 @@ struct ubi_rnvol_req {
  * @padding: reserved for future, not used, has to be zeroed
  */
 struct ubi_leb_change_req {
-	int32_t lnum;
-	int32_t bytes;
-	int8_t  dtype;
-	int8_t  padding[7];
+	__s32 lnum;
+	__s32 bytes;
+	__s8  dtype;
+	__s8  padding[7];
 } __attribute__ ((packed));
 
 /**
@@ -388,9 +390,9 @@ struct ubi_leb_change_req {
  * @padding: reserved for future, not used, has to be zeroed
  */
 struct ubi_map_req {
-	int32_t lnum;
-	int8_t  dtype;
-	int8_t  padding[3];
+	__s32 lnum;
+	__s8  dtype;
+	__s8  padding[3];
 } __attribute__ ((packed));
 
 
@@ -402,9 +404,9 @@ struct ubi_map_req {
  * @value: value to set
  */
 struct ubi_set_prop_req {
-       uint8_t  property;
-       uint8_t  padding[7];
-       uint64_t value;
+       __u8  property;
+       __u8  padding[7];
+       __u64 value;
 }  __attribute__ ((packed));
 
 #endif /* __UBI_USER_H__ */
diff --git a/include/sound/asound.h b/include/sound/asound.h
index 1c02ed1..d9beda5 100644
--- a/include/sound/asound.h
+++ b/include/sound/asound.h
@@ -23,9 +23,10 @@
 #ifndef __SOUND_ASOUND_H
 #define __SOUND_ASOUND_H
 
+#include <linux/types.h>
+
 #ifdef __KERNEL__
 #include <linux/ioctl.h>
-#include <linux/types.h>
 #include <linux/time.h>
 #include <asm/byteorder.h>
 
@@ -342,7 +343,7 @@ struct snd_interval {
 #define SNDRV_MASK_MAX	256
 
 struct snd_mask {
-	u_int32_t bits[(SNDRV_MASK_MAX+31)/32];
+	__u32 bits[(SNDRV_MASK_MAX+31)/32];
 };
 
 struct snd_pcm_hw_params {
@@ -385,7 +386,7 @@ struct snd_pcm_sw_params {
 
 struct snd_pcm_channel_info {
 	unsigned int channel;
-	off_t offset;			/* mmap offset */
+	__kernel_off_t offset;		/* mmap offset */
 	unsigned int first;		/* offset to first sample in bits */
 	unsigned int step;		/* samples distance in bits */
 };
@@ -789,7 +790,7 @@ struct snd_ctl_elem_info {
 	snd_ctl_elem_type_t type;	/* R: value type - SNDRV_CTL_ELEM_TYPE_* */
 	unsigned int access;		/* R: value access (bitmask) - SNDRV_CTL_ELEM_ACCESS_* */
 	unsigned int count;		/* count of values */
-	pid_t owner;			/* owner's PID of this control */
+	__kernel_pid_t owner;		/* owner's PID of this control */
 	union {
 		struct {
 			long min;		/* R: minimum value */
diff --git a/include/sound/emu10k1.h b/include/sound/emu10k1.h
index 10ee28e..6a664c3 100644
--- a/include/sound/emu10k1.h
+++ b/include/sound/emu10k1.h
@@ -1,6 +1,8 @@
 #ifndef __SOUND_EMU10K1_H
 #define __SOUND_EMU10K1_H
 
+#include <linux/types.h>
+
 /*
  *  Copyright (c) by Jaroslav Kysela <perex@perex.cz>,
  *		     Creative Labs, Inc.
@@ -34,6 +36,7 @@
 #include <sound/timer.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
+
 #include <asm/io.h>
 
 /* ------------------- DEFINES -------------------- */
@@ -2171,7 +2174,7 @@ struct snd_emu10k1_fx8010_code {
 	char name[128];
 
 	DECLARE_BITMAP(gpr_valid, 0x200); /* bitmask of valid initializers */
-	u_int32_t __user *gpr_map;	  /* initializers */
+	__u32 __user *gpr_map;		/* initializers */
 
 	unsigned int gpr_add_control_count; /* count of GPR controls to add/replace */
 	struct snd_emu10k1_fx8010_control_gpr __user *gpr_add_controls; /* GPR controls to add/replace */
@@ -2184,11 +2187,11 @@ struct snd_emu10k1_fx8010_code {
 	struct snd_emu10k1_fx8010_control_gpr __user *gpr_list_controls; /* listed GPR controls */
 
 	DECLARE_BITMAP(tram_valid, 0x100); /* bitmask of valid initializers */
-	u_int32_t __user *tram_data_map;  /* data initializers */
-	u_int32_t __user *tram_addr_map;  /* map initializers */
+	__u32 __user *tram_data_map;	  /* data initializers */
+	__u32 __user *tram_addr_map;	  /* map initializers */
 
 	DECLARE_BITMAP(code_valid, 1024); /* bitmask of valid instructions */
-	u_int32_t __user *code;		  /* one instruction - 64 bits */
+	__u32 __user *code;		  /* one instruction - 64 bits */
 };
 
 struct snd_emu10k1_fx8010_tram {
diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index db30fac..56f90a4 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -38,7 +38,7 @@ foreach my $file (@files) {
 		&check_asm_types();
 		&check_sizetypes();
 		&check_prototypes();
-		&check_config();
+		# Dropped for now. Too much noise &check_config();
 	}
 	close FH;
 }
