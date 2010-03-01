Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab0CAUXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 15:23:35 -0500
Received: from havoc.gtf.org ([69.61.125.42]:37211 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0CAUXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 15:23:31 -0500
Date: Mon, 1 Mar 2010 15:23:30 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates for 2.6.34
Message-ID: <20100301202330.GA14977@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/Kconfig             |    4 +-
 drivers/ata/ahci.c              |  235 +++++++++++++++++++++++++++++++++++----
 drivers/ata/ata_generic.c       |    2 +-
 drivers/ata/ata_piix.c          |   28 ++++-
 drivers/ata/libata-core.c       |   17 ++-
 drivers/ata/libata-sff.c        |   50 +++++++--
 drivers/ata/pata_acpi.c         |    2 +-
 drivers/ata/pata_ali.c          |   10 +-
 drivers/ata/pata_amd.c          |    2 +-
 drivers/ata/pata_artop.c        |    2 +-
 drivers/ata/pata_at91.c         |    4 +-
 drivers/ata/pata_atiixp.c       |   14 ++-
 drivers/ata/pata_cmd640.c       |    2 +-
 drivers/ata/pata_cmd64x.c       |   27 ++---
 drivers/ata/pata_cs5530.c       |    2 +-
 drivers/ata/pata_cs5535.c       |    4 +-
 drivers/ata/pata_cs5536.c       |    2 +-
 drivers/ata/pata_cypress.c      |   12 +-
 drivers/ata/pata_efar.c         |   22 +++-
 drivers/ata/pata_hpt366.c       |   23 +---
 drivers/ata/pata_hpt37x.c       |  189 ++++++++++++++-----------------
 drivers/ata/pata_hpt3x2n.c      |  120 +++++++++-----------
 drivers/ata/pata_it8213.c       |    2 +-
 drivers/ata/pata_it821x.c       |    2 +-
 drivers/ata/pata_jmicron.c      |    2 +-
 drivers/ata/pata_marvell.c      |    4 +-
 drivers/ata/pata_netcell.c      |    2 +-
 drivers/ata/pata_ns87410.c      |    2 +-
 drivers/ata/pata_ns87415.c      |    2 +-
 drivers/ata/pata_oldpiix.c      |    2 +-
 drivers/ata/pata_opti.c         |    2 +-
 drivers/ata/pata_optidma.c      |    2 +-
 drivers/ata/pata_pcmcia.c       |    2 +-
 drivers/ata/pata_pdc202xx_old.c |   17 +++-
 drivers/ata/pata_piccolo.c      |    2 +-
 drivers/ata/pata_radisys.c      |    2 +-
 drivers/ata/pata_rz1000.c       |    2 +-
 drivers/ata/pata_sc1200.c       |    2 +-
 drivers/ata/pata_serverworks.c  |    7 +-
 drivers/ata/pata_sil680.c       |    2 +-
 drivers/ata/pata_sis.c          |    2 +-
 drivers/ata/pata_sl82c105.c     |    2 +-
 drivers/ata/pata_triflex.c      |    2 +-
 drivers/ata/pata_via.c          |  210 ++++++++++++++++-------------------
 drivers/ata/sata_via.c          |   23 ++++-
 drivers/staging/phison/phison.c |    2 +-
 include/linux/ata.h             |    3 +-
 include/linux/libata.h          |    5 +-
 48 files changed, 663 insertions(+), 417 deletions(-)

Alan Cox (4):
      libata: Allow pata_legacy to be built on non-ISA but PCI systems
      libata: Pass host flags into the pci helper
      pata_atiixp: enable parallel scan
      pata_efar: Enable parallel scanning

Bart Hartgers (2):
      sata_via: Correctly setup PIO/DMA for pata slave on vt6421.
      sata_via: Delay on vt6420 when starting ATAPI DMA write

Bartlomiej Zolnierkiewicz (17):
      libata: fix CFA handling in ide_timing_compute()
      pata_ali: documentation fixes
      pata_cmd64x: fix PIO setup
      pata_cmd64x: fix handling of address setup timings
      pata_cmd64x: cmd648_bmdma_stop() fix
      pata_cmd64x: remove unused definitions
      pata_cs5535: use correct values for PIO1 and PIO2 data timings
      pata_cypress: fix PIO timings underclocking
      pata_efar: fix secondary port support
      pata_serverworks: fix PIO setup for the second channel
      pata_serverworks: fix error message
      pata_via: fix address setup timings underlocking
      pata_via: store UDMA masks in via_isa_bridges table
      pata_pdc202xx_old: fix UDMA mode for Promise UDMA33 cards
      pata_pdc202xx_old: fix UDMA mode for PDC2026x chipsets
      [libata] pata_efar: add locking for parallel scanning
      [libata] pata_atiixp: add locking for parallel scanning

Ben Gardner (1):
      ata: Detect Delkin Devices compact flash

Christoph Egger (1):
      [libata] pata_marvell: CONFIG_AHCI is really CONFIG_SATA_AHCI

Jeff Garzik (1):
      [libata] pata_at91: fix backslash-continued string

Robert Hancock (1):
      libata: make functions/variables static

Sergei Shtylyov (6):
      pata_hpt37x: use ATA_DMA_* constants
      pata_hpt3x2n: always stretch UltraDMA timing
      pata_hpt{37x|3x2n}: unify mode programming
      pata_hpt366: remove redundant code
      pata_hpt{37x|3x2n}: improve timing register documentation
      pata_hpt366: remove irrelevant TODO

Seth Heasley (2):
      ahci: AHCI and RAID mode SATA patch for Intel Cougar Point DeviceIDs
      ata_piix: IDE Mode SATA patch for Intel Cougar Point DeviceIDs

Shane Huang (1):
      ahci: Implement SATA AHCI FIS-based switching support

Tejun Heo (2):
      libata: cleanup ata_sff_interrupt()
      libata: implement spurious irq handling for SFF and apply it to piix

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 56c6374..01c52c4 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -446,9 +446,9 @@ config PATA_JMICRON
 
 config PATA_LEGACY
 	tristate "Legacy ISA PATA support (Experimental)"
-	depends on ISA && EXPERIMENTAL
+	depends on (ISA || PCI)  && EXPERIMENTAL
 	help
-	  This option enables support for ISA/VLB bus legacy PATA
+	  This option enables support for ISA/VLB/PCI bus legacy PATA
 	  ports and allows them to be accessed via the new ATA layer.
 
 	  If unsure, say N.
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a6a736a..6bd930b 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -93,6 +93,9 @@ enum {
 	AHCI_CMD_TBL_AR_SZ	= AHCI_CMD_TBL_SZ * AHCI_MAX_CMDS,
 	AHCI_PORT_PRIV_DMA_SZ	= AHCI_CMD_SLOT_SZ + AHCI_CMD_TBL_AR_SZ +
 				  AHCI_RX_FIS_SZ,
+	AHCI_PORT_PRIV_FBS_DMA_SZ	= AHCI_CMD_SLOT_SZ +
+					  AHCI_CMD_TBL_AR_SZ +
+					  (AHCI_RX_FIS_SZ * 16),
 	AHCI_IRQ_ON_SG		= (1 << 31),
 	AHCI_CMD_ATAPI		= (1 << 5),
 	AHCI_CMD_WRITE		= (1 << 6),
@@ -170,6 +173,7 @@ enum {
 	PORT_SCR_ERR		= 0x30, /* SATA phy register: SError */
 	PORT_SCR_ACT		= 0x34, /* SATA phy register: SActive */
 	PORT_SCR_NTF		= 0x3c, /* SATA phy register: SNotification */
+	PORT_FBS		= 0x40, /* FIS-based Switching */
 
 	/* PORT_IRQ_{STAT,MASK} bits */
 	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
@@ -208,6 +212,7 @@ enum {
 	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
 	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
+	PORT_CMD_FBSCP		= (1 << 22), /* FBS Capable Port */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
@@ -222,6 +227,14 @@ enum {
 	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
 	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
 
+	PORT_FBS_DWE_OFFSET	= 16, /* FBS device with error offset */
+	PORT_FBS_ADO_OFFSET	= 12, /* FBS active dev optimization offset */
+	PORT_FBS_DEV_OFFSET	= 8,  /* FBS device to issue offset */
+	PORT_FBS_DEV_MASK	= (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.DEV */
+	PORT_FBS_SDE		= (1 << 2), /* FBS single device error */
+	PORT_FBS_DEC		= (1 << 1), /* FBS device error clear */
+	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
+
 	/* hpriv->flags bits */
 	AHCI_HFLAG_NO_NCQ		= (1 << 0),
 	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
@@ -304,6 +317,9 @@ struct ahci_port_priv {
 	unsigned int		ncq_saw_dmas:1;
 	unsigned int		ncq_saw_sdb:1;
 	u32 			intr_mask;	/* interrupts to enable */
+	bool			fbs_supported;	/* set iff FBS is supported */
+	bool			fbs_enabled;	/* set iff FBS is enabled */
+	int			fbs_last_dev;	/* save FBS.DEV of last FIS */
 	/* enclosure management info per PM slot */
 	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
 };
@@ -315,9 +331,12 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
+static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc);
 static void ahci_qc_prep(struct ata_queued_cmd *qc);
 static void ahci_freeze(struct ata_port *ap);
 static void ahci_thaw(struct ata_port *ap);
+static void ahci_enable_fbs(struct ata_port *ap);
+static void ahci_disable_fbs(struct ata_port *ap);
 static void ahci_pmp_attach(struct ata_port *ap);
 static void ahci_pmp_detach(struct ata_port *ap);
 static int ahci_softreset(struct ata_link *link, unsigned int *class,
@@ -356,10 +375,10 @@ static ssize_t ahci_show_host_version(struct device *dev,
 static ssize_t ahci_show_port_cmd(struct device *dev,
 				  struct device_attribute *attr, char *buf);
 
-DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
-DEVICE_ATTR(ahci_host_cap2, S_IRUGO, ahci_show_host_cap2, NULL);
-DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
-DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
+static DEVICE_ATTR(ahci_host_caps, S_IRUGO, ahci_show_host_caps, NULL);
+static DEVICE_ATTR(ahci_host_cap2, S_IRUGO, ahci_show_host_cap2, NULL);
+static DEVICE_ATTR(ahci_host_version, S_IRUGO, ahci_show_host_version, NULL);
+static DEVICE_ATTR(ahci_port_cmd, S_IRUGO, ahci_show_port_cmd, NULL);
 
 static struct device_attribute *ahci_shost_attrs[] = {
 	&dev_attr_link_power_management_policy,
@@ -390,7 +409,7 @@ static struct scsi_host_template ahci_sht = {
 static struct ata_port_operations ahci_ops = {
 	.inherits		= &sata_pmp_port_ops,
 
-	.qc_defer		= sata_pmp_qc_defer_cmd_switch,
+	.qc_defer		= ahci_pmp_qc_defer,
 	.qc_prep		= ahci_qc_prep,
 	.qc_issue		= ahci_qc_issue,
 	.qc_fill_rtf		= ahci_qc_fill_rtf,
@@ -570,6 +589,12 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
 	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c02), board_ahci }, /* CPT AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c03), board_ahci }, /* CPT AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1c04), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
+	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
@@ -2045,6 +2070,17 @@ static unsigned int ahci_fill_sg(struct ata_queued_cmd *qc, void *cmd_tbl)
 	return si;
 }
 
+static int ahci_pmp_qc_defer(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_port_priv *pp = ap->private_data;
+
+	if (!sata_pmp_attached(ap) || pp->fbs_enabled)
+		return ata_std_qc_defer(qc);
+	else
+		return sata_pmp_qc_defer_cmd_switch(qc);
+}
+
 static void ahci_qc_prep(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
@@ -2083,6 +2119,31 @@ static void ahci_qc_prep(struct ata_queued_cmd *qc)
 	ahci_fill_cmd_slot(pp, qc->tag, opts);
 }
 
+static void ahci_fbs_dec_intr(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs = readl(port_mmio + PORT_FBS);
+	int retries = 3;
+
+	DPRINTK("ENTER\n");
+	BUG_ON(!pp->fbs_enabled);
+
+	/* time to wait for DEC is not specified by AHCI spec,
+	 * add a retry loop for safety.
+	 */
+	writel(fbs | PORT_FBS_DEC, port_mmio + PORT_FBS);
+	fbs = readl(port_mmio + PORT_FBS);
+	while ((fbs & PORT_FBS_DEC) && retries--) {
+		udelay(1);
+		fbs = readl(port_mmio + PORT_FBS);
+	}
+
+	if (fbs & PORT_FBS_DEC)
+		dev_printk(KERN_ERR, ap->host->dev,
+			   "failed to clear device error\n");
+}
+
 static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -2091,12 +2152,26 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	struct ata_link *link = NULL;
 	struct ata_queued_cmd *active_qc;
 	struct ata_eh_info *active_ehi;
+	bool fbs_need_dec = false;
 	u32 serror;
 
-	/* determine active link */
-	ata_for_each_link(link, ap, EDGE)
-		if (ata_link_active(link))
-			break;
+	/* determine active link with error */
+	if (pp->fbs_enabled) {
+		void __iomem *port_mmio = ahci_port_base(ap);
+		u32 fbs = readl(port_mmio + PORT_FBS);
+		int pmp = fbs >> PORT_FBS_DWE_OFFSET;
+
+		if ((fbs & PORT_FBS_SDE) && (pmp < ap->nr_pmp_links) &&
+		    ata_link_online(&ap->pmp_link[pmp])) {
+			link = &ap->pmp_link[pmp];
+			fbs_need_dec = true;
+		}
+
+	} else
+		ata_for_each_link(link, ap, EDGE)
+			if (ata_link_active(link))
+				break;
+
 	if (!link)
 		link = &ap->link;
 
@@ -2153,8 +2228,13 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 	}
 
 	if (irq_stat & PORT_IRQ_IF_ERR) {
-		host_ehi->err_mask |= AC_ERR_ATA_BUS;
-		host_ehi->action |= ATA_EH_RESET;
+		if (fbs_need_dec)
+			active_ehi->err_mask |= AC_ERR_DEV;
+		else {
+			host_ehi->err_mask |= AC_ERR_ATA_BUS;
+			host_ehi->action |= ATA_EH_RESET;
+		}
+
 		ata_ehi_push_desc(host_ehi, "interface fatal error");
 	}
 
@@ -2169,7 +2249,10 @@ static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 
 	if (irq_stat & PORT_IRQ_FREEZE)
 		ata_port_freeze(ap);
-	else
+	else if (fbs_need_dec) {
+		ata_link_abort(link);
+		ahci_fbs_dec_intr(ap);
+	} else
 		ata_port_abort(ap);
 }
 
@@ -2222,12 +2305,19 @@ static void ahci_port_intr(struct ata_port *ap)
 			/* If the 'N' bit in word 0 of the FIS is set,
 			 * we just received asynchronous notification.
 			 * Tell libata about it.
+			 *
+			 * Lack of SNotification should not appear in
+			 * ahci 1.2, so the workaround is unnecessary
+			 * when FBS is enabled.
 			 */
-			const __le32 *f = pp->rx_fis + RX_FIS_SDB;
-			u32 f0 = le32_to_cpu(f[0]);
-
-			if (f0 & (1 << 15))
-				sata_async_notification(ap);
+			if (pp->fbs_enabled)
+				WARN_ON_ONCE(1);
+			else {
+				const __le32 *f = pp->rx_fis + RX_FIS_SDB;
+				u32 f0 = le32_to_cpu(f[0]);
+				if (f0 & (1 << 15))
+					sata_async_notification(ap);
+			}
 		}
 	}
 
@@ -2321,6 +2411,15 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 
 	if (qc->tf.protocol == ATA_PROT_NCQ)
 		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
+
+	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
+		u32 fbs = readl(port_mmio + PORT_FBS);
+		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
+		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
+		writel(fbs, port_mmio + PORT_FBS);
+		pp->fbs_last_dev = qc->dev->link->pmp;
+	}
+
 	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
 
 	ahci_sw_activity(qc->dev->link);
@@ -2333,6 +2432,9 @@ static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 	struct ahci_port_priv *pp = qc->ap->private_data;
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
 
+	if (pp->fbs_enabled)
+		d2h_fis += qc->dev->link->pmp * AHCI_RX_FIS_SZ;
+
 	ata_tf_from_fis(d2h_fis, &qc->result_tf);
 	return true;
 }
@@ -2381,6 +2483,71 @@ static void ahci_post_internal_cmd(struct ata_queued_cmd *qc)
 		ahci_kick_engine(ap);
 }
 
