Return-Path: <linux-kernel-owner+w=401wt.eu-S1755006AbZLCTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbZLCTtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:49:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZLCTtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:49:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:63395 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbZLCTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=TfBdgDHIVYWvZs7peRhyUQhqk7G0QmA3llAqJxoslTMXDYAfah0DX0TuwU8kegrbiL
         C8IJKOuR26M7ncvD5q31e3Y89PbS1/IcvPxBEpFH2hLN7uBcqs0s6Fh11RhzkIKgf2d5
         2dp3ty5wErepjbgea5HA+vTIdEF2SeJj3HA8c=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 00/86] PATA fixes
Date: Thu, 3 Dec 2009 20:45:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912031339.14440.bzolnier@gmail.com> <4B17FB37.2030501@garzik.org>
In-Reply-To: <4B17FB37.2030501@garzik.org>
MIME-Version: 1.0
Message-Id: <200912032045.48728.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 06:53:59 pm Jeff Garzik wrote:
> On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
> >> The merge window is upon us, which by strict rules means that anything
> >> not already in libata-dev.git#upstream needs to wait until 2.6.34.
> >>
> >> However, bug fixes and the like should definitely be in 2.6.33.
> >> ->init_host is definitely 2.6.34 material.  Some of the other stuff
> >> could go either way.
> 
> > If you would like to apply some of my patches to 2.6.33 you are more than
> > welcome to do it.  I can even prepare separate git tree with specific changes
> > to make it easier for you once you tell me which changes you would like to
> > see in it.
> 
> OK, great.
> 
> Can you prepare a patchset containing only fixes?  Comment-only changes 
> are acceptable too.  Trivial changes too, if they are extremely trivial :)
> 
> Include nothing that adds features, removes or unifies drivers, etc.

Since this is pretty high-level description and some changes fall into
many categories at once (i.e. addition of proper PCI Power Management
handling could be considered both as a fix and as a feature) I prepared
a rather conservative set of changes (which means that unfortunately
it misses many enhancements available in my tree):

> Please do it in standard kernel submit form, which is either
> (a) repost the patches (yes, again) being submitted for 2.6.33, or
> (b) a standard git pull request, which includes shortlog, diffstat, and 
> all-in-one diff.

Thank you for the detailed explanation of the standard kernel submit
form (I wonder how would I know this otherwise :) but the thing is that
at the current moment I'm not submitting anything to the upstream.

That's it.  While this may sound strange to some people it turns out
that in practice it is much less hassle for me personally to keep some
of trees outside of the (sometimes greatly overrated) upstream.

If knowing the above you still would like to include the aforementioned
set of changes in your libata-dev tree they are at kernel.org now.


The following changes since commit 184b8405d5d3e8510163d66efbac99d351faba2e:
  Bartlomiej Zolnierkiewicz (1):
        libata: add private driver field to struct ata_device

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-for-2.6.33

