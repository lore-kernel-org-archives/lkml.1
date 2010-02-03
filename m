Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0BCK5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 05:57:16 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:37535 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab0BCK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 05:57:07 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Joe Perches <joe@perches.com>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH] tree-wide: Assorted spelling fixes
Date: Wed,  3 Feb 2010 08:01:28 +0800
Message-Id: <1265155288-20095-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LNX.2.00.1002031143150.15395@pobox.suse.cz>
References: <alpine.LNX.2.00.1002031143150.15395@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In particular, several occurances of funny versions of 'success',
'unknown', 'therefore', 'acknowledge', 'argument', 'achieve', 'address',
'beginning', 'desirable', 'separate' and 'necessary' are fixed.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Joe Perches <joe@perches.com>
Cc: Junio C Hamano <gitster@pobox.com>
---
 Documentation/DocBook/mtdnand.tmpl                 |    6 +++---
 Documentation/DocBook/v4l/common.xml               |    2 +-
 Documentation/DocBook/v4l/vidioc-g-parm.xml        |    2 +-
 Documentation/arm/Samsung-S3C24XX/CPUfreq.txt      |    4 ++--
 Documentation/hwmon/abituguru                      |    2 +-
 Documentation/input/rotary-encoder.txt             |    2 +-
 Documentation/networking/skfp.txt                  |    2 +-
 Documentation/s390/kvm.txt                         |    2 +-
 Documentation/scsi/ChangeLog.lpfc                  |   10 +++++-----
 Documentation/trace/ftrace.txt                     |    2 +-
 arch/arm/mach-ep93xx/micro9.c                      |    2 +-
 arch/arm/mach-nomadik/board-nhk8815.c              |    2 +-
 arch/arm/mach-u300/core.c                          |    4 ++--
 arch/arm/mach-u300/include/mach/debug-macro.S      |    2 +-
 arch/arm/plat-s3c/include/plat/gpio-cfg-helpers.h  |    2 +-
 .../arm/plat-s3c/include/plat/regs-usb-hsotg-phy.h |    2 +-
 arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h |    2 +-
 arch/arm/plat-s3c64xx/irq.c                        |    2 +-
 arch/arm/plat-s5pc1xx/irq.c                        |    2 +-
 arch/cris/arch-v10/lib/old_checksum.c              |    2 +-
 arch/cris/arch-v32/mm/tlb.c                        |    2 +-
 arch/h8300/include/asm/io.h                        |    2 +-
 arch/ia64/sn/kernel/setup.c                        |    2 +-
 arch/m68k/atari/atakeyb.c                          |    2 +-
 arch/m68k/include/asm/io_no.h                      |    2 +-
 arch/mips/alchemy/common/reset.c                   |    2 +-
 arch/powerpc/boot/dts/kmeter1.dts                  |    2 +-
 arch/s390/include/asm/cio.h                        |    2 +-
 arch/s390/kernel/sclp.S                            |    2 +-
 arch/sparc/kernel/leon_kernel.c                    |    2 +-
 arch/sparc/kernel/perf_event.c                     |    2 +-
 arch/x86/crypto/twofish-i586-asm_32.S              |   10 +++++-----
 arch/x86/crypto/twofish-x86_64-asm_64.S            |   20 ++++++++++----------
 arch/x86/kernel/head_64.S                          |    2 +-
 arch/x86/kernel/pci-calgary_64.c                   |    2 +-
 arch/x86/kernel/tsc.c                              |    2 +-
 arch/xtensa/kernel/entry.S                         |    4 ++--
 block/bsg.c                                        |    2 +-
 drivers/acpi/dock.c                                |    2 +-
 drivers/acpi/proc.c                                |    2 +-
 drivers/ata/libata-sff.c                           |    2 +-
 drivers/ata/pata_acpi.c                            |    2 +-
 drivers/ata/pata_hpt3x3.c                          |    2 +-
 drivers/ata/pata_pcmcia.c                          |    2 +-
 drivers/block/drbd/drbd_int.h                      |    4 ++--
 drivers/block/drbd/drbd_req.h                      |    2 +-
 drivers/char/agp/intel-agp.c                       |    2 +-
 drivers/char/applicom.c                            |    2 +-
 drivers/char/hvc_iseries.c                         |    2 +-
 drivers/char/hw_random/n2-drv.c                    |    2 +-
 drivers/char/ip2/i2hw.h                            |    2 +-
 drivers/char/pty.c                                 |    2 +-
 drivers/char/tty_io.c                              |    2 +-
 drivers/char/vt.c                                  |    2 +-
 drivers/dma/coh901318_lli.h                        |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c             |    2 +-
 drivers/gpu/drm/nouveau/nouveau_drv.h              |    2 +-
 drivers/gpu/drm/via/via_irq.c                      |    4 ++--
 drivers/i2c/busses/i2c-pxa.c                       |    2 +-
 drivers/infiniband/hw/ehca/ehca_qes.h              |    4 ++--
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    2 +-
 drivers/input/misc/yealink.h                       |    2 +-
 drivers/isdn/i4l/isdn_common.c                     |    2 +-
 drivers/isdn/mISDN/l1oip_core.c                    |    2 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h          |    8 ++++----
 drivers/media/video/bt8xx/bttv-cards.c             |    4 ++--
 drivers/media/video/gspca/ov519.c                  |    2 +-
 drivers/media/video/pwc/philips.txt                |    2 +-
 drivers/media/video/sn9c102/sn9c102_sensor.h       |    2 +-
 drivers/media/video/tea6420.c                      |    2 +-
 drivers/mfd/sm501.c                                |    8 ++++----
 drivers/mmc/host/mxcmmc.c                          |    2 +-
 drivers/mtd/chips/jedec_probe.c                    |    2 +-
 drivers/mtd/nand/bcm_umi_nand.c                    |    4 ++--
 drivers/mtd/nand/mxc_nand.c                        |    2 +-
 drivers/net/atlx/atl2.h                            |    2 +-
 drivers/net/chelsio/sge.c                          |    2 +-
 drivers/net/e1000e/82571.c                         |    2 +-
 drivers/net/e1000e/lib.c                           |    2 +-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/irda/sa1100_ir.c                       |    2 +-
 drivers/net/qlge/qlge_ethtool.c                    |    2 +-
 drivers/net/qlge/qlge_main.c                       |    2 +-
 drivers/net/sfc/regs.h                             |    2 +-
 drivers/net/smsc9420.c                             |    2 +-
 drivers/net/spider_net.c                           |    4 ++--
 drivers/net/sungem.c                               |    2 +-
 drivers/net/tehuti.c                               |    2 +-
 drivers/net/tokenring/tms380tr.c                   |    4 ++--
 drivers/net/tun.c                                  |    2 +-
 drivers/net/ucc_geth.c                             |    2 +-
 drivers/net/wimax/i2400m/fw.c                      |    2 +-
 drivers/net/wimax/i2400m/i2400m.h                  |    2 +-
 drivers/net/wimax/i2400m/sdio.c                    |    4 ++--
 drivers/net/wimax/i2400m/usb.c                     |    4 ++--
 drivers/net/wireless/ath/ar9170/main.c             |    2 +-
 drivers/net/wireless/iwmc3200wifi/lmac.h           |    2 +-
 drivers/net/wireless/rt2x00/rt2500usb.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt2800usb.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00debug.c          |    2 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c            |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c          |    2 +-
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    6 +++---
 drivers/s390/char/raw3270.c                        |    2 +-
 drivers/s390/char/sclp.c                           |    2 +-
 drivers/scsi/a100u2w.c                             |    2 +-
 drivers/scsi/initio.c                              |    2 +-
 drivers/scsi/libfc/fc_fcp.c                        |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                       |    4 ++--
 drivers/scsi/pcmcia/nsp_cs.h                       |    2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |    2 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |    2 +-
 drivers/scsi/pmcraid.h                             |    2 +-
 drivers/scsi/sd.c                                  |    2 +-
 drivers/spi/spi_s3c24xx.c                          |    2 +-
 drivers/usb/musb/musb_regs.h                       |    2 +-
 drivers/usb/serial/cypress_m8.c                    |    2 +-
 drivers/video/omap/lcdc.c                          |    2 +-
 drivers/video/s1d13xxxfb.c                         |    4 ++--
 drivers/video/sm501fb.c                            |    2 +-
 fs/affs/bitmap.c                                   |    2 +-
 fs/binfmt_elf_fdpic.c                              |    2 +-
 fs/cifs/cifs_dfs_ref.c                             |    2 +-
 fs/cifs/cifssmb.c                                  |    2 +-
 fs/ext4/move_extent.c                              |    2 +-
 fs/fuse/inode.c                                    |    2 +-
 fs/gfs2/ops_fstype.c                               |    2 +-
 fs/jbd/transaction.c                               |    2 +-
 fs/nfsd/nfs4xdr.c                                  |    2 +-
 fs/ocfs2/dlmglue.c                                 |    2 +-
 fs/ocfs2/extent_map.c                              |    2 +-
 fs/reiserfs/bitmap.c                               |    2 +-
 include/linux/hil.h                                |   16 ++++++++--------
 include/linux/lru_cache.h                          |    2 +-
 include/linux/sched.h                              |    2 +-
 include/media/davinci/vpfe_capture.h               |    2 +-
 net/ipv4/tcp_timer.c                               |    2 +-
 net/mac80211/mesh_plink.c                          |    2 +-
 net/netfilter/nf_conntrack_sip.c                   |    4 ++--
 net/netfilter/xt_hashlimit.c                       |    2 +-
 net/sctp/sm_sideeffect.c                           |    2 +-
 scripts/gfp-translate                              |    2 +-
 sound/pci/es1968.c                                 |    2 +-
 sound/pci/rme9652/hdspm.c                          |    2 +-
 sound/soc/codecs/wm8990.c                          |    2 +-
 tools/perf/util/hist.c                             |    2 +-
 147 files changed, 198 insertions(+), 198 deletions(-)