+static void ahci_enable_fbs(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs;
+	int rc;
+
+	if (!pp->fbs_supported)
+		return;
+
+	fbs = readl(port_mmio + PORT_FBS);
+	if (fbs & PORT_FBS_EN) {
+		pp->fbs_enabled = true;
+		pp->fbs_last_dev = -1; /* initialization */
+		return;
+	}
+
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		return;
+
+	writel(fbs | PORT_FBS_EN, port_mmio + PORT_FBS);
+	fbs = readl(port_mmio + PORT_FBS);
+	if (fbs & PORT_FBS_EN) {
+		dev_printk(KERN_INFO, ap->host->dev, "FBS is enabled.\n");
+		pp->fbs_enabled = true;
+		pp->fbs_last_dev = -1; /* initialization */
+	} else
+		dev_printk(KERN_ERR, ap->host->dev, "Failed to enable FBS\n");
+
+	ahci_start_engine(ap);
+}
+
+static void ahci_disable_fbs(struct ata_port *ap)
+{
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs;
+	int rc;
+
+	if (!pp->fbs_supported)
+		return;
+
+	fbs = readl(port_mmio + PORT_FBS);
+	if ((fbs & PORT_FBS_EN) == 0) {
+		pp->fbs_enabled = false;
+		return;
+	}
+
+	rc = ahci_stop_engine(ap);
+	if (rc)
+		return;
+
+	writel(fbs & ~PORT_FBS_EN, port_mmio + PORT_FBS);
+	fbs = readl(port_mmio + PORT_FBS);
+	if (fbs & PORT_FBS_EN)
+		dev_printk(KERN_ERR, ap->host->dev, "Failed to disable FBS\n");
+	else {
+		dev_printk(KERN_INFO, ap->host->dev, "FBS is disabled.\n");
+		pp->fbs_enabled = false;
+	}
+
+	ahci_start_engine(ap);
+}
+
 static void ahci_pmp_attach(struct ata_port *ap)
 {
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -2391,6 +2558,8 @@ static void ahci_pmp_attach(struct ata_port *ap)
 	cmd |= PORT_CMD_PMP;
 	writel(cmd, port_mmio + PORT_CMD);
 
+	ahci_enable_fbs(ap);
+
 	pp->intr_mask |= PORT_IRQ_BAD_PMP;
 	writel(pp->intr_mask, port_mmio + PORT_IRQ_MASK);
 }
@@ -2401,6 +2570,8 @@ static void ahci_pmp_detach(struct ata_port *ap)
 	struct ahci_port_priv *pp = ap->private_data;
 	u32 cmd;
 
+	ahci_disable_fbs(ap);
+
 	cmd = readl(port_mmio + PORT_CMD);
 	cmd &= ~PORT_CMD_PMP;
 	writel(cmd, port_mmio + PORT_CMD);
