Return-Path: <linux-kernel-owner+w=401wt.eu-S1762397AbXEKWcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762397AbXEKWcu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbXEKWcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:32:39 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49276 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbXEKWcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:32:33 -0400
Date: Fri, 11 May 2007 18:32:31 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20070511223231.GA6551@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 Documentation/feature-removal-schedule.txt |   19 ++
 drivers/ata/Kconfig                        |   36 ++---
 drivers/ata/Makefile                       |    2 +-
 drivers/ata/ahci.c                         |    5 +-
 drivers/ata/ata_generic.c                  |   12 +-
 drivers/ata/ata_piix.c                     |    8 +-
 drivers/ata/libata-acpi.c                  |  192 +++++++++++-----------
 drivers/ata/libata-core.c                  |   72 ++++----
 drivers/ata/libata-eh.c                    |  246 +---------------------------
 drivers/ata/libata-scsi.c                  |  157 ++++--------------
 drivers/ata/libata-sff.c                   |  162 ++++++++++---------
 drivers/ata/libata.h                       |    7 +-
 drivers/ata/pata_ali.c                     |   36 ++---
 drivers/ata/pata_amd.c                     |   13 +-
 drivers/ata/pata_artop.c                   |   25 ++--
 drivers/ata/pata_atiixp.c                  |   10 +-
 drivers/ata/pata_cmd640.c                  |   11 +-
 drivers/ata/pata_cmd64x.c                  |   17 +--
 drivers/ata/pata_cs5520.c                  |    4 -
 drivers/ata/pata_cs5530.c                  |   14 +-
 drivers/ata/pata_cs5535.c                  |   10 +-
 drivers/ata/pata_cypress.c                 |   10 +-
 drivers/ata/pata_efar.c                    |   10 +-
 drivers/ata/pata_hpt366.c                  |   17 +-
 drivers/ata/pata_hpt37x.c                  |   33 ++--
 drivers/ata/pata_hpt3x2n.c                 |   13 +-
 drivers/ata/pata_hpt3x3.c                  |   10 +-
 drivers/ata/pata_it8213.c                  |   12 +-
 drivers/ata/pata_it821x.c                  |   16 +-
 drivers/ata/pata_ixp4xx_cf.c               |    2 +-
 drivers/ata/pata_jmicron.c                 |   10 +-
 drivers/ata/pata_marvell.c                 |   15 +-
 drivers/ata/pata_mpc52xx.c                 |    4 -
 drivers/ata/pata_mpiix.c                   |    4 -
 drivers/ata/pata_netcell.c                 |   10 +-
 drivers/ata/pata_ns87410.c                 |   10 +-
 drivers/ata/pata_oldpiix.c                 |   10 +-
 drivers/ata/pata_opti.c                    |   10 +-
 drivers/ata/pata_optidma.c                 |   16 +--
 drivers/ata/pata_pcmcia.c                  |    1 +
 drivers/ata/pata_pdc202xx_old.c            |   12 +-
 drivers/ata/pata_platform.c                |    4 +-
 drivers/ata/pata_radisys.c                 |   10 +-
 drivers/ata/pata_rz1000.c                  |   18 +--
 drivers/ata/pata_sc1200.c                  |   12 +-
 drivers/ata/pata_scc.c                     |    4 -
 drivers/ata/pata_serverworks.c             |   19 +--
 drivers/ata/pata_sil680.c                  |   14 +-
 drivers/ata/pata_sis.c                     |   33 ++--
 drivers/ata/pata_sl82c105.c                |   17 +-
 drivers/ata/pata_triflex.c                 |   10 +-
 drivers/ata/pata_via.c                     |   36 ++---
 drivers/ata/sata_inic162x.c                |    4 -
 drivers/ata/sata_nv.c                      |   16 +--
 drivers/ata/sata_sil.c                     |    4 -
 drivers/ata/sata_sil24.c                   |    4 -
 drivers/ata/sata_sis.c                     |    6 +-
 drivers/ata/sata_uli.c                     |   22 ++-
 drivers/ata/sata_via.c                     |    6 +-
 drivers/ata/sis.h                          |    2 +-
 drivers/pci/quirks.c                       |    1 +
 include/linux/libata.h                     |   31 +---
 include/linux/pci_ids.h                    |    1 +
 63 files changed, 532 insertions(+), 1025 deletions(-)

Aeschbacher, Fabrice (1):
      pata_pcmcia: recognize 2GB CompactFlash from Transcend

Andrew Morton (1):
      git-libata-all: sata_via build fix

Henry Su (2):
      Add the combined mode for ATI SB700
      add the ATI SB700 SATA controller device id to AHCI pci table

Jan Engelhardt (1):
      Use menuconfig objects: libata

Olof Johansson (1):
      pata_platform: don't use generic ata_port_start

Tejun Heo (8):
      libata: reimplement suspend/resume support using sdev->manage_start_stop
      libata: implement libata.spindown_compat
      libata: clean up SFF init mess
      libata: ignore EH scheduling during initialization
      libata: fallback to the other IDENTIFY on device error, take#2
      libata: give devices one last chance even if recovery failed with -EINVAL
      libata-acpi: s/CONFIG_SATA_ACPI/CONFIG_ATA_ACPI/
      libata-acpi: clean up parameters and misc stuff

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index c6322c7..498ff31 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -328,3 +328,22 @@ Who:   Adrian Bunk <bunk@stusta.de>
 
 ---------------------------
 
+What: libata.spindown_compat module parameter
+When: Dec 2008
+Why:  halt(8) synchronizes caches for and spins down libata disks
+      because libata didn't use to spin down disk on system halt
+      (only synchronized caches).
+      Spin down on system halt is now implemented and can be tested
+      using sysfs node /sys/class/scsi_disk/h:c:i:l/manage_start_stop.
+      Because issuing spin down command to an already spun down disk
+      makes some disks spin up just to spin down again, the old
+      behavior needs to be maintained till userspace tool is updated
+      to check the sysfs node and not to spin down disks with the
+      node set to one.
+      This module parameter is to give userspace tool the time to
+      get updated and should be removed after userspace is
+      reasonably updated.
+Who:  Tejun Heo <htejun@gmail.com>
+
+---------------------------
+
diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index f031b87..ad1f59c 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -2,11 +2,9 @@
 # SATA/PATA driver configuration
 #
 
-menu "Serial ATA (prod) and Parallel ATA (experimental) drivers"
+menuconfig ATA
+	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
 	depends on HAS_IOMEM
-
-config ATA
-	tristate "ATA device support"
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
 	depends on !SUN4 || BROKEN
@@ -24,6 +22,19 @@ config ATA_NONSTANDARD
        bool
        default n
 
+config ATA_ACPI
+	bool
+	depends on ACPI && PCI
+	default y
+	help
+	  This option adds support for ATA-related ACPI objects.
+	  These ACPI objects add the ability to retrieve taskfiles
+	  from the ACPI BIOS and write them to the disk controller.
+	  These objects may be related to performance, security,
+	  power management, or other areas.
+	  You can disable this at kernel boot time by using the
+	  option libata.noacpi=1
+
 config SATA_AHCI
 	tristate "AHCI SATA support"
 	depends on PCI
@@ -157,19 +168,6 @@ config SATA_INIC162X
 	help
 	  This option enables support for Initio 162x Serial ATA.
 
-config SATA_ACPI
-	bool
-	depends on ACPI && PCI
-	default y
-	help
-	  This option adds support for SATA-related ACPI objects.
-	  These ACPI objects add the ability to retrieve taskfiles
-	  from the ACPI BIOS and write them to the disk controller.
-	  These objects may be related to performance, security,
-	  power management, or other areas.
-	  You can disable this at kernel boot time by using the
-	  option libata.noacpi=1
-
 config PATA_ALI
 	tristate "ALi PATA support (Experimental)"
 	depends on PCI && EXPERIMENTAL
@@ -585,6 +583,4 @@ config PATA_SCC
 
 	  If unsure, say N.
 
-endif
-endmenu
-
+endif # ATA
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index 6f42a0e..8149c68 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -69,4 +69,4 @@ obj-$(CONFIG_ATA_GENERIC)	+= ata_generic.o
 obj-$(CONFIG_PATA_LEGACY)	+= pata_legacy.o
 
 libata-objs	:= libata-core.o libata-scsi.o libata-sff.o libata-eh.o
