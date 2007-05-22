Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbXEVAa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbXEVAa2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 20:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757265AbXEVAaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 20:30:13 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45565 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755AbXEVAaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 20:30:09 -0400
Date: Mon, 21 May 2007 20:30:06 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes and administrivia
Message-ID: <20070522003006.GA30994@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Two fixes; the rest is trivial pre-release administrivia (ie. only bump
versions and chomp whitespace after everything else gets merged up)

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig            |    2 +-
 drivers/ata/ahci.c             |   13 +++++++++++--
 drivers/ata/ata_generic.c      |    2 +-
 drivers/ata/ata_piix.c         |    9 +--------
 drivers/ata/libata-core.c      |   14 ++++++--------
 drivers/ata/libata-eh.c        |    2 +-
 drivers/ata/pata_artop.c       |    4 ++--
 drivers/ata/pata_cmd640.c      |    4 ++--
 drivers/ata/pata_cmd64x.c      |    2 +-
 drivers/ata/pata_cs5520.c      |    2 +-
 drivers/ata/pata_cs5530.c      |    2 +-
 drivers/ata/pata_cs5535.c      |    2 +-
 drivers/ata/pata_cypress.c     |    2 +-
 drivers/ata/pata_hpt366.c      |   28 +---------------------------
 drivers/ata/pata_hpt37x.c      |   10 +++++-----
 drivers/ata/pata_hpt3x3.c      |    2 +-
 drivers/ata/pata_isapnp.c      |    2 +-
 drivers/ata/pata_it8213.c      |    2 +-
 drivers/ata/pata_ixp4xx_cf.c   |    2 +-
 drivers/ata/pata_jmicron.c     |    2 +-
 drivers/ata/pata_legacy.c      |    2 +-
 drivers/ata/pata_platform.c    |    2 +-
 drivers/ata/pata_qdi.c         |    2 +-
 drivers/ata/pata_rz1000.c      |    2 +-
 drivers/ata/pata_sc1200.c      |    2 +-
 drivers/ata/pata_scc.c         |    2 +-
 drivers/ata/pata_serverworks.c |    2 +-
 drivers/ata/pata_sl82c105.c    |    2 +-
 drivers/ata/pata_winbond.c     |    2 +-
 drivers/ata/pdc_adma.c         |    2 +-
 drivers/ata/sata_inic162x.c    |    2 +-
 drivers/ata/sata_mv.c          |    2 +-
 drivers/ata/sata_nv.c          |    6 +++---
 drivers/ata/sata_qstor.c       |    2 +-
 drivers/ata/sata_sil.c         |    2 +-
 drivers/ata/sata_sil24.c       |    2 +-
 drivers/ata/sata_sis.c         |    2 +-
 drivers/ata/sata_svw.c         |    2 +-
 drivers/ata/sata_sx4.c         |    2 +-
 drivers/ata/sata_uli.c         |    2 +-
 drivers/ata/sata_via.c         |    2 +-
 drivers/ata/sata_vsc.c         |    2 +-
 include/linux/libata.h         |    2 --
 43 files changed, 65 insertions(+), 93 deletions(-)

Alan Cox (3):
      pata_hpt366: Enable bits are unreliable so don't use them
      ata_piix: clean up
      libata: Kiss post_set_mode goodbye

Dave Jones (1):
      libata: Add Seagate STT20000A to DMA blacklist.

Jeff Garzik (2):
      libata: Trim trailing whitespace
      libata: bump versions

Tejun Heo (1):
      ahci: disable 64bit dma on sb600

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ad1f59c..b4a8d60 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -132,7 +132,7 @@ config SATA_SIS
 	depends on PCI
 	select PATA_SIS
 	help
-	  This option enables support for SiS Serial ATA on 
+	  This option enables support for SiS Serial ATA on
 	  SiS 964/965/966/180 and Parallel ATA on SiS 180.
 	  The PATA support for SiS 180 requires additionally to
 	  enable the PATA_SIS driver in the config.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e00e1b9..7baeaff 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -46,7 +46,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"ahci"