@@ -2492,20 +2663,40 @@ static int ahci_pci_device_resume(struct pci_dev *pdev)
 
 static int ahci_port_start(struct ata_port *ap)
 {
+	struct ahci_host_priv *hpriv = ap->host->private_data;
 	struct device *dev = ap->host->dev;
 	struct ahci_port_priv *pp;
 	void *mem;
 	dma_addr_t mem_dma;
+	size_t dma_sz, rx_fis_sz;
 
 	pp = devm_kzalloc(dev, sizeof(*pp), GFP_KERNEL);
 	if (!pp)
 		return -ENOMEM;
 
-	mem = dmam_alloc_coherent(dev, AHCI_PORT_PRIV_DMA_SZ, &mem_dma,
-				  GFP_KERNEL);
+	/* check FBS capability */
+	if ((hpriv->cap & HOST_CAP_FBS) && sata_pmp_supported(ap)) {
+		void __iomem *port_mmio = ahci_port_base(ap);
+		u32 cmd = readl(port_mmio + PORT_CMD);
+		if (cmd & PORT_CMD_FBSCP)
+			pp->fbs_supported = true;
+		else
+			dev_printk(KERN_WARNING, dev,
+				   "The port is not capable of FBS\n");
+	}
+
+	if (pp->fbs_supported) {
+		dma_sz = AHCI_PORT_PRIV_FBS_DMA_SZ;
+		rx_fis_sz = AHCI_RX_FIS_SZ * 16;
+	} else {
+		dma_sz = AHCI_PORT_PRIV_DMA_SZ;
+		rx_fis_sz = AHCI_RX_FIS_SZ;
+	}
+
+	mem = dmam_alloc_coherent(dev, dma_sz, &mem_dma, GFP_KERNEL);
 	if (!mem)
 		return -ENOMEM;
-	memset(mem, 0, AHCI_PORT_PRIV_DMA_SZ);
+	memset(mem, 0, dma_sz);
 
 	/*
 	 * First item in chunk of DMA memory: 32-slot command table,
@@ -2523,8 +2714,8 @@ static int ahci_port_start(struct ata_port *ap)
 	pp->rx_fis = mem;
 	pp->rx_fis_dma = mem_dma;
 
-	mem += AHCI_RX_FIS_SZ;
-	mem_dma += AHCI_RX_FIS_SZ;
+	mem += rx_fis_sz;
+	mem_dma += rx_fis_sz;
 
 	/*
 	 * Third item: data area for storing a single command
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 12e26c3..33fb614 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -155,7 +155,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 			return rc;
 		pcim_pin_device(dev);
 	}
-	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &generic_sht, NULL, 0);
 }
 
 static struct pci_device_id ata_generic[] = {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6f3f225..c338066 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -173,6 +173,7 @@ static int piix_sidpr_scr_read(struct ata_link *link,
 			       unsigned int reg, u32 *val);
 static int piix_sidpr_scr_write(struct ata_link *link,
 				unsigned int reg, u32 val);
+static bool piix_irq_check(struct ata_port *ap);
 #ifdef CONFIG_PM
 static int piix_pci_device_suspend(struct pci_dev *pdev, pm_message_t mesg);
 static int piix_pci_device_resume(struct pci_dev *pdev);
@@ -291,6 +292,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (PCH) */
 	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (CPT) */
+	{ 0x8086, 0x1c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
@@ -309,8 +318,13 @@ static struct scsi_host_template piix_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
-static struct ata_port_operations piix_pata_ops = {
+static struct ata_port_operations piix_sata_ops = {
 	.inherits		= &ata_bmdma32_port_ops,
+	.sff_irq_check		= piix_irq_check,
+};
+
+static struct ata_port_operations piix_pata_ops = {
+	.inherits		= &piix_sata_ops,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= piix_set_piomode,
 	.set_dmamode		= piix_set_dmamode,
@@ -328,10 +342,6 @@ static struct ata_port_operations ich_pata_ops = {
 	.set_dmamode		= ich_set_dmamode,
 };
 
-static struct ata_port_operations piix_sata_ops = {
-	.inherits		= &ata_bmdma32_port_ops,
-};
-
 static struct ata_port_operations piix_sidpr_sata_ops = {
 	.inherits		= &piix_sata_ops,
 	.hardreset		= sata_std_hardreset,
@@ -962,6 +972,14 @@ static int piix_sidpr_scr_write(struct ata_link *link,
 	return 0;
 }
 
+static bool piix_irq_check(struct ata_port *ap)
+{
+	if (unlikely(!ap->ioaddr.bmdma_addr))
+		return false;
+
+	return ap->ops->bmdma_status(ap) & ATA_DMA_INTR;
+}
+
 #ifdef CONFIG_PM
 static int piix_broken_suspend(void)
 {
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 6728328..9c77b0d 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3211,6 +3211,7 @@ const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)
 int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 		       struct ata_timing *t, int T, int UT)
 {
+	const u16 *id = adev->id;
 	const struct ata_timing *s;
 	struct ata_timing p;
 
@@ -3228,14 +3229,18 @@ int ata_timing_compute(struct ata_device *adev, unsigned short speed,
 	 * PIO/MW_DMA cycle timing.
 	 */
 
-	if (adev->id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
+	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
+
 		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
-			if (speed <= XFER_PIO_2) p.cycle = p.cyc8b = adev->id[ATA_ID_EIDE_PIO];
-					    else p.cycle = p.cyc8b = adev->id[ATA_ID_EIDE_PIO_IORDY];
-		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2) {
-			p.cycle = adev->id[ATA_ID_EIDE_DMA_MIN];
-		}
+			if (speed <= XFER_PIO_2)
+				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
+			else if ((speed <= XFER_PIO_4) ||
+				 (speed == XFER_PIO_5 && !ata_id_is_cfa(id)))
+				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO_IORDY];
+		} else if (speed >= XFER_MW_DMA_0 && speed <= XFER_MW_DMA_2)
+			p.cycle = id[ATA_ID_EIDE_DMA_MIN];
+
 		ata_timing_merge(&p, t, t, ATA_TIMING_CYCLE | ATA_TIMING_CYC8B);
 	}
 
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 730ef3c..02441fd 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1763,24 +1763,50 @@ irqreturn_t ata_sff_interrupt(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
 	unsigned int i;
-	unsigned int handled = 0;
+	unsigned int handled = 0, polling = 0;
 	unsigned long flags;
 
 	/* TODO: make _irqsave conditional on x86 PCI IDE legacy mode */
 	spin_lock_irqsave(&host->lock, flags);
 
 	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap;
+		struct ata_port *ap = host->ports[i];
+		struct ata_queued_cmd *qc;
 
-		ap = host->ports[i];
-		if (ap &&
-		    !(ap->flags & ATA_FLAG_DISABLED)) {
-			struct ata_queued_cmd *qc;
+		if (unlikely(ap->flags & ATA_FLAG_DISABLED))
+			continue;
 
-			qc = ata_qc_from_tag(ap, ap->link.active_tag);
-			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
-			    (qc->flags & ATA_QCFLAG_ACTIVE))
+		qc = ata_qc_from_tag(ap, ap->link.active_tag);
+		if (qc) {
+			if (!(qc->tf.flags & ATA_TFLAG_POLLING))
 				handled |= ata_sff_host_intr(ap, qc);
+			else
+				polling |= 1 << i;
+		}
+	}
+
+	/*
+	 * If no port was expecting IRQ but the controller is actually
+	 * asserting IRQ line, nobody cared will ensue.  Check IRQ
+	 * pending status if available and clear spurious IRQ.
+	 */
+	if (!handled) {
+		for (i = 0; i < host->n_ports; i++) {
+			struct ata_port *ap = host->ports[i];
+
+			if (polling & (1 << i))
+				continue;
+
+			if (!ap->ops->sff_irq_check ||
+			    !ap->ops->sff_irq_check(ap))
+				continue;
+
+			if (printk_ratelimit())
+				ata_port_printk(ap, KERN_INFO,
+						"clearing spurious IRQ\n");
+
+			ap->ops->sff_check_status(ap);
+			ap->ops->sff_irq_clear(ap);
 		}
 	}
 
@@ -3011,6 +3037,7 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
  *	@ppi: array of port_info, must be enough for two ports
  *	@sht: scsi_host_template to use when registering the host
  *	@host_priv: host private_data
+ *	@hflag: host flags
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -3031,8 +3058,8 @@ EXPORT_SYMBOL_GPL(ata_pci_sff_activate_host);
  *	Zero on success, negative on errno-based value on error.
  */
 int ata_pci_sff_init_one(struct pci_dev *pdev,
-			 const struct ata_port_info * const *ppi,
-			 struct scsi_host_template *sht, void *host_priv)
+		 const struct ata_port_info * const *ppi,
+		 struct scsi_host_template *sht, void *host_priv, int hflag)
 {
 	struct device *dev = &pdev->dev;
 	const struct ata_port_info *pi = NULL;
@@ -3067,6 +3094,7 @@ int ata_pci_sff_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto out;
 	host->private_data = host_priv;
+	host->flags |= hflag;
 
 	pci_set_master(pdev);
 	rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index d8f35fe..294f302 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -259,7 +259,7 @@ static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 			return rc;
 		pcim_pin_device(pdev);
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &pacpi_sht, NULL, 0);
 }
 
 static const struct pci_device_id pacpi_pci_tbl[] = {
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 9434114..dc61b72 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -159,8 +159,7 @@ static void ali_fifo_control(struct ata_port *ap, struct ata_device *adev, int o
  *	ali_program_modes	-	load mode registers
  *	@ap: ALi channel to load
  *	@adev: Device the timing is for
- *	@cmd: Command timing
- *	@data: Data timing
+ *	@t: timing data
  *	@ultra: UDMA timing or zero for off
  *
  *	Loads the timing registers for cmd/data and disable UDMA if
@@ -202,8 +201,7 @@ static void ali_program_modes(struct ata_port *ap, struct ata_device *adev, stru
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	Program the ALi registers for PIO mode. FIXME: add timings for
- *	PIO5.
+ *	Program the ALi registers for PIO mode.
  */
 
 static void ali_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -237,7 +235,7 @@ static void ali_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	@ap: ATA interface
  *	@adev: ATA device
  *
- *	FIXME: MWDMA timings
+ *	Program the ALi registers for DMA mode.
  */
 
 static void ali_set_dmamode(struct ata_port *ap, struct ata_device *adev)
@@ -585,7 +583,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	        	ppi[0] = &info_20_udma;
 	}
 
-	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &ali_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 567f3f7..d95eca9 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -574,7 +574,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* And fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv);
+	return ata_pci_sff_init_one(pdev, ppi, &amd_sht, hpriv, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index d332cfd..4d066d6 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -421,7 +421,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	BUG_ON(ppi[0] == NULL);
 
-	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &artop_sht, NULL, 0);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
index 41c94b1..376dd38 100644
--- a/drivers/ata/pata_at91.c
+++ b/drivers/ata/pata_at91.c
@@ -153,8 +153,8 @@ static void pata_at91_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	/* Compute ATA timing and set it to SMC */
 	ret = ata_timing_compute(adev, adev->pio_mode, &timing, 1000, 0);
 	if (ret) {
-		dev_warn(ap->dev, "Failed to compute ATA timing %d, \
-				set PIO_0 timing\n", ret);
+		dev_warn(ap->dev, "Failed to compute ATA timing %d, "
+			 "set PIO_0 timing\n", ret);
 		set_smc_timing(ap->dev, info, &initial_timing);
 	} else {
 		set_smc_timing(ap->dev, info, &timing);
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index ae4454d..cbaf2ed 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -1,7 +1,7 @@
 /*
  * pata_atiixp.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
- *			  (C) 2009 Bartlomiej Zolnierkiewicz
+ *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * Based on
  *
@@ -46,6 +46,8 @@ static int atiixp_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA40;
 }
 
+static DEFINE_SPINLOCK(atiixp_lock);
+
 /**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
@@ -88,7 +90,10 @@ static void atiixp_set_pio_timing(struct ata_port *ap, struct ata_device *adev,
 
 static void atiixp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
+	unsigned long flags;
+	spin_lock_irqsave(&atiixp_lock, flags);
 	atiixp_set_pio_timing(ap, adev, adev->pio_mode - XFER_PIO_0);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 /**
@@ -108,6 +113,9 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 	int dma = adev->dma_mode;
 	int dn = 2 * ap->port_no + adev->devno;
 	int wanted_pio;
+	unsigned long flags;
+
+	spin_lock_irqsave(&atiixp_lock, flags);
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		u16 udma_mode_data;
@@ -145,6 +153,7 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 
 	if (adev->pio_mode != wanted_pio)
 		atiixp_set_pio_timing(ap, adev, wanted_pio);
+	spin_unlock_irqrestore(&atiixp_lock, flags);
 }
 
 /**
@@ -237,7 +246,8 @@ static int atiixp_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
 			ppi[i] = &ata_dummy_port_info;
 
-	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL,
+						ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id atiixp[] = {
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 5acf9fa..6cd5d5d 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -223,7 +223,7 @@ static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	cmd640_hardware_init(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cmd640_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 0efb1f5..4c81a71 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -2,6 +2,7 @@
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
+ *			  (C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
@@ -39,11 +40,7 @@
 
 enum {
 	CFR 		= 0x50,
-		CFR_INTR_CH0  = 0x02,
-	CNTRL 		= 0x51,
-		CNTRL_DIS_RA0 = 0x40,
-		CNTRL_DIS_RA1 = 0x80,
-		CNTRL_ENA_2ND = 0x08,
+		CFR_INTR_CH0  = 0x04,
 	CMDTIM 		= 0x52,
 	ARTTIM0 	= 0x53,
 	DRWTIM0 	= 0x54,
@@ -53,9 +50,6 @@ enum {
 		ARTTIM23_DIS_RA2  = 0x04,
 		ARTTIM23_DIS_RA3  = 0x08,
 		ARTTIM23_INTR_CH1 = 0x10,
-	ARTTIM2 	= 0x57,
-	ARTTIM3 	= 0x57,
-	DRWTIM23	= 0x58,
 	DRWTIM2 	= 0x58,
 	BRST 		= 0x59,
 	DRWTIM3 	= 0x5b,
@@ -63,14 +57,11 @@ enum {
 	MRDMODE		= 0x71,
 		MRDMODE_INTR_CH0 = 0x04,
 		MRDMODE_INTR_CH1 = 0x08,
-		MRDMODE_BLK_CH0  = 0x10,
-		MRDMODE_BLK_CH1	 = 0x20,
 	BMIDESR0	= 0x72,
 	UDIDETCR0	= 0x73,
 	DTPR0		= 0x74,
 	BMIDECR1	= 0x78,
 	BMIDECSR	= 0x79,
-	BMIDESR1	= 0x7A,
 	UDIDETCR1	= 0x7B,
 	DTPR1		= 0x7C
 };
@@ -130,8 +121,14 @@ static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 m
 
 		if (pair) {
 			struct ata_timing tp;
+
 			ata_timing_compute(pair, pair->pio_mode, &tp, T, 0);
 			ata_timing_merge(&t, &tp, &t, ATA_TIMING_SETUP);
+			if (pair->dma_mode) {
+				ata_timing_compute(pair, pair->dma_mode,
+						&tp, T, 0);
+				ata_timing_merge(&tp, &t, &t, ATA_TIMING_SETUP);
+			}
 		}
 	}
 
@@ -147,7 +144,9 @@ static void cmd64x_set_timing(struct ata_port *ap, struct ata_device *adev, u8 m
 	/* Now convert the clocks into values we can actually stuff into
 	   the chip */
 
-	if (t.recover > 1)
+	if (t.recover == 16)
+		t.recover = 0;
+	else if (t.recover > 1)
 		t.recover--;
 	else
 		t.recover = 15;
@@ -245,7 +244,7 @@ static void cmd648_bmdma_stop(struct ata_queued_cmd *qc)
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u8 dma_intr;
 	int dma_mask = ap->port_no ? ARTTIM23_INTR_CH1 : CFR_INTR_CH0;
-	int dma_reg = ap->port_no ? ARTTIM2 : CFR;
+	int dma_reg = ap->port_no ? ARTTIM23 : CFR;
 
 	ata_bmdma_stop(qc);
 
@@ -368,7 +367,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
 
-	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cmd64x_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index c974b05..738ad2e 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -324,7 +324,7 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cs5530_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 71cef9a..a02e645 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -100,7 +100,7 @@ static int cs5535_cable_detect(struct ata_port *ap)
 static void cs5535_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	static const u16 pio_timings[5] = {
-		0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131
+		0xF7F4, 0xF173, 0x8141, 0x5131, 0x1131
 	};
 	static const u16 pio_cmd_timings[5] = {
 		0xF7F4, 0x53F3, 0x13F1, 0x5131, 0x1131
@@ -198,7 +198,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
 	if (CS5535_BAD_PIO(timings))
 		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
-	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &cs5535_sht, NULL, 0);
 }
 
 static const struct pci_device_id cs5535[] = {
diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
index ffee397..914ae35 100644
--- a/drivers/ata/pata_cs5536.c
+++ b/drivers/ata/pata_cs5536.c
@@ -260,7 +260,7 @@ static int cs5536_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		return -ENODEV;
 	}
 
-	return ata_pci_sff_init_one(dev, ppi, &cs5536_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &cs5536_sht, NULL, 0);
 }
 
 static const struct pci_device_id cs5536[] = {
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 8fb040b..0fcc096 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -62,14 +62,16 @@ static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		return;
 	}
 
-	time_16 = clamp_val(t.recover, 0, 15) | (clamp_val(t.active, 0, 15) << 4);
-	time_8 = clamp_val(t.act8b, 0, 15) | (clamp_val(t.rec8b, 0, 15) << 4);
+	time_16 = clamp_val(t.recover - 1, 0, 15) |
+		  (clamp_val(t.active - 1, 0, 15) << 4);
+	time_8 = clamp_val(t.act8b - 1, 0, 15) |
+		 (clamp_val(t.rec8b - 1, 0, 15) << 4);
 
 	if (adev->devno == 0) {
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0x0F;	/* Mask bits */
-		addr |= clamp_val(t.setup, 0, 15);
+		addr |= clamp_val(t.setup - 1, 0, 15);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_MASTER_IOR, time_16);
@@ -79,7 +81,7 @@ static void cy82c693_set_piomode(struct ata_port *ap, struct ata_device *adev)
 		pci_read_config_dword(pdev, CY82_IDE_ADDRSETUP, &addr);
 
 		addr &= ~0xF0;	/* Mask bits */
-		addr |= (clamp_val(t.setup, 0, 15) << 4);
+		addr |= (clamp_val(t.setup - 1, 0, 15) << 4);
 
 		pci_write_config_dword(pdev, CY82_IDE_ADDRSETUP, addr);
 		pci_write_config_byte(pdev, CY82_IDE_SLAVE_IOR, time_16);
@@ -136,7 +138,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 	if (PCI_FUNC(pdev->devfn) != 1)
 		return -ENODEV;
 
-	return ata_pci_sff_init_one(pdev, ppi, &cy82c693_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &cy82c693_sht, NULL, 0);
 }
 
 static const struct pci_device_id cy82c693[] = {
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index b2e71e6..3bac0e0 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -2,7 +2,7 @@
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
  *	(C) 2005 Red Hat
- *	(C) 2009 Bartlomiej Zolnierkiewicz
+ *	(C) 2009-2010 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -68,6 +68,8 @@ static int efar_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
+static DEFINE_SPINLOCK(efar_lock);
+
 /**
  *	efar_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
@@ -84,7 +86,9 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
 	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
+	unsigned long flags;
 	u16 idetm_data;
+	u8 udma_enable;
 	int control = 0;
 
 	/*
@@ -107,6 +111,8 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE */
 
+	spin_lock_irqsave(&efar_lock, flags);
+
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
@@ -131,6 +137,11 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 
 	idetm_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, idetm_port, idetm_data);
