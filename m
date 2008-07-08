Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYGHMnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYGHMnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 08:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbYGHMnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 08:43:13 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:27528 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753971AbYGHMnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 08:43:11 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: monstr@seznam.cz, arnd@arndb.de, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, vapier.adi@gmail.com,
       alan@lxorguk.ukuu.org.uk, hpa@zytor.com, lethal@linux-sh.org,
       florian@openwrt.org, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 40/58] microblaze_v5: headers pgalloc.h pgtable.h
Date: Tue,  8 Jul 2008 13:59:40 +0200
Message-Id: <5174afd0eaa5c6cb9344ea3217199e48899be313.1215517976.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
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
 <689cff1b6d98f60d8f8abc4472193688b524284d.1215517976.git.monstr@monstr.eu>
 <9664f18e7e86af4332018549b29bf0797d6afcd5.1215517976.git.monstr@monstr.eu>
 <c7120d8a6379cb1a18af5330997e30ec974acc2f.1215517976.git.monstr@monstr.eu>
 <d1d33c18956829ec9ac7daf8d0516b17e85ed190.1215517976.git.monstr@monstr.eu>
 <7a16429cfc461420883dbaa80c16047e5a1a91c1.1215517976.git.monstr@monstr.eu>
 <b6a0f3bceb0867c55613463fc43be5328fcedecd.1215517976.git.monstr@monstr.eu>
 <fc26823d77c7180b62022e2d4bcca3c4fe6de574.1215517976.git.monstr@monstr.eu>
 <64089967061955b7a29eb6d4e6269ff75b5442f2.1215517976.git.monstr@monstr.eu>
 <92e3ab88c2174acf4e25c474c1f68ffd4db72ca6.1215517976.git.monstr@monstr.eu>
In-Reply-To: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
References: <80a2e46f2fb93812ab12bf79c703e8e2d6b0faa0.1215517976.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Acked-by: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/pgalloc.h |   14 +++++++++++
 include/asm-microblaze/pgtable.h |   48 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/pgalloc.h
 create mode 100644 include/asm-microblaze/pgtable.h

diff --git a/include/asm-microblaze/pgalloc.h b/include/asm-microblaze/pgalloc.h
new file mode 100644
index 0000000..2a4b354
--- /dev/null
+++ b/include/asm-microblaze/pgalloc.h
@@ -0,0 +1,14 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PGALLOC_H
+#define _ASM_MICROBLAZE_PGALLOC_H
+
+#define check_pgt_cache()	do {} while (0)
+
+#endif /* _ASM_MICROBLAZE_PGALLOC_H */
diff --git a/include/asm-microblaze/pgtable.h b/include/asm-microblaze/pgtable.h
new file mode 100644
index 0000000..0354908
--- /dev/null
+++ b/include/asm-microblaze/pgtable.h
@@ -0,0 +1,48 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_PGTABLE_H
+#define _ASM_MICROBLAZE_PGTABLE_H
+
+#define pgd_present(pgd)	(1) /* pages are always present on NO_MM */
+#define pgd_none(pgd)		(0)
+#define pgd_bad(pgd)		(0)
+#define pgd_clear(pgdp)
+#define kern_addr_valid(addr)	(1)
+#define	pmd_offset(a, b)	((void *) 0)
+
+#define PAGE_NONE		__pgprot(0) /* these mean nothing to NO_MM */
+#define PAGE_SHARED		__pgprot(0) /* these mean nothing to NO_MM */
+#define PAGE_COPY		__pgprot(0) /* these mean nothing to NO_MM */
+#define PAGE_READONLY		__pgprot(0) /* these mean nothing to NO_MM */
+#define PAGE_KERNEL		__pgprot(0) /* these mean nothing to NO_MM */
+
+#define __swp_type(x)		(0)
+#define __swp_offset(x)		(0)
+#define __swp_entry(typ, off)	((swp_entry_t) { ((typ) | ((off) << 7)) })
+#define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
+#define __swp_entry_to_pte(x)	((pte_t) { (x).val })
+
+#ifndef __ASSEMBLY__
+static inline int pte_file(pte_t pte) { return 0; }
+#endif
+
+#define ZERO_PAGE(vaddr)	({ BUG(); NULL; })
+
+#define swapper_pg_dir ((pgd_t *) NULL)
+
+#define pgtable_cache_init()	do {} while (0)
+
+#define io_remap_pfn_range(vma, vaddr, pfn, size, prot)		\
+		remap_pfn_range(vma, vaddr, pfn, size, prot)
+
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+
+void paging_init(void);
+
+#endif /* _ASM_MICROBLAZE_PGTABLE_H */
-- 
1.5.4.GIT

