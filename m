Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0BIOI1 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:08:27 -0500
Received: from sh.osrg.net ([192.16.179.4]:36547 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754546Ab0BIOIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:22 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH -mm 12/12] xtensa: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:24 +0900
Message-Id: <1265722524-9493-13-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/include/asm/pci.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/xtensa/include/asm/pci.h b/arch/xtensa/include/asm/pci.h
index 66410ac..32828f8 100644
--- a/arch/xtensa/include/asm/pci.h
+++ b/arch/xtensa/include/asm/pci.h
@@ -57,12 +57,7 @@ struct pci_dev;
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
 /* pci_unmap_{page,single} is a no-op, so */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_ubnmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+#include <asm-generic/pci-dma-common.h>
 
 /* Map a range of PCI memory or I/O space for a device into user space */
 int pci_mmap_page_range(struct pci_dev *pdev, struct vm_area_struct *vma,
-- 
1.5.6.5

