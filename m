Return-Path: <linux-kernel-owner+w=401wt.eu-S1031067AbXEKTr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031067AbXEKTr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbXEKTnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:43:05 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:45967 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933634AbXEKTnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:43:00 -0400
Message-ID: <4644C73E.7050501@simon.arlott.org.uk>
Date: Fri, 11 May 2007 20:42:54 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, trivial@kernel.org
Subject: [PATCH] spelling fixes: arch/ppc/
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling fixes in arch/ppc/.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 arch/ppc/4xx_io/serial_sicc.c        |   10 +++++-----
 arch/ppc/8xx_io/commproc.c           |    2 +-
 arch/ppc/8xx_io/fec.c                |    2 +-
 arch/ppc/boot/lib/vreset.c           |    2 +-
 arch/ppc/boot/simple/m8xx_tty.c      |    2 +-
 arch/ppc/boot/simple/misc-embedded.c |    2 +-
 arch/ppc/boot/simple/mpc52xx_tty.c   |    2 +-
 arch/ppc/boot/simple/mv64x60_tty.c   |    2 +-
 arch/ppc/boot/simple/rw4/stb.h       |    2 +-
 arch/ppc/kernel/traps.c              |    4 ++--
 arch/ppc/mm/init.c                   |    2 +-
 arch/ppc/platforms/4xx/bubinga.c     |    2 +-
 arch/ppc/platforms/4xx/ep405.c       |    2 +-
 arch/ppc/platforms/4xx/ibmnp405h.h   |    2 +-
 arch/ppc/platforms/4xx/sycamore.c    |    2 +-
 arch/ppc/platforms/4xx/walnut.c      |    2 +-
 arch/ppc/platforms/ev64360.c         |    2 +-
 arch/ppc/platforms/hdpu.c            |    2 +-
 arch/ppc/platforms/katana.c          |    2 +-
 arch/ppc/platforms/mbx.h             |    2 +-
 arch/ppc/platforms/mvme5100.h        |    2 +-
 arch/ppc/platforms/pplus.h           |    2 +-
 arch/ppc/platforms/prep_pci.c        |   22 +++++++++++-----------
 arch/ppc/platforms/prep_setup.c      |    6 +++---
 arch/ppc/platforms/prpmc750.h        |    2 +-
 arch/ppc/platforms/radstone_ppc7d.c  |    2 +-
 arch/ppc/platforms/sandpoint.c       |    8 ++++----
 arch/ppc/syslib/harrier.c            |    2 +-
 arch/ppc/syslib/hawk_common.c        |    4 ++--
 arch/ppc/syslib/m82xx_pci.c          |    2 +-
 arch/ppc/syslib/mpc10x_common.c      |    4 ++--
 arch/ppc/syslib/mpc52xx_setup.c      |    2 +-
 arch/ppc/syslib/mpc8xx_devices.c     |    2 +-
 arch/ppc/syslib/mv64x60.c            |   10 +++++-----
 arch/ppc/syslib/ocp.c                |    2 +-
 arch/ppc/syslib/ppc403_pic.c         |    2 +-
 arch/ppc/syslib/ppc405_pci.c         |    2 +-
 arch/ppc/syslib/ppc4xx_dma.c         |    2 +-
 arch/ppc/syslib/ppc85xx_rio.c        |    4 ++--
 arch/ppc/syslib/xilinx_pic.c         |    2 +-
 40 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/arch/ppc/4xx_io/serial_sicc.c b/arch/ppc/4xx_io/serial_sicc.c
index e354839..efa0a56 100644
--- a/arch/ppc/4xx_io/serial_sicc.c
+++ b/arch/ppc/4xx_io/serial_sicc.c
@@ -3,7 +3,7 @@
  *
  *  Based on drivers/char/serial_amba.c, by ARM Ltd.
  *
- *  Copyright 2001 IBM Crop.
+ *  Copyright 2001 IBM Corp.
  *  Author: IBM China Research Lab
  *            Yudong Yang <yangyud@cn.ibm.com>
  *            Yi Ge       <geyi@cn.ibm.com>
@@ -155,16 +155,16 @@
 
 /* serial port transmit command register */
 
-#define _TxCR_ET_MASK   0x80           /* transmiter enable mask */
+#define _TxCR_ET_MASK   0x80           /* transmitter enable mask */
 #define _TxCR_DME_MASK  0x60           /* dma mode mask */
 #define _TxCR_TIE_MASK  0x10           /* empty interrupt enable mask */
 #define _TxCR_EIE_MASK  0x08           /* error interrupt enable mask */
 #define _TxCR_SPE_MASK  0x04           /* stop/pause mask */
 #define _TxCR_TB_MASK   0x02           /* transmit break mask */
 
-#define _TxCR_ET_ENABLE _TxCR_ET_MASK  /* transmiter enabled */
-#define _TxCR_DME_DISABLE 0x00         /* transmiter disabled, TBR intr disabled */
-#define _TxCR_DME_TBR   0x20           /* transmiter disabled, TBR intr enabled */
+#define _TxCR_ET_ENABLE _TxCR_ET_MASK  /* transmitter enabled */
+#define _TxCR_DME_DISABLE 0x00         /* transmitter disabled, TBR intr disabled */
+#define _TxCR_DME_TBR   0x20           /* transmitter disabled, TBR intr enabled */
 #define _TxCR_DME_CHAN_2 0x40          /* dma enabled, destination chann 2 */
 #define _TxCR_DME_CHAN_3 0x60          /* dma enabled, destination chann 3 */
 
