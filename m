Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbYAZQAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbYAZQAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:00:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYAZPzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:06 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756101AbYAZPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:03 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 34/52] [microblaze] definitions of types
Date: Thu, 24 Jan 2008 16:03:09 +0100
Message-Id: <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <105791d33ea12564c70be0dd3fafef386f8e1b55.1201107832.git.monstr@monstr.eu>
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
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
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
index 0000000..a05f61f
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
+#ifndef _ASM_POSIX_TYPES_H
+#define _ASM_POSIX_TYPES_H
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
+#endif /* _ASM_POSIX_TYPES_H */
diff --git a/include/asm-microblaze/types.h b/include/asm-microblaze/types.h
new file mode 100644
index 0000000..3ba4b8d
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
+#ifndef _ASM_TYPES_H
+#define _ASM_TYPES_H
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
+#endif /* _ASM_TYPES_H */
-- 
1.5.4.rc4.14.g6fc74

