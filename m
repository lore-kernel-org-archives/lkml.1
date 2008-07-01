Return-Path: <linux-kernel-owner+w=401wt.eu-S1751827AbYGAQ2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbYGAQ2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYGAQ1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:27:39 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:48218 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYGAQ1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:27:37 -0400
Date: Tue, 1 Jul 2008 19:27:16 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Avi Kivity <avi@qumranet.com>
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: [2.6 patch] remove dummy asm/kvm.h files
Message-ID: <20080701162716.GB32598@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dummy asm/kvm.h files on architectures not (yet) 
supporting KVM and uses the same conditional headers installation as
already used for a.out.h .

Also removed are superfluous install rules in the s390 and x86 Kbuild 
files (they are already in Kbuild.asm).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/asm-alpha/kvm.h        |    6 ------
 include/asm-arm/kvm.h          |    6 ------
 include/asm-avr32/kvm.h        |    6 ------
 include/asm-blackfin/kvm.h     |    6 ------
 include/asm-cris/kvm.h         |    6 ------
 include/asm-frv/kvm.h          |    6 ------
 include/asm-generic/Kbuild.asm |    2 ++
 include/asm-h8300/kvm.h        |    6 ------
 include/asm-m32r/kvm.h         |    6 ------
 include/asm-m68k/kvm.h         |    6 ------
 include/asm-m68knommu/kvm.h    |    6 ------
 include/asm-mips/kvm.h         |    6 ------
 include/asm-mn10300/kvm.h      |    6 ------
 include/asm-parisc/kvm.h       |    6 ------
 include/asm-s390/Kbuild        |    1 -
 include/asm-sh/kvm.h           |    6 ------
 include/asm-sparc/kvm.h        |    6 ------
 include/asm-sparc64/kvm.h      |    6 ------
 include/asm-um/kvm.h           |    6 ------
 include/asm-v850/kvm.h         |    6 ------
 include/asm-x86/Kbuild         |    1 -
 include/asm-xtensa/kvm.h       |    6 ------
 include/linux/Kbuild           |    2 ++
 23 files changed, 4 insertions(+), 116 deletions(-)

ab4cdd1a69f500aa1eeed892142a496172b5e40a 
diff --git a/include/asm-alpha/kvm.h b/include/asm-alpha/kvm.h
deleted file mode 100644
index b9daec4..0000000
--- a/include/asm-alpha/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_ALPHA_H
-#define __LINUX_KVM_ALPHA_H
-
-/* alpha does not support KVM */
-
-#endif
diff --git a/include/asm-arm/kvm.h b/include/asm-arm/kvm.h
deleted file mode 100644
index cb3c08c..0000000
--- a/include/asm-arm/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_ARM_H
-#define __LINUX_KVM_ARM_H
-
-/* arm does not support KVM */
-
-#endif
diff --git a/include/asm-avr32/kvm.h b/include/asm-avr32/kvm.h
deleted file mode 100644
index 8c57770..0000000
--- a/include/asm-avr32/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_AVR32_H
-#define __LINUX_KVM_AVR32_H
-
-/* avr32 does not support KVM */
-
-#endif
diff --git a/include/asm-blackfin/kvm.h b/include/asm-blackfin/kvm.h
deleted file mode 100644
index e3477d7..0000000
--- a/include/asm-blackfin/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_BLACKFIN_H
-#define __LINUX_KVM_BLACKFIN_H
-
-/* blackfin does not support KVM */
-
-#endif
diff --git a/include/asm-cris/kvm.h b/include/asm-cris/kvm.h
deleted file mode 100644
index c860f51..0000000
--- a/include/asm-cris/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_CRIS_H
-#define __LINUX_KVM_CRIS_H
-
-/* cris does not support KVM */
-
-#endif
diff --git a/include/asm-frv/kvm.h b/include/asm-frv/kvm.h
deleted file mode 100644
index 9c8a4f0..0000000
--- a/include/asm-frv/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_FRV_H
-#define __LINUX_KVM_FRV_H
-
-/* frv does not support KVM */
-
-#endif
diff --git a/include/asm-generic/Kbuild.asm b/include/asm-generic/Kbuild.asm
index 7cd25b8..1170dc6 100644
--- a/include/asm-generic/Kbuild.asm
+++ b/include/asm-generic/Kbuild.asm
@@ -1,4 +1,6 @@
+ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 header-y  += kvm.h
+endif
 
 ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/a.out.h),)
 unifdef-y += a.out.h
