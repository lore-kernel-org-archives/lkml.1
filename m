Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYEENzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYEENzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYEENyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:54:54 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:56641 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751601AbYEENyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:54:52 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 49/56] microblaze_v2: fcntl.h sockios.h ucontext.h
Date: Sun,  4 May 2008 13:41:38 +0200
Message-Id: <231ae415bf52de25c69f727fd13c50d201f8ecd8.1209897267.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu>
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
 <8aba2d82c85cd1d5b56de328c1fd080ee51f0211.1209897266.git.monstr@monstr.eu>
 <c4000ff625bd217f9bb683e3bf8c7193a82bd744.1209897266.git.monstr@monstr.eu>
 <491f823fac6c03cc36834ec569a45d30a03a72cf.1209897266.git.monstr@monstr.eu>
 <96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
 <92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
 <4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
 <49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
 <d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
 <27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
 <64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
 <9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
 <5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
 <59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
 <8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
 <5b1319d426b1f55e08402790b4bc16a33ec7c00c.1209897267.git.monstr@monstr.eu>
 <eff9f144fc70b87a9ff6767e9ab92d3d55eebbae.1209897267.git.monstr@monstr.eu>
 <643084ee3819dd169cad3c4e3565c5ff20dd3429.1209897267.git.monstr@monstr.eu>
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/fcntl.h    |  104 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/sockios.h  |   25 +++++++++
 include/asm-microblaze/ucontext.h |   24 +++++++++
 3 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/fcntl.h
 create mode 100644 include/asm-microblaze/sockios.h
 create mode 100644 include/asm-microblaze/ucontext.h

diff --git a/include/asm-microblaze/fcntl.h b/include/asm-microblaze/fcntl.h
new file mode 100644
index 0000000..b8706c9
--- /dev/null
+++ b/include/asm-microblaze/fcntl.h
@@ -0,0 +1,104 @@
+/*
+ * include/asm-microblaze/fcntl.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_FCNTL_H
+#define _ASM_MICROBLAZE_FCNTL_H
+
+/* open/fcntl - O_SYNC is only implemented on blocks devices and on files
+ located on an ext2 file system */
+#define O_ACCMODE	0003
+#define O_RDONLY	00
+#define O_WRONLY	01
+#define O_RDWR		02
+#define O_CREAT		0100 /* not fcntl */
+#define O_EXCL		0200 /* not fcntl */
+#define O_NOCTTY	0400 /* not fcntl */
+#define O_TRUNC		01000 /* not fcntl */
+#define O_APPEND	02000
+#define O_NONBLOCK	04000
+#define O_NDELAY	O_NONBLOCK
+#define O_SYNC		010000
+#define FASYNC		020000 /* fcntl, for BSD compatibility */
+#define O_DIRECTORY	040000 /* must be a directory */
+#define O_NOFOLLOW	0100000 /* don't follow links */
+#define O_LARGEFILE	0200000
+#define O_DIRECT	0400000 /* direct disk access hint */
+#define O_NOATIME	01000000
+#define O_CLOEXEC	02000000
+
+#define F_DUPFD		0 /* dup */
+#define F_GETFD		1 /* get close_on_exec */
+#define F_SETFD		2 /* set/clear close_on_exec */
+#define F_GETFL		3 /* get file->f_flags */
+#define F_SETFL		4 /* set file->f_flags */
+#define F_GETLK		5
+#define F_SETLK		6
+#define F_SETLKW	7
+
+#define F_SETOWN	8 /* for sockets. */
+#define F_GETOWN	9 /* for sockets. */
+#define F_SETSIG	10 /* for sockets. */
+#define F_GETSIG	11 /* for sockets. */
+
+#define F_GETLK64	12 /* using 'struct flock64' */
+#define F_SETLK64	13
+#define F_SETLKW64	14
+
+/* for F_[GET|SET]FL */
+#define FD_CLOEXEC	1 /* actually anything with low bit set goes */
+
+/* for posix fcntl() and lockf() */
+#define F_RDLCK		0
+#define F_WRLCK		1
+#define F_UNLCK		2
+
+/* for old implementation of bsd flock () */
+#define F_EXLCK		4 /* or 3 */
+#define F_SHLCK		8 /* or 4 */
+
+/* for leases */
+#define F_INPROGRESS	16
+
+/* operations for bsd flock(), also used by the kernel implementation */
+#define LOCK_SH		1 /* shared lock */
+#define LOCK_EX		2 /* exclusive lock */
+#define LOCK_NB		4 /* or'd with one of the above to prevent blocking */
+#define LOCK_UN		8 /* remove lock */
+
+#define LOCK_MAND	32 /* This is a mandatory flock */
+#define LOCK_READ	64 /* ... Which allows concurrent read operations */
+#define LOCK_WRITE	128 /* ... Which allows concurrent write operations */
+#define LOCK_RW		192 /* ... Which allows concurrent read & write ops */
+
+#ifdef __KERNEL__
+#define F_POSIX		1
+#define F_FLOCK		2
+#define F_BROKEN	4 /* broken flock() emulation */
+#endif /* __KERNEL__ */
+
+struct flock {
+	short l_type;
+	short l_whence;
+	off_t l_start;
+	off_t l_len;
+	pid_t l_pid;
+};
+
+struct flock64 {
+	short l_type;
+	short l_whence;
+	loff_t l_start;
+	loff_t l_len;
+	pid_t l_pid;
+};
+
+#define F_LINUX_SPECIFIC_BASE	1024
+
+#endif /* _ASM_MICROBLAZE_FCNTL_H */
diff --git a/include/asm-microblaze/sockios.h b/include/asm-microblaze/sockios.h
new file mode 100644
index 0000000..a11b12f
--- /dev/null
+++ b/include/asm-microblaze/sockios.h
@@ -0,0 +1,25 @@
+/*
+ * include/asm-microblaze/sockios.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_SOCKIOS_H
+#define _ASM_MICROBLAZE_SOCKIOS_H
+
+#include <asm/ioctl.h>
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* _ASM_MICROBLAZE_SOCKIOS_H */
diff --git a/include/asm-microblaze/ucontext.h b/include/asm-microblaze/ucontext.h
new file mode 100644
index 0000000..7ece650
--- /dev/null
+++ b/include/asm-microblaze/ucontext.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/ucontext.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_UCONTEXT_H
+#define _ASM_MICROBLAZE_UCONTEXT_H
+
+#include <asm/sigcontext.h>
+
+struct ucontext {
+	unsigned long		uc_flags;
+	struct ucontext		*uc_link;
+	stack_t			uc_stack;
+	struct sigcontext	uc_mcontext;
+	sigset_t		uc_sigmask; /* mask last for extensibility */
+};
+
+#endif /* _ASM_MICROBLAZE_UCONTEXT_H */
-- 
1.5.4.GIT