Bartlomiej Zolnierkiewicz (28):
      ide-pci-generic: build fix
      ata_piix: fix MWDMA handling on PIIX3
      pata_efar: fix wrong PIO timings being programmed
      pata_efar: fix wrong MWDMA timings being programmed
      pata_efar: MWDMA0 is unsupported
      pata_cmd640: document known issues
      pata_cs5520: remove dead VDMA support
      pata_cypress: document known issues
      pata_hpt3x2n: fix overclocked MWDMA0 timing
      pata_hpt3x3: Power Management fix
      pata_it8213: fix UDMA handling
      pata_it8213: fix wrong PIO timings being programmed
      pata_it8213: fix PIO2 underclocking
      pata_it8213: fix wrong MWDMA timings being programmed
      pata_it8213: fix it8213_pre_reset() documentation
      pata_it8213: MWDMA0 is unsupported
      pata_legacy: fix QDI6580DP support
      pata_legacy: fix access to control register for QDI6580
      pata_legacy: add pointers to QDI65x0 documentation
      pata_marvell: fix marvell_pre_reset() documentation
      pata_ns87415: Power Management fix
      pata_oldpiix: MWDMA0 is unsupported
      pata_pdc202xx_old: document known issues
      pata_radisys: fix UDMA handling
      pata_rdc: MWDMA0 is unsupported
      pata_rz1000: Power Management fix
      pata_sis: Power Management fix
      pata_via: clear UDMA transfer mode bit for PIO and MWDMA

 drivers/ata/Kconfig           |   14 ++++++++++++--
 drivers/ata/ata_piix.c        |    6 +++---
 drivers/ata/pata_cs5520.c     |   39 +--------------------------------------
 drivers/ata/pata_efar.c       |    9 +++++----
 drivers/ata/pata_hpt3x2n.c    |    3 +--
 drivers/ata/pata_hpt3x3.c     |   11 ++++++++++-
 drivers/ata/pata_it8213.c     |   27 +++++++++++++--------------
 drivers/ata/pata_legacy.c     |   14 +++++++++++---
 drivers/ata/pata_marvell.c    |    2 +-
 drivers/ata/pata_ns87415.c    |   32 +++++++++++++++++++++++++++-----
 drivers/ata/pata_oldpiix.c    |    2 +-
 drivers/ata/pata_radisys.c    |    4 ++--
 drivers/ata/pata_rdc.c        |    2 +-
 drivers/ata/pata_rz1000.c     |   11 ++++++++++-
 drivers/ata/pata_sis.c        |   21 +++++++++++++++++++--
 drivers/ata/pata_via.c        |   19 +++++++++++++------
 drivers/ide/ide-pci-generic.c |    2 +-
 17 files changed, 131 insertions(+), 87 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 676f08b..25cb4e7 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -287,8 +287,11 @@ config PATA_CMD640_PCI
 	depends on PCI && EXPERIMENTAL
 	help
 	  This option enables support for the CMD640 PCI IDE
-	  interface chip. Only the primary channel is currently
-	  supported.
+	  interface chip.
+
+	  Known issues:
+	  - only the primary channel is currently supported
+	  - only the PCI chip interface is currently supported
 
 	  If unsure, say N.
 
@@ -344,6 +347,9 @@ config PATA_CYPRESS
 	  This option enables support for the Cypress/Contaq CY82C693
 	  chipset found in some Alpha systems
 
+	  Known issues:
+	  - only the primary channel is currently supported
+
 	  If unsure, say N.
 
 config PATA_EFAR
@@ -588,6 +594,10 @@ config PATA_PDC_OLD
 	  This option enables support for the Promise 20246, 20262, 20263,
 	  20265 and 20267 adapters.
 
+	  Known issues:
+	  - UDMA transfers fail mysteriously on some chipsets
+	  - ATAPI DMA is unsupported currently
+
 	  If unsure, say N.
 
 config PATA_QDI
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9ac4e37..0c6155f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -869,10 +869,10 @@ static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, in
 				(timings[pio][1] << 8);
 		}
 
