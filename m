Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYCJNL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYCJNL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbYCJNLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:11:17 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:17374 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYCJNLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:11:15 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kvm: provide kvm.h for all architecture: fixes headers_install
User-Agent: KMail/1.9.7
Cc: David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@qumranet.com>,
       Sam Ravnborg <sam@ravnborg.org>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       David Howells <dhowells@redhat.com>, linux-arch@vger.kernel.org,
       mm-commits@vger.kernel.org
References: <200803071326.06682.borntraeger@de.ibm.com> <1204933418.2495.14.camel@shinybook.infradead.org>
In-Reply-To: <1204933418.2495.14.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 10 Mar 2008 14:11:04 +0100
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <200803101411.04175.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, here goes the second version.
Andrew, if there are no further complaints, please replace the old patch,
with this version. Thank you.

-

[PATCH v2] kvm: provide kvm.h for all architecture: fixes headers_install

Currently include/linux/kvm.h is not considered by make headers_install, 
because Kbuild cannot handle " unifdef-$(CONFIG_FOO) += foo.h. 
This problem was introduced by 040922c04cf2c8ac70be2e88a8a9614ecdb41d2e, 
which makes this an 2.6.25 regression.

One way of solving the issue is to enhance Kbuild, but Avi Kivity and David
Woodhouse conviced me, that changing headers_install is not the way to go. 
This patch changes the definition for linux/kvm.h to unifdef-y.

If  unifdef-y is used for linux/kvm.h "make headers_check" will fail on all
architectures without asm/kvm.h. Therefore, this patch also provides 
asm/kvm.h on all architectures.

Changes since v1:
o use asm-generic/Kbuild.asm (Arnd Bergmann)
o fix comment in asm-frv (David Howells)

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Avi Kivity <avi@qumranet.com>

---
 include/asm-alpha/kvm.h        |    6 ++++++
 include/asm-arm/kvm.h          |    6 ++++++
 include/asm-avr32/kvm.h        |    6 ++++++
 include/asm-blackfin/kvm.h     |    6 ++++++
 include/asm-cris/kvm.h         |    6 ++++++
 include/asm-frv/kvm.h          |    6 ++++++
 include/asm-generic/Kbuild.asm |    2 ++
 include/asm-h8300/kvm.h        |    6 ++++++
 include/asm-ia64/kvm.h         |    6 ++++++
 include/asm-m32r/kvm.h         |    6 ++++++
 include/asm-m68k/kvm.h         |    6 ++++++
 include/asm-m68knommu/kvm.h    |    6 ++++++
 include/asm-mips/kvm.h         |    6 ++++++
 include/asm-mn10300/kvm.h      |    6 ++++++
 include/asm-parisc/kvm.h       |    6 ++++++
 include/asm-powerpc/kvm.h      |    6 ++++++
 include/asm-s390/kvm.h         |    6 ++++++
 include/asm-sh/kvm.h           |    6 ++++++
 include/asm-sparc/kvm.h        |    6 ++++++
 include/asm-sparc64/kvm.h      |    6 ++++++
 include/asm-um/kvm.h           |    6 ++++++
 include/asm-v850/kvm.h         |    6 ++++++
 include/asm-xtensa/kvm.h       |    6 ++++++
 include/linux/Kbuild           |    2 +-
 24 files changed, 135 insertions(+), 1 deletion(-)

Index: linux-2.6.git/include/asm-alpha/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-alpha/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ALPHA_H
+#define __LINUX_KVM_ALPHA_H
+
+/* alpha does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-arm/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-arm/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_ARM_H
+#define __LINUX_KVM_ARM_H
+
+/* arm does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-avr32/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-avr32/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_AVR32_H
+#define __LINUX_KVM_AVR32_H
+
+/* avr32 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-blackfin/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-blackfin/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_BLACKFIN_H
+#define __LINUX_KVM_BLACKFIN_H
+
+/* blackfin does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-cris/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-cris/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_CRIS_H
+#define __LINUX_KVM_CRIS_H
+
+/* cris does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-frv/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-frv/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_FRV_H
+#define __LINUX_KVM_FRV_H
+
+/* frv does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-generic/Kbuild.asm
===================================================================
--- linux-2.6.git.orig/include/asm-generic/Kbuild.asm
+++ linux-2.6.git/include/asm-generic/Kbuild.asm
@@ -1,3 +1,5 @@
+header-y  += kvm.h
+
 ifeq ($(wildcard 
include/asm-$(SRCARCH)/a.out.h),include/asm-$(SRCARCH)/a.out.h)
 unifdef-y += a.out.h
 endif
Index: linux-2.6.git/include/asm-h8300/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-h8300/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_H8300_H
+#define __LINUX_KVM_H8300_H
+
+/* h8300 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-ia64/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-ia64/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_IA64_H
+#define __LINUX_KVM_IA64_H
+
+/* ia64 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-m32r/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-m32r/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M32R_H
+#define __LINUX_KVM_M32R_H
+
+/* m32r does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-m68k/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-m68k/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M68K_H
+#define __LINUX_KVM_M68K_H
+
+/* m68k does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-m68knommu/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-m68knommu/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_M68KNOMMU_H
+#define __LINUX_KVM_M68KNOMMU_H
+
+/* m68knommu does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-mips/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-mips/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_MIPS_H
+#define __LINUX_KVM_MIPS_H
+
+/* mips does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-mn10300/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-mn10300/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_MN10300_H
+#define __LINUX_KVM_MN10300_H
+
+/* mn10300 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-parisc/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-parisc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_PARISC_H
+#define __LINUX_KVM_PARISC_H
+
+/* parisc does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-powerpc/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-powerpc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_POWERPC_H
+#define __LINUX_KVM_POWERPC_H
+
+/* powerpc does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-s390/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-s390/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_S390_H
+#define __LINUX_KVM_S390_H
+
+/* s390 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-sh/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-sh/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SH_H
+#define __LINUX_KVM_SH_H
+
+/* sh does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-sparc/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-sparc/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SPARC_H
+#define __LINUX_KVM_SPARC_H
+
+/* sparc does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-sparc64/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-sparc64/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_SPARC64_H
+#define __LINUX_KVM_SPARC64_H
+
+/* sparc64 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-um/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-um/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_UM_H
+#define __LINUX_KVM_UM_H
+
+/* um does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-v850/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-v850/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_V850_H
+#define __LINUX_KVM_V850_H
+
+/* v850 does not support KVM */
+
+#endif
Index: linux-2.6.git/include/asm-xtensa/kvm.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/asm-xtensa/kvm.h
@@ -0,0 +1,6 @@
+#ifndef __LINUX_KVM_XTENSA_H
+#define __LINUX_KVM_XTENSA_H
+
+/* xtensa does not support KVM */
+
+#endif
Index: linux-2.6.git/include/linux/Kbuild
===================================================================
--- linux-2.6.git.orig/include/linux/Kbuild
+++ linux-2.6.git/include/linux/Kbuild
@@ -257,7 +257,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-$(CONFIG_HAVE_KVM) += kvm.h
+unifdef-y += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
