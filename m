Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0BCDq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:46:26 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45821 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab0BCDqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:46:16 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 10/11] tree-wide: Fix spelling of 'separate' and friends
Date: Wed,  3 Feb 2010 00:48:26 +0800
Message-Id: <1265129307-18201-10-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-9-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
 <1265129307-18201-5-git-send-email-daniel@caiaq.de>
 <1265129307-18201-6-git-send-email-daniel@caiaq.de>
 <1265129307-18201-7-git-send-email-daniel@caiaq.de>
 <1265129307-18201-8-git-send-email-daniel@caiaq.de>
 <1265129307-18201-9-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 Documentation/DocBook/mtdnand.tmpl                 |    2 +-
 Documentation/arm/Samsung-S3C24XX/CPUfreq.txt      |    4 ++--
 Documentation/hwmon/abituguru                      |    2 +-
 Documentation/input/rotary-encoder.txt             |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |   10 +++++-----
 arch/arm/mach-ep93xx/micro9.c                      |    2 +-
 arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h  |    2 +-
 .../arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h |    2 +-
 arch/arm/plat-s3c64xx/irq.c                        |    2 +-
 arch/arm/plat-s5pc1xx/irq.c                        |    2 +-
 arch/cris/arch-v10/lib/old_checksum.c              |    2 +-
 arch/cris/arch-v32/mm/tlb.c                        |    2 +-
 arch/powerpc/boot/dts/kmeter1.dts                  |    2 +-
 arch/sparc/kernel/leon_kernel.c                    |    2 +-
 arch/sparc/kernel/perf_event.c                     |    2 +-
 block/bsg.c                                        |    2 +-
 drivers/acpi/dock.c                                |    2 +-
 drivers/acpi/proc.c                                |    2 +-
 drivers/block/drbd/drbd_int.h                      |    2 +-
 drivers/char/agp/intel-agp.c                       |    2 +-
 drivers/char/hw_random/n2-drv.c                    |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    2 +-
 drivers/i2c/busses/i2c-pxa.c                       |    2 +-
 drivers/input/misc/yealink.h                       |    2 +-
 drivers/isdn/mISDN/l1oip_core.c                    |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    8 ++++----
 drivers/media/video/bt8xx/bttv-cards.c             |    4 ++--
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/net/chelsio/sge.c                          |    2 +-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/sungem.c                               |    2 +-
 drivers/net/wireless/ath/ar9170/main.c             |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt2800usb.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00debug.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    6 +++---
 drivers/scsi/lpfc/lpfc_els.c                       |    2 +-
 drivers/usb/musb/musb_regs.h                       |    2 +-
 drivers/video/omap/lcdc.c                          |    2 +-
 fs/binfmt_elf_fdpic.c                              |    2 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/extent_map.c                              |    2 +-
 include/media/davinci/vpfe_capture.h               |    2 +-
 net/netfilter/nf_conntrack_sip.c                   |    4 ++--
 net/netfilter/xt_hashlimit.c                       |    2 +-
 sound/pci/rme9652/hdspm.c                          |    2 +-
 tools/perf/util/hist.c                             |    2 +-
 51 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index a1f1d35..133cd6c 100644
--- a/Documentation/DocBook/mtdnand.tmpl
+++ b/Documentation/DocBook/mtdnand.tmpl
@@ -488,7 +488,7 @@ static void board_select_chip (struct mtd_info *mtd, int chip)
 				The ECC bytes must be placed immidiately after the data
 				bytes in order to make the syndrome generator work. This
 				is contrary to the usual layout used by software ECC. The
-				seperation of data and out of band area is not longer
+				separation of data and out of band area is not longer
 				possible. The nand driver code handles this layout and
 				the remaining free bytes in the oob area are managed by 
 				the autoplacement code. Provide a matching oob-layout
diff --git a/Documentation/arm/Samsung-S3C24XX/CPUfreq.txt b/Documentation/arm/Samsung-S3C24XX/CPUfreq.txt
index 76b3a11..fa968aa 100644
--- a/Documentation/arm/Samsung-S3C24XX/CPUfreq.txt
+++ b/Documentation/arm/Samsung-S3C24XX/CPUfreq.txt
@@ -14,8 +14,8 @@ Introduction
  how the clocks are arranged. The first implementation used as single
  PLL to feed the ARM, memory and peripherals via a series of dividers
  and muxes and this is the implementation that is documented here. A
- newer version where there is a seperate PLL and clock divider for the
- ARM core is available as a seperate driver.
+ newer version where there is a separate PLL and clock divider for the
+ ARM core is available as a separate driver.
 
 
 Layout
