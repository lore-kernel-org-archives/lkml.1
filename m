Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYFZNkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYFZNkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764817AbYFZNkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 09:40:17 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:24215 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760564AbYFZNkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 09:40:14 -0400
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 38/60] microblaze_v4: headers for executables format FLAT, ELF
Date: Thu, 26 Jun 2008 14:30:07 +0200
Message-Id: <1214483429-32360-39-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-38-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
 <1214483429-32360-27-git-send-email-monstr@seznam.cz>
 <1214483429-32360-28-git-send-email-monstr@seznam.cz>
 <1214483429-32360-29-git-send-email-monstr@seznam.cz>
 <1214483429-32360-30-git-send-email-monstr@seznam.cz>
 <1214483429-32360-31-git-send-email-monstr@seznam.cz>
 <1214483429-32360-32-git-send-email-monstr@seznam.cz>
 <1214483429-32360-33-git-send-email-monstr@seznam.cz>
 <1214483429-32360-34-git-send-email-monstr@seznam.cz>
 <1214483429-32360-35-git-send-email-monstr@seznam.cz>
 <1214483429-32360-36-git-send-email-monstr@seznam.cz>
 <1214483429-32360-37-git-send-email-monstr@seznam.cz>
 <1214483429-32360-38-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/elf.h  |   22 ++++++++++
 include/asm-microblaze/flat.h |   90 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 112 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/elf.h
 create mode 100644 include/asm-microblaze/flat.h

diff --git a/include/asm-microblaze/elf.h b/include/asm-microblaze/elf.h
new file mode 100644
index 0000000..a9f2ecf
--- /dev/null
+++ b/include/asm-microblaze/elf.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_ELF_H
+#define _ASM_MICROBLAZE_ELF_H
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
+#endif /* _ASM_MICROBLAZE_ELF_H */
diff --git a/include/asm-microblaze/flat.h b/include/asm-microblaze/flat.h
new file mode 100644
index 0000000..acf0da5
--- /dev/null
+++ b/include/asm-microblaze/flat.h
@@ -0,0 +1,90 @@
+/*
+ * uClinux flat-format executables
+ *
+ * Copyright (C) 2005 John Williams <jwilliams@itee.uq.edu.au>
+ *
+ * This file is subject to the terms and conditions of the GNU General
+ * Public License. See the file COPYING in the main directory of this
+ * archive for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_FLAT_H
+#define _ASM_MICROBLAZE_FLAT_H
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
+#endif /* _ASM_MICROBLAZE_FLAT_H */
-- 
1.5.4.GIT