-		if (ap->udma_mask) {
+		if (ap->udma_mask)
 			udma_enable &= ~(1 << devid);
-			pci_write_config_word(dev, master_port, master_data);
-		}
+
+		pci_write_config_word(dev, master_port, master_data);
 	}
 	/* Don't scribble on 0x48 if the controller does not support UDMA */
 	if (ap->udma_mask)
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 0df83cf..95ebdac 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -90,48 +90,12 @@ static void cs5520_set_timings(struct ata_port *ap, struct ata_device *adev, int
 }
 
 /**
- *	cs5520_enable_dma	-	turn on DMA bits
- *
- *	Turn on the DMA bits for this disk. Needed because the BIOS probably
- *	has not done the work for us. Belongs in the core SATA code.
- */
-
-static void cs5520_enable_dma(struct ata_port *ap, struct ata_device *adev)
-{
-	/* Set the DMA enable/disable flag */
-	u8 reg = ioread8(ap->ioaddr.bmdma_addr + 0x02);
-	reg |= 1<<(adev->devno + 5);
-	iowrite8(reg, ap->ioaddr.bmdma_addr + 0x02);
-}
-
-/**
- *	cs5520_set_dmamode	-	program DMA timings
- *	@ap: ATA port
- *	@adev: ATA device
- *
- *	Program the DMA mode timings for the controller according to the pio
- *	clocking table. Note that this device sets the DMA timings to PIO
- *	mode values. This may seem bizarre but the 5520 architecture talks
- *	PIO mode to the disk and DMA mode to the controller so the underlying
- *	transfers are PIO timed.
- */
-
-static void cs5520_set_dmamode(struct ata_port *ap, struct ata_device *adev)
-{
-	static const int dma_xlate[3] = { XFER_PIO_0, XFER_PIO_3, XFER_PIO_4 };
-	cs5520_set_timings(ap, adev, dma_xlate[adev->dma_mode]);
-	cs5520_enable_dma(ap, adev);
-}
-
-/**
  *	cs5520_set_piomode	-	program PIO timings
  *	@ap: ATA port
  *	@adev: ATA device
  *
  *	Program the PIO mode timings for the controller according to the pio
- *	clocking table. We know pio_mode will equal dma_mode because of the
- *	CS5520 architecture. At least once we turned DMA on and wrote a
- *	mode setter.
+ *	clocking table.
  */
 
 static void cs5520_set_piomode(struct ata_port *ap, struct ata_device *adev)
@@ -149,7 +113,6 @@ static struct ata_port_operations cs5520_port_ops = {
 	.qc_prep		= ata_sff_dumb_qc_prep,
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= cs5520_set_piomode,
-	.set_dmamode		= cs5520_set_dmamode,
 };
 
 static int __devinit cs5520_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 2a6412f..b2e71e6 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -2,6 +2,7 @@
  *    pata_efar.c - EFAR PIIX clone controller driver
  *
  *	(C) 2005 Red Hat
+ *	(C) 2009 Bartlomiej Zolnierkiewicz
  *
  *    Some parts based on ata_piix.c by Jeff Garzik and others.
  *
@@ -118,12 +119,12 @@ static void efar_set_piomode (struct ata_port *ap, struct ata_device *adev)
 		int shift = 4 * ap->port_no;
 		u8 slave_data;
 
-		idetm_data &= 0xCC0F;
+		idetm_data &= 0xFF0F;
 		idetm_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
-		slave_data &= 0x0F << shift;
+		slave_data &= ap->port_no ? 0x0F : 0xF0;
 		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << shift;
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
@@ -200,7 +201,7 @@ static void efar_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= ap->port_no ? 0x0F : 0xF0;
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
@@ -251,7 +252,7 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &efar_ops,
 	};
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index d30da80..9a09a1b 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -80,14 +80,13 @@ static struct hpt_clock hpt3x2n_clocks[] = {
 
 	{	XFER_MW_DMA_2,	0x2c829c62	},
 	{	XFER_MW_DMA_1,	0x2c829c66	},
-	{	XFER_MW_DMA_0,	0x2c829d2c	},
+	{	XFER_MW_DMA_0,	0x2c829d2e	},
 
 	{	XFER_PIO_4,	0x0c829c62	},
 	{	XFER_PIO_3,	0x0c829c84	},
 	{	XFER_PIO_2,	0x0c829ca6	},
 	{	XFER_PIO_1,	0x0d029d26	},
 	{	XFER_PIO_0,	0x0d029d5e	},
-	{	0,		0x0d029d5e	}
 };
 
 /**
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index 7e31025..c86c716 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -255,8 +255,17 @@ static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 #ifdef CONFIG_PM
 static int hpt3x3_reinit_one(struct pci_dev *dev)
 {
+	struct ata_host *host = dev_get_drvdata(&dev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(dev);
+	if (rc)
+		return rc;
+
 	hpt3x3_init_chipset(dev);
-	return ata_pci_device_resume(dev);
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif
 
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index f156da8..8f3325a 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -22,7 +22,7 @@
 #define DRV_VERSION	"0.0.3"
 
 /**
- *	it8213_pre_reset	-	check for 40/80 pin
+ *	it8213_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
@@ -92,18 +92,17 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 			    { 2, 1 },
 			    { 2, 3 }, };
 
-	if (pio > 2)
-		control |= 1;	/* TIME1 enable */
+	if (pio > 1)
+		control |= 1;	/* TIME */
 	if (ata_pio_need_iordy(adev))	/* PIO 3/4 require IORDY */