diff --git a/Documentation/hwmon/abituguru b/Documentation/hwmon/abituguru
index 87ffa0f..5eb3b9d 100644
--- a/Documentation/hwmon/abituguru
+++ b/Documentation/hwmon/abituguru
@@ -30,7 +30,7 @@ Supported chips:
 	   bank1_types=1,1,0,0,0,0,0,2,0,0,0,0,2,0,0,1
 	   You may also need to specify the fan_sensors option for these boards
 	   fan_sensors=5
-	2) There is a seperate abituguru3 driver for these motherboards,
+	2) There is a separate abituguru3 driver for these motherboards,
 	   the abituguru (without the 3 !) driver will not work on these
 	   motherboards (and visa versa)!
 
diff --git a/Documentation/input/rotary-encoder.txt b/Documentation/input/rotary-encoder.txt
index 3a6aec4..8b4129d 100644
--- a/Documentation/input/rotary-encoder.txt
+++ b/Documentation/input/rotary-encoder.txt
@@ -75,7 +75,7 @@ and the number of steps or will clamp at the maximum and zero depending on
 the configuration.
 
 Because GPIO to IRQ mapping is platform specific, this information must
-be given in seperately to the driver. See the example below.
+be given in separately to the driver. See the example below.
 
 ---------<snip>---------
 
diff --git a/Documentation/scsi/ChangeLog.lpfc b/Documentation/scsi/ChangeLog.lpfc
index ff19a52..2ffc114 100644
--- a/Documentation/scsi/ChangeLog.lpfc
+++ b/Documentation/scsi/ChangeLog.lpfc
@@ -989,8 +989,8 @@ Changes from 20040709 to 20040716
 	* Remove redundant port_cmp != 2 check in if
 	  (!port_cmp) { .... if (port_cmp != 2).... }
 	* Clock changes: removed struct clk_data and timerList.
-	* Clock changes: seperate nodev_tmo and els_retry_delay into 2
-	  seperate timers and convert to 1 argument changed
+	* Clock changes: separate nodev_tmo and els_retry_delay into 2
+	  separate timers and convert to 1 argument changed
 	  LPFC_NODE_FARP_PEND_t to struct lpfc_node_farp_pend convert
 	  ipfarp_tmo to 1 argument convert target struct tmofunc and
 	  rtplunfunc to 1 argument * cr_count, cr_delay and
@@ -1514,7 +1514,7 @@ Changes from 20040402 to 20040409
 	* Remove unused elxclock declaration in elx_sli.h.
 	* Since everywhere IOCB_ENTRY is used, the return value is cast,
 	  move the cast into the macro.
-	* Split ioctls out into seperate files
+	* Split ioctls out into separate files
 
 Changes from 20040326 to 20040402
 
@@ -1534,7 +1534,7 @@ Changes from 20040326 to 20040402
 	* Unused variable cleanup
 	* Use Linux list macros for DMABUF_t
 	* Break up ioctls into 3 sections, dfc, util, hbaapi
-	  rearranged code so this could be easily seperated into a
+	  rearranged code so this could be easily separated into a
 	  differnet module later All 3 are currently turned on by
 	  defines in lpfc_ioctl.c LPFC_DFC_IOCTL, LPFC_UTIL_IOCTL,
 	  LPFC_HBAAPI_IOCTL
@@ -1551,7 +1551,7 @@ Changes from 20040326 to 20040402
 	  started by lpfc_online().  lpfc_offline() only stopped
 	  els_timeout routine.  It now stops all timeout routines
 	  associated with that hba.
-	* Replace seperate next and prev pointers in struct
+	* Replace separate next and prev pointers in struct
 	  lpfc_bindlist with list_head type.  In elxHBA_t, replace
 	  fc_nlpbind_start and _end with fc_nlpbind_list and use
 	  list_head macros to access it.
diff --git a/arch/arm/mach-ep93xx/micro9.c b/arch/arm/mach-ep93xx/micro9.c
index f3757a1..c33360e 100644
--- a/arch/arm/mach-ep93xx/micro9.c
+++ b/arch/arm/mach-ep93xx/micro9.c
@@ -28,7 +28,7 @@
  *
  * Micro9-High has up to 64MB of 32-bit flash on CS1
  * Micro9-Mid has up to 64MB of either 32-bit or 16-bit flash on CS1
- * Micro9-Lite uses a seperate MTD map driver for flash support
+ * Micro9-Lite uses a separate MTD map driver for flash support
  * Micro9-Slim has up to 64MB of either 32-bit or 16-bit flash on CS1
  *************************************************************************/
 static struct physmap_flash_data micro9_flash_data;
