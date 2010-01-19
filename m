Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614Ab0ASR5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0ASR5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 12:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130Ab0ASR5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 12:57:41 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:41452 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753806Ab0ASR5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 12:57:31 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org
Cc: Nick Bowler <nbowler@draconx.ca>
Subject: [PATCH 1/2] Fix spelling of "occur" and similar words in comments.
Date: Tue, 19 Jan 2010 12:57:07 -0500
Message-Id: <1263923828-15387-1-git-send-email-nbowler@elliptictech.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Bowler <nbowler@draconx.ca>

The words "occur", "occurs", "occurred", "occurring" and "occurrence"
are misspelled throughout the kernel.  This patch corrects such errors
in comments and documentation only.

Occurrences were found with cscope and then manually corrected.
References to variables or functions in the code were not modified.
This change is purely spelling -- no attempt was made to correct
grammatically incorrect use of the word "occur", nor was an attempt made
to correct the spelling of other words.

Notes on comment wrapping:

 * Multi-line comments were re-wrapped if and only if the original
   comment was wrapped to 80 characters.

 * Single-line comments were _not_ converted to multiple lines, even if
   the change caused that line to exceed 80 characters.

All other checkpatch errors are from the original code.

Signed-off-by: Nick Bowler <nbowler@draconx.ca>
---

These two patches fix around 250 errors located throughout the kernel.  I
wasn't sure of the ideal way to split it, so I settled on just two patches.
This patch changes comments only, and therefore has no behavioural change.
The next changes printk messages.

 Documentation/ia64/aliasing-test.c                 |    2 +-
 arch/alpha/oprofile/op_model_ev67.c                |    2 +-
 arch/arm/mach-iop13xx/pci.c                        |    4 ++--
 arch/ia64/include/asm/perfmon_default_smpl.h       |    4 ++--
 arch/microblaze/kernel/prom.c                      |    2 +-
 arch/mips/include/asm/octeon/cvmx-l2c.h            |    2 +-
 arch/mips/kernel/process.c                         |    2 +-
 arch/powerpc/kernel/prom.c                         |    2 +-
 arch/powerpc/kernel/traps.c                        |    2 +-
 arch/powerpc/oprofile/op_model_cell.c              |    2 +-
 arch/powerpc/platforms/pseries/eeh.c               |    2 +-
 arch/s390/include/asm/cio.h                        |    2 +-
 arch/s390/kernel/time.c                            |    2 +-
 arch/x86/pci/i386.c                                |    2 +-
 drivers/acpi/processor_perflib.c                   |    4 ++--
 drivers/ata/libata-eh.c                            |    2 +-
 drivers/block/xsysace.c                            |    4 ++--
 drivers/char/hvc_iucv.c                            |    4 ++--
 drivers/edac/amd64_edac.c                          |    4 ++--
 drivers/edac/edac_core.h                           |    2 +-
 drivers/edac/i82443bxgx_edac.c                     |    2 +-
 drivers/gpu/drm/i915/i915_drv.h                    |    2 +-
 drivers/gpu/vga/vgaarb.c                           |    2 +-
 drivers/hwmon/sht15.c                              |    4 ++--
 drivers/input/mouse/vsxxxaa.c                      |    2 +-
 drivers/isdn/hisax/l3dss1.c                        |    2 +-
 drivers/isdn/hisax/l3ni1.c                         |    2 +-
 drivers/md/md.h                                    |    2 +-
 drivers/media/common/saa7146_i2c.c                 |    6 +++---
 drivers/media/dvb/b2c2/flexcop-pci.c               |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c          |    2 +-
 drivers/media/dvb/dvb-usb/dvb-usb-init.c           |    2 +-
 drivers/media/dvb/pluto2/pluto2.c                  |    2 +-
 drivers/media/video/saa7164/saa7164-cmd.c          |    2 +-
 drivers/media/video/uvc/uvc_video.c                |    4 ++--
 drivers/message/fusion/lsi/mpi_log_sas.h           |   10 +++++-----
 drivers/message/fusion/mptctl.c                    |    2 +-
 drivers/misc/sgi-gru/grukservices.c                |    2 +-
 drivers/mtd/chips/cfi_cmdset_0001.c                |    4 ++--
 drivers/mtd/lpddr/lpddr_cmds.c                     |    2 +-
 drivers/mtd/mtdchar.c                              |    2 +-
 drivers/mtd/nand/diskonchip.c                      |    2 +-
 drivers/mtd/nand/nand_base.c                       |    2 +-
 drivers/net/can/sja1000/sja1000.c                  |    2 +-
 drivers/net/can/usb/ems_usb.c                      |    2 +-
 drivers/net/cassini.c                              |    2 +-
 drivers/net/cxgb3/t3_hw.c                          |    4 ++--
 drivers/net/e1000e/netdev.c                        |    2 +-
 drivers/net/igb/e1000_phy.c                        |    2 +-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/igbvf/netdev.c                         |    2 +-
 drivers/net/irda/pxaficp_ir.c                      |    2 +-
 drivers/net/s2io.c                                 |    2 +-
 drivers/net/skge.h                                 |    2 +-
 drivers/net/tc35815.c                              |    2 +-
 drivers/net/tsi108_eth.h                           |    8 ++++----
 drivers/net/via-rhine.c                            |    2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c                  |    2 +-
 drivers/net/vxge/vxge-traffic.h                    |    2 +-
 drivers/net/wan/ixp4xx_hss.c                       |    2 +-
 drivers/net/wimax/i2400m/i2400m-usb.h              |    2 +-
 drivers/net/wireless/b43/b43.h                     |    2 +-
 drivers/s390/block/dasd_3990_erp.c                 |    4 ++--
 drivers/s390/scsi/zfcp_fsf.c                       |    2 +-
 drivers/scsi/aic7xxx/aic79xx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c                |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                     |    2 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/scsi/gdth.h                                |    2 +-
 drivers/scsi/initio.c                              |    2 +-
 drivers/scsi/libfc/fc_lport.c                      |    2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    2 +-
 drivers/scsi/pcmcia/nsp_cs.c                       |    2 +-
 drivers/scsi/wd33c93.c                             |    2 +-
 drivers/serial/68328serial.h                       |    4 ++--
 drivers/serial/8250.c                              |    2 +-
 drivers/staging/comedi/comedi_fops.c               |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci2032.c      |    2 +-
 drivers/staging/comedi/drivers/adv_pci1710.c       |    2 +-
 drivers/staging/comedi/drivers/comedi_test.c       |    2 +-
 drivers/staging/comedi/drivers/ni_at_a2150.c       |    4 ++--
 drivers/staging/comedi/drivers/ni_labpc.c          |    6 +++---
 drivers/staging/comedi/drivers/s626.c              |    2 +-
 drivers/staging/dream/pmem.c                       |    2 +-
 drivers/staging/et131x/et131x_isr.c                |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/adc/max1363_ring.c             |    2 +-
 drivers/staging/iio/chrdev.h                       |    4 ++--
 drivers/staging/quatech_usb2/quatech_usb2.c        |    4 ++--
 drivers/staging/rt2860/rtmp.h                      |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    2 +-
 drivers/staging/wlags49_h2/hcf.c                   |    4 ++--
 drivers/staging/wlags49_h2/mdd.h                   |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/c67x00/c67x00-sched.c                  |    2 +-
 drivers/usb/gadget/fsl_qe_udc.h                    |    4 ++--
 drivers/usb/gadget/fsl_udc_core.c                  |    2 +-
 drivers/usb/gadget/s3c-hsotg.c                     |    2 +-
 drivers/usb/host/fhci.h                            |    2 +-
 drivers/uwb/wlp/messages.c                         |    6 +++---
 drivers/uwb/wlp/txrx.c                             |    2 +-
 drivers/uwb/wlp/wlp-lc.c                           |    4 ++--
 drivers/video/fbsysfs.c                            |    2 +-
 drivers/watchdog/acquirewdt.c                      |    2 +-
 drivers/watchdog/sch311x_wdt.c                     |    2 +-
 drivers/watchdog/smsc37b787_wdt.c                  |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/nfs/file.c                                      |    2 +-
 fs/nfsd/nfs4state.c                                |    2 +-
 fs/ntfs/attrib.c                                   |    2 +-
 fs/ntfs/inode.c                                    |    2 +-
 fs/ntfs/logfile.h                                  |    2 +-
 fs/ntfs/super.c                                    |   14 +++++++-------
 fs/ocfs2/cluster/quorum.c                          |    2 +-
 fs/reiserfs/xattr.c                                |    2 +-
 fs/udf/balloc.c                                    |    2 +-
 fs/xfs/linux-2.6/xfs_lrw.c                         |    2 +-
 fs/xfs/quota/xfs_qm_bhv.c                          |    2 +-
 include/drm/ttm/ttm_bo_driver.h                    |    2 +-
 include/linux/can/error.h                          |    2 +-
 include/linux/fb.h                                 |    4 ++--
 include/linux/notifier.h                           |    4 ++--
 include/linux/usb.h                                |    2 +-
 include/linux/uwb.h                                |    4 ++--
 kernel/irq/chip.c                                  |    4 ++--
 kernel/latencytop.c                                |    2 +-
 kernel/user-return-notifier.c                      |    2 +-
 lib/textsearch.c                                   |    2 +-
 lib/ts_bm.c                                        |    2 +-
 mm/backing-dev.c                                   |    4 ++--
 mm/hugetlb.c                                       |    3 ++-
 mm/kmemleak.c                                      |    6 +++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c     |    2 +-
 net/mac80211/rc80211_pid.h                         |    2 +-
 net/netfilter/nf_conntrack_sip.c                   |    2 +-
 net/sunrpc/xprtsock.c                              |    4 ++--
 sound/pci/pcxhr/pcxhr_core.c                       |    4 ++--
 sound/ppc/snd_ps3.c                                |    2 +-
 sound/ppc/snd_ps3_reg.h                            |    8 ++++----
 141 files changed, 191 insertions(+), 190 deletions(-)

diff --git a/Documentation/ia64/aliasing-test.c b/Documentation/ia64/aliasing-test.c
index 3dfb76c..5caa2af 100644
--- a/Documentation/ia64/aliasing-test.c
+++ b/Documentation/ia64/aliasing-test.c
@@ -177,7 +177,7 @@ static int scan_rom(char *path, char *file)
 
 			/*
 			 * It's OK if the ROM is unreadable.  Maybe there
-			 * is no ROM, or some other error ocurred.  The
+			 * is no ROM, or some other error occurred.  The
 			 * important thing is that no MCA happened.
 			 */
 			if (rc > 0)