diff --git a/arch/ppc/8xx_io/commproc.c b/arch/ppc/8xx_io/commproc.c
index e2c6210..7088428 100644
--- a/arch/ppc/8xx_io/commproc.c
+++ b/arch/ppc/8xx_io/commproc.c
@@ -144,7 +144,7 @@ m8xx_cpm_reset(void)
 
 	/* Set SDMA Bus Request priority 5.
 	 * On 860T, this also enables FEC priority 6.  I am not sure
-	 * this is what we realy want for some applications, but the
+	 * this is what we really want for some applications, but the
 	 * manual recommends it.
 	 * Bit 25, FAM can also be set to use FEC aggressive mode (860T).
 	 */
diff --git a/arch/ppc/8xx_io/fec.c b/arch/ppc/8xx_io/fec.c
index 57a9a61..d38335d 100644
--- a/arch/ppc/8xx_io/fec.c
+++ b/arch/ppc/8xx_io/fec.c
@@ -1878,7 +1878,7 @@ fec_restart(struct net_device *dev, int duplex)
 	bdp--;
 	bdp->cbd_sc |= BD_SC_WRAP;
 
-	/* ...and the same for transmmit.
+	/* ...and the same for transmit.
 	*/
 	bdp = fep->tx_bd_base;
 	for (i=0; i<TX_RING_SIZE; i++) {
diff --git a/arch/ppc/boot/lib/vreset.c b/arch/ppc/boot/lib/vreset.c
index 463ba00..98539e9 100644
--- a/arch/ppc/boot/lib/vreset.c
+++ b/arch/ppc/boot/lib/vreset.c
@@ -518,7 +518,7 @@ setTextRegs(struct VgaRegs *svp)
 	outb(0x3c6, 0xff);  /* MASK */
 
 	for ( i = 0; i < 0x10; i++)
-		writeAttr(i, AC[i], 0);  /* pallete */
+		writeAttr(i, AC[i], 0);  /* palette */
 	writeAttr(0x10, 0x0c, 0);    /* text mode */
 	writeAttr(0x11, 0x00, 0);    /* overscan color (border) */
 	writeAttr(0x12, 0x0f, 0);    /* plane enable */
diff --git a/arch/ppc/boot/simple/m8xx_tty.c b/arch/ppc/boot/simple/m8xx_tty.c
index cacc40f..ea615d8 100644
--- a/arch/ppc/boot/simple/m8xx_tty.c
+++ b/arch/ppc/boot/simple/m8xx_tty.c
@@ -1,7 +1,7 @@
 /* Minimal serial functions needed to send messages out the serial
  * port on the MBX console.
  *
- * The MBX uxes SMC1 for the serial port.  We reset the port and use
+ * The MBX uses SMC1 for the serial port.  We reset the port and use
  * only the first BD that EPPC-Bug set up as a character FIFO.
  *
  * Later versions (at least 1.4, maybe earlier) of the MBX EPPC-Bug
diff --git a/arch/ppc/boot/simple/misc-embedded.c b/arch/ppc/boot/simple/misc-embedded.c
index 10219ee..8a08ad3 100644
--- a/arch/ppc/boot/simple/misc-embedded.c
+++ b/arch/ppc/boot/simple/misc-embedded.c
@@ -136,7 +136,7 @@ load_kernel(unsigned long load_addr, int num_words, unsigned long cksum, bd_t *b
 
 	/*
 	 * We link ourself to an arbitrary low address.  When we run, we
-	 * relocate outself to that address.  __image_being points to
+	 * relocate ourself to that address.  __image_being points to
 	 * the part of the image where the zImage is. -- Tom
 	 */
 	zimage_start = (char *)(unsigned long)(&__image_begin);
diff --git a/arch/ppc/boot/simple/mpc52xx_tty.c b/arch/ppc/boot/simple/mpc52xx_tty.c
index 7b5924c..6955891 100644
--- a/arch/ppc/boot/simple/mpc52xx_tty.c
+++ b/arch/ppc/boot/simple/mpc52xx_tty.c
@@ -33,7 +33,7 @@ static struct mpc52xx_psc __iomem *psc =
  * rtc.  We read the decrementer change during one rtc tick
  * and multiply by 4 to get the system bus clock frequency. Since a
  * rtc tick is one seconds, and that's pretty long, we change the rtc
- * dividers temporarly to set them 64x faster ;)
+ * dividers temporarily to set them 64x faster ;)
  */
 static int
 mpc52xx_ipbfreq(void)
diff --git a/arch/ppc/boot/simple/mv64x60_tty.c b/arch/ppc/boot/simple/mv64x60_tty.c
index 781e040..8a73578 100644
--- a/arch/ppc/boot/simple/mv64x60_tty.c
+++ b/arch/ppc/boot/simple/mv64x60_tty.c
@@ -338,7 +338,7 @@ serial_tstc(unsigned long com_port)
 
 	rdp = &rd[com_port][cur_rd[com_port]];
 
