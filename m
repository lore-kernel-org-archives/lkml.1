Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYEDPaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYEDPaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbYEDPaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:30:20 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:60291 "EHLO
	seznam.cz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750847AbYEDPaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:30:18 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 30/56] microblaze_v2: includes SHM*, msgbuf
Date: Sun,  4 May 2008 13:41:19 +0200
Message-Id: <c9418c683be99ae12abb89575c362d586c026bad.1209897266.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <09ce2baf0c8308d3fbca98e7eb36a6aab59112a7.1209897266.git.monstr@monstr.eu>
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
In-Reply-To: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
References: <a4a778e34c66d126f5c4bf1ca423cf32950ea5ab.1209897266.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/msgbuf.h   |   41 +++++++++++++++++++++++++++++
 include/asm-microblaze/shmbuf.h   |   52 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/shmparam.h |   16 +++++++++++
 3 files changed, 109 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/msgbuf.h
 create mode 100644 include/asm-microblaze/shmbuf.h
 create mode 100644 include/asm-microblaze/shmparam.h

diff --git a/include/asm-microblaze/msgbuf.h b/include/asm-microblaze/msgbuf.h
new file mode 100644
index 0000000..e2f93f4
--- /dev/null
+++ b/include/asm-microblaze/msgbuf.h
@@ -0,0 +1,41 @@
+/*
+ * include/asm-microblaze/msgbuf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_MSGBUF_H
+#define _ASM_MICROBLAZE_MSGBUF_H
+
+/*
+ * The msqid64_ds structure for m68k architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct msqid64_ds {
+	struct ipc64_perm msg_perm;
+	__kernel_time_t msg_stime; /* last msgsnd time */
+	unsigned long __unused1;
+	__kernel_time_t msg_rtime; /* last msgrcv time */
+	unsigned long __unused2;
+	__kernel_time_t msg_ctime; /* last change time */
+	unsigned long __unused3;
+	unsigned long msg_cbytes; /* current number of bytes on queue */
+	unsigned long msg_qnum; /* number of messages in queue */
+	unsigned long msg_qbytes; /* max number of bytes on queue */
+	__kernel_pid_t msg_lspid; /* pid of last msgsnd */
+	__kernel_pid_t msg_lrpid; /* last receive pid */
+	unsigned long __unused4;
+	unsigned long __unused5;
+};
+
+#endif /* _ASM_MICROBLAZE_MSGBUF_H */
diff --git a/include/asm-microblaze/shmbuf.h b/include/asm-microblaze/shmbuf.h
new file mode 100644
index 0000000..e3d759f
--- /dev/null
+++ b/include/asm-microblaze/shmbuf.h
@@ -0,0 +1,52 @@
+/*
+ * include/asm-microblaze/shmbuf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_SHMBUF_H
+#define _ASM_MICROBLAZE_SHMBUF_H
+
+/*
+ * The shmid64_ds structure for m68k architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct shmid64_ds {
+	struct ipc64_perm	shm_perm; /* operation perms */
+	size_t			shm_segsz; /* size of segment (bytes) */
+	__kernel_time_t		shm_atime; /* last attach time */
+	unsigned long		__unused1;
+	__kernel_time_t		shm_dtime; /* last detach time */
+	unsigned long		__unused2;
+	__kernel_time_t		shm_ctime; /* last change time */
+	unsigned long		__unused3;
+	__kernel_pid_t		shm_cpid; /* pid of creator */
+	__kernel_pid_t		shm_lpid; /* pid of last operator */
+	unsigned long		shm_nattch; /* no. of current attaches */
+	unsigned long		__unused4;
+	unsigned long		__unused5;
+};
+
+struct shminfo64 {
+	unsigned long	shmmax;
+	unsigned long	shmmin;
+	unsigned long	shmmni;
+	unsigned long	shmseg;
+	unsigned long	shmall;
+	unsigned long	__unused1;
+	unsigned long	__unused2;
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+#endif /* _ASM_MICROBLAZE_SHMBUF_H */
diff --git a/include/asm-microblaze/shmparam.h b/include/asm-microblaze/shmparam.h
new file mode 100644
index 0000000..38e9be0
--- /dev/null
+++ b/include/asm-microblaze/shmparam.h
@@ -0,0 +1,16 @@
+/*
+ * include/asm-microblaze/shmparam.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_SHMPARAM_H
+#define _ASM_MICROBLAZE_SHMPARAM_H
+
+#define SHMLBA	PAGE_SIZE /* attach addr a multiple of this */
+
+#endif /* _ASM_MICROBLAZE_SHMPARAM_H */
-- 
1.5.4.GIT

