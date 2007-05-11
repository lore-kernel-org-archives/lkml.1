Return-Path: <linux-kernel-owner+w=401wt.eu-S966053AbXEKTvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966053AbXEKTvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763517AbXEKToB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:44:01 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45990 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763501AbXEKToA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:44:00 -0400
Message-ID: <4644C77B.9030006@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:43:55 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/v850/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/v850/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/v850/kernel/me2.c          |    4 ++--
 arch/v850/kernel/rte_mb_a_pci.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/v850/kernel/me2.c b/arch/v850/kernel/me2.c
index 38be5c1..007115d 100644
--- a/arch/v850/kernel/me2.c
+++ b/arch/v850/kernel/me2.c
@@ -58,13 +58,13 @@ void __init me2_init_irqs (void)
 void me2_uart_pre_configure (unsigned chan, unsigned cflags, unsigned baud)
 {
 	if (chan == 0) {
-		/* Specify that the relevent pins on the chip should do
+		/* Specify that the relevant pins on the chip should do
 		   serial I/O, not direct I/O.  */
 		ME2_PORT1_PMC |= 0xC;
 		/* Specify that we're using the UART, not the CSI device. */
 		ME2_PORT1_PFC |= 0xC;
 	} else if (chan == 1) {
-		/* Specify that the relevent pins on the chip should do
+		/* Specify that the relevant pins on the chip should do
 		   serial I/O, not direct I/O.  */
 		ME2_PORT2_PMC |= 0x6;
 		/* Specify that we're using the UART, not the CSI device. */
diff --git a/arch/v850/kernel/rte_mb_a_pci.c b/arch/v850/kernel/rte_mb_a_pci.c
index 35a4bd5..7165478 100644
--- a/arch/v850/kernel/rte_mb_a_pci.c
+++ b/arch/v850/kernel/rte_mb_a_pci.c
@@ -179,7 +179,7 @@ static int __devinit pcibios_init (void)
 		   default uses.  */
 
 		/* Significant address bits used for decoding PCI GCS5 space
-		   accessess.  */
+		   accesses.  */
 		MB_A_PCI_DMRR = ~(MB_A_PCI_MEM_SIZE - 1);
 
 		/* I don't understand this, but the SolutionGear example code
@@ -775,7 +775,7 @@ pci_alloc_consistent (struct pci_dev *pdev, size_t size, dma_addr_t *dma_addr)
 /* Free and unmap a consistent DMA buffer.  CPU_ADDR and DMA_ADDR must
    be values that were returned from pci_alloc_consistent.  SIZE must be
    the same as what as passed into pci_alloc_consistent.  References to
-   the memory and mappings assosciated with CPU_ADDR or DMA_ADDR past
+   the memory and mappings associated with CPU_ADDR or DMA_ADDR past
    this call are illegal.  */
 void
 pci_free_consistent (struct pci_dev *pdev, size_t size, void *cpu_addr,
-- 
1.5.0.1

-- 
Simon Arlott
