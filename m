Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZKNLsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZKNLsQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 06:48:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755574AbZKNLsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 06:48:15 -0500
Received: from sh.osrg.net ([192.16.179.4]:52994 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZKNLsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:48:14 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, tony.luck@intel.com
Subject: [PATCH 3/3] remove duplicate extern declarations for swiotlb_force
Date: Sat, 14 Nov 2009 20:46:38 +0900
Message-Id: <1258199198-16657-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Nov 2009 20:48:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: tony.luck@intel.com
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
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
-- 
1.5.6.5

