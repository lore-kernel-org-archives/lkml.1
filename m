Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYAZQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYAZQCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756478AbYAZPzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:55:44 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756313AbYAZPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:55:41 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 48/52] [microblaze] headers files entry.h current.h mman.h registers.h sembuf.h
Date: Thu, 24 Jan 2008 16:03:23 +0100
Message-Id: <807d570db44eeed03e3211b933a207f42cf569f0.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
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
 <b501d439bdfabddbdef5935db86b6f64c83d55c4.1201107832.git.monstr@monstr.eu>
 <43f77bd3045d72346eb39d3170de727050c835c1.1201107832.git.monstr@monstr.eu>
 <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
 <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
 <99bfbc3fdb53003c11414681b2c73561d533c3ef.1201107832.git.monstr@monstr.eu>
 <1b21abdff6128297a902060b07a0c7ca6d8db633.1201107832.git.monstr@monstr.eu>
 <e173c10560cdf883ba3c7e639ca930f0627a2260.1201107832.git.monstr@monstr.eu>
 <155ee14d990137f7eb6fa76beee06c880c97e790.1201107832.git.monstr@monstr.eu>
 <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
 <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
 <01e493efdc1c8cb7ee0d5f8b7c73244e04680e71.1201107832.git.monstr@monstr.eu>
 <739e189a03021d2804f23d0774637a15038098bc.1201107832.git.monstr@monstr.eu>
 <d4eec3db9f6e6e86994444b8035d5e41db3f085b.1201107832.git.monstr@monstr.eu>
 <e445f6b37baf09d6469a0ad4eba189a7ca7ef7c3.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/current.h   |   25 +++++++++++++++++++++++++
 include/asm-microblaze/entry.h     |   32 ++++++++++++++++++++++++++++++++
 include/asm-microblaze/mman.h      |   27 +++++++++++++++++++++++++++
 include/asm-microblaze/registers.h |   26 ++++++++++++++++++++++++++
 include/asm-microblaze/sembuf.h    |   36 ++++++++++++++++++++++++++++++++++++
 5 files changed, 146 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/current.h
 create mode 100644 include/asm-microblaze/entry.h
 create mode 100644 include/asm-microblaze/mman.h
 create mode 100644 include/asm-microblaze/registers.h
 create mode 100644 include/asm-microblaze/sembuf.h

diff --git a/include/asm-microblaze/current.h b/include/asm-microblaze/current.h
new file mode 100644
index 0000000..4ff2a0f
--- /dev/null
+++ b/include/asm-microblaze/current.h
@@ -0,0 +1,25 @@
+/*
+ * include/asm-microblaze/current.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_CURRENT_H
+#define _ASM_CURRENT_H
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Dedicate r31 to keeping the current task pointer
+ */
+register struct task_struct *current asm("r31");
+
+#define get_current() current
+
+#endif
+
+#endif /* _ASM_CURRENT_H */
diff --git a/include/asm-microblaze/entry.h b/include/asm-microblaze/entry.h
new file mode 100644
index 0000000..e298888
--- /dev/null
+++ b/include/asm-microblaze/entry.h
@@ -0,0 +1,32 @@
+/*
+ * include/asm-microblaze/entry.h
+ *
+ * Definitions used by low-level trap handlers
+ *
+ * Copyright (C) 2007 PetaLogix
+ * Copyright (C) 2007 John Williams <john.williams@petalogix.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _MICROBLAZE_ENTRY_H
+#define _MICROBLAZE_ENTRY_H
+
+
+#include <asm/percpu.h>
+#include <asm/ptrace.h>
+
+/* These are per-cpu variables required in entry.S, among other
+ places */
+
+DECLARE_PER_CPU(unsigned int, KSP); /* Saved kernel stack pointer */
+DECLARE_PER_CPU(unsigned int, KM); /* Kernel/user mode */
+DECLARE_PER_CPU(unsigned int, ENTRY_SP); /* Saved SP on kernel entry */
+DECLARE_PER_CPU(unsigned int, R11_SAVE); /* Temp variable for entry */
+DECLARE_PER_CPU(unsigned int, CURRENT_SAVE); /* Saved current pointer */
+DECLARE_PER_CPU(unsigned int, SYSCALL_SAVE); /* Saved syscall number */
+
+#endif /* _MICROBLAZE_ENTRY_H */
diff --git a/include/asm-microblaze/mman.h b/include/asm-microblaze/mman.h
new file mode 100644
index 0000000..7abf722
--- /dev/null
+++ b/include/asm-microblaze/mman.h
@@ -0,0 +1,27 @@
+/*
+ * include/asm-microblaze/mman.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MMAN_H
+#define _ASM_MMAN_H
+
+#include <asm-generic/mman.h>
+
+#define MAP_GROWSDOWN	0x0100 /* stack-like segment */
+#define MAP_DENYWRITE	0x0800 /* ETXTBSY */
+#define MAP_EXECUTABLE	0x1000 /* mark it as an executable */
+#define MAP_LOCKED	0x2000 /* pages are locked */
+#define MAP_NORESERVE	0x4000 /* don't check for reservations */
+#define MAP_POPULATE	0x8000 /* populate (prefault) pagetables */
+#define MAP_NONBLOCK	0x10000 /* do not block on IO */
+
+#define MCL_CURRENT	1 /* lock all current mappings */
+#define MCL_FUTURE	2 /* lock all future mappings */
+
+#endif /* _ASM_MMAN_H */
diff --git a/include/asm-microblaze/registers.h b/include/asm-microblaze/registers.h
new file mode 100644
index 0000000..98a27ae
--- /dev/null
+++ b/include/asm-microblaze/registers.h
@@ -0,0 +1,26 @@
+/*
+ * include/asm-microblaze/registers.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_REGISTERS_H
+#define _ASM_REGISTERS_H
+
+#define MSR_BE	(1<<0)
+#define MSR_IE	(1<<1)
+#define MSR_C	(1<<2)
+#define MSR_BIP	(1<<3)
+#define MSR_FSL	(1<<4)
+#define MSR_ICE	(1<<5)
+#define MSR_DZ	(1<<6)
+#define MSR_DCE	(1<<7)
+#define MSR_EE	(1<<8)
+#define MSR_EIP	(1<<9)
+#define MSR_CC	(1<<31)
+
+#endif /* _ASM_REGISTERS_H */
diff --git a/include/asm-microblaze/sembuf.h b/include/asm-microblaze/sembuf.h
new file mode 100644
index 0000000..8d82db8
--- /dev/null
+++ b/include/asm-microblaze/sembuf.h
@@ -0,0 +1,36 @@
+/*
+ * include/asm-microblaze/sembuf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SEMBUF_H
+#define _ASM_SEMBUF_H
+
+/*
+ * The semid64_ds structure for m68k architecture.
+ * Note extra padding because this structure is passed back and forth
+ * between kernel and user space.
+ *
+ * Pad space is left for:
+ * - 64-bit time_t to solve y2038 problem
+ * - 2 miscellaneous 32-bit values
+ */
+
+struct semid64_ds {
+	struct ipc64_perm sem_perm; /* permissions .. see ipc.h */
+	__kernel_time_t	sem_otime; /* last semop time */
+	unsigned long	__unused1;
+	__kernel_time_t	sem_ctime; /* last change time */
+	unsigned long	__unused2;
+	unsigned long	sem_nsems; /* no. of semaphores in array */
+	unsigned long	__unused3;
+	unsigned long	__unused4;
+};
+
+
+#endif /* _ASM_SEMBUF_H */
-- 
1.5.4.rc4.14.g6fc74