diff --git a/arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h b/arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h
index 652e2bb..dda19da 100644
--- a/arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h
+++ b/arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h
@@ -78,7 +78,7 @@ extern int s3c_gpio_setcfg_s3c24xx_a(struct s3c_gpio_chip *chip,
  *	others = Special functions (dependant on bank)
  *
  * Note, since the code to deal with the case where there are two control
- * registers instead of one, we do not have a seperate set of functions for
+ * registers instead of one, we do not have a separate set of functions for
  * each case.
 */
 extern int s3c_gpio_setcfg_s3c64xx_4bit(struct s3c_gpio_chip *chip,
diff --git a/arch/arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h b/arch/arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h
index 36a85f5..a111ad8 100644
--- a/arch/arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h
+++ b/arch/arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h
@@ -12,7 +12,7 @@
  * published by the Free Software Foundation.
 */
 
-/* Note, this is a seperate header file as some of the clock framework
+/* Note, this is a separate header file as some of the clock framework
  * needs to touch this if the clk_48m is used as the USB OHCI or other
  * peripheral source.
 */
diff --git a/arch/arm/plat-s3c64xx/irq.c b/arch/arm/plat-s3c64xx/irq.c
index 8dc5b6d..3adb464 100644
--- a/arch/arm/plat-s3c64xx/irq.c
+++ b/arch/arm/plat-s3c64xx/irq.c
@@ -136,7 +136,7 @@ static inline unsigned int s3c_irq_uart_bit(unsigned int irq)
 	return irq & 3;
 }
 
-/* UART interrupt registers, not worth adding to seperate include header */
+/* UART interrupt registers, not worth adding to separate include header */
 
 static void s3c_irq_uart_mask(unsigned int irq)
 {
diff --git a/arch/arm/plat-s5pc1xx/irq.c b/arch/arm/plat-s5pc1xx/irq.c
index e44fd04..5b0e7ec 100644
--- a/arch/arm/plat-s5pc1xx/irq.c
+++ b/arch/arm/plat-s5pc1xx/irq.c
@@ -134,7 +134,7 @@ static inline unsigned int s3c_irq_uart_bit(unsigned int irq)
 	return irq & 3;
 }
 
-/* UART interrupt registers, not worth adding to seperate include header */
+/* UART interrupt registers, not worth adding to separate include header */
 #define S3C64XX_UINTP	0x30
 #define S3C64XX_UINTSP	0x34
 #define S3C64XX_UINTM	0x38
diff --git a/arch/cris/arch-v10/lib/old_checksum.c b/arch/cris/arch-v10/lib/old_checksum.c
index 1734b46..8f79163 100644
--- a/arch/cris/arch-v10/lib/old_checksum.c
+++ b/arch/cris/arch-v10/lib/old_checksum.c
@@ -77,7 +77,7 @@ __wsum csum_partial(const void *p, int len, __wsum __sum)
 		sum += *buff++;
 
 	if (endMarker > buff)
-		sum += *(const u8 *)buff;	/* add extra byte seperately */
+		sum += *(const u8 *)buff;	/* add extra byte separately */
 
 	BITOFF;
 	return (__force __wsum)sum;
diff --git a/arch/cris/arch-v32/mm/tlb.c b/arch/cris/arch-v32/mm/tlb.c
index 6779bcb..c030d02 100644
--- a/arch/cris/arch-v32/mm/tlb.c
+++ b/arch/cris/arch-v32/mm/tlb.c
@@ -189,7 +189,7 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 		spin_unlock(&mmu_context_lock);
 
 		/*
-		 * Remember the pgd for the fault handlers. Keep a seperate
+		 * Remember the pgd for the fault handlers. Keep a separate
 		 * copy of it because current and active_mm might be invalid
 		 * at points where * there's still a need to derefer the pgd.
 		 */
diff --git a/arch/powerpc/boot/dts/kmeter1.dts b/arch/powerpc/boot/dts/kmeter1.dts
index 65b8b4f..d8b5d12 100644
--- a/arch/powerpc/boot/dts/kmeter1.dts
+++ b/arch/powerpc/boot/dts/kmeter1.dts
@@ -490,7 +490,7 @@
 			compatible = "cfi-flash";
 			/*
 			 * The Intel P30 chip has 2 non-identical chips on
-			 * one die, so we need to define 2 seperate regions
+			 * one die, so we need to define 2 separate regions
 			 * that are scanned by physmap_of independantly.
 			 */
 			reg = <0 0x00000000 0x02000000
diff --git a/arch/sparc/kernel/leon_kernel.c b/arch/sparc/kernel/leon_kernel.c
index 87f1760..554e0b8 100644
--- a/arch/sparc/kernel/leon_kernel.c
+++ b/arch/sparc/kernel/leon_kernel.c
@@ -124,7 +124,7 @@ void __init leon_init_timers(irq_handler_t counter_fn)
 
 		if (!(LEON3_BYPASS_LOAD_PA(&leon3_gptimer_regs->config) &
 		      (1<<LEON3_GPTIMER_SEPIRQ))) {
-			prom_printf("irq timer not configured with seperate irqs \n");
+			prom_printf("irq timer not configured with separate irqs \n");
 			BUG();
 		}
 
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index e856456..a565ee5 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1353,7 +1353,7 @@ static void perf_callchain_user_32(struct pt_regs *regs,
 }
 
 /* Like powerpc we can't get PMU interrupts within the PMU handler,
- * so no need for seperate NMI and IRQ chains as on x86.
+ * so no need for separate NMI and IRQ chains as on x86.
  */
 static DEFINE_PER_CPU(struct perf_callchain_entry, callchain);
 
diff --git a/block/bsg.c b/block/bsg.c
index a9fd2d8..46597a6 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -260,7 +260,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 		return ERR_PTR(ret);
 
 	/*
-	 * map scatter-gather elements seperately and string them to request
+	 * map scatter-gather elements separately and string them to request
 	 */
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 	if (!rq)
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index bbc2c13..d7f363f 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -605,7 +605,7 @@ register_hotplug_dock_device(acpi_handle handle, struct acpi_dock_ops *ops,
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		/*
 		 * An ATA bay can be in a dock and itself can be ejected
-		 * seperately, so there are two 'dock stations' which need the
+		 * separately, so there are two 'dock stations' which need the
 		 * ops
 		 */
 		dd = find_dock_dependent_device(dock_station, handle);
diff --git a/drivers/acpi/proc.c b/drivers/acpi/proc.c
index d0d25e2..1ac678d 100644
--- a/drivers/acpi/proc.c
+++ b/drivers/acpi/proc.c
@@ -435,7 +435,7 @@ acpi_system_write_wakeup_device(struct file *file,
 				found_dev->wakeup.gpe_device)) {
 				printk(KERN_WARNING
 				       "ACPI: '%s' and '%s' have the same GPE, "
-				       "can't disable/enable one seperately\n",
+				       "can't disable/enable one separately\n",
 				       dev->pnp.bus_id, found_dev->pnp.bus_id);
 				dev->wakeup.state.enabled =
 				    found_dev->wakeup.state.enabled;
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 8e149de..d9301e8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1171,7 +1171,7 @@ extern int drbd_bitmap_io(struct drbd_conf *mdev, int (*io_fn)(struct drbd_conf
 /* Meta data layout
    We reserve a 128MB Block (4k aligned)
    * either at the end of the backing device
-   * or on a seperate meta data device. */
+   * or on a separate meta data device. */
 
 #define MD_RESERVED_SECT (128LU << 11)  /* 128 MB, unit sectors */
 /* The following numbers are sectors */
diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 3999a5f..45a22f9 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -269,7 +269,7 @@ static void intel_agp_insert_sg_entries(struct agp_memory *mem,
 			j++;
 		}
 	} else {
-		/* sg may merge pages, but we have to seperate
+		/* sg may merge pages, but we have to separate
 		 * per-page addr for GTT */
 		unsigned int len, m;
 
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 9b3e09c..10f868e 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -71,7 +71,7 @@ MODULE_VERSION(DRV_MODULE_VERSION);
  *        x22 + x21 + x17 + x15 + x13 + x12 + x11 + x7 + x5 + x + 1
  *
  * The RNG_CTL_VCO value of each noise cell must be programmed
- * seperately.  This is why 4 control register values must be provided
+ * separately.  This is why 4 control register values must be provided
  * to the hypervisor.  During a write, the hypervisor writes them all,
  * one at a time, to the actual RNG_CTL register.  The first three
  * values are used to setup the desired RNG_CTL_VCO for each entropy
diff --git a/drivers/gpu/drm/nouveau/nouveau_bios.c b/drivers/gpu/drm/nouveau/nouveau_bios.c
index d7f8d8b..52fb371 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bios.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bios.c
@@ -3544,7 +3544,7 @@ int nouveau_bios_parse_lvds_table(struct drm_device *dev, int pxclk, bool *dl, b
 	 * at which modes should be set up in the dual link style.
 	 *
 	 * Following the header, the BMP (ver 0xa) table has several records,
-	 * indexed by a seperate xlat table, indexed in turn by the fp strap in
+	 * indexed by a separate xlat table, indexed in turn by the fp strap in
 	 * EXTDEV_BOOT. Each record had a config byte, followed by 6 script
 	 * numbers for use by INIT_SUB which controlled panel init and power,
 	 * and finally a dword of ms to sleep between power off and on
diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 7647a20..90ffbf6 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -12,7 +12,7 @@
  *
  *  History:
  *    Apr 2002: Initial version [CS]
- *    Jun 2002: Properly seperated algo/adap [FB]
+ *    Jun 2002: Properly separated algo/adap [FB]
  *    Jan 2003: Fixed several bugs concerning interrupt handling [Kai-Uwe Bloem]
  *    Jan 2003: added limited signal handling [Kai-Uwe Bloem]
  *    Sep 2004: Major rework to ensure efficient bus handling [RMK]
diff --git a/drivers/input/misc/yealink.h b/drivers/input/misc/yealink.h
index 48af0be..1e0f523 100644
--- a/drivers/input/misc/yealink.h
+++ b/drivers/input/misc/yealink.h
@@ -127,7 +127,7 @@ struct yld_ctl_packet {
  * yld_status struct.
  */
 
-/* LCD, each segment must be driven seperately.
+/* LCD, each segment must be driven separately.
  *
  * Layout:
  *
diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index f1e8af5..0843fcf 100644
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -1509,7 +1509,7 @@ l1oip_init(void)
 			printk(KERN_DEBUG "%s: interface %d is %s with %s.\n",
 			    __func__, l1oip_cnt, pri ? "PRI" : "BRI",
 			    bundle ? "bundled IP packet for all B-channels" :
-			    "seperate IP packets for every B-channel");
+			    "separate IP packets for every B-channel");
 
 		hc = kzalloc(sizeof(struct l1oip), GFP_ATOMIC);
 		if (!hc) {
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 52e4ce4..80dda30 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -214,14 +214,14 @@ struct dvb_tuner_ops {
 	int (*get_status)(struct dvb_frontend *fe, u32 *status);
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
 
-	/** These are provided seperately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter seperately. */
+	/** These are provided separately from set_params in order to facilitate silicon
+	 * tuners which require sophisticated tuning loops, controlling each parameter separately. */
 	int (*set_frequency)(struct dvb_frontend *fe, u32 frequency);
 	int (*set_bandwidth)(struct dvb_frontend *fe, u32 bandwidth);
 
 	/*
-	 * These are provided seperately from set_params in order to facilitate silicon
-	 * tuners which require sophisticated tuning loops, controlling each parameter seperately.
+	 * These are provided separately from set_params in order to facilitate silicon
+	 * tuners which require sophisticated tuning loops, controlling each parameter separately.
 	 */
 	int (*set_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
 	int (*get_state)(struct dvb_frontend *fe, enum tuner_param param, struct tuner_state *state);
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 12279f6..716870a 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -4404,7 +4404,7 @@ static void rv605_muxsel(struct bttv *btv, unsigned int input)
 /* Tibet Systems 'Progress DVR' CS16 muxsel helper [Chris Fanning]
  *
  * The CS16 (available on eBay cheap) is a PCI board with four Fusion
- * 878A chips, a PCI bridge, an Atmel microcontroller, four sync seperator
+ * 878A chips, a PCI bridge, an Atmel microcontroller, four sync separator
  * chips, ten eight input analog multiplexors, a not chip and a few
  * other components.
  *
@@ -4426,7 +4426,7 @@ static void rv605_muxsel(struct bttv *btv, unsigned int input)
  *
  * There is an ATMEL microcontroller with an 8031 core on board.  I have not
  * determined what function (if any) it provides.  With the microcontroller
- * and sync seperator chips a guess is that it might have to do with video
+ * and sync separator chips a guess is that it might have to do with video
  * switching and maybe some digital I/O.
  */
 static void tibetCS16_muxsel(struct bttv *btv, unsigned int input)
diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index 60a2b69..16cc91c 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -4,7 +4,7 @@
  *  This is a driver for the SDHC controller found in Freescale MX2/MX3
  *  SoCs. It is basically the same hardware as found on MX1 (imxmmc.c).
  *  Unlike the hardware found on MX1, this hardware just works and does
- *  not need all the quirks found in imxmmc.c, hence the seperate driver.
+ *  not need all the quirks found in imxmmc.c, hence the separate driver.
  *
  *  Copyright (C) 2008 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
  *  Copyright (C) 2006 Pavel Pisa, PiKRON <ppisa@pikron.com>
diff --git a/drivers/net/chelsio/sge.c b/drivers/net/chelsio/sge.c
index 109d278..bef0233 100644
--- a/drivers/net/chelsio/sge.c
+++ b/drivers/net/chelsio/sge.c
@@ -248,7 +248,7 @@ static void restart_sched(unsigned long);
  *
  * Interrupts are handled by a single CPU and it is likely that on a MP system
  * the application is migrated to another CPU. In that scenario, we try to
- * seperate the RX(in irq context) and TX state in order to decrease memory
+ * separate the RX(in irq context) and TX state in order to decrease memory
  * contention.
  */
 struct sge {
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 997124d..e2ce8f8 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -674,7 +674,7 @@ static void igb_set_interrupt_capability(struct igb_adapter *adapter)
 	/* start with one vector for every rx queue */
 	numvecs = adapter->num_rx_queues;
 
-	/* if tx handler is seperate add 1 for every tx queue */
+	/* if tx handler is separate add 1 for every tx queue */
 	if (!(adapter->flags & IGB_FLAG_QUEUE_PAIRS))
 		numvecs += adapter->num_tx_queues;
 
diff --git a/drivers/net/sungem.c b/drivers/net/sungem.c
index b571a1b..a88fcb3 100644
--- a/drivers/net/sungem.c
+++ b/drivers/net/sungem.c
@@ -782,7 +782,7 @@ static int gem_rx(struct gem *gp, int work_to_do)
 			break;
 
 		/* When writing back RX descriptor, GEM writes status
-		 * then buffer address, possibly in seperate transactions.
+		 * then buffer address, possibly in separate transactions.
 		 * If we don't wait for the chip to write both, we could
 		 * post a new buffer to this descriptor then have GEM spam
 		 * on the buffer address.  We sync on the RX completion
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index f9d6db8..46a1e19 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2535,7 +2535,7 @@ void *ar9170_alloc(size_t priv_size)
 	/*
 	 * this buffer is used for rx stream reconstruction.
 	 * Under heavy load this device (or the transport layer?)
-	 * tends to split the streams into seperate rx descriptors.
+	 * tends to split the streams into separate rx descriptors.
 	 */
 
 	skb = __dev_alloc_skb(AR9170_MAX_RX_BUFFER_SIZE, GFP_KERNEL);
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 83f2592..486c935 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -368,7 +368,7 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 
 		/*
 		 * The encryption key doesn't fit within the CSR cache,
-		 * this means we should allocate it seperately and use
+		 * this means we should allocate it separately and use
 		 * rt2x00usb_vendor_request() to send the key to the hardware.
 		 */
 		reg = KEY_ENTRY(key->hw_key_idx);
@@ -382,7 +382,7 @@ static int rt2500usb_config_key(struct rt2x00_dev *rt2x00dev,
 		/*
 		 * The driver does not support the IV/EIV generation
 		 * in hardware. However it demands the data to be provided
-		 * both seperately as well as inside the frame.
+		 * both separately as well as inside the frame.
 		 * We already provided the CONFIG_CRYPTO_COPY_IV to rt2x00lib
 		 * to ensure rt2x00lib will not strip the data from the
 		 * frame after the copy, now we must tell mac80211
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index ab95346..2e5c8a1 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -100,7 +100,7 @@ static int rt2800usb_check_firmware(struct rt2x00_dev *rt2x00dev,
 	 * There are 2 variations of the rt2870 firmware.
 	 * a) size: 4kb
 	 * b) size: 8kb
-	 * Note that (b) contains 2 seperate firmware blobs of 4k
+	 * Note that (b) contains 2 separate firmware blobs of 4k
 	 * within the file. The first blob is the same firmware as (a),
 	 * but the second blob is for the additional chipsets.
 	 */
@@ -118,7 +118,7 @@ static int rt2800usb_check_firmware(struct rt2x00_dev *rt2x00dev,
 
 	/*
 	 * 8kb firmware files must be checked as if it were
-	 * 2 seperate firmware files.
+	 * 2 separate firmware files.
 	 */
 	while (offset < len) {
 		if (!rt2800usb_check_crc(data + offset, 4096))
diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
index 7d323a7..afee806 100644
--- a/drivers/net/wireless/rt2x00/rt2x00debug.c
+++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
@@ -109,7 +109,7 @@ struct rt2x00debug_intf {
 
 	/*
 	 * HW crypto statistics.
-	 * All statistics are stored seperately per cipher type.
+	 * All statistics are stored separately per cipher type.
 	 */
 	struct rt2x00debug_crypto crypto_stats[CIPHER_MAX];
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 265e66d..5e1d516 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -397,7 +397,7 @@ void rt2x00lib_rxdone(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Hardware might have stripped the IV/EIV/ICV data,
 	 * in that case it is possible that the data was
-	 * provided seperately (through hardware descriptor)
+	 * provided separately (through hardware descriptor)
 	 * in which case we should reinsert the data into the frame.
 	 */
 	if ((rxdesc.dev_flags & RXDONE_CRYPTO_IV) &&
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 9915a09..38ffca9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -502,7 +502,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	/*
 	 * When hardware encryption is supported, and this frame
 	 * is to be encrypted, we should strip the IV/EIV data from
-	 * the frame so we can provide it to the driver seperately.
+	 * the frame so we can provide it to the driver separately.
 	 */
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
 	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 0ca5893..99459db 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -476,7 +476,7 @@ static int rt61pci_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		 * The driver does not support the IV/EIV generation
 		 * in hardware. However it doesn't support the IV/EIV
 		 * inside the ieee80211 frame either, but requires it
-		 * to be provided seperately for the descriptor.
+		 * to be provided separately for the descriptor.
 		 * rt2x00lib will cut the IV/EIV data out of all frames
 		 * given to us by mac80211, but we must tell mac80211
 		 * to generate the IV/EIV data.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index ced3b6a..527368a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -339,7 +339,7 @@ static int rt73usb_config_shared_key(struct rt2x00_dev *rt2x00dev,
 		 * The driver does not support the IV/EIV generation
 		 * in hardware. However it doesn't support the IV/EIV
 		 * inside the ieee80211 frame either, but requires it
-		 * to be provided seperately for the descriptor.
+		 * to be provided separately for the descriptor.
 		 * rt2x00lib will cut the IV/EIV data out of all frames
 		 * given to us by mac80211, but we must tell mac80211
 		 * to generate the IV/EIV data.
@@ -439,7 +439,7 @@ static int rt73usb_config_pairwise_key(struct rt2x00_dev *rt2x00dev,
 		 * The driver does not support the IV/EIV generation
 		 * in hardware. However it doesn't support the IV/EIV
 		 * inside the ieee80211 frame either, but requires it
-		 * to be provided seperately for the descriptor.
+		 * to be provided separately for the descriptor.
 		 * rt2x00lib will cut the IV/EIV data out of all frames
 		 * given to us by mac80211, but we must tell mac80211
 		 * to generate the IV/EIV data.
@@ -1665,7 +1665,7 @@ static void rt73usb_fill_rxdone(struct queue_entry *entry,
 
 		/*
 		 * Hardware has stripped IV/EIV data from 802.11 frame during
-		 * decryption. It has provided the data seperately but rt2x00lib
+		 * decryption. It has provided the data separately but rt2x00lib
 		 * should decide if it should be reinserted.
 		 */
 		rxdesc->flags |= RX_FLAG_IV_STRIPPED;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 930d2ac..c898f47 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3117,7 +3117,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
 	    (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
 		/* A LS_RJT associated with Default RPI cleanup has its own
-		 * seperate code path.
+		 * separate code path.
 		 */
 		if (!(ndlp->nlp_flag & NLP_RM_DFLT_RPI))
 			ls_rjt = 1;
diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 473a94e..7c14d5c 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -436,7 +436,7 @@ static inline void  musb_write_txhubport(void __iomem *mbase, u8 epnum,
 #define MUSB_FLAT_OFFSET(_epnum, _offset)	\
 	(USB_OFFSET(USB_EP_NI0_TXMAXP) + (0x40 * (_epnum)) + (_offset))
 
-/* Not implemented - HW has seperate Tx/Rx FIFO */
+/* Not implemented - HW has separate Tx/Rx FIFO */
 #define MUSB_TXCSR_MODE			0x0000
 
 static inline void musb_write_txfifosz(void __iomem *mbase, u8 c_size)
diff --git a/drivers/video/omap/lcdc.c b/drivers/video/omap/lcdc.c
index a334839..9557f96 100644
--- a/drivers/video/omap/lcdc.c
+++ b/drivers/video/omap/lcdc.c
@@ -389,7 +389,7 @@ static int omap_lcdc_enable_plane(int plane, int enable)
 /*
  * Configure the LCD DMA for a palette load operation and do the palette
  * downloading synchronously. We don't use the frame+palette load mode of
- * the controller, since the palette can always be downloaded seperately.
+ * the controller, since the palette can always be downloaded separately.
  */
 static void load_palette(void)
 {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 18d7729..364fcfc 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1393,7 +1393,7 @@ static inline void fill_note(struct memelfnote *note, const char *name, int type
 
 /*
  * fill up all the fields in prstatus from the given task struct, except
- * registers which need to be filled up seperately.
+ * registers which need to be filled up separately.
  */
 static void fill_prstatus(struct elf_prstatus *prstatus,
 			  struct task_struct *p, long signr)
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index a8587e9..143d43a 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1528,7 +1528,7 @@ static void write_cinfo(__be32 **p, struct nfsd4_change_info *c)
 	} } while (0);
 
 /* Encode as an array of strings the string given with components
- * seperated @sep.
+ * separated @sep.
  */
 static __be32 nfsd4_encode_components(char sep, char *components,
 				   __be32 **pp, int *buflen)
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c5e4a49..ccb9c44 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1757,7 +1757,7 @@ out:
  * ocfs2_file_lock() and ocfs2_file_unlock() map to a single pair of
  * flock() calls. The locking approach this requires is sufficiently
  * different from all other cluster lock types that we implement a
- * seperate path to the "low-level" dlm calls. In particular:
+ * separate path to the "low-level" dlm calls. In particular:
  *
  * - No optimization of lock levels is done - we take at exactly
  *   what's been requested.
diff --git a/fs/ocfs2/extent_map.c b/fs/ocfs2/extent_map.c
index d35a27f..83e9b12 100644
--- a/fs/ocfs2/extent_map.c
+++ b/fs/ocfs2/extent_map.c
@@ -453,7 +453,7 @@ static int ocfs2_get_clusters_nocache(struct inode *inode,
 	if (i == -1) {
 		/*
 		 * Holes can be larger than the maximum size of an
-		 * extent, so we return their lengths in a seperate
+		 * extent, so we return their lengths in a separate
 		 * field.
 		 */
 		if (hole_len) {
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index d863e5e..4314a5f 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -165,7 +165,7 @@ struct vpfe_device {
 	u8 started;
 	/*
 	 * offset where second field starts from the starting of the
-	 * buffer for field seperated YCbCr formats
+	 * buffer for field separated YCbCr formats
 	 */
 	u32 field_off;
 };
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 4b57216..38b4fd6 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -276,7 +276,7 @@ EXPORT_SYMBOL_GPL(ct_sip_parse_request);
  * tabs, spaces and continuation lines, which are treated as a single whitespace
  * character.
  *
- * Some headers may appear multiple times. A comma seperated list of values is
+ * Some headers may appear multiple times. A comma separated list of values is
  * equivalent to multiple headers.
  */
 static const struct sip_header ct_sip_hdrs[] = {
@@ -412,7 +412,7 @@ int ct_sip_get_header(const struct nf_conn *ct, const char *dptr,
 }
 EXPORT_SYMBOL_GPL(ct_sip_get_header);
 
-/* Get next header field in a list of comma seperated values */
+/* Get next header field in a list of comma separated values */
 static int ct_sip_next_header(const struct nf_conn *ct, const char *dptr,
 			      unsigned int dataoff, unsigned int datalen,
 			      enum sip_header_types type,
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index dd16e40..cbaac92 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -1,6 +1,6 @@
 /*
  *	xt_hashlimit - Netfilter module to limit the number of packets per time
- *	seperately for each hashbucket (sourceip/sourceport/dstip/dstport)
+ *	separately for each hashbucket (sourceip/sourceport/dstip/dstport)
  *
  *	(C) 2003-2004 by Harald Welte <laforge@netfilter.org>
  *	Copyright © CC Computer Consultants GmbH, 2007 - 2008
diff --git a/sound/pci/rme9652/hdspm.c b/sound/pci/rme9652/hdspm.c
index a1b10d1..db0ed1c 100644
--- a/sound/pci/rme9652/hdspm.c
+++ b/sound/pci/rme9652/hdspm.c
@@ -2479,7 +2479,7 @@ static int snd_hdspm_put_qs_wire(struct snd_kcontrol *kcontrol,
    on MADICARD 
   - playback mixer matrix: [channelout+64] [output] [value]
   - input(thru) mixer matrix: [channelin] [output] [value]
-  (better do 2 kontrols for seperation ?)
+  (better do 2 kontrols for separation ?)
 */
 
 #define HDSPM_MIXER(xname, xindex) \
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index e8daf5c..44408c2 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -321,7 +321,7 @@ static size_t __callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			new_depth_mask &= ~(1 << (depth - 1));
 
 		/*
-		 * But we keep the older depth mask for the line seperator
+		 * But we keep the older depth mask for the line separator
 		 * to keep the level link until we reach the last child
 		 */
 		ret += ipchain__fprintf_graph_line(fp, depth, depth_mask,
-- 
1.6.3.3