-		control |= 2;	/* IORDY enable */
+		control |= 2;	/* IE */
 	/* Bit 2 is set for ATAPI on the IT8213 - reverse of ICH/PIIX */
 	if (adev->class != ATA_DEV_ATA)
-		control |= 4;
+		control |= 4;	/* PPE */
 
 	pci_read_config_word(dev, idetm_port, &idetm_data);
 
-	/* Enable PPE, IE and TIME as appropriate */
-
+	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
 		idetm_data &= 0xCCF0;
 		idetm_data |= control;
@@ -112,17 +111,17 @@ static void it8213_set_piomode (struct ata_port *ap, struct ata_device *adev)
 	} else {
 		u8 slave_data;
 
-		idetm_data &= 0xCC0F;
+		idetm_data &= 0xFF0F;
 		idetm_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
 		slave_data &= 0xF0;
-		slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << 4;
+		slave_data |= (timings[pio][0] << 2) | timings[pio][1];
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is enabled */
+	idetm_data |= 0x4000;	/* Ensure SITRE is set */
 	pci_write_config_word(dev, idetm_port, idetm_data);
 }
 
@@ -173,10 +172,10 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 
 		udma_enable |= (1 << devid);
 
-		/* Load the UDMA mode number */
+		/* Load the UDMA cycle time */
 		pci_read_config_word(dev, 0x4A, &udma_timing);
 		udma_timing &= ~(3 << (4 * devid));
-		udma_timing |= (udma & 3) << (4 * devid);
+		udma_timing |= u_speed << (4 * devid);
 		pci_write_config_word(dev, 0x4A, udma_timing);
 
 		/* Load the clock selection */
@@ -211,7 +210,7 @@ static void it8213_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 			master_data &= 0xFF4F;  /* Mask out IORDY|TIME1|DMAONLY */
 			master_data |= control << 4;
 			pci_read_config_byte(dev, 0x44, &slave_data);
-			slave_data &= (0x0F + 0xE1 * ap->port_no);
+			slave_data &= 0xF0;
 			/* Load the matching timing */
 			slave_data |= ((timings[pio][0] << 2) | timings[pio][1]) << (ap->port_no ? 4 : 0);
 			pci_write_config_byte(dev, 0x44, slave_data);
@@ -263,7 +262,7 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.udma_mask 	= ATA_UDMA4, /* FIXME: want UDMA 100? */
 		.port_ops	= &it8213_ops,
 	};
diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6932e56..9df1ff7 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -25,6 +25,13 @@
  *		http://www.ryston.cz/petr/vlb/pdc20230b.html
  *		http://www.ryston.cz/petr/vlb/pdc20230c.html
  *		http://www.ryston.cz/petr/vlb/pdc20630.html
+ *	QDI65x0:
+ *		http://www.ryston.cz/petr/vlb/qd6500.html
+ *		http://www.ryston.cz/petr/vlb/qd6580.html
+ *
+ *	QDI65x0 probe code based on drivers/ide/legacy/qd65xx.c
+ *	Rewritten from the work of Colten Edwards <pje120@cs.usask.ca> by
+ *	Samuel Thibault <samuel.thibault@ens-lyon.org>
  *
  *  Unsupported but docs exist:
  *	Appian/Adaptec AIC25VL01/Cirrus Logic PD7220
@@ -35,7 +42,7 @@
  *  the MPIIX where the tuning is PCI side but the IDE is "ISA side".
  *
  *  Specific support is included for the ht6560a/ht6560b/opti82c611a/
- *  opti82c465mv/promise 20230c/20630/winbond83759A
+ *  opti82c465mv/promise 20230c/20630/qdi65x0/winbond83759A
  *
  *  Use the autospeed and pio_mask options with:
  *	Appian ADI/2 aka CLPD7220 or AIC25VL01.
