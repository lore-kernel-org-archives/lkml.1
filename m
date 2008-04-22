Return-Path: <linux-kernel-owner+w=401wt.eu-S1762277AbYDVTe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762277AbYDVTe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYDVTeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:34:19 -0400
Received: from pilet.ens-lyon.fr ([140.77.167.16]:50029 "EHLO
	pilet.ens-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbYDVTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:34:18 -0400
Date: Tue, 22 Apr 2008 21:34:08 +0200
From: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] [TRIVIAL] spelling fix in various files: preferred ->
	preferred
Message-ID: <20080422193408.GC11391@pirzuine>
References: <20080319202818.GE6935@ens-lyon.fr> <alpine.LNX.1.00.0804212322490.1777@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0804212322490.1777@dragon.funnycrock.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 11:24:38PM +0200, Jesper Juhl wrote:
> On Wed, 19 Mar 2008, Benoit Boissinot wrote:
> 
> > Spelling fix: prefered -> preferred
> > 
> > Signed-off-by: Benoit Boissinot <benoit.boissinot@ens-lyon.org>
> > 
> 
> This patch doesn't apply cleanly to mainline any more. Please re-submit if 
> you still want it applied.

done below
> 
> It would be better to split this by subsystem and submit a few 
> patches instead of one huge patch. That makes it easier to merge, both via 
> maintainers and, if that fails, via trivial.

I don't think it is really huge:
 Documentation/i2c/busses/i2c-parport-light |    2 +-
 arch/m68knommu/platform/coldfire/head.S    |    2 +-
 arch/s390/kernel/time.c                    |    2 +-
 drivers/media/video/cx25840/cx25840-core.c |    2 +-
 drivers/net/enc28j60_hw.h                  |    2 +-
 drivers/net/sk98lin/skrlmt.c               |    2 +-
 drivers/net/tokenring/madgemc.c            |    2 +-
 include/acpi/actbl.h                       |    4 ++--
 include/asm-blackfin/cplbinit.h            |    2 +-
 include/asm-ia64/sn/bte.h                  |    2 +-
 include/linux/prefetch.h                   |    2 +-
 include/net/iw_handler.h                   |    2 +-
 sound/pci/ice1712/ice1712.c                |    4 ++--
 sound/ppc/snd_ps3_reg.h                    |    2 +-
 14 files changed, 16 insertions(+), 16 deletions(-)

And if I should split it in 14 patches, I'd prefer to drop it, it would consume too much time.

I've removed the change to acpi, since it was renaming an enum, and although it is safe for the
kernel (not exported in userspace), upstream might not like it if the header is shared with
some other library.
Now all the changes are in comments.

regards,

Benoit


diff --git a/Documentation/i2c/busses/i2c-parport-light b/Documentation/i2c/busses/i2c-parport-light
index 2874364..597ce4c 100644
--- a/Documentation/i2c/busses/i2c-parport-light
+++ b/Documentation/i2c/busses/i2c-parport-light
@@ -4,7 +4,7 @@ Author: Jean Delvare <khali@linux-fr.org>
 
 This driver is a light version of i2c-parport. It doesn't depend        
 on the parport driver, and uses direct I/O access instead. This might be
-prefered on embedded systems where wasting memory for the clean but heavy
+preferred on embedded systems where wasting memory for the clean but heavy
 parport handling is not an option. The drawback is a reduced portability
 and the impossibility to daisy-chain other parallel port devices.                 
   
diff --git a/arch/m68knommu/platform/coldfire/head.S b/arch/m68knommu/platform/coldfire/head.S
index b9aa0ca..6299482 100644
--- a/arch/m68knommu/platform/coldfire/head.S
+++ b/arch/m68knommu/platform/coldfire/head.S
@@ -19,7 +19,7 @@
 
 /*
  *	If we don't have a fixed memory size, then lets build in code
- *	to auto detect the DRAM size. Obviously this is the prefered
+ *	to auto detect the DRAM size. Obviously this is the preferred
  *	method, and should work for most boards. It won't work for those
  *	that do not have their RAM starting at address 0, and it only
  *	works on SDRAM (not boards fitted with SRAM).
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index cb232c1..05d51bf 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -1038,7 +1038,7 @@ static void etr_work_fn(struct work_struct *work)
 		eacr = etr_handle_update(&aib, eacr);
 
 	/*
-	 * Select ports to enable. The prefered synchronization mode is PPS.
+	 * Select ports to enable. The preferred synchronization mode is PPS.
 	 * If a port can be enabled depends on a number of things:
 	 * 1) The port needs to be online and uptodate. A port is not
 	 *    disabled just because it is not uptodate, but it is only
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 756a1ee..9abb569 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -245,7 +245,7 @@ static void cx25840_initialize(struct i2c_client *client)
 	cx25840_write(client, 0x918, 0xa0);
 	cx25840_write(client, 0x919, 0x01);
 
-	/* stereo prefered */
+	/* stereo preferred */
 	cx25840_write(client, 0x809, 0x04);
 	/* AC97 shift */
 	cx25840_write(client, 0x8cf, 0x0f);
diff --git a/drivers/net/enc28j60_hw.h b/drivers/net/enc28j60_hw.h
index 1a0b209..25b41de 100644
--- a/drivers/net/enc28j60_hw.h
+++ b/drivers/net/enc28j60_hw.h
@@ -303,7 +303,7 @@
 /* maximum ethernet frame length */
 #define MAX_FRAMELEN		1518
 
-/* Prefered half duplex: LEDA: Link status LEDB: Rx/Tx activity */
+/* Preferred half duplex: LEDA: Link status LEDB: Rx/Tx activity */
 #define ENC28J60_LAMPS_MODE	0x3476
 
 #endif