-	/* Go thru rcv desc's until empty looking for one with data (no error)*/
+	/* Go through rcv descs until empty looking for one with data (no error)*/
 	while (((rdp->cmd_stat & SDMA_DESC_CMDSTAT_O) == 0) &&
 		(loop_count++ < RX_NUM_DESC)) {
 
diff --git a/arch/ppc/boot/simple/rw4/stb.h b/arch/ppc/boot/simple/rw4/stb.h
index fd98ee0..9afa5ab 100644
--- a/arch/ppc/boot/simple/rw4/stb.h
+++ b/arch/ppc/boot/simple/rw4/stb.h
@@ -88,7 +88,7 @@
 /*----------------------------------------------------------------------------+
 | STB tasks, task stack sizes, and task priorities.  The actual task priority
 | is 1 more than the specified number since priority 0 is reserved (system
-| internaly adds 1 to supplied priority number).
+| internally adds 1 to supplied priority number).
 +----------------------------------------------------------------------------*/
 #define STB_IDLE_TASK_SS        (5* 1024)
 #define STB_IDLE_TASK_PRIO      0
diff --git a/arch/ppc/kernel/traps.c b/arch/ppc/kernel/traps.c
index 810f7aa..aea100b 100644
--- a/arch/ppc/kernel/traps.c
+++ b/arch/ppc/kernel/traps.c
@@ -577,7 +577,7 @@ void program_check_exception(struct pt_regs *regs)
 	 * ESR_DST (!?) or 0.  In the process of chasing this with the
 	 * hardware people - not sure if it can happen on any illegal
 	 * instruction or only on FP instructions, whether there is a
-	 * pattern to occurences etc. -dgibson 31/Mar/2003 */
+	 * pattern to occurrences etc. -dgibson 31/Mar/2003 */
 	if (!(reason & REASON_TRAP) && do_mathemu(regs) == 0) {
 		emulate_single_step(regs);
 		return;
@@ -860,7 +860,7 @@ void SPEFloatingPointException(struct pt_regs *regs)
 	spefscr = current->thread.spefscr;
 	fpexc_mode = current->thread.fpexc_mode;
 
-	/* Hardware does not neccessarily set sticky
+	/* Hardware does not necessarily set sticky
 	 * underflow/overflow/invalid flags */
 	if ((spefscr & SPEFSCR_FOVF) && (fpexc_mode & PR_FP_EXC_OVF)) {
 		code = FPE_FLTOVF;
diff --git a/arch/ppc/mm/init.c b/arch/ppc/mm/init.c
index c374e53..390dd19 100644
--- a/arch/ppc/mm/init.c
+++ b/arch/ppc/mm/init.c
@@ -48,7 +48,7 @@
 #include "mmu_decl.h"
 
 #if defined(CONFIG_KERNEL_START_BOOL) || defined(CONFIG_LOWMEM_SIZE_BOOL)
-/* The ammount of lowmem must be within 0xF0000000 - KERNELBASE. */
+/* The amount of lowmem must be within 0xF0000000 - KERNELBASE. */
 #if (CONFIG_LOWMEM_SIZE > (0xF0000000 - KERNELBASE))
 #error "You must adjust CONFIG_LOWMEM_SIZE or CONFIG_START_KERNEL"
 #endif
diff --git a/arch/ppc/platforms/4xx/bubinga.c b/arch/ppc/platforms/4xx/bubinga.c
index 75857b3..1a7f075 100644
--- a/arch/ppc/platforms/4xx/bubinga.c
+++ b/arch/ppc/platforms/4xx/bubinga.c
@@ -197,7 +197,7 @@ bios_fixup(struct pci_controller *hose, struct pcil0_regs *pcip)
 		    hose->first_busno, PCI_SLOT(hose->first_busno),
 		    PCI_FUNC(hose->first_busno), bar, bar_response);
 	}
-	/* end work arround */
+	/* end workaround */
 
 #ifdef DEBUG
 	printk("PCI bridge regs after fixup \n");
diff --git a/arch/ppc/platforms/4xx/ep405.c b/arch/ppc/platforms/4xx/ep405.c
index e5adf9b..5aa2950 100644
--- a/arch/ppc/platforms/4xx/ep405.c
+++ b/arch/ppc/platforms/4xx/ep405.c
@@ -130,7 +130,7 @@ bios_fixup(struct pci_controller *hose, struct pcil0_regs *pcip)
 		    hose->first_busno, PCI_SLOT(hose->first_busno),
 		    PCI_FUNC(hose->first_busno), bar, bar_response);
 	}
-	/* end work arround */
+	/* end workaround */
 #endif
 }
 
diff --git a/arch/ppc/platforms/4xx/ibmnp405h.h b/arch/ppc/platforms/4xx/ibmnp405h.h
index 4aa8821..08a6a77 100644
--- a/arch/ppc/platforms/4xx/ibmnp405h.h
+++ b/arch/ppc/platforms/4xx/ibmnp405h.h
@@ -80,7 +80,7 @@
 #define DCRN_CPMFR_BASE	0x0B9
 #define DCRN_CPMER_BASE	0x0B8
 
-/* CPM Clocking & Power Mangement defines */
+/* CPM Clocking & Power Management defines */
 #define IBM_CPM_PCI		0x40000000	/* PCI */
 #define IBM_CPM_EMAC2	0x20000000	/* EMAC 2 MII */
 #define IBM_CPM_EMAC3	0x04000000	/* EMAC 3 MII */
