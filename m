Return-Path: <linux-kernel-owner+w=401wt.eu-S1031294AbXEKTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031294AbXEKTw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763398AbXEKToT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:19 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:46651 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763180AbXEKToP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:15 -0400
Message-ID: <4644C78B.7030407@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:44:11 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, chris@zankel.net,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/xtensa/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/xtensa/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/xtensa/kernel/pci.c           |    2 +-
 arch/xtensa/mm/init.c              |    2 +-
 arch/xtensa/platform-iss/network.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/kernel/pci.c b/arch/xtensa/kernel/pci.c
index 45571cc..77deae5 100644
--- a/arch/xtensa/kernel/pci.c
+++ b/arch/xtensa/kernel/pci.c
@@ -401,7 +401,7 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
  * Also, think for a moment about likes of floppy.c that
  * include architecture specific parts. They may want to redefine ins/outs.
  *
- * We do not use horroble macroses here because we want to
+ * We do not use horrible macros here because we want to
  * advance pointer by sizeof(size).
  */
 void outsb(unsigned long addr, const void *src, unsigned long count) {
diff --git a/arch/xtensa/mm/init.c b/arch/xtensa/mm/init.c
index e1ec2d1..8415c76 100644
--- a/arch/xtensa/mm/init.c
+++ b/arch/xtensa/mm/init.c
@@ -205,7 +205,7 @@ void __init init_mmu (void)
 	/* Writing zeros to the <t>TLBCFG special registers ensure
 	 * that valid values exist in the register.  For existing
 	 * PGSZID<w> fields, zero selects the first element of the
-	 * page-size array.  For nonexistant PGSZID<w> fields, zero is
+	 * page-size array.  For nonexistent PGSZID<w> fields, zero is
 	 * the best value to write.  Also, when changing PGSZID<w>
 	 * fields, the corresponding TLB must be flushed.
 	 */
diff --git a/arch/xtensa/platform-iss/network.c b/arch/xtensa/platform-iss/network.c
index 4bfe333..f09962f 100644
--- a/arch/xtensa/platform-iss/network.c
+++ b/arch/xtensa/platform-iss/network.c
@@ -473,7 +473,7 @@ static int iss_net_open(struct net_device *dev)
 	netif_start_queue(dev);
 
 	/* clear buffer - it can happen that the host side of the interface
-	 * is full when we gethere. In this case, new data is never queued,
+	 * is full when we get here. In this case, new data is never queued,
 	 * SIGIOs never arrive, and the net never works.
 	 */
 	while ((err = iss_net_rx(dev)) > 0)
-- 
1.5.0.1

-- 
Simon Arlott
