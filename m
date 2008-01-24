Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYAZP6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYAZP6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYAZPym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:42 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755307AbYAZPyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:40 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 37/52] [microblaze] headers for executables format FLAT, ELF
Date: Thu, 24 Jan 2008 16:03:12 +0100
Message-Id: <29ee870c02ea5d4c409644d7f0eb09cfbb1ec816.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <c09d54c49393bedbe4ca43df0e35cefa5fcc649c.1201107832.git.monstr@monstr.eu>
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
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/elf.h  |   24 +++++++++++
 include/asm-microblaze/flat.h |   93 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 117 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/elf.h
 create mode 100644 include/asm-microblaze/flat.h

diff --git a/include/asm-microblaze/elf.h b/include/asm-microblaze/elf.h
new file mode 100644
index 0000000..8b95630
--- /dev/null
+++ b/include/asm-microblaze/elf.h
@@ -0,0 +1,24 @@
+/*
+ * include/asm-microblaze/elf.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_ELF_H
+#define _ASM_ELF_H
+
+#define EM_XILINX_MICROBLAZE 0xbaab
+#define ELF_ARCH	EM_XILINX_MICROBLAZE
+
+#define elf_check_arch(x) ((x)->e_machine == EM_XILINX_MICROBLAZE)
+
+/*
+ * These are used to set parameters in the core dumps.
+ */
+#define ELF_CLASS	ELFCLASS32
+
+#endif /* _ASM_ELF_H */
diff --git a/include/asm-microblaze/flat.h b/include/asm-microblaze/flat.h
new file mode 100644
index 0000000..1f50a97
--- /dev/null
+++ b/include/asm-microblaze/flat.h
@@ -0,0 +1,93 @@
+/*
+ * include/asm-microblaze/flat.h
+ *
+ * uClinux flat-format executables
+ *
+ * Copyright (C) 2005 John Williams <jwilliams@itee.uq.edu.au>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ *
+ */
+
+#ifndef _MICROBLAZE_FLAT_H
+#define _MICROBLAZE_FLAT_H
+
+#include <asm/unaligned.h>
+
+#define	flat_stack_align(sp) /* nothing needed */
+#define	flat_argvp_envp_on_stack()	0
+#define	flat_old_ram_flag(flags)	(flags)
+#define	flat_reloc_valid(reloc, size)	((reloc) <= (size))
+#define	flat_set_persistent(relval, p)		0
+
+/*
+ * Microblaze works a little differently from other arches, because
+ * of the MICROBLAZE_64 reloc type. Here, a 32 bit address is split
+ * over two instructions, an 'imm' instruction which provides the top
+ * 16 bits, then the instruction "proper" which provides the low 16
+ * bits.
+ */
+
+/*
+ * Crack open a symbol reference and extract the address to be
+ * relocated. rp is a potentially unaligned pointer to the
+ * reference
+ */
+
+static inline unsigned long
+flat_get_addr_from_rp(unsigned long *rp, unsigned long relval,
+			unsigned long flags, unsigned long *persistent)
+{
+	unsigned long addr;
+	(void)flags;
+
+	/* Is it a split 64/32 reference? */
+	if (relval & 0x80000000) {
+		/* Grab the two halves of the reference */
+		unsigned long val_hi, val_lo;
+
+		val_hi = get_unaligned(rp);
+		val_lo = get_unaligned(rp+1);
+
+		/* Crack the address out */
+		addr = ((val_hi & 0xffff) << 16) + (val_lo & 0xffff);
+	} else {
+		/* Get the address straight out */
+		addr = get_unaligned(rp);
+	}
+
+	return addr;
+}
+
+/*
+ * Insert an address into the symbol reference at rp. rp is potentially
+ * unaligned.
+ */
+
+static inline void
+flat_put_addr_at_rp(unsigned long *rp, unsigned long addr, unsigned long relval)
+{
+	/* Is this a split 64/32 reloc? */
+	if (relval & 0x80000000) {
+		/* Get the two "halves" */
+		unsigned long val_hi = get_unaligned(rp);
+		unsigned long val_lo = get_unaligned(rp + 1);
+
+		/* insert the address */
+		val_hi = (val_hi & 0xffff0000) | addr >> 16;
+		val_lo = (val_lo & 0xffff0000) | (addr & 0xffff);
+
+		/* store the two halves back into memory */
+		put_unaligned(val_hi, rp);
+		put_unaligned(val_lo, rp+1);
+	} else {
+		/* Put it straight in, no messing around */
+		put_unaligned(addr, rp);
+	}
+}
+
+#define	flat_get_relocate_addr(rel)	(rel & 0x7fffffff)
+
+#endif /* _MICROBLAZE_FLAT_H */
-- 
1.5.4.rc4.14.g6fc74