diff --git a/arch/ppc/platforms/4xx/sycamore.c b/arch/ppc/platforms/4xx/sycamore.c
index c47493e..8689f3e 100644
--- a/arch/ppc/platforms/4xx/sycamore.c
+++ b/arch/ppc/platforms/4xx/sycamore.c
@@ -225,7 +225,7 @@ bios_fixup(struct pci_controller *hose, struct pcil0_regs *pcip)
 		    hose->first_busno, PCI_SLOT(hose->first_busno),
 		    PCI_FUNC(hose->first_busno), bar, bar_response);
 	}
-	/* end work arround */
+	/* end workaround */
 
 #ifdef DEBUG
 	printk("PCI bridge regs after fixup \n");
diff --git a/arch/ppc/platforms/4xx/walnut.c b/arch/ppc/platforms/4xx/walnut.c
index f414d2d..2f97723 100644
--- a/arch/ppc/platforms/4xx/walnut.c
+++ b/arch/ppc/platforms/4xx/walnut.c
@@ -200,7 +200,7 @@ bios_fixup(struct pci_controller *hose, struct pcil0_regs *pcip)
 		    hose->first_busno, PCI_SLOT(hose->first_busno),
 		    PCI_FUNC(hose->first_busno), bar, bar_response);
 	}
-	/* end work arround */
+	/* end work around */
 
 #ifdef DEBUG
 	printk("PCI bridge regs after fixup \n");
diff --git a/arch/ppc/platforms/ev64360.c b/arch/ppc/platforms/ev64360.c
index f87e06f..f8baf05 100644
--- a/arch/ppc/platforms/ev64360.c
+++ b/arch/ppc/platforms/ev64360.c
@@ -473,7 +473,7 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	 * are non-zero, then we should use the board info from the bd_t
 	 * structure and the cmdline pointed to by r6 instead of the
 	 * information from birecs, if any.  Otherwise, use the information
-	 * from birecs as discovered by the preceeding call to
+	 * from birecs as discovered by the preceding call to
 	 * parse_bootinfo().  This rule should work with both PPCBoot, which
 	 * uses a bd_t board info structure, and the kernel boot wrapper,
 	 * which uses birecs.
diff --git a/arch/ppc/platforms/hdpu.c b/arch/ppc/platforms/hdpu.c
index d809e17..ca5de13 100644
--- a/arch/ppc/platforms/hdpu.c
+++ b/arch/ppc/platforms/hdpu.c
@@ -144,7 +144,7 @@ static void __init hdpu_setup_peripherals(void)
 
 	/* Enable pipelining */
 	mv64x60_set_bits(&bh, MV64x60_CPU_CONFIG, (1 << 13));
-	/* Enable Snoop Pipelineing */
+	/* Enable Snoop Pipelining */
 	mv64x60_set_bits(&bh, MV64360_D_UNIT_CONTROL_HIGH, (1 << 24));
 
 	/*
diff --git a/arch/ppc/platforms/katana.c b/arch/ppc/platforms/katana.c
index 720f8b3..c289e9f 100644
--- a/arch/ppc/platforms/katana.c
+++ b/arch/ppc/platforms/katana.c
@@ -880,7 +880,7 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	 * are non-zero, then we should use the board info from the bd_t
 	 * structure and the cmdline pointed to by r6 instead of the
 	 * information from birecs, if any.  Otherwise, use the information
-	 * from birecs as discovered by the preceeding call to
+	 * from birecs as discovered by the preceding call to
 	 * parse_bootinfo().  This rule should work with both PPCBoot, which
 	 * uses a bd_t board info structure, and the kernel boot wrapper,
 	 * which uses birecs.
diff --git a/arch/ppc/platforms/mbx.h b/arch/ppc/platforms/mbx.h
index fe81ca4..1cf36fa 100644
--- a/arch/ppc/platforms/mbx.h
+++ b/arch/ppc/platforms/mbx.h
@@ -37,7 +37,7 @@ typedef struct bd_info {
 
 /* Memory map for the MBX as configured by EPPC-Bug.  We could reprogram
  * The SIU and PCI bridge, and try to use larger MMU pages, but the
- * performance gain is not measureable and it certainly complicates the
+ * performance gain is not measurable and it certainly complicates the
  * generic MMU model.
  *
  * In a effort to minimize memory usage for embedded applications, any
diff --git a/arch/ppc/platforms/mvme5100.h b/arch/ppc/platforms/mvme5100.h
index 9e2a09e..fbb5495 100644
--- a/arch/ppc/platforms/mvme5100.h
+++ b/arch/ppc/platforms/mvme5100.h
@@ -69,7 +69,7 @@
 
 #define STD_COM_FLAGS ASYNC_BOOT_AUTOCONF
 
-/* All UART IRQ's are wire-OR'd to one MPIC IRQ */
+/* All UART IRQs are wire-OR'd to one MPIC IRQ */
 #define STD_SERIAL_PORT_DFNS \
         { 0, BASE_BAUD, MVME5100_SERIAL_1, \
 		MVME5100_SERIAL_IRQ, \
diff --git a/arch/ppc/platforms/pplus.h b/arch/ppc/platforms/pplus.h
index a07cbbd..a4bbaa8 100644
--- a/arch/ppc/platforms/pplus.h
+++ b/arch/ppc/platforms/pplus.h
@@ -18,7 +18,7 @@
 #include <asm/io.h>
 
 /*
- * Due to limiations imposed by legacy hardware (primaryily IDE controllers),
+ * Due to limitations imposed by legacy hardware (primarily IDE controllers),
  * the PPLUS boards operate using a PReP address map.
  *
  * From Processor (physical) -> PCI:
diff --git a/arch/ppc/platforms/prep_pci.c b/arch/ppc/platforms/prep_pci.c
index c627ba4..1df3150 100644
--- a/arch/ppc/platforms/prep_pci.c
+++ b/arch/ppc/platforms/prep_pci.c
@@ -589,9 +589,9 @@ static unsigned char prep_pci_intpins[4][4] =
 	{ 4, 1, 2, 3},  /* Buses 3, 7, 11 ... */
 };
 