diff --git a/Documentation/DocBook/mtdnand.tmpl b/Documentation/DocBook/mtdnand.tmpl
index 5e7d84b..133cd6c 100644
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
@@ -560,7 +560,7 @@ static void board_select_chip (struct mtd_info *mtd, int chip)
 				bad blocks. They have factory marked good blocks. The marker pattern
 				is erased when the block is erased to be reused. So in case of
 				powerloss before writing the pattern back to the chip this block 
-				would be lost and added to the bad blocks. Therefor we scan the 
+				would be lost and added to the bad blocks. Therefore we scan the 
 				chip(s) when we detect them the first time for good blocks and 
 				store this information in a bad block table before erasing any 
 				of the blocks.
@@ -1094,7 +1094,7 @@ in this page</entry>
 		manufacturers specifications. This applies similar to the spare area. 
 	</para>
 	<para>
-		Therefor NAND aware filesystems must either write in page size chunks
+		Therefore NAND aware filesystems must either write in page size chunks
 		or hold a writebuffer to collect smaller writes until they sum up to 
 		pagesize. Available NAND aware filesystems: JFFS2, YAFFS. 		
 	</para>
diff --git a/Documentation/DocBook/v4l/common.xml b/Documentation/DocBook/v4l/common.xml
index c65f0ac..cea23e1 100644
--- a/Documentation/DocBook/v4l/common.xml
+++ b/Documentation/DocBook/v4l/common.xml
@@ -1170,7 +1170,7 @@ frames per second. If less than this number of frames is to be
 captured or output, applications can request frame skipping or
 duplicating on the driver side. This is especially useful when using
 the &func-read; or &func-write;, which are not augmented by timestamps
-or sequence counters, and to avoid unneccessary data copying.</para>
+or sequence counters, and to avoid unnecessary data copying.</para>
 
     <para>Finally these ioctls can be used to determine the number of
 buffers used internally by a driver in read/write mode. For
diff --git a/Documentation/DocBook/v4l/vidioc-g-parm.xml b/Documentation/DocBook/v4l/vidioc-g-parm.xml
index 78332d3..392aa9e 100644
--- a/Documentation/DocBook/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/v4l/vidioc-g-parm.xml
@@ -55,7 +55,7 @@ captured or output, applications can request frame skipping or
 duplicating on the driver side. This is especially useful when using
 the <function>read()</function> or <function>write()</function>, which
 are not augmented by timestamps or sequence counters, and to avoid
-unneccessary data copying.</para>
+unnecessary data copying.</para>
 
     <para>Further these ioctls can be used to determine the number of
 buffers used internally by a driver in read/write mode. For
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
 
diff --git a/Documentation/networking/skfp.txt b/Documentation/networking/skfp.txt
index abfddf8..203ec66 100644
--- a/Documentation/networking/skfp.txt
+++ b/Documentation/networking/skfp.txt
@@ -68,7 +68,7 @@ Compaq adapters (not tested):
 =======================
 
 From v2.01 on, the driver is integrated in the linux kernel sources.
-Therefor, the installation is the same as for any other adapter
+Therefore, the installation is the same as for any other adapter
 supported by the kernel.
 Refer to the manual of your distribution about the installation
 of network adapters.
diff --git a/Documentation/s390/kvm.txt b/Documentation/s390/kvm.txt
index 6f5ceb0..85f3280 100644
--- a/Documentation/s390/kvm.txt
+++ b/Documentation/s390/kvm.txt
@@ -102,7 +102,7 @@ args:		unsigned long
 see also:	include/linux/kvm.h
 This ioctl stores the state of the cpu at the guest real address given as
 argument, unless one of the following values defined in include/linux/kvm.h
-is given as arguement:
+is given as argument:
 KVM_S390_STORE_STATUS_NOADDR - the CPU stores its status to the save area in
 absolute lowcore as defined by the principles of operation
 KVM_S390_STORE_STATUS_PREFIXED - the CPU stores its status to the save area in
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
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index bab3040..03485bf 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1588,7 +1588,7 @@ module author does not need to worry about it.
 
 When tracing is enabled, kstop_machine is called to prevent
 races with the CPUS executing code being modified (which can
-cause the CPU to do undesireable things), and the nops are
+cause the CPU to do undesirable things), and the nops are
 patched back to calls. But this time, they do not call mcount
 (which is just a function stub). They now call into the ftrace
 infrastructure.
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
diff --git a/arch/arm/mach-nomadik/board-nhk8815.c b/arch/arm/mach-nomadik/board-nhk8815.c
index 9438bf6..ab3712c 100644
--- a/arch/arm/mach-nomadik/board-nhk8815.c
+++ b/arch/arm/mach-nomadik/board-nhk8815.c
@@ -38,7 +38,7 @@
 #define SRC_CR_INIT_MASK	0x00007fff
 #define SRC_CR_INIT_VAL		0x2aaa8000
 