+
+	pci_read_config_byte(dev, 0x48, &udma_enable);
+	udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
+	pci_write_config_byte(dev, 0x48, udma_enable);
+	spin_unlock_irqrestore(&efar_lock, flags);
 }
 
 /**
@@ -151,6 +162,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 	u16 master_data;
 	u8 speed		= adev->dma_mode;
 	int devid		= adev->devno + 2 * ap->port_no;
+	unsigned long flags;
 	u8 udma_enable;
 
 	static const	 /* ISP  RTC */
@@ -160,6 +172,8 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
+	spin_lock_irqsave(&efar_lock, flags);
+
 	pci_read_config_word(dev, master_port, &master_data);
 	pci_read_config_byte(dev, 0x48, &udma_enable);
 
@@ -217,6 +231,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		pci_write_config_word(dev, master_port, master_data);
 	}
 	pci_write_config_byte(dev, 0x48, udma_enable);
+	spin_unlock_irqrestore(&efar_lock, flags);
 }
 
 static struct scsi_host_template efar_sht = {
@@ -256,13 +271,14 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &efar_ops,
 	};
-	const struct ata_port_info *ppi[] = { &info, NULL };
+	const struct ata_port_info *ppi[] = { &info, &info };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL,
+					ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index 0bd48e8..af49bfb 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -11,9 +11,7 @@
  *
  *
  * TODO
- *	Maybe PLL mode
- *	Look into engine reset on timeout errors. Should not be
- *		required.
+ *	Look into engine reset on timeout errors. Should not be required.
  */
 
 