-/* We have to turn on LEVEL mode for changed IRQ's */
-/* All PCI IRQ's need to be level mode, so this should be something
- * other than hard-coded as well... IRQ's are individually mappable
+/* We have to turn on LEVEL mode for changed IRQs */
+/* All PCI IRQs need to be level mode, so this should be something
+ * other than hard-coded as well... IRQs are individually mappable
  * to either edge or level.
  */
 
@@ -923,8 +923,8 @@ prep_sandalfoot_setup_pci(char *irq_edge_mask_lo, char *irq_edge_mask_hi)
 	Motherboard_map_name = "IBM 6015/7020 (Sandalfoot/Sandalbow)";
 	Motherboard_map = ibm6015_pci_IRQ_map;
 	Motherboard_routes = ibm6015_pci_IRQ_routes;
-	*irq_edge_mask_lo = 0x00; /* irq's 0-7 all edge-triggered */
-	*irq_edge_mask_hi = 0xA0; /* irq's 13, 15 level-triggered */
+	*irq_edge_mask_lo = 0x00; /* IRQs 0-7 all edge-triggered */
+	*irq_edge_mask_hi = 0xA0; /* IRQs 13, 15 level-triggered */
 }
 
 void __init
@@ -933,8 +933,8 @@ prep_thinkpad_setup_pci(char *irq_edge_mask_lo, char *irq_edge_mask_hi)
 	Motherboard_map_name = "IBM Thinkpad 850/860";
 	Motherboard_map = Nobis_pci_IRQ_map;
 	Motherboard_routes = Nobis_pci_IRQ_routes;
-	*irq_edge_mask_lo = 0x00; /* irq's 0-7 all edge-triggered */
-	*irq_edge_mask_hi = 0xA0; /* irq's 13, 15 level-triggered */
+	*irq_edge_mask_lo = 0x00; /* IRQs 0-7 all edge-triggered */
+	*irq_edge_mask_hi = 0xA0; /* IRQs 13, 15 level-triggered */
 }
 
 void __init
@@ -943,8 +943,8 @@ prep_carolina_setup_pci(char *irq_edge_mask_lo, char *irq_edge_mask_hi)
 	Motherboard_map_name = "IBM 7248, PowerSeries 830/850 (Carolina)";
 	Motherboard_map = ibm8xx_pci_IRQ_map;
 	Motherboard_routes = ibm8xx_pci_IRQ_routes;
-	*irq_edge_mask_lo = 0x00; /* irq's 0-7 all edge-triggered */
-	*irq_edge_mask_hi = 0xA4; /* irq's 10, 13, 15 level-triggered */
+	*irq_edge_mask_lo = 0x00; /* IRQs 0-7 all edge-triggered */
+	*irq_edge_mask_hi = 0xA4; /* IRQs 10, 13, 15 level-triggered */
 }
 
 void __init
@@ -954,8 +954,8 @@ prep_tiger1_setup_pci(char *irq_edge_mask_lo, char *irq_edge_mask_hi)
 	Motherboard_map = ibm43p_pci_IRQ_map;
 	Motherboard_routes = ibm43p_pci_IRQ_routes;
 	Motherboard_non0 = ibm43p_pci_map_non0;
-	*irq_edge_mask_lo = 0x00; /* irq's 0-7 all edge-triggered */
-	*irq_edge_mask_hi = 0xA0; /* irq's 13, 15 level-triggered */
+	*irq_edge_mask_lo = 0x00; /* IRQs 0-7 all edge-triggered */
+	*irq_edge_mask_hi = 0xA0; /* IRQs 13, 15 level-triggered */
 }
 
 void __init
diff --git a/arch/ppc/platforms/prep_setup.c b/arch/ppc/platforms/prep_setup.c
index f166299..6f21110 100644
--- a/arch/ppc/platforms/prep_setup.c
+++ b/arch/ppc/platforms/prep_setup.c
@@ -593,7 +593,7 @@ static void __init prep_init_sound(void)
 	PPC_DEVICE *audiodevice = NULL;
 
 	/*
-	 * Get the needed resource informations from residual data.
+	 * Get the needed resource information from residual data.
 	 *
 	 */
 	if (have_residual_data)
@@ -632,9 +632,9 @@ static void __init prep_init_sound(void)
 	}
 
 	/*
-	 * Find a way to push these informations to the cs4232 driver
+	 * Find a way to push this information to the cs4232 driver
 	 * Give it out with printk, when not in cmd_line?
-	 * Append it to  cmd_line and boot_command_line?
+	 * Append it to cmd_line and boot_command_line?
 	 * Format is cs4232=io,irq,dma,dma2
 	 */
 }