-libata-$(CONFIG_SATA_ACPI) += libata-acpi.o
+libata-$(CONFIG_ATA_ACPI)	+= libata-acpi.o
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d961789..1ae443d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -250,10 +250,6 @@ static struct scsi_host_template ahci_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations ahci_ops = {
@@ -400,6 +396,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* ATI */
 	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 */
+	{ PCI_VDEVICE(ATI, 0x4390), board_ahci_sb600 }, /* ATI SB700 */
 
 	/* VIA */
 	{ PCI_VDEVICE(VIA, 0x3349), board_ahci_vt8251 }, /* VIA VT8251 */
diff --git a/drivers/ata/ata_generic.c b/drivers/ata/ata_generic.c
index 92a491d..c3d7532 100644
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -54,7 +54,7 @@ static int generic_set_mode(struct ata_port *ap, struct ata_device **unused)
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_ready(dev)) {
+		if (ata_dev_enabled(dev)) {
 			/* We don't really care */
 			dev->pio_mode = XFER_PIO_0;
 			dev->dma_mode = XFER_MW_DMA_0;
@@ -90,10 +90,6 @@ static struct scsi_host_template generic_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations generic_port_ops = {
@@ -145,7 +141,7 @@ static int all_generic_ide;		/* Set to claim all devices */
 static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	u16 command;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &generic_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -153,7 +149,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 		.udma_mask = 0x3f,
 		.port_ops = &generic_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/* Don't use the generic entry unless instructed to do so */
 	if (id->driver_data == 1 && all_generic_ide == 0)
@@ -179,7 +175,7 @@ static int ata_generic_init_one(struct pci_dev *dev, const struct pci_device_id
 	if (dev->vendor == PCI_VENDOR_ID_AL)
 	    	ata_pci_clear_simplex(dev);
 
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static struct pci_device_id ata_generic[] = {
diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 4a795fd..13b6b1d 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -275,10 +275,6 @@ static struct scsi_host_template piix_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations piix_pata_ops = {
@@ -1034,7 +1030,7 @@ static int piix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	struct device *dev = &pdev->dev;
 	struct ata_port_info port_info[2];
-	struct ata_port_info *ppinfo[2] = { &port_info[0], &port_info[1] };
+	const struct ata_port_info *ppi[] = { &port_info[0], &port_info[1] };
 	struct piix_host_priv *hpriv;
 	unsigned long port_flags;
 
@@ -1093,7 +1089,7 @@ static int piix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		port_info[1].mwdma_mask = 0;
 		port_info[1].udma_mask = 0;
 	}
-	return ata_pci_init_one(pdev, ppinfo, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static int __init piix_init(void)
diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index cb3eab6..ed4138e 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -270,8 +270,7 @@ out:
 
 /**
  * do_drive_get_GTF - get the drive bootup default taskfile settings
- * @ap: the ata_port for the drive
- * @ix: target ata_device (drive) index
+ * @dev: target ATA device
  * @gtf_length: number of bytes of _GTF data returned at @gtf_address
  * @gtf_address: buffer containing _GTF taskfile arrays
  *
@@ -286,20 +285,19 @@ out:
  * The returned @gtf_length and @gtf_address are only valid if the
  * function return value is 0.
  */
-static int do_drive_get_GTF(struct ata_port *ap, int ix,
-			unsigned int *gtf_length, unsigned long *gtf_address,
-			unsigned long *obj_loc)
+static int do_drive_get_GTF(struct ata_device *dev, unsigned int *gtf_length,
+			    unsigned long *gtf_address, unsigned long *obj_loc)
 {
-	acpi_status			status;
-	acpi_handle			dev_handle = NULL;
-	acpi_handle			chan_handle, drive_handle;
-	acpi_integer			pcidevfn = 0;
-	u32				dev_adr;
-	struct acpi_buffer		output;
-	union acpi_object 		*out_obj;
-	struct device			*dev = ap->host->dev;
-	struct ata_device		*atadev = &ap->device[ix];
-	int				err = -ENODEV;
+	struct ata_port *ap = dev->ap;
+	acpi_status status;
+	acpi_handle dev_handle = NULL;
+	acpi_handle chan_handle, drive_handle;
+	acpi_integer pcidevfn = 0;
+	u32 dev_adr;
+	struct acpi_buffer output;
+	union acpi_object *out_obj;
+	struct device *gdev = ap->host->dev;
+	int err = -ENODEV;
 
 	*gtf_length = 0;
 	*gtf_address = 0UL;
@@ -309,14 +307,14 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 		return 0;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
 			       __FUNCTION__, ap->port_no);
 
-	if (!ata_dev_enabled(atadev) || (ap->flags & ATA_FLAG_DISABLED)) {
+	if (!ata_dev_enabled(dev) || (ap->flags & ATA_FLAG_DISABLED)) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG, "%s: ERR: "
+			ata_dev_printk(dev, KERN_DEBUG, "%s: ERR: "
 				"ata_dev_present: %d, PORT_DISABLED: %lu\n",
-				__FUNCTION__, ata_dev_enabled(atadev),
+				__FUNCTION__, ata_dev_enabled(dev),
 				ap->flags & ATA_FLAG_DISABLED);
 		goto out;
 	}
@@ -324,19 +322,19 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 	/* Don't continue if device has no _ADR method.
 	 * _GTF is intended for known motherboard devices. */
 	if (!(ap->cbl == ATA_CBL_SATA)) {
-		err = pata_get_dev_handle(dev, &dev_handle, &pcidevfn);
+		err = pata_get_dev_handle(gdev, &dev_handle, &pcidevfn);
 		if (err < 0) {
 			if (ata_msg_probe(ap))
-				ata_dev_printk(atadev, KERN_DEBUG,
+				ata_dev_printk(dev, KERN_DEBUG,
 					"%s: pata_get_dev_handle failed (%d)\n",
 					__FUNCTION__, err);
 			goto out;
 		}
 	} else {
-		err = sata_get_dev_handle(dev, &dev_handle, &pcidevfn);
+		err = sata_get_dev_handle(gdev, &dev_handle, &pcidevfn);
 		if (err < 0) {
 			if (ata_msg_probe(ap))
-				ata_dev_printk(atadev, KERN_DEBUG,
+				ata_dev_printk(dev, KERN_DEBUG,
 					"%s: sata_get_dev_handle failed (%d\n",
 					__FUNCTION__, err);
 			goto out;
@@ -344,7 +342,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 	}
 
 	/* Get this drive's _ADR info. if not already known. */
-	if (!atadev->obj_handle) {
+	if (!dev->obj_handle) {
 		if (!(ap->cbl == ATA_CBL_SATA)) {
 			/* get child objects of dev_handle == channel objects,
 	 		 * + _their_ children == drive objects */
@@ -352,7 +350,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 			chan_handle = acpi_get_child(dev_handle,
 						ap->port_no);
 			if (ata_msg_probe(ap))
-				ata_dev_printk(atadev, KERN_DEBUG,
+				ata_dev_printk(dev, KERN_DEBUG,
 					"%s: chan adr=%d: chan_handle=0x%p\n",
 					__FUNCTION__, ap->port_no,
 					chan_handle);
@@ -361,26 +359,26 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 				goto out;
 			}
 			/* TBD: could also check ACPI object VALID bits */
-			drive_handle = acpi_get_child(chan_handle, ix);
+			drive_handle = acpi_get_child(chan_handle, dev->devno);
 			if (!drive_handle) {
 				err = -ENODEV;
 				goto out;
 			}
-			dev_adr = ix;
-			atadev->obj_handle = drive_handle;
+			dev_adr = dev->devno;
+			dev->obj_handle = drive_handle;
 		} else {	/* for SATA mode */
 			dev_adr = SATA_ADR_RSVD;
-			err = get_sata_adr(dev, dev_handle, pcidevfn, 0,
-					ap, atadev, &dev_adr);
+			err = get_sata_adr(gdev, dev_handle, pcidevfn, 0,
+					ap, dev, &dev_adr);
 		}
 		if (err < 0 || dev_adr == SATA_ADR_RSVD ||
-		    !atadev->obj_handle) {
+		    !dev->obj_handle) {
 			if (ata_msg_probe(ap))
-				ata_dev_printk(atadev, KERN_DEBUG,
+				ata_dev_printk(dev, KERN_DEBUG,
 					"%s: get_sata/pata_adr failed: "
 					"err=%d, dev_adr=%u, obj_handle=0x%p\n",
 					__FUNCTION__, err, dev_adr,
-					atadev->obj_handle);
+					dev->obj_handle);
 			goto out;
 		}
 	}
@@ -391,11 +389,11 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 
 	/* _GTF has no input parameters */
 	err = -EIO;
-	status = acpi_evaluate_object(atadev->obj_handle, "_GTF",
+	status = acpi_evaluate_object(dev->obj_handle, "_GTF",
 					NULL, &output);
 	if (ACPI_FAILURE(status)) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG,
+			ata_dev_printk(dev, KERN_DEBUG,
 				"%s: Run _GTF error: status = 0x%x\n",
 				__FUNCTION__, status);
 		goto out;
@@ -403,7 +401,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 
 	if (!output.length || !output.pointer) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG, "%s: Run _GTF: "
+			ata_dev_printk(dev, KERN_DEBUG, "%s: Run _GTF: "
 				"length or ptr is NULL (0x%llx, 0x%p)\n",
 				__FUNCTION__,
 				(unsigned long long)output.length,
@@ -416,7 +414,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
 		kfree(output.pointer);
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG, "%s: Run _GTF: "
+			ata_dev_printk(dev, KERN_DEBUG, "%s: Run _GTF: "
 				"error: expected object type of "
 				" ACPI_TYPE_BUFFER, got 0x%x\n",
 				__FUNCTION__, out_obj->type);
@@ -427,7 +425,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 	if (!out_obj->buffer.length || !out_obj->buffer.pointer ||
 	    out_obj->buffer.length % REGS_PER_GTF) {
 		if (ata_msg_drv(ap))
-			ata_dev_printk(atadev, KERN_ERR,
+			ata_dev_printk(dev, KERN_ERR,
 				"%s: unexpected GTF length (%d) or addr (0x%p)\n",
 				__FUNCTION__, out_obj->buffer.length,
 				out_obj->buffer.pointer);
@@ -439,7 +437,7 @@ static int do_drive_get_GTF(struct ata_port *ap, int ix,
 	*gtf_address = (unsigned long)out_obj->buffer.pointer;
 	*obj_loc = (unsigned long)out_obj;
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG, "%s: returning "
+		ata_dev_printk(dev, KERN_DEBUG, "%s: returning "
 			"gtf_length=%d, gtf_address=0x%lx, obj_loc=0x%lx\n",
 			__FUNCTION__, *gtf_length, *gtf_address, *obj_loc);
 	err = 0;
@@ -449,7 +447,7 @@ out:
 
 /**
  * taskfile_load_raw - send taskfile registers to host controller
- * @ap: Port to which output is sent
+ * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
  *
  * Outputs ATA taskfile to standard ATA host controller using MMIO
@@ -466,15 +464,15 @@ out:
  * LOCKING: TBD:
  * Inherited from caller.
  */
-static void taskfile_load_raw(struct ata_port *ap,
-				struct ata_device *atadev,
-				const struct taskfile_array *gtf)
+static void taskfile_load_raw(struct ata_device *dev,
+			      const struct taskfile_array *gtf)
 {
+	struct ata_port *ap = dev->ap;
 	struct ata_taskfile tf;
 	unsigned int err;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG, "%s: (0x1f1-1f7): hex: "
+		ata_dev_printk(dev, KERN_DEBUG, "%s: (0x1f1-1f7): hex: "
 			"%02x %02x %02x %02x %02x %02x %02x\n",
 			__FUNCTION__,
 			gtf->tfa[0], gtf->tfa[1], gtf->tfa[2],
@@ -485,7 +483,7 @@ static void taskfile_load_raw(struct ata_port *ap,
 	    && (gtf->tfa[6] == 0))
 		return;
 
-	ata_tf_init(atadev, &tf);
+	ata_tf_init(dev, &tf);
 
 	/* convert gtf to tf */
 	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE; /* TBD */
@@ -498,17 +496,16 @@ static void taskfile_load_raw(struct ata_port *ap,
 	tf.device  = gtf->tfa[5];	/* 0x1f6 */
 	tf.command = gtf->tfa[6];	/* 0x1f7 */
 
-	err = ata_exec_internal(atadev, &tf, NULL, DMA_NONE, NULL, 0);
+	err = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0);
 	if (err && ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_ERR,
+		ata_dev_printk(dev, KERN_ERR,
 			"%s: ata_exec_internal failed: %u\n",
 			__FUNCTION__, err);
 }
 
 /**
  * do_drive_set_taskfiles - write the drive taskfile settings from _GTF
- * @ap: the ata_port for the drive
- * @atadev: target ata_device
+ * @dev: target ATA device
  * @gtf_length: total number of bytes of _GTF taskfiles
  * @gtf_address: location of _GTF taskfile arrays
  *
@@ -517,30 +514,31 @@ static void taskfile_load_raw(struct ata_port *ap,
  * Write {gtf_address, length gtf_length} in groups of
  * REGS_PER_GTF bytes.
  */
-static int do_drive_set_taskfiles(struct ata_port *ap,
-		struct ata_device *atadev, unsigned int gtf_length,
-		unsigned long gtf_address)
+static int do_drive_set_taskfiles(struct ata_device *dev,
+				  unsigned int gtf_length,
+				  unsigned long gtf_address)
 {
-	int			err = -ENODEV;
-	int			gtf_count = gtf_length / REGS_PER_GTF;
-	int			ix;
+	struct ata_port *ap = dev->ap;
+	int err = -ENODEV;
+	int gtf_count = gtf_length / REGS_PER_GTF;
+	int ix;
 	struct taskfile_array	*gtf;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER: port#: %d\n",
 			       __FUNCTION__, ap->port_no);
 
 	if (libata_noacpi || !(ap->cbl == ATA_CBL_SATA))
 		return 0;
 
-	if (!ata_dev_enabled(atadev) || (ap->flags & ATA_FLAG_DISABLED))
+	if (!ata_dev_enabled(dev) || (ap->flags & ATA_FLAG_DISABLED))
 		goto out;
 	if (!gtf_count)		/* shouldn't be here */
 		goto out;
 
 	if (gtf_length % REGS_PER_GTF) {
 		if (ata_msg_drv(ap))
-			ata_dev_printk(atadev, KERN_ERR,
+			ata_dev_printk(dev, KERN_ERR,
 				"%s: unexpected GTF length (%d)\n",
 				__FUNCTION__, gtf_length);
 		goto out;
@@ -551,7 +549,7 @@ static int do_drive_set_taskfiles(struct ata_port *ap,
 			(gtf_address + ix * REGS_PER_GTF);
 
 		/* send all TaskFile registers (0x1f1-0x1f7) *in*that*order* */
-		taskfile_load_raw(ap, atadev, gtf);
+		taskfile_load_raw(dev, gtf);
 	}
 
 	err = 0;
@@ -567,11 +565,11 @@ out:
  */
 int ata_acpi_exec_tfs(struct ata_port *ap)
 {
-	int		ix;
-	int		ret =0;
-	unsigned int	gtf_length;
-	unsigned long	gtf_address;
-	unsigned long	obj_loc;
+	int ix;
+	int ret = 0;
+	unsigned int gtf_length;
+	unsigned long gtf_address;
+	unsigned long obj_loc;
 
 	if (libata_noacpi)
 		return 0;
@@ -584,11 +582,13 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
 		return 0;
 
 	for (ix = 0; ix < ATA_MAX_DEVICES; ix++) {
-		if (!ata_dev_enabled(&ap->device[ix]))
+		struct ata_device *dev = &ap->device[ix];
+
+		if (!ata_dev_enabled(dev))
 			continue;
 
-		ret = do_drive_get_GTF(ap, ix,
-				&gtf_length, &gtf_address, &obj_loc);
+		ret = do_drive_get_GTF(dev, &gtf_length, &gtf_address,
+				       &obj_loc);
 		if (ret < 0) {
 			if (ata_msg_probe(ap))
 				ata_port_printk(ap, KERN_DEBUG,
@@ -597,8 +597,7 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
 			break;
 		}
 
-		ret = do_drive_set_taskfiles(ap, &ap->device[ix],
-				gtf_length, gtf_address);
+		ret = do_drive_set_taskfiles(dev, gtf_length, gtf_address);
 		kfree((void *)obj_loc);
 		if (ret < 0) {
 			if (ata_msg_probe(ap))
@@ -614,8 +613,7 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
 
 /**
  * ata_acpi_push_id - send Identify data to drive
- * @ap: the ata_port for the drive
- * @ix: drive index
+ * @dev: target ATA device
  *
  * _SDD ACPI object: for SATA mode only
  * Must be after Identify (Packet) Device -- uses its data
@@ -623,57 +621,57 @@ int ata_acpi_exec_tfs(struct ata_port *ap)
  * method and if it fails for whatever reason, we should still
  * just keep going.
  */
-int ata_acpi_push_id(struct ata_port *ap, unsigned int ix)
+int ata_acpi_push_id(struct ata_device *dev)
 {
-	acpi_handle                     handle;
-	acpi_integer                    pcidevfn;
-	int                             err;
-	struct device                   *dev = ap->host->dev;
-	struct ata_device               *atadev = &ap->device[ix];
-	u32                             dev_adr;
-	acpi_status                     status;
-	struct acpi_object_list         input;
-	union acpi_object               in_params[1];
+	struct ata_port *ap = dev->ap;
+	acpi_handle handle;
+	acpi_integer pcidevfn;
+	int err;
+	struct device *gdev = ap->host->dev;
+	u32 dev_adr;
+	acpi_status status;
+	struct acpi_object_list input;
+	union acpi_object in_params[1];
 
 	if (libata_noacpi)
 		return 0;
 
 	if (ata_msg_probe(ap))
-		ata_dev_printk(atadev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
-			       __FUNCTION__, ix, ap->port_no);
+		ata_dev_printk(dev, KERN_DEBUG, "%s: ix = %d, port#: %d\n",
+			       __FUNCTION__, dev->devno, ap->port_no);
 
 	/* Don't continue if not a SATA device. */
 	if (!(ap->cbl == ATA_CBL_SATA)) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG,
+			ata_dev_printk(dev, KERN_DEBUG,
 				"%s: Not a SATA device\n", __FUNCTION__);
 		goto out;
 	}
 
 	/* Don't continue if device has no _ADR method.
 	 * _SDD is intended for known motherboard devices. */
-	err = sata_get_dev_handle(dev, &handle, &pcidevfn);
+	err = sata_get_dev_handle(gdev, &handle, &pcidevfn);
 	if (err < 0) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG,
+			ata_dev_printk(dev, KERN_DEBUG,
 				"%s: sata_get_dev_handle failed (%d\n",
 				__FUNCTION__, err);
 		goto out;
 	}
 
 	/* Get this drive's _ADR info, if not already known */
-	if (!atadev->obj_handle) {
+	if (!dev->obj_handle) {
 		dev_adr = SATA_ADR_RSVD;
-		err = get_sata_adr(dev, handle, pcidevfn, ix, ap, atadev,
+		err = get_sata_adr(gdev, handle, pcidevfn, dev->devno, ap, dev,
 					&dev_adr);
 		if (err < 0 || dev_adr == SATA_ADR_RSVD ||
-			!atadev->obj_handle) {
+			!dev->obj_handle) {
 			if (ata_msg_probe(ap))
-				ata_dev_printk(atadev, KERN_DEBUG,
+				ata_dev_printk(dev, KERN_DEBUG,
 					"%s: get_sata_adr failed: "
 					"err=%d, dev_adr=%u, obj_handle=0x%p\n",
 					__FUNCTION__, err, dev_adr,
-					atadev->obj_handle);
+					dev->obj_handle);
 			goto out;
 		}
 	}
@@ -683,19 +681,19 @@ int ata_acpi_push_id(struct ata_port *ap, unsigned int ix)
 	input.count = 1;
 	input.pointer = in_params;
 	in_params[0].type = ACPI_TYPE_BUFFER;
-	in_params[0].buffer.length = sizeof(atadev->id[0]) * ATA_ID_WORDS;
-	in_params[0].buffer.pointer = (u8 *)atadev->id;
+	in_params[0].buffer.length = sizeof(dev->id[0]) * ATA_ID_WORDS;
+	in_params[0].buffer.pointer = (u8 *)dev->id;
 	/* Output buffer: _SDD has no output */
 
 	/* It's OK for _SDD to be missing too. */
-	swap_buf_le16(atadev->id, ATA_ID_WORDS);
-	status = acpi_evaluate_object(atadev->obj_handle, "_SDD", &input, NULL);
-	swap_buf_le16(atadev->id, ATA_ID_WORDS);
+	swap_buf_le16(dev->id, ATA_ID_WORDS);
+	status = acpi_evaluate_object(dev->obj_handle, "_SDD", &input, NULL);
+	swap_buf_le16(dev->id, ATA_ID_WORDS);
 
 	err = ACPI_FAILURE(status) ? -EIO : 0;
 	if (err < 0) {
 		if (ata_msg_probe(ap))
-			ata_dev_printk(atadev, KERN_DEBUG,
+			ata_dev_printk(dev, KERN_DEBUG,
 				       "%s _SDD error: status = 0x%x\n",
 				       __FUNCTION__, status);
 	}
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4595d1f..4166407 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -101,6 +101,12 @@ int libata_noacpi = 1;
 module_param_named(noacpi, libata_noacpi, int, 0444);
 MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in suspend/resume when set");
 
+int ata_spindown_compat = 1;
+module_param_named(spindown_compat, ata_spindown_compat, int, 0644);
+MODULE_PARM_DESC(spindown_compat, "Enable backward compatible spindown "
+		 "behavior.  Will be removed.  More info can be found in "
+		 "Documentation/feature-removal-schedule.txt\n");
+
 MODULE_AUTHOR("Jeff Garzik");
 MODULE_DESCRIPTION("Library module for ATA devices");
 MODULE_LICENSE("GPL");
@@ -1654,7 +1660,7 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 	struct ata_taskfile tf;
 	unsigned int err_mask = 0;
 	const char *reason;
-	int tried_spinup = 0;
+	int may_fallback = 1, tried_spinup = 0;
 	int rc;
 
 	if (ata_msg_ctl(ap))
@@ -1698,11 +1704,31 @@ int ata_dev_read_id(struct ata_device *dev, unsigned int *p_class,
 			return -ENOENT;
 		}
 
+		/* Device or controller might have reported the wrong
+		 * device class.  Give a shot at the other IDENTIFY if
+		 * the current one is aborted by the device.
+		 */
+		if (may_fallback &&
+		    (err_mask == AC_ERR_DEV) && (tf.feature & ATA_ABORTED)) {
+			may_fallback = 0;
+
+			if (class == ATA_DEV_ATA)
+				class = ATA_DEV_ATAPI;
+			else
+				class = ATA_DEV_ATA;
+			goto retry;
+		}
+
 		rc = -EIO;
 		reason = "I/O error";
 		goto err_out;
 	}
 
+	/* Falling back doesn't make sense if ID data was read
+	 * successfully at least once.
+	 */
+	may_fallback = 0;
+
 	swap_buf_le16(id, ATA_ID_WORDS);
 
 	/* sanity check */
@@ -1843,7 +1869,7 @@ int ata_dev_configure(struct ata_device *dev)
 		ata_dev_printk(dev, KERN_DEBUG, "%s: ENTER\n", __FUNCTION__);
 
 	/* set _SDD */
-	rc = ata_acpi_push_id(ap, dev->devno);
+	rc = ata_acpi_push_id(dev);
 	if (rc) {
 		ata_dev_printk(dev, KERN_WARNING, "failed to set _SDD(%d)\n",
 			rc);
@@ -2860,7 +2886,7 @@ int ata_do_set_mode(struct ata_port *ap, struct ata_device **r_failed_dev)
 		dev = &ap->device[i];
 
 		/* don't update suspended devices' xfer mode */
-		if (!ata_dev_ready(dev))
+		if (!ata_dev_enabled(dev))
 			continue;
 
 		rc = ata_dev_set_mode(dev);
@@ -5845,37 +5871,11 @@ static int ata_host_request_pm(struct ata_host *host, pm_message_t mesg,
  */
 int ata_host_suspend(struct ata_host *host, pm_message_t mesg)
 {
-	int i, j, rc;
+	int rc;
 
 	rc = ata_host_request_pm(host, mesg, 0, ATA_EHI_QUIET, 1);
-	if (rc)
-		goto fail;
-
-	/* EH is quiescent now.  Fail if we have any ready device.
-	 * This happens if hotplug occurs between completion of device
-	 * suspension and here.
-	 */
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		for (j = 0; j < ATA_MAX_DEVICES; j++) {
-			struct ata_device *dev = &ap->device[j];
-
-			if (ata_dev_ready(dev)) {
-				ata_port_printk(ap, KERN_WARNING,
-						"suspend failed, device %d "
-						"still active\n", dev->devno);
-				rc = -EBUSY;
-				goto fail;
-			}
-		}
-	}
-
-	host->dev->power.power_state = mesg;
-	return 0;
-
- fail:
-	ata_host_resume(host);
+	if (rc == 0)
+		host->dev->power.power_state = mesg;
 	return rc;
 }
 
@@ -5984,6 +5984,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
 	if (!ap)
 		return NULL;
 
+	ap->pflags |= ATA_PFLAG_INITIALIZING;
 	ap->lock = &host->lock;
 	ap->flags = ATA_FLAG_DISABLED;
 	ap->print_id = -1;
@@ -6352,6 +6353,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 			ehi->action |= ATA_EH_SOFTRESET;
 			ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
 
+			ap->pflags &= ~ATA_PFLAG_INITIALIZING;
 			ap->pflags |= ATA_PFLAG_LOADING;
 			ata_port_schedule_eh(ap);
 
@@ -6876,6 +6878,7 @@ EXPORT_SYMBOL_GPL(ata_timing_merge);
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL_GPL(pci_test_config_bits);
 EXPORT_SYMBOL_GPL(ata_pci_init_native_host);
+EXPORT_SYMBOL_GPL(ata_pci_init_bmdma);
 EXPORT_SYMBOL_GPL(ata_pci_prepare_native_host);
 EXPORT_SYMBOL_GPL(ata_pci_init_one);
 EXPORT_SYMBOL_GPL(ata_pci_remove_one);
@@ -6889,11 +6892,6 @@ EXPORT_SYMBOL_GPL(ata_pci_default_filter);
 EXPORT_SYMBOL_GPL(ata_pci_clear_simplex);
 #endif /* CONFIG_PCI */
 
-#ifdef CONFIG_PM
-EXPORT_SYMBOL_GPL(ata_scsi_device_suspend);
-EXPORT_SYMBOL_GPL(ata_scsi_device_resume);
-#endif /* CONFIG_PM */
-
 EXPORT_SYMBOL_GPL(ata_eng_timeout);
 EXPORT_SYMBOL_GPL(ata_port_schedule_eh);
 EXPORT_SYMBOL_GPL(ata_port_abort);
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 8256655..5309c31 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -77,29 +77,12 @@ static void ata_eh_finish(struct ata_port *ap);
 #ifdef CONFIG_PM
 static void ata_eh_handle_port_suspend(struct ata_port *ap);
 static void ata_eh_handle_port_resume(struct ata_port *ap);
-static int ata_eh_suspend(struct ata_port *ap,
-			  struct ata_device **r_failed_dev);
-static void ata_eh_prep_resume(struct ata_port *ap);
-static int ata_eh_resume(struct ata_port *ap, struct ata_device **r_failed_dev);
 #else /* CONFIG_PM */
 static void ata_eh_handle_port_suspend(struct ata_port *ap)
 { }
 
 static void ata_eh_handle_port_resume(struct ata_port *ap)
 { }
-
-static int ata_eh_suspend(struct ata_port *ap, struct ata_device **r_failed_dev)
-{
-	return 0;
-}
-
-static void ata_eh_prep_resume(struct ata_port *ap)
-{ }
-
-static int ata_eh_resume(struct ata_port *ap, struct ata_device **r_failed_dev)
-{
-	return 0;
-}
 #endif /* CONFIG_PM */
 
 static void ata_ering_record(struct ata_ering *ering, int is_io,
@@ -568,6 +551,9 @@ void ata_port_schedule_eh(struct ata_port *ap)
 {
 	WARN_ON(!ap->ops->error_handler);
 
+	if (ap->pflags & ATA_PFLAG_INITIALIZING)
+		return;
+
 	ap->pflags |= ATA_PFLAG_EH_PENDING;
 	scsi_schedule_eh(ap->scsi_host);
 
@@ -1791,7 +1777,7 @@ static int ata_eh_revalidate_and_attach(struct ata_port *ap,
 		if (ehc->i.flags & ATA_EHI_DID_RESET)
 			readid_flags |= ATA_READID_POSTRESET;
 
-		if (action & ATA_EH_REVALIDATE && ata_dev_ready(dev)) {
+		if ((action & ATA_EH_REVALIDATE) && ata_dev_enabled(dev)) {
 			if (ata_port_offline(ap)) {
 				rc = -EIO;
 				goto err;
@@ -1872,166 +1858,6 @@ static int ata_eh_revalidate_and_attach(struct ata_port *ap,
 	return rc;
 }
 
-#ifdef CONFIG_PM
-/**
- *	ata_eh_suspend - handle suspend EH action
- *	@ap: target host port
- *	@r_failed_dev: result parameter to indicate failing device
- *
- *	Handle suspend EH action.  Disk devices are spinned down and
- *	other types of devices are just marked suspended.  Once
- *	suspended, no EH action to the device is allowed until it is
- *	resumed.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise
- */
-static int ata_eh_suspend(struct ata_port *ap, struct ata_device **r_failed_dev)
-{
-	struct ata_device *dev;
-	int i, rc = 0;
-
-	DPRINTK("ENTER\n");
-
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
-		unsigned long flags;
-		unsigned int action, err_mask;
-
-		dev = &ap->device[i];
-		action = ata_eh_dev_action(dev);
-
-		if (!ata_dev_enabled(dev) || !(action & ATA_EH_SUSPEND))
-			continue;
-
-		WARN_ON(dev->flags & ATA_DFLAG_SUSPENDED);
-
-		ata_eh_about_to_do(ap, dev, ATA_EH_SUSPEND);
-
-		if (dev->class == ATA_DEV_ATA && !(action & ATA_EH_PM_FREEZE)) {
-			/* flush cache */
-			rc = ata_flush_cache(dev);
-			if (rc)
-				break;
-
-			/* spin down */
-			err_mask = ata_do_simple_cmd(dev, ATA_CMD_STANDBYNOW1);
-			if (err_mask) {
-				ata_dev_printk(dev, KERN_ERR, "failed to "
-					       "spin down (err_mask=0x%x)\n",
-					       err_mask);
-				rc = -EIO;
-				break;
-			}
-		}
-
-		spin_lock_irqsave(ap->lock, flags);
-		dev->flags |= ATA_DFLAG_SUSPENDED;
-		spin_unlock_irqrestore(ap->lock, flags);
-
-		ata_eh_done(ap, dev, ATA_EH_SUSPEND);
-	}
-
-	if (rc)
-		*r_failed_dev = dev;
-
-	DPRINTK("EXIT\n");
-	return rc;
-}
-
-/**
- *	ata_eh_prep_resume - prep for resume EH action
- *	@ap: target host port
- *
- *	Clear SUSPENDED in preparation for scheduled resume actions.
- *	This allows other parts of EH to access the devices being
- *	resumed.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- */
-static void ata_eh_prep_resume(struct ata_port *ap)
-{
-	struct ata_device *dev;
-	unsigned long flags;
-	int i;
-
-	DPRINTK("ENTER\n");
-
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
-		unsigned int action;
-
-		dev = &ap->device[i];
-		action = ata_eh_dev_action(dev);
-
-		if (!ata_dev_enabled(dev) || !(action & ATA_EH_RESUME))
-			continue;
-
-		spin_lock_irqsave(ap->lock, flags);
-		dev->flags &= ~ATA_DFLAG_SUSPENDED;
-		spin_unlock_irqrestore(ap->lock, flags);
-	}
-
-	DPRINTK("EXIT\n");
-}
-
-/**
- *	ata_eh_resume - handle resume EH action
- *	@ap: target host port
- *	@r_failed_dev: result parameter to indicate failing device
- *
- *	Handle resume EH action.  Target devices are already reset and
- *	revalidated.  Spinning up is the only operation left.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise
- */
-static int ata_eh_resume(struct ata_port *ap, struct ata_device **r_failed_dev)
-{
-	struct ata_device *dev;
-	int i, rc = 0;
-
-	DPRINTK("ENTER\n");
-
-	for (i = 0; i < ATA_MAX_DEVICES; i++) {
-		unsigned int action, err_mask;
-
-		dev = &ap->device[i];
-		action = ata_eh_dev_action(dev);
-
-		if (!ata_dev_enabled(dev) || !(action & ATA_EH_RESUME))
-			continue;
-
-		ata_eh_about_to_do(ap, dev, ATA_EH_RESUME);
-
-		if (dev->class == ATA_DEV_ATA && !(action & ATA_EH_PM_FREEZE)) {
-			err_mask = ata_do_simple_cmd(dev,
-						     ATA_CMD_IDLEIMMEDIATE);
-			if (err_mask) {
-				ata_dev_printk(dev, KERN_ERR, "failed to "
-					       "spin up (err_mask=0x%x)\n",
-					       err_mask);
-				rc = -EIO;
-				break;
-			}
-		}
-
-		ata_eh_done(ap, dev, ATA_EH_RESUME);
-	}
-
-	if (rc)
-		*r_failed_dev = dev;
-
-	DPRINTK("EXIT\n");
-	return 0;
-}
-#endif /* CONFIG_PM */
-
 static int ata_port_nr_enabled(struct ata_port *ap)
 {
 	int i, cnt = 0;
@@ -2057,17 +1883,6 @@ static int ata_eh_skip_recovery(struct ata_port *ap)
 	struct ata_eh_context *ehc = &ap->eh_context;
 	int i;
 
-	/* skip if all possible devices are suspended */
-	for (i = 0; i < ata_port_max_devices(ap); i++) {
-		struct ata_device *dev = &ap->device[i];
-
-		if (!(dev->flags & ATA_DFLAG_SUSPENDED))
-			break;
-	}
-
-	if (i == ata_port_max_devices(ap))
-		return 1;
-
 	/* thaw frozen port, resume link and recover failed devices */
 	if ((ap->pflags & ATA_PFLAG_FROZEN) ||
 	    (ehc->i.flags & ATA_EHI_RESUME_LINK) || ata_port_nr_enabled(ap))
@@ -2147,9 +1962,6 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	if (ap->pflags & ATA_PFLAG_UNLOADING)
 		goto out;
 
-	/* prep for resume */
-	ata_eh_prep_resume(ap);
-
 	/* skip EH if possible. */
 	if (ata_eh_skip_recovery(ap))
 		ehc->i.action = 0;
@@ -2177,11 +1989,6 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 	if (rc)
 		goto dev_fail;
 
-	/* resume devices */
-	rc = ata_eh_resume(ap, &dev);
-	if (rc)
-		goto dev_fail;
-
 	/* configure transfer mode if necessary */
 	if (ehc->i.flags & ATA_EHI_SETMODE) {
 		rc = ata_set_mode(ap, &dev);
@@ -2190,25 +1997,16 @@ static int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
 		ehc->i.flags &= ~ATA_EHI_SETMODE;
 	}
 
-	/* suspend devices */
-	rc = ata_eh_suspend(ap, &dev);
-	if (rc)
-		goto dev_fail;
-
 	goto out;
 
  dev_fail:
 	ehc->tries[dev->devno]--;
 
 	switch (rc) {
-	case -EINVAL:
-		/* eeek, something went very wrong, give up */
-		ehc->tries[dev->devno] = 0;
-		break;
-
 	case -ENODEV:
 		/* device missing or wrong IDENTIFY data, schedule probing */
 		ehc->i.probe_mask |= (1 << dev->devno);
+	case -EINVAL:
 		/* give it just one more chance */
 		ehc->tries[dev->devno] = min(ehc->tries[dev->devno], 1);
 	case -EIO:
@@ -2390,22 +2188,13 @@ static void ata_eh_handle_port_suspend(struct ata_port *ap)
  *
  *	Resume @ap.
  *
- *	This function also waits upto one second until all devices
- *	hanging off this port requests resume EH action.  This is to
- *	prevent invoking EH and thus reset multiple times on resume.
- *
- *	On DPM resume, where some of devices might not be resumed
- *	together, this may delay port resume upto one second, but such
- *	DPM resumes are rare and 1 sec delay isn't too bad.
- *
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
 static void ata_eh_handle_port_resume(struct ata_port *ap)
 {
-	unsigned long timeout;
 	unsigned long flags;
-	int i, rc = 0;
+	int rc = 0;
 
 	/* are we resuming? */
 	spin_lock_irqsave(ap->lock, flags);
@@ -2416,31 +2205,12 @@ static void ata_eh_handle_port_resume(struct ata_port *ap)
 	}
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	/* spurious? */
-	if (!(ap->pflags & ATA_PFLAG_SUSPENDED))
-		goto done;
+	WARN_ON(!(ap->pflags & ATA_PFLAG_SUSPENDED));
 
 	if (ap->ops->port_resume)
 		rc = ap->ops->port_resume(ap);
 
-	/* give devices time to request EH */
-	timeout = jiffies + HZ; /* 1s max */
-	while (1) {
-		for (i = 0; i < ATA_MAX_DEVICES; i++) {
-			struct ata_device *dev = &ap->device[i];
-			unsigned int action = ata_eh_dev_action(dev);
-
-			if ((dev->flags & ATA_DFLAG_SUSPENDED) &&
-			    !(action & ATA_EH_RESUME))
-				break;
-		}
-
-		if (i == ATA_MAX_DEVICES || time_after(jiffies, timeout))
-			break;
-		msleep(10);
-	}
-
- done:
+	/* report result */
 	spin_lock_irqsave(ap->lock, flags);
 	ap->pflags &= ~(ATA_PFLAG_PM_PENDING | ATA_PFLAG_SUSPENDED);
 	if (ap->pm_result) {
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9afba2b..dd81fa7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -510,133 +510,6 @@ static void ata_dump_status(unsigned id, struct ata_taskfile *tf)
 	}
 }
 
-#ifdef CONFIG_PM
-/**
- *	ata_scsi_device_suspend - suspend ATA device associated with sdev
- *	@sdev: the SCSI device to suspend
- *	@mesg: target power management message
- *
- *	Request suspend EH action on the ATA device associated with
- *	@sdev and wait for the operation to complete.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0 on success, -errno otherwise.
- */
-int ata_scsi_device_suspend(struct scsi_device *sdev, pm_message_t mesg)
-{
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
-	unsigned long flags;
-	unsigned int action;
-	int rc = 0;
-
-	if (!dev)
-		goto out;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	/* wait for the previous resume to complete */
-	while (dev->flags & ATA_DFLAG_SUSPENDED) {
-		spin_unlock_irqrestore(ap->lock, flags);
-		ata_port_wait_eh(ap);
-		spin_lock_irqsave(ap->lock, flags);
-	}
-
-	/* if @sdev is already detached, nothing to do */
-	if (sdev->sdev_state == SDEV_OFFLINE ||
-	    sdev->sdev_state == SDEV_CANCEL || sdev->sdev_state == SDEV_DEL)
-		goto out_unlock;
-
-	/* request suspend */
-	action = ATA_EH_SUSPEND;
-	if (mesg.event != PM_EVENT_SUSPEND)
-		action |= ATA_EH_PM_FREEZE;
-	ap->eh_info.dev_action[dev->devno] |= action;
-	ap->eh_info.flags |= ATA_EHI_QUIET;
-	ata_port_schedule_eh(ap);
-
-	spin_unlock_irqrestore(ap->lock, flags);
-
-	/* wait for EH to do the job */
-	ata_port_wait_eh(ap);
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	/* If @sdev is still attached but the associated ATA device
-	 * isn't suspended, the operation failed.
-	 */
-	if (sdev->sdev_state != SDEV_OFFLINE &&
-	    sdev->sdev_state != SDEV_CANCEL && sdev->sdev_state != SDEV_DEL &&
-	    !(dev->flags & ATA_DFLAG_SUSPENDED))
-		rc = -EIO;
-
- out_unlock:
-	spin_unlock_irqrestore(ap->lock, flags);
- out:
-	if (rc == 0)
-		sdev->sdev_gendev.power.power_state = mesg;
-	return rc;
-}
-
-/**
- *	ata_scsi_device_resume - resume ATA device associated with sdev
- *	@sdev: the SCSI device to resume
- *
- *	Request resume EH action on the ATA device associated with
- *	@sdev and return immediately.  This enables parallel
- *	wakeup/spinup of devices.
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- *
- *	RETURNS:
- *	0.
- */
-int ata_scsi_device_resume(struct scsi_device *sdev)
-{
-	struct ata_port *ap = ata_shost_to_port(sdev->host);
-	struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
-	struct ata_eh_info *ehi = &ap->eh_info;
-	unsigned long flags;
-	unsigned int action;
-
-	if (!dev)
-		goto out;
-
-	spin_lock_irqsave(ap->lock, flags);
-
-	/* if @sdev is already detached, nothing to do */
-	if (sdev->sdev_state == SDEV_OFFLINE ||
-	    sdev->sdev_state == SDEV_CANCEL || sdev->sdev_state == SDEV_DEL)
-		goto out_unlock;
-
-	/* request resume */
-	action = ATA_EH_RESUME;
-	if (sdev->sdev_gendev.power.power_state.event == PM_EVENT_SUSPEND)
-		__ata_ehi_hotplugged(ehi);
-	else
-		action |= ATA_EH_PM_FREEZE | ATA_EH_SOFTRESET;
-	ehi->dev_action[dev->devno] |= action;
-
-	/* We don't want autopsy and verbose EH messages.  Disable
-	 * those if we're the only device on this link.
-	 */
-	if (ata_port_max_devices(ap) == 1)
-		ehi->flags |= ATA_EHI_NO_AUTOPSY | ATA_EHI_QUIET;
-
-	ata_port_schedule_eh(ap);
-
- out_unlock:
-	spin_unlock_irqrestore(ap->lock, flags);
- out:
-	sdev->sdev_gendev.power.power_state = PMSG_ON;
-	return 0;
-}
-#endif /* CONFIG_PM */
-
 /**
  *	ata_to_sense_error - convert ATA error to SCSI error
  *	@id: ATA device number
@@ -929,6 +802,8 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
 
 	blk_queue_max_phys_segments(sdev->request_queue, LIBATA_MAX_PRD);
 
+	sdev->manage_start_stop = 1;
+
 	if (dev)
 		ata_scsi_dev_config(sdev, dev);
 
@@ -1069,9 +944,35 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		}
 
 		tf->command = ATA_CMD_VERIFY;	/* READ VERIFY */
-	} else
+	} else {
+		/* XXX: This is for backward compatibility, will be
+		 * removed.  Read Documentation/feature-removal-schedule.txt
+		 * for more info.
+		 */
+		if (ata_spindown_compat &&
+		    (system_state == SYSTEM_HALT ||
+		     system_state == SYSTEM_POWER_OFF)) {
+			static int warned = 0;
+
+			if (!warned) {
+				spin_unlock_irq(qc->ap->lock);
+				ata_dev_printk(qc->dev, KERN_WARNING,
+					"DISK MIGHT NOT BE SPUN DOWN PROPERLY. "
+					"UPDATE SHUTDOWN UTILITY\n");
+				ata_dev_printk(qc->dev, KERN_WARNING,
+					"For more info, visit "
+					"http://linux-ata.org/shutdown.html\n");
+				warned = 1;
+				ssleep(5);
+				spin_lock_irq(qc->ap->lock);
+			}
+			scmd->result = SAM_STAT_GOOD;
+			return 1;
+		}
+
 		/* Issue ATA STANDBY IMMEDIATE command */
 		tf->command = ATA_CMD_STANDBYNOW1;
+	}
 
 	/*
 	 * Standby and Idle condition timers could be implemented but that
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index d211db6..e35d134 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -544,7 +544,7 @@ static int ata_resources_present(struct pci_dev *pdev, int port)
  *	RETURNS:
  *	0 on success, -errno otherwise.
  */
-static int ata_pci_init_bmdma(struct ata_host *host)
+int ata_pci_init_bmdma(struct ata_host *host)
 {
 	struct device *gdev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(gdev);
@@ -566,7 +566,7 @@ static int ata_pci_init_bmdma(struct ata_host *host)
 	}
 	host->iomap = pcim_iomap_table(pdev);
 
-	for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < 2; i++) {
 		struct ata_port *ap = host->ports[i];
 		void __iomem *bmdma = host->iomap[4] + 8 * i;
 
@@ -585,54 +585,52 @@ static int ata_pci_init_bmdma(struct ata_host *host)
 /**
  *	ata_pci_init_native_host - acquire native ATA resources and init host
  *	@host: target ATA host
- *	@port_mask: ports to consider
  *
- *	Acquire native PCI ATA resources for @host and initialize
- *	@host accordoingly.
+ *	Acquire native PCI ATA resources for @host and initialize the
+ *	first two ports of @host accordingly.  Ports marked dummy are
+ *	skipped and allocation failure makes the port dummy.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
  *	RETURNS:
- *	0 on success, -errno otherwise.
+ *	0 if at least one port is initialized, -ENODEV if no port is
+ *	available.
  */
-int ata_pci_init_native_host(struct ata_host *host, unsigned int port_mask)
+int ata_pci_init_native_host(struct ata_host *host)
 {
 	struct device *gdev = host->dev;
 	struct pci_dev *pdev = to_pci_dev(gdev);
+	unsigned int mask = 0;
 	int i, rc;
 
-	/* Discard disabled ports.  Some controllers show their unused
-	 * channels this way.  Disabled ports are made dummy.
-	 */
-	for (i = 0; i < 2; i++) {
-		if ((port_mask & (1 << i)) && !ata_resources_present(pdev, i)) {
-			host->ports[i]->ops = &ata_dummy_port_ops;
-			port_mask &= ~(1 << i);
-		}
-	}
-
-	if (!port_mask) {
-		dev_printk(KERN_ERR, gdev, "no available port\n");
-		return -ENODEV;
-	}
-
 	/* request, iomap BARs and init port addresses accordingly */
 	for (i = 0; i < 2; i++) {
 		struct ata_port *ap = host->ports[i];
 		int base = i * 2;
 		void __iomem * const *iomap;
 
-		if (!(port_mask & (1 << i)))
+		if (ata_port_is_dummy(ap))
+			continue;
+
+		/* Discard disabled ports.  Some controllers show
+		 * their unused channels this way.  Disabled ports are
+		 * made dummy.
+		 */
+		if (!ata_resources_present(pdev, i)) {
+			ap->ops = &ata_dummy_port_ops;
 			continue;
+		}
 
 		rc = pcim_iomap_regions(pdev, 0x3 << base, DRV_NAME);
 		if (rc) {
-			dev_printk(KERN_ERR, gdev, "failed to request/iomap "
-				   "BARs for port %d (errno=%d)\n", i, rc);
+			dev_printk(KERN_WARNING, gdev,
+				   "failed to request/iomap BARs for port %d "
+				   "(errno=%d)\n", i, rc);
 			if (rc == -EBUSY)
 				pcim_pin_device(pdev);
-			return rc;
+			ap->ops = &ata_dummy_port_ops;
+			continue;
 		}
 		host->iomap = iomap = pcim_iomap_table(pdev);
 
@@ -641,6 +639,13 @@ int ata_pci_init_native_host(struct ata_host *host, unsigned int port_mask)
 		ap->ioaddr.ctl_addr = (void __iomem *)
 			((unsigned long)iomap[base + 1] | ATA_PCI_CTL_OFS);
 		ata_std_ports(&ap->ioaddr);
+
+		mask |= 1 << i;
+	}
+
+	if (!mask) {
+		dev_printk(KERN_ERR, gdev, "no available native port\n");
+		return -ENODEV;
 	}
 
 	return 0;
@@ -649,8 +654,7 @@ int ata_pci_init_native_host(struct ata_host *host, unsigned int port_mask)
 /**
  *	ata_pci_prepare_native_host - helper to prepare native PCI ATA host
  *	@pdev: target PCI device
- *	@ppi: array of port_info
- *	@n_ports: number of ports to allocate
+ *	@ppi: array of port_info, must be enough for two ports
  *	@r_host: out argument for the initialized ATA host
  *
  *	Helper to allocate ATA host for @pdev, acquire all native PCI
@@ -664,10 +668,9 @@ int ata_pci_init_native_host(struct ata_host *host, unsigned int port_mask)
  */
 int ata_pci_prepare_native_host(struct pci_dev *pdev,
 				const struct ata_port_info * const * ppi,
-				int n_ports, struct ata_host **r_host)
+				struct ata_host **r_host)
 {
 	struct ata_host *host;
-	unsigned int port_mask;
 	int rc;
 
 	if (!devres_open_group(&pdev->dev, NULL, GFP_KERNEL))
@@ -681,11 +684,7 @@ int ata_pci_prepare_native_host(struct pci_dev *pdev,
 		goto err_out;
 	}
 
-	port_mask = ATA_PORT_PRIMARY;
-	if (n_ports > 1)
-		port_mask |= ATA_PORT_SECONDARY;
-
-	rc = ata_pci_init_native_host(host, port_mask);
+	rc = ata_pci_init_native_host(host);
 	if (rc)
 		goto err_out;
 
@@ -777,8 +776,11 @@ static int ata_init_legacy_port(struct ata_port *ap,
 	/* iomap cmd and ctl ports */
 	legacy_dr->cmd_addr[port_no] = ioport_map(cmd_port, 8);
 	legacy_dr->ctl_addr[port_no] = ioport_map(ctl_port, 1);
-	if (!legacy_dr->cmd_addr[port_no] || !legacy_dr->ctl_addr[port_no])
+	if (!legacy_dr->cmd_addr[port_no] || !legacy_dr->ctl_addr[port_no]) {
+		dev_printk(KERN_WARNING, host->dev,
+			   "failed to map cmd/ctl ports\n");
 		return -ENOMEM;
+	}
 
 	/* init IO addresses */
 	ap->ioaddr.cmd_addr = legacy_dr->cmd_addr[port_no];
@@ -792,19 +794,20 @@ static int ata_init_legacy_port(struct ata_port *ap,
 /**
  *	ata_init_legacy_host - acquire legacy ATA resources and init ATA host
  *	@host: target ATA host
- *	@legacy_mask: out parameter, mask indicating ports is in legacy mode
  *	@was_busy: out parameter, indicates whether any port was busy
  *
- *	Acquire legacy ATA resources for ports.
+ *	Acquire legacy ATA resources for the first two ports of @host
+ *	and initialize it accordingly.  Ports marked dummy are skipped
+ *	and resource acquistion failure makes the port dummy.
  *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
  *	RETURNS:
- *	0 on success, -errno otherwise.
+ *	0 if at least one port is initialized, -ENODEV if no port is
+ *	available.
  */
-static int ata_init_legacy_host(struct ata_host *host,
-				unsigned int *legacy_mask, int *was_busy)
+static int ata_init_legacy_host(struct ata_host *host, int *was_busy)
 {
 	struct device *gdev = host->dev;
 	struct ata_legacy_devres *legacy_dr;
@@ -821,22 +824,23 @@ static int ata_init_legacy_host(struct ata_host *host,
 	devres_add(gdev, legacy_dr);
 
 	for (i = 0; i < 2; i++) {
-		*legacy_mask &= ~(1 << i);
+		if (ata_port_is_dummy(host->ports[i]))
+			continue;
+
 		rc = ata_init_legacy_port(host->ports[i], legacy_dr);
 		if (rc == 0)
 			legacy_dr->mask |= 1 << i;
-		else if (rc == -EBUSY)
-			(*was_busy)++;
-	}
-
-	if (!legacy_dr->mask)
-		return -EBUSY;
-
-	for (i = 0; i < 2; i++)
-		if (!(legacy_dr->mask & (1 << i)))
+		else {
+			if (rc == -EBUSY)
+				(*was_busy)++;
 			host->ports[i]->ops = &ata_dummy_port_ops;
+		}
+	}
 
-	*legacy_mask |= legacy_dr->mask;
+	if (!legacy_dr->mask) {
+		dev_printk(KERN_ERR, gdev, "no available legacy port\n");
+		return -ENODEV;
+	}
 
 	devres_remove_group(gdev, NULL);
 	return 0;
@@ -875,7 +879,7 @@ static int ata_request_legacy_irqs(struct ata_host *host,
 	legacy_dr = devres_find(host->dev, ata_legacy_release, NULL, NULL);
 	BUG_ON(!legacy_dr);
 
-	for (i = 0; i < host->n_ports; i++) {
+	for (i = 0; i < 2; i++) {
 		unsigned int irq;
 
 		/* FIXME: ATA_*_IRQ() should take generic device not pci_dev */
@@ -923,8 +927,7 @@ static int ata_request_legacy_irqs(struct ata_host *host,
 /**
  *	ata_pci_init_one - Initialize/register PCI IDE host controller
  *	@pdev: Controller to be initialized
- *	@port_info: Information from low-level host driver
- *	@n_ports: Number of ports attached to host controller
+ *	@ppi: array of port_info, must be enough for two ports
  *
  *	This is a helper function which can be called from a driver's
  *	xxx_init_one() probe function if the hardware uses traditional
@@ -944,26 +947,34 @@ static int ata_request_legacy_irqs(struct ata_host *host,
  *	RETURNS:
  *	Zero on success, negative on errno-based value on error.
  */
-
-int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
-		      unsigned int n_ports)
+int ata_pci_init_one(struct pci_dev *pdev,
+		     const struct ata_port_info * const * ppi)
 {
 	struct device *dev = &pdev->dev;
+	const struct ata_port_info *pi = NULL;
 	struct ata_host *host = NULL;
-	const struct ata_port_info *port[2];
 	u8 mask;
-	unsigned int legacy_mode = 0;
-	int rc;
+	int legacy_mode = 0;
+	int i, rc;
 
 	DPRINTK("ENTER\n");
 
-	if (!devres_open_group(dev, NULL, GFP_KERNEL))
-		return -ENOMEM;
+	/* look up the first valid port_info */
+	for (i = 0; i < 2 && ppi[i]; i++) {
+		if (ppi[i]->port_ops != &ata_dummy_port_ops) {
+			pi = ppi[i];
+			break;
+		}
+	}
 
-	BUG_ON(n_ports < 1 || n_ports > 2);
+	if (!pi) {
+		dev_printk(KERN_ERR, &pdev->dev,
+			   "no valid port_info specified\n");
+		return -EINVAL;
+	}
 
-	port[0] = port_info[0];
-	port[1] = (n_ports > 1) ? port_info[1] : NULL;
+	if (!devres_open_group(dev, NULL, GFP_KERNEL))
+		return -ENOMEM;
 
 	/* FIXME: Really for ATA it isn't safe because the device may be
 	   multi-purpose and we want to leave it alone if it was already
@@ -984,7 +995,7 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 		pci_read_config_byte(pdev, PCI_CLASS_PROG, &tmp8);
 		mask = (1 << 2) | (1 << 0);
 		if ((tmp8 & mask) != mask)
-			legacy_mode = (1 << 3);
+			legacy_mode = 1;
 #if defined(CONFIG_NO_ATA_LEGACY)
 		/* Some platforms with PCI limits cannot address compat
 		   port space. In that case we punt if their firmware has
@@ -998,7 +1009,7 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 	}
 
 	/* alloc and init host */
-	host = ata_host_alloc_pinfo(dev, port, n_ports);
+	host = ata_host_alloc_pinfo(dev, ppi, 2);
 	if (!host) {
 		dev_printk(KERN_ERR, &pdev->dev,
 			   "failed to allocate ATA host\n");
@@ -1007,19 +1018,13 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 	}
 
 	if (!legacy_mode) {
-		unsigned int port_mask;
-
-		port_mask = ATA_PORT_PRIMARY;
-		if (n_ports > 1)
-			port_mask |= ATA_PORT_SECONDARY;
-
-		rc = ata_pci_init_native_host(host, port_mask);
+		rc = ata_pci_init_native_host(host);
 		if (rc)
 			goto err_out;
 	} else {
 		int was_busy = 0;
 
-		rc = ata_init_legacy_host(host, &legacy_mode, &was_busy);
+		rc = ata_init_legacy_host(host, &was_busy);
 		if (was_busy)
 			pcim_pin_device(pdev);
 		if (rc)
@@ -1040,8 +1045,7 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 		goto err_out;
 
 	if (!legacy_mode)
-		rc = devm_request_irq(dev, pdev->irq,
-				      port_info[0]->port_ops->irq_handler,
+		rc = devm_request_irq(dev, pdev->irq, pi->port_ops->irq_handler,
 				      IRQF_SHARED, DRV_NAME, host);
 	else {
 		irq_handler_t handler[2] = { host->ops->irq_handler,
@@ -1055,7 +1059,7 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 		goto err_out;
 
 	/* register */
-	rc = ata_host_register(host, port_info[0]->sht);
+	rc = ata_host_register(host, pi->sht);
 	if (rc)
 		goto err_out;
 
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5f4d40c..8b71b73 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -58,6 +58,7 @@ extern int atapi_enabled;
 extern int atapi_dmadir;
 extern int libata_fua;
 extern int libata_noacpi;
+extern int ata_spindown_compat;
 extern struct ata_queued_cmd *ata_qc_new_init(struct ata_device *dev);
 extern int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
 			   u64 block, u32 n_block, unsigned int tf_flags,
@@ -96,15 +97,15 @@ extern int ata_cmd_ioctl(struct scsi_device *scsidev, void __user *arg);
 extern struct ata_port *ata_port_alloc(struct ata_host *host);
 
 /* libata-acpi.c */
-#ifdef CONFIG_SATA_ACPI
+#ifdef CONFIG_ATA_ACPI
 extern int ata_acpi_exec_tfs(struct ata_port *ap);
-extern int ata_acpi_push_id(struct ata_port *ap, unsigned int ix);
+extern int ata_acpi_push_id(struct ata_device *dev);
 #else
 static inline int ata_acpi_exec_tfs(struct ata_port *ap)
 {
 	return 0;
 }
-static inline int ata_acpi_push_id(struct ata_port *ap, unsigned int ix)
+static inline int ata_acpi_push_id(struct ata_device *dev)
 {
 	return 0;
 }
diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index d40edeb..3c55a5f 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -291,10 +291,6 @@ static struct scsi_host_template ali_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 /*
@@ -522,14 +518,14 @@ static void ali_init_chipset(struct pci_dev *pdev)
 
 static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_early = {
+	static const struct ata_port_info info_early = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &ali_early_port_ops
 	};
 	/* Revision 0x20 added DMA */
-	static struct ata_port_info info_20 = {
+	static const struct ata_port_info info_20 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -537,7 +533,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0x20 with support logic added UDMA */
-	static struct ata_port_info info_20_udma = {
+	static const struct ata_port_info info_20_udma = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -546,7 +542,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &ali_20_port_ops
 	};
 	/* Revision 0xC2 adds UDMA66 */
-	static struct ata_port_info info_c2 = {
+	static const struct ata_port_info info_c2 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -555,7 +551,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC3 is UDMA100 */
-	static struct ata_port_info info_c3 = {
+	static const struct ata_port_info info_c3 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -564,7 +560,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC4 is UDMA133 */
-	static struct ata_port_info info_c4 = {
+	static const struct ata_port_info info_c4 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST | ATA_FLAG_PIO_LBA48,
 		.pio_mask = 0x1f,
@@ -573,7 +569,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &ali_c2_port_ops
 	};
 	/* Revision 0xC5 is UDMA133 with LBA48 DMA */
-	static struct ata_port_info info_c5 = {
+	static const struct ata_port_info info_c5 = {
 		.sht = &ali_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -582,7 +578,7 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &ali_c5_port_ops
 	};
 
-	static struct ata_port_info *port_info[2];
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	u8 rev, tmp;
 	struct pci_dev *isa_bridge;
 
@@ -594,17 +590,17 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	 */
 
 	if (rev < 0x20) {
-		port_info[0] = port_info[1] = &info_early;
+		ppi[0] = &info_early;
 	} else if (rev < 0xC2) {
-        	port_info[0] = port_info[1] = &info_20;
+        	ppi[0] = &info_20;
 	} else if (rev == 0xC2) {
-        	port_info[0] = port_info[1] = &info_c2;
+        	ppi[0] = &info_c2;
 	} else if (rev == 0xC3) {
-        	port_info[0] = port_info[1] = &info_c3;
+        	ppi[0] = &info_c3;
 	} else if (rev == 0xC4) {
-        	port_info[0] = port_info[1] = &info_c4;
+        	ppi[0] = &info_c4;
 	} else
-        	port_info[0] = port_info[1] = &info_c5;
+        	ppi[0] = &info_c5;
 
 	ali_init_chipset(pdev);
 
@@ -613,10 +609,10 @@ static int ali_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		/* Are we paired with a UDMA capable chip */
 		pci_read_config_byte(isa_bridge, 0x5E, &tmp);
 		if ((tmp & 0x1E) == 0x12)
-	        	port_info[0] = port_info[1] = &info_20_udma;
+	        	ppi[0] = &info_20_udma;
 		pci_dev_put(isa_bridge);
 	}
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_amd.c b/drivers/ata/pata_amd.c
index 67c7e87..b439351 100644
--- a/drivers/ata/pata_amd.c
+++ b/drivers/ata/pata_amd.c
@@ -324,10 +324,6 @@ static struct scsi_host_template amd_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations amd33_port_ops = {
@@ -542,7 +538,7 @@ static struct ata_port_operations nv133_port_ops = {
 
 static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info[10] = {
+	static const struct ata_port_info info[10] = {
 		{	/* 0: AMD 7401 */
 			.sht = &amd_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -624,7 +620,7 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.port_ops = &amd100_port_ops
 		}
 	};
-	static struct ata_port_info *port_info[2];
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	static int printed_version;
 	int type = id->driver_data;
 	u8 rev;
@@ -656,9 +652,8 @@ static int amd_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		ata_pci_clear_simplex(pdev);
 
 	/* And fire it up */
-
-	port_info[0] = port_info[1] = &info[type];
-	return ata_pci_init_one(pdev, port_info, 2);
+	ppi[0] = &info[type];
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_artop.c b/drivers/ata/pata_artop.c
index ef51940..9861059 100644
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -414,7 +414,7 @@ static const struct ata_port_operations artop6260_ops = {
 static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static int printed_version;
-	static struct ata_port_info info_6210 = {
+	static const struct ata_port_info info_6210 = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -422,7 +422,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask 	= ATA_UDMA2,
 		.port_ops	= &artop6210_ops,
 	};
-	static struct ata_port_info info_626x = {
+	static const struct ata_port_info info_626x = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -430,7 +430,7 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask 	= ATA_UDMA4,
 		.port_ops	= &artop6260_ops,
 	};
-	static struct ata_port_info info_626x_fast = {
+	static const struct ata_port_info info_626x_fast = {
 		.sht		= &artop_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -438,32 +438,30 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask 	= ATA_UDMA5,
 		.port_ops	= &artop6260_ops,
 	};
-	struct ata_port_info *port_info[2];
-	struct ata_port_info *info = NULL;
-	int ports = 2;
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
 	if (id->driver_data == 0) {	/* 6210 variant */
-		info = &info_6210;
+		ppi[0] = &info_6210;
+		ppi[1] = &ata_dummy_port_info;
 		/* BIOS may have left us in UDMA, clear it before libata probe */
 		pci_write_config_byte(pdev, 0x54, 0);
 		/* For the moment (also lacks dsc) */
 		printk(KERN_WARNING "ARTOP 6210 requires serialize functionality not yet supported by libata.\n");
 		printk(KERN_WARNING "Secondary ATA ports will not be activated.\n");
-		ports = 1;
 	}
 	else if (id->driver_data == 1)	/* 6260 */
-		info = &info_626x;
+		ppi[0] = &info_626x;
 	else if (id->driver_data == 2)	{ /* 6260 or 6260 + fast */
 		unsigned long io = pci_resource_start(pdev, 4);
 		u8 reg;
 
-		info = &info_626x;
+		ppi[0] = &info_626x;
 		if (inb(io) & 0x10)
-			info = &info_626x_fast;
+			ppi[0] = &info_626x_fast;
 		/* Mac systems come up with some registers not set as we
 		   will need them */
 
@@ -484,10 +482,9 @@ static int artop_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 
 	}
 
-	BUG_ON(info == NULL);
+	BUG_ON(ppi[0] == NULL);
 
-	port_info[0] = port_info[1] = info;
-	return ata_pci_init_one(pdev, port_info, ports);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id artop_pci_tbl[] = {
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 2151538..8449146 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -229,10 +229,6 @@ static struct scsi_host_template atiixp_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations atiixp_port_ops = {
@@ -272,7 +268,7 @@ static struct ata_port_operations atiixp_port_ops = {
 
 static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &atiixp_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -280,8 +276,8 @@ static int atiixp_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x3F,
 		.port_ops = &atiixp_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
-	return ata_pci_init_one(dev, port_info, 2);
+	const struct ata_port_info *ppi[] = { &info, NULL };
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id atiixp[] = {
diff --git a/drivers/ata/pata_cmd640.c b/drivers/ata/pata_cmd640.c
index 2105985..ed00fa9 100644
--- a/drivers/ata/pata_cmd640.c
+++ b/drivers/ata/pata_cmd640.c
@@ -181,10 +181,6 @@ static struct scsi_host_template cmd640_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations cmd640_port_ops = {
@@ -253,17 +249,16 @@ static void cmd640_hardware_init(struct pci_dev *pdev)
 
 static int cmd640_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cmd640_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &cmd640_port_ops
 	};
-
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	cmd640_hardware_init(pdev);
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static int cmd640_reinit_one(struct pci_dev *pdev)
diff --git a/drivers/ata/pata_cmd64x.c b/drivers/ata/pata_cmd64x.c
index 3989cc5..2a79b33 100644
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -266,10 +266,6 @@ static struct scsi_host_template cmd64x_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations cmd64x_port_ops = {
@@ -381,7 +377,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	u32 class_rev;
 
-	static struct ata_port_info cmd_info[6] = {
+	static const struct ata_port_info cmd_info[6] = {
 		{	/* CMD 643 - no UDMA */
 			.sht = &cmd64x_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -428,11 +424,9 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 			.port_ops = &cmd648_port_ops
 		}
 	};
-	static struct ata_port_info *port_info[2], *info;
+	const struct ata_port_info *ppi[] = { &cmd_info[id->driver_data], NULL };
 	u8 mrdmode;
 
-	info = &cmd_info[id->driver_data];
-
 	pci_read_config_dword(pdev, PCI_CLASS_REVISION, &class_rev);
 	class_rev &= 0xFF;
 
@@ -442,10 +436,10 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (pdev->device == PCI_DEVICE_ID_CMD_646) {
 		/* Does UDMA work ? */
 		if (class_rev > 4)
-			info = &cmd_info[2];
+			ppi[0] = &cmd_info[2];
 		/* Early rev with other problems ? */
 		else if (class_rev == 1)
-			info = &cmd_info[3];
+			ppi[0] = &cmd_info[3];
 	}
 
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 64);
@@ -461,8 +455,7 @@ static int cmd64x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	pci_write_config_byte(pdev, UDIDETCR0, 0xF0);
 #endif
 
-	port_info[0] = port_info[1] = info;
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 79bef0d..83bcc5b 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -155,10 +155,6 @@ static struct scsi_host_template cs5520_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations cs5520_port_ops = {
diff --git a/drivers/ata/pata_cs5530.c b/drivers/ata/pata_cs5530.c
index 29642d5..1b67923 100644
--- a/drivers/ata/pata_cs5530.c
+++ b/drivers/ata/pata_cs5530.c
@@ -176,10 +176,6 @@ static struct scsi_host_template cs5530_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations cs5530_port_ops = {
@@ -339,7 +335,7 @@ fail_put:
 
 static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cs5530_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -348,23 +344,23 @@ static int cs5530_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &cs5530_port_ops
 	};
 	/* The docking connector doesn't do UDMA, and it seems not MWDMA */
-	static struct ata_port_info info_palmax_secondary = {
+	static const struct ata_port_info info_palmax_secondary = {
 		.sht = &cs5530_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &cs5530_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	/* Chip initialisation */
 	if (cs5530_init_chip())
 		return -ENODEV;
 
 	if (cs5530_is_palmax())
-		port_info[1] = &info_palmax_secondary;
+		ppi[1] = &info_palmax_secondary;
 
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_cs5535.c b/drivers/ata/pata_cs5535.c
index 22006ae..f37d4cd 100644
--- a/drivers/ata/pata_cs5535.c
+++ b/drivers/ata/pata_cs5535.c
@@ -173,10 +173,6 @@ static struct scsi_host_template cs5535_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations cs5535_port_ops = {
@@ -227,7 +223,7 @@ static struct ata_port_operations cs5535_port_ops = {
 
 static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cs5535_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -235,7 +231,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x1f,
 		.port_ops = &cs5535_port_ops
 	};
-	struct ata_port_info *ports[1] = { &info };
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
 	u32 timings, dummy;
 
@@ -247,7 +243,7 @@ static int cs5535_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	rdmsr(ATAC_CH0D1_PIO, timings, dummy);
 	if (CS5535_BAD_PIO(timings))
 		wrmsr(ATAC_CH0D1_PIO, 0xF7F4F7F4UL, 0);
-	return ata_pci_init_one(dev, ports, 1);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id cs5535[] = {
diff --git a/drivers/ata/pata_cypress.c b/drivers/ata/pata_cypress.c
index 6ec049c..27b9f29 100644
--- a/drivers/ata/pata_cypress.c
+++ b/drivers/ata/pata_cypress.c
@@ -125,10 +125,6 @@ static struct scsi_host_template cy82c693_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations cy82c693_port_ops = {
@@ -169,14 +165,14 @@ static struct ata_port_operations cy82c693_port_ops = {
 
 static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &cy82c693_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &cy82c693_port_ops
 	};
-	static struct ata_port_info *port_info[1] = { &info };
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
 	/* Devfn 1 is the ATA primary. The secondary is magic and on devfn2.
 	   For the moment we don't handle the secondary. FIXME */
@@ -184,7 +180,7 @@ static int cy82c693_init_one(struct pci_dev *pdev, const struct pci_device_id *i
 	if (PCI_FUNC(pdev->devfn) != 1)
 		return -ENODEV;
 
-	return ata_pci_init_one(pdev, port_info, 1);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id cy82c693[] = {
diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index d0f52e0..079248a 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -247,10 +247,6 @@ static struct scsi_host_template efar_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations efar_ops = {
@@ -305,7 +301,7 @@ static const struct ata_port_operations efar_ops = {
 static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &efar_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -313,13 +309,13 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		.udma_mask 	= 0x0f, /* UDMA 66 */
 		.port_ops	= &efar_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {
diff --git a/drivers/ata/pata_hpt366.c b/drivers/ata/pata_hpt366.c
index e64e05e..c6c8a8b 100644
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -331,10 +331,6 @@ static struct scsi_host_template hpt36x_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 /*
@@ -421,7 +417,7 @@ static void hpt36x_init_chipset(struct pci_dev *dev)
 
 static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_hpt366 = {
+	static const struct ata_port_info info_hpt366 = {
 		.sht = &hpt36x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -429,7 +425,8 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x1f,
 		.port_ops = &hpt366_port_ops
 	};
-	struct ata_port_info *port_info[2] = {&info_hpt366, &info_hpt366};
+	struct ata_port_info info = info_hpt366;
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	u32 class_rev;
 	u32 reg1;
@@ -450,17 +447,17 @@ static int hpt36x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	/* info_hpt366 is safe against re-entry so we can scribble on it */
 	switch((reg1 & 0x700) >> 8) {
 		case 5:
-			info_hpt366.private_data = &hpt366_40;
+			info.private_data = &hpt366_40;
 			break;
 		case 9:
-			info_hpt366.private_data = &hpt366_25;
+			info.private_data = &hpt366_25;
 			break;
 		default:
-			info_hpt366.private_data = &hpt366_33;
+			info.private_data = &hpt366_33;
 			break;
 	}
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_hpt37x.c b/drivers/ata/pata_hpt37x.c
index 1614e8c..5a0a410 100644
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -887,7 +887,7 @@ static int hpt37x_calibrate_dpll(struct pci_dev *dev)
 static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	/* HPT370 - UDMA100 */
-	static struct ata_port_info info_hpt370 = {
+	static const struct ata_port_info info_hpt370 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -896,7 +896,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
-	static struct ata_port_info info_hpt370a = {
+	static const struct ata_port_info info_hpt370a = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -905,7 +905,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT370 - UDMA100 */
-	static struct ata_port_info info_hpt370_33 = {
+	static const struct ata_port_info info_hpt370_33 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -914,7 +914,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt370_port_ops
 	};
 	/* HPT370A - UDMA100 */
-	static struct ata_port_info info_hpt370a_33 = {
+	static const struct ata_port_info info_hpt370a_33 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -923,7 +923,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt370a_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA133 */
-	static struct ata_port_info info_hpt372 = {
+	static const struct ata_port_info info_hpt372 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -932,7 +932,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT371, 372 and friends - UDMA100 at 50MHz clock */
-	static struct ata_port_info info_hpt372_50 = {
+	static const struct ata_port_info info_hpt372_50 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -941,7 +941,7 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.port_ops = &hpt372_port_ops
 	};
 	/* HPT374 - UDMA133 */
-	static struct ata_port_info info_hpt374 = {
+	static const struct ata_port_info info_hpt374 = {
 		.sht = &hpt37x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -951,9 +951,10 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	};
 
 	static const int MHz[4] = { 33, 40, 50, 66 };
-
-	struct ata_port_info *port_info[2];
-	struct ata_port_info *port;
+	const struct ata_port_info *port;
+	void *private_data = NULL;
+	struct ata_port_info port_info;
+	const struct ata_port_info *ppi[] = { &port_info, NULL };
 
 	u8 irqmask;
 	u32 class_rev;
@@ -1124,13 +1125,13 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 			return -ENODEV;
 		}
 		if (clock_slot == 3)
-			port->private_data = (void *)hpt37x_timings_66;
+			private_data = (void *)hpt37x_timings_66;
 		else
-			port->private_data = (void *)hpt37x_timings_50;
+			private_data = (void *)hpt37x_timings_50;
 
 		printk(KERN_INFO "hpt37x: Bus clock %dMHz, using DPLL.\n", MHz[clock_slot]);
 	} else {
-		port->private_data = (void *)chip_table->clocks[clock_slot];
+		private_data = (void *)chip_table->clocks[clock_slot];
 		/*
 		 *	Perform a final fixup. Note that we will have used the
 		 *	DPLL on the HPT372 which means we don't have to worry
@@ -1144,9 +1145,11 @@ static int hpt37x_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		printk(KERN_INFO "hpt37x: %s: Bus clock %dMHz.\n", chip_table->name, MHz[clock_slot]);
 	}
 
-	port_info[0] = port_info[1] = port;
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, port_info, 2);
+	port_info = *port;
+	port_info.private_data = private_data;
+
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id hpt37x[] = {
diff --git a/drivers/ata/pata_hpt3x2n.c b/drivers/ata/pata_hpt3x2n.c
index ea1037d..f25154a 100644
--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -488,7 +488,7 @@ static int hpt3x2n_pci_clock(struct pci_dev *pdev)
 static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	/* HPT372N and friends - UDMA133 */
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &hpt3x2n_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -496,8 +496,8 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x7f,
 		.port_ops = &hpt3x2n_port_ops
 	};
-	struct ata_port_info *port_info[2];
-	struct ata_port_info *port = &info;
+	struct ata_port_info port = info;
+	const struct ata_port_info *ppi[] = { &port, NULL };
 
 	u8 irqmask;
 	u32 class_rev;
@@ -585,9 +585,9 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
-	port->private_data = NULL;
+	port.private_data = NULL;
 	if (pci_mhz > 60) {
-		port->private_data = (void *)PCI66;
+		port.private_data = (void *)PCI66;
 		/*
 		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
 		 * the MISC. register to stretch the UltraDMA Tss timing.
@@ -598,8 +598,7 @@ static int hpt3x2n_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	}
 
 	/* Now kick off ATA set up */
-	port_info[0] = port_info[1] = port;
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id hpt3x2n[] = {
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index ac28ec8..bbabe79 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -100,10 +100,6 @@ static struct scsi_host_template hpt3x3_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations hpt3x3_port_ops = {
@@ -175,7 +171,7 @@ static void hpt3x3_init_chipset(struct pci_dev *dev)
 
 static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &hpt3x3_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -183,11 +179,11 @@ static int hpt3x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x07,
 		.port_ops = &hpt3x3_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	hpt3x3_init_chipset(dev);
 	/* Now kick off ATA set up */
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_it8213.c b/drivers/ata/pata_it8213.c
index 17bf9f3..a769952 100644
--- a/drivers/ata/pata_it8213.c
+++ b/drivers/ata/pata_it8213.c
@@ -257,10 +257,6 @@ static struct scsi_host_template it8213_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations it8213_ops = {
@@ -315,7 +311,7 @@ static const struct ata_port_operations it8213_ops = {
 static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &it8213_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -323,14 +319,14 @@ static int it8213_init_one (struct pci_dev *pdev, const struct pci_device_id *en
 		.udma_mask 	= 0x1f, /* UDMA 100 */
 		.port_ops	= &it8213_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	/* Current IT8213 stuff is single port */
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	/* Current IT8213 stuff is single port */
-	return ata_pci_init_one(pdev, port_info, 1);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id it8213_pci_tbl[] = {
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index f1f8cec..ff9a6fd 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -620,10 +620,6 @@ static struct scsi_host_template it821x_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations it821x_smart_port_ops = {
@@ -722,14 +718,14 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	u8 conf;
 
-	static struct ata_port_info info_smart = {
+	static const struct ata_port_info info_smart = {
 		.sht = &it821x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &it821x_smart_port_ops
 	};
-	static struct ata_port_info info_passthru = {
+	static const struct ata_port_info info_passthru = {
 		.sht = &it821x_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -737,8 +733,8 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = 0x7f,
 		.port_ops = &it821x_passthru_port_ops
 	};
-	static struct ata_port_info *port_info[2];
 
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	static char *mode[2] = { "pass through", "smart" };
 
 	/* Force the card into bypass mode if so requested */
@@ -751,11 +747,11 @@ static int it821x_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	printk(KERN_INFO DRV_NAME ": controller in %s mode.\n", mode[conf]);
 	if (conf == 0)
-		port_info[0] = port_info[1] = &info_passthru;
+		ppi[0] = &info_passthru;
 	else
-		port_info[0] = port_info[1] = &info_smart;
+		ppi[0] = &info_smart;
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_ixp4xx_cf.c b/drivers/ata/pata_ixp4xx_cf.c
index 420c343..b994351 100644
--- a/drivers/ata/pata_ixp4xx_cf.c
+++ b/drivers/ata/pata_ixp4xx_cf.c
@@ -31,7 +31,7 @@ static int ixp4xx_set_mode(struct ata_port *ap, struct ata_device **error)
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_ready(dev)) {
+		if (ata_dev_enabled(dev)) {
 			ata_dev_printk(dev, KERN_INFO, "configured for PIO0\n");
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
diff --git a/drivers/ata/pata_jmicron.c b/drivers/ata/pata_jmicron.c
index 1daf78a..8d799e8 100644
--- a/drivers/ata/pata_jmicron.c
+++ b/drivers/ata/pata_jmicron.c
@@ -138,10 +138,6 @@ static struct scsi_host_template jmicron_sht = {
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations jmicron_ops = {
@@ -195,7 +191,7 @@ static const struct ata_port_operations jmicron_ops = {
 
 static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &jmicron_sht,
 		.flags	= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 
@@ -205,9 +201,9 @@ static int jmicron_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 		.port_ops	= &jmicron_ops,
 	};
-	struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id jmicron_pci_tbl[] = {
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 837b7fe..edbfe0d 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -107,10 +107,6 @@ static struct scsi_host_template marvell_sht = {
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations marvell_ops = {
@@ -165,7 +161,7 @@ static const struct ata_port_operations marvell_ops = {
 
 static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &marvell_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 
@@ -175,7 +171,7 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 		.port_ops	= &marvell_ops,
 	};
-	static struct ata_port_info info_sata = {
+	static const struct ata_port_info info_sata = {
 		.sht		= &marvell_sht,
 		/* Slave possible as its magically mapped not real */
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -186,13 +182,12 @@ static int marvell_init_one (struct pci_dev *pdev, const struct pci_device_id *i
 
 		.port_ops	= &marvell_ops,
 	};
-	struct ata_port_info *port_info[2] = { &info, &info_sata };
-	int n_port = 2;
+	const struct ata_port_info *ppi[] = { &info, &info_sata };
 
 	if (pdev->device == 0x6101)
-		n_port = 1;
+		ppi[1] = &ata_dummy_port_info;
 
-	return ata_pci_init_one(pdev, port_info, n_port);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id marvell_pci_tbl[] = {
diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index 9587a89..368fac7 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -280,10 +280,6 @@ static struct scsi_host_template mpc52xx_ata_sht = {
 	.dma_boundary		= ATA_DMA_BOUNDARY,
 	.slave_configure	= ata_scsi_slave_config,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static struct ata_port_operations mpc52xx_ata_port_ops = {
diff --git a/drivers/ata/pata_mpiix.c b/drivers/ata/pata_mpiix.c
index 3bfbd49..4ea4283 100644
--- a/drivers/ata/pata_mpiix.c
+++ b/drivers/ata/pata_mpiix.c
@@ -165,10 +165,6 @@ static struct scsi_host_template mpiix_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations mpiix_port_ops = {
diff --git a/drivers/ata/pata_netcell.c b/drivers/ata/pata_netcell.c
index dbba5b7..81f5634 100644
--- a/drivers/ata/pata_netcell.c
+++ b/drivers/ata/pata_netcell.c
@@ -37,10 +37,6 @@ static struct scsi_host_template netcell_sht = {
 	.slave_destroy		= ata_scsi_slave_destroy,
 	/* Use standard CHS mapping rules */
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations netcell_ops = {
@@ -96,7 +92,7 @@ static const struct ata_port_operations netcell_ops = {
 static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &netcell_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		/* Actually we don't really care about these as the
@@ -106,7 +102,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		.udma_mask 	= 0x3f, /* UDMA 133 */
 		.port_ops	= &netcell_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *port_info[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
@@ -116,7 +112,7 @@ static int netcell_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 	ata_pci_clear_simplex(pdev);
 
 	/* And let the library code do the work */
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, port_info);
 }
 
 static const struct pci_device_id netcell_pci_tbl[] = {
diff --git a/drivers/ata/pata_ns87410.c b/drivers/ata/pata_ns87410.c
index ebc58a9..ea70ec7 100644
--- a/drivers/ata/pata_ns87410.c
+++ b/drivers/ata/pata_ns87410.c
@@ -158,10 +158,6 @@ static struct scsi_host_template ns87410_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations ns87410_port_ops = {
@@ -195,14 +191,14 @@ static struct ata_port_operations ns87410_port_ops = {
 
 static int ns87410_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &ns87410_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x0F,
 		.port_ops = &ns87410_port_ops
 	};
-	static struct ata_port_info *port_info[2] = {&info, &info};
-	return ata_pci_init_one(dev, port_info, 2);
+	const struct ata_port_info *ppi[] = { &info, NULL };
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id ns87410[] = {
diff --git a/drivers/ata/pata_oldpiix.c b/drivers/ata/pata_oldpiix.c
index 4d75d32..29c23dd 100644
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -234,10 +234,6 @@ static struct scsi_host_template oldpiix_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations oldpiix_pata_ops = {
@@ -293,20 +289,20 @@ static const struct ata_port_operations oldpiix_pata_ops = {
 static int oldpiix_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &oldpiix_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
 		.mwdma_mask	= 0x07, /* mwdma1-2 */
 		.port_ops	= &oldpiix_pata_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
diff --git a/drivers/ata/pata_opti.c b/drivers/ata/pata_opti.c
index 0af8a2c..1c44653 100644
--- a/drivers/ata/pata_opti.c
+++ b/drivers/ata/pata_opti.c
@@ -179,10 +179,6 @@ static struct scsi_host_template opti_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations opti_port_ops = {
@@ -220,19 +216,19 @@ static struct ata_port_operations opti_port_ops = {
 
 static int opti_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &opti_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &opti_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id opti[] = {
diff --git a/drivers/ata/pata_optidma.c b/drivers/ata/pata_optidma.c
index 2843e48..3093b02 100644
--- a/drivers/ata/pata_optidma.c
+++ b/drivers/ata/pata_optidma.c
@@ -363,10 +363,6 @@ static struct scsi_host_template optidma_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations optidma_port_ops = {
@@ -486,14 +482,14 @@ done_nomsg:		/* Wrong chip revision */
 
 static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_82c700 = {
+	static const struct ata_port_info info_82c700 = {
 		.sht = &optidma_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &optidma_port_ops
 	};
-	static struct ata_port_info info_82c700_udma = {
+	static const struct ata_port_info info_82c700_udma = {
 		.sht = &optidma_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -501,8 +497,7 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x07,
 		.port_ops = &optiplus_port_ops
 	};
-	static struct ata_port_info *port_info[2];
-	struct ata_port_info *info = &info_82c700;
+	const struct ata_port_info *ppi[] = { &info_82c700, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
@@ -514,10 +509,9 @@ static int optidma_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 	pci_clock = inb(0x1F5) & 1;		/* 0 = 33Mhz, 1 = 25Mhz */
 
 	if (optiplus_with_udma(dev))
-		info = &info_82c700_udma;
+		ppi[0] = &info_82c700_udma;
 
-	port_info[0] = port_info[1] = info;
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id optidma[] = {
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 11245e3..4d44c75 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -397,6 +397,7 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("TOSHIBA", "MK2001MPL", 0xb4585a1a, 0x3489e003),
 	PCMCIA_DEVICE_PROD_ID1("TRANSCEND    512M   ", 0xd0909443),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
diff --git a/drivers/ata/pata_pdc202xx_old.c b/drivers/ata/pata_pdc202xx_old.c
index ee636be..edbaf9d 100644
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -244,10 +244,6 @@ static struct scsi_host_template pdc202xx_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations pdc2024x_port_ops = {
@@ -321,7 +317,7 @@ static struct ata_port_operations pdc2026x_port_ops = {
 
 static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info[3] = {
+	static const struct ata_port_info info[3] = {
 		{
 			.sht = &pdc202xx_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -348,9 +344,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		}
 
 	};
-	static struct ata_port_info *port_info[2];
-
-	port_info[0] = port_info[1] = &info[id->driver_data];
+	const struct ata_port_info *ppi[] = { &info[id->driver_data], NULL };
 
 	if (dev->device == PCI_DEVICE_ID_PROMISE_20265) {
 		struct pci_dev *bridge = dev->bus->self;
@@ -362,7 +356,7 @@ static int pdc202xx_init_one(struct pci_dev *dev, const struct pci_device_id *id
 				return -ENODEV;
 		}
 	}
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id pdc202xx[] = {
diff --git a/drivers/ata/pata_platform.c b/drivers/ata/pata_platform.c
index a0a650c..1f63848 100644
--- a/drivers/ata/pata_platform.c
+++ b/drivers/ata/pata_platform.c
@@ -48,6 +48,8 @@ static int pata_platform_set_mode(struct ata_port *ap, struct ata_device **unuse
 	return 0;
 }
 
+static int ata_dummy_ret0(struct ata_port *ap)	{ return 0; }
+
 static struct scsi_host_template pata_platform_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
@@ -91,7 +93,7 @@ static struct ata_port_operations pata_platform_port_ops = {
 	.irq_on			= ata_irq_on,
 	.irq_ack		= ata_irq_ack,
 
-	.port_start		= ata_port_start,
+	.port_start		= ata_dummy_ret0,
 };
 
 static void pata_platform_setup_port(struct ata_ioports *ioaddr,
diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
index 1c54673..ba96b54 100644
--- a/drivers/ata/pata_radisys.c
+++ b/drivers/ata/pata_radisys.c
@@ -200,10 +200,6 @@ static struct scsi_host_template radisys_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations radisys_pata_ops = {
@@ -259,7 +255,7 @@ static const struct ata_port_operations radisys_pata_ops = {
 static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht		= &radisys_sht,
 		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask	= 0x1f,	/* pio0-4 */
@@ -267,13 +263,13 @@ static int radisys_init_one (struct pci_dev *pdev, const struct pci_device_id *e
 		.udma_mask	= 0x14, /* UDMA33/66 only */
 		.port_ops	= &radisys_pata_ops,
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id radisys_pci_tbl[] = {
diff --git a/drivers/ata/pata_rz1000.c b/drivers/ata/pata_rz1000.c
index 85c4529..2bfd7ef 100644
--- a/drivers/ata/pata_rz1000.c
+++ b/drivers/ata/pata_rz1000.c
@@ -40,7 +40,7 @@ static int rz1000_set_mode(struct ata_port *ap, struct ata_device **unused)
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
-		if (ata_dev_ready(dev)) {
+		if (ata_dev_enabled(dev)) {
 			/* We don't really care */
 			dev->pio_mode = XFER_PIO_0;
 			dev->xfer_mode = XFER_PIO_0;
@@ -69,10 +69,6 @@ static struct scsi_host_template rz1000_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations rz1000_port_ops = {
@@ -135,22 +131,20 @@ static int rz1000_fifo_disable(struct pci_dev *pdev)
 static int rz1000_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	struct ata_port_info *port_info[2];
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &rz1000_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &rz1000_port_ops
 	};
+	const struct ata_port_info *ppi[] = { &info, NULL };
 
 	if (!printed_version++)
 		printk(KERN_DEBUG DRV_NAME " version " DRV_VERSION "\n");
 
-	if (rz1000_fifo_disable(pdev) == 0) {
-		port_info[0] = &info;
-		port_info[1] = &info;
-		return ata_pci_init_one(pdev, port_info, 2);
-	}
+	if (rz1000_fifo_disable(pdev) == 0)
+		return ata_pci_init_one(pdev, ppi);
+
 	printk(KERN_ERR DRV_NAME ": failed to disable read-ahead on chipset..\n");
 	/* Not safe to use so skip */
 	return -ENODEV;
diff --git a/drivers/ata/pata_sc1200.c b/drivers/ata/pata_sc1200.c
index 66e8ff4..225013e 100644
--- a/drivers/ata/pata_sc1200.c
+++ b/drivers/ata/pata_sc1200.c
@@ -194,10 +194,6 @@ static struct scsi_host_template sc1200_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations sc1200_port_ops = {
@@ -247,7 +243,7 @@ static struct ata_port_operations sc1200_port_ops = {
 
 static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &sc1200_sht,
 		.flags = ATA_FLAG_SLAVE_POSS|ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -255,10 +251,10 @@ static int sc1200_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 		.udma_mask = 0x07,
 		.port_ops = &sc1200_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
-
 	/* Can't enable port 2 yet, see top comments */
-	return ata_pci_init_one(dev, port_info, 1);
+	const struct ata_port_info *ppi[] = { &info, &ata_dummy_port_info };
+
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id sc1200[] = {
diff --git a/drivers/ata/pata_scc.c b/drivers/ata/pata_scc.c
index 203f463..cca3aa2 100644
--- a/drivers/ata/pata_scc.c
+++ b/drivers/ata/pata_scc.c
@@ -984,10 +984,6 @@ static struct scsi_host_template scc_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations scc_pata_ops = {
diff --git a/drivers/ata/pata_serverworks.c b/drivers/ata/pata_serverworks.c
index b6e0203..dee6e21 100644
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -315,10 +315,6 @@ static struct scsi_host_template serverworks_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations serverworks_osb4_port_ops = {
@@ -479,8 +475,7 @@ static void serverworks_fixup_ht1000(struct pci_dev *pdev)
 
 static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int ports = 2;
-	static struct ata_port_info info[4] = {
+	static const struct ata_port_info info[4] = {
 		{ /* OSB4 */
 			.sht = &serverworks_sht,
 			.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
@@ -511,8 +506,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 			.port_ops = &serverworks_csb_port_ops
 		}
 	};
-	static struct ata_port_info *port_info[2];
-	struct ata_port_info *devinfo = &info[id->driver_data];
+	const struct ata_port_info *ppi[] = { &info[id->driver_data], NULL };
 
 	/* Force master latency timer to 64 PCI clocks */
 	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0x40);
@@ -521,7 +515,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4IDE) {
 		/* Select non UDMA capable OSB4 if we can't do fixups */
 		if ( serverworks_fixup_osb4(pdev) < 0)
-			devinfo = &info[1];
+			ppi[0] = &info[1];
 	}
 	/* setup CSB5/CSB6 : South Bridge and IDE option RAID */
 	else if ((pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE) ||
@@ -531,11 +525,11 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 		 /* If the returned btr is the newer revision then
 		    select the right info block */
 		 if (serverworks_fixup_csb(pdev) == 3)
-		 	devinfo = &info[3];
+		 	ppi[0] = &info[3];
 
 		/* Is this the 3rd channel CSB6 IDE ? */
 		if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)
-			ports = 1;
+			ppi[1] = &ata_dummy_port_info;
 	}
 	/* setup HT1000E */
 	else if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_HT1000IDE)
@@ -544,8 +538,7 @@ static int serverworks_init_one(struct pci_dev *pdev, const struct pci_device_id
 	if (pdev->device == PCI_DEVICE_ID_SERVERWORKS_CSB5IDE)
 		ata_pci_clear_simplex(pdev);
 
-	port_info[0] = port_info[1] = devinfo;
-	return ata_pci_init_one(pdev, port_info, ports);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sil680.c b/drivers/ata/pata_sil680.c
index a5886f0..440e2cb 100644
--- a/drivers/ata/pata_sil680.c
+++ b/drivers/ata/pata_sil680.c
@@ -232,10 +232,6 @@ static struct scsi_host_template sil680_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static struct ata_port_operations sil680_port_ops = {
@@ -345,7 +341,7 @@ static u8 sil680_init_chip(struct pci_dev *pdev)
 
 static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &sil680_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -353,7 +349,7 @@ static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = 0x7f,
 		.port_ops = &sil680_port_ops
 	};
-	static struct ata_port_info info_slow = {
+	static const struct ata_port_info info_slow = {
 		.sht = &sil680_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
@@ -361,7 +357,7 @@ static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = 0x3f,
 		.port_ops = &sil680_port_ops
 	};
-	static struct ata_port_info *port_info[2] = {&info, &info};
+	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
@@ -370,12 +366,12 @@ static int sil680_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	switch(sil680_init_chip(pdev))
 	{
 		case 0:
-			port_info[0] = port_info[1] = &info_slow;
+			ppi[0] = &info_slow;
 			break;
 		case 0x30:
 			return -ENODEV;
 	}
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/pata_sis.c b/drivers/ata/pata_sis.c
index f5838cc..f223126 100644
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -38,8 +38,8 @@
 #define DRV_VERSION	"0.5.1"
 
 struct sis_chipset {
-	u16 device;			/* PCI host ID */
-	struct ata_port_info *info;	/* Info block */
+	u16 device;				/* PCI host ID */
+	const struct ata_port_info *info;	/* Info block */
 	/* Probably add family, cable detect type etc here to clean
 	   up code later */
 };
@@ -524,10 +524,6 @@ static struct scsi_host_template sis_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static const struct ata_port_operations sis_133_ops = {
@@ -700,7 +696,7 @@ static const struct ata_port_operations sis_old_ops = {
 	.port_start		= ata_port_start,
 };
 
-static struct ata_port_info sis_info = {
+static const struct ata_port_info sis_info = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
@@ -708,7 +704,7 @@ static struct ata_port_info sis_info = {
 	.udma_mask	= 0,
 	.port_ops	= &sis_old_ops,
 };
-static struct ata_port_info sis_info33 = {
+static const struct ata_port_info sis_info33 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
@@ -716,35 +712,35 @@ static struct ata_port_info sis_info33 = {
 	.udma_mask	= ATA_UDMA2,	/* UDMA 33 */
 	.port_ops	= &sis_old_ops,
 };
-static struct ata_port_info sis_info66 = {
+static const struct ata_port_info sis_info66 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA4,	/* UDMA 66 */
 	.port_ops	= &sis_66_ops,
 };
-static struct ata_port_info sis_info100 = {
+static const struct ata_port_info sis_info100 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA5,
 	.port_ops	= &sis_100_ops,
 };
-static struct ata_port_info sis_info100_early = {
+static const struct ata_port_info sis_info100_early = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.udma_mask	= ATA_UDMA5,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.port_ops	= &sis_66_ops,
 };
-struct ata_port_info sis_info133 = {
+const struct ata_port_info sis_info133 = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &sis_133_ops,
 };
-static struct ata_port_info sis_info133_early = {
+static const struct ata_port_info sis_info133_early = {
 	.sht		= &sis_sht,
 	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 	.pio_mask	= 0x1f,	/* pio0-4 */
@@ -827,8 +823,8 @@ static void sis_fixup(struct pci_dev *pdev, struct sis_chipset *sis)
 static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
-	static struct ata_port_info *port_info[2];
-	struct ata_port_info *port;
+	struct ata_port_info port;
+	const struct ata_port_info *ppi[] = { &port, NULL };
 	struct pci_dev *host = NULL;
 	struct sis_chipset *chipset = NULL;
 	struct sis_chipset *sets;
@@ -968,13 +964,12 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (chipset == NULL)
 		return -ENODEV;
 
-	port = chipset->info;
-	port->private_data = chipset;
+	port = *chipset->info;
+	port.private_data = chipset;
 
 	sis_fixup(pdev, chipset);
 
-	port_info[0] = port_info[1] = port;
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 static const struct pci_device_id sis_pci_tbl[] = {
diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 9aeffdb..f48491a 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -301,20 +301,22 @@ static int sl82c105_bridge_revision(struct pci_dev *pdev)
 
 static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info_dma = {
+	static const struct ata_port_info info_dma = {
 		.sht = &sl82c105_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &sl82c105_port_ops
 	};
-	static struct ata_port_info info_early = {
+	static const struct ata_port_info info_early = {
 		.sht = &sl82c105_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.port_ops = &sl82c105_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info_early, &info_early };
+	/* for now use only the first port */
+	const struct ata_port_info *ppi[] = { &info_early,
+					       &ata_dummy_port_info };
 	u32 val;
 	int rev;
 
@@ -324,17 +326,14 @@ static int sl82c105_init_one(struct pci_dev *dev, const struct pci_device_id *id
 		dev_printk(KERN_WARNING, &dev->dev, "pata_sl82c105: Unable to find bridge, disabling DMA.\n");
 	else if (rev <= 5)
 		dev_printk(KERN_WARNING, &dev->dev, "pata_sl82c105: Early bridge revision, no DMA available.\n");
-	else {
-		port_info[0] = &info_dma;
-		port_info[1] = &info_dma;
-	}
+	else
+		ppi[0] = &info_dma;
 
 	pci_read_config_dword(dev, 0x40, &val);
 	val |= CTRL_P0EN | CTRL_P0F16 | CTRL_P1F16;
 	pci_write_config_dword(dev, 0x40, val);
 
-
-	return ata_pci_init_one(dev, port_info, 1); /* For now */
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id sl82c105[] = {
diff --git a/drivers/ata/pata_triflex.c b/drivers/ata/pata_triflex.c
index 349887b..b1d3076 100644
--- a/drivers/ata/pata_triflex.c
+++ b/drivers/ata/pata_triflex.c
@@ -194,10 +194,6 @@ static struct scsi_host_template triflex_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations triflex_port_ops = {
@@ -237,20 +233,20 @@ static struct ata_port_operations triflex_port_ops = {
 
 static int triflex_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct ata_port_info info = {
+	static const struct ata_port_info info = {
 		.sht = &triflex_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
 		.pio_mask = 0x1f,
 		.mwdma_mask = 0x07,
 		.port_ops = &triflex_port_ops
 	};
-	static struct ata_port_info *port_info[2] = { &info, &info };
+	const struct ata_port_info *ppi[] = { &info, NULL };
 	static int printed_version;
 
 	if (!printed_version++)
 		dev_printk(KERN_DEBUG, &dev->dev, "version " DRV_VERSION "\n");
 
-	return ata_pci_init_one(dev, port_info, 2);
+	return ata_pci_init_one(dev, ppi);
 }
 
 static const struct pci_device_id triflex[] = {
diff --git a/drivers/ata/pata_via.c b/drivers/ata/pata_via.c
index 362beb2..e4c71f7 100644
--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -301,10 +301,6 @@ static struct scsi_host_template via_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.resume			= ata_scsi_device_resume,
-	.suspend		= ata_scsi_device_suspend,
-#endif
 };
 
 static struct ata_port_operations via_port_ops = {
@@ -425,7 +421,7 @@ static void via_config_fifo(struct pci_dev *pdev, unsigned int flags)
 static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	/* Early VIA without UDMA support */
-	static struct ata_port_info via_mwdma_info = {
+	static const struct ata_port_info via_mwdma_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -433,7 +429,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &via_port_ops
 	};
 	/* Ditto with IRQ masking required */
-	static struct ata_port_info via_mwdma_info_borked = {
+	static const struct ata_port_info via_mwdma_info_borked = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -441,7 +437,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &via_port_ops_noirq,
 	};
 	/* VIA UDMA 33 devices (and borked 66) */
-	static struct ata_port_info via_udma33_info = {
+	static const struct ata_port_info via_udma33_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -450,7 +446,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 66 devices */
-	static struct ata_port_info via_udma66_info = {
+	static const struct ata_port_info via_udma66_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -459,7 +455,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &via_port_ops
 	};
 	/* VIA UDMA 100 devices */
-	static struct ata_port_info via_udma100_info = {
+	static const struct ata_port_info via_udma100_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -468,7 +464,7 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.port_ops = &via_port_ops
 	};
 	/* UDMA133 with bad AST (All current 133) */
-	static struct ata_port_info via_udma133_info = {
+	static const struct ata_port_info via_udma133_info = {
 		.sht = &via_sht,
 		.flags = ATA_FLAG_SLAVE_POSS | ATA_FLAG_SETXFER_POLLING,
 		.pio_mask = 0x1f,
@@ -476,7 +472,8 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		.udma_mask = 0x7f,	/* FIXME: should check north bridge */
 		.port_ops = &via_port_ops
 	};
-	struct ata_port_info *port_info[2], *type;
+	struct ata_port_info type;
+	const struct ata_port_info *ppi[] = { &type, NULL };
 	struct pci_dev *isa = NULL;
 	const struct via_isa_bridge *config;
 	static int printed_version;
@@ -521,25 +518,25 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	switch(config->flags & VIA_UDMA) {
 		case VIA_UDMA_NONE:
 			if (config->flags & VIA_NO_UNMASK)
-				type = &via_mwdma_info_borked;
+				type = via_mwdma_info_borked;
 			else
-				type = &via_mwdma_info;
+				type = via_mwdma_info;
 			break;
 		case VIA_UDMA_33:
-			type = &via_udma33_info;
+			type = via_udma33_info;
 			break;
 		case VIA_UDMA_66:
-			type = &via_udma66_info;
+			type = via_udma66_info;
 			/* The 66 MHz devices require we enable the clock */
 			pci_read_config_dword(pdev, 0x50, &timing);
 			timing |= 0x80008;
 			pci_write_config_dword(pdev, 0x50, timing);
 			break;
 		case VIA_UDMA_100:
-			type = &via_udma100_info;
+			type = via_udma100_info;
 			break;
 		case VIA_UDMA_133:
-			type = &via_udma133_info;
+			type = via_udma133_info;
 			break;
 		default:
 			WARN_ON(1);
@@ -554,10 +551,9 @@ static int via_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* We have established the device type, now fire it up */
-	type->private_data = (void *)config;
+	type.private_data = (void *)config;
 
-	port_info[0] = port_info[1] = type;
-	return ata_pci_init_one(pdev, port_info, 2);
+	return ata_pci_init_one(pdev, ppi);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/sata_inic162x.c b/drivers/ata/sata_inic162x.c
index b3b62e9..bda5e77 100644
--- a/drivers/ata/sata_inic162x.c
+++ b/drivers/ata/sata_inic162x.c
@@ -135,10 +135,6 @@ static struct scsi_host_template inic_sht = {
 	.slave_configure	= inic_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const int scr_map[] = {
diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index a097595..4cea3ef 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -325,10 +325,6 @@ static struct scsi_host_template nv_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static struct scsi_host_template nv_adma_sht = {
@@ -347,10 +343,6 @@ static struct scsi_host_template nv_adma_sht = {
 	.slave_configure	= nv_adma_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations nv_generic_ops = {
@@ -465,7 +457,7 @@ static const struct ata_port_operations nv_adma_ops = {
 	.host_stop		= nv_adma_host_stop,
 };
 
-static struct ata_port_info nv_port_info[] = {
+static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
 		.sht		= &nv_sht,
@@ -1545,7 +1537,7 @@ static void nv_adma_error_handler(struct ata_port *ap)
 static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version = 0;
-	const struct ata_port_info *ppi[2];
+	const struct ata_port_info *ppi[] = { NULL, NULL };
 	struct ata_host *host;
 	struct nv_host_priv *hpriv;
 	int rc;
@@ -1573,8 +1565,8 @@ static int nv_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		type = ADMA;
 	}
 
-	ppi[0] = ppi[1] = &nv_port_info[type];
-	rc = ata_pci_prepare_native_host(pdev, ppi, 2, &host);
+	ppi[0] = &nv_port_info[type];
+	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_sil.c b/drivers/ata/sata_sil.c
index 0a1e417..e8483aa 100644
--- a/drivers/ata/sata_sil.c
+++ b/drivers/ata/sata_sil.c
@@ -182,10 +182,6 @@ static struct scsi_host_template sil_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations sil_ops = {
diff --git a/drivers/ata/sata_sil24.c b/drivers/ata/sata_sil24.c
index b97ee9f..a69d78c 100644
--- a/drivers/ata/sata_sil24.c
+++ b/drivers/ata/sata_sil24.c
@@ -380,10 +380,6 @@ static struct scsi_host_template sil24_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations sil24_ops = {
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index d8ee062..ee66c5f 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -129,7 +129,7 @@ static const struct ata_port_operations sis_ops = {
 	.port_start		= ata_port_start,
 };
 
-static struct ata_port_info sis_port_info = {
+static const struct ata_port_info sis_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 	.pio_mask	= 0x1f,
 	.mwdma_mask	= 0x7,
@@ -255,7 +255,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	static int printed_version;
 	struct ata_port_info pi = sis_port_info;
-	const struct ata_port_info *ppi[2] = { &pi, &pi };
+	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ata_host *host;
 	u32 genctl, val;
 	u8 pmr;
@@ -335,7 +335,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 	}
 
-	rc = ata_pci_prepare_native_host(pdev, ppi, 2, &host);
+	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 
diff --git a/drivers/ata/sata_uli.c b/drivers/ata/sata_uli.c
index f74e383..006f5e3 100644
--- a/drivers/ata/sata_uli.c
+++ b/drivers/ata/sata_uli.c
@@ -125,7 +125,7 @@ static const struct ata_port_operations uli_ops = {
 	.port_start		= ata_port_start,
 };
 
-static struct ata_port_info uli_port_info = {
+static const struct ata_port_info uli_port_info = {
 	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 			  ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = 0x1f,		/* pio0-4 */
@@ -201,19 +201,33 @@ static int uli_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 	n_ports = 2;
 	if (board_idx == uli_5287)
 		n_ports = 4;
-	rc = ata_pci_prepare_native_host(pdev, ppi, n_ports, &host);
-	if (rc)
-		return rc;
+
+	/* allocate the host */
+	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
+	if (!host)
+		return -ENOMEM;
 
 	hpriv = devm_kzalloc(&pdev->dev, sizeof(*hpriv), GFP_KERNEL);
 	if (!hpriv)
 		return -ENOMEM;
 	host->private_data = hpriv;
 
+	/* the first two ports are standard SFF */
+	rc = ata_pci_init_native_host(host);
+	if (rc)
+		return rc;
+
+	rc = ata_pci_init_bmdma(host);
+	if (rc)
+		return rc;
+
 	iomap = host->iomap;
 
 	switch (board_idx) {
 	case uli_5287:
+		/* If there are four, the last two live right after
+		 * the standard SFF ports.
+		 */
 		hpriv->scr_cfg_addr[0] = ULI5287_BASE;
 		hpriv->scr_cfg_addr[1] = ULI5287_BASE + ULI5287_OFFS;
 
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 939c924..d105d2c 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -116,10 +116,6 @@ static struct scsi_host_template svia_sht = {
 	.slave_configure	= ata_scsi_slave_config,
 	.slave_destroy		= ata_scsi_slave_destroy,
 	.bios_param		= ata_std_bios_param,
-#ifdef CONFIG_PM
-	.suspend		= ata_scsi_device_suspend,
-	.resume			= ata_scsi_device_resume,
-#endif
 };
 
 static const struct ata_port_operations vt6420_sata_ops = {
@@ -415,7 +411,7 @@ static int vt6420_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	struct ata_host *host;
 	int rc;
 
-	rc = ata_pci_prepare_native_host(pdev, ppi, 2, &host);
+	rc = ata_pci_prepare_native_host(pdev, ppi, &host);
 	if (rc)
 		return rc;
 	*r_host = host;
diff --git a/drivers/ata/sis.h b/drivers/ata/sis.h
index 231da8f..0f2208d 100644
--- a/drivers/ata/sis.h
+++ b/drivers/ata/sis.h
@@ -2,4 +2,4 @@
 struct ata_port_info;
 
 /* pata_sis.c */
-extern struct ata_port_info sis_info133;
+extern const struct ata_port_info sis_info133;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 147d86f..6ccc2e9 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -875,6 +875,7 @@ static void __devinit quirk_sb600_sata(struct pci_dev *pdev)
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP600_SATA, quirk_sb600_sata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_IXP700_SATA, quirk_sb600_sata);
 
 /*
  *	Serverworks CSB5 IDE does not fully support native mode
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 7906d75..27d9362 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -140,7 +140,6 @@ enum {
 
 	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
 	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SUSPENDED	= (1 << 10), /* device suspended */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
@@ -191,6 +190,7 @@ enum {
 	ATA_PFLAG_LOADING	= (1 << 4), /* boot/loading probe */
 	ATA_PFLAG_UNLOADING	= (1 << 5), /* module is unloading */
 	ATA_PFLAG_SCSI_HOTPLUG	= (1 << 6), /* SCSI hotplug scheduled */
+	ATA_PFLAG_INITIALIZING	= (1 << 7), /* being initialized, don't touch */
 
 	ATA_PFLAG_FLUSH_PORT_TASK = (1 << 16), /* flush port task */
 	ATA_PFLAG_SUSPENDED	= (1 << 17), /* port is suspended (power) */
@@ -254,10 +254,6 @@ enum {
 	ATA_DMA_PAD_SZ		= 4,
 	ATA_DMA_PAD_BUF_SZ	= ATA_DMA_PAD_SZ * ATA_MAX_QUEUE,
 
-	/* masks for port functions */
-	ATA_PORT_PRIMARY	= (1 << 0),
-	ATA_PORT_SECONDARY	= (1 << 1),
-
 	/* ering size */
 	ATA_ERING_SIZE		= 32,
 
@@ -268,13 +264,9 @@ enum {
 	ATA_EH_REVALIDATE	= (1 << 0),
 	ATA_EH_SOFTRESET	= (1 << 1),
 	ATA_EH_HARDRESET	= (1 << 2),
-	ATA_EH_SUSPEND		= (1 << 3),
-	ATA_EH_RESUME		= (1 << 4),
-	ATA_EH_PM_FREEZE	= (1 << 5),
 
 	ATA_EH_RESET_MASK	= ATA_EH_SOFTRESET | ATA_EH_HARDRESET,
-	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE | ATA_EH_SUSPEND |
-				  ATA_EH_RESUME | ATA_EH_PM_FREEZE,
+	ATA_EH_PERDEV_MASK	= ATA_EH_REVALIDATE,
 
 	/* ata_eh_info->flags */
 	ATA_EHI_HOTPLUGGED	= (1 << 0),  /* could have been hotplugged */
@@ -466,7 +458,7 @@ struct ata_device {
 	struct ata_ering	ering;
 	int			spdn_cnt;
 	unsigned int		horkage;	/* List of broken features */
-#ifdef CONFIG_SATA_ACPI
+#ifdef CONFIG_ATA_ACPI
 	/* ACPI objects info */
 	acpi_handle obj_handle;
 #endif
@@ -693,8 +685,8 @@ extern void ata_std_postreset(struct ata_port *ap, unsigned int *classes);
 extern void ata_port_disable(struct ata_port *);
 extern void ata_std_ports(struct ata_ioports *ioaddr);
 #ifdef CONFIG_PCI
-extern int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
-			     unsigned int n_ports);
+extern int ata_pci_init_one (struct pci_dev *pdev,
+			     const struct ata_port_info * const * ppi);
 extern void ata_pci_remove_one (struct pci_dev *pdev);
 #ifdef CONFIG_PM
 extern void ata_pci_device_do_suspend(struct pci_dev *pdev, pm_message_t mesg);
@@ -736,8 +728,6 @@ extern int sata_scr_write_flush(struct ata_port *ap, int reg, u32 val);
 extern int ata_port_online(struct ata_port *ap);
 extern int ata_port_offline(struct ata_port *ap);
 #ifdef CONFIG_PM
-extern int ata_scsi_device_resume(struct scsi_device *);
-extern int ata_scsi_device_suspend(struct scsi_device *, pm_message_t mesg);
 extern int ata_host_suspend(struct ata_host *host, pm_message_t mesg);
 extern void ata_host_resume(struct ata_host *host);
 #endif
@@ -861,11 +851,11 @@ struct pci_bits {
 	unsigned long		val;
 };
 
-extern int ata_pci_init_native_host(struct ata_host *host,
-				    unsigned int port_mask);
+extern int ata_pci_init_native_host(struct ata_host *host);
+extern int ata_pci_init_bmdma(struct ata_host *host);
 extern int ata_pci_prepare_native_host(struct pci_dev *pdev,
 				const struct ata_port_info * const * ppi,
-				int n_ports, struct ata_host **r_host);
+				struct ata_host **r_host);
 extern int pci_test_config_bits(struct pci_dev *pdev, const struct pci_bits *bits);
 extern unsigned long ata_pci_default_filter(struct ata_device *, unsigned long);
 #endif /* CONFIG_PCI */
@@ -1008,11 +998,6 @@ static inline unsigned int ata_dev_absent(const struct ata_device *dev)
 	return ata_class_absent(dev->class);
 }
 
-static inline unsigned int ata_dev_ready(const struct ata_device *dev)
-{
-	return ata_dev_enabled(dev) && !(dev->flags & ATA_DFLAG_SUSPENDED);
-}
-
 /*
  * port helpers
  */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae849f0..ccd85e4 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -370,6 +370,7 @@
 #define PCI_DEVICE_ID_ATI_IXP600_SATA	0x4380
 #define PCI_DEVICE_ID_ATI_IXP600_SMBUS	0x4385
 #define PCI_DEVICE_ID_ATI_IXP600_IDE	0x438c
+#define PCI_DEVICE_ID_ATI_IXP700_SATA	0x4390
 
 #define PCI_VENDOR_ID_VLSI		0x1004
 #define PCI_DEVICE_ID_VLSI_82C592	0x0005