diff --git a/include/asm-h8300/kvm.h b/include/asm-h8300/kvm.h
deleted file mode 100644
index bdbed7b..0000000
--- a/include/asm-h8300/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_H8300_H
-#define __LINUX_KVM_H8300_H
-
-/* h8300 does not support KVM */
-
-#endif
diff --git a/include/asm-m32r/kvm.h b/include/asm-m32r/kvm.h
deleted file mode 100644
index 99a4051..0000000
--- a/include/asm-m32r/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_M32R_H
-#define __LINUX_KVM_M32R_H
-
-/* m32r does not support KVM */
-
-#endif
diff --git a/include/asm-m68k/kvm.h b/include/asm-m68k/kvm.h
deleted file mode 100644
index 7ed27fc..0000000
--- a/include/asm-m68k/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_M68K_H
-#define __LINUX_KVM_M68K_H
-
-/* m68k does not support KVM */
-
-#endif
diff --git a/include/asm-m68knommu/kvm.h b/include/asm-m68knommu/kvm.h
deleted file mode 100644
index b49d425..0000000
--- a/include/asm-m68knommu/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_M68KNOMMU_H
-#define __LINUX_KVM_M68KNOMMU_H
-
-/* m68knommu does not support KVM */
-
-#endif
diff --git a/include/asm-mips/kvm.h b/include/asm-mips/kvm.h
deleted file mode 100644
index 093a5b7..0000000
--- a/include/asm-mips/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_MIPS_H
-#define __LINUX_KVM_MIPS_H
-
-/* mips does not support KVM */
-
-#endif
diff --git a/include/asm-mn10300/kvm.h b/include/asm-mn10300/kvm.h
deleted file mode 100644
index f6b609f..0000000
--- a/include/asm-mn10300/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_MN10300_H
-#define __LINUX_KVM_MN10300_H
-
-/* mn10300 does not support KVM */
-
-#endif
diff --git a/include/asm-parisc/kvm.h b/include/asm-parisc/kvm.h
deleted file mode 100644
index 00cc458..0000000
--- a/include/asm-parisc/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_PARISC_H
-#define __LINUX_KVM_PARISC_H
-
-/* parisc does not support KVM */
-
-#endif
diff --git a/include/asm-s390/Kbuild b/include/asm-s390/Kbuild
index 13c9805..e92b429 100644
--- a/include/asm-s390/Kbuild
+++ b/include/asm-s390/Kbuild
@@ -7,7 +7,6 @@ header-y += tape390.h
 header-y += ucontext.h
 header-y += vtoc.h
 header-y += zcrypt.h
-header-y += kvm.h
 
 unifdef-y += cmb.h
 unifdef-y += debug.h
diff --git a/include/asm-sh/kvm.h b/include/asm-sh/kvm.h
deleted file mode 100644
index 6af51db..0000000
--- a/include/asm-sh/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_SH_H
-#define __LINUX_KVM_SH_H
-
-/* sh does not support KVM */
-
-#endif
diff --git a/include/asm-sparc/kvm.h b/include/asm-sparc/kvm.h
deleted file mode 100644
index 2e5478d..0000000
--- a/include/asm-sparc/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_SPARC_H
-#define __LINUX_KVM_SPARC_H
-
-/* sparc does not support KVM */
-
-#endif
diff --git a/include/asm-sparc64/kvm.h b/include/asm-sparc64/kvm.h
deleted file mode 100644
index 380537a..0000000
--- a/include/asm-sparc64/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_SPARC64_H
-#define __LINUX_KVM_SPARC64_H
-
-/* sparc64 does not support KVM */
-
-#endif
diff --git a/include/asm-um/kvm.h b/include/asm-um/kvm.h
deleted file mode 100644
index 66aa770..0000000
--- a/include/asm-um/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_UM_H
-#define __LINUX_KVM_UM_H
-
-/* um does not support KVM */
-
-#endif
diff --git a/include/asm-v850/kvm.h b/include/asm-v850/kvm.h
deleted file mode 100644
index 3f729b7..0000000
--- a/include/asm-v850/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_V850_H
-#define __LINUX_KVM_V850_H
-
-/* v850 does not support KVM */
-
-#endif
diff --git a/include/asm-x86/Kbuild b/include/asm-x86/Kbuild
index 1e35545..811e982 100644
--- a/include/asm-x86/Kbuild
+++ b/include/asm-x86/Kbuild
@@ -3,7 +3,6 @@ include include/asm-generic/Kbuild.asm
 header-y += boot.h
 header-y += bootparam.h
 header-y += debugreg.h
-header-y += kvm.h
 header-y += ldt.h
 header-y += msr-index.h
 header-y += prctl.h
diff --git a/include/asm-xtensa/kvm.h b/include/asm-xtensa/kvm.h
deleted file mode 100644
index bda4e33..0000000
--- a/include/asm-xtensa/kvm.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef __LINUX_KVM_XTENSA_H
-#define __LINUX_KVM_XTENSA_H
-
-/* xtensa does not support KVM */
-
-#endif
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 71d70d1..402c8f5 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -256,7 +256,9 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
+ifneq ($(wildcard $(srctree)/include/asm-$(SRCARCH)/kvm.h),)
 unifdef-y += kvm.h
+endif
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h