diff --git a/arch/ppc/platforms/prpmc750.h b/arch/ppc/platforms/prpmc750.h
index 4c7adcc..c4dcff0 100644
--- a/arch/ppc/platforms/prpmc750.h
+++ b/arch/ppc/platforms/prpmc750.h
@@ -16,7 +16,7 @@
 #define __ASM_PRPMC750_H__
 
 /*
- * Due to limiations imposed by legacy hardware (primaryily IDE controllers),
+ * Due to limitations imposed by legacy hardware (primarily IDE controllers),
  * the PrPMC750 carrier board operates using a PReP address map.
  *
  * From Processor (physical) -> PCI:
diff --git a/arch/ppc/platforms/radstone_ppc7d.c b/arch/ppc/platforms/radstone_ppc7d.c
index 13d70ab..b558607 100644
--- a/arch/ppc/platforms/radstone_ppc7d.c
+++ b/arch/ppc/platforms/radstone_ppc7d.c
@@ -1371,7 +1371,7 @@ void __init platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	 * are non-zero, then we should use the board info from the bd_t
 	 * structure and the cmdline pointed to by r6 instead of the
 	 * information from birecs, if any.  Otherwise, use the information
-	 * from birecs as discovered by the preceeding call to
+	 * from birecs as discovered by the preceding call to
 	 * parse_bootinfo().  This rule should work with both PPCBoot, which
 	 * uses a bd_t board info structure, and the kernel boot wrapper,
 	 * which uses birecs.
diff --git a/arch/ppc/platforms/sandpoint.c b/arch/ppc/platforms/sandpoint.c
index a76002a..3352fae 100644
--- a/arch/ppc/platforms/sandpoint.c
+++ b/arch/ppc/platforms/sandpoint.c
@@ -54,7 +54,7 @@
  *
  *
  * Motorola has finally released a version of DINK32 that correctly
- * (seemingly) initalizes the memory controller correctly, regardless
+ * (seemingly) initializes the memory controller correctly, regardless
  * of the amount of memory in the system.  Once a method of determining
  * what version of DINK initializes the system for us, if applicable, is
  * found, we can hopefully stop hardcoding 32MB of RAM.
@@ -473,7 +473,7 @@ sandpoint_request_io(void)
 arch_initcall(sandpoint_request_io);
 
 /*
- * Interrupt setup and service.  Interrrupts on the Sandpoint come
+ * Interrupt setup and service.  Interrupts on the Sandpoint come
  * from the four PCI slots plus the 8259 in the Winbond Super I/O (SIO).
  * The 8259 is cascaded from EPIC IRQ0, IRQ1-4 map to PCI slots 1-4,
  * IDE is on EPIC 7 and 8.
@@ -505,7 +505,7 @@ sandpoint_find_end_of_memory(void)
 	if (bp->bi_memsize)
 		return bp->bi_memsize;
 
-	/* DINK32 13.0 correctly initalizes things, so iff you use
+	/* DINK32 13.0 correctly initializes things, so iff you use
 	 * this you _should_ be able to change this instead of a
 	 * hardcoded value. */
 #if 0
