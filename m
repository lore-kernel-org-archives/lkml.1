Return-Path: <linux-kernel-owner+w=401wt.eu-S932161AbYAYXSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbYAYXSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762140AbYAYXRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:17:33 -0500
Received: from havoc.gtf.org ([69.61.125.42]:42339 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbYAYXQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:16:19 -0500
Date: Fri, 25 Jan 2008 18:16:17 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20080125231617.GA6853@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Honestly, this is the least interesting merge push I've had in a while.
We're all doing debugging and such, so nothing major is below.

I have some queued stuff (notably a sata_mv update) still to come, but
this is the stuff that's been pending and in -mm for a while.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig             |    9 +
 drivers/ata/Makefile            |    1 +
 drivers/ata/ahci.c              |   72 ++--
 drivers/ata/ata_generic.c       |   51 ++-
 drivers/ata/ata_piix.c          |  393 ++++++++++++++----
 drivers/ata/libata-acpi.c       |  117 ++++--
 drivers/ata/libata-core.c       |  805 ++++++++++++++++------------------
 drivers/ata/libata-eh.c         |  299 ++++++++++---
 drivers/ata/libata-scsi.c       |   40 ++-
 drivers/ata/libata-sff.c        |  199 +++++----
 drivers/ata/libata.h            |    6 +-
 drivers/ata/pata_acpi.c         |   67 +---
 drivers/ata/pata_ali.c          |    2 +-
 drivers/ata/pata_amd.c          |  128 ++++--
 drivers/ata/pata_bf54x.c        |   41 +-
 drivers/ata/pata_cs5520.c       |    2 +-
 drivers/ata/pata_hpt37x.c       |    7 +-
 drivers/ata/pata_icside.c       |    3 +-
 drivers/ata/pata_it821x.c       |   35 ++-
 drivers/ata/pata_ixp4xx_cf.c    |   26 +-
 drivers/ata/pata_legacy.c       |  912 +++++++++++++++++++++++++++++++--------
 drivers/ata/pata_mpc52xx.c      |    2 +-
 drivers/ata/pata_ninja32.c      |  214 +++++++++
 drivers/ata/pata_pcmcia.c       |  101 ++++-
 drivers/ata/pata_pdc2027x.c     |    2 +-
 drivers/ata/pata_pdc202xx_old.c |    5 +-
 drivers/ata/pata_qdi.c          |   30 +-
 drivers/ata/pata_scc.c          |   30 +-
 drivers/ata/pata_serverworks.c  |    9 +-
 drivers/ata/pata_via.c          |    3 +-
 drivers/ata/pata_winbond.c      |   30 +-
 drivers/ata/pdc_adma.c          |    5 +-
 drivers/ata/sata_fsl.c          |    5 +-
 drivers/ata/sata_inic162x.c     |    2 +-
 drivers/ata/sata_mv.c           |    3 +-
 drivers/ata/sata_nv.c           |   25 +-
 drivers/ata/sata_promise.c      |   98 ++---
 drivers/ata/sata_promise.h      |    2 +-
 drivers/ata/sata_qstor.c        |   15 +-
 drivers/ata/sata_sil.c          |   10 +-
 drivers/ata/sata_sil24.c        |   30 +-
 drivers/ata/sata_sx4.c          |   15 +-
 drivers/scsi/ipr.c              |    9 +-
 drivers/scsi/libsas/sas_ata.c   |   14 +-
 include/linux/ata.h             |  110 ++++-
 include/linux/cdrom.h           |    3 +
 include/linux/libata.h          |  184 +++++---
 include/linux/pci_ids.h         |    3 +
 48 files changed, 2851 insertions(+), 1323 deletions(-)
 create mode 100644 drivers/ata/pata_ninja32.c

Al Viro (1):
      libata annotations and fixes

Alan Cox (13):
      libata: Disable ATA8-ACS proposed Trusted Computing features by default
      libata: IORDY handling
      libata-sff: tf_load
      pata_ninja32: Cardbus ATA initial support
      pata_pcmcia: Add support for dumb 8bit IDE emulations
      libata/pata_it821x: Improve handling of poorly compatible emulations
      pata_pcmcia: Minor cleanups and support for dual channel cards
      pata_legacy: resychronize with upstream changes and resubmit
      pata_mpc52xx: remove un-needed assignment
      pata_serverworks: Fix cable types and cosmetics
      pata_winbond: error return
      ata_generic: Cenatek support
      pata_legacy: Merge winbond support

Albert Lee (1):
      libata: zero xfer length on ATAPI data xfer IRQ is HSM violation

Andrew Morton (4):
      drivers/ata/libata-eh.c: fix printk warning
      pata_hpt37x: checkpatch fixes
      [libata] pata_winbond: update for new ->data_xfer hook
      [libata] pata_legacy: typo fix

James Bottomley (1):
      [libata] Prefer SCSI_SENSE_BUFFERSIZE to sizeof()

Jeff Garzik (3):
      libata: checkpatch fixes
      [libata] Build fix WRT ata_is_xxx() new API introduction
      libata: make ata_port_queue_task() an internal function

Peter Schwenke (1):
      ata_piix: Add Toshiba Satellite R20 and Tecra M6 to broken suspend list.

Shaohua Li (1):
      libata-acpi: add ACPI _PSx method

Tejun Heo (40):
      ahci: update PCS programming
      libata: rearrange ATA_DFLAG_*
      libata: implement protocol tests
      libata: factor out ata_eh_schedule_probe()
      libata: move ata_set_mode() to libata-eh.c
      libata: clean up EH speed down implementation
      libata: adjust speed down rules
      libata: implement ATA_DFLAG_DUBIOUS_XFER
      libata: implement fast speed down for unverified data transfer mode
      ata_generic: unindent loop in generic_set_mode()
      libata: export xfermode / PATA timing related functions
      libata: clean up xfermode / PATA timing related stuff
      libata: kill ata_id_to_dma_mode()
      libata: xfer_mask is unsigned long not unsigned int
      libata: add ATA_CBL_PATA_IGN
      sata_promise: make pdc_atapi_pkt() use values from qc->tf
      ata_piix: separate controller IDs into separate enum
      libata: separate out ata_acpi_gtm_xfermask() from pacpi_discover_modes()
      libata: fix ata_acpi_gtm_xfermask()
      libata: implement ata_timing_cycle2mode() and use it in libata-acpi and pata_acpi
      libata: reimplement ata_acpi_cbl_80wire() using ata_acpi_gtm_xfermask()
      pata_amd: update mode selection for NV PATAs
      libata: convert NCQ test in ata_qc_issue() to ata_is_ncq()
      libata: make atapi_request_sense() use sg
      cdrom: add more GPCMD_* constants
      libata: rename ATA_PROT_ATAPI_* to ATAPI_PROT_*
      libata: add ATAPI_* cmd types and implement atapi_cmd_type()
      libata: update ->data_xfer hook for ATAPI
      libata: kill non-sg DMA interface
      libata: change ATA_QCFLAG_DMAMAP semantics
      libata: convert to chained sg
      libata: make qc->nbytes include extra buffers
      ata_piix: kill unused constants and flags
      libata: use dev_driver_string() instead of "libata" in libata-sff.c
      pata_pcmcia: convert to new data_xfer prototype
      libata: factor out ata_pci_activate_sff_host() from ata_pci_one()
      ata_piix: convert to prepare - activate initialization
      ata_piix: implement SIDPR SCR access
      ahci: factor out AHCI enabling and enable AHCI before reading CAP
      libata: fix off-by-one in error categorization

akpm@linux-foundation.org (2):
      [libata] Prefer SCSI_SENSE_BUFFERSIZE to sizeof()
      fix drivers/ata/sata_fsl.c double-decl

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ba63619..2478cca 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -459,6 +459,15 @@ config PATA_NETCELL
 
 	  If unsure, say N.
 
+config PATA_NINJA32
+	tristate "Ninja32/Delkin Cardbus ATA support (Experimental)"
+	depends on PCI && EXPERIMENTAL
+	help
+	  This option enables support for the Ninja32, Delkin and
+	  possibly other brands of Cardbus ATA adapter
+
+	  If unsure, say N.
+
 config PATA_NS87410
 	tristate "Nat Semi NS87410 PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index b13feb2..82550c1 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_PATA_IT821X)	+= pata_it821x.o
 obj-$(CONFIG_PATA_IT8213)	+= pata_it8213.o
 obj-$(CONFIG_PATA_JMICRON)	+= pata_jmicron.o
 obj-$(CONFIG_PATA_NETCELL)	+= pata_netcell.o
+obj-$(CONFIG_PATA_NINJA32)	+= pata_ninja32.o
 obj-$(CONFIG_PATA_NS87410)	+= pata_ns87410.o
 obj-$(CONFIG_PATA_NS87415)	+= pata_ns87415.o
 obj-$(CONFIG_PATA_OPTI)		+= pata_opti.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 54f38c2..6f089b8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -198,18 +198,18 @@ enum {
 };
 
 struct ahci_cmd_hdr {
-	u32			opts;
-	u32			status;
-	u32			tbl_addr;
-	u32			tbl_addr_hi;
-	u32			reserved[4];
+	__le32			opts;
+	__le32			status;
+	__le32			tbl_addr;
+	__le32			tbl_addr_hi;
+	__le32			reserved[4];
 };
 
 struct ahci_sg {
-	u32			addr;
-	u32			addr_hi;
-	u32			reserved;
-	u32			flags_size;
+	__le32			addr;
+	__le32			addr_hi;
+	__le32			reserved;
+	__le32			flags_size;
 };
 
 struct ahci_host_priv {
@@ -597,6 +597,20 @@ static inline void __iomem *ahci_port_base(struct ata_port *ap)
 	return __ahci_port_base(ap->host, ap->port_no);
 }
 
+static void ahci_enable_ahci(void __iomem *mmio)
+{
+	u32 tmp;
+
+	/* turn on AHCI_EN */
+	tmp = readl(mmio + HOST_CTL);
+	if (!(tmp & HOST_AHCI_EN)) {
+		tmp |= HOST_AHCI_EN;
+		writel(tmp, mmio + HOST_CTL);
+		tmp = readl(mmio + HOST_CTL);	/* flush && sanity check */
+		WARN_ON(!(tmp & HOST_AHCI_EN));
+	}
+}
+
 /**
  *	ahci_save_initial_config - Save and fixup initial config values
  *	@pdev: target PCI device
@@ -619,6 +633,9 @@ static void ahci_save_initial_config(struct pci_dev *pdev,
 	u32 cap, port_map;
 	int i;
 
+	/* make sure AHCI mode is enabled before accessing CAP */
+	ahci_enable_ahci(mmio);
+
 	/* Values prefixed with saved_ are written back to host after
 	 * reset.  Values without are used for driver operation.
 	 */
@@ -1036,19 +1053,17 @@ static int ahci_deinit_port(struct ata_port *ap, const char **emsg)
 static int ahci_reset_controller(struct ata_host *host)
 {
 	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = host->iomap[AHCI_PCI_BAR];
 	u32 tmp;
 
 	/* we must be in AHCI mode, before using anything
 	 * AHCI-specific, such as HOST_RESET.
 	 */
-	tmp = readl(mmio + HOST_CTL);
-	if (!(tmp & HOST_AHCI_EN)) {
-		tmp |= HOST_AHCI_EN;
-		writel(tmp, mmio + HOST_CTL);
-	}
+	ahci_enable_ahci(mmio);
 
 	/* global controller reset */
+	tmp = readl(mmio + HOST_CTL);
 	if ((tmp & HOST_RESET) == 0) {
 		writel(tmp | HOST_RESET, mmio + HOST_CTL);
 		readl(mmio + HOST_CTL); /* flush */
@@ -1067,8 +1082,7 @@ static int ahci_reset_controller(struct ata_host *host)
 	}
 
 	/* turn on AHCI mode */
-	writel(HOST_AHCI_EN, mmio + HOST_CTL);
-	(void) readl(mmio + HOST_CTL);	/* flush */
+	ahci_enable_ahci(mmio);
 
 	/* some registers might be cleared on reset.  restore initial values */
 	ahci_restore_initial_config(host);
@@ -1078,8 +1092,10 @@ static int ahci_reset_controller(struct ata_host *host)
 
 		/* configure PCS */
 		pci_read_config_word(pdev, 0x92, &tmp16);
-		tmp16 |= 0xf;
-		pci_write_config_word(pdev, 0x92, tmp16);
+		if ((tmp16 & hpriv->port_map) != hpriv->port_map) {
+			tmp16 |= hpriv->port_map;
+			pci_write_config_word(pdev, 0x92, tmp16);
+		}
 	}
 
 	return 0;
@@ -1480,35 +1496,31 @@ static void ahci_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
 {
 	struct scatterlist *sg;
-	struct ahci_sg *ahci_sg;
-	unsigned int n_sg = 0;
+	struct ahci_sg *ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
+	unsigned int si;
 
 	VPRINTK("ENTER\n");
 
 	/*
 	 * Next, the S/G list.
 	 */
-	ahci_sg = cmd_tbl + AHCI_CMD_TBL_HDR_SZ;
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		dma_addr_t addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
 
-		ahci_sg->addr = cpu_to_le32(addr & 0xffffffff);
-		ahci_sg->addr_hi = cpu_to_le32((addr >> 16) >> 16);
-		ahci_sg->flags_size = cpu_to_le32(sg_len - 1);
-
-		ahci_sg++;
-		n_sg++;
+		ahci_sg[si].addr = cpu_to_le32(addr & 0xffffffff);
+		ahci_sg[si].addr_hi = cpu_to_le32((addr >> 16) >> 16);
+		ahci_sg[si].flags_size = cpu_to_le32(sg_len - 1);
 	}
 
-	return n_sg;
+	return si;
 }
 
 static void ahci_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ahci_port_priv *pp = ap->private_data;