diff --git a/arch/alpha/oprofile/op_model_ev67.c b/arch/alpha/oprofile/op_model_ev67.c
index 7030208..5b9d178 100644
--- a/arch/alpha/oprofile/op_model_ev67.c
+++ b/arch/alpha/oprofile/op_model_ev67.c
@@ -192,7 +192,7 @@ ev67_handle_interrupt(unsigned long which, struct pt_regs *regs,
 		case TRAP_INVALID1:
 		case TRAP_INVALID2:
 		case TRAP_INVALID3:
-			/* Pipeline redirection ocurred. PMPC points
+			/* Pipeline redirection occurred. PMPC points
 			   to PALcode. Recognize ITB miss by PALcode
 			   offset address, and get actual PC from
 			   EXC_ADDR.  */
diff --git a/arch/arm/mach-iop13xx/pci.c b/arch/arm/mach-iop13xx/pci.c
index 4873f26..91b0637 100644
--- a/arch/arm/mach-iop13xx/pci.c
+++ b/arch/arm/mach-iop13xx/pci.c
@@ -224,7 +224,7 @@ static u32 iop13xx_atue_cfg_address(struct pci_bus *bus, int devfn, int where)
 /* This routine checks the status of the last configuration cycle.  If an error
  * was detected it returns >0, else it returns a 0.  The errors being checked
  * are parity, master abort, target abort (master and target).  These types of
- * errors occure during a config cycle where there is no device, like during
+ * errors occur during a config cycle where there is no device, like during
  * the discovery stage.
  */
 static int iop13xx_atux_pci_status(int clear)
@@ -331,7 +331,7 @@ static struct pci_ops iop13xx_atux_ops = {
 /* This routine checks the status of the last configuration cycle.  If an error
  * was detected it returns >0, else it returns a 0.  The errors being checked
  * are parity, master abort, target abort (master and target).  These types of
- * errors occure during a config cycle where there is no device, like during
+ * errors occur during a config cycle where there is no device, like during
  * the discovery stage.
  */
 static int iop13xx_atue_pci_status(int clear)
diff --git a/arch/ia64/include/asm/perfmon_default_smpl.h b/arch/ia64/include/asm/perfmon_default_smpl.h
index 74724b2..a2d560c 100644
--- a/arch/ia64/include/asm/perfmon_default_smpl.h
+++ b/arch/ia64/include/asm/perfmon_default_smpl.h
@@ -67,8 +67,8 @@ typedef struct {
         unsigned long   ip;                     /* where did the overflow interrupt happened  */
         unsigned long   tstamp;                 /* ar.itc when entering perfmon intr. handler */
 
-        unsigned short  cpu;                    /* cpu on which the overflow occured */
-        unsigned short  set;                    /* event set active when overflow ocurred   */
+        unsigned short  cpu;                    /* cpu on which the overflow occurred */
+        unsigned short  set;                    /* event set active when overflow occurred   */
         int    		tgid;              	/* thread group id (for NPTL, this is getpid()) */
 } pfm_default_smpl_entry_t;
 
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index b817df1..2a13cd5 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -776,7 +776,7 @@ void __init early_init_devtree(void *params)
 	initial_boot_params = params;
 
 #ifdef CONFIG_PHYP_DUMP
-	/* scan tree to see if dump occured during last boot */
+	/* scan tree to see if dump occurred during last boot */
 	of_scan_flat_dt(early_init_dt_scan_phyp_dump, NULL);
 #endif
 
diff --git a/arch/mips/include/asm/octeon/cvmx-l2c.h b/arch/mips/include/asm/octeon/cvmx-l2c.h
index 2a8c090..966d49a 100644
--- a/arch/mips/include/asm/octeon/cvmx-l2c.h
+++ b/arch/mips/include/asm/octeon/cvmx-l2c.h
@@ -125,7 +125,7 @@ enum cvmx_l2c_event {
 
 /**
  * Configure one of the four L2 Cache performance counters to capture event
- * occurences.
+ * occurrences.
  *
  * @counter:        The counter to configure. Range 0..3.
  * @event:          The type of L2 Cache event occurrence to count.
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index f3d73e1..4ba5660 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -407,7 +407,7 @@ unsigned long unwind_stack(struct task_struct *task, unsigned long *sp,
 	if (!kallsyms_lookup_size_offset(pc, &size, &ofs))
 		return 0;
 	/*
-	 * Return ra if an exception occured at the first instruction
+	 * Return ra if an exception occurred at the first instruction
 	 */
 	if (unlikely(ofs == 0)) {
 		pc = *ra;
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 4ec3008..832a07b 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -1173,7 +1173,7 @@ void __init early_init_devtree(void *params)
 #endif
 
 #ifdef CONFIG_PHYP_DUMP
-	/* scan tree to see if dump occured during last boot */
+	/* scan tree to see if dump occurred during last boot */
 	of_scan_flat_dt(early_init_dt_scan_phyp_dump, NULL);
 #endif
 
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index d069ff8..df49820 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -834,7 +834,7 @@ void __kprobes program_check_exception(struct pt_regs *regs)
 	 * ESR_DST (!?) or 0.  In the process of chasing this with the
 	 * hardware people - not sure if it can happen on any illegal
 	 * instruction or only on FP instructions, whether there is a
-	 * pattern to occurences etc. -dgibson 31/Mar/2003 */
+	 * pattern to occurrences etc. -dgibson 31/Mar/2003 */
 	switch (do_mathemu(regs)) {
 	case 0:
 		emulate_single_step(regs);
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 2c9e522..02b416f 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1470,7 +1470,7 @@ static int cell_global_start(struct op_counter_config *ctr)
  * trace buffer at the maximum rate possible.  The trace buffer is configured
  * to store the PCs, wrapping when it is full.  The performance counter is
  * intialized to the max hardware count minus the number of events, N, between
- * samples.  Once the N events have occured, a HW counter overflow occurs
+ * samples.  Once the N events have occurred, a HW counter overflow occurs
  * causing the generation of a HW counter interrupt which also stops the
  * writing of the SPU PC values to the trace buffer.  Hence the last PC
  * written to the trace buffer is the SPU PC that we want.  Unfortunately,
diff --git a/arch/powerpc/platforms/pseries/eeh.c b/arch/powerpc/platforms/pseries/eeh.c
index ccd8dd0..5276e6a 100644
--- a/arch/powerpc/platforms/pseries/eeh.c
+++ b/arch/powerpc/platforms/pseries/eeh.c
@@ -67,7 +67,7 @@
  *  with EEH.
  *
  *  Ideally, a PCI device driver, when suspecting that an isolation
- *  event has occured (e.g. by reading 0xff's), will then ask EEH
+ *  event has occurred (e.g. by reading 0xff's), will then ask EEH
  *  whether this is the case, and then take appropriate steps to
  *  reset the PCI slot, the PCI device, and then resume operations.
  *  However, until that day,  the checking is done here, with the
diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index e85679a..26c09af 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -183,7 +183,7 @@ struct esw3 {
  * The irb that is handed to the device driver when an interrupt occurs. For
  * solicited interrupts, the common I/O layer already performs checks whether
  * a field is valid; a field not being valid is always passed as %0.
- * If a unit check occured, @ecw may contain sense data; this is retrieved
+ * If a unit check occurred, @ecw may contain sense data; this is retrieved
  * by the common I/O layer itself if the device doesn't support concurrent
  * sense (so that the device driver never needs to perform basic sene itself).
  * For unsolicited interrupts, the irb is passed as-is (expect for sense data,
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 65065ac..b0ea27f 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -1087,7 +1087,7 @@ static void etr_work_fn(struct work_struct *work)
 	/*
 	 * Update eacr and try to synchronize the clock. If the update
 	 * of eacr caused a stepping port switch (or if we have to
-	 * assume that a stepping port switch has occured) or the
+	 * assume that a stepping port switch has occurred) or the
 	 * clock syncing failed, reset the sync check control bit
 	 * and set up a timer to try again after 0.5 seconds
 	 */
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5dc9e8c..b9fae64 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -245,7 +245,7 @@ void __init pcibios_resource_survey(void)
 	e820_reserve_resources_late();
 	/*
 	 * Insert the IO APIC resources after PCI initialization has
-	 * occured to handle IO APICS that are mapped in on a BAR in
+	 * occurred to handle IO APICS that are mapped in on a BAR in
 	 * PCI space, but before trying to assign unassigned pci res.
 	 */
 	ioapic_insert_resources();
diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 2cabadc..2233b4a 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -442,8 +442,8 @@ int acpi_processor_notify_smm(struct module *calling_module)
 	if (!try_module_get(calling_module))
 		return -EINVAL;
 
-	/* is_done is set to negative if an error occured,
-	 * and to postitive if _no_ error occured, but SMM
+	/* is_done is set to negative if an error occurred,
+	 * and to postitive if _no_ error occurred, but SMM
 	 * was already notified. This avoids double notification
 	 * which might lead to unexpected results...
 	 */
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 0ea97c9..b8a9d34 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1803,7 +1803,7 @@ static int speed_down_verdict_cb(struct ata_ering_entry *ent, void *void_arg)
  *	   occurred during last 5 mins, NCQ_OFF.
  *
  *	3. If more than 8 ATA_BUS, TOUT_HSM or UNK_DEV errors
- *	   ocurred during last 5 mins, FALLBACK_TO_PIO
+ *	   occurred during last 5 mins, FALLBACK_TO_PIO
  *
  *	4. If more than 3 TOUT_HSM or UNK_DEV errors occurred
  *	   during last 10 mins, NCQ_OFF.
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index e5c5415..84a02c8 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -618,7 +618,7 @@ static void ace_fsm_dostate(struct ace_device *ace)
 		ace_dump_mem(ace->cf_id, 512);	/* Debug: Dump out disk ID */
 
 		if (ace->data_result) {
-			/* Error occured, disable the disk */
+			/* Error occurred, disable the disk */
 			ace->media_change = 1;
 			set_capacity(ace->gd, 0);
 			dev_err(ace->dev, "error fetching CF id (%i)\n",
@@ -798,7 +798,7 @@ static int ace_interrupt_checkstate(struct ace_device *ace)
 	u32 sreg = ace_in32(ace, ACE_STATUS);
 	u16 creg = ace_in(ace, ACE_CTRL);
 
-	/* Check for error occurance */
+	/* Check for error occurrence */
 	if ((sreg & (ACE_STATUS_CFGERROR | ACE_STATUS_CFCERROR)) &&
 	    (creg & ACE_CTRL_ERRORIRQ)) {
 		dev_err(ace->dev, "transfer failure\n");
diff --git a/drivers/char/hvc_iucv.c b/drivers/char/hvc_iucv.c
index fe62bd0..7e974b1 100644
--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -252,7 +252,7 @@ static int hvc_iucv_write(struct hvc_iucv_private *priv,
 		default:
 			written = -EIO;
 		}
-		/* remove buffer if an error has occured or received data
+		/* remove buffer if an error has occurred or received data
 		 * is not correct */
 		if (rc || (rb->mbuf->version != MSG_VERSION) ||
 			  (rb->msg.length    != MSG_SIZE(rb->mbuf->datalen)))
@@ -617,7 +617,7 @@ static void hvc_iucv_hangup(struct hvc_iucv_private *priv)
  *		the index of an struct hvc_iucv_private instance.
  *
  * This routine notifies the HVC back-end that a tty hangup (carrier loss,
- * virtual or otherwise) has occured.
+ * virtual or otherwise) has occurred.
  * The z/VM IUCV HVC device driver ignores virtual hangups (vhangup())
  * to keep an existing IUCV communication path established.
  * (Background: vhangup() is called from user space (by getty or login) to
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 000dc67..5c622ff 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2037,8 +2037,8 @@ static int amd64_get_error_info(struct mem_ctl_info *mci,
 	 * Can you see the race condition? All four error reporting registers
 	 * must be read before a new error updates them! There is no way to read
 	 * all four registers atomically. The best than can be done is to detect
-	 * that a race has occured and then report the error without any kind of
-	 * precision.
+	 * that a race has occurred and then report the error without any kind
+	 * of precision.
 	 *
 	 * What is still positive is that errors are still reported and thus
 	 * problems can still be detected - just not localized because the
diff --git a/drivers/edac/edac_core.h b/drivers/edac/edac_core.h
index 001b2e7..4a75e2b 100644
--- a/drivers/edac/edac_core.h
+++ b/drivers/edac/edac_core.h
@@ -813,7 +813,7 @@ extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
  * There are a limited number of error logging registers that can
  * be exausted.  When all registers are exhausted and an additional
  * error occurs then an error overflow register records that an
- * error occured and the type of error, but doesn't have any
+ * error occurred and the type of error, but doesn't have any
  * further information.  The ce/ue versions make for cleaner
  * reporting logic and function interface - reduces conditional
  * statement clutter and extra function arguments.
diff --git a/drivers/edac/i82443bxgx_edac.c b/drivers/edac/i82443bxgx_edac.c
index 577760a..87f7b2f 100644
--- a/drivers/edac/i82443bxgx_edac.c
+++ b/drivers/edac/i82443bxgx_edac.c
@@ -306,7 +306,7 @@ static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 	i82443bxgx_init_csrows(mci, pdev, edac_mode, mtype);
 
 	/* Many BIOSes don't clear error flags on boot, so do this
-	 * here, or we get "phantom" errors occuring at module-load
+	 * here, or we get "phantom" errors occurring at module-load
 	 * time. */
 	pci_write_bits32(pdev, I82443BXGX_EAP,
 			(I82443BXGX_EAP_OFFSET_SBE |
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 2c16694..e507e40 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -548,7 +548,7 @@ typedef struct drm_i915_private {
 		 * Flag if the hardware appears to be wedged.
 		 *
 		 * This is set when attempts to idle the device timeout.
-		 * It prevents command submission from occuring and makes
+		 * It prevents command submission from occurring and makes
 		 * every pending request fail
 		 */
 		atomic_t wedged;
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 1ac0c93..99d02bd 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -130,7 +130,7 @@ static inline void vga_irq_set_state(struct vga_device *vgadev, bool state)
 static void vga_check_first_use(void)
 {
 	/* we should inform all GPUs in the system that
-	 * VGA arb has occured and to try and disable resources
+	 * VGA arb has occurred and to try and disable resources
 	 * if they can */
 	if (!vga_arbiter_used) {
 		vga_arbiter_used = true;
diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index 864a371..c1615b0 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -250,7 +250,7 @@ static inline int sht15_update_single_val(struct sht15_data *data,
 	enable_irq(gpio_to_irq(data->pdata->gpio_data));
 	if (gpio_get_value(data->pdata->gpio_data) == 0) {
 		disable_irq_nosync(gpio_to_irq(data->pdata->gpio_data));
-		/* Only relevant if the interrupt hasn't occured. */
+		/* Only relevant if the interrupt hasn't occurred. */
 		if (!atomic_read(&data->interrupt_handled))
 			schedule_work(&data->read_work);
 	}
@@ -451,7 +451,7 @@ static void sht15_bh_read_data(struct work_struct *work_s)
 		*/
 		atomic_set(&data->interrupt_handled, 0);
 		enable_irq(gpio_to_irq(data->pdata->gpio_data));
-		/* If still not occured or another handler has been scheduled */
+		/* If still not occurred or another handler has been scheduled */
 		if (gpio_get_value(data->pdata->gpio_data)
 		    || atomic_read(&data->interrupt_handled))
 			return;
diff --git a/drivers/input/mouse/vsxxxaa.c b/drivers/input/mouse/vsxxxaa.c
index bf2c0c8..eb9a3cf 100644
--- a/drivers/input/mouse/vsxxxaa.c
+++ b/drivers/input/mouse/vsxxxaa.c
@@ -334,7 +334,7 @@ static void vsxxxaa_handle_POR_packet(struct vsxxxaa *mouse)
 	 * M: manufacturer location code
 	 * R: revision code
 	 * E: Error code. If it's in the range of 0x00..0x1f, only some
-	 *    minor problem occured. Errors >= 0x20 are considered bad
+	 *    minor problem occurred. Errors >= 0x20 are considered bad
 	 *    and the device may not work properly...
 	 * D: <0010> == mouse, <0100> == tablet
 	 */
diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
index a12fa4d..5af01a0 100644
--- a/drivers/isdn/hisax/l3dss1.c
+++ b/drivers/isdn/hisax/l3dss1.c
@@ -1594,7 +1594,7 @@ l3dss1_setup(struct l3_process *pc, u_char pr, void *arg)
 	 * Bearer Capabilities
 	 */
 	p = skb->data;
-	/* only the first occurence 'll be detected ! */
+	/* only the first occurrence 'll be detected ! */
 	if ((p = findie(p, skb->len, 0x04, 0))) {
 		if ((p[1] < 2) || (p[1] > 11))
 			err = 1;
diff --git a/drivers/isdn/hisax/l3ni1.c b/drivers/isdn/hisax/l3ni1.c
index 4622d43..7aafce2 100644
--- a/drivers/isdn/hisax/l3ni1.c
+++ b/drivers/isdn/hisax/l3ni1.c
@@ -1448,7 +1448,7 @@ l3ni1_setup(struct l3_process *pc, u_char pr, void *arg)
 	 * Bearer Capabilities
 	 */
 	p = skb->data;
-	/* only the first occurence 'll be detected ! */
+	/* only the first occurrence 'll be detected ! */
 	if ((p = findie(p, skb->len, 0x04, 0))) {
 		if ((p[1] < 2) || (p[1] > 11))
 			err = 1;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 8e4c75c..9926514 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -71,7 +71,7 @@ struct mdk_rdev_s
 #define	AllReserved	6		/* If whole device is reserved for
 					 * one array */
 #define	AutoDetected	7		/* added by auto-detect */
-#define Blocked		8		/* An error occured on an externally
+#define Blocked		8		/* An error occurred on an externally
 					 * managed array, don't allow writes
 					 * until it is cleared */
 #define StateChanged	9		/* Faulty or Blocked has changed during
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index 48cb154..b741cab 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -161,7 +161,7 @@ static int saa7146_i2c_reset(struct saa7146_dev *dev)
 		msleep(SAA7146_I2C_DELAY);
 	}
 
-	/* if any error is still present, a fatal error has occured ... */
+	/* if any error is still present, a fatal error has occurred ... */
 	status = saa7146_i2c_status(dev);
 	if ( dev->i2c_bitrate != status ) {
 		DEB_I2C(("fatal error. status:0x%08x\n",status));
@@ -326,9 +326,9 @@ static int saa7146_i2c_transfer(struct saa7146_dev *dev, const struct i2c_msg *m
 			if ( 0 != err) {
 				/* this one is unsatisfying: some i2c slaves on some
 				   dvb cards don't acknowledge correctly, so the saa7146
-				   thinks that an address error occured. in that case, the
+				   thinks that an address error occurred. in that case, the
 				   transaction should be retrying, even if an address error
-				   occured. analog saa7146 based cards extensively rely on
+				   occurred. analog saa7146 based cards extensively rely on
 				   i2c address probing, however, and address errors indicate that a
 				   device is really *not* there. retrying in that case
 				   increases the time the device needs to probe greatly, so
diff --git a/drivers/media/dvb/b2c2/flexcop-pci.c b/drivers/media/dvb/b2c2/flexcop-pci.c
index 227c020..9552540 100644
--- a/drivers/media/dvb/b2c2/flexcop-pci.c
+++ b/drivers/media/dvb/b2c2/flexcop-pci.c
@@ -58,7 +58,7 @@ struct flexcop_pci {
 
 	int active_dma1_addr; /* 0 = addr0 of dma1; 1 = addr1 of dma1 */
 	u32 last_dma1_cur_pos;
-	/* position of the pointer last time the timer/packet irq occured */
+	/* position of the pointer last time the timer/packet irq occurred */
 	int count;
 	int count_prev;
 	int stream_problem;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 0746122..5709c83 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -1634,7 +1634,7 @@ static int dvb_frontend_ioctl_legacy(struct inode *inode, struct file *file,
 	case FE_READ_STATUS: {
 		fe_status_t* status = parg;
 
-		/* if retune was requested but hasn't occured yet, prevent
+		/* if retune was requested but hasn't occurred yet, prevent
 		 * that user get signal state from previous tuning */
 		if (fepriv->state == FESTATE_RETUNE ||
 		    fepriv->state == FESTATE_ERROR) {
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-init.c b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
index e331db8..6c04c75 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-init.c
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-init.c
@@ -83,7 +83,7 @@ static int dvb_usb_adapter_init(struct dvb_usb_device *d, short *adapter_nrs)
 
 	/*
 	 * when reloading the driver w/o replugging the device
-	 * sometimes a timeout occures, this helps
+	 * sometimes a timeout occurs, this helps
 	 */
 	if (d->props.generic_bulk_ctrl_endpoint != 0) {
 		usb_clear_halt(d->udev,usb_sndbulkpipe(d->udev,d->props.generic_bulk_ctrl_endpoint));
diff --git a/drivers/media/dvb/pluto2/pluto2.c b/drivers/media/dvb/pluto2/pluto2.c
index 80d14a0..61a3016 100644
--- a/drivers/media/dvb/pluto2/pluto2.c
+++ b/drivers/media/dvb/pluto2/pluto2.c
@@ -331,7 +331,7 @@ static irqreturn_t pluto_irq(int irq, void *dev_id)
 	struct pluto *pluto = dev_id;
 	u32 tscr;
 
-	/* check whether an interrupt occured on this device */
+	/* check whether an interrupt occurred on this device */
 	tscr = pluto_readreg(pluto, REG_TSCR);
 	if (!(tscr & (TSCR_DE | TSCR_OVR)))
 		return IRQ_NONE;
diff --git a/drivers/media/video/saa7164/saa7164-cmd.c b/drivers/media/video/saa7164/saa7164-cmd.c
index 9c1d3ac..814d210 100644
--- a/drivers/media/video/saa7164/saa7164-cmd.c
+++ b/drivers/media/video/saa7164/saa7164-cmd.c
@@ -241,7 +241,7 @@ out:
 }
 
 /* Wait for a signal event, without holding a mutex. Either return TIMEOUT if
- * the event never occured, or SAA_OK if it was signaled during the wait.
+ * the event never occurred, or SAA_OK if it was signaled during the wait.
  */
 int saa7164_cmd_wait(struct saa7164_dev *dev, u8 seqno)
 {
diff --git a/drivers/media/video/uvc/uvc_video.c b/drivers/media/video/uvc/uvc_video.c
index 7dcf534..d1c7bb5 100644
--- a/drivers/media/video/uvc/uvc_video.c
+++ b/drivers/media/video/uvc/uvc_video.c
@@ -359,7 +359,7 @@ int uvc_commit_video(struct uvc_streaming *stream,
  *
  * uvc_video_decode_end is called with header data at the end of a bulk or
  * isochronous payload. It performs any additional header data processing and
- * returns 0 or a negative error code if an error occured. As header data have
+ * returns 0 or a negative error code if an error occurred. As header data have
  * already been processed by uvc_video_decode_start, this functions isn't
  * required to perform sanity checks a second time.
  *
@@ -597,7 +597,7 @@ static void uvc_video_decode_bulk(struct urb *urb, struct uvc_streaming *stream,
 							    buf);
 		} while (ret == -EAGAIN);
 
-		/* If an error occured skip the rest of the payload. */
+		/* If an error occurred skip the rest of the payload. */
 		if (ret < 0 || buf == NULL) {
 			stream->bulk.skip_payload = 1;
 		} else {
diff --git a/drivers/message/fusion/lsi/mpi_log_sas.h b/drivers/message/fusion/lsi/mpi_log_sas.h
index 691620d..c8765c9 100644
--- a/drivers/message/fusion/lsi/mpi_log_sas.h
+++ b/drivers/message/fusion/lsi/mpi_log_sas.h
@@ -56,9 +56,9 @@
 #define IOP_LOGINFO_CODE_FWUPLOAD_NO_FLASH_AVAILABLE         (0x0003E000) /* Tried to upload from flash, but there is none */
 #define IOP_LOGINFO_CODE_FWUPLOAD_UNKNOWN_IMAGE_TYPE         (0x0003E001) /* ImageType field contents were invalid */
 #define IOP_LOGINFO_CODE_FWUPLOAD_WRONG_IMAGE_SIZE           (0x0003E002) /* ImageSize field in TCSGE was bad/offset in MfgPg 4 was wrong */
-#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occured while attempting to upload the entire flash */
-#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occured while attempting to upload single flash region */
-#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occured while DMAing FW to host memory */
+#define IOP_LOGINFO_CODE_FWUPLOAD_ENTIRE_FLASH_UPLOAD_FAILED (0x0003E003) /* Error occurred while attempting to upload the entire flash */
+#define IOP_LOGINFO_CODE_FWUPLOAD_REGION_UPLOAD_FAILED       (0x0003E004) /* Error occurred while attempting to upload single flash region */
+#define IOP_LOGINFO_CODE_FWUPLOAD_DMA_FAILURE                (0x0003E005) /* Problem occurred while DMAing FW to host memory */
 
 #define IOP_LOGINFO_CODE_DIAG_MSG_ERROR                      (0x00040000) /* Error handling diag msg - or'd with diag status */
 
@@ -187,8 +187,8 @@
 #define PL_LOGINFO_SUB_CODE_BREAK_ON_INCOMPLETE_BREAK_RCVD   (0x00005000)
 
 #define PL_LOGINFO_CODE_ENCL_MGMT_SMP_FRAME_FAILURE          (0x00200000) /* Can't get SMP Frame */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occured on SMP Read */
-#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occured on SMP Write */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_READ_ERROR             (0x00200010) /* Error occurred on SMP Read */
+#define PL_LOGINFO_CODE_ENCL_MGMT_SMP_WRITE_ERROR            (0x00200020) /* Error occurred on SMP Write */
 #define PL_LOGINFO_CODE_ENCL_MGMT_NOT_SUPPORTED_ON_ENCL      (0x00200040) /* Encl Mgmt services not available for this WWID */
 #define PL_LOGINFO_CODE_ENCL_MGMT_ADDR_MODE_NOT_SUPPORTED    (0x00200050) /* Address Mode not suppored */
 #define PL_LOGINFO_CODE_ENCL_MGMT_BAD_SLOT_NUM               (0x00200060) /* Invalid Slot Number in SEP Msg */
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 352acd0..dab6c54 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -2364,7 +2364,7 @@ done_free_mem:
 	}
 
 	/* mf is null if command issued successfully
-	 * otherwise, failure occured after mf acquired.
+	 * otherwise, failure occurred after mf acquired.
 	 */
 	if (mf)
 		mpt_free_msg_frame(ioc, mf);
diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 34749ee..9e9bdda 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -229,7 +229,7 @@ again:
 	bid = blade_id < 0 ? uv_numa_blade_id() : blade_id;
 	bs = gru_base[bid];
 
-	/* Handle the case where migration occured while waiting for the sema */
+	/* Handle the case where migration occurred while waiting for the sema */
 	down_read(&bs->bs_kgts_sema);
 	if (blade_id < 0 && bid != uv_numa_blade_id()) {
 		up_read(&bs->bs_kgts_sema);
diff --git a/drivers/mtd/chips/cfi_cmdset_0001.c b/drivers/mtd/chips/cfi_cmdset_0001.c
index 5fbf29e..ff5b5a8 100644
--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1269,12 +1269,12 @@ static int inval_cache_and_wait_for_operation(
 			spin_lock(chip->mutex);
 		}
 		if (chip->erase_suspended && chip_state == FL_ERASING)  {
-			/* Erase suspend occured while sleep: reset timeout */
+			/* Erase suspend occurred while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->erase_suspended = 0;
 		}
 		if (chip->write_suspended && chip_state == FL_WRITING)  {
-			/* Write suspend occured while sleep: reset timeout */
+			/* Write suspend occurred while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->write_suspended = 0;
 		}
diff --git a/drivers/mtd/lpddr/lpddr_cmds.c b/drivers/mtd/lpddr/lpddr_cmds.c
index e22ca49..4c97477 100644
--- a/drivers/mtd/lpddr/lpddr_cmds.c
+++ b/drivers/mtd/lpddr/lpddr_cmds.c
@@ -171,7 +171,7 @@ static int wait_for_ready(struct map_info *map, struct flchip *chip,
 			spin_lock(chip->mutex);
 		}
 		if (chip->erase_suspended || chip->write_suspended)  {
-			/* Suspend has occured while sleep: reset timeout */
+			/* Suspend has occurred while sleep: reset timeout */
 			timeo = reset_timeo;
 			chip->erase_suspended = chip->write_suspended = 0;
 		}
diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 5b081cb..44ae634 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -200,7 +200,7 @@ static ssize_t mtd_read(struct file *file, char __user *buf, size_t count,loff_t
 		 * the data. For our userspace tools it is important
 		 * to dump areas with ecc errors !
 		 * For kernel internal usage it also might return -EUCLEAN
-		 * to signal the caller that a bitflip has occured and has
+		 * to signal the caller that a bitflip has occurred and has
 		 * been corrected by the ECC algorithm.
 		 * Userspace software which accesses NAND this way
 		 * must be aware of the fact that it deals with NAND
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index b126cf8..fecb5f8 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -985,7 +985,7 @@ static int doc200x_correct_data(struct mtd_info *mtd, u_char *dat,
 		dummy = ReadDOC(docptr, ECCConf);
 	}
 
-	/* Error occured ? */
+	/* Error occurred ? */
 	if (dummy & 0x80) {
 		for (i = 0; i < 6; i++) {
 			if (DoC_is_MillenniumPlus(doc))
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 8f2958f..90022d9 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -464,7 +464,7 @@ void nand_wait_ready(struct mtd_info *mtd)
 		return panic_nand_wait_ready(mtd, 400);
 
 	led_trigger_event(nand_led_trigger, LED_FULL);
-	/* wait until command is processed or timeout occures */
+	/* wait until command is processed or timeout occurs */
 	do {
 		if (chip->dev_ready(mtd))
 			break;
diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 542a4f7..ddd7251 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -396,7 +396,7 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 			cf->data[3] = ecc & ECC_SEG;
 			break;
 		}
-		/* Error occured during transmission? */
+		/* Error occurred during transmission? */
 		if ((ecc & ECC_DIR) == 0)
 			cf->data[2] |= CAN_ERR_PROT_TX;
 	}
diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index efbb05c..a31049c 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -388,7 +388,7 @@ static void ems_usb_rx_err(struct ems_usb *dev, struct ems_cpc_msg *msg)
 			break;
 		}
 
-		/* Error occured during transmission? */
+		/* Error occurred during transmission? */
 		if ((ecc & SJA1000_ECC_DIR) == 0)
 			cf->data[2] |= CAN_ERR_PROT_TX;
 
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index f857afe..e3693fc 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -5234,7 +5234,7 @@ err_out_free_res:
 	pci_release_regions(pdev);
 
 err_write_cacheline:
-	/* Try to restore it in case the error occured after we
+	/* Try to restore it in case the error occurred after we
 	 * set it.
 	 */
 	pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, orig_cacheline_size);
diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 032cfe0..cc16fa2 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -1391,11 +1391,11 @@ struct intr_info {
  *	@reg: the interrupt status register to process
  *	@mask: a mask to apply to the interrupt status
  *	@acts: table of interrupt actions
- *	@stats: statistics counters tracking interrupt occurences
+ *	@stats: statistics counters tracking interrupt occurrences
  *
  *	A table driven interrupt handler that applies a set of masks to an
  *	interrupt status word and performs the corresponding actions if the
- *	interrupts described by the mask have occured.  The actions include
+ *	interrupts described by the mask have occurred.  The actions include
  *	optionally printing a warning or alert message, and optionally
  *	incrementing a stat counter.  The table is terminated by an entry
  *	specifying mask 0.  Returns the number of fatal interrupt conditions.
diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index c45965a..b04753e 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -4223,7 +4223,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IP))
 		tx_flags |= E1000_TX_FLAGS_IPV4;
 
-	/* if count is 0 then mapping error has occured */
+	/* if count is 0 then mapping error has occurred */
 	count = e1000_tx_map(adapter, skb, first, max_per_txd, nr_frags, mss);
 	if (count) {
 		e1000_tx_queue(adapter, tx_flags, count);
diff --git a/drivers/net/igb/e1000_phy.c b/drivers/net/igb/e1000_phy.c
index 3670a66..11bd570 100644
--- a/drivers/net/igb/e1000_phy.c
+++ b/drivers/net/igb/e1000_phy.c
@@ -1326,7 +1326,7 @@ out:
 }
 
 /**
- *  igb_check_downshift - Checks whether a downshift in speed occured
+ *  igb_check_downshift - Checks whether a downshift in speed occurred
  *  @hw: pointer to the HW structure
  *
  *  Success returns 0, Failure returns 1
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 933c64f..b011260 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3784,7 +3784,7 @@ netdev_tx_t igb_xmit_frame_ring_adv(struct sk_buff *skb,
 
 	/*
 	 * count reflects descriptors mapped, if 0 or less then mapping error
-	 * has occured and we need to rewind the descriptor queue
+	 * has occurred and we need to rewind the descriptor queue
 	 */
 	count = igb_tx_map_adv(tx_ring, skb, first);
 	if (!count) {
diff --git a/drivers/net/igbvf/netdev.c b/drivers/net/igbvf/netdev.c
index 0dbd032..7eba4c6 100644
--- a/drivers/net/igbvf/netdev.c
+++ b/drivers/net/igbvf/netdev.c
@@ -2294,7 +2294,7 @@ static netdev_tx_t igbvf_xmit_frame_ring_adv(struct sk_buff *skb,
 
 	/*
 	 * count reflects descriptors mapped, if 0 then mapping error
-	 * has occured and we need to rewind the descriptor queue
+	 * has occurred and we need to rewind the descriptor queue
 	 */
 	count = igbvf_tx_map_adv(adapter, tx_ring, skb, first);
 
diff --git a/drivers/net/irda/pxaficp_ir.c b/drivers/net/irda/pxaficp_ir.c
index 84db145..8c62926 100644
--- a/drivers/net/irda/pxaficp_ir.c
+++ b/drivers/net/irda/pxaficp_ir.c
@@ -482,7 +482,7 @@ static irqreturn_t pxa_irda_fir_irq(int irq, void *dev_id)
 	}
 
 	if (icsr0 & ICSR0_EIF) {
-		/* An error in FIFO occured, or there is a end of frame */
+		/* An error in FIFO occurred, or there is a end of frame */
 		pxa_irda_fir_irq_eif(si, dev, icsr0);
 	}
 
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index cc42186..b20bad5 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3569,7 +3569,7 @@ static void s2io_reset(struct s2io_nic *sp)
 	}
 
 	/*
-	 * Clear spurious ECC interrupts that would have occured on
+	 * Clear spurious ECC interrupts that would have occurred on
 	 * XFRAME II cards after reset.
 	 */
 	if (sp->device_type == XFRAME_II_DEVICE) {
diff --git a/drivers/net/skge.h b/drivers/net/skge.h
index 831de1b..3907a85 100644
--- a/drivers/net/skge.h
+++ b/drivers/net/skge.h
@@ -2227,7 +2227,7 @@ enum {
 	XM_ST_BC	= 1<<7,		/* Bit  7:	Broadcast packet */
 	XM_ST_MC	= 1<<6,		/* Bit  6:	Multicast packet */
 	XM_ST_UC	= 1<<5,		/* Bit  5:	Unicast packet */
-	XM_ST_TX_UR	= 1<<4,		/* Bit  4:	FIFO Underrun occured */
+	XM_ST_TX_UR	= 1<<4,		/* Bit  4:	FIFO Underrun occurred */
 	XM_ST_CS_ERR	= 1<<3,		/* Bit  3:	Carrier Sense Error */
 	XM_ST_LAT_COL	= 1<<2,		/* Bit  2:	Late Collision Error */
 	XM_ST_MUL_COL	= 1<<1,		/* Bit  1:	Multiple Collisions */
diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
index 75a669d..122a430 100644
--- a/drivers/net/tc35815.c
+++ b/drivers/net/tc35815.c
@@ -339,7 +339,7 @@ struct BDesc {
 #define TX_THRESHOLD	1024
 /* used threshold with packet max byte for low pci transfer ability.*/
 #define TX_THRESHOLD_MAX 1536
-/* setting threshold max value when overrun error occured this count. */
+/* setting threshold max value when overrun error occurred this count. */
 #define TX_THRESHOLD_KEEP_LIMIT 10
 
 /* 16 + RX_BUF_NUM * 8 + RX_FD_NUM * 16 + TX_FD_NUM * 32 <= PAGE_SIZE*FD_PAGE_NUM */
diff --git a/drivers/net/tsi108_eth.h b/drivers/net/tsi108_eth.h
index 5a77ae6..5fee7d7 100644
--- a/drivers/net/tsi108_eth.h
+++ b/drivers/net/tsi108_eth.h
@@ -305,9 +305,9 @@
 #define TSI108_TX_CRC	(1 << 5)	/* Generate CRC for this packet */
 #define TSI108_TX_INT	(1 << 14)	/* Generate an IRQ after frag. processed */
 #define TSI108_TX_RETRY	(0xf << 16)	/* 4 bit field indicating num. of retries */
-#define TSI108_TX_COL	(1 << 20)	/* Set if a collision occured */
-#define TSI108_TX_LCOL	(1 << 24)	/* Set if a late collision occured */
-#define TSI108_TX_UNDER	(1 << 25)	/* Set if a FIFO underrun occured */
+#define TSI108_TX_COL	(1 << 20)	/* Set if a collision occurred */
+#define TSI108_TX_LCOL	(1 << 24)	/* Set if a late collision occurred */
+#define TSI108_TX_UNDER	(1 << 25)	/* Set if a FIFO underrun occurred */
 #define TSI108_TX_RLIM	(1 << 26)	/* Set if the retry limit was reached */
 #define TSI108_TX_OK	(1 << 30)	/* Set if the frame TX was successful */
 #define TSI108_TX_OWN	(1 << 31)	/* Set if the device owns the descriptor */
@@ -332,7 +332,7 @@ typedef struct {
 #define TSI108_RX_RUNT	(1 << 4)/* Packet is less than minimum size */
 #define TSI108_RX_HASH	(1 << 7)/* Hash table match */
 #define TSI108_RX_BAD	(1 << 8)	/* Bad frame */
-#define TSI108_RX_OVER	(1 << 9)	/* FIFO overrun occured */
+#define TSI108_RX_OVER	(1 << 9)	/* FIFO overrun occurred */
 #define TSI108_RX_TRUNC	(1 << 11)	/* Packet truncated due to excess length */
 #define TSI108_RX_CRC	(1 << 12)	/* Packet had a CRC error */
 #define TSI108_RX_INT	(1 << 13)	/* Generate an IRQ after frag. processed */
diff --git a/drivers/net/via-rhine.c b/drivers/net/via-rhine.c
index 611b804..d495e2a 100644
--- a/drivers/net/via-rhine.c
+++ b/drivers/net/via-rhine.c
@@ -1586,7 +1586,7 @@ static void rhine_restart_tx(struct net_device *dev) {
 	u32 intr_status;
 
 	/*
-	 * If new errors occured, we need to sort them out before doing Tx.
+	 * If new errors occurred, we need to sort them out before doing Tx.
 	 * In that case the ISR will be back here RSN anyway.
 	 */
 	intr_status = get_intr_status(dev);
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 9cc4382..decef57 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -835,7 +835,7 @@ vmxnet3_prepare_tso(struct sk_buff *skb,
  * Transmits a pkt thru a given tq
  * Returns:
  *    NETDEV_TX_OK:      descriptors are setup successfully
- *    NETDEV_TX_OK:      error occured, the pkt is dropped
+ *    NETDEV_TX_OK:      error occurred, the pkt is dropped
  *    NETDEV_TX_BUSY:    tx ring is full, queue is stopped
  *
  * Side-effects:
diff --git a/drivers/net/vxge/vxge-traffic.h b/drivers/net/vxge/vxge-traffic.h
index 861c853..2d5a65e 100644
--- a/drivers/net/vxge/vxge-traffic.h
+++ b/drivers/net/vxge/vxge-traffic.h
@@ -681,7 +681,7 @@ struct vxge_hw_xmac_aggr_stats {
  * @rx_red_discard: Count of received frames that are discarded because of RED
  *            (Random Early Discard).
  * @rx_xgmii_ctrl_err_cnt: Maintains a count of unexpected or misplaced control
- *            characters occuring between times of normal data transmission
+ *            characters occurring between times of normal data transmission
  *            (i.e. not included in RX_XGMII_DATA_ERR_CNT). This counter is
  *            incremented when either -
  *            1) The Reconciliation Sublayer (RS) is expecting one control
diff --git a/drivers/net/wan/ixp4xx_hss.c b/drivers/net/wan/ixp4xx_hss.c
index c705046..77a7fbb 100644
--- a/drivers/net/wan/ixp4xx_hss.c
+++ b/drivers/net/wan/ixp4xx_hss.c
@@ -229,7 +229,7 @@
 #define PKT_PIPE_MODE_WRITE		0x57
 
 /* HDLC packet status values - desc->status */
-#define ERR_SHUTDOWN		1 /* stop or shutdown occurrance */
+#define ERR_SHUTDOWN		1 /* stop or shutdown occurrence */
 #define ERR_HDLC_ALIGN		2 /* HDLC alignment error */
 #define ERR_HDLC_FCS		3 /* HDLC Frame Check Sum error */
 #define ERR_RXFREE_Q_EMPTY	4 /* RX-free queue became empty while receiving
diff --git a/drivers/net/wimax/i2400m/i2400m-usb.h b/drivers/net/wimax/i2400m/i2400m-usb.h
index 5cc0f27..8dbd6cd 100644
--- a/drivers/net/wimax/i2400m/i2400m-usb.h
+++ b/drivers/net/wimax/i2400m/i2400m-usb.h
@@ -112,7 +112,7 @@ static inline void edc_init(struct edc *edc)
  *
  * This is way to determine if the number of acceptable errors per time
  * period has been exceeded. It is not accurate as there are cases in which
- * this scheme will not work, for example if there are periodic occurences
+ * this scheme will not work, for example if there are periodic occurrences
  * of errors that straddle updates to the start time. This scheme is
  * sufficient for our usage.
  *
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index fe3bf94..fdaa38b 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -624,7 +624,7 @@ struct b43_request_fw_context {
 	char errors[B43_NR_FWTYPES][128];
 	/* Temporary buffer for storing the firmware name. */
 	char fwname[64];
-	/* A fatal error occured while requesting. Firmware reqest
+	/* A fatal error occurred while requesting. Firmware reqest
 	 * can not continue, as any other reqest will also fail. */
 	int fatal_failure;
 };
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index 44796ba..eae764e 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2182,7 +2182,7 @@ dasd_3990_erp_inspect_32(struct dasd_ccw_req * erp, char *sense)
  * DASD_3990_ERP_CONTROL_CHECK
  *
  * DESCRIPTION
- *   Does a generic inspection if a control check occured and sets up
+ *   Does a generic inspection if a control check occurred and sets up
  *   the related error recovery procedure
  *
  * PARAMETER
@@ -2225,7 +2225,7 @@ dasd_3990_erp_inspect(struct dasd_ccw_req *erp)
 	struct dasd_ccw_req *erp_new = NULL;
 	char *sense;
 
-	/* if this problem occured on an alias retry on base */
+	/* if this problem occurred on an alias retry on base */
 	erp_new = dasd_3990_erp_inspect_alias(erp);
 	if (erp_new)
 		return erp_new;
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 482dcd9..f342c36 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1172,7 +1172,7 @@ static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 			zfcp_fsf_access_denied_port(req, port);
 		break;
 	case FSF_SBAL_MISMATCH:
-		/* should never occure, avoided in zfcp_fsf_send_els */
+		/* should never occur, avoided in zfcp_fsf_send_els */
 		/* fall through */
 	default:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 4d419c1..dd9a18d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -6237,7 +6237,7 @@ ahd_shutdown(void *arg)
 /*
  * Reset the controller and record some information about it
  * that is only available just after a reset.  If "reinit" is
- * non-zero, this reset occured after initial configuration
+ * non-zero, this reset occurred after initial configuration
  * and the caller requests that the chip be fully reinitialized
  * to a runable state.  Chip interrupts are *not* enabled after
  * a reinitialization.  The caller must enable interrupts via
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 1222a7a..4f3068c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -1867,7 +1867,7 @@ ahd_done(struct ahd_softc *ahd, struct scb *scb)
 	/*
 	 * Some devices deal with temporary internal resource
 	 * shortages by returning queue full.  When the queue
-	 * full occurrs, we throttle back.  Slowly try to get
+	 * full occurs, we throttle back.  Slowly try to get
 	 * back to our previous queue depth.
 	 */
 	if ((dev->openings + dev->active) < dev->maxtags
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 45aa728..be97b8f 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -4584,7 +4584,7 @@ ahc_shutdown(void *arg)
 /*
  * Reset the controller and record some information about it
  * that is only available just after a reset.  If "reinit" is
- * non-zero, this reset occured after initial configuration
+ * non-zero, this reset occurred after initial configuration
  * and the caller requests that the chip be fully reinitialized
  * to a runable state.  Chip interrupts are *not* enabled after
  * a reinitialization.  The caller must enable interrupts via
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 8cb05dc..cac77b9 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -1807,7 +1807,7 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
 	/*
 	 * Some devices deal with temporary internal resource
 	 * shortages by returning queue full.  When the queue
-	 * full occurrs, we throttle back.  Slowly try to get
+	 * full occurs, we throttle back.  Slowly try to get
 	 * back to our previous queue depth.
 	 */
 	if ((dev->openings + dev->active) < dev->maxtags
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index 1af578d..f3f9b0e 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -171,7 +171,7 @@ void bnx2i_arm_cq_event_coalescing(struct bnx2i_endpoint *ep, u8 action)
 
 /**
  * bnx2i_get_rq_buf - copy RQ buffer contents to driver buffer
- * @conn:		iscsi connection on which RQ event occured
+ * @conn:		iscsi connection on which RQ event occurred
  * @ptr:		driver buffer to which RQ buffer contents is to
  *			be copied
  * @len:		length of valid data inside RQ buf
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6c59c02..3689d58 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1772,7 +1772,7 @@ static void dc395x_handle_interrupt(struct AdapterCtlBlk *acb,
 		dc395x_statev(acb, srb, &scsi_status);
 
 		/* 
-		 * if there were any exception occured scsi_status
+		 * if there were any exception occurred scsi_status
 		 * will be modify to bus free phase new scsi_status
 		 * transfer out from ... previous dc395x_statev
 		 */
diff --git a/drivers/scsi/gdth.h b/drivers/scsi/gdth.h
index 1646444..c47280e 100644
--- a/drivers/scsi/gdth.h
+++ b/drivers/scsi/gdth.h
@@ -895,7 +895,7 @@ typedef struct {
         unchar          ldr_no;                 /* log. drive no. */
         unchar          rw_attribs;             /* r/w attributes */
         unchar          cluster_type;           /* cluster properties */
-        unchar          media_changed;          /* Flag:MOUNT/UNMOUNT occured */
+        unchar          media_changed;          /* Flag:MOUNT/UNMOUNT occurred */
         ulong32         start_sec;              /* start sector */
     } hdr[MAX_LDRIVES];                         /* host drives */
     struct {
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..88d75f4 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -1917,7 +1917,7 @@ static int int_initio_scsi_rst(struct initio_host * host)
 }
 
 /**
- *	int_initio_scsi_resel	-	Reselection occured
+ *	int_initio_scsi_resel	-	Reselection occurred
  *	@host: InitIO host adapter
  *
  *	A SCSI reselection event has been signalled and the interrupt
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index 0b16502..890d0c0 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -162,7 +162,7 @@ static int fc_frame_drop(struct fc_lport *lport, struct fc_frame *fp)
  * fc_lport_rport_callback() - Event handler for rport events
  * @lport: The lport which is receiving the event
  * @rdata: private remote port data
- * @event: The event that occured
+ * @event: The event that occurred
  *
  * Locking Note: The rport lock should not be held when calling
  *		 this function.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2445e39..70fcc14 100755
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -637,7 +637,7 @@ lpfc_do_work(void *p)
 
 /*
  * This is only called to handle FC worker events. Since this a rare
- * occurance, we allocate a struct lpfc_work_evt structure here instead of
+ * occurrence, we allocate a struct lpfc_work_evt structure here instead of
  * embedding it in the IOCB.
  */
 int
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index c2341af..2c70e94 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -636,7 +636,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCpnt)
 
 	/*
 	 * XXX: NSP_QUIRK
-	 * data phase skip only occures in case of SCSI_LOW_READ
+	 * data phase skip only occurs in case of SCSI_LOW_READ
 	 */
 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
 	SCpnt->SCp.phase = PH_DATA;
diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 5fda881..82e9fa0 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1841,7 +1841,7 @@ check_setup_args(char *key, int *flags, int *val, char *buf)
  *
  * The original driver used to rely on a fixed sx_table, containing periods
  * for (only) the lower limits of the respective input-clock-frequency ranges
- * (8-10/12-15/16-20 MHz). Although it seems, that no problems ocurred with
+ * (8-10/12-15/16-20 MHz). Although it seems, that no problems occurred with
  * this setting so far, it might be desirable to adjust the transfer periods
  * closer to the really attached, possibly 25% higher, input-clock, since
  * - the wd33c93 may really use a significant shorter period, than it has
diff --git a/drivers/serial/68328serial.h b/drivers/serial/68328serial.h
index 58aa215..021199a 100644
--- a/drivers/serial/68328serial.h
+++ b/drivers/serial/68328serial.h
@@ -79,14 +79,14 @@ struct serial_struct {
  * At high speeds the output might become a little "bursted" (use USTCNT_TXHE
  * if that bothers you), but in most cases it will not, since we try to 
  * transmit characters every time rs_interrupt is called. Thus, quite often
- * you'll see that a receive interrupt occures before the transmit one.
+ * you'll see that a receive interrupt occurs before the transmit one.
  *                                  -- Vladimir Gurevich
  */
 #define USTCNT_TX_INTR_MASK (USTCNT_TXEE)
 
 /*
  * 68328 and 68EZ328 UARTS are a little bit different. EZ328 has special
- * "Old data interrupt" which occures whenever the data stay in the FIFO
+ * "Old data interrupt" which occurs whenever the data stay in the FIFO
  * longer than 30 bits time. This allows us to use FIFO without compromising
  * latency. '328 does not have this feature and without the real  328-based
  * board I would assume that RXRE is the safest setting.
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c3e37c8..9bb9f45 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1580,7 +1580,7 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 		} else if (up->port.iotype == UPIO_DWAPB &&
 			  (iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 			/* The DesignWare APB UART has an Busy Detect (0x07)
-			 * interrupt meaning an LCR write attempt occured while the
+			 * interrupt meaning an LCR write attempt occurred while the
 			 * UART was busy. The interrupt must be cleared by reading
 			 * the UART status register (USR) and the LCR re-written. */
 			unsigned int status;
diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index 8117748..18d27f9 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -1990,7 +1990,7 @@ void comedi_event(struct comedi_device *dev, struct comedi_subdevice *s)
 			     COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_RUNNING;
 	}
-	/* remember if an error event has occured, so an error
+	/* remember if an error event has occurred, so an error
 	 * can be returned the next time the user does a read() */
 	if (s->async->events & (COMEDI_CB_ERROR | COMEDI_CB_OVERFLOW)) {
 		runflags_mask |= SRF_ERROR;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
index ec81708..2af0e8f 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c
@@ -498,7 +498,7 @@ void v_APCI2032_Interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	unsigned int ui_DO;
 
-	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occured. */
+	ui_DO = inl(devpriv->iobase + APCI2032_DIGITAL_OP_IRQ) & 0x1;	/* Check if VCC OR CC interrupt has occurred. */
 
 	if (ui_DO == 0) {
 		printk("\nInterrupt from unKnown source\n");
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 951e579..f95ccb3 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -93,7 +93,7 @@ Configuration options:
 #define	Status_FE	0x0100	/* 1=FIFO is empty */
 #define Status_FH	0x0200	/* 1=FIFO is half full */
 #define Status_FF	0x0400	/* 1=FIFO is full, fatal error */
-#define Status_IRQ	0x0800	/* 1=IRQ occured */
+#define Status_IRQ	0x0800	/* 1=IRQ occurred */
 /* bits from control register (PCI171x_CONTROL) */
 #define Control_CNT0	0x0040	/* 1=CNT0 have external source, 0=have internal 100kHz source */
 #define Control_ONEFH	0x0020	/* 1=IRQ on FIFO is half full, 0=every sample */
diff --git a/drivers/staging/comedi/drivers/comedi_test.c b/drivers/staging/comedi/drivers/comedi_test.c
index ef83a1a..6e20ea6 100644
--- a/drivers/staging/comedi/drivers/comedi_test.c
+++ b/drivers/staging/comedi/drivers/comedi_test.c
@@ -81,7 +81,7 @@ static const struct waveform_board waveform_boards[] = {
 /* Data unique to this driver */
 struct waveform_private {
 	struct timer_list timer;
-	struct timeval last;	/* time at which last timer interrupt occured */
+	struct timeval last;	/* time at which last timer interrupt occurred */
 	unsigned int uvolt_amplitude;	/* waveform amplitude in microvolts */
 	unsigned long usec_period;	/* waveform period in microseconds */
 	unsigned long usec_current;	/* current time (modulo waveform period) */
diff --git a/drivers/staging/comedi/drivers/ni_at_a2150.c b/drivers/staging/comedi/drivers/ni_at_a2150.c
index dd75dfb..14ff50c 100644
--- a/drivers/staging/comedi/drivers/ni_at_a2150.c
+++ b/drivers/staging/comedi/drivers/ni_at_a2150.c
@@ -105,8 +105,8 @@ TRIG_WAKE_EOS
 #define   OVFL_BIT		0x8	/*  fifo overflow */
 #define   EDAQ_BIT		0x10	/*  end of aquisition interrupt */
 #define   DCAL_BIT		0x20	/*  offset calibration in progress */
-#define   INTR_BIT		0x40	/*  interrupt has occured */
-#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occured */
+#define   INTR_BIT		0x40	/*  interrupt has occurred */
+#define   DMA_TC_BIT		0x80	/*  dma terminal count interrupt has occurred */
 #define   ID_BITS(x)	(((x) >> 8) & 0x3)
 #define IRQ_DMA_CNTRL_REG		0x12	/*  write only */
 #define   DMA_CHAN_BITS(x)		((x) & 0x7)	/*  sets dma channel */
diff --git a/drivers/staging/comedi/drivers/ni_labpc.c b/drivers/staging/comedi/drivers/ni_labpc.c
index dc3f398..05bc855 100644
--- a/drivers/staging/comedi/drivers/ni_labpc.c
+++ b/drivers/staging/comedi/drivers/ni_labpc.c
@@ -148,9 +148,9 @@ NI manuals:
 #define   DATA_AVAIL_BIT	0x1	/*  data is available in fifo */
 #define   OVERRUN_BIT	0x2	/*  overrun has occurred */
 #define   OVERFLOW_BIT	0x4	/*  fifo overflow */
-#define   TIMER_BIT	0x8	/*  timer interrupt has occured */
-#define   DMATC_BIT	0x10	/*  dma terminal count has occured */
-#define   EXT_TRIG_BIT	0x40	/*  external trigger has occured */
+#define   TIMER_BIT	0x8	/*  timer interrupt has occurred */
+#define   DMATC_BIT	0x10	/*  dma terminal count has occurred */
+#define   EXT_TRIG_BIT	0x40	/*  external trigger has occurred */
 #define STATUS2_REG	0x1d	/*  1200 boards only */
 #define   EEPROM_OUT_BIT	0x1	/*  programmable eeprom serial output */
 #define   A1_TC_BIT	0x2	/*  counter A1 terminal count */
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index fdd7ab9..47dd6fa 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2529,7 +2529,7 @@ static uint32_t I2Chandshake(struct comedi_device *dev, uint32_t val)
 	/*  Wait until I2C bus transfer is finished or an error occurs. */
 	while ((RR7146(P_I2CCTRL) & (I2C_BUSY | I2C_ERR)) == I2C_BUSY) ;
 
-	/*  Return non-zero if I2C error occured. */
+	/*  Return non-zero if I2C error occurred. */
 	return RR7146(P_I2CCTRL) & I2C_ERR;
 
 }
diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
index def6468..0499300 100644
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -611,7 +611,7 @@ static int pmem_mmap(struct file *file, struct vm_area_struct *vma)
 		up_write(&pmem[id].bitmap_sem);
 		data->index = index;
 	}
-	/* either no space was available or an error occured */
+	/* either no space was available or an error occurred */
 	if (!has_allocation(file)) {
 		ret = -EINVAL;
 		printk("pmem: could not find allocation for map.\n");
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index f6d452d..89a1f1f 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -453,7 +453,7 @@ void et131x_isr_handler(struct work_struct *work)
 		/* Handle SLV Timeout Interrupt */
 		if (status & ET_INTR_SLV_TIMEOUT) {
 			/*
-			 * This means a timeout has occured on a read or
+			 * This means a timeout has occurred on a read or
 			 * write request to one of the JAGCore registers. The
 			 * Global Resources block has terminated the request
 			 * and on a read request, returned a "fake" value.
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index a6b7c72..636ab09 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -459,7 +459,7 @@ static const struct attribute_group lis3l02dq_trigger_attr_group = {
  *
  * As the trigger may occur on any data element being updated it is
  * really rather likely to occur during the read from the previous
- * trigger event.  The only way to discover if this has occured on
+ * trigger event.  The only way to discover if this has occurred on
  * boards not supporting level interrupts is to take a look at the line.
  * If it is indicating another interrupt and we don't seem to have a
  * handler looking at it, then we need to notify the core that we need
diff --git a/drivers/staging/iio/adc/max1363_ring.c b/drivers/staging/iio/adc/max1363_ring.c
index a953eac..595a8f1 100644
--- a/drivers/staging/iio/adc/max1363_ring.c
+++ b/drivers/staging/iio/adc/max1363_ring.c
@@ -113,7 +113,7 @@ static int max1363_ring_predisable(struct iio_dev *indio_dev)
 /**
  * max1363_poll_func_th() th of trigger launched polling to ring buffer
  *
- * As sampling only occurs on i2c comms occuring, leave timestamping until
+ * As sampling only occurs on i2c comms occurring, leave timestamping until
  * then.  Some triggers will generate their own time stamp.  Currently
  * there is no way of notifying them when no one cares.
  **/
diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index f42bafb..e8c3b92 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -33,7 +33,7 @@ struct iio_handler {
 /**
  * struct iio_event_data - The actual event being pushed to userspace
  * @id:		event identifier
- * @timestamp:	best estimate of time of event occurance (often from
+ * @timestamp:	best estimate of time of event occurrence (often from
  *		the interrupt handler)
  */
 struct iio_event_data {
@@ -42,7 +42,7 @@ struct iio_event_data {
 };
 
 /**
- * struct iio_detected_event_list - list element for events that have occured
+ * struct iio_detected_event_list - list element for events that have occurred
  * @list:		linked list header
  * @ev:			the event itself
  * @shared_pointer:	used when the event is shared - i.e. can be escallated
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index f7726f1..6d7118c 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -148,7 +148,7 @@ static struct usb_driver quausb2_usb_driver = {
  * value of the line status flags from the port
  * @shadowMSR: Last received state of the modem status register, holds
  * the value of the modem status received from the port
- * @rcv_flush: Flag indicating that a receive flush has occured on
+ * @rcv_flush: Flag indicating that a receive flush has occurred on
  * the hardware.
  * @xmit_flush: Flag indicating that a transmit flush has been processed by
  * the hardware.
@@ -731,7 +731,7 @@ static int qt2_write(struct tty_struct *tty, struct usb_serial_port *port,
 		return 0;
 	} else if (port_extra->tx_pending_bytes >= QT2_FIFO_DEPTH) {
 		/* buffer is full (==). > should not occur, but would indicate
-		 * that an overflow had occured */
+		 * that an overflow had occurred */
 		dbg("%s(): port transmit buffer is full!", __func__);
 		/* schedule_work(&port->work); commented in vendor driver */
 		return 0;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index c50abf4..6856861 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -774,7 +774,7 @@ struct rt_tkip_key_info {
 /* */
 struct rt_private {
 	u32 SystemResetCnt;	/* System reset counter */
-	u32 TxRingFullCnt;	/* Tx ring full occurrance number */
+	u32 TxRingFullCnt;	/* Tx ring full occurrence number */
 	u32 PhyRxErrCnt;	/* PHY Rx error count, for debug purpose, might move to global counter */
 	/* Variables for WEP encryption / decryption in rtmp_wep.c */
 	u32 FCSCRC32;
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index c7c645a..4678168 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -1188,7 +1188,7 @@ void ieee80211_associate_step1(struct ieee80211_device *ieee)
 			ieee->associate_timer.expires = jiffies + (HZ / 2);
 			add_timer(&ieee->associate_timer);
 		}
-		//If call dev_kfree_skb_any,a warning will ocur....
+		//If call dev_kfree_skb_any,a warning will occur....
 		//KERNEL: assertion (!atomic_read(&skb->users)) failed at net/core/dev.c (1708)
 		//So ... 1204 by lawrence.
 		//printk("\nIn %s,line %d call kfree skb.",__func__,__LINE__);
diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 6e39f50..12cb4e5 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -1931,7 +1931,7 @@ hcf_16	t = (hcf_16)(*type<<8) + *(type+1);																/* 2 */
 *	HCF_SUCCESS			Success
 *!!	via cmd_exe ( type >= CFG_RID_FW_MIN )
 *	HCF_ERR_NO_NIC		NIC removed during retrieval
-*	HCF_ERR_TIME_OUT	Expected Hermes event did not occure in expected time
+*	HCF_ERR_TIME_OUT	Expected Hermes event did not occur in expected time
 *!!	via cmd_exe and setup_bap (type >= CFG_RID_FW_MIN )
 *	HCF_ERR_DEFUNCT_...	HCF is in defunct mode (bits 0x7F reflect cause)
 *
@@ -4286,7 +4286,7 @@ PROT_CNT_INI
 *6:	All other than Tallies (including "unknown" ones) are checked against the selection set by the MSF
 *	via CFG_RID_LOG. If a match is found or the selection set has the wild-card type (i.e non-NULL buffer
 *	pointer at the terminating zero-type), the frame is copied to the (type-specific) log buffer.
-*	Note that to accumulate tallies into IFB AND to log them or to log a frame when a specific match occures
+*	Note that to accumulate tallies into IFB AND to log them or to log a frame when a specific match occurs
 *	AND based on the wild-card selection, you have to call setup_bap again after the 1st copy.
 *
 *.ENDDOC				END DOCUMENTATION
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index b45c7dd..cb47363 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -845,7 +845,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 
 
 #define HCF_SUCCESS					0x00	// OK
-#define HCF_ERR_TIME_OUT			0x04	// Expected Hermes event did not occure in expected time
+#define HCF_ERR_TIME_OUT			0x04	// Expected Hermes event did not occur in expected time
 #define HCF_ERR_NO_NIC				0x05	/* card not found (usually yanked away during hcfio_in_string
 										  	 * Also: card is either absent or disabled while it should be neither */
 #define HCF_ERR_LEN					0x08	/* buffer size insufficient
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index c539524..3eaa7ab 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1797,7 +1797,7 @@ static int uea_start_reset(struct uea_softc *sc)
 
 	/* mask interrupt */
 	sc->booting = 1;
-	/* We need to set this here because, a ack timeout could have occured,
+	/* We need to set this here because, a ack timeout could have occurred,
 	 * but before we start the reboot, the ack occurs and set this to 1.
 	 * So we will failed to wait Ready CMV.
 	 */
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index 85dfe29..556c823 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -906,7 +906,7 @@ static inline int c67x00_end_of_data(struct c67x00_td *td)
 
 /* Remove all td's from the list which come
  * after last_td and are meant for the same pipe.
- * This is used when a short packet has occured */
+ * This is used when a short packet has occurred */
 static inline void c67x00_clear_pipe(struct c67x00_hcd *c67x00,
 				     struct c67x00_td *last_td)
 {
diff --git a/drivers/usb/gadget/fsl_qe_udc.h b/drivers/usb/gadget/fsl_qe_udc.h
index bea5b82..8e18d0d 100644
--- a/drivers/usb/gadget/fsl_qe_udc.h
+++ b/drivers/usb/gadget/fsl_qe_udc.h
@@ -208,14 +208,14 @@ struct qe_frame{
 /* Frame status field */
 /* Receive side */
 #define FRAME_OK               0x00000000 /* Frame tranmitted or received OK */
-#define FRAME_ERROR            0x80000000 /* Error occured on frame */
+#define FRAME_ERROR            0x80000000 /* Error occurred on frame */
 #define START_FRAME_LOST       0x40000000 /* START_FRAME_LOST */
 #define END_FRAME_LOST         0x20000000 /* END_FRAME_LOST */
 #define RX_ER_NONOCT           0x10000000 /* Rx Non Octet Aligned Packet */
 #define RX_ER_BITSTUFF         0x08000000 /* Frame Aborted --Received packet
 					     with bit stuff error */
 #define RX_ER_CRC              0x04000000 /* Received packet with CRC error */
-#define RX_ER_OVERUN           0x02000000 /* Over-run occured on reception */
+#define RX_ER_OVERUN           0x02000000 /* Over-run occurred on reception */
 #define RX_ER_PID              0x01000000 /* Wrong PID received */
 /* Tranmit side */
 #define TX_ER_NAK              0x00800000 /* Received NAK handshake */
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index fa3d142..4d366d6 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -654,7 +654,7 @@ static void fsl_queue_td(struct fsl_ep *ep, struct fsl_req *req)
 			| EP_QUEUE_HEAD_STATUS_HALT));
 	dQH->size_ioc_int_sts &= temp;
 
-	/* Ensure that updates to the QH will occure before priming. */
+	/* Ensure that updates to the QH will occur before priming. */
 	wmb();
 
 	/* Prime endpoint by writing 1 to ENDPTPRIME */
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 4b5dbd0..1141935 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2096,7 +2096,7 @@ irq_retry:
 
 	/* these next two seem to crop-up occasionally causing the core
 	 * to shutdown the USB transfer, so try clearing them and logging
-	 * the occurence. */
+	 * the occurrence. */
 
 	if (gintsts & S3C_GINTSTS_GOUTNakEff) {
 		dev_info(hsotg->dev, "GOUTNakEff triggered\n");
diff --git a/drivers/usb/host/fhci.h b/drivers/usb/host/fhci.h
index 72dae1c..1011f3b 100644
--- a/drivers/usb/host/fhci.h
+++ b/drivers/usb/host/fhci.h
@@ -81,7 +81,7 @@
 #define USB_TD_RX_ER_NONOCT	0x40000000 /* Tx Non Octet Aligned Packet */
 #define USB_TD_RX_ER_BITSTUFF	0x20000000 /* Frame Aborted-Received pkt */
 #define USB_TD_RX_ER_CRC	0x10000000 /* CRC error */
-#define USB_TD_RX_ER_OVERUN	0x08000000 /* Over - run occured */
+#define USB_TD_RX_ER_OVERUN	0x08000000 /* Over - run occurred */
 #define USB_TD_RX_ER_PID	0x04000000 /* wrong PID received */
 #define USB_TD_RX_DATA_UNDERUN	0x02000000 /* shorter than expected */
 #define USB_TD_RX_DATA_OVERUN	0x01000000 /* longer than expected */
diff --git a/drivers/uwb/wlp/messages.c b/drivers/uwb/wlp/messages.c
index aa42fce..f40bbf9 100644
--- a/drivers/uwb/wlp/messages.c
+++ b/drivers/uwb/wlp/messages.c
@@ -218,14 +218,14 @@ static int wlp_check_attr_hdr(struct wlp *wlp, struct wlp_attr_hdr *hdr,
  * @returns: length of WSS attributes (value of length attribute field) if
  *             valid WSS information attribute found
  *           -ENODATA if no WSS information attribute found
- *           -EIO other error occured
+ *           -EIO other error occurred
  *
  * The WSS information attribute is optional. The function will be provided
  * with a pointer to data that could _potentially_ be a WSS information
  * attribute. If a valid WSS information attribute is found it will return
  * 0, if no WSS information attribute is found it will return -ENODATA, and
  * another error will be returned if it is a WSS information attribute, but
- * some parsing failure occured.
+ * some parsing failure occurred.
  */
 static int wlp_check_wss_info_attr_hdr(struct wlp *wlp,
 				       struct wlp_attr_hdr *hdr, size_t buflen)
@@ -892,7 +892,7 @@ error_alloc:
  * Parse F0 frame
  *
  * We just retrieve the values and print it as an error to the user.
- * Calling function already knows an error occured (F0 indicates error), so
+ * Calling function already knows an error occurred (F0 indicates error), so
  * we just parse the content as debug for higher layers.
  */
 int wlp_parse_f0(struct wlp *wlp, struct sk_buff *skb)
diff --git a/drivers/uwb/wlp/txrx.c b/drivers/uwb/wlp/txrx.c
index 7350ed6..398098f 100644
--- a/drivers/uwb/wlp/txrx.c
+++ b/drivers/uwb/wlp/txrx.c
@@ -203,7 +203,7 @@ out:
  *
  * @returns: 1 if calling function should free the skb
  *           0 if it successfully handled skb and freed it
- *           0 if error occured, will free skb in this case
+ *           0 if error occurred, will free skb in this case
  */
 int wlp_receive_frame(struct device *dev, struct wlp *wlp, struct sk_buff *skb,
 		      struct uwb_dev_addr *src)
diff --git a/drivers/uwb/wlp/wlp-lc.c b/drivers/uwb/wlp/wlp-lc.c
index 13db739..83ecb28 100644
--- a/drivers/uwb/wlp/wlp-lc.c
+++ b/drivers/uwb/wlp/wlp-lc.c
@@ -421,8 +421,8 @@ static int wlp_add_neighbor_helper(struct device *dev, void *priv)
  *
  * If one neighbor fails during initial discovery (determining if it is a
  * neighbor or not), we fail all - note that interaction with neighbor has
- * not occured at this point so if a failure occurs we know something went wrong
- * locally. We thus undo everything.
+ * not occurred at this point so if a failure occurs we know something went
+ * wrong locally. We thus undo everything.
  */
 ssize_t wlp_discover(struct wlp *wlp)
 {
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index d4a2c11..b94ef86 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -32,7 +32,7 @@
  * for driver private data (info->par). info->par (if any) will be
  * aligned to sizeof(long).
  *
- * Returns the new structure, or NULL if an error occured.
+ * Returns the new structure, or NULL if an error occurred.
  *
  */
 struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
diff --git a/drivers/watchdog/acquirewdt.c b/drivers/watchdog/acquirewdt.c
index 4d18c87..7ea0647 100644
--- a/drivers/watchdog/acquirewdt.c
+++ b/drivers/watchdog/acquirewdt.c
@@ -26,7 +26,7 @@
  *	Theory of Operation:
  *		The Watch-Dog Timer is provided to ensure that standalone
  *		Systems can always recover from catastrophic conditions that
- *		caused the CPU to crash. This condition may have occured by
+ *		caused the CPU to crash. This condition may have occurred by
  *		external EMI or a software bug. When the CPU stops working
  *		correctly, hardware on the board will either perform a hardware
  *		reset (cold boot) or a non-maskable interrupt (NMI) to bring the
diff --git a/drivers/watchdog/sch311x_wdt.c b/drivers/watchdog/sch311x_wdt.c
index 569eb29..2bae70e 100644
--- a/drivers/watchdog/sch311x_wdt.c
+++ b/drivers/watchdog/sch311x_wdt.c
@@ -201,7 +201,7 @@ static void sch311x_wdt_get_status(int *status)
 	spin_lock(&sch311x_wdt_data.io_lock);
 
 	/* -- Watchdog timer control --
-	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occurred
 	 * Bit 1   Reserved
 	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
 	 * Bit 3   P20 Force Timeout enabled:
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 8a1f0bc..4b3462b 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -191,7 +191,7 @@ static inline void wdt_timer_conf(unsigned char conf)
 static inline void wdt_timer_ctrl(unsigned char reg)
 {
 	/* -- Watchdog timer control --
-	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occured
+	 * Bit 0   Status Bit: 0 = Timer counting, 1 = Timeout occurred
 	 * Bit 1   Power LED Toggle: 0 = Disable Toggle, 1 = Toggle at 1 Hz
 	 * Bit 2   Force Timeout: 1 = Forces WD timeout event (self-cleaning)
 	 * Bit 3   P20 Force Timeout enabled:
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index e22de83..a87a528 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -24,7 +24,7 @@
  *
  * Returns: 0 if the data CRC is correct;
  * 	    1 - if incorrect;
- *	    error code if an error occured.
+ *	    error code if an error occurred.
  */
 static int check_node_data(struct jffs2_sb_info *c, struct jffs2_tmp_dnode_info *tn)
 {
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 6b89132..73140fd 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -205,7 +205,7 @@ static loff_t nfs_file_llseek(struct file *filp, loff_t offset, int origin)
  * disk, but it retrieves and clears ctx->error after synching, despite
  * the two being set at the same time in nfs_context_set_write_error().
  * This is because the former is used to notify the _next_ call to
- * nfs_file_write() that a write error occured, and hence cause it to
+ * nfs_file_write() that a write error occurred, and hence cause it to
  * fall back to doing a synchronous write.
  */
 static int nfs_do_fsync(struct nfs_open_context *ctx, struct inode *inode)
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index f19ed86..6af7a71 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3342,7 +3342,7 @@ find_lockstateowner_str(struct inode *inode, clientid_t *clid,
 /*
  * Alloc a lock owner structure.
  * Called in nfsd4_lock - therefore, OPEN and OPEN_CONFIRM (if needed) has 
- * occured. 
+ * occurred.
  *
  * strhashval = lock_ownerstr_hashval 
  */
diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index 50d3b0c..55ca4d0 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -1180,7 +1180,7 @@ not_found:
  * for, i.e. if one wants to add the attribute to the mft record this is the
  * correct place to insert its attribute list entry into.
  *
- * When -errno != -ENOENT, an error occured during the lookup.  @ctx->attr is
+ * When -errno != -ENOENT, an error occurred during the lookup.  @ctx->attr is
  * then undefined and in particular you should not rely on it not changing.
  */
 int ntfs_attr_lookup(const ATTR_TYPE type, const ntfschar *name,
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index dc2505a..9f69932 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -2519,7 +2519,7 @@ retry_truncate:
 		 * specifies that the behaviour is unspecified thus we do not
 		 * have to do anything.  This means that in our implementation
 		 * in the rare case that the file is mmap()ped and a write
-		 * occured into the mmap()ped region just beyond the file size
+		 * occurred into the mmap()ped region just beyond the file size
 		 * and writepage has not yet been called to write out the page
 		 * (which would clear the area beyond the file size) and we now
 		 * extend the file size to incorporate this dirty region
diff --git a/fs/ntfs/logfile.h b/fs/ntfs/logfile.h
index b5a6f08..aa2b6ac 100644
--- a/fs/ntfs/logfile.h
+++ b/fs/ntfs/logfile.h
@@ -222,7 +222,7 @@ typedef struct {
 /* 24*/	sle64 file_size;	/* Usable byte size of the log file.  If the
 				   restart_area_offset + the offset of the
 				   file_size are > 510 then corruption has
-				   occured.  This is the very first check when
+				   occurred.  This is the very first check when
 				   starting with the restart_area as if it
 				   fails it means that some of the above values
 				   will be corrupted by the multi sector
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index 80b0477..4381da7 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -458,7 +458,7 @@ static int ntfs_remount(struct super_block *sb, int *flags, char *opt)
 	 * the volume on boot and updates them.
 	 *
 	 * When remounting read-only, mark the volume clean if no volume errors
-	 * have occured.
+	 * have occurred.
 	 */
 	if ((sb->s_flags & MS_RDONLY) && !(*flags & MS_RDONLY)) {
 		static const char *es = ".  Cannot remount read-write.";
@@ -1279,7 +1279,7 @@ static int check_windows_hibernation_status(ntfs_volume *vol)
 					"hibernated on the volume.");
 			return 0;
 		}
-		/* A real error occured. */
+		/* A real error occurred. */
 		ntfs_error(vol->sb, "Failed to find inode number for "
 				"hiberfil.sys.");
 		return ret;
@@ -1380,7 +1380,7 @@ static bool load_and_init_quota(ntfs_volume *vol)
 			NVolSetQuotaOutOfDate(vol);
 			return true;
 		}
-		/* A real error occured. */
+		/* A real error occurred. */
 		ntfs_error(vol->sb, "Failed to find inode number for $Quota.");
 		return false;
 	}
@@ -1464,7 +1464,7 @@ not_enabled:
 			NVolSetUsnJrnlStamped(vol);
 			return true;
 		}
-		/* A real error occured. */
+		/* A real error occurred. */
 		ntfs_error(vol->sb, "Failed to find inode number for "
 				"$UsnJrnl.");
 		return false;
@@ -2304,7 +2304,7 @@ static void ntfs_put_super(struct super_block *sb)
 	ntfs_commit_inode(vol->mft_ino);
 
 	/*
-	 * If a read-write mount and no volume errors have occured, mark the
+	 * If a read-write mount and no volume errors have occurred, mark the
 	 * volume clean.  Also, re-commit all affected inodes.
 	 */
 	if (!(sb->s_flags & MS_RDONLY)) {
@@ -2510,7 +2510,7 @@ static s64 get_nr_free_clusters(ntfs_volume *vol)
 	if (vol->nr_clusters & 63)
 		nr_free += 64 - (vol->nr_clusters & 63);
 	up_read(&vol->lcnbmp_lock);
-	/* If errors occured we may well have gone below zero, fix this. */
+	/* If errors occurred we may well have gone below zero, fix this. */
 	if (nr_free < 0)
 		nr_free = 0;
 	ntfs_debug("Exiting.");
@@ -2575,7 +2575,7 @@ static unsigned long __get_nr_free_mft_records(ntfs_volume *vol,
 	}
 	ntfs_debug("Finished reading $MFT/$BITMAP, last index = 0x%lx.",
 			index - 1);
-	/* If errors occured we may well have gone below zero, fix this. */
+	/* If errors occurred we may well have gone below zero, fix this. */
 	if (nr_free < 0)
 		nr_free = 0;
 	ntfs_debug("Exiting.");
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 6390240..25a1ffa 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -90,7 +90,7 @@ static void o2quo_fence_self(void)
 	};
 }
 
-/* Indicate that a timeout occured on a hearbeat region write. The
+/* Indicate that a timeout occurred on a hearbeat region write. The
  * other nodes in the cluster may consider us dead at that time so we
  * want to "fence" ourselves so that we don't scribble on the disk
  * after they think they've recovered us. This can't solve all
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 81f09fa..6b9d4ba 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -399,7 +399,7 @@ static struct page *reiserfs_get_page(struct inode *dir, size_t n)
 	struct address_space *mapping = dir->i_mapping;
 	struct page *page;
 	/* We can deadlock if we try to free dentries,
-	   and an unlink/rmdir has just occured - GFP_NOFS avoids this */
+	   and an unlink/rmdir has just occurred - GFP_NOFS avoids this */
 	mapping_set_gfp_mask(mapping, GFP_NOFS);
 	page = read_mapping_page(mapping, n >> PAGE_CACHE_SHIFT, NULL);
 	if (!IS_ERR(page)) {
diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 82372e3..556528e 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -447,7 +447,7 @@ static void udf_table_free_blocks(struct super_block *sb,
 
 	iinfo = UDF_I(table);
 	/* We do this up front - There are some error conditions that
-	   could occure, but.. oh well */
+	   could occur, but.. oh well */
 	if (inode)
 		vfs_dq_free_block(inode, count);
 	udf_add_free_space(sb, sbi->s_partition, count);
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 0d32457..7e6eb87 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -768,7 +768,7 @@ write_retry:
 		/*
 		 * If this was a direct or synchronous I/O that failed (such
 		 * as ENOSPC) then part of the I/O may have been written to
-		 * disk before the error occured.  In this case the on-disk
+		 * disk before the error occurred.  In this case the on-disk
 		 * file size may have been adjusted beyond the in-memory file
 		 * size and now needs to be truncated back.
 		 */
diff --git a/fs/xfs/quota/xfs_qm_bhv.c b/fs/xfs/quota/xfs_qm_bhv.c
index a534663..2507776 100644
--- a/fs/xfs/quota/xfs_qm_bhv.c
+++ b/fs/xfs/quota/xfs_qm_bhv.c
@@ -145,7 +145,7 @@ xfs_qm_newmount(
 		 */
 		if (quotaondisk && !XFS_QM_NEED_QUOTACHECK(mp)) {
 			/*
-			 * If an error occured, qm_mount_quotas code
+			 * If an error occurred, qm_mount_quotas code
 			 * has already disabled quotas. So, just finish
 			 * mounting, and get on with the boring life
 			 * without disk quotas.
diff --git a/include/drm/ttm/ttm_bo_driver.h b/include/drm/ttm/ttm_bo_driver.h
index ff7664e..59dd074 100644
--- a/include/drm/ttm/ttm_bo_driver.h
+++ b/include/drm/ttm/ttm_bo_driver.h
@@ -726,7 +726,7 @@ extern void ttm_bo_unmap_virtual(struct ttm_buffer_object *bo);
  * different order, either by will or as a result of a buffer being evicted
  * to make room for a buffer already reserved. (Buffers are reserved before
  * they are evicted). The following algorithm prevents such deadlocks from
- * occuring:
+ * occurring:
  * 1) Buffers are reserved with the lru spinlock held. Upon successful
  * reservation they are removed from the lru list. This stops a reserved buffer
  * from being evicted. However the lru spinlock is released between the time
diff --git a/include/linux/can/error.h b/include/linux/can/error.h
index d4127fd..5958074 100644
--- a/include/linux/can/error.h
+++ b/include/linux/can/error.h
@@ -51,7 +51,7 @@
 #define CAN_ERR_PROT_BIT1        0x10 /* unable to send recessive bit */
 #define CAN_ERR_PROT_OVERLOAD    0x20 /* bus overload */
 #define CAN_ERR_PROT_ACTIVE      0x40 /* active error announcement */
-#define CAN_ERR_PROT_TX          0x80 /* error occured on transmission */
+#define CAN_ERR_PROT_TX          0x80 /* error occurred on transmission */
 
 /* error in CAN protocol (location) / data[3] */
 #define CAN_ERR_PROT_LOC_UNSPEC  0x00 /* unspecified */
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 369767b..fc2ea7c 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -530,14 +530,14 @@ struct fb_cursor_user {
 #define FB_EVENT_GET_CONSOLE_MAP        0x07
 /*      CONSOLE-SPECIFIC: set console to framebuffer mapping */
 #define FB_EVENT_SET_CONSOLE_MAP        0x08
-/*      A hardware display blank change occured */
+/*      A hardware display blank change occurred */
 #define FB_EVENT_BLANK                  0x09
 /*      Private modelist is to be replaced */
 #define FB_EVENT_NEW_MODELIST           0x0A
 /*	The resolution of the passed in fb_info about to change and
         all vc's should be changed         */
 #define FB_EVENT_MODE_CHANGE_ALL	0x0B
-/*	A software display blank change occured */
+/*	A software display blank change occurred */
 #define FB_EVENT_CONBLANK               0x0C
 /*      Get drawing requirements        */
 #define FB_EVENT_GET_REQ                0x0D
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index fee6c2f..a420a10 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -229,8 +229,8 @@ static inline int notifier_to_errno(int ret)
 					* enabling interrupts. Must not sleep,
 					* must not fail */
 
-/* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
- * operation in progress
+/* Used for CPU hotplug events occurring while tasks are frozen due to a
+ * suspend operation in progress
  */
 #define CPU_TASKS_FROZEN	0x0010
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index e101a2d..4bfd260 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -808,7 +808,7 @@ struct usbdrv_wrap {
  *	usb_set_intfdata() to associate driver-specific data with the
  *	interface.  It may also use usb_set_interface() to specify the
  *	appropriate altsetting.  If unwilling to manage the interface,
- *	return -ENODEV, if genuine IO errors occured, an appropriate
+ *	return -ENODEV, if genuine IO errors occurred, an appropriate
  *	negative errno value.
  * @disconnect: Called when the interface is no longer accessible, usually
  *	because its device has been (or is being) disconnected or the
diff --git a/include/linux/uwb.h b/include/linux/uwb.h
index 7fc9746..3052e44 100644
--- a/include/linux/uwb.h
+++ b/include/linux/uwb.h
@@ -702,10 +702,10 @@ void edc_init(struct edc *edc)
 	edc->timestart = jiffies;
 }
 
-/* Called when an error occured.
+/* Called when an error occurred.
  * This is way to determine if the number of acceptable errors per time
  * period has been exceeded. It is not accurate as there are cases in which
- * this scheme will not work, for example if there are periodic occurences
+ * this scheme will not work, for example if there are periodic occurrences
  * of errors that straddle updates to the start time. This scheme is
  * sufficient for our usage.
  *
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index ecc3fa2..7a34169 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -516,8 +516,8 @@ out:
  *	@irq:	the interrupt number
  *	@desc:	the interrupt description structure for this irq
  *
- *	Interrupt occures on the falling and/or rising edge of a hardware
- *	signal. The occurence is latched into the irq controller hardware
+ *	Interrupt occurs on the falling and/or rising edge of a hardware
+ *	signal. The occurrence is latched into the irq controller hardware
  *	and must be acked in order to be reenabled. After the ack another
  *	interrupt can happen on the same source even before the first one
  *	is handled by the assosiacted event handler. If this happens it
diff --git a/kernel/latencytop.c b/kernel/latencytop.c
index ca07c5c..46802af 100644
--- a/kernel/latencytop.c
+++ b/kernel/latencytop.c
@@ -154,7 +154,7 @@ static inline void store_stacktrace(struct task_struct *tsk,
 }
 
 /**
- * __account_scheduler_latency - record an occured latency
+ * __account_scheduler_latency - record an occurred latency
  * @tsk - the task struct of the task hitting the latency
  * @usecs - the duration of the latency in microseconds
  * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
diff --git a/kernel/user-return-notifier.c b/kernel/user-return-notifier.c
index eb27fd3..92cb706 100644
--- a/kernel/user-return-notifier.c
+++ b/kernel/user-return-notifier.c
@@ -20,7 +20,7 @@ EXPORT_SYMBOL_GPL(user_return_notifier_register);
 
 /*
  * Removes a registered user return notifier.  Must be called from atomic
- * context, and from the same cpu registration occured in.
+ * context, and from the same cpu registration occurred in.
  */
 void user_return_notifier_unregister(struct user_return_notifier *urn)
 {
diff --git a/lib/textsearch.c b/lib/textsearch.c
index 9fbcb44..bc1afea 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -66,7 +66,7 @@
  *   continuous() for linear data or by providing an own get_next_block()
  *   implementation and calling textsearch_find(). Both functions return
  *   the position of the first occurrence of the patern or UINT_MAX if
- *   no match was found. Subsequent occurences can be found by calling
+ *   no match was found. Subsequent occurrences can be found by calling
  *   textsearch_next() regardless of the linearity of the data.
  *
  *   Once you're done using a configuration it must be given back via
diff --git a/lib/ts_bm.c b/lib/ts_bm.c
index 9e66ee4..1a09907 100644
--- a/lib/ts_bm.c
+++ b/lib/ts_bm.c
@@ -128,7 +128,7 @@ static void compute_prefix_tbl(struct ts_bm *bm, int flags)
 			    = bm->patlen - 1 - i;
 	}
 
-	/* Compute the good shift array, used to match reocurrences 
+	/* Compute the good shift array, used to match reoccurrences
 	 * of a subpattern */
 	bm->good_shift[0] = 1;
 	for (i = 1; i < bm->patlen; i++)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0e8ca03..00f598c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -498,8 +498,8 @@ void static bdi_add_default_flusher_task(struct backing_dev_info *bdi)
 	/*
 	 * Check with the helper whether to proceed adding a task. Will only
 	 * abort if we two or more simultanous calls to
-	 * bdi_add_default_flusher_task() occured, further additions will block
-	 * waiting for previous additions to finish.
+	 * bdi_add_default_flusher_task() occurred, further additions will
+	 * block waiting for previous additions to finish.
 	 */
 	if (!test_and_set_bit(BDI_pending, &bdi->state)) {
 		list_del_rcu(&bdi->bdi_list);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e91b81b..9a86f3c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2403,7 +2403,8 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 	/*
 	 * Currently, we are forced to kill the process in the event the
 	 * original mapper has unmapped pages from the child due to a failed
-	 * COW. Warn that such a situation has occured as it may not be obvious
+	 * COW. Warn that such a situation has occurred as it may not be
+	 * obvious
 	 */
 	if (is_vma_resv_set(vma, HPAGE_RESV_UNMAPPED)) {
 		printk(KERN_WARNING
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5b069e4..c9d8a8a 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -261,7 +261,7 @@ static void kmemleak_disable(void);
 } while (0)
 
 /*
- * Macro invoked when a serious kmemleak condition occured and cannot be
+ * Macro invoked when a serious kmemleak condition occurred and cannot be
  * recovered from. Kmemleak will be disabled and further allocation/freeing
  * tracing no longer available.
  */
@@ -961,7 +961,7 @@ static bool update_checksum(struct kmemleak_object *object)
 
 /*
  * Memory scanning is a long process and it needs to be interruptable. This
- * function checks whether such interrupt condition occured.
+ * function checks whether such interrupt condition occurred.
  */
 static int scan_should_stop(void)
 {
@@ -1679,7 +1679,7 @@ static int __init kmemleak_late_init(void)
 
 	if (atomic_read(&kmemleak_error)) {
 		/*
-		 * Some error occured and kmemleak was disabled. There is a
+		 * Some error occurred and kmemleak was disabled. There is a
 		 * small chance that kmemleak_disable() was called immediately
 		 * after setting kmemleak_initialized and we may end up with
 		 * two clean-up threads but serialized by scan_mutex.
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 0956eba..df1e700 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -220,7 +220,7 @@ static unsigned int ipv6_defrag(unsigned int hooknum,
 	if (reasm == NULL)
 		return NF_STOLEN;
 
-	/* error occured or not fragmented */
+	/* error occurred or not fragmented */
 	if (reasm == skb)
 		return NF_ACCEPT;
 
diff --git a/net/mac80211/rc80211_pid.h b/net/mac80211/rc80211_pid.h
index 1a873f0..8d8a141 100644
--- a/net/mac80211/rc80211_pid.h
+++ b/net/mac80211/rc80211_pid.h
@@ -80,7 +80,7 @@ union rc_pid_event_data {
 };
 
 struct rc_pid_event {
-	/* The time when the event occured */
+	/* The time when the event occurred */
 	unsigned long timestamp;
 
 	/* Event ID number */
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4b57216..506ca8c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -606,7 +606,7 @@ static const char *ct_sdp_header_search(const char *dptr, const char *limit,
 }
 
 /* Locate a SDP header (optionally a substring within the header value),
- * optionally stopping at the first occurence of the term header, parse
+ * optionally stopping at the first occurrence of the term header, parse
  * it and return the offset and length of the data we're interested in.
  */
 int ct_sip_get_sdp_header(const struct nf_conn *ct, const char *dptr,
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 3d739e5..4f61312 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -518,7 +518,7 @@ static int xs_nospace(struct rpc_task *task)
  *   EAGAIN:	The socket was blocked, please call again later to
  *		complete the request
  * ENOTCONN:	Caller needs to invoke connect logic then call again
- *    other:	Some other error occured, the request was not sent
+ *    other:	Some other error occurred, the request was not sent
  */
 static int xs_udp_send_request(struct rpc_task *task)
 {
@@ -606,7 +606,7 @@ static inline void xs_encode_tcp_record_marker(struct xdr_buf *buf)
  *   EAGAIN:	The socket was blocked, please call again later to
  *		complete the request
  * ENOTCONN:	Caller needs to invoke connect logic then call again
- *    other:	Some other error occured, the request was not sent
+ *    other:	Some other error occurred, the request was not sent
  *
  * XXX: In the case of soft timeouts, should we eventually give up
  *	if sendmsg is not able to make progress?
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 833e718..2dc5dc2 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -1233,7 +1233,7 @@ irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
 	reg = PCXHR_INPL(mgr, PCXHR_PLX_L2PCIDB);
 	PCXHR_OUTPL(mgr, PCXHR_PLX_L2PCIDB, reg);
 
-	/* timer irq occured */
+	/* timer irq occurred */
 	if (reg & PCXHR_IRQ_TIMER) {
 		int timer_toggle = reg & PCXHR_IRQ_TIMER;
 		/* is a 24 bit counter */
@@ -1288,7 +1288,7 @@ irqreturn_t pcxhr_interrupt(int irq, void *dev_id)
 	if (reg & PCXHR_IRQ_MASK) {
 		if (reg & PCXHR_IRQ_ASYNC) {
 			/* as we didn't request any async notifications,
-			 * some kind of xrun error will probably occured
+			 * some kind of xrun error will probably occurred
 			 */
 			/* better resynchronize all streams next interrupt : */
 			mgr->dsp_time_last = PCXHR_DSP_TIME_INVALID;
diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
index 53c81a5..d5b686e 100644
--- a/sound/ppc/snd_ps3.c
+++ b/sound/ppc/snd_ps3.c
@@ -358,7 +358,7 @@ static irqreturn_t snd_ps3_interrupt(int irq, void *dev_id)
 		 * filling dummy data, serial automatically start to
 		 * consume them and then will generate normal buffer
 		 * empty interrupts.
-		 * If both buffer underflow and buffer empty are occured,
+		 * If both buffer underflow and buffer empty have occurred,
 		 * it is better to do nomal data transfer than empty one
 		 */
 		snd_ps3_program_dma(card,
diff --git a/sound/ppc/snd_ps3_reg.h b/sound/ppc/snd_ps3_reg.h
index 03fdee4..a7962c5 100644
--- a/sound/ppc/snd_ps3_reg.h
+++ b/sound/ppc/snd_ps3_reg.h
@@ -316,13 +316,13 @@ DISABLED=Interrupt generation disabled.
 
 /*
 Audio Port Interrupt Status Register
-Indicates Interrupt status, which interrupt has occured, and can clear
+Indicates Interrupt status, which interrupt has occurred, and can clear
 each interrupt in this register.
 Writing 1b to a field containing 1b clears field and de-asserts interrupt.
 Writing 0b to a field has no effect.
 Field vaules are the following:
-0 - Interrupt hasn't occured.
-1 - Interrupt has occured.
+0 - Interrupt hasn't occurred.
+1 - Interrupt has occurred.
 
 
  31            24 23           16 15            8 7             0
@@ -756,7 +756,7 @@ The STATUS field can be used to monitor the progress of a DMA request.
 DONE indicates the previous request has completed.
 EVENT indicates that the DMA engine is waiting for the EVENT to occur.
 PENDING indicates that the DMA engine has not started processing this
-request, but the EVENT has occured.
+request, but the EVENT has occurred.
 DMA indicates that the data transfer is in progress.
 NOTIFY indicates that the notifier signalling end of transfer is being written.
 CLEAR indicated that the previous transfer was cleared.
-- 
1.6.6

