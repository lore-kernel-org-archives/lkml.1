Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbZCRVsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbZCRVsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757435AbZCRVmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:42:54 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54475 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754971AbZCRVmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:42:52 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: john.williams@petalogix.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 33/57] microblaze_v7: definitions of types
Date: Wed, 18 Mar 2009 21:31:00 +0100
Message-Id: <6eb167a9a027d644f10b843b8b1bde66e4c2ee25.1237407249.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <827e2a6a349e009f6c98f31178ce84042b0e2e10.1237407249.git.monstr@monstr.eu>
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
In-Reply-To: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
References: <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/posix_types.h |   69 +++++++++++++++++++++++++++++
 arch/microblaze/include/asm/types.h       |   38 ++++++++++++++++
 2 files changed, 107 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/include/asm/posix_types.h
 create mode 100644 arch/microblaze/include/asm/types.h

diff --git a/arch/microblaze/include/asm/posix_types.h b/arch/microblaze/include/asm/posix_types.h
new file mode 100644
index 0000000..c858eb7
--- /dev/null
+++ b/arch/microblaze/include/asm/posix_types.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_POSIX_TYPES_H
+#define _ASM_MICROBLAZE_POSIX_TYPES_H
+
+/*
+ * This file is generally used by user-level software, so you need to
+ * be a little careful about namespace pollution etc. Also, we cannot
+ * assume GCC is being used.
+ */
+
+typedef unsigned long	__kernel_ino_t;
+typedef unsigned int	__kernel_mode_t;
+typedef unsigned int	__kernel_nlink_t;
+typedef long		__kernel_off_t;
+typedef int		__kernel_pid_t;
+typedef unsigned int	__kernel_ipc_pid_t;
+typedef unsigned int	__kernel_uid_t;
+typedef unsigned int	__kernel_gid_t;
+typedef unsigned long	__kernel_size_t;
+typedef long		__kernel_ssize_t;
+typedef int		__kernel_ptrdiff_t;
+typedef long		__kernel_time_t;
+typedef long		__kernel_suseconds_t;
+typedef long		__kernel_clock_t;
+typedef int		__kernel_timer_t;
+typedef int		__kernel_clockid_t;
+typedef int		__kernel_daddr_t;
+typedef char *		__kernel_caddr_t;
+typedef unsigned short	__kernel_uid16_t;
+typedef unsigned short	__kernel_gid16_t;
+typedef unsigned int	__kernel_uid32_t;
+typedef unsigned int	__kernel_gid32_t;
+
+#ifdef __GNUC__
+typedef long long	__kernel_loff_t;
+#endif
+
+typedef struct {
+#if defined(__KERNEL__) || defined(__USE_ALL)
+	int	val[2];
+#else /* !defined(__KERNEL__) && !defined(__USE_ALL) */
+	int	__val[2];
+#endif /* !defined(__KERNEL__) && !defined(__USE_ALL) */
+} __kernel_fsid_t;
+
+#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+
+#undef	__FD_SET
+#define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
+
+#undef	__FD_CLR
+#define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
+
+#undef	__FD_ISSET
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
+
+#undef	__FD_ZERO
+#define __FD_ZERO(fdsetp) (memset(fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
+
+#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+
+#endif /* _ASM_MICROBLAZE_POSIX_TYPES_H */
diff --git a/arch/microblaze/include/asm/types.h b/arch/microblaze/include/asm/types.h
new file mode 100644
index 0000000..bebc018
--- /dev/null
+++ b/arch/microblaze/include/asm/types.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TYPES_H
+#define _ASM_MICROBLAZE_TYPES_H
+
+/*
+ * This file is never included by application software unless
+ * explicitly requested (e.g., via linux/types.h) in which case the
+ * application is Linux specific so (user-) name space pollution is
+ * not a major issue.  However, for interoperability, libraries still
+ * need to be careful to avoid a name clashes.
+ */
+
+#include <asm-generic/int-ll64.h>
+
+# ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#  ifdef __KERNEL__
+#  define BITS_PER_LONG 32
+
+/* Dma addresses are 32-bits wide. */
+
+typedef u32 dma_addr_t;
+
+#  endif/* __KERNEL__ */
+# endif /* __ASSEMBLY__ */
+#endif /* _ASM_MICROBLAZE_TYPES_H */
-- 
1.5.5.1