-	int is_atapi = is_atapi_taskfile(&qc->tf);
+	int is_atapi = ata_is_atapi(qc->tf.protocol);
 	void *cmd_tbl;
 	u32 opts;
 	const u32 cmd_fis_len = 5; /* five dwords */
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 9032998..2053420 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "ata_generic"
-#define DRV_VERSION "0.2.13"
+#define DRV_VERSION "0.2.15"
 
 /*
  *	A generic parallel ATA driver using libata
@@ -48,27 +48,47 @@ static int generic_set_mode(struct ata_link *link, struct ata_device **unused)
 	struct ata_port *ap = link->ap;
 	int dma_enabled = 0;
 	struct ata_device *dev;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	/* Bits 5 and 6 indicate if DMA is active on master/slave */
 	if (ap->ioaddr.bmdma_addr)
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
+	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
+		dma_enabled = 0xFF;
+
 	ata_link_for_each_dev(dev, link) {
-		if (ata_dev_enabled(dev)) {
-			/* We don't really care */
-			dev->pio_mode = XFER_PIO_0;
-			dev->dma_mode = XFER_MW_DMA_0;
-			/* We do need the right mode information for DMA or PIO
-			   and this comes from the current configuration flags */
-			if (dma_enabled & (1 << (5 + dev->devno))) {
-				ata_id_to_dma_mode(dev, XFER_MW_DMA_0);
-				dev->flags &= ~ATA_DFLAG_PIO;
-			} else {
-				ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
-				dev->xfer_mode = XFER_PIO_0;
-				dev->xfer_shift = ATA_SHIFT_PIO;
-				dev->flags |= ATA_DFLAG_PIO;
+		if (!ata_dev_enabled(dev))
+			continue;
+
+		/* We don't really care */
+		dev->pio_mode = XFER_PIO_0;
+		dev->dma_mode = XFER_MW_DMA_0;
+		/* We do need the right mode information for DMA or PIO
+		   and this comes from the current configuration flags */
+		if (dma_enabled & (1 << (5 + dev->devno))) {
+			unsigned int xfer_mask = ata_id_xfermask(dev->id);
+			const char *name;
+
+			if (xfer_mask & (ATA_MASK_MWDMA | ATA_MASK_UDMA))
+				name = ata_mode_string(xfer_mask);
+			else {
+				/* SWDMA perhaps? */
+				name = "DMA";
+				xfer_mask |= ata_xfer_mode2mask(XFER_MW_DMA_0);
 			}
+
+			ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
+				       name);
+
+			dev->xfer_mode = ata_xfer_mask2mode(xfer_mask);
+			dev->xfer_shift = ata_xfer_mode2shift(dev->xfer_mode);
+			dev->flags &= ~ATA_DFLAG_PIO;
+		} else {
+			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			dev->xfer_mode = XFER_PIO_0;
+			dev->xfer_shift = ATA_SHIFT_PIO;
+			dev->flags |= ATA_DFLAG_PIO;
 		}
 	}
 	return 0;
@@ -185,6 +205,7 @@ static struct pci_device_id ata_generic[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b406b39..a65c8ae 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -101,39 +101,21 @@ enum {
 	ICH5_PMR		= 0x90, /* port mapping register */
 	ICH5_PCS		= 0x92,	/* port control and status */
 	PIIX_SCC		= 0x0A, /* sub-class code register */
+	PIIX_SIDPR_BAR		= 5,
+	PIIX_SIDPR_LEN		= 16,
+	PIIX_SIDPR_IDX		= 0,
+	PIIX_SIDPR_DATA		= 4,
 
-	PIIX_FLAG_SCR		= (1 << 26), /* SCR available */
 	PIIX_FLAG_AHCI		= (1 << 27), /* AHCI possible */
 	PIIX_FLAG_CHECKINTR	= (1 << 28), /* make sure PCI INTx enabled */
+	PIIX_FLAG_SIDPR		= (1 << 29), /* SATA idx/data pair regs */
 
 	PIIX_PATA_FLAGS		= ATA_FLAG_SLAVE_POSS,
 	PIIX_SATA_FLAGS		= ATA_FLAG_SATA | PIIX_FLAG_CHECKINTR,
 
-	/* combined mode.  if set, PATA is channel 0.
-	 * if clear, PATA is channel 1.
-	 */
-	PIIX_PORT_ENABLED	= (1 << 0),
-	PIIX_PORT_PRESENT	= (1 << 4),
-
 	PIIX_80C_PRI		= (1 << 5) | (1 << 4),
 	PIIX_80C_SEC		= (1 << 7) | (1 << 6),
 
-	/* controller IDs */
-	piix_pata_mwdma		= 0,	/* PIIX3 MWDMA only */
-	piix_pata_33,			/* PIIX4 at 33Mhz */
-	ich_pata_33,			/* ICH up to UDMA 33 only */
-	ich_pata_66,			/* ICH up to 66 Mhz */
-	ich_pata_100,			/* ICH up to UDMA 100 */
-	ich5_sata,
-	ich6_sata,
-	ich6_sata_ahci,
-	ich6m_sata_ahci,
-	ich8_sata_ahci,
-	ich8_2port_sata,
-	ich8m_apple_sata_ahci,		/* locks up on second port enable */
-	tolapai_sata_ahci,
-	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
-
 	/* constants for mapping table */
 	P0			= 0,  /* port 0 */
 	P1			= 1,  /* port 1 */
@@ -149,6 +131,24 @@ enum {
 	PIIX_HOST_BROKEN_SUSPEND = (1 << 24),
 };
 
+enum piix_controller_ids {
+	/* controller IDs */
+	piix_pata_mwdma,	/* PIIX3 MWDMA only */
+	piix_pata_33,		/* PIIX4 at 33Mhz */
+	ich_pata_33,		/* ICH up to UDMA 33 only */
+	ich_pata_66,		/* ICH up to 66 Mhz */
+	ich_pata_100,		/* ICH up to UDMA 100 */
+	ich5_sata,
+	ich6_sata,
+	ich6_sata_ahci,
+	ich6m_sata_ahci,
+	ich8_sata_ahci,
+	ich8_2port_sata,
+	ich8m_apple_sata_ahci,	/* locks up on second port enable */
+	tolapai_sata_ahci,
+	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
+};
+
 struct piix_map_db {
 	const u32 mask;
 	const u16 port_enable;
@@ -157,6 +157,7 @@ struct piix_map_db {
 
 struct piix_host_priv {
 	const int *map;
+	void __iomem *sidpr;
 };
 
 static int piix_init_one(struct pci_dev *pdev,
@@ -167,6 +168,9 @@ static void piix_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev);
 static int ich_pata_cable_detect(struct ata_port *ap);
 static u8 piix_vmw_bmdma_status(struct ata_port *ap);
+static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val);
+static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val);
+static void piix_sidpr_error_handler(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -321,7 +325,6 @@ static const struct ata_port_operations piix_pata_ops = {
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.cable_detect		= ata_cable_40wire,
 
-	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
@@ -353,7 +356,6 @@ static const struct ata_port_operations ich_pata_ops = {
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 	.cable_detect		= ich_pata_cable_detect,
 
-	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
@@ -380,7 +382,6 @@ static const struct ata_port_operations piix_sata_ops = {
 	.error_handler		= ata_bmdma_error_handler,
 	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
 
-	.irq_handler		= ata_interrupt,
 	.irq_clear		= ata_bmdma_irq_clear,
 	.irq_on			= ata_irq_on,
 
@@ -419,6 +420,35 @@ static const struct ata_port_operations piix_vmw_ops = {
 	.port_start		= ata_port_start,
 };
 
+static const struct ata_port_operations piix_sidpr_sata_ops = {
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.check_status		= ata_check_status,
+	.exec_command		= ata_exec_command,
+	.dev_select		= ata_std_dev_select,
+
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.data_xfer		= ata_data_xfer,
+
+	.scr_read		= piix_sidpr_scr_read,
+	.scr_write		= piix_sidpr_scr_write,
+
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= piix_sidpr_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+
+	.port_start		= ata_port_start,
+};
+
 static const struct piix_map_db ich5_map_db = {
 	.mask = 0x7,
 	.port_enable = 0x3,
@@ -526,7 +556,6 @@ static const struct piix_map_db *piix_map_db_table[] = {
 static struct ata_port_info piix_port_info[] = {
 	[piix_pata_mwdma] = 	/* PIIX3 MWDMA only */
 	{
-		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
@@ -535,7 +564,6 @@ static struct ata_port_info piix_port_info[] = {
 
 	[piix_pata_33] =	/* PIIX4 at 33MHz */
 	{
-		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x06, /* mwdma1-2 ?? CHECK 0 should be ok but slow */
@@ -545,7 +573,6 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich_pata_33] = 	/* ICH0 - ICH at 33Mhz*/
 	{
-		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask 	= 0x1f,	/* pio 0-4 */
 		.mwdma_mask	= 0x06, /* Check: maybe 0x07  */
@@ -555,7 +582,6 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich_pata_66] = 	/* ICH controllers up to 66MHz */
 	{
-		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS,
 		.pio_mask 	= 0x1f,	/* pio 0-4 */
 		.mwdma_mask	= 0x06, /* MWDMA0 is broken on chip */
@@ -565,7 +591,6 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich_pata_100] =
 	{
-		.sht		= &piix_sht,
 		.flags		= PIIX_PATA_FLAGS | PIIX_FLAG_CHECKINTR,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x06, /* mwdma1-2 */
@@ -575,7 +600,6 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich5_sata] =
 	{
-		.sht		= &piix_sht,
 		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
@@ -585,8 +609,7 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich6_sata] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR,
+		.flags		= PIIX_SATA_FLAGS,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -595,9 +618,7 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich6_sata_ahci] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
-				  PIIX_FLAG_AHCI,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -606,9 +627,7 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich6m_sata_ahci] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
-				  PIIX_FLAG_AHCI,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -617,9 +636,8 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich8_sata_ahci] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
-				  PIIX_FLAG_AHCI,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_AHCI |
+				  PIIX_FLAG_SIDPR,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -628,9 +646,8 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich8_2port_sata] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
-				  PIIX_FLAG_AHCI,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_AHCI |
+				  PIIX_FLAG_SIDPR,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -639,9 +656,7 @@ static struct ata_port_info piix_port_info[] = {
 
 	[tolapai_sata_ahci] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
-				  PIIX_FLAG_AHCI,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_AHCI,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -650,9 +665,8 @@ static struct ata_port_info piix_port_info[] = {
 
 	[ich8m_apple_sata_ahci] =
 	{
-		.sht		= &piix_sht,
-		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SCR |
-				  PIIX_FLAG_AHCI,
+		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_AHCI |
+				  PIIX_FLAG_SIDPR,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma0-2 */
 		.udma_mask	= ATA_UDMA6,
@@ -1001,6 +1015,180 @@ static void ich_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	do_pata_set_dmamode(ap, adev, 1);
 }
 
+/*
+ * Serial ATA Index/Data Pair Superset Registers access
+ *
+ * Beginning from ICH8, there's a sane way to access SCRs using index
+ * and data register pair located at BAR5.  This creates an
+ * interesting problem of mapping two SCRs to one port.
+ *
+ * Although they have separate SCRs, the master and slave aren't
+ * independent enough to be treated as separate links - e.g. softreset
+ * resets both.  Also, there's no protocol defined for hard resetting
+ * singled device sharing the virtual port (no defined way to acquire
+ * device signature).  This is worked around by merging the SCR values
+ * into one sensible value and requesting follow-up SRST after
+ * hardreset.
+ *
+ * SCR merging is perfomed in nibbles which is the unit contents in
+ * SCRs are organized.  If two values are equal, the value is used.
+ * When they differ, merge table which lists precedence of possible
+ * values is consulted and the first match or the last entry when
+ * nothing matches is used.  When there's no merge table for the
+ * specific nibble, value from the first port is used.
+ */
+static const int piix_sidx_map[] = {
+	[SCR_STATUS]	= 0,
+	[SCR_ERROR]	= 2,
+	[SCR_CONTROL]	= 1,
+};
+
+static void piix_sidpr_sel(struct ata_device *dev, unsigned int reg)
+{
+	struct ata_port *ap = dev->link->ap;
+	struct piix_host_priv *hpriv = ap->host->private_data;
+
+	iowrite32(((ap->port_no * 2 + dev->devno) << 8) | piix_sidx_map[reg],
+		  hpriv->sidpr + PIIX_SIDPR_IDX);
+}
+
+static int piix_sidpr_read(struct ata_device *dev, unsigned int reg)
+{
+	struct piix_host_priv *hpriv = dev->link->ap->host->private_data;
+
+	piix_sidpr_sel(dev, reg);
+	return ioread32(hpriv->sidpr + PIIX_SIDPR_DATA);
+}
+
+static void piix_sidpr_write(struct ata_device *dev, unsigned int reg, u32 val)
+{
+	struct piix_host_priv *hpriv = dev->link->ap->host->private_data;
+
+	piix_sidpr_sel(dev, reg);
+	iowrite32(val, hpriv->sidpr + PIIX_SIDPR_DATA);
+}
+
+u32 piix_merge_scr(u32 val0, u32 val1, const int * const *merge_tbl)
+{
+	u32 val = 0;
+	int i, mi;
+
+	for (i = 0, mi = 0; i < 32 / 4; i++) {
+		u8 c0 = (val0 >> (i * 4)) & 0xf;
+		u8 c1 = (val1 >> (i * 4)) & 0xf;
+		u8 merged = c0;
+		const int *cur;
+
+		/* if no merge preference, assume the first value */
+		cur = merge_tbl[mi];
+		if (!cur)
+			goto done;
+		mi++;
+
+		/* if two values equal, use it */
+		if (c0 == c1)
+			goto done;
+
+		/* choose the first match or the last from the merge table */
+		while (*cur != -1) {
+			if (c0 == *cur || c1 == *cur)
+				break;
+			cur++;
+		}
+		if (*cur == -1)
+			cur--;
+		merged = *cur;
+	done:
+		val |= merged << (i * 4);
+	}
+
+	return val;
+}
+
+static int piix_sidpr_scr_read(struct ata_port *ap, unsigned int reg, u32 *val)
+{
+	const int * const sstatus_merge_tbl[] = {
+		/* DET */ (const int []){ 1, 3, 0, 4, 3, -1 },
+		/* SPD */ (const int []){ 2, 1, 0, -1 },
+		/* IPM */ (const int []){ 6, 2, 1, 0, -1 },
+		NULL,
+	};
+	const int * const scontrol_merge_tbl[] = {
+		/* DET */ (const int []){ 1, 0, 4, 0, -1 },
+		/* SPD */ (const int []){ 0, 2, 1, 0, -1 },
+		/* IPM */ (const int []){ 0, 1, 2, 3, 0, -1 },
+		NULL,
+	};
+	u32 v0, v1;
+
+	if (reg >= ARRAY_SIZE(piix_sidx_map))
+		return -EINVAL;
+
+	if (!(ap->flags & ATA_FLAG_SLAVE_POSS)) {
+		*val = piix_sidpr_read(&ap->link.device[0], reg);
+		return 0;
+	}
+
+	v0 = piix_sidpr_read(&ap->link.device[0], reg);
+	v1 = piix_sidpr_read(&ap->link.device[1], reg);
+
+	switch (reg) {
+	case SCR_STATUS:
+		*val = piix_merge_scr(v0, v1, sstatus_merge_tbl);
+		break;
+	case SCR_ERROR:
+		*val = v0 | v1;
+		break;
+	case SCR_CONTROL:
+		*val = piix_merge_scr(v0, v1, scontrol_merge_tbl);
+		break;
+	}
+
+	return 0;
+}
+
+static int piix_sidpr_scr_write(struct ata_port *ap, unsigned int reg, u32 val)
+{
+	if (reg >= ARRAY_SIZE(piix_sidx_map))
+		return -EINVAL;
+
+	piix_sidpr_write(&ap->link.device[0], reg, val);
+
+	if (ap->flags & ATA_FLAG_SLAVE_POSS)
+		piix_sidpr_write(&ap->link.device[1], reg, val);
+
+	return 0;
+}
+
+static int piix_sidpr_hardreset(struct ata_link *link, unsigned int *class,
+				unsigned long deadline)
+{
+	const unsigned long *timing = sata_ehc_deb_timing(&link->eh_context);
+	int rc;
+
+	/* do hardreset */
+	rc = sata_link_hardreset(link, timing, deadline);
+	if (rc) {
+		ata_link_printk(link, KERN_ERR,
+				"COMRESET failed (errno=%d)\n", rc);
+		return rc;
+	}
+
+	/* TODO: phy layer with polling, timeouts, etc. */
+	if (ata_link_offline(link)) {
+		*class = ATA_DEV_NONE;
+		return 0;
+	}
+
+	return -EAGAIN;
+}
+
+static void piix_sidpr_error_handler(struct ata_port *ap)
+{
+	ata_bmdma_drive_eh(ap, ata_std_prereset, ata_std_softreset,
+			   piix_sidpr_hardreset, ata_std_postreset);
+}
+
 #ifdef CONFIG_PM
 static int piix_broken_suspend(void)
 {
@@ -1034,6 +1222,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "TECRA M6",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "TECRA M6"),
+			},
+		},
+		{
 			.ident = "TECRA M7",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -1048,6 +1243,13 @@ static int piix_broken_suspend(void)
 			},
 		},
 		{
+			.ident = "Satellite R20",
+			.matches = {
+				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+				DMI_MATCH(DMI_PRODUCT_NAME, "Satellite R20"),
+			},
+		},
+		{
 			.ident = "Satellite R25",
 			.matches = {
 				DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
@@ -1253,10 +1455,10 @@ static int __devinit piix_check_450nx_errata(struct pci_dev *ata_dev)
 	return no_piix_dma;
 }
 
-static void __devinit piix_init_pcs(struct pci_dev *pdev,
-				    struct ata_port_info *pinfo,
+static void __devinit piix_init_pcs(struct ata_host *host,
 				    const struct piix_map_db *map_db)
 {
+	struct pci_dev *pdev = to_pci_dev(host->dev);
 	u16 pcs, new_pcs;
 
 	pci_read_config_word(pdev, ICH5_PCS, &pcs);
@@ -1270,11 +1472,10 @@ static void __devinit piix_init_pcs(struct pci_dev *pdev,
 	}
 }
 
-static void __devinit piix_init_sata_map(struct pci_dev *pdev,
-					 struct ata_port_info *pinfo,
-					 const struct piix_map_db *map_db)
+static const int *__devinit piix_init_sata_map(struct pci_dev *pdev,
+					       struct ata_port_info *pinfo,
+					       const struct piix_map_db *map_db)
 {
-	struct piix_host_priv *hpriv = pinfo[0].private_data;
 	const int *map;
 	int i, invalid_map = 0;
 	u8 map_value;
@@ -1298,7 +1499,6 @@ static void __devinit piix_init_sata_map(struct pci_dev *pdev,
 		case IDE:
 			WARN_ON((i & 1) || map[i + 1] != IDE);
 			pinfo[i / 2] = piix_port_info[ich_pata_100];
-			pinfo[i / 2].private_data = hpriv;
 			i++;
 			printk(" IDE IDE");
 			break;
@@ -1316,7 +1516,33 @@ static void __devinit piix_init_sata_map(struct pci_dev *pdev,
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "invalid MAP value %u\n", map_value);
 
-	hpriv->map = map;
+	return map;
+}
+
+static void __devinit piix_init_sidpr(struct ata_host *host)
+{
+	struct pci_dev *pdev = to_pci_dev(host->dev);
+	struct piix_host_priv *hpriv = host->private_data;
+	int i;
+
+	/* check for availability */
+	for (i = 0; i < 4; i++)
+		if (hpriv->map[i] == IDE)
+			return;
+
+	if (!(host->ports[0]->flags & PIIX_FLAG_SIDPR))
+		return;
+
+	if (pci_resource_start(pdev, PIIX_SIDPR_BAR) == 0 ||
+	    pci_resource_len(pdev, PIIX_SIDPR_BAR) != PIIX_SIDPR_LEN)
+		return;
+
+	if (pcim_iomap_regions(pdev, 1 << PIIX_SIDPR_BAR, DRV_NAME))
+		return;
+
+	hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
+	host->ports[0]->ops = &piix_sidpr_sata_ops;
+	host->ports[1]->ops = &piix_sidpr_sata_ops;
 }
 
 static void piix_iocfg_bit18_quirk(struct pci_dev *pdev)
@@ -1375,8 +1601,10 @@ static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
 	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
-	struct piix_host_priv *hpriv;
 	unsigned long port_flags;
+	struct ata_host *host;
+	struct piix_host_priv *hpriv;
+	int rc;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
@@ -1386,17 +1614,31 @@ static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!in_module_init)
 		return -ENODEV;
 
+	port_info[0] = piix_port_info[ent->driver_data];
+	port_info[1] = piix_port_info[ent->driver_data];
+
+	port_flags = port_info[0].flags;
+
+	/* enable device and prepare host */
+	rc = pcim_enable_device(pdev);
+	if (rc)
+		return rc;
+
+	/* SATA map init can change port_info, do it before prepping host */
 	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
 
-	port_info[0] = piix_port_info[ent->driver_data];
-	port_info[1] = piix_port_info[ent->driver_data];
-	port_info[0].private_data = hpriv;
-	port_info[1].private_data = hpriv;
+	if (port_flags & ATA_FLAG_SATA)
+		hpriv->map = piix_init_sata_map(pdev, port_info,
+					piix_map_db_table[ent->driver_data]);
 
-	port_flags = port_info[0].flags;
+	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
+	if (rc)
+		return rc;
+	host->private_data = hpriv;
 
+	/* initialize controller */
 	if (port_flags & PIIX_FLAG_AHCI) {
 		u8 tmp;
 		pci_read_config_byte(pdev, PIIX_SCC, &tmp);
@@ -1407,12 +1649,9 @@ static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 	}
 
-	/* Initialize SATA map */
 	if (port_flags & ATA_FLAG_SATA) {
-		piix_init_sata_map(pdev, port_info,
-				   piix_map_db_table[ent->driver_data]);
-		piix_init_pcs(pdev, port_info,
-			      piix_map_db_table[ent->driver_data]);
+		piix_init_pcs(host, piix_map_db_table[ent->driver_data]);
+		piix_init_sidpr(host);
 	}
 
 	/* apply IOCFG bit18 quirk */
@@ -1431,12 +1670,14 @@ static int piix_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* This writes into the master table but it does not
 		   really matter for this errata as we will apply it to
 		   all the PIIX devices on the board */
-		port_info[0].mwdma_mask = 0;
-		port_info[0].udma_mask = 0;
-		port_info[1].mwdma_mask = 0;
-		port_info[1].udma_mask = 0;
+		host->ports[0]->mwdma_mask = 0;
+		host->ports[0]->udma_mask = 0;
+		host->ports[1]->mwdma_mask = 0;
+		host->ports[1]->udma_mask = 0;
 	}
-	return ata_pci_init_one(pdev, ppi);
+
+	pci_set_master(pdev);
+	return ata_pci_activate_sff_host(host, ata_interrupt, &piix_sht);
 }
 
 static int __init piix_init(void)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 7bf4bef..9e8ec19 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -442,40 +442,77 @@ static int ata_dev_get_GTF(struct ata_device *dev, struct ata_acpi_gtf **gtf)
 }
 
 /**
+ * ata_acpi_gtm_xfermode - determine xfermode from GTM parameter
+ * @dev: target device
+ * @gtm: GTM parameter to use
+ *
+ * Determine xfermask for @dev from @gtm.
+ *
+ * LOCKING:
+ * None.
+ *
+ * RETURNS:
+ * Determined xfermask.
+ */
+unsigned long ata_acpi_gtm_xfermask(struct ata_device *dev,
+				    const struct ata_acpi_gtm *gtm)
+{
+	unsigned long xfer_mask = 0;
+	unsigned int type;
+	int unit;
+	u8 mode;
+
+	/* we always use the 0 slot for crap hardware */
+	unit = dev->devno;
+	if (!(gtm->flags & 0x10))
+		unit = 0;
+
+	/* PIO */
+	mode = ata_timing_cycle2mode(ATA_SHIFT_PIO, gtm->drive[unit].pio);
+	xfer_mask |= ata_xfer_mode2mask(mode);
+
+	/* See if we have MWDMA or UDMA data. We don't bother with
+	 * MWDMA if UDMA is available as this means the BIOS set UDMA
+	 * and our error changedown if it works is UDMA to PIO anyway.
+	 */
+	if (!(gtm->flags & (1 << (2 * unit))))
+		type = ATA_SHIFT_MWDMA;
+	else
+		type = ATA_SHIFT_UDMA;
+
+	mode = ata_timing_cycle2mode(type, gtm->drive[unit].dma);
+	xfer_mask |= ata_xfer_mode2mask(mode);
+
+	return xfer_mask;
+}
+EXPORT_SYMBOL_GPL(ata_acpi_gtm_xfermask);
+
+/**
  * ata_acpi_cbl_80wire		-	Check for 80 wire cable
  * @ap: Port to check
+ * @gtm: GTM data to use
  *
- * Return 1 if the ACPI mode data for this port indicates the BIOS selected
- * an 80wire mode.
+ * Return 1 if the @gtm indicates the BIOS selected an 80wire mode.
  */
-
-int ata_acpi_cbl_80wire(struct ata_port *ap)
+int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm)
 {
-	const struct ata_acpi_gtm *gtm = ata_acpi_init_gtm(ap);
-	int valid = 0;
+	struct ata_device *dev;
 
-	if (!gtm)
-		return 0;
+	ata_link_for_each_dev(dev, &ap->link) {
+		unsigned long xfer_mask, udma_mask;
+
+		if (!ata_dev_enabled(dev))
+			continue;
+
+		xfer_mask = ata_acpi_gtm_xfermask(dev, gtm);
+		ata_unpack_xfermask(xfer_mask, NULL, NULL, &udma_mask);
+
+		if (udma_mask & ~ATA_UDMA_MASK_40C)
+			return 1;
+	}
 
-	/* Split timing, DMA enabled */
-	if ((gtm->flags & 0x11) == 0x11 && gtm->drive[0].dma < 55)
-		valid |= 1;
-	if ((gtm->flags & 0x14) == 0x14 && gtm->drive[1].dma < 55)
-		valid |= 2;
-	/* Shared timing, DMA enabled */
-	if ((gtm->flags & 0x11) == 0x01 && gtm->drive[0].dma < 55)
-		valid |= 1;
-	if ((gtm->flags & 0x14) == 0x04 && gtm->drive[0].dma < 55)
-		valid |= 2;
-
-	/* Drive check */
-	if ((valid & 1) && ata_dev_enabled(&ap->link.device[0]))
-		return 1;
-	if ((valid & 2) && ata_dev_enabled(&ap->link.device[1]))
-		return 1;
 	return 0;
 }
-
 EXPORT_SYMBOL_GPL(ata_acpi_cbl_80wire);
 
 static void ata_acpi_gtf_to_tf(struct ata_device *dev,
@@ -776,6 +813,36 @@ void ata_acpi_on_resume(struct ata_port *ap)
 }
 
 /**
+ * ata_acpi_set_state - set the port power state
+ * @ap: target ATA port
+ * @state: state, on/off
+ *
+ * This function executes the _PS0/_PS3 ACPI method to set the power state.
+ * ACPI spec requires _PS0 when IDE power on and _PS3 when power off
+ */
+void ata_acpi_set_state(struct ata_port *ap, pm_message_t state)
+{
+	struct ata_device *dev;
+
+	if (!ap->acpi_handle || (ap->flags & ATA_FLAG_ACPI_SATA))
+		return;
+
+	/* channel first and then drives for power on and vica versa
+	   for power off */
+	if (state.event == PM_EVENT_ON)
+		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D0);
+
+	ata_link_for_each_dev(dev, &ap->link) {
+		if (dev->acpi_handle && ata_dev_enabled(dev))
+			acpi_bus_set_power(dev->acpi_handle,
+				state.event == PM_EVENT_ON ?
+					ACPI_STATE_D0 : ACPI_STATE_D3);
+	}
+	if (state.event != PM_EVENT_ON)
+		acpi_bus_set_power(ap->acpi_handle, ACPI_STATE_D3);
+}
+
+/**
  * ata_acpi_on_devcfg - ATA ACPI hook called on device donfiguration
  * @dev: target ATA device
  *
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6380726..ce803d1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -119,6 +119,10 @@ int libata_noacpi = 0;
 module_param_named(noacpi, libata_noacpi, int, 0444);
 MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in probe/suspend/resume when set");
 
+int libata_allow_tpm = 0;
+module_param_named(allow_tpm, libata_allow_tpm, int, 0444);
+MODULE_PARM_DESC(allow_tpm, "Permit the use of TPM commands");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
@@ -450,9 +454,9 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
  *	RETURNS:
  *	Packed xfer_mask.
  */
-static unsigned int ata_pack_xfermask(unsigned int pio_mask,
-				      unsigned int mwdma_mask,
-				      unsigned int udma_mask)
+unsigned long ata_pack_xfermask(unsigned long pio_mask,
+				unsigned long mwdma_mask,
+				unsigned long udma_mask)
 {
 	return ((pio_mask << ATA_SHIFT_PIO) & ATA_MASK_PIO) |
 		((mwdma_mask << ATA_SHIFT_MWDMA) & ATA_MASK_MWDMA) |
@@ -469,10 +473,8 @@ static unsigned int ata_pack_xfermask(unsigned int pio_mask,
  *	Unpack @xfer_mask into @pio_mask, @mwdma_mask and @udma_mask.
  *	Any NULL distination masks will be ignored.
  */
-static void ata_unpack_xfermask(unsigned int xfer_mask,
-				unsigned int *pio_mask,
-				unsigned int *mwdma_mask,
-				unsigned int *udma_mask)
+void ata_unpack_xfermask(unsigned long xfer_mask, unsigned long *pio_mask,
+			 unsigned long *mwdma_mask, unsigned long *udma_mask)
 {
 	if (pio_mask)
 		*pio_mask = (xfer_mask & ATA_MASK_PIO) >> ATA_SHIFT_PIO;
@@ -486,9 +488,9 @@ static const struct ata_xfer_ent {
 	int shift, bits;
 	u8 base;
 } ata_xfer_tbl[] = {
-	{ ATA_SHIFT_PIO, ATA_BITS_PIO, XFER_PIO_0 },
-	{ ATA_SHIFT_MWDMA, ATA_BITS_MWDMA, XFER_MW_DMA_0 },
-	{ ATA_SHIFT_UDMA, ATA_BITS_UDMA, XFER_UDMA_0 },
+	{ ATA_SHIFT_PIO, ATA_NR_PIO_MODES, XFER_PIO_0 },
+	{ ATA_SHIFT_MWDMA, ATA_NR_MWDMA_MODES, XFER_MW_DMA_0 },
+	{ ATA_SHIFT_UDMA, ATA_NR_UDMA_MODES, XFER_UDMA_0 },
 	{ -1, },
 };
 
@@ -503,9 +505,9 @@ static const struct ata_xfer_ent {
  *	None.
  *
  *	RETURNS:
- *	Matching XFER_* value, 0 if no match found.
+ *	Matching XFER_* value, 0xff if no match found.
  */
-static u8 ata_xfer_mask2mode(unsigned int xfer_mask)
+u8 ata_xfer_mask2mode(unsigned long xfer_mask)
 {
 	int highbit = fls(xfer_mask) - 1;
 	const struct ata_xfer_ent *ent;
@@ -513,7 +515,7 @@ static u8 ata_xfer_mask2mode(unsigned int xfer_mask)
 	for (ent = ata_xfer_tbl; ent->shift >= 0; ent++)
 		if (highbit >= ent->shift && highbit < ent->shift + ent->bits)
 			return ent->base + highbit - ent->shift;
-	return 0;
+	return 0xff;
 }
 
 /**
@@ -528,13 +530,14 @@ static u8 ata_xfer_mask2mode(unsigned int xfer_mask)
  *	RETURNS:
  *	Matching xfer_mask, 0 if no match found.
  */
-static unsigned int ata_xfer_mode2mask(u8 xfer_mode)
+unsigned long ata_xfer_mode2mask(u8 xfer_mode)
 {
 	const struct ata_xfer_ent *ent;
 
 	for (ent = ata_xfer_tbl; ent->shift >= 0; ent++)
 		if (xfer_mode >= ent->base && xfer_mode < ent->base + ent->bits)
-			return 1 << (ent->shift + xfer_mode - ent->base);
+			return ((2 << (ent->shift + xfer_mode - ent->base)) - 1)
+				& ~((1 << ent->shift) - 1);
 	return 0;
 }
 
@@ -550,7 +553,7 @@ static unsigned int ata_xfer_mode2mask(u8 xfer_mode)
  *	RETURNS:
  *	Matching xfer_shift, -1 if no match found.
  */
-static int ata_xfer_mode2shift(unsigned int xfer_mode)
+int ata_xfer_mode2shift(unsigned long xfer_mode)
 {
 	const struct ata_xfer_ent *ent;
 
@@ -574,7 +577,7 @@ static int ata_xfer_mode2shift(unsigned int xfer_mode)
  *	Constant C string representing highest speed listed in
  *	@mode_mask, or the constant C string "<n/a>".
  */
-static const char *ata_mode_string(unsigned int xfer_mask)
+const char *ata_mode_string(unsigned long xfer_mask)
 {
 	static const char * const xfer_mode_str[] = {
 		"PIO0",
@@ -947,8 +950,8 @@ unsigned int ata_dev_try_classify(struct ata_device *dev, int present,
 	if (r_err)
 		*r_err = err;
 
-	/* see if device passed diags: if master then continue and warn later */
-	if (err == 0 && dev->devno == 0)
+	/* see if device passed diags: continue and warn later */
+	if (err == 0)
 		/* diagnostic fail : do nothing _YET_ */
 		dev->horkage |= ATA_HORKAGE_DIAGNOSTIC;
 	else if (err == 1)
@@ -1286,48 +1289,6 @@ static int ata_hpa_resize(struct ata_device *dev)
 }
 
 /**
- *	ata_id_to_dma_mode	-	Identify DMA mode from id block
- *	@dev: device to identify
- *	@unknown: mode to assume if we cannot tell
- *
- *	Set up the timing values for the device based upon the identify
- *	reported values for the DMA mode. This function is used by drivers
- *	which rely upon firmware configured modes, but wish to report the
- *	mode correctly when possible.
- *
- *	In addition we emit similarly formatted messages to the default
- *	ata_dev_set_mode handler, in order to provide consistency of
- *	presentation.
- */
-
-void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown)
-{
-	unsigned int mask;
-	u8 mode;
-
-	/* Pack the DMA modes */
-	mask = ((dev->id[63] >> 8) << ATA_SHIFT_MWDMA) & ATA_MASK_MWDMA;
-	if (dev->id[53] & 0x04)
-		mask |= ((dev->id[88] >> 8) << ATA_SHIFT_UDMA) & ATA_MASK_UDMA;
-
-	/* Select the mode in use */
-	mode = ata_xfer_mask2mode(mask);
-
-	if (mode != 0) {
-		ata_dev_printk(dev, KERN_INFO, "configured for %s\n",
-		       ata_mode_string(mask));
-	} else {
-		/* SWDMA perhaps ? */
-		mode = unknown;
-		ata_dev_printk(dev, KERN_INFO, "configured for DMA\n");
-	}
-
-	/* Configure the device reporting */
-	dev->xfer_mode = mode;
-	dev->xfer_shift = ata_xfer_mode2shift(mode);
-}
-
-/**
  *	ata_noop_dev_select - Select device 0/1 on ATA bus
  *	@ap: ATA channel to manipulate
  *	@device: ATA device (numbered from zero) to select
@@ -1464,9 +1425,9 @@ static inline void ata_dump_id(const u16 *id)
  *	RETURNS:
  *	Computed xfermask
  */
-static unsigned int ata_id_xfermask(const u16 *id)
+unsigned long ata_id_xfermask(const u16 *id)
 {
-	unsigned int pio_mask, mwdma_mask, udma_mask;
+	unsigned long pio_mask, mwdma_mask, udma_mask;
 
 	/* Usual case. Word 53 indicates word 64 is valid */
 	if (id[ATA_ID_FIELD_VALID] & (1 << 1)) {
@@ -1519,7 +1480,7 @@ static unsigned int ata_id_xfermask(const u16 *id)
 }
 
 /**
- *	ata_port_queue_task - Queue port_task
+ *	ata_pio_queue_task - Queue port_task
  *	@ap: The ata_port to queue port_task for
  *	@fn: workqueue function to be scheduled
  *	@data: data for @fn to use
@@ -1531,16 +1492,15 @@ static unsigned int ata_id_xfermask(const u16 *id)
  *	one task is active at any given time.
  *
  *	libata core layer takes care of synchronization between
- *	port_task and EH.  ata_port_queue_task() may be ignored for EH
+ *	port_task and EH.  ata_pio_queue_task() may be ignored for EH
  *	synchronization.
  *
  *	LOCKING:
  *	Inherited from caller.
  */
-void ata_port_queue_task(struct ata_port *ap, work_func_t fn, void *data,
-			 unsigned long delay)
+static void ata_pio_queue_task(struct ata_port *ap, void *data,
+			       unsigned long delay)
 {
-	PREPARE_DELAYED_WORK(&ap->port_task, fn);
 	ap->port_task_data = data;
 
 	/* may fail if ata_port_flush_task() in progress */
@@ -2090,7 +2050,7 @@ int ata_dev_configure(struct ata_device *dev)
 	struct ata_eh_context *ehc = &dev->link->eh_context;
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 	const u16 *id = dev->id;
-	unsigned int xfer_mask;
+	unsigned long xfer_mask;
 	char revbuf[7];		/* XYZ-99\0 */
 	char fwrevbuf[ATA_ID_FW_REV_LEN+1];
 	char modelbuf[ATA_ID_PROD_LEN+1];
@@ -2161,8 +2121,14 @@ int ata_dev_configure(struct ata_device *dev)
 					       "supports DRM functions and may "
 					       "not be fully accessable.\n");
 			snprintf(revbuf, 7, "CFA");
-		} else
+		} else {
 			snprintf(revbuf, 7, "ATA-%d", ata_id_major_version(id));
+			/* Warn the user if the device has TPM extensions */
+			if (ata_id_has_tpm(id))
+				ata_dev_printk(dev, KERN_WARNING,
+					       "supports DRM functions and may "
+					       "not be fully accessable.\n");
+		}
 
 		dev->n_sectors = ata_id_n_sectors(id);
 
@@ -2295,19 +2261,8 @@ int ata_dev_configure(struct ata_device *dev)
 			dev->flags |= ATA_DFLAG_DIPM;
 	}
 
-	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
-		/* Let the user know. We don't want to disallow opens for
-		   rescue purposes, or in case the vendor is just a blithering
-		   idiot */
-		if (print_info) {
-			ata_dev_printk(dev, KERN_WARNING,
-"Drive reports diagnostics failure. This may indicate a drive\n");
-			ata_dev_printk(dev, KERN_WARNING,
-"fault or invalid emulation. Contact drive vendor for information.\n");
-		}
-	}
-
-	/* limit bridge transfers to udma5, 200 sectors */
+	/* Limit PATA drive on SATA cable bridge transfers to udma5,
+	   200 sectors */
 	if (ata_dev_knobble(dev)) {
 		if (ata_msg_drv(ap) && print_info)
 			ata_dev_printk(dev, KERN_INFO,
@@ -2336,6 +2291,21 @@ int ata_dev_configure(struct ata_device *dev)
 	if (ap->ops->dev_config)
 		ap->ops->dev_config(dev);
 
+	if (dev->horkage & ATA_HORKAGE_DIAGNOSTIC) {
+		/* Let the user know. We don't want to disallow opens for
+		   rescue purposes, or in case the vendor is just a blithering
+		   idiot. Do this after the dev_config call as some controllers
+		   with buggy firmware may want to avoid reporting false device
+		   bugs */
+
+		if (print_info) {
+			ata_dev_printk(dev, KERN_WARNING,
+"Drive reports diagnostics failure. This may indicate a drive\n");
+			ata_dev_printk(dev, KERN_WARNING,
+"fault or invalid emulation. Contact drive vendor for information.\n");
+		}
+	}
+
 	if (ata_msg_probe(ap))
 		ata_dev_printk(dev, KERN_DEBUG, "%s: EXIT, drv_stat = 0x%x\n",
 			__FUNCTION__, ata_chk_status(ap));
@@ -2387,6 +2357,18 @@ int ata_cable_unknown(struct ata_port *ap)
 }
 
 /**
+ *	ata_cable_ignore	-	return ignored PATA cable.
+ *	@ap: port
+ *
+ *	Helper method for drivers which don't use cable type to limit
+ *	transfer mode.
+ */
+int ata_cable_ignore(struct ata_port *ap)
+{
+	return ATA_CBL_PATA_IGN;
+}
+
+/**
  *	ata_cable_sata	-	return SATA cable type
  *	@ap: port
  *
@@ -2781,38 +2763,33 @@ int sata_set_spd(struct ata_link *link)
  */
 
 static const struct ata_timing ata_timing[] = {
+/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 }, */
+	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
+	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
+	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
+	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
+	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
+	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
+	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
 
-	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
-	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
-	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
-	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
+	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
+	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
+	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
 
-	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
+	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
+	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
+	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
 	{ XFER_MW_DMA_3,  25,   0,   0,   0,  65,  25, 100,   0 },
-	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
-	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
-	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
+	{ XFER_MW_DMA_4,  25,   0,   0,   0,  55,  20,  80,   0 },
 
 /*	{ XFER_UDMA_SLOW,  0,   0,   0,   0,   0,   0,   0, 150 }, */
-
-	{ XFER_MW_DMA_2,  25,   0,   0,   0,  70,  25, 120,   0 },
-	{ XFER_MW_DMA_1,  45,   0,   0,   0,  80,  50, 150,   0 },
-	{ XFER_MW_DMA_0,  60,   0,   0,   0, 215, 215, 480,   0 },
-
-	{ XFER_SW_DMA_2,  60,   0,   0,   0, 120, 120, 240,   0 },
-	{ XFER_SW_DMA_1,  90,   0,   0,   0, 240, 240, 480,   0 },
-	{ XFER_SW_DMA_0, 120,   0,   0,   0, 480, 480, 960,   0 },
-
-	{ XFER_PIO_6,     10,  55,  20,  80,  55,  20,  80,   0 },
-	{ XFER_PIO_5,     15,  65,  25, 100,  65,  25, 100,   0 },
-	{ XFER_PIO_4,     25,  70,  25, 120,  70,  25, 120,   0 },
-	{ XFER_PIO_3,     30,  80,  70, 180,  80,  70, 180,   0 },
-
-	{ XFER_PIO_2,     30, 290,  40, 330, 100,  90, 240,   0 },
-	{ XFER_PIO_1,     50, 290,  93, 383, 125, 100, 383,   0 },
-	{ XFER_PIO_0,     70, 290, 240, 600, 165, 150, 600,   0 },
-
-/*	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 }, */
+	{ XFER_UDMA_0,     0,   0,   0,   0,   0,   0,   0, 120 },
+	{ XFER_UDMA_1,     0,   0,   0,   0,   0,   0,   0,  80 },
+	{ XFER_UDMA_2,     0,   0,   0,   0,   0,   0,   0,  60 },
+	{ XFER_UDMA_3,     0,   0,   0,   0,   0,   0,   0,  45 },
+	{ XFER_UDMA_4,     0,   0,   0,   0,   0,   0,   0,  30 },
+	{ XFER_UDMA_5,     0,   0,   0,   0,   0,   0,   0,  20 },
+	{ XFER_UDMA_6,     0,   0,   0,   0,   0,   0,   0,  15 },
 
 	{ 0xFF }
 };
@@ -2845,14 +2822,16 @@ void ata_timing_merge(const struct ata_timing *a, const struct ata_timing *b,
 	if (what & ATA_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
 }
 
-static const struct ata_timing *ata_timing_find_mode(unsigned short speed)
+const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)
 {
-	const struct ata_timing *t;
+	const struct ata_timing *t = ata_timing;
+
+	while (xfer_mode > t->mode)
+		t++;
 
-	for (t = ata_timing; t->mode != speed; t++)
-		if (t->mode == 0xFF)
-			return NULL;
-	return t;
+	if (xfer_mode == t->mode)
+		return t;
+	return NULL;
 }
 
 int ata_timing_compute(struct ata_device *adev, unsigned short speed,
@@ -2927,6 +2906,57 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 }
 
 /**
+ *	ata_timing_cycle2mode - find xfer mode for the specified cycle duration
+ *	@xfer_shift: ATA_SHIFT_* value for transfer type to examine.
+ *	@cycle: cycle duration in ns
+ *
+ *	Return matching xfer mode for @cycle.  The returned mode is of
+ *	the transfer type specified by @xfer_shift.  If @cycle is too
+ *	slow for @xfer_shift, 0xff is returned.  If @cycle is faster
+ *	than the fastest known mode, the fasted mode is returned.
+ *
+ *	LOCKING:
+ *	None.
+ *
+ *	RETURNS:
+ *	Matching xfer_mode, 0xff if no match found.
+ */
+u8 ata_timing_cycle2mode(unsigned int xfer_shift, int cycle)
+{
+	u8 base_mode = 0xff, last_mode = 0xff;
+	const struct ata_xfer_ent *ent;
+	const struct ata_timing *t;
+
+	for (ent = ata_xfer_tbl; ent->shift >= 0; ent++)
+		if (ent->shift == xfer_shift)
+			base_mode = ent->base;
+
+	for (t = ata_timing_find_mode(base_mode);
+	     t && ata_xfer_mode2shift(t->mode) == xfer_shift; t++) {
+		unsigned short this_cycle;
+
+		switch (xfer_shift) {
+		case ATA_SHIFT_PIO:
+		case ATA_SHIFT_MWDMA:
+			this_cycle = t->cycle;
+			break;
+		case ATA_SHIFT_UDMA:
+			this_cycle = t->udma;
+			break;
+		default:
+			return 0xff;
+		}
+
+		if (cycle > this_cycle)
+			break;
+
+		last_mode = t->mode;
+	}
+
+	return last_mode;
+}
+
+/**
  *	ata_down_xfermask_limit - adjust dev xfer masks downward
  *	@dev: Device to adjust xfer masks
  *	@sel: ATA_DNXFER_* selector
@@ -2944,8 +2974,8 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel)
 {
 	char buf[32];
-	unsigned int orig_mask, xfer_mask;
-	unsigned int pio_mask, mwdma_mask, udma_mask;
+	unsigned long orig_mask, xfer_mask;
+	unsigned long pio_mask, mwdma_mask, udma_mask;
 	int quiet, highbit;
 
 	quiet = !!(sel & ATA_DNXFER_QUIET);
@@ -3039,7 +3069,7 @@ static int ata_dev_set_mode(struct ata_device *dev)
 
 	/* Early MWDMA devices do DMA but don't allow DMA mode setting.
 	   Don't fail an MWDMA0 set IFF the device indicates it is in MWDMA0 */
-	if (dev->xfer_shift == ATA_SHIFT_MWDMA && 
+	if (dev->xfer_shift == ATA_SHIFT_MWDMA &&
 	    dev->dma_mode == XFER_MW_DMA_0 &&
 	    (dev->id[63] >> 8) & 1)
 		err_mask &= ~AC_ERR_DEV;
@@ -3089,7 +3119,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 
 	/* step 1: calculate xfer_mask */
 	ata_link_for_each_dev(dev, link) {
-		unsigned int pio_mask, dma_mask;
+		unsigned long pio_mask, dma_mask;
 		unsigned int mode_mask;
 
 		if (!ata_dev_enabled(dev))
@@ -3115,7 +3145,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		dev->dma_mode = ata_xfer_mask2mode(dma_mask);
 
 		found = 1;
-		if (dev->dma_mode)
+		if (dev->dma_mode != 0xff)
 			used_dma = 1;
 	}
 	if (!found)
@@ -3126,7 +3156,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 		if (!ata_dev_enabled(dev))
 			continue;
 
-		if (!dev->pio_mode) {
+		if (dev->pio_mode == 0xff) {
 			ata_dev_printk(dev, KERN_WARNING, "no PIO support\n");
 			rc = -EINVAL;
 			goto out;
@@ -3140,7 +3170,7 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 
 	/* step 3: set host DMA timings */
 	ata_link_for_each_dev(dev, link) {
-		if (!ata_dev_enabled(dev) || !dev->dma_mode)
+		if (!ata_dev_enabled(dev) || dev->dma_mode == 0xff)
 			continue;
 
 		dev->xfer_mode = dev->dma_mode;
@@ -3173,31 +3203,6 @@ int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
 }
 
 /**
- *	ata_set_mode - Program timings and issue SET FEATURES - XFER
- *	@link: link on which timings will be programmed
- *	@r_failed_dev: out paramter for failed device
- *
- *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
- *	ata_set_mode() fails, pointer to the failing device is
- *	returned in @r_failed_dev.
- *
- *	LOCKING:
- *	PCI/etc. bus probe sem.
- *
- *	RETURNS:
- *	0 on success, negative errno otherwise
- */
-int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
-{
-	struct ata_port *ap = link->ap;
-
-	/* has private set_mode? */
-	if (ap->ops->set_mode)
-		return ap->ops->set_mode(link, r_failed_dev);
-	return ata_do_set_mode(link, r_failed_dev);
-}
-
-/**
  *	ata_tf_to_host - issue ATA taskfile to host controller
  *	@ap: port to which command is being issued
  *	@tf: ATA taskfile register set
@@ -4363,7 +4368,14 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev)
 	tf.feature = SETFEATURES_XFER;
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_POLLING;
 	tf.protocol = ATA_PROT_NODATA;
-	tf.nsect = dev->xfer_mode;
+	/* If we are using IORDY we must send the mode setting command */
+	if (ata_pio_need_iordy(dev))
+		tf.nsect = dev->xfer_mode;
+	/* If the device has IORDY and the controller does not - turn it off */
+ 	else if (ata_id_has_iordy(dev->id))
+		tf.nsect = 0x01;
+	else /* In the ancient relic department - skip all of this */
+		return 0;
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
 
@@ -4462,17 +4474,13 @@ static unsigned int ata_dev_init_params(struct ata_device *dev,
 void ata_sg_clean(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg = qc->__sg;
+	struct scatterlist *sg = qc->sg;
 	int dir = qc->dma_dir;
 	void *pad_buf = NULL;
 
-	WARN_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
 	WARN_ON(sg == NULL);
 
-	if (qc->flags & ATA_QCFLAG_SINGLE)
-		WARN_ON(qc->n_elem > 1);
-
-	VPRINTK("unmapping %u sg elements\n", qc->n_elem);
+	VPRINTK("unmapping %u sg elements\n", qc->mapped_n_elem);
 
 	/* if we padded the buffer out to 32-bit bound, and data
 	 * xfer direction is from-device, we must copy from the
@@ -4481,31 +4489,20 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 	if (qc->pad_len && !(qc->tf.flags & ATA_TFLAG_WRITE))
 		pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
 
-	if (qc->flags & ATA_QCFLAG_SG) {
-		if (qc->n_elem)
-			dma_unmap_sg(ap->dev, sg, qc->n_elem, dir);
-		/* restore last sg */
-		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
-		if (pad_buf) {
-			struct scatterlist *psg = &qc->pad_sgent;
-			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-			memcpy(addr + psg->offset, pad_buf, qc->pad_len);
-			kunmap_atomic(addr, KM_IRQ0);
-		}
-	} else {
-		if (qc->n_elem)
-			dma_unmap_single(ap->dev,
-				sg_dma_address(&sg[0]), sg_dma_len(&sg[0]),
-				dir);
-		/* restore sg */
-		sg->length += qc->pad_len;
-		if (pad_buf)
-			memcpy(qc->buf_virt + sg->length - qc->pad_len,
-			       pad_buf, qc->pad_len);
+	if (qc->mapped_n_elem)
+		dma_unmap_sg(ap->dev, sg, qc->mapped_n_elem, dir);
+	/* restore last sg */
+	if (qc->last_sg)
+		*qc->last_sg = qc->saved_last_sg;
+	if (pad_buf) {
+		struct scatterlist *psg = &qc->extra_sg[1];
+		void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
+		memcpy(addr + psg->offset, pad_buf, qc->pad_len);
+		kunmap_atomic(addr, KM_IRQ0);
 	}
 
 	qc->flags &= ~ATA_QCFLAG_DMAMAP;
-	qc->__sg = NULL;
+	qc->sg = NULL;
 }
 
 /**
@@ -4523,13 +4520,10 @@ static void ata_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
-	unsigned int idx;
+	unsigned int si, pi;
 
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
-
-	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
@@ -4546,18 +4540,17 @@ static void ata_fill_sg(struct ata_queued_cmd *qc)
 			if ((offset + sg_len) > 0x10000)
 				len = 0x10000 - offset;
 
-			ap->prd[idx].addr = cpu_to_le32(addr);
-			ap->prd[idx].flags_len = cpu_to_le32(len & 0xffff);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+			ap->prd[pi].addr = cpu_to_le32(addr);
+			ap->prd[pi].flags_len = cpu_to_le32(len & 0xffff);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
 
-			idx++;
+			pi++;
 			sg_len -= len;
 			addr += len;
 		}
 	}
 
-	if (idx)
-		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 /**
@@ -4577,13 +4570,10 @@ static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
-	unsigned int idx;
-
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	unsigned int si, pi;
 
-	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	pi = 0;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr, offset;
 		u32 sg_len, len, blen;
 
@@ -4601,25 +4591,24 @@ static void ata_fill_sg_dumb(struct ata_queued_cmd *qc)
 				len = 0x10000 - offset;
 
 			blen = len & 0xffff;
-			ap->prd[idx].addr = cpu_to_le32(addr);
+			ap->prd[pi].addr = cpu_to_le32(addr);
 			if (blen == 0) {
 			   /* Some PATA chipsets like the CS5530 can't
 			      cope with 0x0000 meaning 64K as the spec says */
-				ap->prd[idx].flags_len = cpu_to_le32(0x8000);
+				ap->prd[pi].flags_len = cpu_to_le32(0x8000);
 				blen = 0x8000;
-				ap->prd[++idx].addr = cpu_to_le32(addr + 0x8000);
+				ap->prd[++pi].addr = cpu_to_le32(addr + 0x8000);
 			}
-			ap->prd[idx].flags_len = cpu_to_le32(blen);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+			ap->prd[pi].flags_len = cpu_to_le32(blen);
+			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", pi, addr, len);
 
-			idx++;
+			pi++;
 			sg_len -= len;
 			addr += len;
 		}
 	}
 
-	if (idx)
-		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	ap->prd[pi - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 /**
@@ -4669,8 +4658,8 @@ int ata_check_atapi_dma(struct ata_queued_cmd *qc)
  */
 static int atapi_qc_may_overflow(struct ata_queued_cmd *qc)
 {
-	if (qc->tf.protocol != ATA_PROT_ATAPI &&
-	    qc->tf.protocol != ATA_PROT_ATAPI_DMA)
+	if (qc->tf.protocol != ATAPI_PROT_PIO &&
+	    qc->tf.protocol != ATAPI_PROT_DMA)
 		return 0;
 
 	if (qc->tf.flags & ATA_TFLAG_WRITE)
@@ -4756,33 +4745,6 @@ void ata_dumb_qc_prep(struct ata_queued_cmd *qc)
 void ata_noop_qc_prep(struct ata_queued_cmd *qc) { }
 
 /**
- *	ata_sg_init_one - Associate command with memory buffer
- *	@qc: Command to be associated
- *	@buf: Memory buffer
- *	@buflen: Length of memory buffer, in bytes.
- *
- *	Initialize the data-related elements of queued_cmd @qc
- *	to point to a single memory buffer, @buf of byte length @buflen.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- */
-
-void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf, unsigned int buflen)
-{
-	qc->flags |= ATA_QCFLAG_SINGLE;
-
-	qc->__sg = &qc->sgent;
-	qc->n_elem = 1;
-	qc->orig_n_elem = 1;
-	qc->buf_virt = buf;
-	qc->nbytes = buflen;
-	qc->cursg = qc->__sg;
-
-	sg_init_one(&qc->sgent, buf, buflen);
-}
-
-/**
  *	ata_sg_init - Associate command with scatter-gather table.
  *	@qc: Command to be associated
  *	@sg: Scatter-gather table.
@@ -4795,84 +4757,103 @@ void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf, unsigned int buflen)
  *	LOCKING:
  *	spin_lock_irqsave(host lock)
  */
-
 void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem)
 {
-	qc->flags |= ATA_QCFLAG_SG;
-	qc->__sg = sg;
+	qc->sg = sg;
 	qc->n_elem = n_elem;
-	qc->orig_n_elem = n_elem;
-	qc->cursg = qc->__sg;
+	qc->cursg = qc->sg;
 }
 
-/**
- *	ata_sg_setup_one - DMA-map the memory buffer associated with a command.
- *	@qc: Command with memory buffer to be mapped.
- *
- *	DMA-map the memory buffer associated with queued_cmd @qc.
- *
- *	LOCKING:
- *	spin_lock_irqsave(host lock)
- *
- *	RETURNS:
- *	Zero on success, negative on error.
- */
-
-static int ata_sg_setup_one(struct ata_queued_cmd *qc)
+static unsigned int ata_sg_setup_extra(struct ata_queued_cmd *qc,
+				       unsigned int *n_elem_extra,
+				       unsigned int *nbytes_extra)
 {
 	struct ata_port *ap = qc->ap;
-	int dir = qc->dma_dir;
-	struct scatterlist *sg = qc->__sg;
-	dma_addr_t dma_address;
-	int trim_sg = 0;
+	unsigned int n_elem = qc->n_elem;
+	struct scatterlist *lsg, *copy_lsg = NULL, *tsg = NULL, *esg = NULL;
+
+	*n_elem_extra = 0;
+	*nbytes_extra = 0;
+
+	/* needs padding? */
+	qc->pad_len = qc->nbytes & 3;
+
+	if (likely(!qc->pad_len))
+		return n_elem;
+
+	/* locate last sg and save it */
+	lsg = sg_last(qc->sg, n_elem);
+	qc->last_sg = lsg;
+	qc->saved_last_sg = *lsg;
+
+	sg_init_table(qc->extra_sg, ARRAY_SIZE(qc->extra_sg));
 
-	/* we must lengthen transfers to end on a 32-bit boundary */
-	qc->pad_len = sg->length & 3;
 	if (qc->pad_len) {
+		struct scatterlist *psg = &qc->extra_sg[1];
 		void *pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-		struct scatterlist *psg = &qc->pad_sgent;
+		unsigned int offset;
 
 		WARN_ON(qc->dev->class != ATA_DEV_ATAPI);
 
 		memset(pad_buf, 0, ATA_DMA_PAD_SZ);
 
-		if (qc->tf.flags & ATA_TFLAG_WRITE)
-			memcpy(pad_buf, qc->buf_virt + sg->length - qc->pad_len,
-			       qc->pad_len);
+		/* psg->page/offset are used to copy to-be-written
+		 * data in this function or read data in ata_sg_clean.
+		 */
+		offset = lsg->offset + lsg->length - qc->pad_len;
+		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT),
+			    qc->pad_len, offset_in_page(offset));
+
+		if (qc->tf.flags & ATA_TFLAG_WRITE) {
+			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
+			memcpy(pad_buf, addr + psg->offset, qc->pad_len);
+			kunmap_atomic(addr, KM_IRQ0);
+		}
 
 		sg_dma_address(psg) = ap->pad_dma + (qc->tag * ATA_DMA_PAD_SZ);
 		sg_dma_len(psg) = ATA_DMA_PAD_SZ;
-		/* trim sg */
-		sg->length -= qc->pad_len;
-		if (sg->length == 0)
-			trim_sg = 1;
 
-		DPRINTK("padding done, sg->length=%u pad_len=%u\n",
-			sg->length, qc->pad_len);
-	}
+		/* Trim the last sg entry and chain the original and
+		 * padding sg lists.
+		 *
+		 * Because chaining consumes one sg entry, one extra
+		 * sg entry is allocated and the last sg entry is
+		 * copied to it if the length isn't zero after padded
+		 * amount is removed.
+		 *
+		 * If the last sg entry is completely replaced by
+		 * padding sg entry, the first sg entry is skipped
+		 * while chaining.
+		 */
+		lsg->length -= qc->pad_len;
+		if (lsg->length) {
+			copy_lsg = &qc->extra_sg[0];
+			tsg = &qc->extra_sg[0];
+		} else {
+			n_elem--;
+			tsg = &qc->extra_sg[1];
+		}
 
-	if (trim_sg) {
-		qc->n_elem--;
-		goto skip_map;
-	}
+		esg = &qc->extra_sg[1];
 
-	dma_address = dma_map_single(ap->dev, qc->buf_virt,
-				     sg->length, dir);
-	if (dma_mapping_error(dma_address)) {
-		/* restore sg */
-		sg->length += qc->pad_len;
-		return -1;
+		(*n_elem_extra)++;
+		(*nbytes_extra) += 4 - qc->pad_len;
 	}
 
-	sg_dma_address(sg) = dma_address;
-	sg_dma_len(sg) = sg->length;
+	if (copy_lsg)
+		sg_set_page(copy_lsg, sg_page(lsg), lsg->length, lsg->offset);
 
-skip_map:
-	DPRINTK("mapped buffer of %d bytes for %s\n", sg_dma_len(sg),
-		qc->tf.flags & ATA_TFLAG_WRITE ? "write" : "read");
+	sg_chain(lsg, 1, tsg);
+	sg_mark_end(esg);
 
-	return 0;
+	/* sglist can't start with chaining sg entry, fast forward */
+	if (qc->sg == lsg) {
+		qc->sg = tsg;
+		qc->cursg = tsg;
+	}
+
+	return n_elem;
 }
 
 /**
@@ -4888,75 +4869,30 @@ skip_map:
  *	Zero on success, negative on error.
  *
  */
-
 static int ata_sg_setup(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct scatterlist *sg = qc->__sg;
-	struct scatterlist *lsg = sg_last(qc->__sg, qc->n_elem);
-	int n_elem, pre_n_elem, dir, trim_sg = 0;
+	unsigned int n_elem, n_elem_extra, nbytes_extra;
 
 	VPRINTK("ENTER, ata%u\n", ap->print_id);
-	WARN_ON(!(qc->flags & ATA_QCFLAG_SG));
 
-	/* we must lengthen transfers to end on a 32-bit boundary */
-	qc->pad_len = lsg->length & 3;
-	if (qc->pad_len) {
-		void *pad_buf = ap->pad + (qc->tag * ATA_DMA_PAD_SZ);
-		struct scatterlist *psg = &qc->pad_sgent;
-		unsigned int offset;
-
-		WARN_ON(qc->dev->class != ATA_DEV_ATAPI);
+	n_elem = ata_sg_setup_extra(qc, &n_elem_extra, &nbytes_extra);
 
-		memset(pad_buf, 0, ATA_DMA_PAD_SZ);
-
-		/*
-		 * psg->page/offset are used to copy to-be-written
-		 * data in this function or read data in ata_sg_clean.
-		 */
-		offset = lsg->offset + lsg->length - qc->pad_len;
-		sg_init_table(psg, 1);
-		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT),
-				qc->pad_len, offset_in_page(offset));
-
-		if (qc->tf.flags & ATA_TFLAG_WRITE) {
-			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
-			memcpy(pad_buf, addr + psg->offset, qc->pad_len);
-			kunmap_atomic(addr, KM_IRQ0);
+	if (n_elem) {
+		n_elem = dma_map_sg(ap->dev, qc->sg, n_elem, qc->dma_dir);
+		if (n_elem < 1) {
+			/* restore last sg */
+			if (qc->last_sg)
+				*qc->last_sg = qc->saved_last_sg;
+			return -1;
 		}
-
-		sg_dma_address(psg) = ap->pad_dma + (qc->tag * ATA_DMA_PAD_SZ);
-		sg_dma_len(psg) = ATA_DMA_PAD_SZ;
-		/* trim last sg */
-		lsg->length -= qc->pad_len;
-		if (lsg->length == 0)
-			trim_sg = 1;
-
-		DPRINTK("padding done, sg[%d].length=%u pad_len=%u\n",
-			qc->n_elem - 1, lsg->length, qc->pad_len);
-	}
-
-	pre_n_elem = qc->n_elem;
-	if (trim_sg && pre_n_elem)
-		pre_n_elem--;
-
-	if (!pre_n_elem) {
-		n_elem = 0;
-		goto skip_map;
-	}
-
-	dir = qc->dma_dir;
-	n_elem = dma_map_sg(ap->dev, sg, pre_n_elem, dir);
-	if (n_elem < 1) {
-		/* restore last sg */
-		lsg->length += qc->pad_len;
-		return -1;
+		DPRINTK("%d sg elements mapped\n", n_elem);
 	}
 
-	DPRINTK("%d sg elements mapped\n", n_elem);
-
-skip_map:
-	qc->n_elem = n_elem;
+	qc->n_elem = qc->mapped_n_elem = n_elem;
+	qc->n_elem += n_elem_extra;
+	qc->nbytes += nbytes_extra;
+	qc->flags |= ATA_QCFLAG_DMAMAP;
 
 	return 0;
 }
@@ -4985,7 +4921,7 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
 
 /**
  *	ata_data_xfer - Transfer data by PIO
- *	@adev: device to target
+ *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
  *	@write_data: read/write
@@ -4994,37 +4930,44 @@ void swap_buf_le16(u16 *buf, unsigned int buf_words)
  *
  *	LOCKING:
  *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	Bytes consumed.
  */
-void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
-		   unsigned int buflen, int write_data)
+unsigned int ata_data_xfer(struct ata_device *dev, unsigned char *buf,
+			   unsigned int buflen, int rw)
 {
-	struct ata_port *ap = adev->link->ap;
+	struct ata_port *ap = dev->link->ap;
+	void __iomem *data_addr = ap->ioaddr.data_addr;
 	unsigned int words = buflen >> 1;
 
 	/* Transfer multiple of 2 bytes */
-	if (write_data)
-		iowrite16_rep(ap->ioaddr.data_addr, buf, words);
+	if (rw == READ)
+		ioread16_rep(data_addr, buf, words);
 	else
-		ioread16_rep(ap->ioaddr.data_addr, buf, words);
+		iowrite16_rep(data_addr, buf, words);
 
 	/* Transfer trailing 1 byte, if any. */
 	if (unlikely(buflen & 0x01)) {
-		u16 align_buf[1] = { 0 };
+		__le16 align_buf[1] = { 0 };
 		unsigned char *trailing_buf = buf + buflen - 1;
 
-		if (write_data) {
-			memcpy(align_buf, trailing_buf, 1);
-			iowrite16(le16_to_cpu(align_buf[0]), ap->ioaddr.data_addr);
-		} else {
-			align_buf[0] = cpu_to_le16(ioread16(ap->ioaddr.data_addr));
+		if (rw == READ) {
+			align_buf[0] = cpu_to_le16(ioread16(data_addr));
 			memcpy(trailing_buf, align_buf, 1);
+		} else {
+			memcpy(align_buf, trailing_buf, 1);
+			iowrite16(le16_to_cpu(align_buf[0]), data_addr);
 		}
+		words++;
 	}
+
+	return words << 1;
 }
 
 /**
  *	ata_data_xfer_noirq - Transfer data by PIO
- *	@adev: device to target
+ *	@dev: device to target
  *	@buf: data buffer
  *	@buflen: buffer length
  *	@write_data: read/write
@@ -5034,14 +4977,21 @@ void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
  *
  *	LOCKING:
  *	Inherited from caller.
+ *
+ *	RETURNS:
+ *	Bytes consumed.
  */
-void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
-			 unsigned int buflen, int write_data)
+unsigned int ata_data_xfer_noirq(struct ata_device *dev, unsigned char *buf,
+				 unsigned int buflen, int rw)
 {
 	unsigned long flags;
+	unsigned int consumed;
+
 	local_irq_save(flags);
-	ata_data_xfer(adev, buf, buflen, write_data);
+	consumed = ata_data_xfer(dev, buf, buflen, rw);
 	local_irq_restore(flags);
+
+	return consumed;
 }
 
 
@@ -5152,13 +5102,13 @@ static void atapi_send_cdb(struct ata_port *ap, struct ata_queued_cmd *qc)
 	ata_altstatus(ap); /* flush */
 
 	switch (qc->tf.protocol) {
-	case ATA_PROT_ATAPI:
+	case ATAPI_PROT_PIO:
 		ap->hsm_task_state = HSM_ST;
 		break;
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_NODATA:
 		ap->hsm_task_state = HSM_ST_LAST;
 		break;
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		ap->hsm_task_state = HSM_ST_LAST;
 		/* initiate bmdma */
 		ap->ops->bmdma_start(qc);
@@ -5300,12 +5250,15 @@ static void atapi_pio_bytes(struct ata_queued_cmd *qc)
 	bytes = (bc_hi << 8) | bc_lo;
 
 	/* shall be cleared to zero, indicating xfer of data */
-	if (ireason & (1 << 0))
+	if (unlikely(ireason & (1 << 0)))
 		goto err_out;
 
 	/* make sure transfer direction matches expected */
 	i_write = ((ireason & (1 << 1)) == 0) ? 1 : 0;
-	if (do_write != i_write)
+	if (unlikely(do_write != i_write))
+		goto err_out;
+
+	if (unlikely(!bytes))
 		goto err_out;
 
 	VPRINTK("ata%u: xfering %d bytes\n", ap->print_id, bytes);
@@ -5341,7 +5294,7 @@ static inline int ata_hsm_ok_in_wq(struct ata_port *ap, struct ata_queued_cmd *q
 		    (qc->tf.flags & ATA_TFLAG_WRITE))
 		    return 1;
 
-		if (is_atapi_taskfile(&qc->tf) &&
+		if (ata_is_atapi(qc->tf.protocol) &&
 		    !(qc->dev->flags & ATA_DFLAG_CDB_INTR))
 			return 1;
 	}
@@ -5506,7 +5459,7 @@ fsm_start:
 
 	case HSM_ST:
 		/* complete command or read/write the data register */
-		if (qc->tf.protocol == ATA_PROT_ATAPI) {
+		if (qc->tf.protocol == ATAPI_PROT_PIO) {
 			/* ATAPI PIO protocol */
 			if ((status & ATA_DRQ) == 0) {
 				/* No more data to transfer or device error.
@@ -5664,7 +5617,7 @@ fsm_start:
 		msleep(2);
 		status = ata_busy_wait(ap, ATA_BUSY, 10);
 		if (status & ATA_BUSY) {
-			ata_port_queue_task(ap, ata_pio_task, qc, ATA_SHORT_PAUSE);
+			ata_pio_queue_task(ap, qc, ATA_SHORT_PAUSE);
 			return;
 		}
 	}
@@ -5805,6 +5758,22 @@ static void fill_result_tf(struct ata_queued_cmd *qc)
 	ap->ops->tf_read(ap, &qc->result_tf);
 }
 
+static void ata_verify_xfer(struct ata_queued_cmd *qc)
+{
+	struct ata_device *dev = qc->dev;
+
+	if (ata_tag_internal(qc->tag))
+		return;
+
+	if (ata_is_nodata(qc->tf.protocol))
+		return;
+
+	if ((dev->mwdma_mask || dev->udma_mask) && ata_is_pio(qc->tf.protocol))
+		return;
+
+	dev->flags &= ~ATA_DFLAG_DUBIOUS_XFER;
+}
+
 /**
  *	ata_qc_complete - Complete an active ATA command
  *	@qc: Command to complete
@@ -5876,6 +5845,9 @@ void ata_qc_complete(struct ata_queued_cmd *qc)
 			break;
 		}
 
+		if (unlikely(dev->flags & ATA_DFLAG_DUBIOUS_XFER))
+			ata_verify_xfer(qc);
+
 		__ata_qc_complete(qc);
 	} else {
 		if (qc->flags & ATA_QCFLAG_EH_SCHEDULED)
@@ -5938,30 +5910,6 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active,
 	return nr_done;
 }
 
-static inline int ata_should_dma_map(struct ata_queued_cmd *qc)
-{
-	struct ata_port *ap = qc->ap;
-
-	switch (qc->tf.protocol) {
-	case ATA_PROT_NCQ:
-	case ATA_PROT_DMA:
-	case ATA_PROT_ATAPI_DMA:
-		return 1;
-
-	case ATA_PROT_ATAPI:
-	case ATA_PROT_PIO:
-		if (ap->flags & ATA_FLAG_PIO_DMA)
-			return 1;
-
-		/* fall through */
-
-	default:
-		return 0;
-	}
-
-	/* never reached */
-}
-
 /**
  *	ata_qc_issue - issue taskfile to device
  *	@qc: command to issue to device
@@ -5978,6 +5926,7 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct ata_link *link = qc->dev->link;
+	u8 prot = qc->tf.protocol;
 
 	/* Make sure only one non-NCQ command is outstanding.  The
 	 * check is skipped for old EH because it reuses active qc to
@@ -5985,7 +5934,7 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	 */
 	WARN_ON(ap->ops->error_handler && ata_tag_valid(link->active_tag));
 
-	if (qc->tf.protocol == ATA_PROT_NCQ) {
+	if (ata_is_ncq(prot)) {
 		WARN_ON(link->sactive & (1 << qc->tag));
 
 		if (!link->sactive)
@@ -6001,17 +5950,18 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	qc->flags |= ATA_QCFLAG_ACTIVE;
 	ap->qc_active |= 1 << qc->tag;
 
-	if (ata_should_dma_map(qc)) {
-		if (qc->flags & ATA_QCFLAG_SG) {
-			if (ata_sg_setup(qc))
-				goto sg_err;
-		} else if (qc->flags & ATA_QCFLAG_SINGLE) {
-			if (ata_sg_setup_one(qc))
-				goto sg_err;
-		}
-	} else {
-		qc->flags &= ~ATA_QCFLAG_DMAMAP;
-	}
+	/* We guarantee to LLDs that they will have at least one
+	 * non-zero sg if the command is a data command.
+	 */
+	BUG_ON(ata_is_data(prot) && (!qc->sg || !qc->n_elem || !qc->nbytes));
+
+	/* ata_sg_setup() may update nbytes */
+	qc->raw_nbytes = qc->nbytes;
+
+	if (ata_is_dma(prot) || (ata_is_pio(prot) &&
+				 (ap->flags & ATA_FLAG_PIO_DMA)))
+		if (ata_sg_setup(qc))
+			goto sg_err;
 
 	/* if device is sleeping, schedule softreset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
@@ -6029,7 +5979,6 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 	return;
 
 sg_err:
-	qc->flags &= ~ATA_QCFLAG_DMAMAP;
 	qc->err_mask |= AC_ERR_SYSTEM;
 err:
 	ata_qc_complete(qc);
@@ -6064,11 +6013,11 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 		switch (qc->tf.protocol) {
 		case ATA_PROT_PIO:
 		case ATA_PROT_NODATA:
-		case ATA_PROT_ATAPI:
-		case ATA_PROT_ATAPI_NODATA:
+		case ATAPI_PROT_PIO:
+		case ATAPI_PROT_NODATA:
 			qc->tf.flags |= ATA_TFLAG_POLLING;
 			break;
-		case ATA_PROT_ATAPI_DMA:
+		case ATAPI_PROT_DMA:
 			if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
 				/* see ata_dma_blacklisted() */
 				BUG();
@@ -6091,7 +6040,7 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 		ap->hsm_task_state = HSM_ST_LAST;
 
 		if (qc->tf.flags & ATA_TFLAG_POLLING)
-			ata_port_queue_task(ap, ata_pio_task, qc, 0);
+			ata_pio_queue_task(ap, qc, 0);
 
 		break;
 
@@ -6113,7 +6062,7 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
 			/* PIO data out protocol */
 			ap->hsm_task_state = HSM_ST_FIRST;
-			ata_port_queue_task(ap, ata_pio_task, qc, 0);
+			ata_pio_queue_task(ap, qc, 0);
 
 			/* always send first data block using
 			 * the ata_pio_task() codepath.
@@ -6123,7 +6072,7 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 			ap->hsm_task_state = HSM_ST;
 
 			if (qc->tf.flags & ATA_TFLAG_POLLING)
-				ata_port_queue_task(ap, ata_pio_task, qc, 0);
+				ata_pio_queue_task(ap, qc, 0);
 
 			/* if polling, ata_pio_task() handles the rest.
 			 * otherwise, interrupt handler takes over from here.
@@ -6132,8 +6081,8 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 
 		break;
 
-	case ATA_PROT_ATAPI:
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_PIO:
+	case ATAPI_PROT_NODATA:
 		if (qc->tf.flags & ATA_TFLAG_POLLING)
 			ata_qc_set_polling(qc);
 
@@ -6144,10 +6093,10 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 		/* send cdb by polling if no cdb interrupt */
 		if ((!(qc->dev->flags & ATA_DFLAG_CDB_INTR)) ||
 		    (qc->tf.flags & ATA_TFLAG_POLLING))
-			ata_port_queue_task(ap, ata_pio_task, qc, 0);
+			ata_pio_queue_task(ap, qc, 0);
 		break;
 
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		WARN_ON(qc->tf.flags & ATA_TFLAG_POLLING);
 
 		ap->ops->tf_load(ap, &qc->tf);	 /* load tf registers */
@@ -6156,7 +6105,7 @@ unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc)
 
 		/* send cdb by polling if no cdb interrupt */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
-			ata_port_queue_task(ap, ata_pio_task, qc, 0);
+			ata_pio_queue_task(ap, qc, 0);
 		break;
 
 	default:
@@ -6200,15 +6149,15 @@ inline unsigned int ata_host_intr(struct ata_port *ap,
 		 */
 
 		/* Check the ATA_DFLAG_CDB_INTR flag is enough here.
-		 * The flag was turned on only for atapi devices.
-		 * No need to check is_atapi_taskfile(&qc->tf) again.
+		 * The flag was turned on only for atapi devices.  No
+		 * need to check ata_is_atapi(qc->tf.protocol) again.
 		 */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
 			goto idle_irq;
 		break;
 	case HSM_ST_LAST:
 		if (qc->tf.protocol == ATA_PROT_DMA ||
-		    qc->tf.protocol == ATA_PROT_ATAPI_DMA) {
+		    qc->tf.protocol == ATAPI_PROT_DMA) {
 			/* check status of DMA engine */
 			host_stat = ap->ops->bmdma_status(ap);
 			VPRINTK("ata%u: host_stat 0x%X\n",
@@ -6250,7 +6199,7 @@ inline unsigned int ata_host_intr(struct ata_port *ap,
 	ata_hsm_move(ap, qc, status, 0);
 
 	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA ||
-				       qc->tf.protocol == ATA_PROT_ATAPI_DMA))
+				       qc->tf.protocol == ATAPI_PROT_DMA))
 		ata_ehi_push_desc(ehi, "BMDMA stat 0x%x", host_stat);
 
 	return 1;	/* irq handled */
@@ -6772,7 +6721,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	ap->msg_enable = ATA_MSG_DRV | ATA_MSG_ERR | ATA_MSG_WARN;
 #endif
 
-	INIT_DELAYED_WORK(&ap->port_task, NULL);
+	INIT_DELAYED_WORK(&ap->port_task, ata_pio_task);
 	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
 	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
 	INIT_LIST_HEAD(&ap->eh_done_q);
@@ -7589,7 +7538,6 @@ EXPORT_SYMBOL_GPL(ata_host_register);
 EXPORT_SYMBOL_GPL(ata_host_activate);
 EXPORT_SYMBOL_GPL(ata_host_detach);
 EXPORT_SYMBOL_GPL(ata_sg_init);
-EXPORT_SYMBOL_GPL(ata_sg_init_one);
 EXPORT_SYMBOL_GPL(ata_hsm_move);
 EXPORT_SYMBOL_GPL(ata_qc_complete);
 EXPORT_SYMBOL_GPL(ata_qc_complete_multiple);
@@ -7601,6 +7549,13 @@ EXPORT_SYMBOL_GPL(ata_std_dev_select);
 EXPORT_SYMBOL_GPL(sata_print_link_status);
 EXPORT_SYMBOL_GPL(ata_tf_to_fis);
 EXPORT_SYMBOL_GPL(ata_tf_from_fis);
+EXPORT_SYMBOL_GPL(ata_pack_xfermask);
+EXPORT_SYMBOL_GPL(ata_unpack_xfermask);
+EXPORT_SYMBOL_GPL(ata_xfer_mask2mode);
+EXPORT_SYMBOL_GPL(ata_xfer_mode2mask);
+EXPORT_SYMBOL_GPL(ata_xfer_mode2shift);
+EXPORT_SYMBOL_GPL(ata_mode_string);
+EXPORT_SYMBOL_GPL(ata_id_xfermask);
 EXPORT_SYMBOL_GPL(ata_check_status);
 EXPORT_SYMBOL_GPL(ata_altstatus);
 EXPORT_SYMBOL_GPL(ata_exec_command);
@@ -7643,7 +7598,6 @@ EXPORT_SYMBOL_GPL(ata_wait_register);
 EXPORT_SYMBOL_GPL(ata_busy_sleep);
 EXPORT_SYMBOL_GPL(ata_wait_after_reset);
 EXPORT_SYMBOL_GPL(ata_wait_ready);
-EXPORT_SYMBOL_GPL(ata_port_queue_task);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
@@ -7662,18 +7616,20 @@ EXPORT_SYMBOL_GPL(ata_host_resume);
 #endif /* CONFIG_PM */
 EXPORT_SYMBOL_GPL(ata_id_string);
 EXPORT_SYMBOL_GPL(ata_id_c_string);
-EXPORT_SYMBOL_GPL(ata_id_to_dma_mode);
 EXPORT_SYMBOL_GPL(ata_scsi_simulate);
 
 EXPORT_SYMBOL_GPL(ata_pio_need_iordy);
+EXPORT_SYMBOL_GPL(ata_timing_find_mode);
 EXPORT_SYMBOL_GPL(ata_timing_compute);
 EXPORT_SYMBOL_GPL(ata_timing_merge);
+EXPORT_SYMBOL_GPL(ata_timing_cycle2mode);
 
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
 EXPORT_SYMBOL_GPL(ata_pci_init_sff_host);
 EXPORT_SYMBOL_GPL(ata_pci_init_bmdma);
 EXPORT_SYMBOL_GPL(ata_pci_prepare_sff_host);
+EXPORT_SYMBOL_GPL(ata_pci_activate_sff_host);
 EXPORT_SYMBOL_GPL(ata_pci_init_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
 #ifdef CONFIG_PM
@@ -7715,4 +7671,5 @@ EXPORT_SYMBOL_GPL(ata_dev_try_classify);
 EXPORT_SYMBOL_GPL(ata_cable_40wire);
 EXPORT_SYMBOL_GPL(ata_cable_80wire);
 EXPORT_SYMBOL_GPL(ata_cable_unknown);
+EXPORT_SYMBOL_GPL(ata_cable_ignore);
 EXPORT_SYMBOL_GPL(ata_cable_sata);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 21a81cd..4e31071 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -46,9 +46,26 @@
 #include "libata.h"
 
 enum {
+	/* speed down verdicts */
 	ATA_EH_SPDN_NCQ_OFF		= (1 << 0),
 	ATA_EH_SPDN_SPEED_DOWN		= (1 << 1),
 	ATA_EH_SPDN_FALLBACK_TO_PIO	= (1 << 2),
+	ATA_EH_SPDN_KEEP_ERRORS		= (1 << 3),
+
+	/* error flags */
+	ATA_EFLAG_IS_IO			= (1 << 0),
+	ATA_EFLAG_DUBIOUS_XFER		= (1 << 1),
+
+	/* error categories */
+	ATA_ECAT_NONE			= 0,
+	ATA_ECAT_ATA_BUS		= 1,
+	ATA_ECAT_TOUT_HSM		= 2,
+	ATA_ECAT_UNK_DEV		= 3,
+	ATA_ECAT_DUBIOUS_NONE		= 4,
+	ATA_ECAT_DUBIOUS_ATA_BUS	= 5,
+	ATA_ECAT_DUBIOUS_TOUT_HSM	= 6,
+	ATA_ECAT_DUBIOUS_UNK_DEV	= 7,
+	ATA_ECAT_NR			= 8,
 };
 
 /* Waiting in ->prereset can never be reliable.  It's sometimes nice
@@ -213,12 +230,13 @@ void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 	if (offset < 0)
 		ata_port_desc(ap, "%s %s%llu@0x%llx", name, type, len, start);
 	else
-		ata_port_desc(ap, "%s 0x%llx", name, start + offset);
+		ata_port_desc(ap, "%s 0x%llx", name,
+				start + (unsigned long long)offset);
 }
 
 #endif /* CONFIG_PCI */
 
-static void ata_ering_record(struct ata_ering *ering, int is_io,
+static void ata_ering_record(struct ata_ering *ering, unsigned int eflags,
 			     unsigned int err_mask)
 {
 	struct ata_ering_entry *ent;
@@ -229,11 +247,20 @@ static void ata_ering_record(struct ata_ering *ering, int is_io,
 	ering->cursor %= ATA_ERING_SIZE;
 
 	ent = &ering->ring[ering->cursor];
-	ent->is_io = is_io;
+	ent->eflags = eflags;
 	ent->err_mask = err_mask;
 	ent->timestamp = get_jiffies_64();
 }
 
+static struct ata_ering_entry *ata_ering_top(struct ata_ering *ering)
+{
+	struct ata_ering_entry *ent = &ering->ring[ering->cursor];
+
+	if (ent->err_mask)
+		return ent;
+	return NULL;
+}
+
 static void ata_ering_clear(struct ata_ering *ering)
 {
 	memset(ering, 0, sizeof(*ering));
@@ -445,9 +472,20 @@ void ata_scsi_error(struct Scsi_Host *host)
 		spin_lock_irqsave(ap->lock, flags);
 
 		__ata_port_for_each_link(link, ap) {
+			struct ata_eh_context *ehc = &link->eh_context;
+			struct ata_device *dev;
+
 			memset(&link->eh_context, 0, sizeof(link->eh_context));
 			link->eh_context.i = link->eh_info;
 			memset(&link->eh_info, 0, sizeof(link->eh_info));
+
+			ata_link_for_each_dev(dev, link) {
+				int devno = dev->devno;
+
+				ehc->saved_xfer_mode[devno] = dev->xfer_mode;
+				if (ata_ncq_enabled(dev))
+					ehc->saved_ncq_enabled |= 1 << devno;
+			}
 		}
 
 		ap->pflags |= ATA_PFLAG_EH_IN_PROGRESS;
@@ -1260,10 +1298,10 @@ static unsigned int atapi_eh_request_sense(struct ata_queued_cmd *qc)
 
 	/* is it pointless to prefer PIO for "safety reasons"? */
 	if (ap->flags & ATA_FLAG_PIO_DMA) {
-		tf.protocol = ATA_PROT_ATAPI_DMA;
+		tf.protocol = ATAPI_PROT_DMA;
 		tf.feature |= ATAPI_PKT_DMA;
 	} else {
-		tf.protocol = ATA_PROT_ATAPI;
+		tf.protocol = ATAPI_PROT_PIO;
 		tf.lbam = SCSI_SENSE_BUFFERSIZE;
 		tf.lbah = 0;
 	}
@@ -1451,20 +1489,29 @@ static unsigned int ata_eh_analyze_tf(struct ata_queued_cmd *qc,
 	return action;
 }
 
-static int ata_eh_categorize_error(int is_io, unsigned int err_mask)
+static int ata_eh_categorize_error(unsigned int eflags, unsigned int err_mask,
+				   int *xfer_ok)
 {
+	int base = 0;
+
+	if (!(eflags & ATA_EFLAG_DUBIOUS_XFER))
+		*xfer_ok = 1;
+
+	if (!*xfer_ok)
+		base = ATA_ECAT_DUBIOUS_NONE;
+
 	if (err_mask & AC_ERR_ATA_BUS)
-		return 1;
+		return base + ATA_ECAT_ATA_BUS;
 
 	if (err_mask & AC_ERR_TIMEOUT)
-		return 2;
+		return base + ATA_ECAT_TOUT_HSM;
 
-	if (is_io) {
+	if (eflags & ATA_EFLAG_IS_IO) {
 		if (err_mask & AC_ERR_HSM)
-			return 2;
+			return base + ATA_ECAT_TOUT_HSM;
 		if ((err_mask &
 		     (AC_ERR_DEV|AC_ERR_MEDIA|AC_ERR_INVALID)) == AC_ERR_DEV)
-			return 3;
+			return base + ATA_ECAT_UNK_DEV;
 	}
 
 	return 0;
@@ -1472,18 +1519,22 @@ static int ata_eh_categorize_error(int is_io, unsigned int err_mask)
 
 struct speed_down_verdict_arg {
 	u64 since;
-	int nr_errors[4];
+	int xfer_ok;
+	int nr_errors[ATA_ECAT_NR];
 };
 
 static int speed_down_verdict_cb(struct ata_ering_entry *ent, void *void_arg)
 {
 	struct speed_down_verdict_arg *arg = void_arg;
-	int cat = ata_eh_categorize_error(ent->is_io, ent->err_mask);
+	int cat;
 
 	if (ent->timestamp < arg->since)
 		return -1;
 
+	cat = ata_eh_categorize_error(ent->eflags, ent->err_mask,
+				      &arg->xfer_ok);
 	arg->nr_errors[cat]++;
+
 	return 0;
 }
 
@@ -1495,22 +1546,48 @@ static int speed_down_verdict_cb(struct ata_ering_entry *ent, void *void_arg)
  *	whether NCQ needs to be turned off, transfer speed should be
  *	stepped down, or falling back to PIO is necessary.
  *
- *	Cat-1 is ATA_BUS error for any command.
+ *	ECAT_ATA_BUS	: ATA_BUS error for any command
+ *
+ *	ECAT_TOUT_HSM	: TIMEOUT for any command or HSM violation for
+ *			  IO commands
+ *
+ *	ECAT_UNK_DEV	: Unknown DEV error for IO commands
+ *
+ *	ECAT_DUBIOUS_*	: Identical to above three but occurred while
+ *			  data transfer hasn't been verified.
+ *
+ *	Verdicts are
+ *
+ *	NCQ_OFF		: Turn off NCQ.
+ *
+ *	SPEED_DOWN	: Speed down transfer speed but don't fall back
+ *			  to PIO.
+ *
+ *	FALLBACK_TO_PIO	: Fall back to PIO.
+ *
+ *	Even if multiple verdicts are returned, only one action is
+ *	taken per error.  An action triggered by non-DUBIOUS errors
+ *	clears ering, while one triggered by DUBIOUS_* errors doesn't.
+ *	This is to expedite speed down decisions right after device is
+ *	initially configured.
  *
- *	Cat-2 is TIMEOUT for any command or HSM violation for known
- *	supported commands.
+ *	The followings are speed down rules.  #1 and #2 deal with
+ *	DUBIOUS errors.
  *
- *	Cat-3 is is unclassified DEV error for known supported
- *	command.
+ *	1. If more than one DUBIOUS_ATA_BUS or DUBIOUS_TOUT_HSM errors
+ *	   occurred during last 5 mins, SPEED_DOWN and FALLBACK_TO_PIO.
  *
- *	NCQ needs to be turned off if there have been more than 3
- *	Cat-2 + Cat-3 errors during last 10 minutes.
+ *	2. If more than one DUBIOUS_TOUT_HSM or DUBIOUS_UNK_DEV errors
+ *	   occurred during last 5 mins, NCQ_OFF.
  *
- *	Speed down is necessary if there have been more than 3 Cat-1 +
- *	Cat-2 errors or 10 Cat-3 errors during last 10 minutes.
+ *	3. If more than 8 ATA_BUS, TOUT_HSM or UNK_DEV errors
+ *	   ocurred during last 5 mins, FALLBACK_TO_PIO
  *
- *	Falling back to PIO mode is necessary if there have been more
- *	than 10 Cat-1 + Cat-2 + Cat-3 errors during last 5 minutes.
+ *	4. If more than 3 TOUT_HSM or UNK_DEV errors occurred
+ *	   during last 10 mins, NCQ_OFF.
+ *
+ *	5. If more than 3 ATA_BUS or TOUT_HSM errors, or more than 6
+ *	   UNK_DEV errors occurred during last 10 mins, SPEED_DOWN.
  *
  *	LOCKING:
  *	Inherited from caller.
@@ -1525,23 +1602,38 @@ static unsigned int ata_eh_speed_down_verdict(struct ata_device *dev)
 	struct speed_down_verdict_arg arg;
 	unsigned int verdict = 0;
 
-	/* scan past 10 mins of error history */
+	/* scan past 5 mins of error history */
 	memset(&arg, 0, sizeof(arg));
-	arg.since = j64 - min(j64, j10mins);
+	arg.since = j64 - min(j64, j5mins);
 	ata_ering_map(&dev->ering, speed_down_verdict_cb, &arg);
 
-	if (arg.nr_errors[2] + arg.nr_errors[3] > 3)
-		verdict |= ATA_EH_SPDN_NCQ_OFF;
-	if (arg.nr_errors[1] + arg.nr_errors[2] > 3 || arg.nr_errors[3] > 10)
-		verdict |= ATA_EH_SPDN_SPEED_DOWN;
+	if (arg.nr_errors[ATA_ECAT_DUBIOUS_ATA_BUS] +
+	    arg.nr_errors[ATA_ECAT_DUBIOUS_TOUT_HSM] > 1)
+		verdict |= ATA_EH_SPDN_SPEED_DOWN |
+			ATA_EH_SPDN_FALLBACK_TO_PIO | ATA_EH_SPDN_KEEP_ERRORS;
 
-	/* scan past 3 mins of error history */
+	if (arg.nr_errors[ATA_ECAT_DUBIOUS_TOUT_HSM] +
+	    arg.nr_errors[ATA_ECAT_DUBIOUS_UNK_DEV] > 1)
+		verdict |= ATA_EH_SPDN_NCQ_OFF | ATA_EH_SPDN_KEEP_ERRORS;
+
+	if (arg.nr_errors[ATA_ECAT_ATA_BUS] +
+	    arg.nr_errors[ATA_ECAT_TOUT_HSM] +
+	    arg.nr_errors[ATA_ECAT_UNK_DEV] > 6)
+		verdict |= ATA_EH_SPDN_FALLBACK_TO_PIO;
+
+	/* scan past 10 mins of error history */
 	memset(&arg, 0, sizeof(arg));
-	arg.since = j64 - min(j64, j5mins);
+	arg.since = j64 - min(j64, j10mins);
 	ata_ering_map(&dev->ering, speed_down_verdict_cb, &arg);
 
-	if (arg.nr_errors[1] + arg.nr_errors[2] + arg.nr_errors[3] > 10)
-		verdict |= ATA_EH_SPDN_FALLBACK_TO_PIO;
+	if (arg.nr_errors[ATA_ECAT_TOUT_HSM] +
+	    arg.nr_errors[ATA_ECAT_UNK_DEV] > 3)
+		verdict |= ATA_EH_SPDN_NCQ_OFF;
+
+	if (arg.nr_errors[ATA_ECAT_ATA_BUS] +
+	    arg.nr_errors[ATA_ECAT_TOUT_HSM] > 3 ||
+	    arg.nr_errors[ATA_ECAT_UNK_DEV] > 6)
+		verdict |= ATA_EH_SPDN_SPEED_DOWN;
 
 	return verdict;
 }
@@ -1549,7 +1641,7 @@ static unsigned int ata_eh_speed_down_verdict(struct ata_device *dev)
 /**
  *	ata_eh_speed_down - record error and speed down if necessary
  *	@dev: Failed device
- *	@is_io: Did the device fail during normal IO?
+ *	@eflags: mask of ATA_EFLAG_* flags
  *	@err_mask: err_mask of the error
  *
  *	Record error and examine error history to determine whether
@@ -1563,18 +1655,20 @@ static unsigned int ata_eh_speed_down_verdict(struct ata_device *dev)
  *	RETURNS:
  *	Determined recovery action.
  */
-static unsigned int ata_eh_speed_down(struct ata_device *dev, int is_io,
-				      unsigned int err_mask)
+static unsigned int ata_eh_speed_down(struct ata_device *dev,
+				unsigned int eflags, unsigned int err_mask)
 {
+	struct ata_link *link = dev->link;
+	int xfer_ok = 0;
 	unsigned int verdict;
 	unsigned int action = 0;
 
 	/* don't bother if Cat-0 error */
-	if (ata_eh_categorize_error(is_io, err_mask) == 0)
+	if (ata_eh_categorize_error(eflags, err_mask, &xfer_ok) == 0)
 		return 0;
 
 	/* record error and determine whether speed down is necessary */
-	ata_ering_record(&dev->ering, is_io, err_mask);
+	ata_ering_record(&dev->ering, eflags, err_mask);
 	verdict = ata_eh_speed_down_verdict(dev);
 
 	/* turn off NCQ? */
@@ -1590,7 +1684,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev, int is_io,
 	/* speed down? */
 	if (verdict & ATA_EH_SPDN_SPEED_DOWN) {
 		/* speed down SATA link speed if possible */
-		if (sata_down_spd_limit(dev->link) == 0) {
+		if (sata_down_spd_limit(link) == 0) {
 			action |= ATA_EH_HARDRESET;
 			goto done;
 		}
@@ -1618,10 +1712,10 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev, int is_io,
 	}
 
 	/* Fall back to PIO?  Slowing down to PIO is meaningless for
-	 * SATA.  Consider it only for PATA.
+	 * SATA ATA devices.  Consider it only for PATA and SATAPI.
 	 */
 	if ((verdict & ATA_EH_SPDN_FALLBACK_TO_PIO) && (dev->spdn_cnt >= 2) &&
-	    (dev->link->ap->cbl != ATA_CBL_SATA) &&
+	    (link->ap->cbl != ATA_CBL_SATA || dev->class == ATA_DEV_ATAPI) &&
 	    (dev->xfer_shift != ATA_SHIFT_PIO)) {
 		if (ata_down_xfermask_limit(dev, ATA_DNXFER_FORCE_PIO) == 0) {
 			dev->spdn_cnt = 0;
@@ -1633,7 +1727,8 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev, int is_io,
 	return 0;
  done:
 	/* device has been slowed down, blow error history */
-	ata_ering_clear(&dev->ering);
+	if (!(verdict & ATA_EH_SPDN_KEEP_ERRORS))
+		ata_ering_clear(&dev->ering);
 	return action;
 }
 
@@ -1653,8 +1748,8 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 	struct ata_port *ap = link->ap;
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev;
-	unsigned int all_err_mask = 0;
-	int tag, is_io = 0;
+	unsigned int all_err_mask = 0, eflags = 0;
+	int tag;
 	u32 serror;
 	int rc;
 
@@ -1713,15 +1808,15 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 		ehc->i.dev = qc->dev;
 		all_err_mask |= qc->err_mask;
 		if (qc->flags & ATA_QCFLAG_IO)
-			is_io = 1;
+			eflags |= ATA_EFLAG_IS_IO;
 	}
 
 	/* enforce default EH actions */
 	if (ap->pflags & ATA_PFLAG_FROZEN ||
 	    all_err_mask & (AC_ERR_HSM | AC_ERR_TIMEOUT))
 		ehc->i.action |= ATA_EH_SOFTRESET;
-	else if ((is_io && all_err_mask) ||
-		 (!is_io && (all_err_mask & ~AC_ERR_DEV)))
+	else if (((eflags & ATA_EFLAG_IS_IO) && all_err_mask) ||
+		 (!(eflags & ATA_EFLAG_IS_IO) && (all_err_mask & ~AC_ERR_DEV)))
 		ehc->i.action |= ATA_EH_REVALIDATE;
 
 	/* If we have offending qcs and the associated failed device,
@@ -1743,8 +1838,11 @@ static void ata_eh_link_autopsy(struct ata_link *link)
 		      ata_dev_enabled(link->device))))
 	    dev = link->device;
 
-	if (dev)
-		ehc->i.action |= ata_eh_speed_down(dev, is_io, all_err_mask);
+	if (dev) {
+		if (dev->flags & ATA_DFLAG_DUBIOUS_XFER)
+			eflags |= ATA_EFLAG_DUBIOUS_XFER;
+		ehc->i.action |= ata_eh_speed_down(dev, eflags, all_err_mask);
+	}
 
 	DPRINTK("EXIT\n");
 }
@@ -1880,8 +1978,8 @@ static void ata_eh_link_report(struct ata_link *link)
 				[ATA_PROT_PIO]		= "pio",
 				[ATA_PROT_DMA]		= "dma",
 				[ATA_PROT_NCQ]		= "ncq",
-				[ATA_PROT_ATAPI]	= "pio",
-				[ATA_PROT_ATAPI_DMA]	= "dma",
+				[ATAPI_PROT_PIO]	= "pio",
+				[ATAPI_PROT_DMA]	= "dma",
 			};
 
 			snprintf(data_buf, sizeof(data_buf), " %s %u %s",
@@ -1889,7 +1987,7 @@ static void ata_eh_link_report(struct ata_link *link)
 				 dma_str[qc->dma_dir]);
 		}
 
-		if (is_atapi_taskfile(&qc->tf))
+		if (ata_is_atapi(qc->tf.protocol))
 			snprintf(cdb_buf, sizeof(cdb_buf),
 				 "cdb %02x %02x %02x %02x %02x %02x %02x %02x  "
 				 "%02x %02x %02x %02x %02x %02x %02x %02x\n         ",
@@ -2329,6 +2427,58 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
 	return rc;
 }
 
+/**
+ *	ata_set_mode - Program timings and issue SET FEATURES - XFER
+ *	@link: link on which timings will be programmed
+ *	@r_failed_dev: out paramter for failed device
+ *
+ *	Set ATA device disk transfer mode (PIO3, UDMA6, etc.).  If
+ *	ata_set_mode() fails, pointer to the failing device is
+ *	returned in @r_failed_dev.
+ *
+ *	LOCKING:
+ *	PCI/etc. bus probe sem.
+ *
+ *	RETURNS:
+ *	0 on success, negative errno otherwise
+ */
+int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev)
+{
+	struct ata_port *ap = link->ap;
+	struct ata_device *dev;
+	int rc;
+
+	/* if data transfer is verified, clear DUBIOUS_XFER on ering top */
+	ata_link_for_each_dev(dev, link) {
+		if (!(dev->flags & ATA_DFLAG_DUBIOUS_XFER)) {
+			struct ata_ering_entry *ent;
+
+			ent = ata_ering_top(&dev->ering);
+			if (ent)
+				ent->eflags &= ~ATA_EFLAG_DUBIOUS_XFER;
+		}
+	}
+
+	/* has private set_mode? */
+	if (ap->ops->set_mode)
+		rc = ap->ops->set_mode(link, r_failed_dev);
+	else
+		rc = ata_do_set_mode(link, r_failed_dev);
+
+	/* if transfer mode has changed, set DUBIOUS_XFER on device */
+	ata_link_for_each_dev(dev, link) {
+		struct ata_eh_context *ehc = &link->eh_context;
+		u8 saved_xfer_mode = ehc->saved_xfer_mode[dev->devno];
+		u8 saved_ncq = !!(ehc->saved_ncq_enabled & (1 << dev->devno));
+
+		if (dev->xfer_mode != saved_xfer_mode ||
+		    ata_ncq_enabled(dev) != saved_ncq)
+			dev->flags |= ATA_DFLAG_DUBIOUS_XFER;
+	}
+
+	return rc;
+}
+
 static int ata_link_nr_enabled(struct ata_link *link)
 {
 	struct ata_device *dev;
@@ -2375,6 +2525,24 @@ static int ata_eh_skip_recovery(struct ata_link *link)
 	return 1;
 }
 
+static int ata_eh_schedule_probe(struct ata_device *dev)
+{
+	struct ata_eh_context *ehc = &dev->link->eh_context;
+
+	if (!(ehc->i.probe_mask & (1 << dev->devno)) ||
+	    (ehc->did_probe_mask & (1 << dev->devno)))
+		return 0;
+
+	ata_eh_detach_dev(dev);
+	ata_dev_init(dev);
+	ehc->did_probe_mask |= (1 << dev->devno);
+	ehc->i.action |= ATA_EH_SOFTRESET;
+	ehc->saved_xfer_mode[dev->devno] = 0;
+	ehc->saved_ncq_enabled &= ~(1 << dev->devno);
+
+	return 1;
+}
+
 static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 {
 	struct ata_eh_context *ehc = &dev->link->eh_context;
@@ -2406,16 +2574,9 @@ static int ata_eh_handle_dev_fail(struct ata_device *dev, int err)
 		if (ata_link_offline(dev->link))
 			ata_eh_detach_dev(dev);
 
-		/* probe if requested */
-		if ((ehc->i.probe_mask & (1 << dev->devno)) &&
-		    !(ehc->did_probe_mask & (1 << dev->devno))) {
-			ata_eh_detach_dev(dev);
-			ata_dev_init(dev);
-
+		/* schedule probe if necessary */
+		if (ata_eh_schedule_probe(dev))
 			ehc->tries[dev->devno] = ATA_EH_DEV_TRIES;
-			ehc->did_probe_mask |= (1 << dev->devno);
-			ehc->i.action |= ATA_EH_SOFTRESET;
-		}
 
 		return 1;
 	} else {
@@ -2492,14 +2653,9 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			if (dev->flags & ATA_DFLAG_DETACH)
 				ata_eh_detach_dev(dev);
 
-			if (!ata_dev_enabled(dev) &&
-			    ((ehc->i.probe_mask & (1 << dev->devno)) &&
-			     !(ehc->did_probe_mask & (1 << dev->devno)))) {
-				ata_eh_detach_dev(dev);
-				ata_dev_init(dev);
-				ehc->did_probe_mask |= (1 << dev->devno);
-				ehc->i.action |= ATA_EH_SOFTRESET;
-			}
+			/* schedule probe if necessary */
+			if (!ata_dev_enabled(dev))
+				ata_eh_schedule_probe(dev);
 		}
 	}
 
@@ -2747,6 +2903,7 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
 	if (ap->ops->port_suspend)
 		rc = ap->ops->port_suspend(ap, ap->pm_mesg);
 
+	ata_acpi_set_state(ap, PMSG_SUSPEND);
  out:
 	/* report result */
 	spin_lock_irqsave(ap->lock, flags);
@@ -2792,6 +2949,8 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 
 	WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));
 
+	ata_acpi_set_state(ap, PMSG_ON);
+
 	if (ap->ops->port_resume)
 		rc = ap->ops->port_resume(ap);
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 14daf48..3fd0820 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -517,7 +517,7 @@ static struct ata_queued_cmd *ata_scsi_qc_new(struct ata_device *dev,
 		qc->scsicmd = cmd;
 		qc->scsidone = done;
 
-		qc->__sg = scsi_sglist(cmd);
+		qc->sg = scsi_sglist(cmd);
 		qc->n_elem = scsi_sg_count(cmd);
 	} else {
 		cmd->result = (DID_OK << 16) | (QUEUE_FULL << 1);
@@ -2210,7 +2210,7 @@ unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
 
 		/* sector size */
 		ATA_SCSI_RBUF_SET(6, ATA_SECT_SIZE >> 8);
-		ATA_SCSI_RBUF_SET(7, ATA_SECT_SIZE);
+		ATA_SCSI_RBUF_SET(7, ATA_SECT_SIZE & 0xff);
 	} else {
 		/* sector count, 64-bit */
 		ATA_SCSI_RBUF_SET(0, last_lba >> (8 * 7));
@@ -2224,7 +2224,7 @@ unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf,
 
 		/* sector size */
 		ATA_SCSI_RBUF_SET(10, ATA_SECT_SIZE >> 8);
-		ATA_SCSI_RBUF_SET(11, ATA_SECT_SIZE);
+		ATA_SCSI_RBUF_SET(11, ATA_SECT_SIZE & 0xff);
 	}
 
 	return 0;
@@ -2331,7 +2331,7 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 	DPRINTK("ATAPI request sense\n");
 
 	/* FIXME: is this needed? */
-	memset(cmd->sense_buffer, 0, sizeof(cmd->sense_buffer));
+	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 
 	ap->ops->tf_read(ap, &qc->tf);
 
@@ -2341,7 +2341,9 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 
 	ata_qc_reinit(qc);
 
-	ata_sg_init_one(qc, cmd->sense_buffer, sizeof(cmd->sense_buffer));
+	/* setup sg table and init transfer direction */
+	sg_init_one(&qc->sgent, cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+	ata_sg_init(qc, &qc->sgent, 1);
 	qc->dma_dir = DMA_FROM_DEVICE;
 
 	memset(&qc->cdb, 0, qc->dev->cdb_len);
@@ -2352,10 +2354,10 @@ static void atapi_request_sense(struct ata_queued_cmd *qc)
 	qc->tf.command = ATA_CMD_PACKET;
 
 	if (ata_pio_use_silly(ap)) {
-		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
+		qc->tf.protocol = ATAPI_PROT_DMA;
 		qc->tf.feature |= ATAPI_PKT_DMA;
 	} else {
-		qc->tf.protocol = ATA_PROT_ATAPI;
+		qc->tf.protocol = ATAPI_PROT_PIO;
 		qc->tf.lbam = SCSI_SENSE_BUFFERSIZE;
 		qc->tf.lbah = 0;
 	}
@@ -2526,12 +2528,12 @@ static unsigned int atapi_xlat(struct ata_queued_cmd *qc)
 	if (using_pio || nodata) {
 		/* no data, or PIO data xfer */
 		if (nodata)
-			qc->tf.protocol = ATA_PROT_ATAPI_NODATA;
+			qc->tf.protocol = ATAPI_PROT_NODATA;
 		else
-			qc->tf.protocol = ATA_PROT_ATAPI;
+			qc->tf.protocol = ATAPI_PROT_PIO;
 	} else {
 		/* DMA data xfer */
-		qc->tf.protocol = ATA_PROT_ATAPI_DMA;
+		qc->tf.protocol = ATAPI_PROT_DMA;
 		qc->tf.feature |= ATAPI_PKT_DMA;
 
 		if (atapi_dmadir && (scmd->sc_data_direction != DMA_TO_DEVICE))
@@ -2690,6 +2692,24 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 	if ((tf->protocol = ata_scsi_map_proto(cdb[1])) == ATA_PROT_UNKNOWN)
 		goto invalid_fld;
 
+	/*
+	 * Filter TPM commands by default. These provide an
+	 * essentially uncontrolled encrypted "back door" between
+	 * applications and the disk. Set libata.allow_tpm=1 if you
+	 * have a real reason for wanting to use them. This ensures
+	 * that installed software cannot easily mess stuff up without
+	 * user intent. DVR type users will probably ship with this enabled
+	 * for movie content management.
+	 *
+	 * Note that for ATA8 we can issue a DCS change and DCS freeze lock
+	 * for this and should do in future but that it is not sufficient as
+	 * DCS is an optional feature set. Thus we also do the software filter
+	 * so that we comply with the TC consortium stated goal that the user
+	 * can turn off TC features of their system.
+	 */
+	if (tf->command >= 0x5C && tf->command <= 0x5F && !libata_allow_tpm)
+		goto invalid_fld;
+
 	/* We may not issue DMA commands if no DMA mode is set */
 	if (tf->protocol == ATA_PROT_DMA && dev->dma_mode == 0)
 		goto invalid_fld;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index b7ac80b..60cd4b1 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -147,7 +147,9 @@ void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
  *	@tf: ATA taskfile register set for storing input
  *
  *	Reads ATA taskfile registers for currently-selected device
- *	into @tf.
+ *	into @tf. Assumes the device has a fully SFF compliant task file
+ *	layout and behaviour. If you device does not (eg has a different
+ *	status method) then you will need to provide a replacement tf_read
  *
  *	LOCKING:
  *	Inherited from caller.
@@ -156,7 +158,7 @@ void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
 {
 	struct ata_ioports *ioaddr = &ap->ioaddr;
 
-	tf->command = ata_chk_status(ap);
+	tf->command = ata_check_status(ap);
 	tf->feature = ioread8(ioaddr->error_addr);
 	tf->nsect = ioread8(ioaddr->nsect_addr);
 	tf->lbal = ioread8(ioaddr->lbal_addr);
@@ -415,7 +417,7 @@ void ata_bmdma_drive_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
 	ap->hsm_task_state = HSM_ST_IDLE;
 
 	if (qc && (qc->tf.protocol == ATA_PROT_DMA ||
-		   qc->tf.protocol == ATA_PROT_ATAPI_DMA)) {
+		   qc->tf.protocol == ATAPI_PROT_DMA)) {
 		u8 host_stat;
 
 		host_stat = ap->ops->bmdma_status(ap);
@@ -549,7 +551,7 @@ int ata_pci_init_bmdma(struct ata_host *host)
 		return rc;
 
 	/* request and iomap DMA region */
-	rc = pcim_iomap_regions(pdev, 1 << 4, DRV_NAME);
+	rc = pcim_iomap_regions(pdev, 1 << 4, dev_driver_string(gdev));
 	if (rc) {
 		dev_printk(KERN_ERR, gdev, "failed to request/iomap BAR4\n");
 		return -ENOMEM;
@@ -619,7 +621,8 @@ int ata_pci_init_sff_host(struct ata_host *host)
 			continue;
 		}
 
-		rc = pcim_iomap_regions(pdev, 0x3 << base, DRV_NAME);
+		rc = pcim_iomap_regions(pdev, 0x3 << base,
+					dev_driver_string(gdev));
 		if (rc) {
 			dev_printk(KERN_WARNING, gdev,
 				   "failed to request/iomap BARs for port %d "
@@ -711,6 +714,99 @@ int ata_pci_prepare_sff_host(struct pci_dev *pdev,
 }
 
 /**
+ *	ata_pci_activate_sff_host - start SFF host, request IRQ and register it
+ *	@host: target SFF ATA host
+ *	@irq_handler: irq_handler used when requesting IRQ(s)
+ *	@sht: scsi_host_template to use when registering the host
+ *
+ *	This is the counterpart of ata_host_activate() for SFF ATA
+ *	hosts.  This separate helper is necessary because SFF hosts
+ *	use two separate interrupts in legacy mode.
+ *
+ *	LOCKING:
+ *	Inherited from calling layer (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno otherwise.
+ */
+int ata_pci_activate_sff_host(struct ata_host *host,
+			      irq_handler_t irq_handler,
+			      struct scsi_host_template *sht)
+{
+	struct device *dev = host->dev;
+	struct pci_dev *pdev = to_pci_dev(dev);
+	const char *drv_name = dev_driver_string(host->dev);
+	int legacy_mode = 0, rc;
+
+	rc = ata_host_start(host);
+	if (rc)
+		return rc;
+
+	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
+		u8 tmp8, mask;
+
+		/* TODO: What if one channel is in native mode ... */
+		pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp8);
+		mask = (1 << 2) | (1 << 0);
+		if ((tmp8 & mask) != mask)
+			legacy_mode = 1;
+#if defined(CONFIG_NO_ATA_LEGACY)
+		/* Some platforms with PCI limits cannot address compat
+		   port space. In that case we punt if their firmware has
+		   left a device in compatibility mode */
+		if (legacy_mode) {
+			printk(KERN_ERR "ata: Compatibility mode ATA is not supported on this platform, skipping.\n");
+			return -EOPNOTSUPP;
+		}
+#endif
+	}
+
+	if (!devres_open_group(dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
+
+	if (!legacy_mode && pdev->irq) {
+		rc = devm_request_irq(dev, pdev->irq, irq_handler,
+				      IRQF_SHARED, drv_name, host);
+		if (rc)
+			goto out;
+
+		ata_port_desc(host->ports[0], "irq %d", pdev->irq);
+		ata_port_desc(host->ports[1], "irq %d", pdev->irq);
+	} else if (legacy_mode) {
+		if (!ata_port_is_dummy(host->ports[0])) {
+			rc = devm_request_irq(dev, ATA_PRIMARY_IRQ(pdev),
+					      irq_handler, IRQF_SHARED,
+					      drv_name, host);
+			if (rc)
+				goto out;
+
+			ata_port_desc(host->ports[0], "irq %d",
+				      ATA_PRIMARY_IRQ(pdev));
+		}
+
+		if (!ata_port_is_dummy(host->ports[1])) {
+			rc = devm_request_irq(dev, ATA_SECONDARY_IRQ(pdev),
+					      irq_handler, IRQF_SHARED,
+					      drv_name, host);
+			if (rc)
+				goto out;
+
+			ata_port_desc(host->ports[1], "irq %d",
+				      ATA_SECONDARY_IRQ(pdev));
+		}
+	}
+
+	rc = ata_host_register(host, sht);
+ out:
+	if (rc == 0)
+		devres_remove_group(dev, NULL);
+	else
+		devres_release_group(dev, NULL);
+
+	return rc;
+}
+
+/**
  *	ata_pci_init_one - Initialize/register PCI IDE host controller
  *	@pdev: Controller to be initialized
  *	@ppi: array of port_info, must be enough for two ports
@@ -739,8 +835,6 @@ int ata_pci_init_one(struct pci_dev *pdev,
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi = NULL;
 	struct ata_host *host = NULL;
-	u8 mask;
-	int legacy_mode = 0;
 	int i, rc;
 
 	DPRINTK("ENTER\n");
@@ -762,95 +856,24 @@ int ata_pci_init_one(struct pci_dev *pdev,
 	if (!devres_open_group(dev, NULL, GFP_KERNEL))
 		return -ENOMEM;
 
-	/* FIXME: Really for ATA it isn't safe because the device may be
-	   multi-purpose and we want to leave it alone if it was already
-	   enabled. Secondly for shared use as Arjan says we want refcounting
-
-	   Checking dev->is_enabled is insufficient as this is not set at
-	   boot for the primary video which is BIOS enabled
-	  */
-
 	rc = pcim_enable_device(pdev);
 	if (rc)
-		goto err_out;
+		goto out;
 
-	if ((pdev->class >> 8) == PCI_CLASS_STORAGE_IDE) {
-		u8 tmp8;
-
-		/* TODO: What if one channel is in native mode ... */
-		pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp8);
-		mask = (1 << 2) | (1 << 0);
-		if ((tmp8 & mask) != mask)
-			legacy_mode = 1;
-#if defined(CONFIG_NO_ATA_LEGACY)
-		/* Some platforms with PCI limits cannot address compat
-		   port space. In that case we punt if their firmware has
-		   left a device in compatibility mode */
-		if (legacy_mode) {
-			printk(KERN_ERR "ata: Compatibility mode ATA is not supported on this platform, skipping.\n");
-			rc = -EOPNOTSUPP;
-			goto err_out;
-		}
-#endif
-	}
-
-	/* prepare host */
+	/* prepare and activate SFF host */
 	rc = ata_pci_prepare_sff_host(pdev, ppi, &host);
 	if (rc)
-		goto err_out;
+		goto out;
 
 	pci_set_master(pdev);
+	rc = ata_pci_activate_sff_host(host, pi->port_ops->irq_handler,
+				       pi->sht);
+ out:
+	if (rc == 0)
+		devres_remove_group(&pdev->dev, NULL);
+	else
+		devres_release_group(&pdev->dev, NULL);
 
-	/* start host and request IRQ */
-	rc = ata_host_start(host);
-	if (rc)
-		goto err_out;
-
-	if (!legacy_mode && pdev->irq) {
-		/* We may have no IRQ assigned in which case we can poll. This
-		   shouldn't happen on a sane system but robustness is cheap
-		   in this case */
-		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
-				      IRQF_SHARED, DRV_NAME, host);
-		if (rc)
-			goto err_out;
-
-		ata_port_desc(host->ports[0], "irq %d", pdev->irq);
-		ata_port_desc(host->ports[1], "irq %d", pdev->irq);
-	} else if (legacy_mode) {
-		if (!ata_port_is_dummy(host->ports[0])) {
-			rc = devm_request_irq(dev, ATA_PRIMARY_IRQ(pdev),
-					      pi->port_ops->irq_handler,
-					      IRQF_SHARED, DRV_NAME, host);
-			if (rc)
-				goto err_out;
-
-			ata_port_desc(host->ports[0], "irq %d",
-				      ATA_PRIMARY_IRQ(pdev));
-		}
-
-		if (!ata_port_is_dummy(host->ports[1])) {
-			rc = devm_request_irq(dev, ATA_SECONDARY_IRQ(pdev),
-					      pi->port_ops->irq_handler,
-					      IRQF_SHARED, DRV_NAME, host);
-			if (rc)
-				goto err_out;
-
-			ata_port_desc(host->ports[1], "irq %d",
-				      ATA_SECONDARY_IRQ(pdev));
-		}
-	}
-
-	/* register */
-	rc = ata_host_register(host, pi->sht);
-	if (rc)
-		goto err_out;
-
-	devres_remove_group(dev, NULL);
-	return 0;
-
-err_out:
-	devres_release_group(dev, NULL);
 	return rc;
 }
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index bbe59c2..409ffb9 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -60,6 +60,7 @@ extern int atapi_dmadir;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
+extern int libata_allow_tpm;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
@@ -85,7 +86,6 @@ extern int ata_dev_configure(struct ata_device *dev);
 extern int sata_down_spd_limit(struct ata_link *link);
 extern int sata_set_spd_needed(struct ata_link *link);
 extern int ata_down_xfermask_limit(struct ata_device *dev, unsigned int sel);
-extern int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern void ata_sg_clean(struct ata_queued_cmd *qc);
 extern void ata_qc_free(struct ata_queued_cmd *qc);
 extern void ata_qc_issue(struct ata_queued_cmd *qc);
@@ -113,6 +113,7 @@ extern int ata_acpi_on_suspend(struct ata_port *ap);
 extern void ata_acpi_on_resume(struct ata_port *ap);
 extern int ata_acpi_on_devcfg(struct ata_device *dev);
 extern void ata_acpi_on_disable(struct ata_device *dev);
+extern void ata_acpi_set_state(struct ata_port *ap, pm_message_t state);
 #else
 static inline void ata_acpi_associate_sata_port(struct ata_port *ap) { }
 static inline void ata_acpi_associate(struct ata_host *host) { }
@@ -121,6 +122,8 @@ static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
 static inline void ata_acpi_on_resume(struct ata_port *ap) { }
 static inline int ata_acpi_on_devcfg(struct ata_device *dev) { return 0; }
 static inline void ata_acpi_on_disable(struct ata_device *dev) { }
+static inline void ata_acpi_set_state(struct ata_port *ap,
+				      pm_message_t state) { }
 #endif
 
 /* libata-scsi.c */
@@ -183,6 +186,7 @@ extern void ata_eh_report(struct ata_port *ap);
 extern int ata_eh_reset(struct ata_link *link, int classify,
 			ata_prereset_fn_t prereset, ata_reset_fn_t softreset,
 			ata_reset_fn_t hardreset, ata_postreset_fn_t postreset);
+extern int ata_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
 extern int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 			  ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
 			  ata_postreset_fn_t postreset,
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index e4542ab..244098a 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -81,17 +81,6 @@ static void pacpi_error_handler(struct ata_port *ap)
 				  NULL, ata_std_postreset);
 }
 
-/* Welcome to ACPI, bring a bucket */
-static const unsigned int pio_cycle[7] = {
-	600, 383, 240, 180, 120, 100, 80
-};
-static const unsigned int mwdma_cycle[5] = {
-	480, 150, 120, 100, 80
-};
-static const unsigned int udma_cycle[7] = {
-	120, 80, 60, 45, 30, 20, 15
-};
-
 /**
  *	pacpi_discover_modes	-	filter non ACPI modes
  *	@adev: ATA device
@@ -103,56 +92,20 @@ static const unsigned int udma_cycle[7] = {
 
 static unsigned long pacpi_discover_modes(struct ata_port *ap, struct ata_device *adev)
 {
-	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
-	int i;
-	u32 t;
-	unsigned long mask = (0x7f << ATA_SHIFT_UDMA) | (0x7 << ATA_SHIFT_MWDMA) | (0x1F << ATA_SHIFT_PIO);
-
 	struct ata_acpi_gtm probe;
+	unsigned int xfer_mask;
 
 	probe = acpi->gtm;
 
-	/* We always use the 0 slot for crap hardware */
-	if (!(probe.flags & 0x10))
-		unit = 0;
-
 	ata_acpi_gtm(ap, &probe);
 
-	/* Start by scanning for PIO modes */
-	for (i = 0; i < 7; i++) {
-		t = probe.drive[unit].pio;
-		if (t <= pio_cycle[i]) {
-			mask |= (2 << (ATA_SHIFT_PIO + i)) - 1;
-			break;
-		}
-	}
+	xfer_mask = ata_acpi_gtm_xfermask(adev, &probe);
 
-	/* See if we have MWDMA or UDMA data. We don't bother with MWDMA
-	   if UDMA is availabe as this means the BIOS set UDMA and our
-	   error changedown if it works is UDMA to PIO anyway */
-	if (probe.flags & (1 << (2 * unit))) {
-		/* MWDMA */
-		for (i = 0; i < 5; i++) {
-			t = probe.drive[unit].dma;
-			if (t <= mwdma_cycle[i]) {
-				mask |= (2 << (ATA_SHIFT_MWDMA + i)) - 1;
-				break;
-			}
-		}
-	} else {
-		/* UDMA */
-		for (i = 0; i < 7; i++) {
-			t = probe.drive[unit].dma;
-			if (t <= udma_cycle[i]) {
-				mask |= (2 << (ATA_SHIFT_UDMA + i)) - 1;
-				break;
-			}
-		}
-	}
-	if (mask & (0xF8 << ATA_SHIFT_UDMA))
+	if (xfer_mask & (0xF8 << ATA_SHIFT_UDMA))
 		ap->cbl = ATA_CBL_PATA80;
-	return mask;
+
+	return xfer_mask;
 }
 
 /**
@@ -180,12 +133,14 @@ static void pacpi_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
+	const struct ata_timing *t;
 
 	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
-	acpi->gtm.drive[unit].pio = pio_cycle[adev->pio_mode - XFER_PIO_0];
+	t = ata_timing_find_mode(adev->pio_mode);
+	acpi->gtm.drive[unit].pio = t->cycle;
 	ata_acpi_stm(ap, &acpi->gtm);
 	/* See what mode we actually got */
 	ata_acpi_gtm(ap, &acpi->gtm);
@@ -201,16 +156,18 @@ static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	int unit = adev->devno;
 	struct pata_acpi *acpi = ap->private_data;
+	const struct ata_timing *t;
 
 	if (!(acpi->gtm.flags & 0x10))
 		unit = 0;
 
 	/* Now stuff the nS values into the structure */
+	t = ata_timing_find_mode(adev->dma_mode);
 	if (adev->dma_mode >= XFER_UDMA_0) {
-		acpi->gtm.drive[unit].dma = udma_cycle[adev->dma_mode - XFER_UDMA_0];
+		acpi->gtm.drive[unit].dma = t->udma;
 		acpi->gtm.flags |= (1 << (2 * unit));
 	} else {
-		acpi->gtm.drive[unit].dma = mwdma_cycle[adev->dma_mode - XFER_MW_DMA_0];
+		acpi->gtm.drive[unit].dma = t->cycle;
 		acpi->gtm.flags &= ~(1 << (2 * unit));
 	}
 	ata_acpi_stm(ap, &acpi->gtm);
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 8caf9af..7e68edf 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -64,7 +64,7 @@ static int ali_cable_override(struct pci_dev *pdev)
 	if (pdev->subsystem_vendor == 0x10CF && pdev->subsystem_device == 0x10AF)
 	   	return 1;
 	/* Mitac 8317 (Winbook-A) and relatives */
-	if (pdev->subsystem_vendor == 0x1071  && pdev->subsystem_device == 0x8317)
+	if (pdev->subsystem_vendor == 0x1071 && pdev->subsystem_device == 0x8317)
 		return 1;
 	/* Systems by DMI */
 	if (dmi_check_system(cable_dmi_table))
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 3cc27b5..761a666 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -220,6 +220,62 @@ static void amd133_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	timing_setup(ap, adev, 0x40, adev->dma_mode, 4);
 }
 
+/* Both host-side and drive-side detection results are worthless on NV
+ * PATAs.  Ignore them and just follow what BIOS configured.  Both the
+ * current configuration in PCI config reg and ACPI GTM result are
+ * cached during driver attach and are consulted to select transfer
+ * mode.
+ */
+static unsigned long nv_mode_filter(struct ata_device *dev,
+				    unsigned long xfer_mask)
+{
+	static const unsigned int udma_mask_map[] =
+		{ ATA_UDMA2, ATA_UDMA1, ATA_UDMA0, 0,
+		  ATA_UDMA3, ATA_UDMA4, ATA_UDMA5, ATA_UDMA6 };
+	struct ata_port *ap = dev->link->ap;
+	char acpi_str[32] = "";
+	u32 saved_udma, udma;
+	const struct ata_acpi_gtm *gtm;
+	unsigned long bios_limit = 0, acpi_limit = 0, limit;
+
+	/* find out what BIOS configured */
+	udma = saved_udma = (unsigned long)ap->host->private_data;
+
+	if (ap->port_no == 0)
+		udma >>= 16;
+	if (dev->devno == 0)
+		udma >>= 8;
+
+	if ((udma & 0xc0) == 0xc0)
+		bios_limit = ata_pack_xfermask(0, 0, udma_mask_map[udma & 0x7]);
+
+	/* consult ACPI GTM too */
+	gtm = ata_acpi_init_gtm(ap);
+	if (gtm) {
+		acpi_limit = ata_acpi_gtm_xfermask(dev, gtm);
+
+		snprintf(acpi_str, sizeof(acpi_str), " (%u:%u:0x%x)",
+			 gtm->drive[0].dma, gtm->drive[1].dma, gtm->flags);
+	}
+
+	/* be optimistic, EH can take care of things if something goes wrong */
+	limit = bios_limit | acpi_limit;
+
+	/* If PIO or DMA isn't configured at all, don't limit.  Let EH
+	 * handle it.
+	 */
+	if (!(limit & ATA_MASK_PIO))
+		limit |= ATA_MASK_PIO;
+	if (!(limit & (ATA_MASK_MWDMA | ATA_MASK_UDMA)))
+		limit |= ATA_MASK_MWDMA | ATA_MASK_UDMA;
+
+	ata_port_printk(ap, KERN_DEBUG, "nv_mode_filter: 0x%lx&0x%lx->0x%lx, "
+			"BIOS=0x%lx (0x%x) ACPI=0x%lx%s\n",
+			xfer_mask, limit, xfer_mask & limit, bios_limit,
+			saved_udma, acpi_limit, acpi_str);
+
+	return xfer_mask & limit;
+}
 
 /**
  *	nv_probe_init	-	cable detection
@@ -252,31 +308,6 @@ static void nv_error_handler(struct ata_port *ap)
 			       ata_std_postreset);
 }
 
-static int nv_cable_detect(struct ata_port *ap)
-{
-	static const u8 bitmask[2] = {0x03, 0x0C};
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 ata66;
-	u16 udma;
-	int cbl;
-
-	pci_read_config_byte(pdev, 0x52, &ata66);
-	if (ata66 & bitmask[ap->port_no])
-		cbl = ATA_CBL_PATA80;
-	else
-		cbl = ATA_CBL_PATA40;
-
- 	/* We now have to double check because the Nvidia boxes BIOS
- 	   doesn't always set the cable bits but does set mode bits */
- 	pci_read_config_word(pdev, 0x62 - 2 * ap->port_no, &udma);
- 	if ((udma & 0xC4) == 0xC4 || (udma & 0xC400) == 0xC400)
-		cbl = ATA_CBL_PATA80;
-	/* And a triple check across suspend/resume with ACPI around */
-	if (ata_acpi_cbl_80wire(ap))
-		cbl = ATA_CBL_PATA80;
-	return cbl;
-}
-
 /**
  *	nv100_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -314,6 +345,14 @@ static void nv133_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	timing_setup(ap, adev, 0x50, adev->dma_mode, 4);
 }
 
+static void nv_host_stop(struct ata_host *host)
+{
+	u32 udma = (unsigned long)host->private_data;
+
+	/* restore PCI config register 0x60 */
+	pci_write_config_dword(to_pci_dev(host->dev), 0x60, udma);
+}
+
 static struct scsi_host_template amd_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -478,7 +517,8 @@ static struct ata_port_operations nv100_port_ops = {
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
-	.cable_detect	= nv_cable_detect,
+	.cable_detect	= ata_cable_ignore,
+	.mode_filter	= nv_mode_filter,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -495,6 +535,7 @@ static struct ata_port_operations nv100_port_ops = {
 	.irq_on		= ata_irq_on,
 
 	.port_start	= ata_sff_port_start,
+	.host_stop	= nv_host_stop,
 };
 
 static struct ata_port_operations nv133_port_ops = {
@@ -511,7 +552,8 @@ static struct ata_port_operations nv133_port_ops = {
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= nv_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
-	.cable_detect	= nv_cable_detect,
+	.cable_detect	= ata_cable_ignore,
+	.mode_filter	= nv_mode_filter,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
@@ -528,6 +570,7 @@ static struct ata_port_operations nv133_port_ops = {
 	.irq_on		= ata_irq_on,
 
 	.port_start	= ata_sff_port_start,
+	.host_stop	= nv_host_stop,
 };
 
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -614,7 +657,8 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.port_ops = &amd100_port_ops
 		}
 	};
-	const struct ata_port_info *ppi[] = { NULL, NULL };
+	struct ata_port_info pi;
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	static int printed_version;
 	int type = id->driver_data;
 	u8 fifo;
@@ -628,6 +672,19 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (type == 1 && pdev->revision > 0x7)
 		type = 2;
 
+	/* Serenade ? */
+	if (type == 5 && pdev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
+			 pdev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
+		type = 6;	/* UDMA 100 only */
+
+	/*
+	 * Okay, type is determined now.  Apply type-specific workarounds.
+	 */
+	pi = info[type];
+
+	if (type < 3)
+		ata_pci_clear_simplex(pdev);
+
 	/* Check for AMD7411 */
 	if (type == 3)
 		/* FIFO is broken */
@@ -635,16 +692,17 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	else
 		pci_write_config_byte(pdev, 0x41, fifo | 0xF0);
 
-	/* Serenade ? */
-	if (type == 5 && pdev->subsystem_vendor == PCI_VENDOR_ID_AMD &&
-			 pdev->subsystem_device == PCI_DEVICE_ID_AMD_SERENADE)
-		type = 6;	/* UDMA 100 only */
+	/* Cable detection on Nvidia chips doesn't work too well,
+	 * cache BIOS programmed UDMA mode.
+	 */
+	if (type == 7 || type == 8) {
+		u32 udma;
 
-	if (type < 3)
-		ata_pci_clear_simplex(pdev);
+		pci_read_config_dword(pdev, 0x60, &udma);
+		pi.private_data = (void *)(unsigned long)udma;
+	}
 
 	/* And fire it up */
-	ppi[0] = &info[type];
 	return ata_pci_init_one(pdev, ppi);
 }
 
diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 7842cc4..a32e3c4 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -832,6 +832,7 @@ static void bfin_bmdma_setup(struct ata_queued_cmd *qc)
 {
 	unsigned short config = WDSIZE_16;
 	struct scatterlist *sg;
+	unsigned int si;
 
 	pr_debug("in atapi dma setup\n");
 	/* Program the ATA_CTRL register with dir */
@@ -839,7 +840,7 @@ static void bfin_bmdma_setup(struct ata_queued_cmd *qc)
 		/* fill the ATAPI DMA controller */
 		set_dma_config(CH_ATAPI_TX, config);
 		set_dma_x_modify(CH_ATAPI_TX, 2);
-		ata_for_each_sg(sg, qc) {
+		for_each_sg(qc->sg, sg, qc->n_elem, si) {
 			set_dma_start_addr(CH_ATAPI_TX, sg_dma_address(sg));
 			set_dma_x_count(CH_ATAPI_TX, sg_dma_len(sg) >> 1);
 		}
@@ -848,7 +849,7 @@ static void bfin_bmdma_setup(struct ata_queued_cmd *qc)
 		/* fill the ATAPI DMA controller */
 		set_dma_config(CH_ATAPI_RX, config);
 		set_dma_x_modify(CH_ATAPI_RX, 2);
-		ata_for_each_sg(sg, qc) {
+		for_each_sg(qc->sg, sg, qc->n_elem, si) {
 			set_dma_start_addr(CH_ATAPI_RX, sg_dma_address(sg));
 			set_dma_x_count(CH_ATAPI_RX, sg_dma_len(sg) >> 1);
 		}
@@ -867,6 +868,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 	struct ata_port *ap = qc->ap;
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
 	struct scatterlist *sg;
+	unsigned int si;
 
 	pr_debug("in atapi dma start\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
@@ -881,7 +883,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 		 * data cache is enabled. Otherwise, this loop
 		 * is an empty loop and optimized out.
 		 */
-		ata_for_each_sg(sg, qc) {
+		for_each_sg(qc->sg, sg, qc->n_elem, si) {
 			flush_dcache_range(sg_dma_address(sg),
 				sg_dma_address(sg) + sg_dma_len(sg));
 		}
@@ -910,7 +912,7 @@ static void bfin_bmdma_start(struct ata_queued_cmd *qc)
 	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | TFRCNT_RST);
 
 		/* Set transfer length to buffer len */
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		ATAPI_SET_XFER_LEN(base, (sg_dma_len(sg) >> 1));
 	}
 
@@ -932,6 +934,7 @@ static void bfin_bmdma_stop(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
+	unsigned int si;
 
 	pr_debug("in atapi dma stop\n");
 	if (!(ap->udma_mask || ap->mwdma_mask))
@@ -950,7 +953,7 @@ static void bfin_bmdma_stop(struct ata_queued_cmd *qc)
 			 * data cache is enabled. Otherwise, this loop
 			 * is an empty loop and optimized out.
 			 */
-			ata_for_each_sg(sg, qc) {
+			for_each_sg(qc->sg, sg, qc->n_elem, si) {
 				invalidate_dcache_range(
 					sg_dma_address(sg),
 					sg_dma_address(sg)
@@ -1167,34 +1170,36 @@ static unsigned char bfin_bmdma_status(struct ata_port *ap)
  *	Note: Original code is ata_data_xfer().
  */
 
-static void bfin_data_xfer(struct ata_device *adev, unsigned char *buf,
-			   unsigned int buflen, int write_data)
+static unsigned int bfin_data_xfer(struct ata_device *dev, unsigned char *buf,
+				   unsigned int buflen, int rw)
 {
-	struct ata_port *ap = adev->link->ap;
-	unsigned int words = buflen >> 1;
-	unsigned short *buf16 = (u16 *) buf;
+	struct ata_port *ap = dev->link->ap;
 	void __iomem *base = (void __iomem *)ap->ioaddr.ctl_addr;
+	unsigned int words = buflen >> 1;
+	unsigned short *buf16 = (u16 *)buf;
 
 	/* Transfer multiple of 2 bytes */
-	if (write_data) {
-		write_atapi_data(base, words, buf16);
-	} else {
+	if (rw == READ)
 		read_atapi_data(base, words, buf16);
-	}
+	else
+		write_atapi_data(base, words, buf16);
 
 	/* Transfer trailing 1 byte, if any. */
 	if (unlikely(buflen & 0x01)) {
 		unsigned short align_buf[1] = { 0 };
 		unsigned char *trailing_buf = buf + buflen - 1;
 
-		if (write_data) {
-			memcpy(align_buf, trailing_buf, 1);
-			write_atapi_data(base, 1, align_buf);
-		} else {
+		if (rw == READ) {
 			read_atapi_data(base, 1, align_buf);
 			memcpy(trailing_buf, align_buf, 1);
+		} else {
+			memcpy(align_buf, trailing_buf, 1);
+			write_atapi_data(base, 1, align_buf);
 		}
+		words++;
 	}
+
+	return words << 1;
 }
 
 /**
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 33f7f08..d4590f5 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -198,7 +198,7 @@ static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_devi
 	};
 	const struct ata_port_info *ppi[2];
 	u8 pcicfg;
-	void *iomap[5];
+	void __iomem *iomap[5];
 	struct ata_host *host;
 	struct ata_ioports *ioaddr;
 	int i, rc;
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index c79f066..68eb349 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -847,15 +847,16 @@ static u32 hpt374_read_freq(struct pci_dev *pdev)
 	u32 freq;
 	unsigned long io_base = pci_resource_start(pdev, 4);
 	if (PCI_FUNC(pdev->devfn) & 1) {
-		struct pci_dev *pdev_0 = pci_get_slot(pdev->bus, pdev->devfn - 1);
+		struct pci_dev *pdev_0;
+
+		pdev_0 = pci_get_slot(pdev->bus, pdev->devfn - 1);
 		/* Someone hot plugged the controller on us ? */
 		if (pdev_0 == NULL)
 			return 0;
 		io_base = pci_resource_start(pdev_0, 4);
 		freq = inl(io_base + 0x90);
 		pci_dev_put(pdev_0);
-	}
-	else
+	} else
 		freq = inl(io_base + 0x90);
 	return freq;
 }
diff --git a/drivers/ata/pata_icside.c b/drivers/ata/pata_icside.c
index 842fe08..5b8586d 100644
--- a/drivers/ata/pata_icside.c
+++ b/drivers/ata/pata_icside.c
@@ -224,6 +224,7 @@ static void pata_icside_bmdma_setup(struct ata_queued_cmd *qc)
 	struct pata_icside_state *state = ap->host->private_data;
 	struct scatterlist *sg, *rsg = state->sg;
 	unsigned int write = qc->tf.flags & ATA_TFLAG_WRITE;
+	unsigned int si;
 
 	/*
 	 * We are simplex; BUG if we try to fiddle with DMA
@@ -234,7 +235,7 @@ static void pata_icside_bmdma_setup(struct ata_queued_cmd *qc)
 	/*
 	 * Copy ATAs scattered sg list into a contiguous array of sg
 	 */
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		memcpy(rsg, sg, sizeof(*sg));
 		rsg++;
 	}
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index ca9aae0..109ddd4 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -430,7 +430,7 @@ static unsigned int it821x_smart_qc_issue_prot(struct ata_queued_cmd *qc)
 			return ata_qc_issue_prot(qc);
 	}
 	printk(KERN_DEBUG "it821x: can't process command 0x%02X\n", qc->tf.command);
-	return AC_ERR_INVALID;
+	return AC_ERR_DEV;
 }
 
 /**
@@ -516,6 +516,37 @@ static void it821x_dev_config(struct ata_device *adev)
 			printk("(%dK stripe)", adev->id[146]);
 		printk(".\n");
 	}
+	/* This is a controller firmware triggered funny, don't
+	   report the drive faulty! */
+	adev->horkage &= ~ATA_HORKAGE_DIAGNOSTIC;
+}
+
+/**
+ *	it821x_ident_hack	-	Hack identify data up
+ *	@ap: Port
+ *
+ *	Walk the devices on this firmware driven port and slightly
+ *	mash the identify data to stop us and common tools trying to
+ *	use features not firmware supported. The firmware itself does
+ *	some masking (eg SMART) but not enough.
+ *
+ *	This is a bit of an abuse of the cable method, but it is the
+ *	only method called at the right time. We could modify the libata
+ *	core specifically for ident hacking but while we have one offender
+ *	it seems better to keep the fallout localised.
+ */
+
+static int it821x_ident_hack(struct ata_port *ap)
+{
+	struct ata_device *adev;
+	ata_link_for_each_dev(adev, &ap->link) {
+		if (ata_dev_enabled(adev)) {
+			adev->id[84] &= ~(1 << 6);	/* No FUA */
+			adev->id[85] &= ~(1 << 10);	/* No HPA */
+			adev->id[76] = 0;		/* No NCQ/AN etc */
+		}
+	}
+	return ata_cable_unknown(ap);
 }
 
 
@@ -634,7 +665,7 @@ static struct ata_port_operations it821x_smart_port_ops = {
 	.thaw		= ata_bmdma_thaw,
 	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
-	.cable_detect	= ata_cable_unknown,
+	.cable_detect	= it821x_ident_hack,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 120b5bf..030878f 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -42,13 +42,13 @@ static int ixp4xx_set_mode(struct ata_link *link, struct ata_device **error)
 	return 0;
 }
 
-static void ixp4xx_mmio_data_xfer(struct ata_device *adev, unsigned char *buf,
-				unsigned int buflen, int write_data)
+static unsigned int ixp4xx_mmio_data_xfer(struct ata_device *dev,
+				unsigned char *buf, unsigned int buflen, int rw)
 {
 	unsigned int i;
 	unsigned int words = buflen >> 1;
 	u16 *buf16 = (u16 *) buf;
-	struct ata_port *ap = adev->link->ap;
+	struct ata_port *ap = dev->link->ap;
 	void __iomem *mmio = ap->ioaddr.data_addr;
 	struct ixp4xx_pata_data *data = ap->host->dev->platform_data;
 
@@ -59,30 +59,32 @@ static void ixp4xx_mmio_data_xfer(struct ata_device *adev, unsigned char *buf,
 	udelay(100);
 
 	/* Transfer multiple of 2 bytes */
-	if (write_data) {
-		for (i = 0; i < words; i++)
-			writew(buf16[i], mmio);
-	} else {
+	if (rw == READ)
 		for (i = 0; i < words; i++)
 			buf16[i] = readw(mmio);
-	}
+	else
+		for (i = 0; i < words; i++)
+			writew(buf16[i], mmio);
 
 	/* Transfer trailing 1 byte, if any. */
 	if (unlikely(buflen & 0x01)) {
 		u16 align_buf[1] = { 0 };
 		unsigned char *trailing_buf = buf + buflen - 1;
 
-		if (write_data) {
-			memcpy(align_buf, trailing_buf, 1);
-			writew(align_buf[0], mmio);
-		} else {
+		if (rw == READ) {
 			align_buf[0] = readw(mmio);
 			memcpy(trailing_buf, align_buf, 1);
+		} else {
+			memcpy(align_buf, trailing_buf, 1);
+			writew(align_buf[0], mmio);
 		}
+		words++;
 	}
 
 	udelay(100);
 	*data->cs0_cfg |= 0x01;
+
+	return words << 1;
 }
 
 static struct scsi_host_template ixp4xx_sht = {
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 17159b5..333dc15 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -28,7 +28,6 @@
  *
  *  Unsupported but docs exist:
  *	Appian/Adaptec AIC25VL01/Cirrus Logic PD7220
- *	Winbond W83759A
  *
  *  This driver handles legacy (that is "ISA/VLB side") IDE ports found
  *  on PC class systems. There are three hybrid devices that are exceptions
@@ -36,7 +35,7 @@
  *  the MPIIX where the tuning is PCI side but the IDE is "ISA side".
  *
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
- *  opti82c465mv/promise 20230c/20630
+ *  opti82c465mv/promise 20230c/20630/winbond83759A
  *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
@@ -47,9 +46,6 @@
  *  For now use autospeed and pio_mask as above with the W83759A. This may
  *  change.
  *
- *  TODO
- *	Merge existing pata_qdi driver
- *
  */
 
 #include <linux/kernel.h>
@@ -64,12 +60,13 @@
 #include <linux/platform_device.h>
 
 #define DRV_NAME "pata_legacy"
-#define DRV_VERSION "0.5.5"
+#define DRV_VERSION "0.6.5"
 
 #define NR_HOST 6
 
-static int legacy_port[NR_HOST] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
-static int legacy_irq[NR_HOST] = { 14, 15, 11, 10, 8, 12 };
+static int all;
+module_param(all, int, 0444);
+MODULE_PARM_DESC(all, "Grab all legacy port devices, even if PCI(0=off, 1=on)");
 
 struct legacy_data {
 	unsigned long timing;
@@ -80,21 +77,107 @@ struct legacy_data {
 
 };
 
+enum controller {
+	BIOS = 0,
+	SNOOP = 1,
+	PDC20230 = 2,
+	HT6560A = 3,
+	HT6560B = 4,
+	OPTI611A = 5,
+	OPTI46X = 6,
+	QDI6500 = 7,
+	QDI6580 = 8,
+	QDI6580DP = 9,		/* Dual channel mode is different */
+	W83759A = 10,
+
+	UNKNOWN = -1
+};
+
+
+struct legacy_probe {
+	unsigned char *name;
+	unsigned long port;
+	unsigned int irq;
+	unsigned int slot;
+	enum controller type;
+	unsigned long private;
+};
+
+struct legacy_controller {
+	const char *name;
+	struct ata_port_operations *ops;
+	unsigned int pio_mask;
+	unsigned int flags;
+	int (*setup)(struct platform_device *, struct legacy_probe *probe,
+		struct legacy_data *data);
+};
+
+static int legacy_port[NR_HOST] = { 0x1f0, 0x170, 0x1e8, 0x168, 0x1e0, 0x160 };
+
+static struct legacy_probe probe_list[NR_HOST];
 static struct legacy_data legacy_data[NR_HOST];
 static struct ata_host *legacy_host[NR_HOST];
 static int nr_legacy_host;
 
 
-static int probe_all;			/* Set to check all ISA port ranges */
-static int ht6560a;			/* HT 6560A on primary 1, secondary 2, both 3 */
-static int ht6560b;			/* HT 6560A on primary 1, secondary 2, both 3 */
-static int opti82c611a;			/* Opti82c611A on primary 1, secondary 2, both 3 */
-static int opti82c46x;			/* Opti 82c465MV present (pri/sec autodetect) */
-static int autospeed;			/* Chip present which snoops speed changes */
-static int pio_mask = 0x1F;		/* PIO range for autospeed devices */
+static int probe_all;		/* Set to check all ISA port ranges */
+static int ht6560a;		/* HT 6560A on primary 1, second 2, both 3 */
+static int ht6560b;		/* HT 6560A on primary 1, second 2, both 3 */
+static int opti82c611a;		/* Opti82c611A on primary 1, sec 2, both 3 */
+static int opti82c46x;		/* Opti 82c465MV present(pri/sec autodetect) */
+static int qdi;			/* Set to probe QDI controllers */
+static int winbond;		/* Set to probe Winbond controllers,
+					give I/O port if non stdanard */
+static int autospeed;		/* Chip present which snoops speed changes */
+static int pio_mask = 0x1F;	/* PIO range for autospeed devices */
 static int iordy_mask = 0xFFFFFFFF;	/* Use iordy if available */
 
 /**
+ *	legacy_probe_add	-	Add interface to probe list
+ *	@port: Controller port
+ *	@irq: IRQ number
+ *	@type: Controller type
+ *	@private: Controller specific info
+ *
+ *	Add an entry into the probe list for ATA controllers. This is used
+ *	to add the default ISA slots and then to build up the table
+ *	further according to other ISA/VLB/Weird device scans
+ *
+ *	An I/O port list is used to keep ordering stable and sane, as we
+ *	don't have any good way to talk about ordering otherwise
+ */
+
+static int legacy_probe_add(unsigned long port, unsigned int irq,
+				enum controller type, unsigned long private)
+{
+	struct legacy_probe *lp = &probe_list[0];
+	int i;
+	struct legacy_probe *free = NULL;
+
+	for (i = 0; i < NR_HOST; i++) {
+		if (lp->port == 0 && free == NULL)
+			free = lp;
+		/* Matching port, or the correct slot for ordering */
+		if (lp->port == port || legacy_port[i] == port) {
+			free = lp;
+			break;
+		}
+		lp++;
+	}
+	if (free == NULL) {
+		printk(KERN_ERR "pata_legacy: Too many interfaces.\n");
+		return -1;
+	}
+	/* Fill in the entry for later probing */
+	free->port = port;
+	free->irq = irq;
+	free->type = type;
+	free->private = private;
+	return 0;
+}
+
+
+/**
  *	legacy_set_mode		-	mode setting
  *	@link: IDE link
  *	@unused: Device that failed when error is returned
@@ -113,7 +196,8 @@ static int legacy_set_mode(struct ata_link *link, struct ata_device **unused)
 
 	ata_link_for_each_dev(dev, link) {
 		if (ata_dev_enabled(dev)) {
-			ata_dev_printk(dev, KERN_INFO, "configured for PIO\n");
+			ata_dev_printk(dev, KERN_INFO,
+						"configured for PIO\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
 			dev->xfer_shift = ATA_SHIFT_PIO;
@@ -171,7 +255,7 @@ static struct ata_port_operations simple_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 static struct ata_port_operations legacy_port_ops = {
@@ -198,15 +282,16 @@ static struct ata_port_operations legacy_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
  *	Promise 20230C and 20620 support
  *
- *	This controller supports PIO0 to PIO2. We set PIO timings conservatively to
- *	allow for 50MHz Vesa Local Bus. The 20620 DMA support is weird being DMA to
- *	controller and PIO'd to the host and not supported.
+ *	This controller supports PIO0 to PIO2. We set PIO timings
+ *	conservatively to allow for 50MHz Vesa Local Bus. The 20620 DMA
+ *	support is weird being DMA to controller and PIO'd to the host
+ *	and not supported.
  */
 
 static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -221,8 +306,7 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	local_irq_save(flags);
 
 	/* Unlock the control interface */
-	do
-	{
+	do {
 		inb(0x1F5);
 		outb(inb(0x1F2) | 0x80, 0x1F2);
 		inb(0x1F2);
@@ -231,7 +315,7 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		inb(0x1F2);
 		inb(0x1F2);
 	}
-	while((inb(0x1F2) & 0x80) && --tries);
+	while ((inb(0x1F2) & 0x80) && --tries);
 
 	local_irq_restore(flags);
 
@@ -249,13 +333,14 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 
 }
 
-static void pdc_data_xfer_vlb(struct ata_device *adev, unsigned char *buf, unsigned int buflen, int write_data)
+static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw)
 {
-	struct ata_port *ap = adev->link->ap;
-	int slop = buflen & 3;
-	unsigned long flags;
+	if (ata_id_has_dword_io(dev->id)) {
+		struct ata_port *ap = dev->link->ap;
+		int slop = buflen & 3;
+		unsigned long flags;
 
-	if (ata_id_has_dword_io(adev->id)) {
 		local_irq_save(flags);
 
 		/* Perform the 32bit I/O synchronization sequence */
@@ -264,26 +349,27 @@ static void pdc_data_xfer_vlb(struct ata_device *adev, unsigned char *buf, unsig
 		ioread8(ap->ioaddr.nsect_addr);
 
 		/* Now the data */
-
-		if (write_data)
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
+		if (rw == READ)
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
+		else
+			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad = 0;
-			if (write_data) {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			} else {
+			u32 pad;
+			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
+			} else {
+				memcpy(&pad, buf + buflen - slop, slop);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			}
+			buflen += 4 - slop;
 		}
 		local_irq_restore(flags);
-	}
-	else
-		ata_data_xfer_noirq(adev, buf, buflen, write_data);
+	} else
+		buflen = ata_data_xfer_noirq(dev, buf, buflen, rw);
+
+	return buflen;
 }
 
 static struct ata_port_operations pdc20230_port_ops = {
@@ -310,14 +396,14 @@ static struct ata_port_operations pdc20230_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
  *	Holtek 6560A support
  *
- *	This controller supports PIO0 to PIO2 (no IORDY even though higher timings
- *	can be loaded).
+ *	This controller supports PIO0 to PIO2 (no IORDY even though higher
+ *	timings can be loaded).
  */
 
 static void ht6560a_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -364,14 +450,14 @@ static struct ata_port_operations ht6560a_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
  *	Holtek 6560B support
  *
- *	This controller supports PIO0 to PIO4. We honour the BIOS/jumper FIFO setting
- *	unless we see an ATAPI device in which case we force it off.
+ *	This controller supports PIO0 to PIO4. We honour the BIOS/jumper FIFO
+ *	setting unless we see an ATAPI device in which case we force it off.
  *
  *	FIXME: need to implement 2nd channel support.
  */
@@ -398,7 +484,7 @@ static void ht6560b_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	if (adev->class != ATA_DEV_ATA) {
 		u8 rconf = inb(0x3E6);
 		if (rconf & 0x24) {
-			rconf &= ~ 0x24;
+			rconf &= ~0x24;
 			outb(rconf, 0x3E6);
 		}
 	}
@@ -423,13 +509,13 @@ static struct ata_port_operations ht6560b_port_ops = {
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
 
-	.data_xfer	= ata_data_xfer,	/* FIXME: Check 32bit and noirq */
+	.data_xfer	= ata_data_xfer,    /* FIXME: Check 32bit and noirq */
 
 	.irq_handler	= ata_interrupt,
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -462,7 +548,8 @@ static u8 opti_syscfg(u8 reg)
  *	This controller supports PIO0 to PIO3.
  */
 
-static void opti82c611a_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void opti82c611a_set_piomode(struct ata_port *ap,
+						struct ata_device *adev)
 {
 	u8 active, recover, setup;
 	struct ata_timing t;
@@ -549,7 +636,7 @@ static struct ata_port_operations opti82c611a_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
 /*
@@ -681,77 +768,398 @@ static struct ata_port_operations opti82c46x_port_ops = {
 	.irq_clear	= ata_bmdma_irq_clear,
 	.irq_on		= ata_irq_on,
 
-	.port_start	= ata_port_start,
+	.port_start	= ata_sff_port_start,
 };
 
+static void qdi6500_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_timing t;
+	struct legacy_data *qdi = ap->host->private_data;
+	int active, recovery;
+	u8 timing;
+
+	/* Get the timing data in cycles */
+	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	if (qdi->fast) {
+		active = 8 - FIT(t.active, 1, 8);
+		recovery = 18 - FIT(t.recover, 3, 18);
+	} else {
+		active = 9 - FIT(t.active, 2, 9);
+		recovery = 15 - FIT(t.recover, 0, 15);
+	}
+	timing = (recovery << 4) | active | 0x08;
+
+	qdi->clock[adev->devno] = timing;
+
+	outb(timing, qdi->timing);
+}
 
 /**
- *	legacy_init_one		-	attach a legacy interface
- *	@port: port number
- *	@io: I/O port start
- *	@ctrl: control port
+ *	qdi6580dp_set_piomode		-	PIO setup for dual channel
+ *	@ap: Port
+ *	@adev: Device
  *	@irq: interrupt line
  *
- *	Register an ISA bus IDE interface. Such interfaces are PIO and we
- *	assume do not support IRQ sharing.
+ *	In dual channel mode the 6580 has one clock per channel and we have
+ *	to software clockswitch in qc_issue_prot.
  */
 
-static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl, int irq)
+static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	struct legacy_data *ld = &legacy_data[nr_legacy_host];
-	struct ata_host *host;
-	struct ata_port *ap;
-	struct platform_device *pdev;
-	struct ata_port_operations *ops = &legacy_port_ops;
-	void __iomem *io_addr, *ctrl_addr;
-	int pio_modes = pio_mask;
-	u32 mask = (1 << port);
-	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
-	int ret;
+	struct ata_timing t;
+	struct legacy_data *qdi = ap->host->private_data;
+	int active, recovery;
+	u8 timing;
 
-	pdev = platform_device_register_simple(DRV_NAME, nr_legacy_host, NULL, 0);
-	if (IS_ERR(pdev))
-		return PTR_ERR(pdev);
+	/* Get the timing data in cycles */
+	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	if (qdi->fast) {
+		active = 8 - FIT(t.active, 1, 8);
+		recovery = 18 - FIT(t.recover, 3, 18);
+	} else {
+		active = 9 - FIT(t.active, 2, 9);
+		recovery = 15 - FIT(t.recover, 0, 15);
+	}
+	timing = (recovery << 4) | active | 0x08;
 
-	ret = -EBUSY;
-	if (devm_request_region(&pdev->dev, io, 8, "pata_legacy") == NULL ||
-	    devm_request_region(&pdev->dev, ctrl, 1, "pata_legacy") == NULL)
-		goto fail;
+	qdi->clock[adev->devno] = timing;
 
-	ret = -ENOMEM;
-	io_addr = devm_ioport_map(&pdev->dev, io, 8);
-	ctrl_addr = devm_ioport_map(&pdev->dev, ctrl, 1);
-	if (!io_addr || !ctrl_addr)
-		goto fail;
+	outb(timing, qdi->timing + 2 * ap->port_no);
+	/* Clear the FIFO */
+	if (adev->class != ATA_DEV_ATA)
+		outb(0x5F, qdi->timing + 3);
+}
 
-	if (ht6560a & mask) {
-		ops = &ht6560a_port_ops;
-		pio_modes = 0x07;
-		iordy = ATA_FLAG_NO_IORDY;
-	}
-	if (ht6560b & mask) {
-		ops = &ht6560b_port_ops;
-		pio_modes = 0x1F;
-	}
-	if (opti82c611a & mask) {
-		ops = &opti82c611a_port_ops;
-		pio_modes = 0x0F;
+/**
+ *	qdi6580_set_piomode		-	PIO setup for single channel
+ *	@ap: Port
+ *	@adev: Device
+ *
+ *	In single channel mode the 6580 has one clock per device and we can
+ *	avoid the requirement to clock switch. We also have to load the timing
+ *	into the right clock according to whether we are master or slave.
+ */
+
+static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_timing t;
+	struct legacy_data *qdi = ap->host->private_data;
+	int active, recovery;
+	u8 timing;
+
+	/* Get the timing data in cycles */
+	ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	if (qdi->fast) {
+		active = 8 - FIT(t.active, 1, 8);
+		recovery = 18 - FIT(t.recover, 3, 18);
+	} else {
+		active = 9 - FIT(t.active, 2, 9);
+		recovery = 15 - FIT(t.recover, 0, 15);
 	}
-	if (opti82c46x & mask) {
-		ops = &opti82c46x_port_ops;
-		pio_modes = 0x0F;
+	timing = (recovery << 4) | active | 0x08;
+	qdi->clock[adev->devno] = timing;
+	outb(timing, qdi->timing + 2 * adev->devno);
+	/* Clear the FIFO */
+	if (adev->class != ATA_DEV_ATA)
+		outb(0x5F, qdi->timing + 3);
+}
+
+/**
+ *	qdi_qc_issue_prot	-	command issue
+ *	@qc: command pending
+ *
+ *	Called when the libata layer is about to issue a command. We wrap
+ *	this interface so that we can load the correct ATA timings.
+ */
+
+static unsigned int qdi_qc_issue_prot(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ata_device *adev = qc->dev;
+	struct legacy_data *qdi = ap->host->private_data;
+
+	if (qdi->clock[adev->devno] != qdi->last) {
+		if (adev->pio_mode) {
+			qdi->last = qdi->clock[adev->devno];
+			outb(qdi->clock[adev->devno], qdi->timing +
+							2 * ap->port_no);
+		}
 	}
+	return ata_qc_issue_prot(qc);
+}
 
-	/* Probe for automatically detectable controllers */
+static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
+					unsigned int buflen, int rw)
+{
+	struct ata_port *ap = adev->link->ap;
+	int slop = buflen & 3;
 
-	if (io == 0x1F0 && ops == &legacy_port_ops) {
-		unsigned long flags;
+	if (ata_id_has_dword_io(adev->id)) {
+		if (rw == WRITE)
+			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
+		else
+			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
-		local_irq_save(flags);
+		if (unlikely(slop)) {
+			u32 pad;
+			if (rw == WRITE) {
+				memcpy(&pad, buf + buflen - slop, slop);
+				pad = le32_to_cpu(pad);
+				iowrite32(pad, ap->ioaddr.data_addr);
+			} else {
+				pad = ioread32(ap->ioaddr.data_addr);
+				pad = cpu_to_le32(pad);
+				memcpy(buf + buflen - slop, &pad, slop);
+			}
+		}
+		return (buflen + 3) & ~3;
+	} else
+		return ata_data_xfer(adev, buf, buflen, rw);
+}
+
+static int qdi_port(struct platform_device *dev,
+			struct legacy_probe *lp, struct legacy_data *ld)
+{
+	if (devm_request_region(&dev->dev, lp->private, 4, "qdi") == NULL)
+		return -EBUSY;
+	ld->timing = lp->private;
+	return 0;
+}
+
+static struct ata_port_operations qdi6500_port_ops = {
+	.set_piomode	= qdi6500_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= qdi_qc_issue_prot,
+
+	.data_xfer	= vlb32_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static struct ata_port_operations qdi6580_port_ops = {
+	.set_piomode	= qdi6580_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= ata_qc_issue_prot,
+
+	.data_xfer	= vlb32_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static struct ata_port_operations qdi6580dp_port_ops = {
+	.set_piomode	= qdi6580dp_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= qdi_qc_issue_prot,
+
+	.data_xfer	= vlb32_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static DEFINE_SPINLOCK(winbond_lock);
+
+static void winbond_writecfg(unsigned long port, u8 reg, u8 val)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&winbond_lock, flags);
+	outb(reg, port + 0x01);
+	outb(val, port + 0x02);
+	spin_unlock_irqrestore(&winbond_lock, flags);
+}
+
+static u8 winbond_readcfg(unsigned long port, u8 reg)
+{
+	u8 val;
+
+	unsigned long flags;
+	spin_lock_irqsave(&winbond_lock, flags);
+	outb(reg, port + 0x01);
+	val = inb(port + 0x02);
+	spin_unlock_irqrestore(&winbond_lock, flags);
+
+	return val;
+}
+
+static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	struct ata_timing t;
+	struct legacy_data *winbond = ap->host->private_data;
+	int active, recovery;
+	u8 reg;
+	int timing = 0x88 + (ap->port_no * 4) + (adev->devno * 2);
+
+	reg = winbond_readcfg(winbond->timing, 0x81);
+
+	/* Get the timing data in cycles */
+	if (reg & 0x40)		/* Fast VLB bus, assume 50MHz */
+		ata_timing_compute(adev, adev->pio_mode, &t, 20000, 1000);
+	else
+		ata_timing_compute(adev, adev->pio_mode, &t, 30303, 1000);
+
+	active = (FIT(t.active, 3, 17) - 1) & 0x0F;
+	recovery = (FIT(t.recover, 1, 15) + 1) & 0x0F;
+	timing = (active << 4) | recovery;
+	winbond_writecfg(winbond->timing, timing, reg);
+
+	/* Load the setup timing */
+
+	reg = 0x35;
+	if (adev->class != ATA_DEV_ATA)
+		reg |= 0x08;	/* FIFO off */
+	if (!ata_pio_need_iordy(adev))
+		reg |= 0x02;	/* IORDY off */
+	reg |= (FIT(t.setup, 0, 3) << 6);
+	winbond_writecfg(winbond->timing, timing + 1, reg);
+}
+
+static int winbond_port(struct platform_device *dev,
+			struct legacy_probe *lp, struct legacy_data *ld)
+{
+	if (devm_request_region(&dev->dev, lp->private, 4, "winbond") == NULL)
+		return -EBUSY;
+	ld->timing = lp->private;
+	return 0;
+}
+
+static struct ata_port_operations winbond_port_ops = {
+	.set_piomode	= winbond_set_piomode,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= ata_qc_issue_prot,
+
+	.data_xfer	= vlb32_data_xfer,
+
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
 
+	.port_start	= ata_sff_port_start,
+};
+
+static struct legacy_controller controllers[] = {
+	{"BIOS",	&legacy_port_ops, 	0x1F,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"Snooping", 	&simple_port_ops, 	0x1F,
+						0	       ,	NULL },
+	{"PDC20230",	&pdc20230_port_ops,	0x7,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"HT6560A",	&ht6560a_port_ops,	0x07,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"HT6560B",	&ht6560b_port_ops,	0x1F,
+						ATA_FLAG_NO_IORDY,	NULL },
+	{"OPTI82C611A",	&opti82c611a_port_ops,	0x0F,
+						0	       ,	NULL },
+	{"OPTI82C46X",	&opti82c46x_port_ops,	0x0F,
+						0	       ,	NULL },
+	{"QDI6500",	&qdi6500_port_ops,	0x07,
+					ATA_FLAG_NO_IORDY,	qdi_port },
+	{"QDI6580",	&qdi6580_port_ops,	0x1F,
+					0	       ,	qdi_port },
+	{"QDI6580DP",	&qdi6580dp_port_ops,	0x1F,
+					0	       ,	qdi_port },
+	{"W83759A",	&winbond_port_ops,	0x1F,
+					0	       ,	winbond_port }
+};
+
+/**
+ *	probe_chip_type		-	Discover controller
+ *	@probe: Probe entry to check
+ *
+ *	Probe an ATA port and identify the type of controller. We don't
+ *	check if the controller appears to be driveless at this point.
+ */
+
+static __init int probe_chip_type(struct legacy_probe *probe)
+{
+	int mask = 1 << probe->slot;
+
+	if (winbond && (probe->port == 0x1F0 || probe->port == 0x170)) {
+		u8 reg = winbond_readcfg(winbond, 0x81);
+		reg |= 0x80;	/* jumpered mode off */
+		winbond_writecfg(winbond, 0x81, reg);
+		reg = winbond_readcfg(winbond, 0x83);
+		reg |= 0xF0;	/* local control */
+		winbond_writecfg(winbond, 0x83, reg);
+		reg = winbond_readcfg(winbond, 0x85);
+		reg |= 0xF0;	/* programmable timing */
+		winbond_writecfg(winbond, 0x85, reg);
+
+		reg = winbond_readcfg(winbond, 0x81);
+
+		if (reg & mask)
+			return W83759A;
+	}
+	if (probe->port == 0x1F0) {
+		unsigned long flags;
+		local_irq_save(flags);
 		/* Probes */
-		inb(0x1F5);
 		outb(inb(0x1F2) | 0x80, 0x1F2);
+		inb(0x1F5);
 		inb(0x1F2);
 		inb(0x3F6);
 		inb(0x3F6);
@@ -760,29 +1168,83 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 
 		if ((inb(0x1F2) & 0x80) == 0) {
 			/* PDC20230c or 20630 ? */
-			printk(KERN_INFO "PDC20230-C/20630 VLB ATA controller detected.\n");
-				pio_modes = 0x07;
-			ops = &pdc20230_port_ops;
-			iordy = ATA_FLAG_NO_IORDY;
+			printk(KERN_INFO  "PDC20230-C/20630 VLB ATA controller"
+							" detected.\n");
 			udelay(100);
 			inb(0x1F5);
+			local_irq_restore(flags);
+			return PDC20230;
 		} else {
 			outb(0x55, 0x1F2);
 			inb(0x1F2);
 			inb(0x1F2);
-			if (inb(0x1F2) == 0x00) {
-				printk(KERN_INFO "PDC20230-B VLB ATA controller detected.\n");
-			}
+			if (inb(0x1F2) == 0x00)
+				printk(KERN_INFO "PDC20230-B VLB ATA "
+						     "controller detected.\n");
+			local_irq_restore(flags);
+			return BIOS;
 		}
 		local_irq_restore(flags);
 	}
 
+	if (ht6560a & mask)
+		return HT6560A;
+	if (ht6560b & mask)
+		return HT6560B;
+	if (opti82c611a & mask)
+		return OPTI611A;
+	if (opti82c46x & mask)
+		return OPTI46X;
+	if (autospeed & mask)
+		return SNOOP;
+	return BIOS;
+}
+
+
+/**
+ *	legacy_init_one		-	attach a legacy interface
+ *	@pl: probe record
+ *
+ *	Register an ISA bus IDE interface. Such interfaces are PIO and we
+ *	assume do not support IRQ sharing.
+ */
+
+static __init int legacy_init_one(struct legacy_probe *probe)
+{
+	struct legacy_controller *controller = &controllers[probe->type];
+	int pio_modes = controller->pio_mask;
+	unsigned long io = probe->port;
+	u32 mask = (1 << probe->slot);
+	struct ata_port_operations *ops = controller->ops;
+	struct legacy_data *ld = &legacy_data[probe->slot];
+	struct ata_host *host = NULL;
+	struct ata_port *ap;
+	struct platform_device *pdev;
+	struct ata_device *dev;
+	void __iomem *io_addr, *ctrl_addr;
+	u32 iordy = (iordy_mask & mask) ? 0: ATA_FLAG_NO_IORDY;
+	int ret;
 
-	/* Chip does mode setting by command snooping */
-	if (ops == &legacy_port_ops && (autospeed & mask))
-		ops = &simple_port_ops;
+	iordy |= controller->flags;
+
+	pdev = platform_device_register_simple(DRV_NAME, probe->slot, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	ret = -EBUSY;
+	if (devm_request_region(&pdev->dev, io, 8, "pata_legacy") == NULL ||
+	    devm_request_region(&pdev->dev, io + 0x0206, 1,
+							"pata_legacy") == NULL)
+		goto fail;
 
 	ret = -ENOMEM;
+	io_addr = devm_ioport_map(&pdev->dev, io, 8);
+	ctrl_addr = devm_ioport_map(&pdev->dev, io + 0x0206, 1);
+	if (!io_addr || !ctrl_addr)
+		goto fail;
+	if (controller->setup)
+		if (controller->setup(pdev, probe, ld) < 0)
+			goto fail;
 	host = ata_host_alloc(&pdev->dev, 1);
 	if (!host)
 		goto fail;
@@ -795,19 +1257,29 @@ static __init int legacy_init_one(int port, unsigned long io, unsigned long ctrl
 	ap->ioaddr.altstatus_addr = ctrl_addr;
 	ap->ioaddr.ctl_addr = ctrl_addr;
 	ata_std_ports(&ap->ioaddr);
-	ap->private_data = ld;
+	ap->host->private_data = ld;
 
-	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io, ctrl);
+	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io, io + 0x0206);
 
-	ret = ata_host_activate(host, irq, ata_interrupt, 0, &legacy_sht);
+	ret = ata_host_activate(host, probe->irq, ata_interrupt, 0,
+								&legacy_sht);
 	if (ret)
 		goto fail;
-
-	legacy_host[nr_legacy_host++] = dev_get_drvdata(&pdev->dev);
 	ld->platform_dev = pdev;
-	return 0;
 
+	/* Nothing found means we drop the port as its probably not there */
+
+	ret = -ENODEV;
+	ata_link_for_each_dev(dev, &ap->link) {
+		if (!ata_dev_absent(dev)) {
+			legacy_host[probe->slot] = host;
+			ld->platform_dev = pdev;
+			return 0;
+		}
+	}
 fail:
+	if (host)
+		ata_host_detach(host);
 	platform_device_unregister(pdev);
 	return ret;
 }
@@ -818,13 +1290,15 @@ fail:
  *	@master: set this if we find an ATA master
  *	@master: set this if we find an ATA secondary
  *
- *	A small number of vendors implemented early PCI ATA interfaces on bridge logic
- *	without the ATA interface being PCI visible. Where we have a matching PCI driver
- *	we must skip the relevant device here. If we don't know about it then the legacy
- *	driver is the right driver anyway.
+ *	A small number of vendors implemented early PCI ATA interfaces
+ *	on bridge logic without the ATA interface being PCI visible.
+ *	Where we have a matching PCI driver we must skip the relevant
+ *	device here. If we don't know about it then the legacy driver
+ *	is the right driver anyway.
  */
 
-static void legacy_check_special_cases(struct pci_dev *p, int *primary, int *secondary)
+static void __init legacy_check_special_cases(struct pci_dev *p, int *primary,
+								int *secondary)
 {
 	/* Cyrix CS5510 pre SFF MWDMA ATA on the bridge */
 	if (p->vendor == 0x1078 && p->device == 0x0000) {
@@ -840,7 +1314,8 @@ static void legacy_check_special_cases(struct pci_dev *p, int *primary, int *sec
 	if (p->vendor == 0x8086 && p->device == 0x1234) {
 		u16 r;
 		pci_read_config_word(p, 0x6C, &r);
-		if (r & 0x8000) {	/* ATA port enabled */
+		if (r & 0x8000) {
+			/* ATA port enabled */
 			if (r & 0x4000)
 				*secondary = 1;
 			else
@@ -850,6 +1325,114 @@ static void legacy_check_special_cases(struct pci_dev *p, int *primary, int *sec
 	}
 }
 
+static __init void probe_opti_vlb(void)
+{
+	/* If an OPTI 82C46X is present find out where the channels are */
+	static const char *optis[4] = {
+		"3/463MV", "5MV",
+		"5MVA", "5MVB"
+	};
+	u8 chans = 1;
+	u8 ctrl = (opti_syscfg(0x30) & 0xC0) >> 6;
+
+	opti82c46x = 3;	/* Assume master and slave first */
+	printk(KERN_INFO DRV_NAME ": Opti 82C46%s chipset support.\n",
+								optis[ctrl]);
+	if (ctrl == 3)
+		chans = (opti_syscfg(0x3F) & 0x20) ? 2 : 1;
+	ctrl = opti_syscfg(0xAC);
+	/* Check enabled and this port is the 465MV port. On the
+	   MVB we may have two channels */
+	if (ctrl & 8) {
+		if (chans == 2) {
+			legacy_probe_add(0x1F0, 14, OPTI46X, 0);
+			legacy_probe_add(0x170, 15, OPTI46X, 0);
+		}
+		if (ctrl & 4)
+			legacy_probe_add(0x170, 15, OPTI46X, 0);
+		else
+			legacy_probe_add(0x1F0, 14, OPTI46X, 0);
+	} else
+		legacy_probe_add(0x1F0, 14, OPTI46X, 0);
+}
+
+static __init void qdi65_identify_port(u8 r, u8 res, unsigned long port)
+{
+	static const unsigned long ide_port[2] = { 0x170, 0x1F0 };
+	/* Check card type */
+	if ((r & 0xF0) == 0xC0) {
+		/* QD6500: single channel */
+		if (r & 8)
+			/* Disabled ? */
+			return;
+		legacy_probe_add(ide_port[r & 0x01], 14 + (r & 0x01),
+								QDI6500, port);
+	}
+	if (((r & 0xF0) == 0xA0) || (r & 0xF0) == 0x50) {
+		/* QD6580: dual channel */
+		if (!request_region(port + 2 , 2, "pata_qdi")) {
+			release_region(port, 2);
+			return;
+		}
+		res = inb(port + 3);
+		/* Single channel mode ? */
+		if (res & 1)
+			legacy_probe_add(ide_port[r & 0x01], 14 + (r & 0x01),
+								QDI6580, port);
+		else { /* Dual channel mode */
+			legacy_probe_add(0x1F0, 14, QDI6580DP, port);
+			/* port + 0x02, r & 0x04 */
+			legacy_probe_add(0x170, 15, QDI6580DP, port + 2);
+		}
+		release_region(port + 2, 2);
+	}
+}
+
+static __init void probe_qdi_vlb(void)
+{
+	unsigned long flags;
+	static const unsigned long qd_port[2] = { 0x30, 0xB0 };
+	int i;
+
+	/*
+	 *	Check each possible QD65xx base address
+	 */
+
+	for (i = 0; i < 2; i++) {
+		unsigned long port = qd_port[i];
+		u8 r, res;
+
+
+		if (request_region(port, 2, "pata_qdi")) {
+			/* Check for a card */
+			local_irq_save(flags);
+			/* I have no h/w that needs this delay but it
+			   is present in the historic code */
+			r = inb(port);
+			udelay(1);
+			outb(0x19, port);
+			udelay(1);
+			res = inb(port);
+			udelay(1);
+			outb(r, port);
+			udelay(1);
+			local_irq_restore(flags);
+
+			/* Fail */
+			if (res == 0x19) {
+				release_region(port, 2);
+				continue;
+			}
+			/* Passes the presence test */
+			r = inb(port + 1);
+			udelay(1);
+			/* Check port agrees with port set */
+			if ((r & 2) >> 1 == i)
+				qdi65_identify_port(r, res, port);
+			release_region(port, 2);
+		}
+	}
+}
 
 /**
  *	legacy_init		-	attach legacy interfaces
@@ -867,15 +1450,17 @@ static __init int legacy_init(void)
 	int ct = 0;
 	int primary = 0;
 	int secondary = 0;
-	int last_port = NR_HOST;
+	int pci_present = 0;
+	struct legacy_probe *pl = &probe_list[0];
+	int slot = 0;
 
 	struct pci_dev *p = NULL;
 
 	for_each_pci_dev(p) {
 		int r;
-		/* Check for any overlap of the system ATA mappings. Native mode controllers
-		   stuck on these addresses or some devices in 'raid' mode won't be found by
-		   the storage class test */
+		/* Check for any overlap of the system ATA mappings. Native
+		   mode controllers stuck on these addresses or some devices
+		   in 'raid' mode won't be found by the storage class test */
 		for (r = 0; r < 6; r++) {
 			if (pci_resource_start(p, r) == 0x1f0)
 				primary = 1;
@@ -885,49 +1470,39 @@ static __init int legacy_init(void)
 		/* Check for special cases */
 		legacy_check_special_cases(p, &primary, &secondary);
 
-		/* If PCI bus is present then don't probe for tertiary legacy ports */
-		if (probe_all == 0)
-			last_port = 2;
+		/* If PCI bus is present then don't probe for tertiary
+		   legacy ports */
+		pci_present = 1;
 	}
 
-	/* If an OPTI 82C46X is present find out where the channels are */
-	if (opti82c46x) {
-		static const char *optis[4] = {
-			"3/463MV", "5MV",
-			"5MVA", "5MVB"
-		};
-		u8 chans = 1;
-		u8 ctrl = (opti_syscfg(0x30) & 0xC0) >> 6;
-
-		opti82c46x = 3;	/* Assume master and slave first */
-		printk(KERN_INFO DRV_NAME ": Opti 82C46%s chipset support.\n", optis[ctrl]);
-		if (ctrl == 3)
-			chans = (opti_syscfg(0x3F) & 0x20) ? 2 : 1;
-		ctrl = opti_syscfg(0xAC);
-		/* Check enabled and this port is the 465MV port. On the
-		   MVB we may have two channels */
-		if (ctrl & 8) {
-			if (ctrl & 4)
-				opti82c46x = 2;	/* Slave */
-			else
-				opti82c46x = 1;	/* Master */
-			if (chans == 2)
-				opti82c46x = 3; /* Master and Slave */
-		}	/* Slave only */
-		else if (chans == 1)
-			opti82c46x = 1;
+	if (winbond == 1)
+		winbond = 0x130;	/* Default port, alt is 1B0 */
+
+	if (primary == 0 || all)
+		legacy_probe_add(0x1F0, 14, UNKNOWN, 0);
+	if (secondary == 0 || all)
+		legacy_probe_add(0x170, 15, UNKNOWN, 0);
+
+	if (probe_all || !pci_present) {
+		/* ISA/VLB extra ports */
+		legacy_probe_add(0x1E8, 11, UNKNOWN, 0);
+		legacy_probe_add(0x168, 10, UNKNOWN, 0);
+		legacy_probe_add(0x1E0, 8, UNKNOWN, 0);
+		legacy_probe_add(0x160, 12, UNKNOWN, 0);
 	}
 
-	for (i = 0; i < last_port; i++) {
-		/* Skip primary if we have seen a PCI one */
-		if (i == 0 && primary == 1)
-			continue;
-		/* Skip secondary if we have seen a PCI one */
-		if (i == 1 && secondary == 1)
+	if (opti82c46x)
+		probe_opti_vlb();
+	if (qdi)
+		probe_qdi_vlb();
+
+	for (i = 0; i < NR_HOST; i++, pl++) {
+		if (pl->port == 0)
 			continue;
-		if (legacy_init_one(i, legacy_port[i],
-				   legacy_port[i] + 0x0206,
-				   legacy_irq[i]) == 0)
+		if (pl->type == UNKNOWN)
+			pl->type = probe_chip_type(pl);
+		pl->slot = slot++;
+		if (legacy_init_one(pl) == 0)
 			ct++;
 	}
 	if (ct != 0)
@@ -941,11 +1516,8 @@ static __exit void legacy_exit(void)
 
 	for (i = 0; i < nr_legacy_host; i++) {
 		struct legacy_data *ld = &legacy_data[i];
-
 		ata_host_detach(legacy_host[i]);
 		platform_device_unregister(ld->platform_dev);
-		if (ld->timing)
-			release_region(ld->timing, 2);
 	}
 }
 
@@ -960,9 +1532,9 @@ module_param(ht6560a, int, 0);
 module_param(ht6560b, int, 0);
 module_param(opti82c611a, int, 0);
 module_param(opti82c46x, int, 0);
+module_param(qdi, int, 0);
 module_param(pio_mask, int, 0);
 module_param(iordy_mask, int, 0);
 
 module_init(legacy_init);
 module_exit(legacy_exit);
-
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 50c56e2..dc40162 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -364,7 +364,7 @@ mpc52xx_ata_probe(struct of_device *op, const struct of_device_id *match)
 {
 	unsigned int ipb_freq;
 	struct resource res_mem;
-	int ata_irq = NO_IRQ;
+	int ata_irq;
 	struct mpc52xx_ata __iomem *ata_regs;
 	struct mpc52xx_ata_priv *priv;
 	int rv;
diff --git a/drivers/ata/pata_ninja32.c b/drivers/ata/pata_ninja32.c
new file mode 100644
index 0000000..1c1b835
--- /dev/null
+++ b/drivers/ata/pata_ninja32.c
@@ -0,0 +1,214 @@
+/*
+ * pata_ninja32.c 	- Ninja32 PATA for new ATA layer
+ *			  (C) 2007 Red Hat Inc
+ *			  Alan Cox <alan@redhat.com>
+ *
+ * Note: The controller like many controllers has shared timings for
+ * PIO and DMA. We thus flip to the DMA timings in dma_start and flip back
+ * in the dma_stop function. Thus we actually don't need a set_dmamode
+ * method as the PIO method is always called and will set the right PIO
+ * timing parameters.
+ *
+ * The Ninja32 Cardbus is not a generic SFF controller. Instead it is
+ * laid out as follows off BAR 0. This is based upon Mark Lord's delkin
+ * driver and the extensive analysis done by the BSD developers, notably
+ * ITOH Yasufumi.
+ *
+ *	Base + 0x00 IRQ Status
+ *	Base + 0x01 IRQ control
+ *	Base + 0x02 Chipset control
+ *	Base + 0x04 VDMA and reset control + wait bits
+ *	Base + 0x08 BMIMBA
+ *	Base + 0x0C DMA Length
+ *	Base + 0x10 Taskfile
+ *	Base + 0x18 BMDMA Status ?
+ *	Base + 0x1C
+ *	Base + 0x1D Bus master control
+ *		bit 0 = enable
+ *		bit 1 = 0 write/1 read
+ *		bit 2 = 1 sgtable
+ *		bit 3 = go
+ *		bit 4-6 wait bits
+ *		bit 7 = done
+ *	Base + 0x1E AltStatus
+ *	Base + 0x1F timing register
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <scsi/scsi_host.h>
+#include <linux/libata.h>
+
+#define DRV_NAME "pata_ninja32"
+#define DRV_VERSION "0.0.1"
+
+
+/**
+ *	ninja32_set_piomode	-	set initial PIO mode data
+ *	@ap: ATA interface
+ *	@adev: ATA device
+ *
+ *	Called to do the PIO mode setup. Our timing registers are shared
+ *	but we want to set the PIO timing by default.
+ */
+
+static void ninja32_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	static u16 pio_timing[5] = {
+		0xd6, 0x85, 0x44, 0x33, 0x13
+	};
+	iowrite8(pio_timing[adev->pio_mode - XFER_PIO_0],
+		 ap->ioaddr.bmdma_addr + 0x1f);
+	ap->private_data = adev;
+}
+
+
+static void ninja32_dev_select(struct ata_port *ap, unsigned int device)
+{
+	struct ata_device *adev = &ap->link.device[device];
+	if (ap->private_data != adev) {
+		iowrite8(0xd6, ap->ioaddr.bmdma_addr + 0x1f);
+		ata_std_dev_select(ap, device);
+		ninja32_set_piomode(ap, adev);
+	}
+}
+
+static struct scsi_host_template ninja32_sht = {
+	.module			= THIS_MODULE,
+	.name			= DRV_NAME,
+	.ioctl			= ata_scsi_ioctl,
+	.queuecommand		= ata_scsi_queuecmd,
+	.can_queue		= ATA_DEF_QUEUE,
+	.this_id		= ATA_SHT_THIS_ID,
+	.sg_tablesize		= LIBATA_MAX_PRD,
+	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
+	.emulated		= ATA_SHT_EMULATED,
+	.use_clustering		= ATA_SHT_USE_CLUSTERING,
+	.proc_name		= DRV_NAME,
+	.dma_boundary		= ATA_DMA_BOUNDARY,
+	.slave_configure	= ata_scsi_slave_config,
+	.slave_destroy		= ata_scsi_slave_destroy,
+	.bios_param		= ata_std_bios_param,
+};
+
+static struct ata_port_operations ninja32_port_ops = {
+	.set_piomode	= ninja32_set_piomode,
+	.mode_filter	= ata_pci_default_filter,
+
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ninja32_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.bmdma_setup 	= ata_bmdma_setup,
+	.bmdma_start 	= ata_bmdma_start,
+	.bmdma_stop	= ata_bmdma_stop,
+	.bmdma_status 	= ata_bmdma_status,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= ata_qc_issue_prot,
+
+	.data_xfer	= ata_data_xfer,
+
+	.irq_handler	= ata_interrupt,
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
+static int ninja32_init_one(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	struct ata_host *host;
+	struct ata_port *ap;
+	void __iomem *base;
+	int rc;
+
+	host = ata_host_alloc(&dev->dev, 1);
+	if (!host)
+		return -ENOMEM;
+	ap = host->ports[0];
+
+	/* Set up the PCI device */
+	rc = pcim_enable_device(dev);
+	if (rc)
+		return rc;
+	rc = pcim_iomap_regions(dev, 1 << 0, DRV_NAME);
+	if (rc == -EBUSY)
+		pcim_pin_device(dev);
+	if (rc)
+		return rc;
+
+	host->iomap = pcim_iomap_table(dev);
+	rc = pci_set_dma_mask(dev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	rc = pci_set_consistent_dma_mask(dev, ATA_DMA_MASK);
+	if (rc)
+		return rc;
+	pci_set_master(dev);
+
+	/* Set up the register mappings */
+	base = host->iomap[0];
+	if (!base)
+		return -ENOMEM;
+	ap->ops = &ninja32_port_ops;
+	ap->pio_mask = 0x1F;
+	ap->flags |= ATA_FLAG_SLAVE_POSS;
+
+	ap->ioaddr.cmd_addr = base + 0x10;
+	ap->ioaddr.ctl_addr = base + 0x1E;
+	ap->ioaddr.altstatus_addr = base + 0x1E;
+	ap->ioaddr.bmdma_addr = base;
+	ata_std_ports(&ap->ioaddr);
+
+	iowrite8(0x05, base + 0x01);	/* Enable interrupt lines */
+	iowrite8(0xB3, base + 0x02);	/* Burst, ?? setup */
+	iowrite8(0x00, base + 0x04);	/* WAIT0 ? */
+	/* FIXME: Should we disable them at remove ? */
+	return ata_host_activate(host, dev->irq, ata_interrupt,
+				 IRQF_SHARED, &ninja32_sht);
+}
+
+static const struct pci_device_id ninja32[] = {
+	{ 0x1145, 0xf021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ 0x1145, 0xf024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ },
+};
+
+static struct pci_driver ninja32_pci_driver = {
+	.name 		= DRV_NAME,
+	.id_table	= ninja32,
+	.probe 		= ninja32_init_one,
+	.remove		= ata_pci_remove_one
+};
+
+static int __init ninja32_init(void)
+{
+	return pci_register_driver(&ninja32_pci_driver);
+}
+
+static void __exit ninja32_exit(void)
+{
+	pci_unregister_driver(&ninja32_pci_driver);
+}
+
+MODULE_AUTHOR("Alan Cox");
+MODULE_DESCRIPTION("low-level driver for Ninja32 ATA");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(pci, ninja32);
+MODULE_VERSION(DRV_VERSION);
+
+module_init(ninja32_init);
+module_exit(ninja32_exit);
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index fd36099..3e7f6a9 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -42,7 +42,7 @@
 
 
 #define DRV_NAME "pata_pcmcia"
-#define DRV_VERSION "0.3.2"
+#define DRV_VERSION "0.3.3"
 
 /*
  *	Private data structure to glue stuff together
@@ -86,6 +86,47 @@ static int pcmcia_set_mode(struct ata_link *link, struct ata_device **r_failed_d
 	return ata_do_set_mode(link, r_failed_dev);
 }
 
+/**
+ *	pcmcia_set_mode_8bit	-	PCMCIA specific mode setup
+ *	@link: link
+ *	@r_failed_dev: Return pointer for failed device
+ *
+ *	For the simple emulated 8bit stuff the less we do the better.
+ */
+
+static int pcmcia_set_mode_8bit(struct ata_link *link,
+				struct ata_device **r_failed_dev)
+{
+	return 0;
+}
+
+/**
+ *	ata_data_xfer_8bit	 -	Transfer data by 8bit PIO
+ *	@dev: device to target
+ *	@buf: data buffer
+ *	@buflen: buffer length
+ *	@rw: read/write
+ *
+ *	Transfer data from/to the device data register by 8 bit PIO.
+ *
+ *	LOCKING:
+ *	Inherited from caller.
+ */
+
+static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
+				unsigned char *buf, unsigned int buflen, int rw)
+{
+	struct ata_port *ap = dev->link->ap;
+
+	if (rw == READ)
+		ioread8_rep(ap->ioaddr.data_addr, buf, buflen);
+	else
+		iowrite8_rep(ap->ioaddr.data_addr, buf, buflen);
+
+	return buflen;
+}
+
+
 static struct scsi_host_template pcmcia_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -129,6 +170,31 @@ static struct ata_port_operations pcmcia_port_ops = {
 	.port_start	= ata_sff_port_start,
 };
 
+static struct ata_port_operations pcmcia_8bit_port_ops = {
+	.set_mode	= pcmcia_set_mode_8bit,
+	.tf_load	= ata_tf_load,
+	.tf_read	= ata_tf_read,
+	.check_status 	= ata_check_status,
+	.exec_command	= ata_exec_command,
+	.dev_select 	= ata_std_dev_select,
+
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
+	.error_handler	= ata_bmdma_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
+
+	.qc_prep 	= ata_qc_prep,
+	.qc_issue	= ata_qc_issue_prot,
+
+	.data_xfer	= ata_data_xfer_8bit,
+
+	.irq_clear	= ata_bmdma_irq_clear,
+	.irq_on		= ata_irq_on,
+
+	.port_start	= ata_sff_port_start,
+};
+
 #define CS_CHECK(fn, ret) \
 do { last_fn = (fn); if ((last_ret = (ret)) != 0) goto cs_failed; } while (0)
 
@@ -153,9 +219,12 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 		cistpl_cftable_entry_t dflt;
 	} *stk = NULL;
 	cistpl_cftable_entry_t *cfg;
-	int pass, last_ret = 0, last_fn = 0, is_kme = 0, ret = -ENOMEM;
+	int pass, last_ret = 0, last_fn = 0, is_kme = 0, ret = -ENOMEM, p;
 	unsigned long io_base, ctl_base;
 	void __iomem *io_addr, *ctl_addr;
+	int n_ports = 1;
+
+	struct ata_port_operations *ops = &pcmcia_port_ops;
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (info == NULL)
@@ -282,27 +351,32 @@ next_entry:
 	/* FIXME: Could be more ports at base + 0x10 but we only deal with
 	   one right now */
 	if (pdev->io.NumPorts1 >= 0x20)
-		printk(KERN_WARNING DRV_NAME ": second channel not yet supported.\n");
+		n_ports = 2;
 
+	if (pdev->manf_id == 0x0097 && pdev->card_id == 0x1620)
+		ops = &pcmcia_8bit_port_ops;
 	/*
 	 *	Having done the PCMCIA plumbing the ATA side is relatively
 	 *	sane.
 	 */
 	ret = -ENOMEM;
-	host = ata_host_alloc(&pdev->dev, 1);
+	host = ata_host_alloc(&pdev->dev, n_ports);
 	if (!host)
 		goto failed;
-	ap = host->ports[0];
 
-	ap->ops = &pcmcia_port_ops;
-	ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
-	ap->flags |= ATA_FLAG_SLAVE_POSS;
-	ap->ioaddr.cmd_addr = io_addr;
-	ap->ioaddr.altstatus_addr = ctl_addr;
-	ap->ioaddr.ctl_addr = ctl_addr;
-	ata_std_ports(&ap->ioaddr);
+	for (p = 0; p < n_ports; p++) {
+		ap = host->ports[p];
 
-	ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io_base, ctl_base);
+		ap->ops = ops;
+		ap->pio_mask = 1;		/* ISA so PIO 0 cycles */
+		ap->flags |= ATA_FLAG_SLAVE_POSS;
+		ap->ioaddr.cmd_addr = io_addr + 0x10 * p;
+		ap->ioaddr.altstatus_addr = ctl_addr + 0x10 * p;
+		ap->ioaddr.ctl_addr = ctl_addr + 0x10 * p;
+		ata_std_ports(&ap->ioaddr);
+
+		ata_port_desc(ap, "cmd 0x%lx ctl 0x%lx", io_base, ctl_base);
+	}
 
 	/* activate */
 	ret = ata_host_activate(host, pdev->irq.AssignedIRQ, ata_interrupt,
@@ -360,6 +434,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x0704),
 	PCMCIA_DEVICE_MANF_CARD(0x0032, 0x2904),
 	PCMCIA_DEVICE_MANF_CARD(0x0045, 0x0401),	/* SanDisk CFA */
+	PCMCIA_DEVICE_MANF_CARD(0x0097, 0x1620), 	/* TI emulated */
 	PCMCIA_DEVICE_MANF_CARD(0x0098, 0x0000),	/* Toshiba */
 	PCMCIA_DEVICE_MANF_CARD(0x00a4, 0x002d),
 	PCMCIA_DEVICE_MANF_CARD(0x00ce, 0x0000),	/* Samsung */
diff --git a/drivers/ata/pata_pdc2027x.c b/drivers/ata/pata_pdc2027x.c
index 2622577..028af5d 100644
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -348,7 +348,7 @@ static unsigned long pdc2027x_mode_filter(struct ata_device *adev, unsigned long
 	ata_id_c_string(pair->id, model_num, ATA_ID_PROD,
 			  ATA_ID_PROD_LEN + 1);
 	/* If the master is a maxtor in UDMA6 then the slave should not use UDMA 6 */
-	if (strstr(model_num, "Maxtor") == 0 && pair->dma_mode == XFER_UDMA_6)
+	if (strstr(model_num, "Maxtor") == NULL && pair->dma_mode == XFER_UDMA_6)
 		mask &= ~ (1 << (6 + ATA_SHIFT_UDMA));
 
 	return ata_pci_default_filter(adev, mask);
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 6c9689b..3ed8667 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -168,8 +168,7 @@ static void pdc2026x_bmdma_start(struct ata_queued_cmd *qc)
 	pdc202xx_set_dmamode(ap, qc->dev);
 
 	/* Cases the state machine will not complete correctly without help */
-	if ((tf->flags & ATA_TFLAG_LBA48) ||  tf->protocol == ATA_PROT_ATAPI_DMA)
-	{
+	if ((tf->flags & ATA_TFLAG_LBA48) ||  tf->protocol == ATAPI_PROT_DMA) {
 		len = qc->nbytes / 2;
 
 		if (tf->flags & ATA_TFLAG_WRITE)
@@ -208,7 +207,7 @@ static void pdc2026x_bmdma_stop(struct ata_queued_cmd *qc)
 	void __iomem *atapi_reg = master + 0x20 + (4 * ap->port_no);
 
 	/* Cases the state machine will not complete correctly */
-	if (tf->protocol == ATA_PROT_ATAPI_DMA || ( tf->flags & ATA_TFLAG_LBA48)) {
+	if (tf->protocol == ATAPI_PROT_DMA || (tf->flags & ATA_TFLAG_LBA48)) {
 		iowrite32(0, atapi_reg);
 		iowrite8(ioread8(clock) & ~sel66, clock);
 	}
diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
index a4c0e50..9f308ed 100644
--- a/drivers/ata/pata_qdi.c
+++ b/drivers/ata/pata_qdi.c
@@ -124,29 +124,33 @@ static unsigned int qdi_qc_issue_prot(struct ata_queued_cmd *qc)
 	return ata_qc_issue_prot(qc);
 }
 
-static void qdi_data_xfer(struct ata_device *adev, unsigned char *buf, unsigned int buflen, int write_data)
+static unsigned int qdi_data_xfer(struct ata_device *dev, unsigned char *buf,
+				  unsigned int buflen, int rw)
 {
-	struct ata_port *ap = adev->link->ap;
-	int slop = buflen & 3;
+	if (ata_id_has_dword_io(dev->id)) {
+		struct ata_port *ap = dev->link->ap;
+		int slop = buflen & 3;
 
-	if (ata_id_has_dword_io(adev->id)) {
-		if (write_data)
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
+		if (rw == READ)
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
+		else
+			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad = 0;
-			if (write_data) {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			} else {
+			u32 pad;
+			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
+			} else {
+				memcpy(&pad, buf + buflen - slop, slop);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			}
+			buflen += 4 - slop;
 		}
 	} else
-		ata_data_xfer(adev, buf, buflen, write_data);
+		buflen = ata_data_xfer(dev, buf, buflen, rw);
+
+	return buflen;
 }
 
 static struct scsi_host_template qdi_sht = {
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index ea2ef9f..55055b2 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -768,45 +768,47 @@ static u8 scc_bmdma_status (struct ata_port *ap)
 
 /**
  *	scc_data_xfer - Transfer data by PIO
- *	@adev: device for this I/O
+ *	@dev: device for this I/O
  *	@buf: data buffer
  *	@buflen: buffer length
- *	@write_data: read/write
+ *	@rw: read/write
  *
  *	Note: Original code is ata_data_xfer().
  */
 
-static void scc_data_xfer (struct ata_device *adev, unsigned char *buf,
-			   unsigned int buflen, int write_data)
+static unsigned int scc_data_xfer (struct ata_device *dev, unsigned char *buf,
+				   unsigned int buflen, int rw)
 {
-	struct ata_port *ap = adev->link->ap;
+	struct ata_port *ap = dev->link->ap;
 	unsigned int words = buflen >> 1;
 	unsigned int i;
 	u16 *buf16 = (u16 *) buf;
 	void __iomem *mmio = ap->ioaddr.data_addr;
 
 	/* Transfer multiple of 2 bytes */
-	if (write_data) {
-		for (i = 0; i < words; i++)
-			out_be32(mmio, cpu_to_le16(buf16[i]));
-	} else {
+	if (rw == READ)
 		for (i = 0; i < words; i++)
 			buf16[i] = le16_to_cpu(in_be32(mmio));
-	}
+	else
+		for (i = 0; i < words; i++)
+			out_be32(mmio, cpu_to_le16(buf16[i]));
 
 	/* Transfer trailing 1 byte, if any. */
 	if (unlikely(buflen & 0x01)) {
 		u16 align_buf[1] = { 0 };
 		unsigned char *trailing_buf = buf + buflen - 1;
 
-		if (write_data) {
-			memcpy(align_buf, trailing_buf, 1);
-			out_be32(mmio, cpu_to_le16(align_buf[0]));
-		} else {
+		if (rw == READ) {
 			align_buf[0] = le16_to_cpu(in_be32(mmio));
 			memcpy(trailing_buf, align_buf, 1);
+		} else {
+			memcpy(align_buf, trailing_buf, 1);
+			out_be32(mmio, cpu_to_le16(align_buf[0]));
 		}
+		words++;
 	}
+
+	return words << 1;
 }
 
 /**
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index 8bed888..9c523fb 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -41,7 +41,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_serverworks"
-#define DRV_VERSION "0.4.2"
+#define DRV_VERSION "0.4.3"
 
 #define SVWKS_CSB5_REVISION_NEW	0x92 /* min PCI_REVISION_ID for UDMA5 (A2.0) */
 #define SVWKS_CSB6_REVISION	0xa0 /* min PCI_REVISION_ID for UDMA4 (A1.0) */
@@ -102,7 +102,7 @@ static int osb4_cable(struct ata_port *ap) {
 }
 
 /**
- *	csb4_cable	-	CSB5/6 cable detect
+ *	csb_cable	-	CSB5/6 cable detect
  *	@ap: ATA port to check
  *
  *	Serverworks default arrangement is to use the drive side detection
@@ -110,7 +110,7 @@ static int osb4_cable(struct ata_port *ap) {
  */
 
 static int csb_cable(struct ata_port *ap) {
-	return ATA_CBL_PATA80;
+	return ATA_CBL_PATA_UNK;
 }
 
 struct sv_cable_table {
@@ -231,7 +231,6 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 	return ata_pci_default_filter(adev, mask);
 }
 
-
 /**
  *	serverworks_set_piomode	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -243,7 +242,7 @@ static unsigned long serverworks_csb_filter(struct ata_device *adev, unsigned lo
 static void serverworks_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u8 pio_mode[] = { 0x5d, 0x47, 0x34, 0x22, 0x20 };
-	int offset = 1 + (2 * ap->port_no) - adev->devno;
+	int offset = 1 + 2 * ap->port_no - adev->devno;
 	int devbits = (2 * ap->port_no + adev->devno) * 4;
 	u16 csb5_pio;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 453d72b..39627ab 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -185,7 +185,8 @@ static int via_cable_detect(struct ata_port *ap) {
 	if (ata66 & (0x10100000 >> (16 * ap->port_no)))
 		return ATA_CBL_PATA80;
 	/* Check with ACPI so we can spot BIOS reported SATA bridges */
-	if (ata_acpi_cbl_80wire(ap))
+	if (ata_acpi_init_gtm(ap) &&
+	    ata_acpi_cbl_80wire(ap, ata_acpi_init_gtm(ap)))
 		return ATA_CBL_PATA80;
 	return ATA_CBL_PATA40;
 }
diff --git a/drivers/ata/pata_winbond.c b/drivers/ata/pata_winbond.c
index 7116a9e..99c92ed 100644
--- a/drivers/ata/pata_winbond.c
+++ b/drivers/ata/pata_winbond.c
@@ -92,29 +92,33 @@ static void winbond_set_piomode(struct ata_port *ap, struct ata_device *adev)
 }
 
 
-static void winbond_data_xfer(struct ata_device *adev, unsigned char *buf, unsigned int buflen, int write_data)
+static unsigned int winbond_data_xfer(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw)
 {
-	struct ata_port *ap = adev->link->ap;
+	struct ata_port *ap = dev->link->ap;
 	int slop = buflen & 3;
 
-	if (ata_id_has_dword_io(adev->id)) {
-		if (write_data)
-			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
-		else
+	if (ata_id_has_dword_io(dev->id)) {
+		if (rw == READ)
 			ioread32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
+		else
+			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 
 		if (unlikely(slop)) {
-			__le32 pad = 0;
-			if (write_data) {
-				memcpy(&pad, buf + buflen - slop, slop);
-				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
-			} else {
+			u32 pad;
+			if (rw == READ) {
 				pad = cpu_to_le32(ioread32(ap->ioaddr.data_addr));
 				memcpy(buf + buflen - slop, &pad, slop);
+			} else {
+				memcpy(&pad, buf + buflen - slop, slop);
+				iowrite32(le32_to_cpu(pad), ap->ioaddr.data_addr);
 			}
+			buflen += 4 - slop;
 		}
 	} else
-		ata_data_xfer(adev, buf, buflen, write_data);
+		buflen = ata_data_xfer(dev, buf, buflen, rw);
+
+	return buflen;
 }
 
 static struct scsi_host_template winbond_sht = {
@@ -191,7 +195,7 @@ static __init int winbond_init_one(unsigned long port)
 	reg = winbond_readcfg(port, 0x81);
 
 	if (!(reg & 0x03))		/* Disabled */
-		return 0;
+		return -ENODEV;
 
 	for (i = 0; i < 2 ; i ++) {
 		unsigned long cmd_port = 0x1F0 - (0x80 * i);
diff --git a/drivers/ata/pdc_adma.c b/drivers/ata/pdc_adma.c
index bd4c2a3..8e1b7e9 100644
--- a/drivers/ata/pdc_adma.c
+++ b/drivers/ata/pdc_adma.c
@@ -321,8 +321,9 @@ static int adma_fill_sg(struct ata_queued_cmd *qc)
 	u8  *buf = pp->pkt, *last_buf = NULL;
 	int i = (2 + buf[3]) * 8;
 	u8 pFLAGS = pORD | ((qc->tf.flags & ATA_TFLAG_WRITE) ? pDIRO : 0);
+	unsigned int si;
 
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr;
 		u32 len;
 
@@ -455,7 +456,7 @@ static unsigned int adma_qc_issue(struct ata_queued_cmd *qc)
 		adma_packet_start(qc);
 		return 0;
 
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		BUG();
 		break;
 
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index d015b4a..922d7b2 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -333,13 +333,14 @@ static unsigned int sata_fsl_fill_sg(struct ata_queued_cmd *qc, void *cmd_desc,
 	struct prde *prd_ptr_to_indirect_ext = NULL;
 	unsigned indirect_ext_segment_sz = 0;
 	dma_addr_t indirect_ext_segment_paddr;
+	unsigned int si;
 
 	VPRINTK("SATA FSL : cd = 0x%x, prd = 0x%x\n", cmd_desc, prd);
 
 	indirect_ext_segment_paddr = cmd_desc_paddr +
 	    SATA_FSL_CMD_DESC_OFFSET_TO_PRDT + SATA_FSL_MAX_PRD_DIRECT * 16;
 
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		dma_addr_t sg_addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
 
@@ -417,7 +418,7 @@ static void sata_fsl_qc_prep(struct ata_queued_cmd *qc)
 	}
 
 	/* setup "ACMD - atapi command" in cmd. desc. if this is ATAPI cmd */
-	if (is_atapi_taskfile(&qc->tf)) {
+	if (ata_is_atapi(qc->tf.protocol)) {
 		desc_info |= ATAPI_CMD;
 		memset((void *)&cd->acmd, 0, 32);
 		memcpy((void *)&cd->acmd, qc->cdb, qc->dev->cdb_len);
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index 323c087..96e614a 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -585,7 +585,7 @@ static struct ata_port_operations inic_port_ops = {
 };
 
 static struct ata_port_info inic_port_info = {
-	/* For some reason, ATA_PROT_ATAPI is broken on this
+	/* For some reason, ATAPI_PROT_PIO is broken on this
 	 * controller, and no, PIO_POLLING does't fix it.  It somehow
 	 * manages to report the wrong ireason and ignoring ireason
 	 * results in machine lock up.  Tell libata to always prefer
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 37b850a..7e72463 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -1136,9 +1136,10 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
 	struct mv_port_priv *pp = qc->ap->private_data;
 	struct scatterlist *sg;
 	struct mv_sg *mv_sg, *last_sg = NULL;
+	unsigned int si;
 
 	mv_sg = pp->sg_tbl;
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		dma_addr_t addr = sg_dma_address(sg);
 		u32 sg_len = sg_dma_len(sg);
 
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ed5dc7c..a0f98fd 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -1336,21 +1336,18 @@ static void nv_adma_fill_aprd(struct ata_queued_cmd *qc,
 static void nv_adma_fill_sg(struct ata_queued_cmd *qc, struct nv_adma_cpb *cpb)
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
-	unsigned int idx;
 	struct nv_adma_prd *aprd;
 	struct scatterlist *sg;
+	unsigned int si;
 
 	VPRINTK("ENTER\n");
 
-	idx = 0;
-
-	ata_for_each_sg(sg, qc) {
-		aprd = (idx < 5) ? &cpb->aprd[idx] :
-			       &pp->aprd[NV_ADMA_SGTBL_LEN * qc->tag + (idx-5)];
-		nv_adma_fill_aprd(qc, sg, idx, aprd);
-		idx++;
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
+		aprd = (si < 5) ? &cpb->aprd[si] :
+			       &pp->aprd[NV_ADMA_SGTBL_LEN * qc->tag + (si-5)];
+		nv_adma_fill_aprd(qc, sg, si, aprd);
 	}
-	if (idx > 5)
+	if (si > 5)
 		cpb->next_aprd = cpu_to_le64(((u64)(pp->aprd_dma + NV_ADMA_SGTBL_SZ * qc->tag)));
 	else
 		cpb->next_aprd = cpu_to_le64(0);
@@ -1995,17 +1992,14 @@ static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
-	unsigned int idx;
 	struct nv_swncq_port_priv *pp = ap->private_data;
 	struct ata_prd *prd;
-
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
+	unsigned int si, idx;
 
 	prd = pp->prd + ATA_MAX_PRD * qc->tag;
 
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
@@ -2027,8 +2021,7 @@ static void nv_swncq_fill_sg(struct ata_queued_cmd *qc)
 		}
 	}
 
-	if (idx)
-		prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+	prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 static unsigned int nv_swncq_issue_atacmd(struct ata_port *ap,
diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index 7914def..a07d319 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -450,19 +450,19 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 	struct pdc_port_priv *pp = ap->private_data;
 	u8 *buf = pp->pkt;
 	u32 *buf32 = (u32 *) buf;
-	unsigned int dev_sel, feature, nbytes;
+	unsigned int dev_sel, feature;
 
 	/* set control bits (byte 0), zero delay seq id (byte 3),
 	 * and seq id (byte 2)
 	 */
 	switch (qc->tf.protocol) {
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		if (!(qc->tf.flags & ATA_TFLAG_WRITE))
 			buf32[0] = cpu_to_le32(PDC_PKT_READ);
 		else
 			buf32[0] = 0;
 		break;
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_NODATA:
 		buf32[0] = cpu_to_le32(PDC_PKT_NODATA);
 		break;
 	default:
@@ -473,45 +473,37 @@ static void pdc_atapi_pkt(struct ata_queued_cmd *qc)
 	buf32[2] = 0;				/* no next-packet */
 
 	/* select drive */
-	if (sata_scr_valid(&ap->link)) {
+	if (sata_scr_valid(&ap->link))
 		dev_sel = PDC_DEVICE_SATA;
-	} else {
-		dev_sel = ATA_DEVICE_OBS;
-		if (qc->dev->devno != 0)
-			dev_sel |= ATA_DEV1;
-	}
+	else
+		dev_sel = qc->tf.device;
+
 	buf[12] = (1 << 5) | ATA_REG_DEVICE;
 	buf[13] = dev_sel;
 	buf[14] = (1 << 5) | ATA_REG_DEVICE | PDC_PKT_CLEAR_BSY;
 	buf[15] = dev_sel; /* once more, waiting for BSY to clear */
 
 	buf[16] = (1 << 5) | ATA_REG_NSECT;
-	buf[17] = 0x00;
+	buf[17] = qc->tf.nsect;
 	buf[18] = (1 << 5) | ATA_REG_LBAL;
-	buf[19] = 0x00;
+	buf[19] = qc->tf.lbal;
 
 	/* set feature and byte counter registers */
-	if (qc->tf.protocol != ATA_PROT_ATAPI_DMA) {
+	if (qc->tf.protocol != ATAPI_PROT_DMA)
 		feature = PDC_FEATURE_ATAPI_PIO;
-		/* set byte counter register to real transfer byte count */
-		nbytes = qc->nbytes;
-		if (nbytes > 0xffff)
-			nbytes = 0xffff;
-	} else {
+	else
 		feature = PDC_FEATURE_ATAPI_DMA;
-		/* set byte counter register to 0 */
-		nbytes = 0;
-	}
+
 	buf[20] = (1 << 5) | ATA_REG_FEATURE;
 	buf[21] = feature;
 	buf[22] = (1 << 5) | ATA_REG_BYTEL;
-	buf[23] = nbytes & 0xFF;
+	buf[23] = qc->tf.lbam;
 	buf[24] = (1 << 5) | ATA_REG_BYTEH;
-	buf[25] = (nbytes >> 8) & 0xFF;
+	buf[25] = qc->tf.lbah;
 
 	/* send ATAPI packet command 0xA0 */
 	buf[26] = (1 << 5) | ATA_REG_CMD;
-	buf[27] = ATA_CMD_PACKET;
+	buf[27] = qc->tf.command;
 
 	/* select drive and check DRQ */
 	buf[28] = (1 << 5) | ATA_REG_DEVICE | PDC_PKT_WAIT_DRDY;
@@ -541,17 +533,15 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct scatterlist *sg;
-	unsigned int idx;
 	const u32 SG_COUNT_ASIC_BUG = 41*4;
+	unsigned int si, idx;
+	u32 len;
 
 	if (!(qc->flags & ATA_QCFLAG_DMAMAP))
 		return;
 
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
-
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u32 addr, offset;
 		u32 sg_len, len;
 
@@ -578,29 +568,27 @@ static void pdc_fill_sg(struct ata_queued_cmd *qc)
 		}
 	}
 
-	if (idx) {
-		u32 len = le32_to_cpu(ap->prd[idx - 1].flags_len);
+	len = le32_to_cpu(ap->prd[idx - 1].flags_len);
 
-		if (len > SG_COUNT_ASIC_BUG) {
-			u32 addr;
+	if (len > SG_COUNT_ASIC_BUG) {
+		u32 addr;
 
-			VPRINTK("Splitting last PRD.\n");
+		VPRINTK("Splitting last PRD.\n");
 
-			addr = le32_to_cpu(ap->prd[idx - 1].addr);
-			ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
+		addr = le32_to_cpu(ap->prd[idx - 1].addr);
+		ap->prd[idx - 1].flags_len = cpu_to_le32(len - SG_COUNT_ASIC_BUG);
+		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx - 1, addr, SG_COUNT_ASIC_BUG);
 
-			addr = addr + len - SG_COUNT_ASIC_BUG;
-			len = SG_COUNT_ASIC_BUG;
-			ap->prd[idx].addr = cpu_to_le32(addr);
-			ap->prd[idx].flags_len = cpu_to_le32(len);
-			VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
+		addr = addr + len - SG_COUNT_ASIC_BUG;
+		len = SG_COUNT_ASIC_BUG;
+		ap->prd[idx].addr = cpu_to_le32(addr);
+		ap->prd[idx].flags_len = cpu_to_le32(len);
+		VPRINTK("PRD[%u] = (0x%X, 0x%X)\n", idx, addr, len);
 
-			idx++;
-		}
-
-		ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
+		idx++;
 	}
+
+	ap->prd[idx - 1].flags_len |= cpu_to_le32(ATA_PRD_EOT);
 }
 
 static void pdc_qc_prep(struct ata_queued_cmd *qc)
@@ -627,14 +615,14 @@ static void pdc_qc_prep(struct ata_queued_cmd *qc)
 		pdc_pkt_footer(&qc->tf, pp->pkt, i);
 		break;
 
-	case ATA_PROT_ATAPI:
+	case ATAPI_PROT_PIO:
 		pdc_fill_sg(qc);
 		break;
 
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		pdc_fill_sg(qc);
 		/*FALLTHROUGH*/
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_NODATA:
 		pdc_atapi_pkt(qc);
 		break;
 
@@ -754,8 +742,8 @@ static inline unsigned int pdc_host_intr(struct ata_port *ap,
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
 	case ATA_PROT_NODATA:
-	case ATA_PROT_ATAPI_DMA:
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_DMA:
+	case ATAPI_PROT_NODATA:
 		qc->err_mask |= ac_err_mask(ata_wait_idle(ap));
 		ata_qc_complete(qc);
 		handled = 1;
@@ -900,7 +888,7 @@ static inline void pdc_packet_start(struct ata_queued_cmd *qc)
 static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
 {
 	switch (qc->tf.protocol) {
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_NODATA:
 		if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
 			break;
 		/*FALLTHROUGH*/
@@ -908,7 +896,7 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
 		if (qc->tf.flags & ATA_TFLAG_POLLING)
 			break;
 		/*FALLTHROUGH*/
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 	case ATA_PROT_DMA:
 		pdc_packet_start(qc);
 		return 0;
@@ -922,16 +910,14 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
 
 static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
 {
-	WARN_ON(tf->protocol == ATA_PROT_DMA ||
-		tf->protocol == ATA_PROT_ATAPI_DMA);
+	WARN_ON(tf->protocol == ATA_PROT_DMA || tf->protocol == ATAPI_PROT_DMA);
 	ata_tf_load(ap, tf);
 }
 
 static void pdc_exec_command_mmio(struct ata_port *ap,
 				  const struct ata_taskfile *tf)
 {
-	WARN_ON(tf->protocol == ATA_PROT_DMA ||
-		tf->protocol == ATA_PROT_ATAPI_DMA);
+	WARN_ON(tf->protocol == ATA_PROT_DMA || tf->protocol == ATAPI_PROT_DMA);
 	ata_exec_command(ap, tf);
 }
 
diff --git a/drivers/ata/sata_promise.h b/drivers/ata/sata_promise.h
index 6ee5e19..00d6000 100644
--- a/drivers/ata/sata_promise.h
+++ b/drivers/ata/sata_promise.h
@@ -46,7 +46,7 @@ static inline unsigned int pdc_pkt_header(struct ata_taskfile *tf,
 					  unsigned int devno, u8 *buf)
 {
 	u8 dev_reg;
-	u32 *buf32 = (u32 *) buf;
+	__le32 *buf32 = (__le32 *) buf;
 
 	/* set control bits (byte 0), zero delay seq id (byte 3),
 	 * and seq id (byte 2)
diff --git a/drivers/ata/sata_qstor.c b/drivers/ata/sata_qstor.c
index c68b241..91cc12c 100644
--- a/drivers/ata/sata_qstor.c
+++ b/drivers/ata/sata_qstor.c
@@ -287,14 +287,10 @@ static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
 	struct scatterlist *sg;
 	struct ata_port *ap = qc->ap;
 	struct qs_port_priv *pp = ap->private_data;
-	unsigned int nelem;
 	u8 *prd = pp->pkt + QS_CPB_BYTES;
+	unsigned int si;
 
-	WARN_ON(qc->__sg == NULL);
-	WARN_ON(qc->n_elem == 0 && qc->pad_len == 0);
-
-	nelem = 0;
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		u64 addr;
 		u32 len;
 
@@ -306,12 +302,11 @@ static unsigned int qs_fill_sg(struct ata_queued_cmd *qc)
 		*(__le32 *)prd = cpu_to_le32(len);
 		prd += sizeof(u64);
 
-		VPRINTK("PRD[%u] = (0x%llX, 0x%X)\n", nelem,
+		VPRINTK("PRD[%u] = (0x%llX, 0x%X)\n", si,
 					(unsigned long long)addr, len);
-		nelem++;
 	}
 
-	return nelem;
+	return si;
 }
 
 static void qs_qc_prep(struct ata_queued_cmd *qc)
@@ -376,7 +371,7 @@ static unsigned int qs_qc_issue(struct ata_queued_cmd *qc)
 		qs_packet_start(qc);
 		return 0;
 
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		BUG();
 		break;
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index f5119bf..0b8191b 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -416,15 +416,14 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 		 */
 
 		/* Check the ATA_DFLAG_CDB_INTR flag is enough here.
-		 * The flag was turned on only for atapi devices.
-		 * No need to check is_atapi_taskfile(&qc->tf) again.
+		 * The flag was turned on only for atapi devices.  No
+		 * need to check ata_is_atapi(qc->tf.protocol) again.
 		 */
 		if (!(qc->dev->flags & ATA_DFLAG_CDB_INTR))
 			goto err_hsm;
 		break;
 	case HSM_ST_LAST:
-		if (qc->tf.protocol == ATA_PROT_DMA ||
-		    qc->tf.protocol == ATA_PROT_ATAPI_DMA) {
+		if (ata_is_dma(qc->tf.protocol)) {
 			/* clear DMA-Start bit */
 			ap->ops->bmdma_stop(qc);
 
@@ -451,8 +450,7 @@ static void sil_host_intr(struct ata_port *ap, u32 bmdma2)
 	/* kick HSM in the ass */
 	ata_hsm_move(ap, qc, status, 0);
 
-	if (unlikely(qc->err_mask) && (qc->tf.protocol == ATA_PROT_DMA ||
-				       qc->tf.protocol == ATA_PROT_ATAPI_DMA))
+	if (unlikely(qc->err_mask) && ata_is_dma(qc->tf.protocol))
 		ata_ehi_push_desc(ehi, "BMDMA2 stat 0x%x", bmdma2);
 
 	return;
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index 864c1c1..b4b1f91 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -813,8 +813,9 @@ static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 {
 	struct scatterlist *sg;
 	struct sil24_sge *last_sge = NULL;
+	unsigned int si;
 
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		sge->addr = cpu_to_le64(sg_dma_address(sg));
 		sge->cnt = cpu_to_le32(sg_dma_len(sg));
 		sge->flags = 0;
@@ -823,8 +824,7 @@ static inline void sil24_fill_sg(struct ata_queued_cmd *qc,
 		sge++;
 	}
 
-	if (likely(last_sge))
-		last_sge->flags = cpu_to_le32(SGE_TRM);
+	last_sge->flags = cpu_to_le32(SGE_TRM);
 }
 
 static int sil24_qc_defer(struct ata_queued_cmd *qc)
@@ -852,9 +852,7 @@ static int sil24_qc_defer(struct ata_queued_cmd *qc)
 	 *   set.
 	 *
  	 */
-	int is_excl = (prot == ATA_PROT_ATAPI ||
-		       prot == ATA_PROT_ATAPI_NODATA ||
-		       prot == ATA_PROT_ATAPI_DMA ||
+	int is_excl = (ata_is_atapi(prot) ||
 		       (qc->flags & ATA_QCFLAG_RESULT_TF));
 
 	if (unlikely(ap->excl_link)) {
@@ -885,35 +883,21 @@ static void sil24_qc_prep(struct ata_queued_cmd *qc)
 
 	cb = &pp->cmd_block[sil24_tag(qc->tag)];
 
-	switch (qc->tf.protocol) {
-	case ATA_PROT_PIO:
-	case ATA_PROT_DMA:
-	case ATA_PROT_NCQ:
-	case ATA_PROT_NODATA:
+	if (!ata_is_atapi(qc->tf.protocol)) {
 		prb = &cb->ata.prb;
 		sge = cb->ata.sge;
-		break;
-
-	case ATA_PROT_ATAPI:
-	case ATA_PROT_ATAPI_DMA:
-	case ATA_PROT_ATAPI_NODATA:
+	} else {
 		prb = &cb->atapi.prb;
 		sge = cb->atapi.sge;
 		memset(cb->atapi.cdb, 0, 32);
 		memcpy(cb->atapi.cdb, qc->cdb, qc->dev->cdb_len);
 
-		if (qc->tf.protocol != ATA_PROT_ATAPI_NODATA) {
+		if (ata_is_data(qc->tf.protocol)) {
 			if (qc->tf.flags & ATA_TFLAG_WRITE)
 				ctrl = PRB_CTRL_PACKET_WRITE;
 			else
 				ctrl = PRB_CTRL_PACKET_READ;
 		}
-		break;
-
-	default:
-		prb = NULL;	/* shut up, gcc */
-		sge = NULL;
-		BUG();
 	}
 
 	prb->ctrl = cpu_to_le16(ctrl);
diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 4d85718..e3d56bc 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -334,7 +334,7 @@ static inline void pdc20621_ata_sg(struct ata_taskfile *tf, u8 *buf,
 {
 	u32 addr;
 	unsigned int dw = PDC_DIMM_APKT_PRD >> 2;
-	u32 *buf32 = (u32 *) buf;
+	__le32 *buf32 = (__le32 *) buf;
 
 	/* output ATA packet S/G table */
 	addr = PDC_20621_DIMM_BASE + PDC_20621_DIMM_DATA +
@@ -356,7 +356,7 @@ static inline void pdc20621_host_sg(struct ata_taskfile *tf, u8 *buf,
 {
 	u32 addr;
 	unsigned int dw = PDC_DIMM_HPKT_PRD >> 2;
-	u32 *buf32 = (u32 *) buf;
+	__le32 *buf32 = (__le32 *) buf;
 
 	/* output Host DMA packet S/G table */
 	addr = PDC_20621_DIMM_BASE + PDC_20621_DIMM_DATA +
@@ -377,7 +377,7 @@ static inline unsigned int pdc20621_ata_pkt(struct ata_taskfile *tf,
 					    unsigned int portno)
 {
 	unsigned int i, dw;
-	u32 *buf32 = (u32 *) buf;
+	__le32 *buf32 = (__le32 *) buf;
 	u8 dev_reg;
 
 	unsigned int dimm_sg = PDC_20621_DIMM_BASE +
@@ -429,7 +429,8 @@ static inline void pdc20621_host_pkt(struct ata_taskfile *tf, u8 *buf,
 				     unsigned int portno)
 {
 	unsigned int dw;
-	u32 tmp, *buf32 = (u32 *) buf;
+	u32 tmp;
+	__le32 *buf32 = (__le32 *) buf;
 
 	unsigned int host_sg = PDC_20621_DIMM_BASE +
 			       (PDC_DIMM_WINDOW_STEP * portno) +
@@ -473,7 +474,7 @@ static void pdc20621_dma_prep(struct ata_queued_cmd *qc)
 	void __iomem *mmio = ap->host->iomap[PDC_MMIO_BAR];
 	void __iomem *dimm_mmio = ap->host->iomap[PDC_DIMM_BAR];
 	unsigned int portno = ap->port_no;
-	unsigned int i, idx, total_len = 0, sgt_len;
+	unsigned int i, si, idx, total_len = 0, sgt_len;
 	u32 *buf = (u32 *) &pp->dimm_buf[PDC_DIMM_HEADER_SZ];
 
 	WARN_ON(!(qc->flags & ATA_QCFLAG_DMAMAP));
@@ -487,7 +488,7 @@ static void pdc20621_dma_prep(struct ata_queued_cmd *qc)
 	 * Build S/G table
 	 */
 	idx = 0;
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		buf[idx++] = cpu_to_le32(sg_dma_address(sg));
 		buf[idx++] = cpu_to_le32(sg_dma_len(sg));
 		total_len += sg_dma_len(sg);
@@ -700,7 +701,7 @@ static unsigned int pdc20621_qc_issue_prot(struct ata_queued_cmd *qc)
 		pdc20621_packet_start(qc);
 		return 0;
 
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		BUG();
 		break;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0841df0..aa0df0a 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5142,6 +5142,7 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 	struct ipr_ioadl_desc *last_ioadl = NULL;
 	int len = qc->nbytes + qc->pad_len;
 	struct scatterlist *sg;
+	unsigned int si;
 
 	if (len == 0)
 		return;
@@ -5159,7 +5160,7 @@ static void ipr_build_ata_ioadl(struct ipr_cmnd *ipr_cmd,
 			cpu_to_be32(sizeof(struct ipr_ioadl_desc) * ipr_cmd->dma_use_sg);
 	}
 
-	ata_for_each_sg(sg, qc) {
+	for_each_sg(qc->sg, sg, qc->n_elem, si) {
 		ioadl->flags_and_data_len = cpu_to_be32(ioadl_flags | sg_dma_len(sg));
 		ioadl->address = cpu_to_be32(sg_dma_address(sg));
 
@@ -5222,12 +5223,12 @@ static unsigned int ipr_qc_issue(struct ata_queued_cmd *qc)
 		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
 		break;
 
-	case ATA_PROT_ATAPI:
-	case ATA_PROT_ATAPI_NODATA:
+	case ATAPI_PROT_PIO:
+	case ATAPI_PROT_NODATA:
 		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
 		break;
 
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 		regs->flags |= IPR_ATA_FLAG_PACKET_CMD;
 		regs->flags |= IPR_ATA_FLAG_XFER_TYPE_DMA;
 		break;
diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
index 0829b55..827cfb1 100644
--- a/drivers/scsi/libsas/sas_ata.c
+++ b/drivers/scsi/libsas/sas_ata.c
@@ -158,8 +158,8 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	struct Scsi_Host *host = sas_ha->core.shost;
 	struct sas_internal *i = to_sas_internal(host->transportt);
 	struct scatterlist *sg;
-	unsigned int num = 0;
 	unsigned int xfer = 0;
+	unsigned int si;
 
 	task = sas_alloc_task(GFP_ATOMIC);
 	if (!task)
@@ -176,22 +176,20 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 
 	ata_tf_to_fis(&qc->tf, 1, 0, (u8*)&task->ata_task.fis);
 	task->uldd_task = qc;
-	if (is_atapi_taskfile(&qc->tf)) {
+	if (ata_is_atapi(qc->tf.protocol)) {
 		memcpy(task->ata_task.atapi_packet, qc->cdb, qc->dev->cdb_len);
 		task->total_xfer_len = qc->nbytes + qc->pad_len;
 		task->num_scatter = qc->pad_len ? qc->n_elem + 1 : qc->n_elem;
 	} else {
-		ata_for_each_sg(sg, qc) {
-			num++;
+		for_each_sg(qc->sg, sg, qc->n_elem, si)
 			xfer += sg->length;
-		}
 
 		task->total_xfer_len = xfer;
-		task->num_scatter = num;
+		task->num_scatter = si;
 	}
 
 	task->data_dir = qc->dma_dir;
-	task->scatter = qc->__sg;
+	task->scatter = qc->sg;
 	task->ata_task.retry_count = 1;
 	task->task_state_flags = SAS_TASK_STATE_PENDING;
 	qc->lldd_task = task;
@@ -200,7 +198,7 @@ static unsigned int sas_ata_qc_issue(struct ata_queued_cmd *qc)
 	case ATA_PROT_NCQ:
 		task->ata_task.use_ncq = 1;
 		/* fall through */
-	case ATA_PROT_ATAPI_DMA:
+	case ATAPI_PROT_DMA:
 	case ATA_PROT_DMA:
 		task->ata_task.dma_xfer = 1;
 		break;
diff --git a/include/linux/ata.h b/include/linux/ata.h
index e672e80..78bbaca 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -286,9 +286,10 @@ enum {
 	ATA_CBL_NONE		= 0,
 	ATA_CBL_PATA40		= 1,
 	ATA_CBL_PATA80		= 2,
-	ATA_CBL_PATA40_SHORT	= 3,		/* 40 wire cable to high UDMA spec */
-	ATA_CBL_PATA_UNK	= 4,
-	ATA_CBL_SATA		= 5,
+	ATA_CBL_PATA40_SHORT	= 3,	/* 40 wire cable to high UDMA spec */
+	ATA_CBL_PATA_UNK	= 4,	/* don't know, maybe 80c? */
+	ATA_CBL_PATA_IGN	= 5,	/* don't know, ignore cable handling */
+	ATA_CBL_SATA		= 6,
 
 	/* SATA Status and Control Registers */
 	SCR_STATUS		= 0,
@@ -324,6 +325,13 @@ enum {
 	ATA_TFLAG_LBA		= (1 << 4), /* enable LBA */
 	ATA_TFLAG_FUA		= (1 << 5), /* enable FUA */
 	ATA_TFLAG_POLLING	= (1 << 6), /* set nIEN to 1 and use polling */
+
+	/* protocol flags */
+	ATA_PROT_FLAG_PIO	= (1 << 0), /* is PIO */
+	ATA_PROT_FLAG_DMA	= (1 << 1), /* is DMA */
+	ATA_PROT_FLAG_DATA	= ATA_PROT_FLAG_PIO | ATA_PROT_FLAG_DMA,
+	ATA_PROT_FLAG_NCQ	= (1 << 2), /* is NCQ */
+	ATA_PROT_FLAG_ATAPI	= (1 << 3), /* is ATAPI */
 };
 
 enum ata_tf_protocols {
@@ -333,9 +341,9 @@ enum ata_tf_protocols {
 	ATA_PROT_PIO,		/* PIO data xfer */
 	ATA_PROT_DMA,		/* DMA */
 	ATA_PROT_NCQ,		/* NCQ */
-	ATA_PROT_ATAPI,		/* packet command, PIO data xfer*/
-	ATA_PROT_ATAPI_NODATA,	/* packet command, no data */
-	ATA_PROT_ATAPI_DMA,	/* packet command with special DMA sauce */
+	ATAPI_PROT_NODATA,	/* packet command, no data */
+	ATAPI_PROT_PIO,		/* packet command, PIO data xfer*/
+	ATAPI_PROT_DMA,		/* packet command with special DMA sauce */
 };
 
 enum ata_ioctls {
@@ -346,8 +354,8 @@ enum ata_ioctls {
 /* core structures */
 
 struct ata_prd {
-	u32			addr;
-	u32			flags_len;
+	__le32			addr;
+	__le32			flags_len;
 };
 
 struct ata_taskfile {
@@ -373,13 +381,69 @@ struct ata_taskfile {
 	u8			command;	/* IO operation */
 };
 
+/*
+ * protocol tests
+ */
+static inline unsigned int ata_prot_flags(u8 prot)
+{
+	switch (prot) {
+	case ATA_PROT_NODATA:
+		return 0;
+	case ATA_PROT_PIO:
+		return ATA_PROT_FLAG_PIO;
+	case ATA_PROT_DMA:
+		return ATA_PROT_FLAG_DMA;
+	case ATA_PROT_NCQ:
+		return ATA_PROT_FLAG_DMA | ATA_PROT_FLAG_NCQ;
+	case ATAPI_PROT_NODATA:
+		return ATA_PROT_FLAG_ATAPI;
+	case ATAPI_PROT_PIO:
+		return ATA_PROT_FLAG_ATAPI | ATA_PROT_FLAG_PIO;
+	case ATAPI_PROT_DMA:
+		return ATA_PROT_FLAG_ATAPI | ATA_PROT_FLAG_DMA;
+	}
+	return 0;
+}
+
+static inline int ata_is_atapi(u8 prot)
+{
+	return ata_prot_flags(prot) & ATA_PROT_FLAG_ATAPI;
+}
+
+static inline int ata_is_nodata(u8 prot)
+{
+	return !(ata_prot_flags(prot) & ATA_PROT_FLAG_DATA);
+}
+
+static inline int ata_is_pio(u8 prot)
+{
+	return ata_prot_flags(prot) & ATA_PROT_FLAG_PIO;
+}
+
+static inline int ata_is_dma(u8 prot)
+{
+	return ata_prot_flags(prot) & ATA_PROT_FLAG_DMA;
+}
+
+static inline int ata_is_ncq(u8 prot)
+{
+	return ata_prot_flags(prot) & ATA_PROT_FLAG_NCQ;
+}
+
+static inline int ata_is_data(u8 prot)
+{
+	return ata_prot_flags(prot) & ATA_PROT_FLAG_DATA;
+}
+
+/*
+ * id tests
+ */
 #define ata_id_is_ata(id)	(((id)[0] & (1 << 15)) == 0)
 #define ata_id_has_lba(id)	((id)[49] & (1 << 9))
 #define ata_id_has_dma(id)	((id)[49] & (1 << 8))
 #define ata_id_has_ncq(id)	((id)[76] & (1 << 8))
 #define ata_id_queue_depth(id)	(((id)[75] & 0x1f) + 1)
 #define ata_id_removeable(id)	((id)[0] & (1 << 7))
-#define ata_id_has_dword_io(id)	((id)[48] & (1 << 0))
 #define ata_id_has_atapi_AN(id)	\
 	( (((id)[76] != 0x0000) && ((id)[76] != 0xffff)) && \
 	  ((id)[78] & (1 << 5)) )
@@ -415,6 +479,7 @@ static inline bool ata_id_has_dipm(const u16 *id)
 	return val & (1 << 3);
 }
 
+
 static inline int ata_id_has_fua(const u16 *id)
 {
 	if ((id[84] & 0xC000) != 0x4000)
@@ -519,6 +584,26 @@ static inline int ata_id_is_sata(const u16 *id)
 	return ata_id_major_version(id) >= 5 && id[93] == 0;
 }
 
+static inline int ata_id_has_tpm(const u16 *id)
+{
+	/* The TPM bits are only valid on ATA8 */
+	if (ata_id_major_version(id) < 8)
+		return 0;
+	if ((id[48] & 0xC000) != 0x4000)
+		return 0;
+	return id[48] & (1 << 0);
+}
+
+static inline int ata_id_has_dword_io(const u16 *id)
+{
+	/* ATA 8 reuses this flag for "trusted" computing */
+	if (ata_id_major_version(id) > 7)
+		return 0;
+	if (id[48] & (1 << 0))
+		return 1;
+	return 0;
+}
+
 static inline int ata_id_current_chs_valid(const u16 *id)
 {
 	/* For ATA-1 devices, if the INITIALIZE DEVICE PARAMETERS command
@@ -574,13 +659,6 @@ static inline int atapi_command_packet_set(const u16 *dev_id)
 	return (dev_id[0] >> 8) & 0x1f;
 }
 
-static inline int is_atapi_taskfile(const struct ata_taskfile *tf)
-{
-	return (tf->protocol == ATA_PROT_ATAPI) ||
-	       (tf->protocol == ATA_PROT_ATAPI_NODATA) ||
-	       (tf->protocol == ATA_PROT_ATAPI_DMA);
-}
-
 static inline int is_multi_taskfile(struct ata_taskfile *tf)
 {
 	return (tf->command == ATA_CMD_READ_MULTI) ||
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index c6d3e22..fcdc11b 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -451,6 +451,7 @@ struct cdrom_generic_command
 #define GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL  0x1e
 #define GPCMD_READ_10			    0x28
 #define GPCMD_READ_12			    0xa8
+#define GPCMD_READ_BUFFER		    0x3c
 #define GPCMD_READ_BUFFER_CAPACITY	    0x5c
 #define GPCMD_READ_CDVD_CAPACITY	    0x25
 #define GPCMD_READ_CD			    0xbe
@@ -480,7 +481,9 @@ struct cdrom_generic_command
 #define GPCMD_TEST_UNIT_READY		    0x00
 #define GPCMD_VERIFY_10			    0x2f
 #define GPCMD_WRITE_10			    0x2a
+#define GPCMD_WRITE_12			    0xaa
 #define GPCMD_WRITE_AND_VERIFY_10	    0x2e
+#define GPCMD_WRITE_BUFFER		    0x3b
 /* This is listed as optional in ATAPI 2.6, but is (curiously) 
  * missing from Mt. Fuji, Table 57.  It _is_ mentioned in Mt. Fuji
  * Table 377 as an MMC command for SCSi devices though...  Most ATAPI
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 124033c..4374c42 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -35,6 +35,7 @@
 #include <linux/workqueue.h>
 #include <scsi/scsi_host.h>
 #include <linux/acpi.h>
+#include <linux/cdrom.h>
 
 /*
  * Define if arch has non-standard setup.  This is a _PCI_ standard
@@ -143,10 +144,11 @@ enum {
 	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
 	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
-	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
+	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
+	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
-	ATA_DFLAG_DETACH	= (1 << 16),
-	ATA_DFLAG_DETACHED	= (1 << 17),
+	ATA_DFLAG_DETACH	= (1 << 24),
+	ATA_DFLAG_DETACHED	= (1 << 25),
 
 	ATA_DEV_UNKNOWN		= 0,	/* unknown device */
 	ATA_DEV_ATA		= 1,	/* ATA device */
@@ -217,9 +219,7 @@ enum {
 
 	/* struct ata_queued_cmd flags */
 	ATA_QCFLAG_ACTIVE	= (1 << 0), /* cmd not yet ack'd to scsi lyer */
-	ATA_QCFLAG_SG		= (1 << 1), /* have s/g table? */
-	ATA_QCFLAG_SINGLE	= (1 << 2), /* no s/g, just a single buffer */
-	ATA_QCFLAG_DMAMAP	= ATA_QCFLAG_SG | ATA_QCFLAG_SINGLE,
+	ATA_QCFLAG_DMAMAP	= (1 << 1), /* SG table is DMA mapped */
 	ATA_QCFLAG_IO		= (1 << 3), /* standard IO command */
 	ATA_QCFLAG_RESULT_TF	= (1 << 4), /* result TF requested */
 	ATA_QCFLAG_CLEAR_EXCL	= (1 << 5), /* clear excl_link on completion */
@@ -266,19 +266,15 @@ enum {
 	PORT_DISABLED		= 2,
 
 	/* encoding various smaller bitmaps into a single
-	 * unsigned int bitmap
+	 * unsigned long bitmap
 	 */
-	ATA_BITS_PIO		= 7,
-	ATA_BITS_MWDMA		= 5,
-	ATA_BITS_UDMA		= 8,
+	ATA_NR_PIO_MODES	= 7,
+	ATA_NR_MWDMA_MODES	= 5,
+	ATA_NR_UDMA_MODES	= 8,
 
 	ATA_SHIFT_PIO		= 0,
-	ATA_SHIFT_MWDMA		= ATA_SHIFT_PIO + ATA_BITS_PIO,
-	ATA_SHIFT_UDMA		= ATA_SHIFT_MWDMA + ATA_BITS_MWDMA,
-
-	ATA_MASK_PIO		= ((1 << ATA_BITS_PIO) - 1) << ATA_SHIFT_PIO,
-	ATA_MASK_MWDMA		= ((1 << ATA_BITS_MWDMA) - 1) << ATA_SHIFT_MWDMA,
-	ATA_MASK_UDMA		= ((1 << ATA_BITS_UDMA) - 1) << ATA_SHIFT_UDMA,
+	ATA_SHIFT_MWDMA		= ATA_SHIFT_PIO + ATA_NR_PIO_MODES,
+	ATA_SHIFT_UDMA		= ATA_SHIFT_MWDMA + ATA_NR_MWDMA_MODES,
 
 	/* size of buffer to pad xfers ending on unaligned boundaries */
 	ATA_DMA_PAD_SZ		= 4,
@@ -349,6 +345,21 @@ enum {
 	ATA_DMA_MASK_ATA	= (1 << 0),	/* DMA on ATA Disk */
 	ATA_DMA_MASK_ATAPI	= (1 << 1),	/* DMA on ATAPI */
 	ATA_DMA_MASK_CFA	= (1 << 2),	/* DMA on CF Card */
+
+	/* ATAPI command types */
+	ATAPI_READ		= 0,		/* READs */
+	ATAPI_WRITE		= 1,		/* WRITEs */
+	ATAPI_READ_CD		= 2,		/* READ CD [MSF] */
+	ATAPI_MISC		= 3,		/* the rest */
+};
+
+enum ata_xfer_mask {
+	ATA_MASK_PIO		= ((1LU << ATA_NR_PIO_MODES) - 1)
+					<< ATA_SHIFT_PIO,
+	ATA_MASK_MWDMA		= ((1LU << ATA_NR_MWDMA_MODES) - 1)
+					<< ATA_SHIFT_MWDMA,
+	ATA_MASK_UDMA		= ((1LU << ATA_NR_UDMA_MODES) - 1)
+					<< ATA_SHIFT_UDMA,
 };
 
 enum hsm_task_states {
@@ -447,7 +458,7 @@ struct ata_queued_cmd {
 	unsigned int		tag;
 	unsigned int		n_elem;
 	unsigned int		n_iter;
-	unsigned int		orig_n_elem;
+	unsigned int		mapped_n_elem;
 
 	int			dma_dir;
 
@@ -455,17 +466,18 @@ struct ata_queued_cmd {
 	unsigned int		sect_size;
 
 	unsigned int		nbytes;
+	unsigned int		raw_nbytes;
 	unsigned int		curbytes;
 
 	struct scatterlist	*cursg;
 	unsigned int		cursg_ofs;
 
+	struct scatterlist	*last_sg;
+	struct scatterlist	saved_last_sg;
 	struct scatterlist	sgent;
-	struct scatterlist	pad_sgent;
-	void			*buf_virt;
+	struct scatterlist	extra_sg[2];
 
-	/* DO NOT iterate over __sg manually, use ata_for_each_sg() */
-	struct scatterlist	*__sg;
+	struct scatterlist	*sg;
 
 	unsigned int		err_mask;
 	struct ata_taskfile	result_tf;
@@ -482,7 +494,7 @@ struct ata_port_stats {
 };
 
 struct ata_ering_entry {
-	int			is_io;
+	unsigned int		eflags;
 	unsigned int		err_mask;
 	u64			timestamp;
 };
@@ -522,9 +534,9 @@ struct ata_device {
 	unsigned int		cdb_len;
 
 	/* per-dev xfer mask */
-	unsigned int		pio_mask;
-	unsigned int		mwdma_mask;
-	unsigned int		udma_mask;
+	unsigned long		pio_mask;
+	unsigned long		mwdma_mask;
+	unsigned long		udma_mask;
 
 	/* for CHS addressing */
 	u16			cylinders;	/* Number of cylinders */
@@ -560,6 +572,8 @@ struct ata_eh_context {
 	int			tries[ATA_MAX_DEVICES];
 	unsigned int		classes[ATA_MAX_DEVICES];
 	unsigned int		did_probe_mask;
+	unsigned int		saved_ncq_enabled;
+	u8			saved_xfer_mode[ATA_MAX_DEVICES];
 };
 
 struct ata_acpi_drive
@@ -686,7 +700,8 @@ struct ata_port_operations {
 	void (*bmdma_setup) (struct ata_queued_cmd *qc);
 	void (*bmdma_start) (struct ata_queued_cmd *qc);
 
-	void (*data_xfer) (struct ata_device *, unsigned char *, unsigned int, int);
+	unsigned int (*data_xfer) (struct ata_device *dev, unsigned char *buf,
+				   unsigned int buflen, int rw);
 
 	int (*qc_defer) (struct ata_queued_cmd *qc);
 	void (*qc_prep) (struct ata_queued_cmd *qc);
@@ -832,8 +847,6 @@ extern int ata_busy_sleep(struct ata_port *ap,
 			  unsigned long timeout_pat, unsigned long timeout);
 extern void ata_wait_after_reset(struct ata_port *ap, unsigned long deadline);
 extern int ata_wait_ready(struct ata_port *ap, unsigned long deadline);
-extern void ata_port_queue_task(struct ata_port *ap, work_func_t fn,
-				void *data, unsigned long delay);
 extern u32 ata_wait_register(void __iomem *reg, u32 mask, u32 val,
 			     unsigned long interval_msec,
 			     unsigned long timeout_msec);
@@ -848,6 +861,16 @@ extern void ata_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 extern void ata_tf_to_fis(const struct ata_taskfile *tf,
 			  u8 pmp, int is_cmd, u8 *fis);
 extern void ata_tf_from_fis(const u8 *fis, struct ata_taskfile *tf);
+extern unsigned long ata_pack_xfermask(unsigned long pio_mask,
+			unsigned long mwdma_mask, unsigned long udma_mask);
+extern void ata_unpack_xfermask(unsigned long xfer_mask,
+			unsigned long *pio_mask, unsigned long *mwdma_mask,
+			unsigned long *udma_mask);
+extern u8 ata_xfer_mask2mode(unsigned long xfer_mask);
+extern unsigned long ata_xfer_mode2mask(u8 xfer_mode);
+extern int ata_xfer_mode2shift(unsigned long xfer_mode);
+extern const char *ata_mode_string(unsigned long xfer_mask);
+extern unsigned long ata_id_xfermask(const u16 *id);
 extern void ata_noop_dev_select(struct ata_port *ap, unsigned int device);
 extern void ata_std_dev_select(struct ata_port *ap, unsigned int device);
 extern u8 ata_check_status(struct ata_port *ap);
@@ -856,17 +879,15 @@ extern void ata_exec_command(struct ata_port *ap, const struct ata_taskfile *tf)
 extern int ata_port_start(struct ata_port *ap);
 extern int ata_sff_port_start(struct ata_port *ap);
 extern irqreturn_t ata_interrupt(int irq, void *dev_instance);
-extern void ata_data_xfer(struct ata_device *adev, unsigned char *buf,
-			  unsigned int buflen, int write_data);
-extern void ata_data_xfer_noirq(struct ata_device *adev, unsigned char *buf,
-				unsigned int buflen, int write_data);
+extern unsigned int ata_data_xfer(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw);
+extern unsigned int ata_data_xfer_noirq(struct ata_device *dev,
+			unsigned char *buf, unsigned int buflen, int rw);
 extern int ata_std_qc_defer(struct ata_queued_cmd *qc);
 extern void ata_dumb_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_qc_prep(struct ata_queued_cmd *qc);
 extern void ata_noop_qc_prep(struct ata_queued_cmd *qc);
 extern unsigned int ata_qc_issue_prot(struct ata_queued_cmd *qc);
-extern void ata_sg_init_one(struct ata_queued_cmd *qc, void *buf,
-		unsigned int buflen);
 extern void ata_sg_init(struct ata_queued_cmd *qc, struct scatterlist *sg,
 		 unsigned int n_elem);
 extern unsigned int ata_dev_classify(const struct ata_taskfile *tf);
@@ -875,7 +896,6 @@ extern void ata_id_string(const u16 *id, unsigned char *s,
 			  unsigned int ofs, unsigned int len);
 extern void ata_id_c_string(const u16 *id, unsigned char *s,
 			    unsigned int ofs, unsigned int len);
-extern void ata_id_to_dma_mode(struct ata_device *dev, u8 unknown);
 extern void ata_bmdma_setup(struct ata_queued_cmd *qc);
 extern void ata_bmdma_start(struct ata_queued_cmd *qc);
 extern void ata_bmdma_stop(struct ata_queued_cmd *qc);
@@ -910,6 +930,7 @@ extern u8 ata_irq_on(struct ata_port *ap);
 extern int ata_cable_40wire(struct ata_port *ap);
 extern int ata_cable_80wire(struct ata_port *ap);
 extern int ata_cable_sata(struct ata_port *ap);
+extern int ata_cable_ignore(struct ata_port *ap);
 extern int ata_cable_unknown(struct ata_port *ap);
 
 /*
@@ -917,11 +938,13 @@ extern int ata_cable_unknown(struct ata_port *ap);
  */
 
 extern unsigned int ata_pio_need_iordy(const struct ata_device *);
+extern const struct ata_timing *ata_timing_find_mode(u8 xfer_mode);
 extern int ata_timing_compute(struct ata_device *, unsigned short,
 			      struct ata_timing *, int, int);
 extern void ata_timing_merge(const struct ata_timing *,
 			     const struct ata_timing *, struct ata_timing *,
 			     unsigned int);
+extern u8 ata_timing_cycle2mode(unsigned int xfer_shift, int cycle);
 
 enum {
 	ATA_TIMING_SETUP	= (1 << 0),
@@ -948,15 +971,40 @@ static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
 		return &ap->__acpi_init_gtm;
 	return NULL;
 }
-extern int ata_acpi_cbl_80wire(struct ata_port *ap);
 int ata_acpi_stm(struct ata_port *ap, const struct ata_acpi_gtm *stm);
 int ata_acpi_gtm(struct ata_port *ap, struct ata_acpi_gtm *stm);
+unsigned long ata_acpi_gtm_xfermask(struct ata_device *dev,
+				    const struct ata_acpi_gtm *gtm);
+int ata_acpi_cbl_80wire(struct ata_port *ap, const struct ata_acpi_gtm *gtm);
 #else
 static inline const struct ata_acpi_gtm *ata_acpi_init_gtm(struct ata_port *ap)
 {
 	return NULL;
 }
-static inline int ata_acpi_cbl_80wire(struct ata_port *ap) { return 0; }
+
+static inline int ata_acpi_stm(const struct ata_port *ap,
+			       struct ata_acpi_gtm *stm)
+{
+	return -ENOSYS;
+}
+
+static inline int ata_acpi_gtm(const struct ata_port *ap,
+			       struct ata_acpi_gtm *stm)
+{
+	return -ENOSYS;
+}
+
+static inline unsigned int ata_acpi_gtm_xfermask(struct ata_device *dev,
+					const struct ata_acpi_gtm *gtm)
+{
+	return 0;
+}
+
+static inline int ata_acpi_cbl_80wire(struct ata_port *ap,
+				      const struct ata_acpi_gtm *gtm)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_PCI
@@ -985,8 +1033,12 @@ extern int ata_pci_init_bmdma(struct ata_host *host);
 extern int ata_pci_prepare_sff_host(struct pci_dev *pdev,
 				    const struct ata_port_info * const * ppi,
 				    struct ata_host **r_host);
+extern int ata_pci_activate_sff_host(struct ata_host *host,
+				     irq_handler_t irq_handler,
+				     struct scsi_host_template *sht);
 extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
-extern unsigned long ata_pci_default_filter(struct ata_device *, unsigned long);
+extern unsigned long ata_pci_default_filter(struct ata_device *dev,
+					    unsigned long xfer_mask);
 #endif /* CONFIG_PCI */
 
 /*
@@ -1074,35 +1126,6 @@ extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 			       const char *name);
 #endif
 
-/*
- * qc helpers
- */
-static inline struct scatterlist *
-ata_qc_first_sg(struct ata_queued_cmd *qc)
-{
-	qc->n_iter = 0;
-	if (qc->n_elem)
-		return qc->__sg;
-	if (qc->pad_len)
-		return &qc->pad_sgent;
-	return NULL;
-}
-
-static inline struct scatterlist *
-ata_qc_next_sg(struct scatterlist *sg, struct ata_queued_cmd *qc)
-{
-	if (sg == &qc->pad_sgent)
-		return NULL;
-	if (++qc->n_iter < qc->n_elem)
-		return sg_next(sg);
-	if (qc->pad_len)
-		return &qc->pad_sgent;
-	return NULL;
-}
-
-#define ata_for_each_sg(sg, qc) \
-	for (sg = ata_qc_first_sg(qc); sg; sg = ata_qc_next_sg(sg, qc))
-
 static inline unsigned int ata_tag_valid(unsigned int tag)
 {
 	return (tag < ATA_MAX_QUEUE) ? 1 : 0;
@@ -1337,15 +1360,17 @@ static inline void ata_tf_init(struct ata_device *dev, struct ata_taskfile *tf)
 static inline void ata_qc_reinit(struct ata_queued_cmd *qc)
 {
 	qc->dma_dir = DMA_NONE;
-	qc->__sg = NULL;
+	qc->sg = NULL;
 	qc->flags = 0;
 	qc->cursg = NULL;
 	qc->cursg_ofs = 0;
-	qc->nbytes = qc->curbytes = 0;
+	qc->nbytes = qc->raw_nbytes = qc->curbytes = 0;
 	qc->n_elem = 0;
+	qc->mapped_n_elem = 0;
 	qc->n_iter = 0;
 	qc->err_mask = 0;
 	qc->pad_len = 0;
+	qc->last_sg = NULL;
 	qc->sect_size = ATA_SECT_SIZE;
 
 	ata_tf_init(qc->dev, &qc->tf);
@@ -1362,6 +1387,27 @@ static inline int ata_try_flush_cache(const struct ata_device *dev)
 	       ata_id_has_flush_ext(dev->id);
 }
 
+static inline int atapi_cmd_type(u8 opcode)
+{
+	switch (opcode) {
+	case GPCMD_READ_10:
+	case GPCMD_READ_12:
+		return ATAPI_READ;
+
+	case GPCMD_WRITE_10:
+	case GPCMD_WRITE_12:
+	case GPCMD_WRITE_AND_VERIFY_10:
+		return ATAPI_WRITE;
+
+	case GPCMD_READ_CD:
+	case GPCMD_READ_CD_MSF:
+		return ATAPI_READ_CD;
+
+	default:
+		return ATAPI_MISC;
+	}
+}
+
 static inline unsigned int ac_err_mask(u8 status)
 {
 	if (status & (ATA_BUSY | ATA_DRQ))
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 7f22151..1fbd025 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2066,6 +2066,9 @@
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
+#define PCI_VENDOR_ID_CENATEK		0x16CA
+#define PCI_DEVICE_ID_CENATEK_IDE	0x0001
+
 #define PCI_VENDOR_ID_VITESSE		0x1725
 #define PCI_DEVICE_ID_VITESSE_VSC7174	0x7174
 