@@ -27,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt366"
-#define DRV_VERSION	"0.6.7"
+#define DRV_VERSION	"0.6.8"
 
 struct hpt_clock {
 	u8	xfer_mode;
@@ -207,17 +205,8 @@ static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 {
 	struct hpt_clock *clocks = ap->host->private_data;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
-	u32 addr2 = 0x51 + 4 * ap->port_no;
+	u32 addr = 0x40 + 4 * adev->devno;
 	u32 mask, reg;
-	u8 fast;
-
-	/* Fast interrupt prediction disable, hold off interrupt disable */
-	pci_read_config_byte(pdev, addr2, &fast);
-	if (fast & 0x80) {
-		fast &= ~0x80;
-		pci_write_config_byte(pdev, addr2, fast);
-	}
 
 	/* determine timing mask and find matching clock entry */
 	if (mode < XFER_MW_DMA_0)
@@ -240,9 +229,9 @@ static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 	 * on-chip PIO FIFO/buffer (and PIO MST mode as well) to avoid
 	 * problems handling I/O errors later.
 	 */
-	pci_read_config_dword(pdev, addr1, &reg);
+	pci_read_config_dword(pdev, addr, &reg);
 	reg = ((reg & ~mask) | (clocks->timing & mask)) & ~0xc0000000;
-	pci_write_config_dword(pdev, addr1, reg);
+	pci_write_config_dword(pdev, addr, reg);
 }
 
 /**
@@ -372,7 +361,7 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv);
+	return ata_pci_sff_init_one(dev, ppi, &hpt36x_sht, hpriv, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 4224cfc..8839307 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -24,7 +24,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt37x"
-#define DRV_VERSION	"0.6.14"
+#define DRV_VERSION	"0.6.15"
 
 struct hpt_clock {
 	u8	xfer_speed;
@@ -39,25 +39,24 @@ struct hpt_chip {
 
 /* key for bus clock timings
  * bit
- * 0:3    data_high_time. inactive time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 4:8    data_low_time. active time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 9:12   cmd_high_time. inactive time of DIOW_/DIOR_ during task file
+ * 0:3    data_high_time. Inactive time of DIOW_/DIOR_ for PIO and MW DMA.
+ *        cycles = value + 1
+ * 4:8    data_low_time. Active time of DIOW_/DIOR_ for PIO and MW DMA.
+ *        cycles = value + 1
+ * 9:12   cmd_high_time. Inactive time of DIOW_/DIOR_ during task file
  *        register access.
- * 13:17  cmd_low_time. active time of DIOW_/DIOR_ during task file
+ * 13:17  cmd_low_time. Active time of DIOW_/DIOR_ during task file
  *        register access.
- * 18:21  udma_cycle_time. clock freq and clock cycles for UDMA xfer.
- *        during task file register access.
- * 22:24  pre_high_time. time to initialize 1st cycle for PIO and MW DMA
- *        xfer.
- * 25:27  cmd_pre_high_time. time to initialize 1st PIO cycle for task
+ * 18:20  udma_cycle_time. Clock cycles for UDMA xfer.
+ * 21     CLK frequency for UDMA: 0=ATA clock, 1=dual ATA clock.
+ * 22:24  pre_high_time. Time to initialize 1st cycle for PIO and MW DMA xfer.
+ * 25:27  cmd_pre_high_time. Time to initialize 1st PIO cycle for task file
  *        register access.
- * 28     UDMA enable
- * 29     DMA enable
- * 30     PIO_MST enable. if set, the chip is in bus master mode during
- *        PIO.
- * 31     FIFO enable.
+ * 28     UDMA enable.
+ * 29     DMA  enable.
+ * 30     PIO_MST enable. If set, the chip is in bus master mode during
+ *        PIO xfer.
+ * 31     FIFO enable. Only for PIO.
  */
 
 static struct hpt_clock hpt37x_timings_33[] = {
@@ -384,20 +383,12 @@ static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	hpt370_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Perform PIO mode setup.
- */
-
-static void hpt370_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void hpt370_set_mode(struct ata_port *ap, struct ata_device *adev,
+			    u8 mode)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, timing, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -409,11 +400,31 @@ static void hpt370_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	fast |= 0x01;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	/* Determine timing mask and find matching mode entry */
+	if (mode < XFER_MW_DMA_0)
+		mask = 0xcfc3ffff;
+	else if (mode < XFER_UDMA_0)
+		mask = 0x31c001ff;
+	else
+		mask = 0x303c0000;
+
+	timing = hpt37x_find_mode(ap, mode);
+
 	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt37x_find_mode(ap, adev->pio_mode);
-	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
-	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	reg = (reg & ~mask) | (timing & mask);
+	pci_write_config_dword(pdev, addr1, reg);
+}
+/**
+ *	hpt370_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Perform PIO mode setup.
+ */
+
+static void hpt370_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	hpt370_set_mode(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -421,33 +432,12 @@ static void hpt370_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	@ap: ATA interface
  *	@adev: Device being configured
  *
- *	Set up the channel for MWDMA or UDMA modes. Much the same as with
- *	PIO, load the mode number and then set MWDMA or UDMA flag.
+ *	Set up the channel for MWDMA or UDMA modes.
  */
 
 static void hpt370_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 addr1, addr2;
-	u32 reg, mode, mask;
-	u8 fast;
-
-	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
-	addr2 = 0x51 + 4 * ap->port_no;
-
-	/* Fast interrupt prediction disable, hold off interrupt disable */
-	pci_read_config_byte(pdev, addr2, &fast);
-	fast &= ~0x02;
-	fast |= 0x01;
-	pci_write_config_byte(pdev, addr2, fast);
-
-	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
-
-	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt37x_find_mode(ap, adev->dma_mode);
-	mode &= mask;
-	reg &= ~mask;
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	hpt370_set_mode(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -461,24 +451,25 @@ static void hpt370_bmdma_stop(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u8 dma_stat = ioread8(ap->ioaddr.bmdma_addr + 2);
-	u8 dma_cmd;
 	void __iomem *bmdma = ap->ioaddr.bmdma_addr;
+	u8 dma_stat = ioread8(bmdma + ATA_DMA_STATUS);
+	u8 dma_cmd;
 
-	if (dma_stat & 0x01) {
+	if (dma_stat & ATA_DMA_ACTIVE) {
 		udelay(20);
-		dma_stat = ioread8(bmdma + 2);
+		dma_stat = ioread8(bmdma + ATA_DMA_STATUS);
 	}
-	if (dma_stat & 0x01) {
+	if (dma_stat & ATA_DMA_ACTIVE) {
 		/* Clear the engine */
 		pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 		udelay(10);
 		/* Stop DMA */
-		dma_cmd = ioread8(bmdma );
-		iowrite8(dma_cmd & 0xFE, bmdma);
+		dma_cmd = ioread8(bmdma + ATA_DMA_CMD);
+		iowrite8(dma_cmd & ~ATA_DMA_START, bmdma + ATA_DMA_CMD);
 		/* Clear Error */
-		dma_stat = ioread8(bmdma + 2);
-		iowrite8(dma_stat | 0x06 , bmdma + 2);
+		dma_stat = ioread8(bmdma + ATA_DMA_STATUS);
+		iowrite8(dma_stat | ATA_DMA_INTR | ATA_DMA_ERR,
+			 bmdma + ATA_DMA_STATUS);
 		/* Clear the engine */
 		pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 		udelay(10);
@@ -486,20 +477,12 @@ static void hpt370_bmdma_stop(struct ata_queued_cmd *qc)
 	ata_bmdma_stop(qc);
 }
 
-/**
- *	hpt372_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Perform PIO mode setup.
- */
-
-static void hpt372_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void hpt372_set_mode(struct ata_port *ap, struct ata_device *adev,
+			    u8 mode)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, timing, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -510,13 +493,32 @@ static void hpt372_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	fast &= ~0x07;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	/* Determine timing mask and find matching mode entry */
+	if (mode < XFER_MW_DMA_0)
+		mask = 0xcfc3ffff;
+	else if (mode < XFER_UDMA_0)
+		mask = 0x31c001ff;
+	else
+		mask = 0x303c0000;
+
+	timing = hpt37x_find_mode(ap, mode);
+
 	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt37x_find_mode(ap, adev->pio_mode);
+	reg = (reg & ~mask) | (timing & mask);
+	pci_write_config_dword(pdev, addr1, reg);
+}
+
+/**
+ *	hpt372_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Perform PIO mode setup.
+ */
 
-	printk("Find mode for %d reports %X\n", adev->pio_mode, mode);
-	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
-	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
-	pci_write_config_dword(pdev, addr1, reg | mode);
+static void hpt372_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	hpt372_set_mode(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -524,33 +526,12 @@ static void hpt372_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	@ap: ATA interface
  *	@adev: Device being configured
  *
- *	Set up the channel for MWDMA or UDMA modes. Much the same as with
- *	PIO, load the mode number and then set MWDMA or UDMA flag.
+ *	Set up the channel for MWDMA or UDMA modes.
  */
 
 static void hpt372_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 addr1, addr2;
-	u32 reg, mode, mask;
-	u8 fast;
-
-	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
-	addr2 = 0x51 + 4 * ap->port_no;
-
-	/* Fast interrupt prediction disable, hold off interrupt disable */
-	pci_read_config_byte(pdev, addr2, &fast);
-	fast &= ~0x07;
-	pci_write_config_byte(pdev, addr2, fast);
-
-	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
-
-	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt37x_find_mode(ap, adev->dma_mode);
-	printk("Find mode for DMA %d reports %X\n", adev->dma_mode, mode);
-	mode &= mask;
-	reg &= ~mask;
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	hpt372_set_mode(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -1006,7 +987,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt37x_sht, private_data);
+	return ata_pci_sff_init_one(dev, ppi, &hpt37x_sht, private_data, 0);
 }
 
 static const struct pci_device_id hpt37x[] = {
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index dd26bc7..01457b2 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.8"
+#define DRV_VERSION	"0.3.10"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -45,25 +45,24 @@ struct hpt_chip {
 
 /* key for bus clock timings
  * bit
- * 0:3    data_high_time. inactive time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 4:8    data_low_time. active time of DIOW_/DIOR_ for PIO and MW
- *        DMA. cycles = value + 1
- * 9:12   cmd_high_time. inactive time of DIOW_/DIOR_ during task file
+ * 0:3    data_high_time. Inactive time of DIOW_/DIOR_ for PIO and MW DMA.
+ *        cycles = value + 1
+ * 4:8    data_low_time. Active time of DIOW_/DIOR_ for PIO and MW DMA.
+ *        cycles = value + 1
+ * 9:12   cmd_high_time. Inactive time of DIOW_/DIOR_ during task file
  *        register access.
- * 13:17  cmd_low_time. active time of DIOW_/DIOR_ during task file
+ * 13:17  cmd_low_time. Active time of DIOW_/DIOR_ during task file
  *        register access.
- * 18:21  udma_cycle_time. clock freq and clock cycles for UDMA xfer.
- *        during task file register access.
- * 22:24  pre_high_time. time to initialize 1st cycle for PIO and MW DMA
- *        xfer.
- * 25:27  cmd_pre_high_time. time to initialize 1st PIO cycle for task
+ * 18:20  udma_cycle_time. Clock cycles for UDMA xfer.
+ * 21     CLK frequency for UDMA: 0=ATA clock, 1=dual ATA clock.
+ * 22:24  pre_high_time. Time to initialize 1st cycle for PIO and MW DMA xfer.
+ * 25:27  cmd_pre_high_time. Time to initialize 1st PIO cycle for task file
  *        register access.
- * 28     UDMA enable
- * 29     DMA enable
- * 30     PIO_MST enable. if set, the chip is in bus master mode during
- *        PIO.
- * 31     FIFO enable.
+ * 28     UDMA enable.
+ * 29     DMA  enable.
+ * 30     PIO_MST enable. If set, the chip is in bus master mode during
+ *        PIO xfer.
+ * 31     FIFO enable. Only for PIO.
  */
 
 /* 66MHz DPLL clocks */
@@ -161,20 +160,12 @@ static int hpt3x2n_pre_reset(struct ata_link *link, unsigned long deadline)
 	return ata_sff_prereset(link, deadline);
 }
 
-/**
- *	hpt3x2n_set_piomode		-	PIO setup
- *	@ap: ATA interface
- *	@adev: device on the interface
- *
- *	Perform PIO mode setup.
- */
-
-static void hpt3x2n_set_piomode(struct ata_port *ap, struct ata_device *adev)
+static void hpt3x2n_set_mode(struct ata_port *ap, struct ata_device *adev,
+			     u8 mode)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	u32 addr1, addr2;
-	u32 reg;
-	u32 mode;
+	u32 reg, timing, mask;
 	u8 fast;
 
 	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
@@ -185,11 +176,32 @@ static void hpt3x2n_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	fast &= ~0x07;
 	pci_write_config_byte(pdev, addr2, fast);
 
+	/* Determine timing mask and find matching mode entry */
+	if (mode < XFER_MW_DMA_0)
+		mask = 0xcfc3ffff;
+	else if (mode < XFER_UDMA_0)
+		mask = 0x31c001ff;
+	else
+		mask = 0x303c0000;
+
+	timing = hpt3x2n_find_mode(ap, mode);
+
 	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt3x2n_find_mode(ap, adev->pio_mode);
-	mode &= 0xCFC3FFFF;	/* Leave DMA bits alone */
-	reg &= ~0xCFC3FFFF;	/* Strip timing bits */
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	reg = (reg & ~mask) | (timing & mask);
+	pci_write_config_dword(pdev, addr1, reg);
+}
+
+/**
+ *	hpt3x2n_set_piomode		-	PIO setup
+ *	@ap: ATA interface
+ *	@adev: device on the interface
+ *
+ *	Perform PIO mode setup.
+ */
+
+static void hpt3x2n_set_piomode(struct ata_port *ap, struct ata_device *adev)
+{
+	hpt3x2n_set_mode(ap, adev, adev->pio_mode);
 }
 
 /**
@@ -197,32 +209,12 @@ static void hpt3x2n_set_piomode(struct ata_port *ap, struct ata_device *adev)
  *	@ap: ATA interface
  *	@adev: Device being configured
  *
- *	Set up the channel for MWDMA or UDMA modes. Much the same as with
- *	PIO, load the mode number and then set MWDMA or UDMA flag.
+ *	Set up the channel for MWDMA or UDMA modes.
  */
 
 static void hpt3x2n_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	u32 addr1, addr2;
-	u32 reg, mode, mask;
-	u8 fast;
-
-	addr1 = 0x40 + 4 * (adev->devno + 2 * ap->port_no);
-	addr2 = 0x51 + 4 * ap->port_no;
-
-	/* Fast interrupt prediction disable, hold off interrupt disable */
-	pci_read_config_byte(pdev, addr2, &fast);
-	fast &= ~0x07;
-	pci_write_config_byte(pdev, addr2, fast);
-
-	mask = adev->dma_mode < XFER_UDMA_0 ? 0x31C001FF : 0x303C0000;
-
-	pci_read_config_dword(pdev, addr1, &reg);
-	mode = hpt3x2n_find_mode(ap, adev->dma_mode);
-	mode &= mask;
-	reg &= ~mask;
-	pci_write_config_dword(pdev, addr1, reg | mode);
+	hpt3x2n_set_mode(ap, adev, adev->dma_mode);
 }
 
 /**
@@ -544,19 +536,19 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	       pci_mhz);
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
-	if (pci_mhz > 60) {
+	if (pci_mhz > 60)
 		hpriv = (void *)(PCI66 | USE_DPLL);
-		/*
-		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
-		 * the MISC. register to stretch the UltraDMA Tss timing.
-		 * NOTE: This register is only writeable via I/O space.
-		 */
-		if (dev->device == PCI_DEVICE_ID_TTI_HPT371)
-			outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
-	}
+
+	/*
+	 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
+	 * the MISC. register to stretch the UltraDMA Tss timing.
+	 * NOTE: This register is only writeable via I/O space.
+	 */
+	if (dev->device == PCI_DEVICE_ID_TTI_HPT371)
+		outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
 
 	/* Now kick off ATA set up */
-	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv);
+	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv, 0);
 }
 
 static const struct pci_device_id hpt3x2n[] = {
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 8f3325a..f971f0d 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -273,7 +273,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &it8213_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &it8213_sht, NULL, 0);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index edc5c1f..9bde1cb 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -932,7 +932,7 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		else
 			ppi[0] = &info_smart;
 	}