-#define DRV_VERSION	"2.1"
+#define DRV_VERSION	"2.2"
 
 
 enum {
@@ -170,6 +170,7 @@ enum {
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
 	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
+	AHCI_FLAG_32BIT_ONLY		= (1 << 28), /* force 32bit */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
@@ -354,7 +355,8 @@ static const struct ata_port_info ahci_port_info[] = {
 	/* board_ahci_sb600 */
 	{
 		.flags		= AHCI_FLAG_COMMON |
-				  AHCI_FLAG_IGN_SERR_INTERNAL,
+				  AHCI_FLAG_IGN_SERR_INTERNAL |
+				  AHCI_FLAG_32BIT_ONLY,
 		.pio_mask	= 0x1f, /* pio0-4 */
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
@@ -492,6 +494,13 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	hpriv->saved_cap = cap = readl(mmio + HOST_CAP);
 	hpriv->saved_port_map = port_map = readl(mmio + HOST_PORTS_IMPL);
 
+	/* some chips lie about 64bit support */
+	if ((cap & HOST_CAP_64) && (pi->flags & AHCI_FLAG_32BIT_ONLY)) {
+		dev_printk(KERN_INFO, &pdev->dev,
+			   "controller can't do 64bit DMA, forcing 32bit\n");
+		cap &= ~HOST_CAP_64;
+	}
+
 	/* fixup zero port_map */
 	if (!port_map) {
 		port_map = (1 << ahci_nr_ports(hpriv->cap)) - 1;
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index c3d7532..7565f02 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "ata_generic"
-#define DRV_VERSION "0.2.11"
+#define DRV_VERSION "0.2.12"
 
 /*
  *	A generic parallel ATA driver using libata
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 13b6b1d..0458811 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -155,7 +155,6 @@ struct piix_host_priv {
 static int piix_init_one (struct pci_dev *pdev,
 				    const struct pci_device_id *ent);
 static void piix_pata_error_handler(struct ata_port *ap);
-static void piix_sata_error_handler(struct ata_port *ap);
 static void piix_set_piomode (struct ata_port *ap, struct ata_device *adev);
 static void piix_set_dmamode (struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode (struct ata_port *ap, struct ata_device *adev);
@@ -364,7 +363,7 @@ static const struct ata_port_operations piix_sata_ops = {
 
 	.freeze			= ata_bmdma_freeze,
 	.thaw			= ata_bmdma_thaw,
-	.error_handler		= piix_sata_error_handler,
+	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
 	.irq_handler		= ata_interrupt,
@@ -641,12 +640,6 @@ static void piix_pata_error_handler(struct ata_port *ap)
 			   ata_std_postreset);
 }
 
-static void piix_sata_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset, NULL,
-			   ata_std_postreset);
-}
-
 /**
  *	piix_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d3ea7f5..a6de57e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -59,7 +59,7 @@
 
 #include "libata.h"
 
-#define DRV_VERSION	"2.20"	/* must be exactly four chars */
+#define DRV_VERSION	"2.21"	/* must be exactly four chars */
 
 
 /* debounce timing parameters in msecs { interval, duration, timeout } */
@@ -977,7 +977,7 @@ static u64 ata_hpa_resize(struct ata_device *dev)
 {
 	u64 sectors = dev->n_sectors;
 	u64 hpa_sectors;
-	
+
 	if (ata_id_has_lba48(dev->id))
 		hpa_sectors = ata_read_native_max_address_ext(dev);
 	else
@@ -1588,7 +1588,7 @@ unsigned int ata_do_simple_cmd(struct ata_device *dev, u8 cmd)
  *	Check if the current speed of the device requires IORDY. Used
  *	by various controllers for chip configuration.
  */
- 
+
 unsigned int ata_pio_need_iordy(const struct ata_device *adev)
 {
 	/* Controller doesn't support  IORDY. Probably a pointless check
@@ -1611,7 +1611,7 @@ unsigned int ata_pio_need_iordy(const struct ata_device *adev)
  *	Compute the highest mode possible if we are not using iordy. Return
  *	-1 if no iordy mode is available.
  */
- 
+
 static u32 ata_pio_mask_no_iordy(const struct ata_device *adev)
 {
 	/* If we have no drive specific rule, then PIO 2 is non IORDY */
@@ -2663,7 +2663,7 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 		t->active += (t->cycle - (t->active + t->recover)) / 2;
 		t->recover = t->cycle - t->active;
 	}
-	
+
 	/* In a few cases quantisation may produce enough errors to
 	   leave t->cycle too low for the sum of active and recovery
 	   if so we must correct this */
@@ -2893,9 +2893,6 @@ int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
 	if (used_dma && (ap->host->flags & ATA_HOST_SIMPLEX))
 		ap->host->simplex_claimed = ap;
 
-	/* step5: chip specific finalisation */
-	if (ap->ops->post_set_mode)
-		ap->ops->post_set_mode(ap);
  out:
 	if (rc)
 		*r_failed_dev = dev;
@@ -3771,6 +3768,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "ATAPI CD-ROM DRIVE 40X MAXIMUM",NULL,ATA_HORKAGE_NODMA },
 	{ "_NEC DV5800A", 	NULL,		ATA_HORKAGE_NODMA },
 	{ "SAMSUNG CD-ROM SN-124","N001",	ATA_HORKAGE_NODMA },
+	{ "Seagate STT20000A", NULL,		ATA_HORKAGE_NODMA },
 
 	/* Weird ATAPI devices */
 	{ "TORiSAN DVD-ROM DRD-N216", NULL,	ATA_HORKAGE_MAX_SEC_128 |
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5309c31..d807098 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1009,7 +1009,7 @@ static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 	sense_buf[0] = 0x70;
 	sense_buf[2] = qc->result_tf.feature >> 4;
 
-	/* some devices time out if garbage left in tf */ 
+	/* some devices time out if garbage left in tf */
 	ata_tf_init(dev, &tf);
 
 	memset(cdb, 0, ATAPI_CDB_LEN);
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index 9861059..7b4810c 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -28,7 +28,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_artop"
-#define DRV_VERSION	"0.4.2"
+#define DRV_VERSION	"0.4.3"
 
 /*
  *	The ARTOP has 33 Mhz and "over clocked" timing tables. Until we
@@ -99,7 +99,7 @@ static int artop6260_pre_reset(struct ata_port *ap, unsigned long deadline)
  *
  *	Identify the cable type for the ARTOp interface in question
  */
- 
+
 static int artop6260_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index ed00fa9..31cbf8d 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -107,7 +107,7 @@ static void cmd640_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_byte(pdev, arttim + 1, (t.active << 4) | t.recover);
 	} else {
 		/* Save the shared timings for channel, they will be loaded
-		   by qc_issue_prot. Reloading the setup time is expensive 
+		   by qc_issue_prot. Reloading the setup time is expensive
 		   so we keep a merged one loaded */
 		pci_read_config_byte(pdev, ARTIM23, &reg);
 		reg &= 0x3F;
@@ -231,7 +231,7 @@ static void cmd640_hardware_init(struct pci_dev *pdev)
 	pci_write_config_byte(pdev, CMDTIM, 0);
 	/* 512 byte bursts (sector) */
 	pci_write_config_byte(pdev, BRST, 0x40);
-	/* 
+	/*
 	 * A reporter a long time ago
 	 * Had problems with the data fifo
 	 * So don't run the risk
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 2a79b33..320a5b1 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -31,7 +31,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cmd64x"
-#define DRV_VERSION "0.2.2"
+#define DRV_VERSION "0.2.3"
 
 /*
  * CMD64x specific registers definition.
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 83bcc5b..1aabe15 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -41,7 +41,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_cs5520"
-#define DRV_VERSION	"0.6.4"
+#define DRV_VERSION	"0.6.5"
 
 struct pio_clocks
 {
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 1b67923..848f030 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -35,7 +35,7 @@
 #include <linux/dmi.h>
 
 #define DRV_NAME	"pata_cs5530"
-#define DRV_VERSION	"0.7.2"
+#define DRV_VERSION	"0.7.3"
 
 static void __iomem *cs5530_port_base(struct ata_port *ap)
 {
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index f37d4cd..aa3256f 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -39,7 +39,7 @@
 #include <asm/msr.h>
 
 #define DRV_NAME	"cs5535"
-#define DRV_VERSION	"0.2.11"
+#define DRV_VERSION	"0.2.12"
 
 /*
  *	The Geode (Aka Athlon GX now) uses an internal MSR based
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 27b9f29..d41a769 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -18,7 +18,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_cypress"
-#define DRV_VERSION "0.1.4"
+#define DRV_VERSION "0.1.5"
 
 /* here are the offset definitions for the registers */
 
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index c6c8a8b..0c9cb60 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -220,32 +220,6 @@ static int hpt36x_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
-static int hpt36x_pre_reset(struct ata_port *ap, unsigned long deadline)
-{
-	static const struct pci_bits hpt36x_enable_bits[] = {
-		{ 0x50, 1, 0x04, 0x04 },
-		{ 0x54, 1, 0x04, 0x04 }
-	};
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (!pci_test_config_bits(pdev, &hpt36x_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_std_prereset(ap, deadline);
-}
-
-/**
- *	hpt36x_error_handler	-	reset the hpt36x bus
- *	@ap: ATA port to reset
- *
- *	Perform the reset handling for the 366/368
- */
-
-static void hpt36x_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, hpt36x_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 /**
  *	hpt366_set_piomode		-	PIO setup
  *	@ap: ATA interface
@@ -351,7 +325,7 @@ static struct ata_port_operations hpt366_port_ops = {
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= hpt36x_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
 	.cable_detect	= hpt36x_cable_detect,
 
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 5a0a410..a54c174 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -961,7 +961,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	u8 mcr1;
 	u32 freq;
 	int prefer_dpll = 1;
-	
+
 	unsigned long iobase = pci_resource_start(dev, 4);
 
 	const struct hpt_chip *chip_table;
@@ -1055,7 +1055,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	 */
 
 	pci_write_config_byte(dev, 0x5b, 0x23);
-	
+
 	/*
 	 * HighPoint does this for HPT372A.
 	 * NOTE: This register is only writeable via I/O space.
@@ -1088,7 +1088,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	 *	Turn the frequency check into a band and then find a timing
 	 *	table to match it.
 	 */
-	 
+
 	clock_slot = hpt37x_clock_slot(freq, chip_table->base);
 	if (chip_table->clocks[clock_slot] == NULL || prefer_dpll) {
 		/*
@@ -1099,11 +1099,11 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		 */
 		unsigned int f_low, f_high;
 		int adjust;
-		
+
 		clock_slot = 2;
 		if (port->udma_mask & 0xE0)
 			clock_slot = 3;
-		
+
 		f_low = (MHz[clock_slot] * chip_table->base) / 192;
 		f_high = f_low + 2;
 
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index bbabe79..8ce5e23 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -23,7 +23,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x3"
-#define DRV_VERSION	"0.4.2"
+#define DRV_VERSION	"0.4.3"
 
 /**
  *	hpt3x3_set_piomode		-	PIO setup
diff --git a/drivers/ata/pata_isapnp.c b/drivers/ata/pata_isapnp.c
index d042efd..1f647b6 100644
--- a/drivers/ata/pata_isapnp.c
+++ b/drivers/ata/pata_isapnp.c
@@ -17,7 +17,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_isapnp"
-#define DRV_VERSION "0.2.0"
+#define DRV_VERSION "0.2.1"
 
 static struct scsi_host_template isapnp_sht = {
 	.module			= THIS_MODULE,
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index a769952..95b0bb6 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -19,7 +19,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_it8213"
-#define DRV_VERSION	"0.0.2"
+#define DRV_VERSION	"0.0.3"
 
 /**
  *	it8213_pre_reset	-	check for 40/80 pin
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index b994351..8d2bc1e 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -23,7 +23,7 @@
 #include <scsi/scsi_host.h>
 
 #define DRV_NAME	"pata_ixp4xx_cf"
-#define DRV_VERSION	"0.1.2"
+#define DRV_VERSION	"0.1.3"
 
 static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device **error)
 {
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 8d799e8..2af7ff8 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -19,7 +19,7 @@
 #include <linux/ata.h>
 
 #define DRV_NAME	"pata_jmicron"
-#define DRV_VERSION	"0.1.4"
+#define DRV_VERSION	"0.1.5"
 
 typedef enum {
 	PORT_PATA0 = 0,
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 7070992..edffc25 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -64,7 +64,7 @@
 #include <linux/platform_device.h>
 
 #define DRV_NAME "pata_legacy"
-#define DRV_VERSION "0.5.4"
+#define DRV_VERSION "0.5.5"
 
 #define NR_HOST 6
 
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index 1f63848..cbb7866 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -22,7 +22,7 @@
 #include <linux/pata_platform.h>
 
 #define DRV_NAME "pata_platform"
-#define DRV_VERSION "0.1.2"
+#define DRV_VERSION "1.0"
 
 static int pio_mask = 1;
 
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index fb8c9e1..1998c19 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -26,7 +26,7 @@
 #include <linux/platform_device.h>
 
 #define DRV_NAME "pata_qdi"
-#define DRV_VERSION "0.3.0"
+#define DRV_VERSION "0.3.1"
 
 #define NR_HOST 4	/* Two 6580s */
 
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 2bfd7ef..a3488b4 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -21,7 +21,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_rz1000"
-#define DRV_VERSION	"0.2.3"
+#define DRV_VERSION	"0.2.4"
 
 
 /**
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 225013e..1233063 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -40,7 +40,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sc1200"
-#define DRV_VERSION	"0.2.4"
+#define DRV_VERSION	"0.2.5"
 
 #define SC1200_REV_A	0x00
 #define SC1200_REV_B1	0x01
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 844e53b..aa138d2 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -43,7 +43,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME		"pata_scc"
-#define DRV_VERSION		"0.1"
+#define DRV_VERSION		"0.2"
 
 #define PCI_DEVICE_ID_TOSHIBA_SCC_ATA		0x01b4
 
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index dee6e21..1e8f421 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -41,7 +41,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_serverworks"
-#define DRV_VERSION "0.4.0"
+#define DRV_VERSION "0.4.1"
 
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index f48491a..e5aaec4 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sl82c105"
-#define DRV_VERSION "0.3.0"
+#define DRV_VERSION "0.3.1"
 
 enum {
 	/*
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index cc4ad27..83abfec 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -16,7 +16,7 @@
 #include <linux/platform_device.h>
 
 #define DRV_NAME "pata_winbond"
-#define DRV_VERSION "0.0.2"
+#define DRV_VERSION "0.0.3"
 
 #define NR_HOST 4	/* Two winbond controllers, two channels each */
 
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index 52b6953..f12c2b6 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -44,7 +44,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pdc_adma"
-#define DRV_VERSION	"0.05"
+#define DRV_VERSION	"0.06"
 
 /* macro to calculate base address for ATA regs */
 #define ADMA_ATA_REGS(base,port_no)	((base) + ((port_no) * 0x40))
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index bda5e77..2d80c9d 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -28,7 +28,7 @@
 #include <scsi/scsi_device.h>
 
 #define DRV_NAME	"sata_inic162x"
-#define DRV_VERSION	"0.1"
+#define DRV_VERSION	"0.2"
 
 enum {
 	MMIO_BAR		= 5,
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index cb9b9ac..705a020 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -35,7 +35,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_mv"
-#define DRV_VERSION	"0.8"
+#define DRV_VERSION	"0.81"
 
 enum {
 	/* BAR's are enumerated in terms of pci_resource_start() terms */
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 1a49c77..adfa693 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -49,7 +49,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME			"sata_nv"
-#define DRV_VERSION			"3.3"
+#define DRV_VERSION			"3.4"
 
 #define NV_ADMA_DMA_BOUNDARY		0xffffffffUL
 
@@ -802,7 +802,7 @@ static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
 			u16 status;
 			u32 gen_ctl;
 			u32 notifier, notifier_error;
-			
+
 			/* if ADMA is disabled, use standard ata interrupt handler */
 			if (pp->flags & NV_ADMA_ATAPI_SETUP_COMPLETE) {
 				u8 irq_stat = readb(host->iomap[NV_MMIO_BAR] + NV_INT_STATUS_CK804)
@@ -963,7 +963,7 @@ static void nv_adma_irq_clear(struct ata_port *ap)
 
 	/* clear ADMA status */
 	writew(0xffff, mmio + NV_ADMA_STAT);
-	
+
 	/* clear notifiers - note both ports need to be written with
 	   something even though we are only clearing on one */
 	if (ap->port_no == 0) {
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index f5a05de..6688ccb 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -39,7 +39,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_qstor"
-#define DRV_VERSION	"0.07"
+#define DRV_VERSION	"0.08"
 
 enum {
 	QS_MMIO_BAR		= 4,
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index e8483aa..a3b339b 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -305,7 +305,7 @@ static int sil_set_mode (struct ata_port *ap, struct ata_device **r_failed)
 	u32 tmp, dev_mode[2];
 	unsigned int i;
 	int rc;
-	
+
 	rc = ata_do_set_mode(ap, r_failed);
 	if (rc)
 		return rc;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 0cb6618..0ddfae9 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -30,7 +30,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_sil24"
-#define DRV_VERSION	"0.8"
+#define DRV_VERSION	"0.9"
 
 /*
  * Port request block (PRB) 32 bytes
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index ee66c5f..51d9251 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -43,7 +43,7 @@
 #include "sis.h"
 
 #define DRV_NAME	"sata_sis"
-#define DRV_VERSION	"0.7"
+#define DRV_VERSION	"0.8"
 
 enum {
 	sis_180			= 0,
diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
index 1724673..bcb2cd8 100644
--- a/drivers/ata/sata_svw.c
+++ b/drivers/ata/sata_svw.c
@@ -53,7 +53,7 @@
 #endif /* CONFIG_PPC_OF */
 
 #define DRV_NAME	"sata_svw"
-#define DRV_VERSION	"2.1"
+#define DRV_VERSION	"2.2"
 
 enum {
 	/* ap->flags bits */
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 3a4f445..2d14f3d 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -44,7 +44,7 @@
 #include "sata_promise.h"
 
 #define DRV_NAME	"sata_sx4"
-#define DRV_VERSION	"0.10"
+#define DRV_VERSION	"0.11"
 
 
 enum {
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index 006f5e3..6815de7 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -36,7 +36,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_uli"
-#define DRV_VERSION	"1.1"
+#define DRV_VERSION	"1.2"
 
 enum {
 	uli_5289		= 0,
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index ac4f43c..01bba26 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -46,7 +46,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_via"
-#define DRV_VERSION	"2.1"
+#define DRV_VERSION	"2.2"
 
 enum board_ids_enum {
 	vt6420,
diff --git a/drivers/ata/sata_vsc.c b/drivers/ata/sata_vsc.c
index 80126f8..8133017 100644
--- a/drivers/ata/sata_vsc.c
+++ b/drivers/ata/sata_vsc.c
@@ -47,7 +47,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_vsc"
-#define DRV_VERSION	"2.1"
+#define DRV_VERSION	"2.2"
 
 enum {
 	VSC_MMIO_BAR			= 0,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 666592e..85f7b1b 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -574,8 +574,6 @@ struct ata_port_operations {
 	void (*phy_reset) (struct ata_port *ap); /* obsolete */
 	int  (*set_mode) (struct ata_port *ap, struct ata_device **r_failed_dev);
 
-	void (*post_set_mode) (struct ata_port *ap);
-
 	int (*cable_detect) (struct ata_port *ap);
 
 	int  (*check_atapi_dma) (struct ata_queued_cmd *qc);
