Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbXEKTsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbXEKTsu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933640AbXEKTnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:19 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45976 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673AbXEKTnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:16 -0400
Message-ID: <4644C750.2030300@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:43:12 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/sh/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/sh/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/sh/boards/landisk/gio.c             |    2 +-
 arch/sh/boards/snapgear/rtc.c            |    2 +-
 arch/sh/boards/superh/microdev/io.c      |    6 +++---
 arch/sh/boards/superh/microdev/irq.c     |    6 +++---
 arch/sh/boards/superh/microdev/setup.c   |    2 +-
 arch/sh/boards/unknown/setup.c           |    2 +-
 arch/sh/drivers/dma/dma-api.c            |    2 +-
 arch/sh/drivers/dma/dma-isa.c            |    2 +-
 arch/sh/drivers/dma/dmabrg.c             |    2 +-
 arch/sh/drivers/pci/ops-dreamcast.c      |    2 +-
 arch/sh/drivers/pci/pci-st40.c           |    6 +++---
 arch/sh/drivers/pci/pci-st40.h           |    2 +-
 arch/sh/drivers/superhyway/ops-sh4-202.c |    2 +-
 arch/sh/kernel/cf-enabler.c              |    2 +-
 arch/sh/kernel/cpu/irq/maskreg.c         |    2 +-
 arch/sh/kernel/cpu/sh4/fpu.c             |    2 +-
 arch/sh/kernel/kgdb_stub.c               |    4 ++--
 arch/sh/kernel/traps.c                   |    2 +-
 arch/sh/math-emu/math.c                  |    2 +-
 arch/sh/mm/init.c                        |    2 +-
 20 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/sh/boards/landisk/gio.c b/arch/sh/boards/landisk/gio.c
index 50d38be..a37643d 100644
--- a/arch/sh/boards/landisk/gio.c
+++ b/arch/sh/boards/landisk/gio.c
@@ -69,7 +69,7 @@ static int gio_ioctl(struct inode *inode, struct file *filp,
 	}
 
 	switch (cmd) {
-	case GIODRV_IOCSGIOSETADDR:	/* addres set */
+	case GIODRV_IOCSGIOSETADDR:	/* address set */
 		addr = data;
 		break;
 
diff --git a/arch/sh/boards/snapgear/rtc.c b/arch/sh/boards/snapgear/rtc.c
index 1659fdd..edb3dd9 100644
--- a/arch/sh/boards/snapgear/rtc.c
+++ b/arch/sh/boards/snapgear/rtc.c
@@ -108,7 +108,7 @@ static void ds1302_writebyte(unsigned int addr, unsigned int val)
 static void ds1302_reset(void)
 {
 	unsigned long	flags;
-	/* Hardware dependant reset/init */
+	/* Hardware dependent reset/init */
 	local_irq_save(flags);
 	set_dirp(get_dirp() | RTC_RESET | RTC_IODATA | RTC_SCLK);
 	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
diff --git a/arch/sh/boards/superh/microdev/io.c b/arch/sh/boards/superh/microdev/io.c
index 83419bf..b704e20 100644
--- a/arch/sh/boards/superh/microdev/io.c
+++ b/arch/sh/boards/superh/microdev/io.c
@@ -198,12 +198,12 @@ void microdev_outb(unsigned char b, unsigned long port)
 	/*
 	 *	There is a board feature with the current SH4-202 MicroDev in
 	 *	that the 2 byte enables (nBE0 and nBE1) are tied together (and
-	 *	to the Chip Select Line (Ethernet_CS)). Due to this conectivity,
+	 *	to the Chip Select Line (Ethernet_CS)). Due to this connectivity,
 	 *	it is not possible to safely perform 8-bit writes to the
 	 *	Ethernet registers, as 16-bits will be consumed from the Data
 	 *	lines (corrupting the other byte).  Hence, this function is
-	 *	written to impliment 16-bit read/modify/write for all byte-wide
-	 *	acceses.
+	 *	written to implement 16-bit read/modify/write for all byte-wide
+	 *	accesses.
 	 *
 	 *	Note: there is no problem with byte READS (even or odd).
 	 *
diff --git a/arch/sh/boards/superh/microdev/irq.c b/arch/sh/boards/superh/microdev/irq.c
index 8c64baa..cc1cb04 100644
--- a/arch/sh/boards/superh/microdev/irq.c
+++ b/arch/sh/boards/superh/microdev/irq.c
@@ -100,7 +100,7 @@ static void disable_microdev_irq(unsigned int irq)
 
 	fpgaIrq = fpgaIrqTable[irq].fpgaIrq;
 
-	/* disable interupts on the FPGA INTC register */
+	/* disable interrupts on the FPGA INTC register */
 	ctrl_outl(MICRODEV_FPGA_INTC_MASK(fpgaIrq), MICRODEV_FPGA_INTDSB_REG);
 }
 
@@ -125,7 +125,7 @@ static void enable_microdev_irq(unsigned int irq)
 	priorities |= MICRODEV_FPGA_INTPRI_LEVEL(fpgaIrq, pri);
 	ctrl_outl(priorities, priorityReg);
 
-	/* enable interupts on the FPGA INTC register */
+	/* enable interrupts on the FPGA INTC register */
 	ctrl_outl(MICRODEV_FPGA_INTC_MASK(fpgaIrq), MICRODEV_FPGA_INTENB_REG);
 }
 