@@ -672,7 +679,7 @@ static void qdi6580dp_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(timing, ld_qdi->timing + 2 * ap->port_no);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, ld_qdi->timing + 3);
+		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
 /**
@@ -707,7 +714,7 @@ static void qdi6580_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(timing, ld_qdi->timing + 2 * adev->devno);
 	/* Clear the FIFO */
 	if (adev->class != ATA_DEV_ATA)
-		outb(0x5F, ld_qdi->timing + 3);
+		outb(0x5F, (ld_qdi->timing & 0xFFF0) + 3);
 }
 
 /**
@@ -787,6 +794,7 @@ static struct ata_port_operations qdi6580_port_ops = {
 static struct ata_port_operations qdi6580dp_port_ops = {
 	.inherits	= &legacy_base_port_ops,
 	.set_piomode	= qdi6580dp_set_piomode,
+	.qc_issue	= qdi_qc_issue,
 	.sff_data_xfer	= vlb32_data_xfer,
 };
 
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 2096fb7..950da39 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -58,7 +58,7 @@ static int marvell_pata_active(struct pci_dev *pdev)
 }
 
 /**
- *	marvell_pre_reset	-	check for 40/80 pin
+ *	marvell_pre_reset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
diff --git a/drivers/ata/pata_ns87415.c b/drivers/ata/pata_ns87415.c
index 773b159..061aa1c 100644
--- a/drivers/ata/pata_ns87415.c
+++ b/drivers/ata/pata_ns87415.c
@@ -325,6 +325,13 @@ static struct scsi_host_template ns87415_sht = {
 	ATA_BMDMA_SHT(DRV_NAME),
 };
 
+static void ns87415_fixup(struct pci_dev *pdev)
+{
+	/* Select 512 byte sectors */
+	pci_write_config_byte(pdev, 0x55, 0xEE);
+	/* Select PIO0 8bit clocking */
+	pci_write_config_byte(pdev, 0x54, 0xB7);
+}
 
 /**
  *	ns87415_init_one - Register 87415 ATA PCI device with kernel services
@@ -371,10 +378,8 @@ static int ns87415_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	if (rc)
 		return rc;
 
-	/* Select 512 byte sectors */
-	pci_write_config_byte(pdev, 0x55, 0xEE);
-	/* Select PIO0 8bit clocking */
-	pci_write_config_byte(pdev, 0x54, 0xB7);
+	ns87415_fixup(pdev);
+
 	return ata_pci_sff_init_one(pdev, ppi, &ns87415_sht, NULL);
 }
 
@@ -384,6 +389,23 @@ static const struct pci_device_id ns87415_pci_tbl[] = {
 	{ }	/* terminate list */
 };
 
+#ifdef CONFIG_PM
+static int ns87415_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	ns87415_fixup(pdev);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static struct pci_driver ns87415_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= ns87415_pci_tbl,
@@ -391,7 +413,7 @@ static struct pci_driver ns87415_pci_driver = {
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
+	.resume			= ns87415_reinit_one,
 #endif
 };
 
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 84ac503..9a8687d 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -239,7 +239,7 @@ static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	static const struct ata_port_info info = {
 		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
-		.mwdma_mask	= ATA_MWDMA2,
+		.mwdma_mask	= ATA_MWDMA12_ONLY,
 		.port_ops	= &oldpiix_pata_ops,
 	};
 	const struct ata_port_info *ppi[] = { &info, NULL };
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 4401b33..4fd25e7 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -139,9 +139,9 @@ static void radisys_set_dmamode (struct ata_port *ap, struct ata_device *adev)
 		pci_read_config_byte(dev, 0x4A, &udma_mode);
 
 		if (adev->xfer_mode == XFER_UDMA_2)
-			udma_mode &= ~ (1 << adev->devno);
+			udma_mode &= ~(2 << (adev->devno * 4));
 		else /* UDMA 4 */
-			udma_mode |= (1 << adev->devno);
+			udma_mode |= (2 << (adev->devno * 4));
 
 		pci_write_config_byte(dev, 0x4A, udma_mode);
 