-/* These adresses span 16MB, so use three individual pages */
+/* These addresses span 16MB, so use three individual pages */
 static struct resource nhk8815_nand_resources[] = {
 	{
 		.name = "nand_addr",
diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 653e25b..d0cb5e9 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -356,7 +356,7 @@ static struct resource ave_resources[] = {
 	/*
 	 * The AVE3e requires two regions of 256MB that it considers
 	 * "invisible". The hardware will not be able to access these
-	 * adresses, so they should never point to system RAM.
+	 * addresses, so they should never point to system RAM.
 	 */
 	{
 		.name  = "AVE3e Reserved 0",
@@ -571,7 +571,7 @@ static void __init u300_init_check_chip(void)
 /*
  * Some devices and their resources require reserved physical memory from
  * the end of the available RAM. This function traverses the list of devices
- * and assigns actual adresses to these.
+ * and assigns actual addresses to these.
  */
 static void __init u300_assign_physmem(void)
 {
diff --git a/arch/arm/mach-u300/include/mach/debug-macro.S b/arch/arm/mach-u300/include/mach/debug-macro.S
index f3a1cbb..d591fe1 100644
--- a/arch/arm/mach-u300/include/mach/debug-macro.S
+++ b/arch/arm/mach-u300/include/mach/debug-macro.S
@@ -11,7 +11,7 @@
 #include <mach/hardware.h>
 
 	.macro	addruart,rx
-	/* If we move the adress using MMU, use this. */
+	/* If we move the address using MMU, use this. */
 	mrc	p15, 0, \rx, c1, c0
 	tst	\rx, #1			@ MMU enabled?
 	ldreq	\rx,	  = U300_SLOW_PER_PHYS_BASE @ MMU off, physical address
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
diff --git a/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h b/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h
index 33d421d..d623235 100644
--- a/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h
+++ b/arch/arm/plat-s3c24xx/include/plat/cpu-freq-core.h
@@ -135,7 +135,7 @@ struct s3c_cpufreq_config {
  * @locktime_m: The lock-time in uS for the MPLL.
  * @locktime_u: The lock-time in uS for the UPLL.
  * @locttime_bits: The number of bits each LOCKTIME field.
- * @need_pll: Set if this driver needs to change the PLL values to acheive
+ * @need_pll: Set if this driver needs to change the PLL values to achieve
  *	any frequency changes. This is really only need by devices like the
  *	S3C2410 where there is no or limited divider between the PLL and the
  *	ARMCLK.
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
diff --git a/arch/h8300/include/asm/io.h b/arch/h8300/include/asm/io.h
index 33e842f..c1a8df2 100644
--- a/arch/h8300/include/asm/io.h
+++ b/arch/h8300/include/asm/io.h
@@ -25,7 +25,7 @@
  * memory location directly.
  */
 /* ++roman: The assignments to temp. vars avoid that gcc sometimes generates
- * two accesses to memory, which may be undesireable for some devices.
+ * two accesses to memory, which may be undesirable for some devices.
  */
 
 /*
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index ece1bf9..c6c6d93 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -241,7 +241,7 @@ static void __cpuinit sn_check_for_wars(void)
  * Note:  This stuff is duped here because Altix requires the PCDP to
  * locate a usable VGA device due to lack of proper ACPI support.  Structures
  * could be used from drivers/firmware/pcdp.h, but it was decided that moving
- * this file to a more public location just for Altix use was undesireable.
+ * this file to a more public location just for Altix use was undesirable.
  */
 
 struct hcdp_uart_desc {
diff --git a/arch/m68k/atari/atakeyb.c b/arch/m68k/atari/atakeyb.c
index 4add96d..5890897 100644
--- a/arch/m68k/atari/atakeyb.c
+++ b/arch/m68k/atari/atakeyb.c
@@ -121,7 +121,7 @@ KEYBOARD_STATE kb_state;
  * bytes have been lost and in which state of the packet structure we are now.
  * This usually causes keyboards bytes to be interpreted as mouse movements
  * and vice versa, which is very annoying. It seems better to throw away some
- * bytes (that are usually mouse bytes) than to misinterpret them. Therefor I
+ * bytes (that are usually mouse bytes) than to misinterpret them. Therefore I
  * introduced the RESYNC state for IKBD data. In this state, the bytes up to
  * one that really looks like a key event (0x04..0xf2) or the start of a mouse
  * packet (0xf8..0xfb) are thrown away, but at most 2 bytes. This at least
diff --git a/arch/m68k/include/asm/io_no.h b/arch/m68k/include/asm/io_no.h
index 359065d..6e2413e 100644
--- a/arch/m68k/include/asm/io_no.h
+++ b/arch/m68k/include/asm/io_no.h
@@ -16,7 +16,7 @@
  * memory location directly.
  */
 /* ++roman: The assignments to temp. vars avoid that gcc sometimes generates
- * two accesses to memory, which may be undesireable for some devices.
+ * two accesses to memory, which may be undesirable for some devices.
  */
 
 /*
diff --git a/arch/mips/alchemy/common/reset.c b/arch/mips/alchemy/common/reset.c
index 4791011..45e6074 100644
--- a/arch/mips/alchemy/common/reset.c
+++ b/arch/mips/alchemy/common/reset.c
@@ -147,7 +147,7 @@ void au1000_restart(char *command)
 	/* Give board a chance to do a hardware reset */
 	board_reset();
 
-	/* Jump to the beggining in case board_reset() is empty */
+	/* Jump to the beginning in case board_reset() is empty */
 	__asm__ __volatile__("jr\t%0"::"r"(0xbfc00000));
 }
 
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
diff --git a/arch/s390/include/asm/cio.h b/arch/s390/include/asm/cio.h
index e85679a..e34347d 100644
--- a/arch/s390/include/asm/cio.h
+++ b/arch/s390/include/asm/cio.h
@@ -20,7 +20,7 @@
 /**
  * struct ccw1 - channel command word
  * @cmd_code: command code
- * @flags: flags, like IDA adressing, etc.
+ * @flags: flags, like IDA addressing, etc.
  * @count: byte count
  * @cda: data address
  *
diff --git a/arch/s390/kernel/sclp.S b/arch/s390/kernel/sclp.S
index e27ca63..27c1a2e 100644
--- a/arch/s390/kernel/sclp.S
+++ b/arch/s390/kernel/sclp.S
@@ -221,7 +221,7 @@ _sclp_print:
 	lh	%r9,0(%r8)			# update sccb length
 	ar	%r9,%r6
 	sth	%r9,0(%r8)
-	ar	%r7,%r6				# update current mto adress
+	ar	%r7,%r6				# update current mto address
 	ltr	%r0,%r0				# more characters?
 	jnz	.LinitmtoS4
 	l	%r2,.LwritedataS4-.LbaseS4(%r13)# write data
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
 
diff --git a/arch/x86/crypto/twofish-i586-asm_32.S b/arch/x86/crypto/twofish-i586-asm_32.S
index 39b98ed..575331c 100644
--- a/arch/x86/crypto/twofish-i586-asm_32.S
+++ b/arch/x86/crypto/twofish-i586-asm_32.S
@@ -22,7 +22,7 @@
 
 #include <asm/asm-offsets.h>
 
-/* return adress at 0 */
+/* return address at 0 */
 
 #define in_blk    12  /* input byte array address parameter*/
 #define out_blk   8  /* output byte array address parameter*/
@@ -230,8 +230,8 @@ twofish_enc_blk:
 	push    %edi
 
 	mov	tfm + 16(%esp),	%ebp	/* abuse the base pointer: set new base bointer to the crypto tfm */
-	add	$crypto_tfm_ctx_offset, %ebp	/* ctx adress */
-	mov     in_blk+16(%esp),%edi	/* input adress in edi */
+	add	$crypto_tfm_ctx_offset, %ebp	/* ctx address */
+	mov     in_blk+16(%esp),%edi	/* input address in edi */
 
 	mov	(%edi),		%eax
 	mov	b_offset(%edi),	%ebx
@@ -286,8 +286,8 @@ twofish_dec_blk:
 
 
 	mov	tfm + 16(%esp),	%ebp	/* abuse the base pointer: set new base bointer to the crypto tfm */
-	add	$crypto_tfm_ctx_offset, %ebp	/* ctx adress */
-	mov     in_blk+16(%esp),%edi	/* input adress in edi */
+	add	$crypto_tfm_ctx_offset, %ebp	/* ctx address */
+	mov     in_blk+16(%esp),%edi	/* input address in edi */
 
 	mov	(%edi),		%eax
 	mov	b_offset(%edi),	%ebx
diff --git a/arch/x86/crypto/twofish-x86_64-asm_64.S b/arch/x86/crypto/twofish-x86_64-asm_64.S
index 35974a5..573aa10 100644
--- a/arch/x86/crypto/twofish-x86_64-asm_64.S
+++ b/arch/x86/crypto/twofish-x86_64-asm_64.S
@@ -221,11 +221,11 @@
 twofish_enc_blk:
 	pushq    R1
 
-	/* %rdi contains the crypto tfm adress */
-	/* %rsi contains the output adress */
-	/* %rdx contains the input adress */
-	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx adress */
-	/* ctx adress is moved to free one non-rex register
+	/* %rdi contains the crypto tfm address */
+	/* %rsi contains the output address */
+	/* %rdx contains the input address */
+	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx address */
+	/* ctx address is moved to free one non-rex register
 	as target for the 8bit high operations */
 	mov	%rdi,		%r11
 
@@ -274,11 +274,11 @@ twofish_enc_blk:
 twofish_dec_blk:
 	pushq    R1
 
-	/* %rdi contains the crypto tfm adress */
-	/* %rsi contains the output adress */
-	/* %rdx contains the input adress */
-	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx adress */
-	/* ctx adress is moved to free one non-rex register
+	/* %rdi contains the crypto tfm address */
+	/* %rsi contains the output address */
+	/* %rdx contains the input address */
+	add	$crypto_tfm_ctx_offset, %rdi	/* set ctx address */
+	/* ctx address is moved to free one non-rex register
 	as target for the 8bit high operations */
 	mov	%rdi,		%r11
 
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 2d8b503..3d1e6f1 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -27,7 +27,7 @@
 #define GET_CR2_INTO_RCX movq %cr2, %rcx
 #endif
 
-/* we are not able to switch in one step to the final KERNEL ADRESS SPACE
+/* we are not able to switch in one step to the final KERNEL ADDRESS SPACE
  * because we need identity-mapped pages.
  *
  */
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 2bbde60..fb99f7e 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1309,7 +1309,7 @@ static void calgary_init_bitmap_from_tce_table(struct iommu_table *tbl)
 /*
  * get_tce_space_from_tar():
  * Function for kdump case. Get the tce tables from first kernel
- * by reading the contents of the base adress register of calgary iommu
+ * by reading the contents of the base address register of calgary iommu
  */
 static void __init get_tce_space_from_tar(void)
 {
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..dec8f68 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -50,7 +50,7 @@ u64 native_sched_clock(void)
 	 *   unstable. We do this because unlike Time Of Day,
 	 *   the scheduler clock tolerates small errors and it's
 	 *   very important for it to be as fast as the platform
-	 *   can achive it. )
+	 *   can achieve it. )
 	 */
 	if (unlikely(tsc_disabled)) {
 		/* No locking but a rare wrong value is not a big deal: */
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 80d24c4..77fc9f6 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -104,7 +104,7 @@
  *   excsave has been restored, and
  *   stack pointer (a1) has been set.
  *
- * Note: _user_exception might be at an odd adress. Don't use call0..call12
+ * Note: _user_exception might be at an odd address. Don't use call0..call12
  */
 
 ENTRY(user_exception)
@@ -244,7 +244,7 @@ _user_exception:
  *   excsave has been restored, and
  *   stack pointer (a1) has been set.
  *
- * Note: _kernel_exception might be at an odd adress. Don't use call0..call12
+ * Note: _kernel_exception might be at an odd address. Don't use call0..call12
  */
 
 ENTRY(kernel_exception)
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
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 741065c..7f2c94a 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2258,7 +2258,7 @@ EXPORT_SYMBOL_GPL(ata_sff_postreset);
  *	@qc: command
  *
  *	Drain the FIFO and device of any stuck data following a command
- *	failing to complete. In some cases this is neccessary before a
+ *	failing to complete. In some cases this is necessary before a
  *	reset will recover the device.
  *
  */
diff --git a/drivers/ata/pata_acpi.c b/drivers/ata/pata_acpi.c
index d8f35fe..9e33da9 100644
--- a/drivers/ata/pata_acpi.c
+++ b/drivers/ata/pata_acpi.c
@@ -161,7 +161,7 @@ static void pacpi_set_dmamode(struct ata_port *ap, struct ata_device *adev)
  *
  *	Called when the libata layer is about to issue a command. We wrap
  *	this interface so that we can load the correct ATA timings if
- *	neccessary.
+ *	necessary.
  */
 
 static unsigned int pacpi_qc_issue(struct ata_queued_cmd *qc)
diff --git a/drivers/ata/pata_hpt3x3.c b/drivers/ata/pata_hpt3x3.c
index c86c716..727a81c 100644
--- a/drivers/ata/pata_hpt3x3.c
+++ b/drivers/ata/pata_hpt3x3.c
@@ -180,7 +180,7 @@ static void hpt3x3_init_chipset(struct pci_dev *dev)
  *	@id: Entry in match table
  *
  *	Perform basic initialisation. We set the device up so we access all
- *	ports via BAR4. This is neccessary to work around errata.
+ *	ports via BAR4. This is necessary to work around errata.
  */
 
 static int hpt3x3_init_one(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 1b392c9..416aebb 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -131,7 +131,7 @@ static unsigned int ata_data_xfer_8bit(struct ata_device *dev,
  *	@qc: command
  *
  *	Drain the FIFO and device of any stuck data following a command
- *	failing to complete. In some cases this is neccessary before a
+ *	failing to complete. In some cases this is necessary before a
  *	reset will recover the device.
  *
  */
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2bf3a6e..d9301e8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -95,7 +95,7 @@ extern char usermode_helper[];
 
 /* All EEs on the free list should have ID_VACANT (== 0)
  * freshly allocated EEs get !ID_VACANT (== 1)
- * so if it says "cannot dereference null pointer at adress 0x00000001",
+ * so if it says "cannot dereference null pointer at address 0x00000001",
  * it is most likely one of these :( */
 
 #define ID_IN_SYNC      (4711ULL)
@@ -1171,7 +1171,7 @@ extern int drbd_bitmap_io(struct drbd_conf *mdev, int (*io_fn)(struct drbd_conf
 /* Meta data layout
    We reserve a 128MB Block (4k aligned)
    * either at the end of the backing device
-   * or on a seperate meta data device. */
+   * or on a separate meta data device. */
 
 #define MD_RESERVED_SECT (128LU << 11)  /* 128 MB, unit sectors */
 /* The following numbers are sectors */
diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
index f22c1bc..16119d7 100644
--- a/drivers/block/drbd/drbd_req.h
+++ b/drivers/block/drbd/drbd_req.h
@@ -57,7 +57,7 @@
  *
  *  It may me handed over to the local disk subsystem.
  *  It may be completed by the local disk subsystem,
- *    either sucessfully or with io-error.
+ *    either successfully or with io-error.
  *  In case it is a READ request, and it failed locally,
  *    it may be retried remotely.
  *
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
 
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index fe2cb2f..a7424bf 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -14,7 +14,7 @@
 /* et passe en argument a acinit, mais est scrute sur le bus pour s'adapter  */
 /* au nombre de cartes presentes sur le bus. IOCL code 6 affichait V2.4.3    */
 /* F.LAFORSE 28/11/95 creation de fichiers acXX.o avec les differentes       */
-/* adresses de base des cartes, IOCTL 6 plus complet                         */
+/* addresses de base des cartes, IOCTL 6 plus complet                         */
 /* J.PAGET le 19/08/96 copie de la version V2.6 en V2.8.0 sans modification  */
 /* de code autre que le texte V2.6.1 en V2.8.0                               */
 /*****************************************************************************/
diff --git a/drivers/char/hvc_iseries.c b/drivers/char/hvc_iseries.c
index 936d05b..0794925 100644
--- a/drivers/char/hvc_iseries.c
+++ b/drivers/char/hvc_iseries.c
@@ -353,7 +353,7 @@ static void hvc_close_event(struct HvLpEvent *event)
 
 	if (!hvlpevent_is_int(event)) {
 		printk(KERN_WARNING
-			"hvc: got unexpected close acknowlegement\n");
+			"hvc: got unexpected close acknowledgement\n");
 		return;
 	}
 
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
diff --git a/drivers/char/ip2/i2hw.h b/drivers/char/ip2/i2hw.h
index 8aa6e7a..c0ba6c0 100644
--- a/drivers/char/ip2/i2hw.h
+++ b/drivers/char/ip2/i2hw.h
@@ -559,7 +559,7 @@ Loadware may be sent to the board in two ways:
 
 2) It may be hard-coded into your source by including a .h file (typically
 	supplied by Computone), which declares a data array and initializes every
-	element. This acheives the same result as if an entire loadware file had 
+	element. This achieves the same result as if an entire loadware file had 
 	been read into the array.
 
 	This requires more data space in your program, but access to the file system
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 385c44b..5ee4248 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -220,7 +220,7 @@ static void pty_set_termios(struct tty_struct *tty,
  *	@tty: tty being resized
  *	@ws: window size being set.
  *
- *	Update the termios variables and send the neccessary signals to
+ *	Update the termios variables and send the necessary signals to
  *	peform a terminal resize correctly
  */
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index c6f3b48..56b11c1 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2026,7 +2026,7 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
  *	@rows: rows (character)
  *	@cols: cols (character)
  *
- *	Update the termios variables and send the neccessary signals to
+ *	Update the termios variables and send the necessary signals to
  *	peform a terminal resize correctly
  */
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50faa1f..19e6673 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -821,7 +821,7 @@ static inline int resize_screen(struct vc_data *vc, int width, int height,
  *
  *	Resize a virtual console, clipping according to the actual constraints.
  *	If the caller passes a tty structure then update the termios winsize
- *	information and perform any neccessary signal handling.
+ *	information and perform any necessary signal handling.
  *
  *	Caller must hold the console semaphore. Takes the termios mutex and
  *	ctrl_lock of the tty IFF a tty is passed.
diff --git a/drivers/dma/coh901318_lli.h b/drivers/dma/coh901318_lli.h
index 7bf713b..7a5c809 100644
--- a/drivers/dma/coh901318_lli.h
+++ b/drivers/dma/coh901318_lli.h
@@ -30,7 +30,7 @@ struct device;
  * @pool: pool handle
  * @dev: dma device
  * @lli_nbr: number of lli:s in the pool
- * @algin: adress alignemtn of lli:s
+ * @algin: address alignemtn of lli:s
  * returns 0 on success otherwise none zero
  */
 int coh901318_pool_create(struct coh901318_pool *pool,
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
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 6b96904..2366405 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -544,7 +544,7 @@ struct drm_nouveau_private {
 	uint32_t ramro_offset;
 	uint32_t ramro_size;
 
-	/* base physical adresses */
+	/* base physical addresses */
 	uint64_t fb_phys;
 	uint64_t fb_available_size;
 	uint64_t fb_mappable_pages;
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index 5935b88..34079f2 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -150,7 +150,7 @@ irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
 		cur_irq++;
 	}
 
-	/* Acknowlege interrupts */
+	/* Acknowledge interrupts */
 	VIA_WRITE(VIA_REG_INTERRUPT, status);
 
 
@@ -165,7 +165,7 @@ static __inline__ void viadrv_acknowledge_irqs(drm_via_private_t * dev_priv)
 	u32 status;
 
 	if (dev_priv) {
-		/* Acknowlege interrupts */
+		/* Acknowledge interrupts */
 		status = VIA_READ(VIA_REG_INTERRUPT);
 		VIA_WRITE(VIA_REG_INTERRUPT, status |
 			  dev_priv->irq_pending_mask);
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
diff --git a/drivers/infiniband/hw/ehca/ehca_qes.h b/drivers/infiniband/hw/ehca/ehca_qes.h
index 5d28e3e..90c4efa 100644
--- a/drivers/infiniband/hw/ehca/ehca_qes.h
+++ b/drivers/infiniband/hw/ehca/ehca_qes.h
@@ -46,7 +46,7 @@
 
 #include "ehca_tools.h"
 
-/* virtual scatter gather entry to specify remote adresses with length */
+/* virtual scatter gather entry to specify remote addresses with length */
 struct ehca_vsgentry {
 	u64 vaddr;
 	u32 lkey;
@@ -148,7 +148,7 @@ struct ehca_wqe {
 	u32 immediate_data;
 	union {
 		struct {
-			u64 remote_virtual_adress;
+			u64 remote_virtual_address;
 			u32 rkey;
 			u32 reserved;
 			u64 atomic_1st_op_dma_len;
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index e3ec7fd..9a3fbfc 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -269,7 +269,7 @@ static inline int ehca_write_swqe(struct ehca_qp *qp,
 		/* no break is intentional here */
 	case IB_QPT_RC:
 		/* TODO: atomic not implemented */
-		wqe_p->u.nud.remote_virtual_adress =
+		wqe_p->u.nud.remote_virtual_address =
 			send_wr->wr.rdma.remote_addr;
 		wqe_p->u.nud.rkey = send_wr->wr.rdma.rkey;
 
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
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index adb1e8c..00c60e2 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1347,7 +1347,7 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 /*
  * isdn net devices manage lots of configuration variables as linked lists.
  * Those lists must only be manipulated from user space. Some of the ioctl's
- * service routines access user space and are not atomic. Therefor, ioctl's
+ * service routines access user space and are not atomic. Therefore, ioctl's
  * manipulating the lists and ioctl's sleeping while accessing the lists
  * are serialized by means of a semaphore.
  */
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
diff --git a/drivers/media/video/gspca/ov519.c b/drivers/media/video/gspca/ov519.c
index b4f9657..e5e4c44 100644
--- a/drivers/media/video/gspca/ov519.c
+++ b/drivers/media/video/gspca/ov519.c
@@ -503,7 +503,7 @@ static const struct v4l2_pix_format ovfx2_ov3610_mode[] = {
 /*
  * The FX2 chip does not give us a zero length read at end of frame.
  * It does, however, give a short read at the end of a frame, if
- * neccessary, rather than run two frames together.
+ * necessary, rather than run two frames together.
  *
  * By choosing the right bulk transfer size, we are guaranteed to always
  * get a short read for the last read of each frame.  Frame sizes are
diff --git a/drivers/media/video/pwc/philips.txt b/drivers/media/video/pwc/philips.txt
index f9f3584..d38dd79 100644
--- a/drivers/media/video/pwc/philips.txt
+++ b/drivers/media/video/pwc/philips.txt
@@ -33,7 +33,7 @@ a lot of extra information, a FAQ, and the binary plugin 'PWCX'. This plugin
 contains decompression routines that allow you to use higher image sizes and
 framerates; in addition the webcam uses less bandwidth on the USB bus (handy
 if you want to run more than 1 camera simultaneously). These routines fall
-under a NDA, and may therefor not be distributed as source; however, its use
+under a NDA, and may therefore not be distributed as source; however, its use
 is completely optional.
 
 You can build this code either into your kernel, or as a module. I recommend
diff --git a/drivers/media/video/sn9c102/sn9c102_sensor.h b/drivers/media/video/sn9c102/sn9c102_sensor.h
index 4af7382..494957b 100644
--- a/drivers/media/video/sn9c102/sn9c102_sensor.h
+++ b/drivers/media/video/sn9c102/sn9c102_sensor.h
@@ -120,7 +120,7 @@ extern int sn9c102_write_regs(struct sn9c102_device*, const u8 valreg[][2],
 /*
    Write multiple registers with constant values. For example:
    sn9c102_write_const_regs(cam, {0x00, 0x14}, {0x60, 0x17}, {0x0f, 0x18});
-   Register adresses must be < 256.
+   Register addresses must be < 256.
 */
 #define sn9c102_write_const_regs(sn9c102_device, data...)                     \
 	({ static const u8 _valreg[][2] = {data};                             \
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index 0446524..6bf6bc7 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -6,7 +6,7 @@
 
     The tea6420 is a bus controlled audio-matrix with 5 stereo inputs,
     4 stereo outputs and gain control for each output.
-    It is cascadable, i.e. it can be found at the adresses 0x98
+    It is cascadable, i.e. it can be found at the addresses 0x98
     and 0x9a on the i2c-bus.
 
     For detailed informations download the specifications directly
diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 0cc5eef..10491e4 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -523,7 +523,7 @@ unsigned long sm501_set_clock(struct device *dev,
 	unsigned long clock = readl(sm->regs + SM501_CURRENT_CLOCK);
 	unsigned char reg;
 	unsigned int pll_reg = 0;
-	unsigned long sm501_freq; /* the actual frequency acheived */
+	unsigned long sm501_freq; /* the actual frequency achieved */
 
 	struct sm501_clock to;
 
@@ -533,7 +533,7 @@ unsigned long sm501_set_clock(struct device *dev,
 
 	switch (clksrc) {
 	case SM501_CLOCK_P2XCLK:
-		/* This clock is divided in half so to achive the
+		/* This clock is divided in half so to achieve the
 		 * requested frequency the value must be multiplied by
 		 * 2. This clock also has an additional pre divisor */
 
@@ -562,7 +562,7 @@ unsigned long sm501_set_clock(struct device *dev,
 		break;
 
 	case SM501_CLOCK_V2XCLK:
-		/* This clock is divided in half so to achive the
+		/* This clock is divided in half so to achieve the
 		 * requested frequency the value must be multiplied by 2. */
 
 		sm501_freq = (sm501_select_clock(2 * req_freq, &to, 3) / 2);
@@ -648,7 +648,7 @@ unsigned long sm501_find_clock(struct device *dev,
 			       unsigned long req_freq)
 {
 	struct sm501_devdata *sm = dev_get_drvdata(dev);
-	unsigned long sm501_freq; /* the frequency achiveable by the 501 */
+	unsigned long sm501_freq; /* the frequency achieveable by the 501 */
 	struct sm501_clock to;
 
 	switch (clksrc) {
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
diff --git a/drivers/mtd/chips/jedec_probe.c b/drivers/mtd/chips/jedec_probe.c
index 1bec5e1..8db1148 100644
--- a/drivers/mtd/chips/jedec_probe.c
+++ b/drivers/mtd/chips/jedec_probe.c
@@ -226,7 +226,7 @@ struct unlock_addr {
  * exists, but is for MTD_UADDR_NOT_SUPPORTED - and, therefore,
  * should not be used.  The  problem is that structures with
  * initializers have extra fields initialized to 0.  It is _very_
- * desireable to have the unlock address entries for unsupported
+ * desirable to have the unlock address entries for unsupported
  * data widths automatically initialized - that means that
  * MTD_UADDR_NOT_SUPPORTED must be 0 and the first entry here
  * must go unused.
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index 087bcd7..7d1cca7 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -381,7 +381,7 @@ static int __devinit bcm_umi_nand_probe(struct platform_device *pdev)
 	if (!r)
 		return -ENXIO;
 
-	/* map physical adress */
+	/* map physical address */
 	bcm_umi_io_base = ioremap(r->start, r->end - r->start + 1);
 
 	if (!bcm_umi_io_base) {
@@ -525,7 +525,7 @@ static int bcm_umi_nand_remove(struct platform_device *pdev)
 	/* Release resources, unregister device */
 	nand_release(board_mtd);
 
-	/* unmap physical adress */
+	/* unmap physical address */
 	iounmap(bcm_umi_io_base);
 
 	/* Free the MTD device structure */
diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 45dec57..b2900d8 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -507,7 +507,7 @@ static void mxc_do_addr_cycle(struct mtd_info *mtd, int column, int page_addr)
 		 * MXC NANDFC can only perform full page+spare or
 		 * spare-only read/write.  When the upper layers
 		 * layers perform a read/write buf operation,
-		 * we will used the saved column adress to index into
+		 * we will used the saved column address to index into
 		 * the full page.
 		 */
 		send_addr(host, 0, page_addr == -1);
diff --git a/drivers/net/atlx/atl2.h b/drivers/net/atlx/atl2.h
index d918bbe..927e4de 100644
--- a/drivers/net/atlx/atl2.h
+++ b/drivers/net/atlx/atl2.h
@@ -442,7 +442,7 @@ struct atl2_hw {
 struct atl2_ring_header {
     /* pointer to the descriptor ring memory */
     void *desc;
-    /* physical adress of the descriptor ring */
+    /* physical address of the descriptor ring */
     dma_addr_t dma;
     /* length of descriptor ring in bytes */
     unsigned int size;
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
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index 02d67d0..dc4eb87 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1363,7 +1363,7 @@ static s32 e1000_setup_fiber_serdes_link_82571(struct e1000_hw *hw)
  *
  *  1) down
  *  2) autoneg_progress
- *  3) autoneg_complete (the link sucessfully autonegotiated)
+ *  3) autoneg_complete (the link successfully autonegotiated)
  *  4) forced_up (the link has been forced up, it did not autonegotiate)
  *
  **/
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 2fa9b36..3af0b1b 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -587,7 +587,7 @@ s32 e1000e_check_for_serdes_link(struct e1000_hw *hw)
 				if (!(rxcw & E1000_RXCW_IV)) {
 					mac->serdes_has_link = true;
 					e_dbg("SERDES: Link up - autoneg "
-					   "completed sucessfully.\n");
+					   "completed successfully.\n");
 				} else {
 					mac->serdes_has_link = false;
 					e_dbg("SERDES: Link down - invalid"
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
 
diff --git a/drivers/net/irda/sa1100_ir.c b/drivers/net/irda/sa1100_ir.c
index c412e80..1dcdce0 100644
--- a/drivers/net/irda/sa1100_ir.c
+++ b/drivers/net/irda/sa1100_ir.c
@@ -331,7 +331,7 @@ static int sa1100_irda_resume(struct platform_device *pdev)
 		 * If we missed a speed change, initialise at the new speed
 		 * directly.  It is debatable whether this is actually
 		 * required, but in the interests of continuing from where
-		 * we left off it is desireable.  The converse argument is
+		 * we left off it is desirable.  The converse argument is
 		 * that we should re-negotiate at 9600 baud again.
 		 */
 		if (si->newspeed) {
diff --git a/drivers/net/qlge/qlge_ethtool.c b/drivers/net/qlge/qlge_ethtool.c
index 058fa0a..b8d21ab 100644
--- a/drivers/net/qlge/qlge_ethtool.c
+++ b/drivers/net/qlge/qlge_ethtool.c
@@ -402,7 +402,7 @@ static int ql_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 		u32 wol = 0;
 		status = ql_mb_wol_mode(qdev, wol);
 		QPRINTK(qdev, DRV, ERR, "WOL %s (wol code 0x%x) on %s\n",
-			(status == 0) ? "cleared sucessfully" : "clear failed",
+			(status == 0) ? "cleared successfully" : "clear failed",
 			wol, qdev->ndev->name);
 	}
 
diff --git a/drivers/net/qlge/qlge_main.c b/drivers/net/qlge/qlge_main.c
index 894a7c8..a35845b 100644
--- a/drivers/net/qlge/qlge_main.c
+++ b/drivers/net/qlge/qlge_main.c
@@ -3517,7 +3517,7 @@ int ql_wol(struct ql_adapter *qdev)
 		wol |= MB_WOL_MODE_ON;
 		status = ql_mb_wol_mode(qdev, wol);
 		QPRINTK(qdev, DRV, ERR, "WOL %s (wol code 0x%x) on %s\n",
-			(status == 0) ? "Sucessfully set" : "Failed", wol,
+			(status == 0) ? "Successfully set" : "Failed", wol,
 			qdev->ndev->name);
 	}
 
diff --git a/drivers/net/sfc/regs.h b/drivers/net/sfc/regs.h
index 89d606f..18a3be4 100644
--- a/drivers/net/sfc/regs.h
+++ b/drivers/net/sfc/regs.h
@@ -95,7 +95,7 @@
 #define	FRF_AA_INT_ACK_KER_FIELD_LBN 0
 #define	FRF_AA_INT_ACK_KER_FIELD_WIDTH 32
 
-/* INT_ISR0_REG: Function 0 Interrupt Acknowlege Status register */
+/* INT_ISR0_REG: Function 0 Interrupt Acknowledge Status register */
 #define	FR_BZ_INT_ISR0 0x00000090
 #define	FRF_BZ_INT_ISR_REG_LBN 0
 #define	FRF_BZ_INT_ISR_REG_WIDTH 64
diff --git a/drivers/net/smsc9420.c b/drivers/net/smsc9420.c
index 12f0f5d..2ae1972 100644
--- a/drivers/net/smsc9420.c
+++ b/drivers/net/smsc9420.c
@@ -1348,7 +1348,7 @@ static int smsc9420_open(struct net_device *dev)
 
 	netif_carrier_off(dev);
 
-	/* disable, mask and acknowlege all interrupts */
+	/* disable, mask and acknowledge all interrupts */
 	spin_lock_irqsave(&pd->int_lock, flags);
 	int_cfg = smsc9420_reg_read(pd, INT_CFG) & (~INT_CFG_IRQ_EN_);
 	smsc9420_reg_write(pd, INT_CFG, int_cfg);
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 2185248..839b1f0 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -474,7 +474,7 @@ spider_net_prepare_rx_descr(struct spider_net_card *card,
  * spider_net_enable_rxchtails - sets RX dmac chain tail addresses
  * @card: card structure
  *
- * spider_net_enable_rxchtails sets the RX DMAC chain tail adresses in the
+ * spider_net_enable_rxchtails sets the RX DMAC chain tail addresses in the
  * chip by writing to the appropriate register. DMA is enabled in
  * spider_net_enable_rxdmac.
  */
@@ -1820,7 +1820,7 @@ spider_net_enable_card(struct spider_net_card *card)
 
 	spider_net_write_reg(card, SPIDER_NET_ECMODE, SPIDER_NET_ECMODE_VALUE);
 
-	/* set chain tail adress for RX chains and
+	/* set chain tail address for RX chains and
 	 * enable DMA */
 	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
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
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 80b404f..ed4e9c4 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1857,7 +1857,7 @@ static void bdx_tx_push_desc(struct bdx_priv *priv, void *data, int size)
  * @data - desc's data
  * @size - desc's size
  *
- * NOTE: this func does check for available space and, if neccessary, waits for
+ * NOTE: this func does check for available space and, if necessary, waits for
  *   NIC to read existing data before writing new one.
  */
 static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size)
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index e3c42f5..4e4c402 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -693,7 +693,7 @@ static netdev_tx_t tms380tr_hardware_send_packet(struct sk_buff *skb,
  * NOTE: This function should be used whenever the status of any TPL must be
  * modified by the driver, because the compiler may otherwise change the
  * order of instructions such that writing the TPL status may be executed at
- * an undesireable time. When this function is used, the status is always
+ * an undesirable time. When this function is used, the status is always
  * written when the function is called.
  */
 static void tms380tr_write_tpl_status(TPL *tpl, unsigned int Status)
@@ -2266,7 +2266,7 @@ static void tms380tr_rcv_status_irq(struct net_device *dev)
  * This function should be used whenever the status of any RPL must be
  * modified by the driver, because the compiler may otherwise change the
  * order of instructions such that writing the RPL status may be executed
- * at an undesireable time. When this function is used, the status is
+ * at an undesirable time. When this function is used, the status is
  * always written when the function is called.
  */
 static void tms380tr_write_rpl_status(RPL *rpl, unsigned int Status)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2834a01..e572ecc 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1365,7 +1365,7 @@ static int tun_chr_close(struct inode *inode, struct file *file)
 
 		__tun_detach(tun);
 
-		/* If desireable, unregister the netdevice. */
+		/* If desirable, unregister the netdevice. */
 		if (!(tun->flags & TUN_PERSIST)) {
 			rtnl_lock();
 			if (dev->reg_state == NETREG_REGISTERED)
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index eb8fe7e..8eec977 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -429,7 +429,7 @@ static void hw_add_addr_in_hash(struct ucc_geth_private *ugeth,
 	    ucc_fast_get_qe_cr_subblock(ugeth->ug_info->uf_info.ucc_num);
 
 	/* Ethernet frames are defined in Little Endian mode,
-	therefor to insert */
+	therefore to insert */
 	/* the address to the hash (Big Endian mode), we reverse the bytes.*/
 
 	set_mac_addr(&p_82xx_addr_filt->taddr.h, p_enet_addr);
diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index 64cdfeb..6c459f5 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -612,7 +612,7 @@ ssize_t i2400m_bm_cmd(struct i2400m *i2400m,
 		goto error_wait_for_ack;
 	}
 	rx_bytes = result;
-	/* verify the ack and read more if neccessary [result is the
+	/* verify the ack and read more if necessary [result is the
 	 * final amount of bytes we get in the ack]  */
 	result = __i2400m_bm_ack_verify(i2400m, opcode, ack, ack_size, flags);
 	if (result < 0)
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 04df9bb..820b128 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -627,7 +627,7 @@ enum i2400m_bm_cmd_flags {
  * @I2400M_BRI_NO_REBOOT: Do not reboot the device and proceed
  *     directly to wait for a reboot barker from the device.
  * @I2400M_BRI_MAC_REINIT: We need to reinitialize the boot
- *     rom after reading the MAC adress. This is quite a dirty hack,
+ *     rom after reading the MAC address. This is quite a dirty hack,
  *     if you ask me -- the device requires the bootrom to be
  *     intialized after reading the MAC address.
  */
diff --git a/drivers/net/wimax/i2400m/sdio.c b/drivers/net/wimax/i2400m/sdio.c
index 76a50ac..14f876b 100644
--- a/drivers/net/wimax/i2400m/sdio.c
+++ b/drivers/net/wimax/i2400m/sdio.c
@@ -304,7 +304,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, but won't be
  * disconnected from the bus (so no reenumeration will
- * happen). Firmware upload will be neccessary.
+ * happen). Firmware upload will be necessary.
  *
  * The device will send a reboot barker that will trigger the driver
  * to reinitialize the state via __i2400m_dev_reset_handle.
@@ -314,7 +314,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, disconnected from the
  * bus an a reenumeration will happen. Firmware upload will be
- * neccessary. Thus, we don't do any locking or struct
+ * necessary. Thus, we don't do any locking or struct
  * reinitialization, as we are going to be fully disconnected and
  * reenumerated.
  *
diff --git a/drivers/net/wimax/i2400m/usb.c b/drivers/net/wimax/i2400m/usb.c
index 98f4f8c..99f04c4 100644
--- a/drivers/net/wimax/i2400m/usb.c
+++ b/drivers/net/wimax/i2400m/usb.c
@@ -246,7 +246,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, but won't be
  * disconnected from the USB bus (so no reenumeration will
- * happen). Firmware upload will be neccessary.
+ * happen). Firmware upload will be necessary.
  *
  * The device will send a reboot barker in the notification endpoint
  * that will trigger the driver to reinitialize the state
@@ -257,7 +257,7 @@ error_kzalloc:
  *
  * The device will be fully reset internally, disconnected from the
  * USB bus an a reenumeration will happen. Firmware upload will be
- * neccessary. Thus, we don't do any locking or struct
+ * necessary. Thus, we don't do any locking or struct
  * reinitialization, as we are going to be fully disconnected and
  * reenumerated.
  *
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
diff --git a/drivers/net/wireless/iwmc3200wifi/lmac.h b/drivers/net/wireless/iwmc3200wifi/lmac.h
index a3a79b5..a855a99 100644
--- a/drivers/net/wireless/iwmc3200wifi/lmac.h
+++ b/drivers/net/wireless/iwmc3200wifi/lmac.h
@@ -262,7 +262,7 @@ struct iwm_ct_kill_cfg_cmd {
 
 /* Power Management */
 #define POWER_TABLE_CMD			0x77
-#define SAVE_RESTORE_ADRESS_CMD		0x78
+#define SAVE_RESTORE_ADDRESS_CMD		0x78
 #define REPLY_WATERMARK_CMD		0x79
 #define PM_DEBUG_STATISTIC_NOTIFIC	0x7B
 #define PD_FLUSH_N_NOTIFICATION		0x7C
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
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 62ddf52..2a4c566 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -373,7 +373,7 @@ raw3270_irq (struct ccw_device *cdev, unsigned long intparm, struct irb *irb)
 		rq->rc = ccw_device_start(rp->cdev, &rq->ccw,
 					  (unsigned long) rq, 0, 0);
 		if (rq->rc == 0)
-			return;	/* Sucessfully restarted. */
+			return;	/* Successfully restarted. */
 		break;
 	case RAW3270_IO_STOP:
 		if (!rq)
diff --git a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
index ec88c59..f6d72e1 100644
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -196,7 +196,7 @@ __sclp_start_request(struct sclp_req *req)
 	req->start_count++;
 
 	if (rc == 0) {
-		/* Sucessfully started request */
+		/* Successfully started request */
 		req->status = SCLP_REQ_RUNNING;
 		sclp_running_state = sclp_running_state_running;
 		__sclp_set_request_timer(SCLP_RETRY_INTERVAL * HZ,
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 208d6df..ff5716d 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -492,7 +492,7 @@ static void init_alloc_map(struct orc_host * host)
  *	init_orchid		-	initialise the host adapter
  *	@host:host adapter to initialise
  *
- *	Initialise the controller and if neccessary load the firmware.
+ *	Initialise the controller and if necessary load the firmware.
  *
  *	Returns -1 if the initialisation fails.
  */
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 89a5948..a771416 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -531,7 +531,7 @@ static void initio_read_eeprom(unsigned long base)
  *	initio_stop_bm		-	stop bus master
  *	@host: InitIO we are stopping
  *
- *	Stop any pending DMA operation, aborting the DMA if neccessary
+ *	Stop any pending DMA operation, aborting the DMA if necessary
  */
 
 static void initio_stop_bm(struct initio_host * host)
diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 881d5df..69e3f34 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -48,7 +48,7 @@ struct kmem_cache *scsi_pkt_cachep;
 #define FC_SRB_CMD_SENT		(1 << 0)	/* cmd has been sent */
 #define FC_SRB_RCV_STATUS	(1 << 1)	/* response has arrived */
 #define FC_SRB_ABORT_PENDING	(1 << 2)	/* cmd abort sent to device */
-#define FC_SRB_ABORTED		(1 << 3)	/* abort acknowleged */
+#define FC_SRB_ABORTED		(1 << 3)	/* abort acknowledged */
 #define FC_SRB_DISCONTIG	(1 << 4)	/* non-sequential data recvd */
 #define FC_SRB_COMPL		(1 << 5)	/* fc_io_compl has been run */
 #define FC_SRB_FCP_PROCESSING_TMO (1 << 6)	/* timer function processing */
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 2cc3968..c898f47 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -969,7 +969,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
  * function returns, it does not guarantee all the IOCBs are actually aborted.
  *
  * Return code
- *   0 - Sucessfully issued abort iocb on all outstanding flogis (Always 0)
+ *   0 - Successfully issued abort iocb on all outstanding flogis (Always 0)
  **/
 int
 lpfc_els_abort_flogi(struct lpfc_hba *phba)
@@ -3117,7 +3117,7 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
 	    (*((uint32_t *) (pcmd)) == ELS_CMD_LS_RJT)) {
 		/* A LS_RJT associated with Default RPI cleanup has its own
-		 * seperate code path.
+		 * separate code path.
 		 */
 		if (!(ndlp->nlp_flag & NLP_RM_DFLT_RPI))
 			ls_rjt = 1;
diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 7db28cd..8c61a4f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -187,7 +187,7 @@
 #define S_IO		BIT(1)    /* Input/Output line from SCSI bus */
 #define S_CD		BIT(2)    /* Command/Data line from SCSI bus */
 #define S_BUSY		BIT(3)    /* Busy line from SCSI bus         */
-#define S_ACK		BIT(4)    /* Acknowlege line from SCSI bus   */
+#define S_ACK		BIT(4)    /* Acknowledge line from SCSI bus  */
 #define S_REQUEST	BIT(5)    /* Request line from SCSI bus      */
 #define S_SELECT	BIT(6)	  /*                                 */
 #define S_ATN		BIT(7)	  /*                                 */
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 9b44c6f..7985ae4 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2924,7 +2924,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	default:
 		PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk("unkown device type(%x)\n", deviceType));
+			pm8001_printk("unknown device type(%x)\n", deviceType));
 		break;
 	}
 	phy->phy_type |= PORT_TYPE_SAS;
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 7f9c83a..3b2c98f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -600,7 +600,7 @@ static void pm8001_free_dev(struct pm8001_device *pm8001_dev)
   * by the command "OPC_INB_REG_DEV", after that the HBA will assign a
   * device ID(according to device's sas address) and returned it to LLDD. From
   * now on, we communicate with HBA FW with the device ID which HBA assigned
-  * rather than sas address. it is the neccessary step for our HBA but it is
+  * rather than sas address. it is the necessary step for our HBA but it is
   * the optional for other HBA driver.
   */
 static int pm8001_dev_found_notify(struct domain_device *dev)
diff --git a/drivers/scsi/pmcraid.h b/drivers/scsi/pmcraid.h
index 92f89d5..b8ad07c 100644
--- a/drivers/scsi/pmcraid.h
+++ b/drivers/scsi/pmcraid.h
@@ -938,7 +938,7 @@ static struct pmcraid_ioasc_error pmcraid_ioasc_error_table[] = {
 
 /*
  * pmcraid_ioctl_header - definition of header structure that preceeds all the
- * buffers given as ioctl arguements.
+ * buffers given as ioctl arguments.
  *
  * .signature           : always ASCII string, "PMCRAID"
  * .reserved            : not used
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 255da53..5d94772 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2105,7 +2105,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
  *	which is followed by sdaaa.
  *
  *	This is basically 26 base counting with one extra 'nil' entry
- *	at the beggining from the second digit on and can be
+ *	at the beginning from the second digit on and can be
  *	determined using similar method as 26 base conversion with the
  *	index shifted -1 after each digit is computed.
  *
diff --git a/drivers/spi/spi_s3c24xx.c b/drivers/spi/spi_s3c24xx.c
index c010733..1fabede 100644
--- a/drivers/spi/spi_s3c24xx.c
+++ b/drivers/spi/spi_s3c24xx.c
@@ -275,7 +275,7 @@ static inline u32 ack_bit(unsigned int irq)
  * Claim the FIQ handler (only one can be active at any one time) and
  * then setup the correct transfer code for this transfer.
  *
- * This call updates all the necessary state information if sucessful,
+ * This call updates all the necessary state information if successful,
  * so the caller does not need to do anything more than start the transfer
  * as normal, since the IRQ will have been re-routed to the FIQ handler.
 */
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
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index a591ebe..52a81a3 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -154,7 +154,7 @@ struct cypress_private {
 	int isthrottled;		   /* if throttled, discard reads */
 	wait_queue_head_t delta_msr_wait;  /* used for TIOCMIWAIT */
 	char prev_status, diff_status;	   /* used for TIOCMIWAIT */
-	/* we pass a pointer to this as the arguement sent to
+	/* we pass a pointer to this as the argument sent to
 	   cypress_set_termios old_termios */
 	struct ktermios tmp_termios; 	   /* stores the old termios settings */
 };
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
diff --git a/drivers/video/s1d13xxxfb.c b/drivers/video/s1d13xxxfb.c
index 0deb0a8..7b63429 100644
--- a/drivers/video/s1d13xxxfb.c
+++ b/drivers/video/s1d13xxxfb.c
@@ -517,12 +517,12 @@ s1d13xxxfb_bitblt_copyarea(struct fb_info *info, const struct fb_copyarea *area)
 		src = (sy * stride) + (bpp * sx);
 	}
 
-	/* set source adress */
+	/* set source address */
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START0, (src & 0xff));
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START1, (src >> 8) & 0x00ff);
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_SRC_START2, (src >> 16) & 0x00ff);
 
-	/* set destination adress */
+	/* set destination address */
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START0, (dst & 0xff));
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START1, (dst >> 8) & 0x00ff);
 	s1d13xxxfb_writereg(info->par, S1DREG_BBLT_DST_START2, (dst >> 16) & 0x00ff);
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 35370d0..b7dc180 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -411,7 +411,7 @@ static int sm501fb_set_par_common(struct fb_info *info,
 	struct sm501fb_par  *par = info->par;
 	struct sm501fb_info *fbi = par->info;
 	unsigned long pixclock;      /* pixelclock in Hz */
-	unsigned long sm501pixclock; /* pixelclock the 501 can achive in Hz */
+	unsigned long sm501pixclock; /* pixelclock the 501 can achieve in Hz */
 	unsigned int mem_type;
 	unsigned int clock_type;
 	unsigned int head_addr;
diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
index dc5ef14..8306d53 100644
--- a/fs/affs/bitmap.c
+++ b/fs/affs/bitmap.c
@@ -128,7 +128,7 @@ err_range:
 /*
  * Allocate a block in the given allocation zone.
  * Since we have to byte-swap the bitmap on little-endian
- * machines, this is rather expensive. Therefor we will
+ * machines, this is rather expensive. Therefore we will
  * preallocate up to 16 blocks from the same word, if
  * possible. We are not doing preallocations in the
  * header zone, though.
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
diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
index b44ce0a..b1d61d0 100644
--- a/fs/cifs/cifs_dfs_ref.c
+++ b/fs/cifs/cifs_dfs_ref.c
@@ -54,7 +54,7 @@ void cifs_dfs_release_automount_timer(void)
  * Extracts sharename form full UNC.
  * i.e. strips from UNC trailing path that is not part of share
  * name and fixup missing '\' in the begining of DFS node refferal
- * if neccessary.
+ * if necessary.
  * Returns pointer to share name on success or ERR_PTR on error.
  * Caller is responsible for freeing returned string.
  */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 941441d..0e22440 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3886,7 +3886,7 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS_REFER_RSP *pSMBr,
 		goto parse_DFS_referrals_exit;
 	}
 
-	/* collect neccessary data from referrals */
+	/* collect necessary data from referrals */
 	for (i = 0; i < *num_of_nodes; i++) {
 		char *temp;
 		int max_len;
diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 82c415b..12a9ec7 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -928,7 +928,7 @@ out2:
 }
 
 /**
- * mext_check_argumants - Check whether move extent can be done
+ * mext_check_arguments - Check whether move extent can be done
  *
  * @orig_inode:		original inode
  * @donor_inode:	donor inode
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1a822ce..ec14d19 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -850,7 +850,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->in.args[0].size = sizeof(*arg);
 	req->in.args[0].value = arg;
 	req->out.numargs = 1;
-	/* Variable length arguement used for backward compatibility
+	/* Variable length argument used for backward compatibility
 	   with interface version < 7.5.  Rest of init_out is zeroed
 	   by do_get_request(), so a short reply is not a problem */
 	req->out.argvar = 1;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index edfee24..0556f7f 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -992,7 +992,7 @@ static const struct lm_lockops nolock_ops = {
 /**
  * gfs2_lm_mount - mount a locking protocol
  * @sdp: the filesystem
- * @args: mount arguements
+ * @args: mount arguments
  * @silent: if 1, don't complain if the FS isn't a GFS2 fs
  *
  * Returns: errno
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 006f9ad..57ae203 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1398,7 +1398,7 @@ int journal_stop(handle_t *handle)
 	 * the case where our storage is so fast that it is more optimal to go
 	 * ahead and force a flush and wait for the transaction to be committed
 	 * than it is to wait for an arbitrary amount of time for new writers to
-	 * join the transaction.  We acheive this by measuring how long it takes
+	 * join the transaction.  We achieve this by measuring how long it takes
 	 * to commit a transaction, and compare it with how long this
 	 * transaction has been running, and if run time < commit time then we
 	 * sleep for the delta and commit.  This greatly helps super fast disks
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
diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 65c8727..ecc04b5 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -169,7 +169,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 			return 0;	// No free blocks in this bitmap
 		}
 
-		/* search for a first zero bit -- beggining of a window */
+		/* search for a first zero bit -- beginning of a window */
 		*beg = reiserfs_find_next_zero_le_bit
 		    ((unsigned long *)(bh->b_data), boundary, *beg);
 
diff --git a/include/linux/hil.h b/include/linux/hil.h
index 13352d7..523785a 100644
--- a/include/linux/hil.h
+++ b/include/linux/hil.h
@@ -168,14 +168,14 @@ enum hil_command {
 	HIL_CMD_PR6	= 0x45,	/* Prompt6 */
 	HIL_CMD_PR7	= 0x46,	/* Prompt7 */
 	HIL_CMD_PRM	= 0x47,	/* Prompt (General Purpose) */
-	HIL_CMD_AK1	= 0x48,	/* Acknowlege1 */  
-	HIL_CMD_AK2	= 0x49,	/* Acknowlege2 */
-	HIL_CMD_AK3	= 0x4a,	/* Acknowlege3 */
-	HIL_CMD_AK4	= 0x4b,	/* Acknowlege4 */
-	HIL_CMD_AK5	= 0x4c,	/* Acknowlege5 */
-	HIL_CMD_AK6	= 0x4d,	/* Acknowlege6 */
-	HIL_CMD_AK7	= 0x4e,	/* Acknowlege7 */
-	HIL_CMD_ACK	= 0x4f,	/* Acknowlege (General Purpose) */
+	HIL_CMD_AK1	= 0x48,	/* Acknowledge1 */  
+	HIL_CMD_AK2	= 0x49,	/* Acknowledge2 */
+	HIL_CMD_AK3	= 0x4a,	/* Acknowledge3 */
+	HIL_CMD_AK4	= 0x4b,	/* Acknowledge4 */
+	HIL_CMD_AK5	= 0x4c,	/* Acknowledge5 */
+	HIL_CMD_AK6	= 0x4d,	/* Acknowledge6 */
+	HIL_CMD_AK7	= 0x4e,	/* Acknowledge7 */
+	HIL_CMD_ACK	= 0x4f,	/* Acknowledge (General Purpose) */
 
 	/* 0x50 to 0x78 reserved for future use  */
 	/* 0x80 to 0xEF device-specific commands */
diff --git a/include/linux/lru_cache.h b/include/linux/lru_cache.h
index 3a2b2d9..de48d16 100644
--- a/include/linux/lru_cache.h
+++ b/include/linux/lru_cache.h
@@ -64,7 +64,7 @@ For crash recovery after replication node failure,
   usually the condition is softened to regions that _may_ have been target of
   in-flight WRITE IO, e.g. by only lazily clearing the on-disk write-intent
   bitmap, trading frequency of meta data transactions against amount of
-  (possibly unneccessary) resync traffic.
+  (possibly unnecessary) resync traffic.
 
   If we set a hard limit on the area that may be "hot" at any given time, we
   limit the amount of resync traffic needed for crash recovery.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index abdfacc..a70957b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1533,7 +1533,7 @@ struct task_struct {
 
 	struct list_head	*scm_work_list;
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	/* Index of current stored adress in ret_stack */
+	/* Index of current stored address in ret_stack */
 	int curr_ret_stack;
 	/* Stack of return addresses for return function tracing */
 	struct ftrace_ret_stack	*ret_stack;
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
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 8816a20..aff48d6 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -133,7 +133,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 }
 
 /* This function calculates a "timeout" which is equivalent to the timeout of a
- * TCP connection after "boundary" unsucessful, exponentially backed-off
+ * TCP connection after "boundary" unsuccessful, exponentially backed-off
  * retransmissions with an initial RTO of TCP_RTO_MIN.
  */
 static bool retransmits_timed_out(struct sock *sk,
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 0f7c6e6..54e4c8b 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -743,7 +743,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		break;
 	default:
 		/* should not get here, PLINK_BLOCKED is dealt with at the
-		 * beggining of the function
+		 * beginning of the function
 		 */
 		spin_unlock_bh(&sta->lock);
 		break;
diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 023966b..fbe94ad 100644
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
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 4e4ca65..500886b 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -475,7 +475,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 	 * used to provide an upper bound to this doubling operation.
 	 *
 	 * Special Case:  the first HB doesn't trigger exponential backoff.
-	 * The first unacknowleged HB triggers it.  We do this with a flag
+	 * The first unacknowledged HB triggers it.  We do this with a flag
 	 * that indicates that we have an outstanding HB.
 	 */
 	if (!is_hb || transport->hb_sent) {
diff --git a/scripts/gfp-translate b/scripts/gfp-translate
index 073cb6d..d81b968 100644
--- a/scripts/gfp-translate
+++ b/scripts/gfp-translate
@@ -19,7 +19,7 @@ usage() {
 	exit 0
 }
 
-# Parse command-line arguements
+# Parse command-line arguments
 while [ $# -gt 0 ]; do
 	case $1 in
 		--source)
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index a11f453..39cc3d2 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -180,7 +180,7 @@ MODULE_PARM_DESC(joystick, "Enable joystick.");
 
 #define ESS_DISABLE_AUDIO	0x8000
 #define ESS_ENABLE_SERIAL_IRQ	0x4000
-#define IO_ADRESS_ALIAS		0x0020
+#define IO_ADDRESS_ALIAS		0x0020
 #define MPU401_IRQ_ENABLE	0x0010
 #define MPU401_IO_ENABLE	0x0008
 #define GAME_IO_ENABLE		0x0004
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
diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index 341481e..427614a 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -990,7 +990,7 @@ static int wm8990_set_dai_pll(struct snd_soc_dai *codec_dai, int pll_id,
 		reg = snd_soc_read(codec, WM8990_CLOCKING_2);
 		snd_soc_write(codec, WM8990_CLOCKING_2, reg | WM8990_SYSCLK_SRC);
 
-		/* set up N , fractional mode and pre-divisor if neccessary */
+		/* set up N , fractional mode and pre-divisor if necessary */
 		snd_soc_write(codec, WM8990_PLL1, pll_div.n | WM8990_SDM |
 			(pll_div.div2?WM8990_PRESCALE:0));
 		snd_soc_write(codec, WM8990_PLL2, (u8)(pll_div.k>>8));
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