-	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &it821x_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 3a1474a..565e01e 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -144,7 +144,7 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(pdev, ppi, &jmicron_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &jmicron_sht, NULL, 0);
 }
 
 static const struct pci_device_id jmicron_pci_tbl[] = {
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 950da39..e8ca02e 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -147,13 +147,13 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 	if (pdev->device == 0x6101)
 		ppi[1] = &ata_dummy_port_info;
 
-#if defined(CONFIG_AHCI) || defined(CONFIG_AHCI_MODULE)
+#if defined(CONFIG_SATA_AHCI) || defined(CONFIG_SATA_AHCI_MODULE)
 	if (!marvell_pata_active(pdev)) {
 		printk(KERN_INFO DRV_NAME ": PATA port not active, deferring to AHCI driver.\n");
 		return -ENODEV;
 	}
 #endif
-	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &marvell_sht, NULL, 0);
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index f0d52f7..94f979a 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -82,7 +82,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	ata_pci_bmdma_clear_simplex(pdev);
 
 	/* And let the library code do the work */
-	return ata_pci_sff_init_one(pdev, port_info, &netcell_sht, NULL);
+	return ata_pci_sff_init_one(pdev, port_info, &netcell_sht, NULL, 0);
 }
 
 static const struct pci_device_id netcell_pci_tbl[] = {
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index ca53fac..2110863 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -148,7 +148,7 @@ static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &ns87410_port_ops
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
-	return ata_pci_sff_init_one(dev, ppi, &ns87410_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &ns87410_sht, NULL, 0);
 }
 
 static const struct pci_device_id ns87410[] = {
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 061aa1c..830431f 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -380,7 +380,7 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 
 	ns87415_fixup(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL, 0);
 }
 
 static const struct pci_device_id ns87415_pci_tbl[] = {
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 9a8687d..5f6aba7 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -248,7 +248,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL, 0);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 99eddda..00c5a02 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -172,7 +172,7 @@ static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(dev, ppi, &opti_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &opti_sht, NULL, 0);
 }
 
 static const struct pci_device_id opti[] = {
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 86885a4..76b7d12 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -429,7 +429,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (optiplus_with_udma(dev))
 		ppi[0] = &info_82c700_udma;
 
-	return ata_pci_sff_init_one(dev, ppi, &optidma_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &optidma_sht, NULL, 0);
 }
 
 static const struct pci_device_id optidma[] = {
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 1b392c9..3610353 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -136,7 +136,7 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
  *
  */
  
-void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
+static void pcmcia_8bit_drain_fifo(struct ata_queued_cmd *qc)
 {
 	int count;
 	struct ata_port *ap;
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index 2f3c9be..9ac0897 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,7 +2,7 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
- *			  (C) 2007,2009 Bartlomiej Zolnierkiewicz
+ *			  (C) 2007,2009,2010 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
@@ -35,6 +35,15 @@ static int pdc2026x_cable_detect(struct ata_port *ap)
 	return ATA_CBL_PATA80;
 }
 
+static void pdc202xx_exec_command(struct ata_port *ap,
+				  const struct ata_taskfile *tf)
+{
+	DPRINTK("ata%u: cmd 0x%X\n", ap->print_id, tf->command);
+
+	iowrite8(tf->command, ap->ioaddr.command_addr);
+	ndelay(400);
+}
+
 /**
  *	pdc202xx_configure_piomode	-	set chip PIO timing
  *	@ap: ATA interface
@@ -271,6 +280,8 @@ static struct ata_port_operations pdc2024x_port_ops = {
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= pdc202xx_set_piomode,
 	.set_dmamode		= pdc202xx_set_dmamode,
+
+	.sff_exec_command	= pdc202xx_exec_command,
 };
 
 static struct ata_port_operations pdc2026x_port_ops = {
@@ -284,6 +295,8 @@ static struct ata_port_operations pdc2026x_port_ops = {
 	.dev_config		= pdc2026x_dev_config,
 
 	.port_start		= pdc2026x_port_start,
+
+	.sff_exec_command	= pdc202xx_exec_command,
 };
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
@@ -324,7 +337,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 				return -ENODEV;
 		}
 	}
-	return ata_pci_sff_init_one(dev, ppi, &pdc202xx_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &pdc202xx_sht, NULL, 0);
 }
 
 static const struct pci_device_id pdc202xx[] = {
diff --git a/drivers/ata/pata_piccolo.c b/drivers/ata/pata_piccolo.c
index bfe0180..9816154 100644
--- a/drivers/ata/pata_piccolo.c
+++ b/drivers/ata/pata_piccolo.c
@@ -95,7 +95,7 @@ static int ata_tosh_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	};
 	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 	/* Just one port for the moment */
-	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &tosh_sht, NULL, 0);
 }
 
 static struct pci_device_id ata_tosh[] = {
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 4fd25e7..fc96022 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -227,7 +227,7 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &radisys_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &radisys_sht, NULL, 0);
 }
 
 static const struct pci_device_id radisys_pci_tbl[] = {
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 2932998..4a454a8 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -95,7 +95,7 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	printk_once(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
 	if (rz1000_fifo_disable(pdev) == 0)
-		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL);
+		return ata_pci_sff_init_one(pdev, ppi, &rz1000_sht, NULL, 0);
 
 	printk(KERN_ERR DRV_NAME ": failed to disable read-ahead on chipset..\n");
 	/* Not safe to use so skip */
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 3bbed83..dfecc6f 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -237,7 +237,7 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &sc1200_sht, NULL, 0);
 }
 
 static const struct pci_device_id sc1200[] = {
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index beaed12..9524d54 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -1,6 +1,7 @@
 /*
  * pata_serverworks.c 	- Serverworks PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2010 Bartlomiej Zolnierkiewicz
  *
  * based upon
  *
@@ -253,7 +254,7 @@ static void serverworks_set_piomode(struct ata_port *ap, struct ata_device *adev
 	if (serverworks_is_csb(pdev)) {
 		pci_read_config_word(pdev, 0x4A, &csb5_pio);
 		csb5_pio &= ~(0x0F << devbits);
-		pci_write_config_byte(pdev, 0x4A, csb5_pio | (pio << devbits));
+		pci_write_config_word(pdev, 0x4A, csb5_pio | (pio << devbits));
 	}
 }
 
@@ -327,7 +328,7 @@ static int serverworks_fixup_osb4(struct pci_dev *pdev)
 		pci_dev_put(isa_dev);
 		return 0;
 	}
-	printk(KERN_WARNING "ata_serverworks: Unable to find bridge.\n");
+	printk(KERN_WARNING DRV_NAME ": Unable to find bridge.\n");
 	return -ENODEV;
 }
 
@@ -459,7 +460,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		ata_pci_bmdma_clear_simplex(pdev);
 
-	return ata_pci_sff_init_one(pdev, ppi, &serverworks_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &serverworks_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index a2ace48..c6c589c 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -356,7 +356,7 @@ static int __devinit sil680_init_one(struct pci_dev *pdev,
 				 IRQF_SHARED, &sil680_sht);
 
 use_ioports:
-	return ata_pci_sff_init_one(pdev, ppi, &sil680_sht, NULL);
+	return ata_pci_sff_init_one(pdev, ppi, &sil680_sht, NULL, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index 5c30d56..b670803 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -826,7 +826,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	sis_fixup(pdev, chipset);
 
-	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset);
+	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset, 0);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 29f733c..733b042 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -316,7 +316,7 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &sl82c105_sht, NULL, 0);
 }
 
 static const struct pci_device_id sl82c105[] = {
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index f1f13ff..48f5060 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -201,7 +201,7 @@ static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(dev, ppi, &triflex_sht, NULL);
+	return ata_pci_sff_init_one(dev, ppi, &triflex_sht, NULL, 0);
 }
 
 static const struct pci_device_id triflex[] = {
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 0d97890..3059ec0 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -22,6 +22,7 @@
  *	VIA VT8233c	-	UDMA100
  *	VIA VT8235	-	UDMA133
  *	VIA VT8237	-	UDMA133
+ *	VIA VT8237A	-	UDMA133
  *	VIA VT8237S	-	UDMA133
  *	VIA VT8251	-	UDMA133
  *
@@ -64,26 +65,15 @@
 #define DRV_NAME "pata_via"
 #define DRV_VERSION "0.3.4"
 
-/*
- *	The following comes directly from Vojtech Pavlik's ide/pci/via82cxxx
- *	driver.
- */
-
 enum {
-	VIA_UDMA	= 0x007,
-	VIA_UDMA_NONE	= 0x000,
-	VIA_UDMA_33	= 0x001,
-	VIA_UDMA_66	= 0x002,
-	VIA_UDMA_100	= 0x003,
-	VIA_UDMA_133	= 0x004,
-	VIA_BAD_PREQ	= 0x010, /* Crashes if PREQ# till DDACK# set */
-	VIA_BAD_CLK66	= 0x020, /* 66 MHz clock doesn't work correctly */
-	VIA_SET_FIFO	= 0x040, /* Needs to have FIFO split set */
-	VIA_NO_UNMASK	= 0x080, /* Doesn't work with IRQ unmasking on */
-	VIA_BAD_ID	= 0x100, /* Has wrong vendor ID (0x1107) */
-	VIA_BAD_AST	= 0x200, /* Don't touch Address Setup Timing */
-	VIA_NO_ENABLES	= 0x400, /* Has no enablebits */
-	VIA_SATA_PATA	= 0x800, /* SATA/PATA combined configuration */
+	VIA_BAD_PREQ	= 0x01, /* Crashes if PREQ# till DDACK# set */
+	VIA_BAD_CLK66	= 0x02, /* 66 MHz clock doesn't work correctly */
+	VIA_SET_FIFO	= 0x04, /* Needs to have FIFO split set */
+	VIA_NO_UNMASK	= 0x08, /* Doesn't work with IRQ unmasking on */
+	VIA_BAD_ID	= 0x10, /* Has wrong vendor ID (0x1107) */
+	VIA_BAD_AST	= 0x20, /* Don't touch Address Setup Timing */
+	VIA_NO_ENABLES	= 0x40, /* Has no enablebits */
+	VIA_SATA_PATA	= 0x80, /* SATA/PATA combined configuration */
 };
 
 enum {
@@ -99,40 +89,37 @@ static const struct via_isa_bridge {
 	u16 id;
 	u8 rev_min;
 	u8 rev_max;
-	u16 flags;
+	u8 udma_mask;
+	u8 flags;
 } via_isa_bridges[] = {
-	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f,
-	  VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, VIA_UDMA_133 |
-	VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f,
-	  VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_SATA_PATA },
-	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, VIA_UDMA_133 | VIA_BAD_AST | VIA_NO_ENABLES },
-	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
-	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, VIA_UDMA_100 },
-	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, VIA_UDMA_100 },
-	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, VIA_UDMA_66 },
-	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, VIA_UDMA_33 | VIA_BAD_CLK66 },
-	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, VIA_UDMA_66 },
-	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, VIA_UDMA_33 | VIA_BAD_CLK66 },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, VIA_UDMA_33 | VIA_SET_FIFO | VIA_BAD_PREQ },
-	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, VIA_UDMA_33 | VIA_SET_FIFO },
-	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f, VIA_UDMA_NONE | VIA_SET_FIFO },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK },
-	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f, VIA_UDMA_NONE | VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
-	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,    0x00, 0x2f,
-	  VIA_UDMA_133 | VIA_BAD_AST },
+	{ "vx855",	PCI_DEVICE_ID_VIA_VX855,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vx800",	PCI_DEVICE_ID_VIA_VX800,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt8261",	PCI_DEVICE_ID_VIA_8261,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237s",	PCI_DEVICE_ID_VIA_8237S,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8251",	PCI_DEVICE_ID_VIA_8251,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "cx700",	PCI_DEVICE_ID_VIA_CX700,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_SATA_PATA },
+	{ "vt6410",	PCI_DEVICE_ID_VIA_6410,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt6415",	PCI_DEVICE_ID_VIA_6415,     0x00, 0xff, ATA_UDMA6, VIA_BAD_AST | VIA_NO_ENABLES },
+	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
+	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, ATA_UDMA5, },
+	{ "vt8233",	PCI_DEVICE_ID_VIA_8233_0,   0x00, 0x2f, ATA_UDMA5, },
+	{ "vt8231",	PCI_DEVICE_ID_VIA_8231,     0x00, 0x2f, ATA_UDMA5, },
+	{ "vt82c686b",	PCI_DEVICE_ID_VIA_82C686,   0x40, 0x4f, ATA_UDMA5, },
+	{ "vt82c686a",	PCI_DEVICE_ID_VIA_82C686,   0x10, 0x2f, ATA_UDMA4, },
+	{ "vt82c686",	PCI_DEVICE_ID_VIA_82C686,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
+	{ "vt82c596b",	PCI_DEVICE_ID_VIA_82C596,   0x10, 0x2f, ATA_UDMA4, },
+	{ "vt82c596a",	PCI_DEVICE_ID_VIA_82C596,   0x00, 0x0f, ATA_UDMA2, VIA_BAD_CLK66 },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x47, 0x4f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x40, 0x46, ATA_UDMA2, VIA_SET_FIFO | VIA_BAD_PREQ },
+	{ "vt82c586b",	PCI_DEVICE_ID_VIA_82C586_0, 0x30, 0x3f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586a",	PCI_DEVICE_ID_VIA_82C586_0, 0x20, 0x2f, ATA_UDMA2, VIA_SET_FIFO },
+	{ "vt82c586",	PCI_DEVICE_ID_VIA_82C586_0, 0x00, 0x0f,      0x00, VIA_SET_FIFO },
+	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK },
+	{ "vt82c576",	PCI_DEVICE_ID_VIA_82C576,   0x00, 0x2f,      0x00, VIA_SET_FIFO | VIA_NO_UNMASK | VIA_BAD_ID },
+	{ "vtxxxx",	PCI_DEVICE_ID_VIA_ANON,     0x00, 0x2f, ATA_UDMA6, VIA_BAD_AST },
 	{ NULL }
 };
 