diff --git a/drivers/ata/pata_rdc.c b/drivers/ata/pata_rdc.c
index c843a1e..237a24d 100644
--- a/drivers/ata/pata_rdc.c
+++ b/drivers/ata/pata_rdc.c
@@ -284,7 +284,7 @@ static struct ata_port_info rdc_port_info = {
 
 	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
-	.mwdma_mask	= ATA_MWDMA2,
+	.mwdma_mask	= ATA_MWDMA12_ONLY,
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &rdc_pata_ops,
 };
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index a5e4dfe..2932998 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -105,11 +105,20 @@ static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 #ifdef CONFIG_PM
 static int rz1000_reinit_one(struct pci_dev *pdev)
 {
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
 	/* If this fails on resume (which is a "cant happen" case), we
 	   must stop as any progress risks data loss */
 	if (rz1000_fifo_disable(pdev))
 		panic("rz1000 fifo");
-	return ata_pci_device_resume(pdev);
+
+	ata_host_resume(host);
+	return 0;
 }
 #endif
 
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index d70ecec..8af0dc8 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -2,7 +2,7 @@
  *    pata_sis.c - SiS ATA driver
  *
  *	(C) 2005 Red Hat
- *	(C) 2007 Bartlomiej Zolnierkiewicz
+ *	(C) 2007,2009 Bartlomiej Zolnierkiewicz
  *
  *    Based upon linux/drivers/ide/pci/sis5513.c
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
@@ -876,6 +876,23 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	return ata_pci_sff_init_one(pdev, ppi, &sis_sht, chipset);
 }
 
+#ifdef CONFIG_PM
+static int sis_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	sis_fixup(pdev, host->private_data);
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 static const struct pci_device_id sis_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x5513), },	/* SiS 5513 */
 	{ PCI_VDEVICE(SI, 0x5518), },	/* SiS 5518 */
@@ -891,7 +908,7 @@ static struct pci_driver sis_pci_driver = {
 	.remove			= ata_pci_remove_one,
 #ifdef CONFIG_PM
 	.suspend		= ata_pci_device_suspend,
-	.resume			= ata_pci_device_resume,
+	.resume			= sis_reinit_one,
 #endif
 };
 
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 78eac27..0d97890 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -303,14 +303,21 @@ static void via_do_set_mode(struct ata_port *ap, struct ata_device *adev, int mo
 	}
 
 	/* Set UDMA unless device is not UDMA capable */
-	if (udma_type && t.udma) {
-		u8 cable80_status;
+	if (udma_type) {
+		u8 udma_etc;
 
-		/* Get 80-wire cable detection bit */
-		pci_read_config_byte(pdev, 0x50 + offset, &cable80_status);
-		cable80_status &= 0x10;
+		pci_read_config_byte(pdev, 0x50 + offset, &udma_etc);
 
-		pci_write_config_byte(pdev, 0x50 + offset, ut | cable80_status);
+		/* clear transfer mode bit */
+		udma_etc &= ~0x20;
+
+		if (t.udma) {
+			/* preserve 80-wire cable detection bit */
+			udma_etc &= 0x10;
+			udma_etc |= ut;
+		}
+
+		pci_write_config_byte(pdev, 0x50 + offset, udma_etc);
 	}
 }
 
diff --git a/drivers/ide/ide-pci-generic.c b/drivers/ide/ide-pci-generic.c
index 3f0bc42..a743e68 100644
--- a/drivers/ide/ide-pci-generic.c
+++ b/drivers/ide/ide-pci-generic.c
@@ -165,7 +165,7 @@ static const struct pci_device_id generic_pci_tbl[] = {
 	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_1),	 4 },
 	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),	 4 },
 	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_3),	 4 },
-	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_5)	 4 },
+	{ PCI_VDEVICE(TOSHIBA,	PCI_DEVICE_ID_TOSHIBA_PICCOLO_5),	 4 },
 	{ PCI_VDEVICE(NETCELL,	PCI_DEVICE_ID_REVOLUTION),		 6 },
 	/*
 	 * Must come last.  If you add entries adjust