@@ -152,7 +152,7 @@ extern void __init init_microdev_irq(void)
 {
 	int i;
 
-		/* disable interupts on the FPGA INTC register */
+		/* disable interrupts on the FPGA INTC register */
 	ctrl_outl(~0ul, MICRODEV_FPGA_INTDSB_REG);
 
 	for (i = 0; i < NUM_EXTERNAL_IRQS; i++)
diff --git a/arch/sh/boards/superh/microdev/setup.c b/arch/sh/boards/superh/microdev/setup.c
index 031c814..6396cea 100644
--- a/arch/sh/boards/superh/microdev/setup.c
+++ b/arch/sh/boards/superh/microdev/setup.c
@@ -349,7 +349,7 @@ static int __init smsc_superio_setup(void)
 	SMSC_WRITE_INDEXED(0x00, 0xc7);	/* GP47 = nIOWOP */
 	SMSC_WRITE_INDEXED(0x08, 0xe8);	/* GP20 = nIDE2_OE */
 
-		/* Exit the configuraton state */
+		/* Exit the configuration state */
 	outb(SMSC_EXIT_CONFIG_KEY, SMSC_CONFIG_PORT_ADDR);
 
 	return 0;
diff --git a/arch/sh/boards/unknown/setup.c b/arch/sh/boards/unknown/setup.c
index 1c94137..bee4612 100644
--- a/arch/sh/boards/unknown/setup.c
+++ b/arch/sh/boards/unknown/setup.c
@@ -6,7 +6,7 @@
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
  *
- * Setup code for an unknown machine (internal peripherials only)
+ * Setup code for an unknown machine (internal peripherals only)
  *
  * This is the simplest of all boards, and serves only as a quick and dirty
  * method to start debugging a new board during bring-up until proper board
diff --git a/arch/sh/drivers/dma/dma-api.c b/arch/sh/drivers/dma/dma-api.c
index e062067..8057a27 100644
--- a/arch/sh/drivers/dma/dma-api.c
+++ b/arch/sh/drivers/dma/dma-api.c
@@ -115,7 +115,7 @@ static int search_cap(const char **haystack, const char *needle)
 /**
  * request_dma_bycap - Allocate a DMA channel based on its capabilities
  * @dmac: List of DMA controllers to search
- * @caps: List of capabilites
+ * @caps: List of capabilities
  *
  * Search all channels of all DMA controllers to find a channel which
  * matches the requested capabilities. The result is the channel
diff --git a/arch/sh/drivers/dma/dma-isa.c b/arch/sh/drivers/dma/dma-isa.c
index 05a74ff..5fb044b 100644
--- a/arch/sh/drivers/dma/dma-isa.c
+++ b/arch/sh/drivers/dma/dma-isa.c
@@ -28,7 +28,7 @@
  * NOTE: ops->xfer() is the preferred way of doing things. However, there
  * are some users of the ISA DMA API that exist in common code that we
  * don't necessarily want to go out of our way to break, so we still
- * allow for some compatability at that level. Any new code is strongly
+ * allow for some compatibility at that level. Any new code is strongly
  * advised to run far away from the ISA DMA API and use the SH DMA API
  * directly.
  */
diff --git a/arch/sh/drivers/dma/dmabrg.c b/arch/sh/drivers/dma/dmabrg.c
index 9d0a293..5e22689 100644
--- a/arch/sh/drivers/dma/dmabrg.c
+++ b/arch/sh/drivers/dma/dmabrg.c
@@ -33,7 +33,7 @@
  *     9      | HAC1/SSI1 | rec | half done    | DMABRGI2
  *
  * all can be enabled/disabled in the DMABRGCR register,
- * as well as checked if they occured.
+ * as well as checked if they occurred.
  *
  * DMABRGI0 services  USB  DMA  Address  errors,  but it still must be
  * enabled/acked in the DMABRGCR register.  USB-DMA complete indicator
diff --git a/arch/sh/drivers/pci/ops-dreamcast.c b/arch/sh/drivers/pci/ops-dreamcast.c
index 381306c..e1284fc 100644
--- a/arch/sh/drivers/pci/ops-dreamcast.c
+++ b/arch/sh/drivers/pci/ops-dreamcast.c
@@ -57,7 +57,7 @@ struct pci_channel board_pci_channels[] = {
  *
  * Also, we could very easily support both Type 0 and Type 1 configurations
  * here, but since it doesn't seem that there is any such implementation in
- * existance, we don't bother.
+ * existence, we don't bother.
  *
  * I suppose if someone actually gets around to ripping the chip out of
  * the BBA and hanging some more devices off of it, then this might be
diff --git a/arch/sh/drivers/pci/pci-st40.c b/arch/sh/drivers/pci/pci-st40.c
index d67656a..543417f 100644
--- a/arch/sh/drivers/pci/pci-st40.c
+++ b/arch/sh/drivers/pci/pci-st40.c
@@ -292,7 +292,7 @@ int __init st40pci_init(unsigned memStart, unsigned memSize)
 			    PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER |
 			    PCI_COMMAND_IO);
 
-	/* Accesse to the 0xb0000000 -> 0xb6000000 area will go through to 0x10000000 -> 0x16000000
+	/* Access to the 0xb0000000 -> 0xb6000000 area will go through to 0x10000000 -> 0x16000000
 	 * on the PCI bus. This allows a nice 1-1 bus to phys mapping.
 	 */
 
@@ -315,7 +315,7 @@ int __init st40pci_init(unsigned memStart, unsigned memSize)
 	ST40PCI_WRITE(CSR_MBAR0, 0);
 	ST40PCI_WRITE(LSR0, 0x0fff0001);
 
-	/* ... and set up the initial incomming window to expose all of RAM */
+	/* ... and set up the initial incoming window to expose all of RAM */
 	pci_set_rbar_region(7, memStart, memStart, memSize);
 
 	/* Maximise timeout values */
@@ -473,7 +473,7 @@ static void pci_set_rbar_region(unsigned int region,     unsigned long localAddr
 
 	mask = r2p2(regionSize) - 0x10000;
 
-	/* Diable the region (in case currently in use, should never happen) */
+	/* Disable the region (in case currently in use, should never happen) */
 	ST40PCI_WRITE_INDEXED(RSR, region, 0);
 
 	/* Start of local address space to publish */
diff --git a/arch/sh/drivers/pci/pci-st40.h b/arch/sh/drivers/pci/pci-st40.h
index d729e0c..cf0d35b 100644
--- a/arch/sh/drivers/pci/pci-st40.h
+++ b/arch/sh/drivers/pci/pci-st40.h
@@ -4,7 +4,7 @@
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.                            
  *
- * Defintions for the ST40 PCI hardware.
+ * Definitions for the ST40 PCI hardware.
  */
 
 #ifndef __PCI_ST40_H__
diff --git a/arch/sh/drivers/superhyway/ops-sh4-202.c b/arch/sh/drivers/superhyway/ops-sh4-202.c
index a55c98a..3b14bf8 100644
--- a/arch/sh/drivers/superhyway/ops-sh4-202.c
+++ b/arch/sh/drivers/superhyway/ops-sh4-202.c
@@ -130,7 +130,7 @@ static int sh4202_read_vcr(unsigned long base, struct superhyway_vcr_info *vcr)
 	 * Some modules (PBR and ePBR for instance) also appear to have
 	 * VCRL/VCRH flipped in the documentation, but on the SH4-202
 	 * itself it appears that these are all consistently mapped with
-	 * VCRH preceeding VCRL.
+	 * VCRH preceding VCRL.
 	 *
 	 * Do not trust the documentation, for it is evil.
 	 */
diff --git a/arch/sh/kernel/cf-enabler.c b/arch/sh/kernel/cf-enabler.c
index 0758d48..849a9e1 100644
--- a/arch/sh/kernel/cf-enabler.c
+++ b/arch/sh/kernel/cf-enabler.c
@@ -31,7 +31,7 @@
  */
 #if defined(CONFIG_CPU_SH4)
 /* SH4 can't access PCMCIA interface through P2 area.
- * we must remap it with appropreate attribute bit of the page set.
+ * we must remap it with appropriate attribute bit of the page set.
  * this part is based on Greg Banks' hd64465_ss.c implementation - Masahiro Abe */
 
 #if defined(CONFIG_CF_AREA6)
diff --git a/arch/sh/kernel/cpu/irq/maskreg.c b/arch/sh/kernel/cpu/irq/maskreg.c
index 492db31..978992e 100644
--- a/arch/sh/kernel/cpu/irq/maskreg.c
+++ b/arch/sh/kernel/cpu/irq/maskreg.c
@@ -38,7 +38,7 @@ static struct hw_interrupt_type maskreg_irq_type = {
 	.end = end_maskreg_irq
 };
 
-/* actual implementatin */
+/* actual implementation */
 static unsigned int startup_maskreg_irq(unsigned int irq)
 {
 	enable_maskreg_irq(irq);
diff --git a/arch/sh/kernel/cpu/sh4/fpu.c b/arch/sh/kernel/cpu/sh4/fpu.c
index d61dd59..c5a4fc7 100644
--- a/arch/sh/kernel/cpu/sh4/fpu.c
+++ b/arch/sh/kernel/cpu/sh4/fpu.c
@@ -138,7 +138,7 @@ restore_fpu(struct task_struct *tsk)
 /*
  * Load the FPU with signalling NANS.  This bit pattern we're using
  * has the property that no matter wether considered as single or as
- * double precission represents signaling NANS.  
+ * double precision represents signaling NANS.  
  */
 
 static void
diff --git a/arch/sh/kernel/kgdb_stub.c b/arch/sh/kernel/kgdb_stub.c
index a532336..edd1ec2 100644
--- a/arch/sh/kernel/kgdb_stub.c
+++ b/arch/sh/kernel/kgdb_stub.c
@@ -2,7 +2,7 @@
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
  *
- * Containes extracts from code by Glenn Engel, Jim Kingdon,
+ * Contains extracts from code by Glenn Engel, Jim Kingdon,
  * David Grothe <dave@gcom.com>, Tigran Aivazian <tigran@sco.com>,
  * Amit S. Kale <akale@veritas.com>,  William Gatliff <bgat@open-widgets.com>,
  * Ben Lee, Steve Chamberlain and Benoit Miller <fulg@iname.com>.
@@ -85,7 +85,7 @@
  *
  * Responses can be run-length encoded to save space.  A '*' means that
  * the next character is an ASCII encoding giving a repeat count which
- * stands for that many repititions of the character preceding the '*'.
+ * stands for that many repetitions of the character preceding the '*'.
  * The encoding is n+29, yielding a printable character where n >=3
  * (which is where RLE starts to win).  Don't use an n > 126.
  *
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 3a19764..a01e367 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -513,7 +513,7 @@ static int handle_unaligned_access(u16 instruction, struct pt_regs *regs)
  *       misaligned data access
  *       access to >= 0x80000000 is user mode
  * Unfortuntaly we can't distinguish between instruction address error
- * and data address errors caused by read acceses.
+ * and data address errors caused by read accesses.
  */
 asmlinkage void do_address_error(struct pt_regs *regs,
 				 unsigned long writeaccess,
diff --git a/arch/sh/math-emu/math.c b/arch/sh/math-emu/math.c
index 1efbac1..a38e1ee 100644
--- a/arch/sh/math-emu/math.c
+++ b/arch/sh/math-emu/math.c
@@ -148,7 +148,7 @@ fmac(struct sh_fpu_soft_struct *fregs, struct pt_regs *regs, int m, int n)
 	return 0;
 }
 
-// to process fmov's extention (odd n for DR access XD).
+// to process fmov's extension (odd n for DR access XD).
 #define FMOV_EXT(x) if(x&1) x+=16-1
 
 static int
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 8fe223a..2bb0d86 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -112,7 +112,7 @@ static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
  * As a performance optimization, other platforms preserve the fixmap mapping
  * across a context switch, we don't presently do this, but this could be done
  * in a similar fashion as to the wired TLB interface that sh64 uses (by way
- * of the memorry mapped UTLB configuration) -- this unfortunately forces us to
+ * of the memory mapped UTLB configuration) -- this unfortunately forces us to
  * give up a TLB entry for each mapping we want to preserve. While this may be
  * viable for a small number of fixmaps, it's not particularly useful for
  * everything and needs to be carefully evaluated. (ie, we may want this for
-- 
1.5.0.1

-- 
Simon Arlott
