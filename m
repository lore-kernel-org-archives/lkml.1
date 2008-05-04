Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbYEDPmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbYEDPmb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbYEDPmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:42:23 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:44216 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751256AbYEDPmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:42:21 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 32/56] microblaze_v2: definitions of types
Date: Sun,  4 May 2008 13:41:21 +0200
Message-Id: <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
 <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
 <c805caeb1dd7f6d1349c4a463cb88a5342a170d2.1209897266.git.monstr@monstr.eu>
 <f120ababf2bade9aab7199bffb3014aa606e5a1c.1209897266.git.monstr@monstr.eu>
 <684c36e5ad3f598e5079e88ec195545c4a7150c2.1209897266.git.monstr@monstr.eu>
 <ed3695121faf485d491cecdd96d5d4dcc498411d.1209897266.git.monstr@monstr.eu>
 <0674b1f7abb9a3d564b68c95bc28adc2c2fe9551.1209897266.git.monstr@monstr.eu>
 <9a7c6646e5dd9724c1cf34767adec181481fa3ef.1209897266.git.monstr@monstr.eu>
 <932956128c9c655a218a940eaf02017a5dd0bdf9.1209897266.git.monstr@monstr.eu>
 <2f801c33caee22e112af51ae927c264ce99ead01.1209897266.git.monstr@monstr.eu>
 <2391e49379fb6639f57d9d6e5811f3d49a4c6fda.1209897266.git.monstr@monstr.eu>
 <0873f3a1f3b72591735c6461b51964693cac52e5.1209897266.git.monstr@monstr.eu>
 <0ba1f259d3c17eba54e334622493577493f5065f.1209897266.git.monstr@monstr.eu>
 <694451053534fea7b78fb9d618b53a2b5ebeb602.1209897266.git.monstr@monstr.eu>
 <f0c837df4106a31c1a81917596603918f722ea7b.1209897266.git.monstr@monstr.eu>
 <d883a8d8da812d77fefd47730d28d0bdb7b504e0.1209897266.git.monstr@monstr.eu>
 <625ef466cf121d655539eedc919dd39166087e0c.1209897266.git.monstr@monstr.eu>
 <b5067a1846075ddd1035966ea1edc908579e2e88.1209897266.git.monstr@monstr.eu>
 <378157891bac535dbc55e658d5f03fdd332e85cf.1209897266.git.monstr@monstr.eu>
 <eadcc6f4754df78b69d6d54c404624d0390c8558.1209897266.git.monstr@monstr.eu>
 <4df4022e06b9056202cc2fdf0b99deb01563a0fa.1209897266.git.monstr@monstr.eu>
 <6b0c9864dc80776ae48d6488a6892e5d698751b7.1209897266.git.monstr@monstr.eu>
 <ea5cbbca49c38c506960fddba29cbd8cb24e1a8d.1209897266.git.monstr@monstr.eu>
 <4f4d6ed3fce9b21cdd6dcacb2d72fff7e9830628.1209897266.git.monstr@monstr.eu>
 <35e662a81eb86c7ffb2aaa6141ca38a07789f382.1209897266.git.monstr@monstr.eu>
 <b41fcf3dd830f4ba82692a9bec2406ed0c290e7e.1209897266.git.monstr@monstr.eu>
 <14acb31da2794d2d5916da3db3d75fe2285ac055.1209897266.git.monstr@monstr.eu>
 <598221ce2159046614d7b158ea62d5af51907af3.1209897266.git.monstr@monstr.eu>
 <41c1f410eaafd875246362d10ef9866d8cc2a934.1209897266.git.monstr@monstr.eu>
 <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
 <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
 <cfde3796e95bdd17c32e4fd7762d0aee55967707.1209897266.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/posix_types.h |   75 ++++++++++++++++++++++++++++++++++
 include/asm-microblaze/types.h       |   64 +++++++++++++++++++++++++++++
 2 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/posix_types.h
 create mode 100644 include/asm-microblaze/types.h

diff --git a/include/asm-microblaze/posix_types.h b/include/asm-microblaze/posix_types.h
new file mode 100644
index 0000000..a4aa46e
--- /dev/null
+++ b/include/asm-microblaze/posix_types.h
@@ -0,0 +1,75 @@
+/*
+ * include/asm-microblaze/posix_types.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
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
+typedef unsigned short	__kernel_mode_t;
+typedef unsigned short	__kernel_nlink_t;
+typedef long		__kernel_off_t;
+typedef int		__kernel_pid_t;
+typedef unsigned short	__kernel_ipc_pid_t;
+typedef unsigned short	__kernel_uid_t;
+typedef unsigned short	__kernel_gid_t;
+typedef unsigned int	__kernel_size_t;
+typedef int		__kernel_ssize_t;
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
+typedef unsigned short	__kernel_old_uid_t;
+typedef unsigned short	__kernel_old_gid_t;
+typedef unsigned short	__kernel_old_dev_t;
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
+#define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
+
+#endif /* defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2) */
+
+#endif /* _ASM_MICROBLAZE_POSIX_TYPES_H */
diff --git a/include/asm-microblaze/types.h b/include/asm-microblaze/types.h
new file mode 100644
index 0000000..052cc8f
--- /dev/null
+++ b/include/asm-microblaze/types.h
@@ -0,0 +1,64 @@
+/*
+ * include/asm-microblaze/types.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_TYPES_H
+#define _ASM_MICROBLAZE_TYPES_H
+
+#ifndef __ASSEMBLY__
+
+typedef unsigned short umode_t;
+
+/*
+ * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
+ * header files exported to user space
+ */
+
+typedef __signed__ char __s8;
+typedef unsigned char __u8;
+
+typedef __signed__ short __s16;
+typedef unsigned short __u16;
+
+typedef __signed__ int __s32;
+typedef unsigned int __u32;
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__)
+typedef __signed__ long long __s64;
+typedef unsigned long long __u64;
+#endif
+
+/*
+ * These aren't exported outside the kernel to avoid name space clashes
+ */
+#ifdef __KERNEL__
+
+typedef __signed__ char s8;
+typedef unsigned char u8;
+
+typedef __signed__ short s16;
+typedef unsigned short u16;
+
+typedef __signed__ int s32;
+typedef unsigned int u32;
+
+typedef __signed__ long long s64;
+typedef unsigned long long u64;
+
+
+#define BITS_PER_LONG 32
+
+/* Dma addresses are 32-bits wide. */
+
+typedef u32 dma_addr_t;
+
+#endif/* __KERNEL__ */
+#endif
+
+#endif /* _ASM_MICROBLAZE_TYPES_H */
-- 
1.5.4.GIT

