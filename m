Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZKOK3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZKOK3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 05:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZKOK3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 05:29:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:46974 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZKOK3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 05:29:16 -0500
Date: Sun, 15 Nov 2009 10:28:21 GMT
From: tip-bot for FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1258199198-16657-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258199198-16657-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] swiotlb: Remove duplicate swiotlb_force extern declarations
Message-ID: <tip-6959450e567c1f17d3ce8489099fc56c3721d577@git.kernel.org>
Git-Commit-ID: 6959450e567c1f17d3ce8489099fc56c3721d577
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6959450e567c1f17d3ce8489099fc56c3721d577
Gitweb:     http://git.kernel.org/tip/6959450e567c1f17d3ce8489099fc56c3721d577
Author:     FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
AuthorDate: Sat, 14 Nov 2009 20:46:38 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 15 Nov 2009 09:03:10 +0100

swiotlb: Remove duplicate swiotlb_force extern declarations

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: tony.luck@intel.com
LKML-Reference: <1258199198-16657-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/include/asm/swiotlb.h |    2 --
 arch/x86/include/asm/swiotlb.h  |    4 ----
 include/linux/swiotlb.h         |    2 ++
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/ia64/include/asm/swiotlb.h b/arch/ia64/include/asm/swiotlb.h
index dcbaea7..f0acde6 100644
--- a/arch/ia64/include/asm/swiotlb.h
+++ b/arch/ia64/include/asm/swiotlb.h
@@ -4,8 +4,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/swiotlb.h>
 
-extern int swiotlb_force;
-
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
 extern void pci_swiotlb_init(void);
diff --git a/arch/x86/include/asm/swiotlb.h b/arch/x86/include/asm/swiotlb.h
index 940f13a..87ffcb1 100644
--- a/arch/x86/include/asm/swiotlb.h
+++ b/arch/x86/include/asm/swiotlb.h
@@ -3,10 +3,6 @@
 
 #include <linux/swiotlb.h>
 
-/* SWIOTLB interface */
-
-extern int swiotlb_force;
-
 #ifdef CONFIG_SWIOTLB
 extern int swiotlb;
 extern int pci_swiotlb_init(void);
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index eb9bdb4..febedcf 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -7,6 +7,8 @@ struct device;
 struct dma_attrs;
 struct scatterlist;
 
+extern int swiotlb_force;
+
 /*
  * Maximum allowable number of contiguous slabs to map,
  * must be a power of 2.  What is the appropriate value ?
