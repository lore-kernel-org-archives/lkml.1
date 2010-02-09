Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0BIOIp (ORCPT <rfc822;list-kernel77@spinics.net>);
	Tue, 9 Feb 2010 09:08:45 -0500
Received: from sh.osrg.net ([192.16.179.4]:36560 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab0BIOIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:08:42 -0500
From: e@lab.ntt.co.jp
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
        David Howells <dhowells@redhat.com>
Subject: [PATCH -mm 05/12] frv: use asm-generic/pci-dma-common.h
Date: Tue,  9 Feb 2010 22:35:17 +0900
Message-Id: <1265722524-9493-6-git-send-email-e>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265722524-9493-1-git-send-email-e>
References: <1265722524-9493-1-git-send-email-e>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Feb 2010 23:07:47 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/pci.h |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
index 8c7260a..030a190 100644
--- a/arch/frv/include/asm/pci.h
+++ b/arch/frv/include/asm/pci.h
@@ -44,12 +44,7 @@ extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
 #define pci_controller_num(PDEV)	(0)
 
 /* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+#include <asm-generic/pci-dma-common.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-- 
1.5.6.5

