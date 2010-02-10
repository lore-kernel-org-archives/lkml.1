Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab0BJBjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:39:48 -0500
Received: from sh.osrg.net ([192.16.179.4]:54828 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350Ab0BJBjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:39:37 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       David Howells <dhowells@redhat.com>
Subject: [PATCH v2 -mm 05/14] frv: use include/linux/pci-dma.h
Date: Wed, 10 Feb 2010 10:34:38 +0900
Message-Id: <1265765687-14121-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 10 Feb 2010 10:38:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/include/asm/pci.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/frv/include/asm/pci.h b/arch/frv/include/asm/pci.h
index 8c7260a..05db569 100644
--- a/arch/frv/include/asm/pci.h
+++ b/arch/frv/include/asm/pci.h
@@ -43,13 +43,7 @@ extern void pci_free_consistent(struct pci_dev *hwdev, size_t size,
 /* Return the index of the PCI controller for device PDEV. */
 #define pci_controller_num(PDEV)	(0)
 
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+#include <linux/pci-dma.h>
 
 #ifdef CONFIG_PCI
 static inline void pci_dma_burst_advice(struct pci_dev *pdev,
-- 
1.5.6.5

