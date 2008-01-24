Return-Path: <linux-kernel-owner+w=401wt.eu-S1753044AbYAZP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044AbYAZP7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:59:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbYAZPy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:59 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754748AbYAZPy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:57 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 43/52] [microblaze] clinkage.h linkage.h sections.h kmap_types.h
Date: Thu, 24 Jan 2008 16:03:18 +0100
Message-Id: <14243bf49d44d1dbd6e377813f2635defcb82c4e.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <34f2199d631406fbdf6b325a164e0d1899a3acb5.1201107832.git.monstr@monstr.eu>
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
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/clinkage.h   |   29 +++++++++++++++++++++++++++++
 include/asm-microblaze/kmap_types.h |   31 +++++++++++++++++++++++++++++++
 include/asm-microblaze/linkage.h    |   17 +++++++++++++++++
 include/asm-microblaze/sections.h   |   19 +++++++++++++++++++
 4 files changed, 96 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/clinkage.h
 create mode 100644 include/asm-microblaze/kmap_types.h
 create mode 100644 include/asm-microblaze/linkage.h
 create mode 100644 include/asm-microblaze/sections.h

diff --git a/include/asm-microblaze/clinkage.h b/include/asm-microblaze/clinkage.h
new file mode 100644
index 0000000..697c6ac
--- /dev/null
+++ b/include/asm-microblaze/clinkage.h
@@ -0,0 +1,29 @@
+/*
+ * include/asm-microblaze/clinkage.h
+ *
+ * Macros to reflect C symbol-naming conventions
+ *
+ * Copyright (C) 2003 John Williams <jwilliams@itee.uq.edu.au>
+ * Copyright (C) 2001,2002 NEC Corporatione
+ * Copyright (C) 2001,2002 Miles Bader <miles@gnu.org>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ * Written by Miles Bader <miles@gnu.org>
+ * Microblaze port by John Williams
+ */
+
+#ifndef _MICROBLAZE_CLINKAGE_H
+#define _MICROBLAZE_CLINKAGE_H
+
+#define __ASSEMBLY__
+
+#include <linux/linkage.h>
+
+#define C_SYMBOL_NAME(name)	name
+#define C_ENTRY(name)		.globl name; .align 4; name
+#define C_END(name)
+
+#endif /* _MICROBLAZE_CLINKAGE_H */
diff --git a/include/asm-microblaze/kmap_types.h b/include/asm-microblaze/kmap_types.h
new file mode 100644
index 0000000..9258c0b
--- /dev/null
+++ b/include/asm-microblaze/kmap_types.h
@@ -0,0 +1,31 @@
+/*
+ * include/asm-microblaze/kmap_types.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_KMAP_TYPES_H
+#define _ASM_KMAP_TYPES_H
+
+enum km_type {
+	KM_BOUNCE_READ,
+	KM_SKB_SUNRPC_DATA,
+	KM_SKB_DATA_SOFTIRQ,
+	KM_USER0,
+	KM_USER1,
+	KM_BIO_SRC_IRQ,
+	KM_BIO_DST_IRQ,
+	KM_PTE0,
+	KM_PTE1,
+	KM_IRQ0,
+	KM_IRQ1,
+	KM_SOFTIRQ0,
+	KM_SOFTIRQ1,
+	KM_TYPE_NR,
+};
+
+#endif /* _ASM_KMAP_TYPES_H */
diff --git a/include/asm-microblaze/linkage.h b/include/asm-microblaze/linkage.h
new file mode 100644
index 0000000..c699956
--- /dev/null
+++ b/include/asm-microblaze/linkage.h
@@ -0,0 +1,17 @@
+/*
+ * include/asm-microblaze/linkage.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_LINKAGE_H
+#define _ASM_LINKAGE_H
+
+#define __ALIGN		.align 4
+#define __ALIGN_STR	".align 4"
+
+#endif /* _ASM_LINKAGE_H */
diff --git a/include/asm-microblaze/sections.h b/include/asm-microblaze/sections.h
new file mode 100644
index 0000000..43df5f6
--- /dev/null
+++ b/include/asm-microblaze/sections.h
@@ -0,0 +1,19 @@
+/*
+ * include/asm-microblaze/sections.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_SECTIONS_H
+#define _ASM_SECTIONS_H
+
+#include <asm-generic/sections.h>
+
+extern char _ssbss[], _esbss[];
+extern unsigned long __ivt_start[], __ivt_end[];
+
+#endif /* _ASM_SECTIONS_H */
-- 
1.5.4.rc4.14.g6fc74