@@ -191,10 +178,10 @@ static int via_cable_detect(struct ata_port *ap) {
 		return ATA_CBL_SATA;
 
 	/* Early chips are 40 wire */
-	if ((config->flags & VIA_UDMA) < VIA_UDMA_66)
+	if (config->udma_mask < ATA_UDMA4)
 		return ATA_CBL_PATA40;
 	/* UDMA 66 chips have only drive side logic */
-	else if ((config->flags & VIA_UDMA) < VIA_UDMA_100)
+	else if (config->udma_mask < ATA_UDMA5)
 		return ATA_CBL_PATA_UNK;
 	/* UDMA 100 or later */
 	pci_read_config_dword(pdev, 0x50, &ata66);
@@ -229,11 +216,10 @@ static int via_pre_reset(struct ata_link *link, unsigned long deadline)
 
 
 /**
- *	via_do_set_mode	-	set initial PIO mode data
+ *	via_do_set_mode	-	set transfer mode data
  *	@ap: ATA interface
  *	@adev: ATA device
  *	@mode: ATA mode being programmed
- *	@tdiv: Clocks per PCI clock
  *	@set_ast: Set to program address setup
  *	@udma_type: UDMA mode/format of registers
  *
@@ -244,17 +230,27 @@ static int via_pre_reset(struct ata_link *link, unsigned long deadline)
  *	on the two channels.
  */
 
-static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mode, int tdiv, int set_ast, int udma_type)
+static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev,
+			    int mode, int set_ast, int udma_type)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	struct ata_device *peer = ata_dev_pair(adev);
 	struct ata_timing t, p;
