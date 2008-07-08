Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbYGHMow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbYGHMow (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbYGHMnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:43:47 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27533 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758707AbYGHMnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:43:46 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 31/58] microblaze_v5: includes SHM*, msgbuf
Date: Tue,  8 Jul 2008 13:59:31 +0200
Message-Id: <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
References: <1215518398-5057-1-git-send-email-monstr@monstr.eu>
 <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
 <c03d29cbccaef8aed8a2911c2a259fbd79ad23d9.1215517976.git.monstr@monstr.eu>
 <58f35f498bac29e7105c589c06567e86c5a42dd5.1215517976.git.monstr@monstr.eu>
 <810775b1bb678003923039726a9153ee34fb67b4.1215517976.git.monstr@monstr.eu>
 <2a24e5bc2cfbd349613ef10c716a28f04ce24a9f.1215517976.git.monstr@monstr.eu>
 <3171c5cf21eefc79665165f4a14bc5b68dd03f95.1215517976.git.monstr@monstr.eu>
 <9be4eff2f4d015023c453eaec3b3473a44380491.1215517976.git.monstr@monstr.eu>
 <f8e331ed9432719f3c0555c840cbbb7bbc1a6322.1215517976.git.monstr@monstr.eu>
 <4409daf2ac356e902a8f091bb5908eb8a90218bc.1215517976.git.monstr@monstr.eu>
 <f7458acb0252f72b5620d19c76104408ecc2e451.1215517976.git.monstr@monstr.eu>
 <dbd9df742cdd9eb3355d7bc8e39f9dfef6c545e4.1215517976.git.monstr@monstr.eu>
 <1f9a1f345caa749cb630cf85f95f217366395069.1215517976.git.monstr@monstr.eu>
 <fe3686f0f70d838b33642bcbcd7185fc2180b366.1215517976.git.monstr@monstr.eu>
 <e61f5a8579570cf7cd18a22e4106b7f85518928e.1215517976.git.monstr@monstr.eu>
 <59d7e0a5f38b8d38f01f357a071fc93eed36f3a8.1215517976.git.monstr@monstr.eu>
 <143afcf84af583ab66da7e8acfc9eb03b7f3eaa0.1215517976.git.monstr@monstr.eu>
 <a967ee4e5a60b410e2810ce0475e8fd04f99e3ae.1215517976.git.monstr@monstr.eu>
 <c5f0730287365c845746467a9917dbc07d2fca3c.1215517976.git.monstr@monstr.eu>
 <2aa1ac7891af57959237aae3addf4bbe607f55d7.1215517976.git.monstr@monstr.eu>
 <875ba2708f6cd3c585e4d965142e2feb07c39a0e.1215517976.git.monstr@monstr.eu>
 <eb0e741f891335df37c3cd19f1a3ce2f7ce8652a.1215517976.git.monstr@monstr.eu>
 <b28df2ea2419cbda26f9089ed6edcc175c009688.1215517976.git.monstr@monstr.eu>
 <5da1d8f069f18f14faee8c4bff736791179ef6f1.1215517976.git.monstr@monstr.eu>
 <9a32168fe72b772f301216a7090670474af78e49.1215517976.git.monstr@monstr.eu>
 <7ada4bceefc1806a2c8ef73676b7aabd8ac1cad6.1215517976.git.monstr@monstr.eu>
 <701c1dac442ac09f5010cb5356cc1a12bb0abfe1.1215517976.git.monstr@monstr.eu>
 <9b48e9d85b4a5a6dcffce8eef62b232b6bfac8e8.1215517976.git.monstr@monstr.eu>
 <04b0b222b84ba9cfe2507a9081f4d715f2323733.1215517976.git.monstr@monstr.eu>
 <d4c1b3ecfec1bf37ca0ecea6909ad25bbc945630.1215517976.git.monstr@monstr.eu>
 <6e5687d37386334cf122d1eafcca0c6649c955be.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/msgbuf.h   |   39 ++++++++++++++++++++++++++++
 include/asm-microblaze/shmbuf.h   |   50 +++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/shmparam.h |   14 ++++++++++
 3 files changed, 103 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/msgbuf.h
 create mode 100644 include/asm-microblaze/shmbuf.h
 create mode 100644 include/asm-microblaze/shmparam.h

diff --git a/include/asm-microblaze/msgbuf.h b/include/asm-microblaze/msgbuf.h
new file mode 100644
index 0000000..8172bc9
--- /dev/null
+++ b/include/asm-microblaze/msgbuf.h
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_MSGBUF_H
+#define _ASM_MICROBLAZE_MSGBUF_H
+
+/*
+ * The msqid64_ds structure for microblaze architecture.
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
index 0000000..a460e36
--- /dev/null
+++ b/include/asm-microblaze/shmbuf.h
@@ -0,0 +1,50 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_SHMBUF_H
+#define _ASM_MICROBLAZE_SHMBUF_H
+
+/*
+ * The shmid64_ds structure for microblaze architecture.
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
index 0000000..719bbed
--- /dev/null
+++ b/include/asm-microblaze/shmparam.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
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

