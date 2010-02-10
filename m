Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0BJGLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 01:11:09 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:54212 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0BJGLI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 01:11:08 -0500
From: Mikael Starvik <mikael.starvik@axis.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Date: Wed, 10 Feb 2010 07:10:33 +0100
Subject: RE: [PATCH v2 -mm 13/14] cris: use include/linux/pci-dma.h
Thread-Topic: [PATCH v2 -mm 13/14] cris: use include/linux/pci-dma.h
Thread-Index: Acqp8xZzAqmtMZTOQEW3u19lHBnUdAAJI/kA
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D0546A9437CFB@xmail3.se.axis.com>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1265765687-14121-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1265765687-14121-14-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sure, that is ok.

Signed-off-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] 
Sent: den 10 februari 2010 02:35
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org; fujita.tomonori@lab.ntt.co.jp; Mikael Starvik
Subject: [PATCH v2 -mm 13/14] cris: use include/linux/pci-dma.h

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Mikael Starvik <starvik@axis.com>
---
 arch/cris/include/asm/pci.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/cris/include/asm/pci.h b/arch/cris/include/asm/pci.h
index 730ce40..43cfa0c 100644
--- a/arch/cris/include/asm/pci.h
+++ b/arch/cris/include/asm/pci.h
@@ -44,13 +44,7 @@ struct pci_dev;
  */
 #define PCI_DMA_BUS_IS_PHYS	(1)
 
-/* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+#include <linux/pci-dma.h>
 
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
-- 
1.5.6.5