diff --git a/drivers/net/sk98lin/skrlmt.c b/drivers/net/sk98lin/skrlmt.c
index be8d1cc..754e5ba 100644
--- a/drivers/net/sk98lin/skrlmt.c
+++ b/drivers/net/sk98lin/skrlmt.c
@@ -1627,7 +1627,7 @@ SK_U32	NetIdx)	/* Net index */
 	PortFound = SK_FALSE;
 	pAC->Rlmt.CheckSwitch = SK_FALSE;
 
-#if 0	/* RW 2001/10/18 - active port becomes always prefered one */
+#if 0	/* RW 2001/10/18 - active port becomes always preferred one */
 	if (pAC->Rlmt.Net[NetIdx].Preference == 0xFFFFFFFF) { /* Automatic */
 		/* disable auto-fail back */
 		PrefPort = Active;
diff --git a/drivers/net/tokenring/madgemc.c b/drivers/net/tokenring/madgemc.c
index c9c5a2b..cc8df75 100644
--- a/drivers/net/tokenring/madgemc.c
+++ b/drivers/net/tokenring/madgemc.c
@@ -459,7 +459,7 @@ static irqreturn_t madgemc_interrupt(int irq, void *dev_id)
 }
 
 /*
- * Set the card to the prefered ring speed.
+ * Set the card to the preferred ring speed.
  *
  * Unlike newer cards, the MC16/32 have their speed selection
  * circuit connected to the Madge ASICs and not to the TMS380
diff --git a/include/asm-blackfin/cplbinit.h b/include/asm-blackfin/cplbinit.h
index 0eb1c1b..28dfa75 100644
--- a/include/asm-blackfin/cplbinit.h
+++ b/include/asm-blackfin/cplbinit.h
@@ -52,7 +52,7 @@ enum
 struct cplb_desc {
 	u32 start; /* start address */
 	u32 end; /* end address */
-	u32 psize; /* prefered size if any otherwise 1MB or 4MB*/
+	u32 psize; /* preferred size if any otherwise 1MB or 4MB*/
 	u16 attr;/* attributes */
 	u16 i_conf;/* I-CPLB DATA */
 	u16 d_conf;/* D-CPLB DATA */
diff --git a/include/asm-ia64/sn/bte.h b/include/asm-ia64/sn/bte.h
index a0d214f..7ee01d6 100644
--- a/include/asm-ia64/sn/bte.h
+++ b/include/asm-ia64/sn/bte.h
@@ -216,7 +216,7 @@ extern void bte_error_handler(unsigned long);
 	bte_copy(0, dest, len, ((mode) | BTE_ZERO_FILL), notification)
 
 /*
- * The following is the prefered way of calling bte_unaligned_copy
+ * The following is the preferred way of calling bte_unaligned_copy
  * If the copy is fully cache line aligned, then bte_copy is
  * used instead.  Since bte_copy is inlined, this saves a call
  * stack.  NOTE: bte_copy is called synchronously and does block
diff --git a/include/linux/prefetch.h b/include/linux/prefetch.h
index af7c36a..a3bfbdf 100644
--- a/include/linux/prefetch.h
+++ b/include/linux/prefetch.h
@@ -29,7 +29,7 @@
 	prefetchw(x)	- prefetches the cacheline at "x" for write
 	spin_lock_prefetch(x) - prefetches the spinlock *x for taking
 	
-	there is also PREFETCH_STRIDE which is the architecure-prefered 
+	there is also PREFETCH_STRIDE which is the architecure-preferred 
 	"lookahead" size for prefetching streamed operations.
 	
 */
diff --git a/include/net/iw_handler.h b/include/net/iw_handler.h
index 369d50e..7019abf 100644
--- a/include/net/iw_handler.h
+++ b/include/net/iw_handler.h
@@ -129,7 +129,7 @@
  *
  * Functions prototype uses union iwreq_data
  * -----------------------------------------
- * Some would have prefered functions defined this way :
+ * Some would have preferred functions defined this way :
  *	static int mydriver_ioctl_setrate(struct net_device *dev, 
  *					  long rate, int auto)
  * 1) The kernel code doesn't "validate" the content of iwreq_data, and
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index df292af..0cf2622 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2712,7 +2712,7 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 			return err;
 		}
 		if (c->mpu401_1_name)
-			/*  Prefered name available in card_info */
+			/*  Preferred name available in card_info */
 			snprintf(ice->rmidi[0]->name,
 				 sizeof(ice->rmidi[0]->name),
 				 "%s %d", c->mpu401_1_name, card->number);
@@ -2729,7 +2729,7 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 				return err;
 			}
 			if (c->mpu401_2_name)
-				/*  Prefered name available in card_info */
+				/*  Preferred name available in card_info */
 				snprintf(ice->rmidi[1]->name,
 					 sizeof(ice->rmidi[1]->name),
 					 "%s %d", c->mpu401_2_name,
diff --git a/sound/ppc/snd_ps3_reg.h b/sound/ppc/snd_ps3_reg.h
index 03fdee4..d146d33 100644
--- a/sound/ppc/snd_ps3_reg.h
+++ b/sound/ppc/snd_ps3_reg.h
@@ -125,7 +125,7 @@
    transfers.  Any interrupts associated with the canceled transfers
    will occur as if the transfer had finished.
    Since this bit is designed to recover from DMA related issues
-   which are caused by unpredictable situations, it is prefered to wait
+   which are caused by unpredictable situations, it is preferred to wait
    for normal DMA transfer end without using this bit.
 */
 #define PS3_AUDIO_CONFIG_CLEAR          (1 << 8)  /* RWIVF */

-- 
:wq