@@ -677,7 +677,7 @@ platform_init(unsigned long r3, unsigned long r4, unsigned long r5,
 	 * are non-zero, then we should use the board info from the bd_t
 	 * structure and the cmdline pointed to by r6 instead of the
 	 * information from birecs, if any.  Otherwise, use the information
-	 * from birecs as discovered by the preceeding call to
+	 * from birecs as discovered by the preceding call to
 	 * parse_bootinfo().  This rule should work with both PPCBoot, which
 	 * uses a bd_t board info structure, and the kernel boot wrapper,
 	 * which uses birecs.
diff --git a/arch/ppc/syslib/harrier.c b/arch/ppc/syslib/harrier.c
index c1583f4..45b797b 100644
--- a/arch/ppc/syslib/harrier.c
+++ b/arch/ppc/syslib/harrier.c
@@ -210,7 +210,7 @@ harrier_init(struct pci_controller *hose,
  * This assumes that PPCBug has initialized the memory controller (SMC)
  * on the Harrier correctly (i.e., it does no sanity checking).
  * It also assumes that the memory base registers are set to configure the
- * memory as contigous starting with "RAM A BASE", "RAM B BASE", etc.
+ * memory as contiguous starting with "RAM A BASE", "RAM B BASE", etc.
  * however, RAM base registers can be skipped (e.g. A, B, C are set,
  * D is skipped but E is set is okay).
  */
diff --git a/arch/ppc/syslib/hawk_common.c b/arch/ppc/syslib/hawk_common.c
index c5bf16b..86821d8 100644
--- a/arch/ppc/syslib/hawk_common.c
+++ b/arch/ppc/syslib/hawk_common.c
@@ -165,7 +165,7 @@ hawk_init(struct pci_controller *hose,
 				 processor_pci_mem_start + 
 				 hose->mem_space.start) | 0x0);
 
-	/* Map MPIC into vitual memory */
+	/* Map MPIC into virtual memory */
 	OpenPIC_Addr = ioremap(processor_mpic_base, HAWK_MPIC_SIZE);
 
 	return 0;
@@ -176,7 +176,7 @@ hawk_init(struct pci_controller *hose,
  * This assumes that PPCBug has initialized the memory controller (SMC)
  * on the Falcon/HAWK correctly (i.e., it does no sanity checking).
  * It also assumes that the memory base registers are set to configure the
- * memory as contigous starting with "RAM A BASE", "RAM B BASE", etc.
+ * memory as contiguous starting with "RAM A BASE", "RAM B BASE", etc.
  * however, RAM base registers can be skipped (e.g. A, B, C are set,
  * D is skipped but E is set is okay).
  */
diff --git a/arch/ppc/syslib/m82xx_pci.c b/arch/ppc/syslib/m82xx_pci.c
index e3b586b..fe860d5 100644
--- a/arch/ppc/syslib/m82xx_pci.c
+++ b/arch/ppc/syslib/m82xx_pci.c
@@ -197,7 +197,7 @@ pq2ads_setup_pci(struct pci_controller *hose)
 	   CPM high      	0b0000
 	   CPM middle           0b0001
 	   CPM low       	0b0010
-	   PCI reguest          0b0011
+	   PCI request          0b0011
 	   Reserved      	0b0100
 	   Reserved      	0b0101
 	   Internal Core     	0b0110
diff --git a/arch/ppc/syslib/mpc10x_common.c b/arch/ppc/syslib/mpc10x_common.c
index 2fc7c41..437a294 100644
--- a/arch/ppc/syslib/mpc10x_common.c
+++ b/arch/ppc/syslib/mpc10x_common.c
@@ -432,7 +432,7 @@ mpc10x_bridge_init(struct pci_controller *hose,
 			phys_eumb_base);
 	}
 
-	/* IRQ's are determined at runtime */
+	/* IRQs are determined at runtime */
 	ppc_sys_platform_devices[MPC10X_IIC1].resource[1].start = MPC10X_I2C_IRQ;
 	ppc_sys_platform_devices[MPC10X_IIC1].resource[1].end = MPC10X_I2C_IRQ;
 	ppc_sys_platform_devices[MPC10X_DMA0].resource[1].start = MPC10X_DMA0_IRQ;
@@ -646,7 +646,7 @@ void __init mpc10x_set_openpic(void)
 	openpic_set_sources(EPIC_IRQ_BASE, 3, OpenPIC_Addr + 0x11020);
 	/* Skip reserved space and map Message Unit Interrupt (I2O) */
 	openpic_set_sources(EPIC_IRQ_BASE + 3, 1, OpenPIC_Addr + 0x110C0);
-	/* Skip reserved space and map Serial Interupts */
+	/* Skip reserved space and map Serial Interrupts */
 	openpic_set_sources(EPIC_IRQ_BASE + 4, 2, OpenPIC_Addr + 0x11120);
 
 	openpic_init(NUM_8259_INTERRUPTS);
diff --git a/arch/ppc/syslib/mpc52xx_setup.c b/arch/ppc/syslib/mpc52xx_setup.c
index 80c6090..ecfa2c0 100644
--- a/arch/ppc/syslib/mpc52xx_setup.c
+++ b/arch/ppc/syslib/mpc52xx_setup.c
@@ -252,7 +252,7 @@ mpc52xx_setup_cpu(void)
 	out_be32(&xlb->snoop_window, MPC52xx_PCI_TARGET_MEM | 0x1d);
 
 	/* Disable XLB pipelining */
-	/* (cfr errate 292. We could do this only just before ATA PIO
+	/* (cfr errata 292. We could do this only just before ATA PIO
 	    transaction and re-enable it after ...) */
 	out_be32(&xlb->config, in_be32(&xlb->config) | MPC52xx_XLB_CFG_PLDIS);
 
diff --git a/arch/ppc/syslib/mpc8xx_devices.c b/arch/ppc/syslib/mpc8xx_devices.c
index 31fb565..c05ac87 100644
--- a/arch/ppc/syslib/mpc8xx_devices.c
+++ b/arch/ppc/syslib/mpc8xx_devices.c
@@ -21,7 +21,7 @@
 #include <asm/irq.h>
 #include <asm/ppc_sys.h>
 
-/* We use offsets for IORESOURCE_MEM to do not set dependences at compile time.
+/* We use offsets for IORESOURCE_MEM to do not set dependencies at compile time.
  * They will get fixed up by mach_mpc8xx_fixup
  */
 
diff --git a/arch/ppc/syslib/mv64x60.c b/arch/ppc/syslib/mv64x60.c
index a6f8b68..8485a68 100644
--- a/arch/ppc/syslib/mv64x60.c
+++ b/arch/ppc/syslib/mv64x60.c
@@ -490,7 +490,7 @@ static struct platform_device *mv64x60_pd_devs[] __initdata = {
 /*
  * mv64x60_init()
  *
- * Initialze the bridge based on setting passed in via 'si'.  The bridge
+ * Initialize the bridge based on setting passed in via 'si'.  The bridge
  * handle, 'bh', will be set so that it can be used to make subsequent
  * calls to routines in this file.
  */
@@ -1704,7 +1704,7 @@ gt64260_disable_all_windows(struct mv64x60_handle *bh,
 /*
  * gt64260a_chip_specific_init()
  *
- * Implement errata work arounds for the GT64260A.
+ * Implement errata workarounds for the GT64260A.
  */
 static void __init
 gt64260a_chip_specific_init(struct mv64x60_handle *bh,
@@ -1776,7 +1776,7 @@ gt64260a_chip_specific_init(struct mv64x60_handle *bh,
 /*
  * gt64260b_chip_specific_init()
  *
- * Implement errata work arounds for the GT64260B.
+ * Implement errata workarounds for the GT64260B.
  */
 static void __init
 gt64260b_chip_specific_init(struct mv64x60_handle *bh,
@@ -2316,7 +2316,7 @@ mv64360_set_mpsc2regs_window(struct mv64x60_handle *bh, u32 base)
 /*
  * mv64360_chip_specific_init()
  *
- * Implement errata work arounds for the MV64360.
+ * Implement errata workarounds for the MV64360.
  */
 static void __init
 mv64360_chip_specific_init(struct mv64x60_handle *bh,
@@ -2336,7 +2336,7 @@ mv64360_chip_specific_init(struct mv64x60_handle *bh,
 /*
  * mv64460_chip_specific_init()
  *
- * Implement errata work arounds for the MV64460.
+ * Implement errata workarounds for the MV64460.
  */
 static void __init
 mv64460_chip_specific_init(struct mv64x60_handle *bh,
diff --git a/arch/ppc/syslib/ocp.c b/arch/ppc/syslib/ocp.c
index 50c5562..491fe9a 100644
--- a/arch/ppc/syslib/ocp.c
+++ b/arch/ppc/syslib/ocp.c
@@ -27,7 +27,7 @@
  *  device model.  The devices on the OCP bus are seeded by an
  *  an initial OCP device array created by the arch-specific
  *  Device entries can be added/removed/modified through OCP
- *  helper functions to accomodate system and  board-specific
+ *  helper functions to accommodate system and  board-specific
  *  parameters commonly found in embedded systems. OCP also
  *  provides a standard method for devices to describe extended
  *  attributes about themselves to the system.  A standard access
diff --git a/arch/ppc/syslib/ppc403_pic.c b/arch/ppc/syslib/ppc403_pic.c
index 607ebd1..c3b7b8b 100644
--- a/arch/ppc/syslib/ppc403_pic.c
+++ b/arch/ppc/syslib/ppc403_pic.c
@@ -112,7 +112,7 @@ ppc4xx_pic_init(void)
 
 	/*
 	 * Disable all external interrupts until they are
-	 * explicity requested.
+	 * explicitly requested.
 	 */
 	ppc_cached_irq_mask[0] = 0;
 
diff --git a/arch/ppc/syslib/ppc405_pci.c b/arch/ppc/syslib/ppc405_pci.c
index d6d838b..9e90356 100644
--- a/arch/ppc/syslib/ppc405_pci.c
+++ b/arch/ppc/syslib/ppc405_pci.c
@@ -137,7 +137,7 @@ ppc4xx_find_bridges(void)
 	hose_a->pci_mem_offset = 0;
 
 	/* Setup bridge memory/IO ranges & resources
-	 * TODO: Handle firmwares setting up a legacy ISA mem base
+	 * TODO: Handle firmware setting up a legacy ISA mem base
 	 */
 	hose_a->io_space.start = PPC405_PCI_LOWER_IO;
 	hose_a->io_space.end = PPC405_PCI_UPPER_IO;
diff --git a/arch/ppc/syslib/ppc4xx_dma.c b/arch/ppc/syslib/ppc4xx_dma.c
index 1eef4ff..bd30186 100644
--- a/arch/ppc/syslib/ppc4xx_dma.c
+++ b/arch/ppc/syslib/ppc4xx_dma.c
@@ -241,7 +241,7 @@ ppc4xx_set_dma_count(unsigned int dmanr, unsigned int count)
 }
 
 /*
- *   Returns the number of bytes left to be transfered.
+ *   Returns the number of bytes left to be transferred.
  *   After a DMA transfer, this should return zero.
  *   Reading this while a DMA transfer is still in progress will return
  *   unpredictable results.
diff --git a/arch/ppc/syslib/ppc85xx_rio.c b/arch/ppc/syslib/ppc85xx_rio.c
index 2b09780..af2425e 100644
--- a/arch/ppc/syslib/ppc85xx_rio.c
+++ b/arch/ppc/syslib/ppc85xx_rio.c
@@ -349,7 +349,7 @@ EXPORT_SYMBOL_GPL(rio_hw_add_outb_message);
  * @dev_instance: Pointer to interrupt-specific data
  *
  * Handles outbound message interrupts. Executes a register outbound
- * mailbox event handler and acks the interrupt occurence.
+ * mailbox event handler and acks the interrupt occurrence.
  */
 static irqreturn_t
 mpc85xx_rio_tx_handler(int irq, void *dev_instance)
@@ -516,7 +516,7 @@ void rio_close_outb_mbox(struct rio_mport *mport, int mbox)
  * @dev_instance: Pointer to interrupt-specific data
  *
  * Handles inbound message interrupts. Executes a registered inbound
- * mailbox event handler and acks the interrupt occurence.
+ * mailbox event handler and acks the interrupt occurrence.
  */
 static irqreturn_t
 mpc85xx_rio_rx_handler(int irq, void *dev_instance)
diff --git a/arch/ppc/syslib/xilinx_pic.c b/arch/ppc/syslib/xilinx_pic.c
index 6fd4cdb..3b82333 100644
--- a/arch/ppc/syslib/xilinx_pic.c
+++ b/arch/ppc/syslib/xilinx_pic.c
@@ -130,7 +130,7 @@ ppc4xx_pic_init(void)
 
 	/*
 	 * Disable all external interrupts until they are
-	 * explicity requested.
+	 * explicitly requested.
 	 */
 	intc_out_be32(intc + IER, 0);
 
-- 
1.5.0.1

-- 
Simon Arlott