-	static int via_clock = 33333;	/* Bus clock in kHZ - ought to be tunable one day */
+	static int via_clock = 33333;	/* Bus clock in kHZ */
 	unsigned long T =  1000000000 / via_clock;
-	unsigned long UT = T/tdiv;
+	unsigned long UT = T;
 	int ut;
 	int offset = 3 - (2*ap->port_no) - adev->devno;
 
+	switch (udma_type) {
+	case ATA_UDMA4:
+		UT = T / 2; break;
+	case ATA_UDMA5:
+		UT = T / 3; break;
+	case ATA_UDMA6:
+		UT = T / 4; break;
+	}
+
 	/* Calculate the timing values we require */
 	ata_timing_compute(adev, mode, &t, T, UT);
 
@@ -273,7 +269,7 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 
 		pci_read_config_byte(pdev, 0x4C, &setup);
 		setup &= ~(3 << shift);
-		setup |= clamp_val(t.setup, 1, 4) << shift;	/* 1,4 or 1,4 - 1  FIXME */
+		setup |= (clamp_val(t.setup, 1, 4) - 1) << shift;
 		pci_write_config_byte(pdev, 0x4C, setup);
 	}
 
@@ -284,22 +280,20 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 		((clamp_val(t.active, 1, 16) - 1) << 4) | (clamp_val(t.recover, 1, 16) - 1));
 
 	/* Load the UDMA bits according to type */
-	switch(udma_type) {
-		default:
-			/* BUG() ? */
-			/* fall through */
-		case 33:
-			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
-			break;
-		case 66:
-			ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
-			break;
-		case 100:
-			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
-			break;
-		case 133:
-			ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
-			break;
+	switch (udma_type) {
+	case ATA_UDMA2:
+	default:
+		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 5) - 2)) : 0x03;
+		break;
+	case ATA_UDMA4:
+		ut = t.udma ? (0xe8 | (clamp_val(t.udma, 2, 9) - 2)) : 0x0f;
+		break;
+	case ATA_UDMA5:
+		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
+		break;
+	case ATA_UDMA6:
+		ut = t.udma ? (0xe0 | (clamp_val(t.udma, 2, 9) - 2)) : 0x07;
+		break;
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
@@ -325,22 +319,16 @@ static void via_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
 	const struct via_isa_bridge *config = ap->host->private_data;
 	int set_ast = (config->flags & VIA_BAD_AST) ? 0 : 1;
-	int mode = config->flags & VIA_UDMA;
-	static u8 tclock[5] = { 1, 1, 2, 3, 4 };
-	static u8 udma[5] = { 0, 33, 66, 100, 133 };
 
-	via_do_set_mode(ap, adev, adev->pio_mode, tclock[mode], set_ast, udma[mode]);
+	via_do_set_mode(ap, adev, adev->pio_mode, set_ast, config->udma_mask);
 }
 
 static void via_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	const struct via_isa_bridge *config = ap->host->private_data;
 	int set_ast = (config->flags & VIA_BAD_AST) ? 0 : 1;
-	int mode = config->flags & VIA_UDMA;
-	static u8 tclock[5] = { 1, 1, 2, 3, 4 };
-	static u8 udma[5] = { 0, 33, 66, 100, 133 };
 
-	via_do_set_mode(ap, adev, adev->dma_mode, tclock[mode], set_ast, udma[mode]);
+	via_do_set_mode(ap, adev, adev->dma_mode, set_ast, config->udma_mask);
 }
 
 /**
@@ -604,33 +592,29 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	via_config_fifo(pdev, config->flags);
 
 	/* Clock set up */
-	switch(config->flags & VIA_UDMA) {
-		case VIA_UDMA_NONE:
-			if (config->flags & VIA_NO_UNMASK)
-				ppi[0] = &via_mwdma_info_borked;
-			else
-				ppi[0] = &via_mwdma_info;
-			break;
-		case VIA_UDMA_33:
-			ppi[0] = &via_udma33_info;
-			break;
-		case VIA_UDMA_66:
-			ppi[0] = &via_udma66_info;
-			/* The 66 MHz devices require we enable the clock */
-			pci_read_config_dword(pdev, 0x50, &timing);
-			timing |= 0x80008;
-			pci_write_config_dword(pdev, 0x50, timing);
-			break;
-		case VIA_UDMA_100:
-			ppi[0] = &via_udma100_info;
-			break;
-		case VIA_UDMA_133:
-			ppi[0] = &via_udma133_info;
-			break;
-		default:
-			WARN_ON(1);
-			return -ENODEV;
-	}
+	switch (config->udma_mask) {
+	case 0x00:
+		if (config->flags & VIA_NO_UNMASK)
+			ppi[0] = &via_mwdma_info_borked;
+		else
+			ppi[0] = &via_mwdma_info;
+		break;
+	case ATA_UDMA2:
+		ppi[0] = &via_udma33_info;
+		break;
+	case ATA_UDMA4:
+		ppi[0] = &via_udma66_info;
+		break;
+	case ATA_UDMA5:
+		ppi[0] = &via_udma100_info;
+		break;
+	case ATA_UDMA6:
+		ppi[0] = &via_udma133_info;
+		break;
+	default:
+		WARN_ON(1);
+		return -ENODEV;
+ 	}
 
 	if (config->flags & VIA_BAD_CLK66) {
 		/* Disable the 66MHz clock on problem devices */
@@ -640,7 +624,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* We have established the device type, now fire it up */
-	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config);
+	return ata_pci_sff_init_one(pdev, ppi, &via_sht, (void *)config, 0);
 }
 
 #ifdef CONFIG_PM
@@ -667,7 +651,7 @@ static int via_reinit_one(struct pci_dev *pdev)
 
 	via_config_fifo(pdev, config->flags);
 
-	if ((config->flags & VIA_UDMA) == VIA_UDMA_66) {
+	if (config->udma_mask == ATA_UDMA4) {
 		/* The 66 MHz devices require we enable the clock */
 		pci_read_config_dword(pdev, 0x50, &timing);
 		timing |= 0x80008;
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 02efd9a..08f6549 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -40,11 +40,13 @@
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_via"
-#define DRV_VERSION	"2.4"
+#define DRV_VERSION	"2.6"
 
 /*
  * vt8251 is different from other sata controllers of VIA.  It has two
@@ -80,6 +82,7 @@ static int vt8251_scr_write(struct ata_link *link, unsigned int scr, u32 val);
 static void svia_tf_load(struct ata_port *ap, const struct ata_taskfile *tf);
 static void svia_noop_freeze(struct ata_port *ap);
 static int vt6420_prereset(struct ata_link *link, unsigned long deadline);
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc);
 static int vt6421_pata_cable_detect(struct ata_port *ap);
 static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev);
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev);
@@ -121,6 +124,7 @@ static struct ata_port_operations vt6420_sata_ops = {
 	.inherits		= &svia_base_ops,
 	.freeze			= svia_noop_freeze,
 	.prereset		= vt6420_prereset,
+	.bmdma_start		= vt6420_bmdma_start,
 };
 
 static struct ata_port_operations vt6421_pata_ops = {
@@ -377,6 +381,17 @@ static int vt6420_prereset(struct ata_link *link, unsigned long deadline)
 	return 0;
 }
 
+static void vt6420_bmdma_start(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	if ((qc->tf.command == ATA_CMD_PACKET) &&
+	    (qc->scsicmd->sc_data_direction == DMA_TO_DEVICE)) {
+		/* Prevents corruption on some ATAPI burners */
+		ata_sff_pause(ap);
+	}
+	ata_bmdma_start(qc);
+}
+
 static int vt6421_pata_cable_detect(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
@@ -392,14 +407,16 @@ static void vt6421_set_pio_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const u8 pio_bits[] = { 0xA8, 0x65, 0x65, 0x31, 0x20 };
-	pci_write_config_byte(pdev, PATA_PIO_TIMING, pio_bits[adev->pio_mode - XFER_PIO_0]);
+	pci_write_config_byte(pdev, PATA_PIO_TIMING - adev->devno,
+			      pio_bits[adev->pio_mode - XFER_PIO_0]);
 }
 
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
-	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->dma_mode - XFER_UDMA_0]);
+	pci_write_config_byte(pdev, PATA_UDMA_TIMING - adev->devno,
+			      udma_bits[adev->dma_mode - XFER_UDMA_0]);
 }
 
 static const unsigned int svia_bar_sizes[] = {
diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 3817d74..fcba78d 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -62,7 +62,7 @@ static int phison_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	ret = ata_pci_sff_init_one(pdev, ppi, &phison_sht, NULL);
+	ret = ata_pci_sff_init_one(pdev, ppi, &phison_sht, NULL, 0);
 
 	dev_dbg(&pdev->dev, "phison_init_one(), ret = %x\n", ret);
 
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 20f3156..b4c85e2 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -841,7 +841,8 @@ static inline int ata_id_current_chs_valid(const u16 *id)
 
 static inline int ata_id_is_cfa(const u16 *id)
 {
-	if (id[ATA_ID_CONFIG] == 0x848A)	/* Traditional CF */
+	if ((id[ATA_ID_CONFIG] == 0x848A) ||	/* Traditional CF */
+	    (id[ATA_ID_CONFIG] == 0x844A))	/* Delkin Devices CF */
 		return 1;
 	/*
 	 * CF specs don't require specific value in the word 0 anymore and yet
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7311225..f8ea71e 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -857,6 +857,7 @@ struct ata_port_operations {
 	unsigned int (*sff_data_xfer)(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw);
 	u8   (*sff_irq_on)(struct ata_port *);
+	bool (*sff_irq_check)(struct ata_port *);
 	void (*sff_irq_clear)(struct ata_port *);
 
 	void (*bmdma_setup)(struct ata_queued_cmd *qc);
@@ -1642,8 +1643,8 @@ extern int ata_pci_sff_activate_host(struct ata_host *host,
 				     irq_handler_t irq_handler,
 				     struct scsi_host_template *sht);
 extern int ata_pci_sff_init_one(struct pci_dev *pdev,
-				const struct ata_port_info * const * ppi,
-				struct scsi_host_template *sht, void *host_priv);
+		const struct ata_port_info * const * ppi,
+		struct scsi_host_template *sht, void *host_priv, int hflags);
 #endif /* CONFIG_PCI */
 
 /**
