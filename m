Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYHVQEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYHVQEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbYHVQEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:04:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:43009 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbYHVQEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=xBTRsBLGeTnJUEN0KGZJ+lNe0vGsJsCAhM0/mUmICEL1JfxUWUxg6LHb0I8FK3CKKQ
         d/tYQhrWFBB0+WHSMzmS9SfVdiRjwAHjr3abCsYXjImlbxwFwoA67VLW0H3ARYkXGYVN
         z8igVQXjRohaSIobSRux7WsehLK2xPJQS6BZo=
Date: Fri, 22 Aug 2008 17:02:22 +0100
From: WANG Cong <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org
Subject: [Patch] Trivial: fix "*er then" typos
Message-ID: <20080822160222.GF3053@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Obviously, these "*er then" should be "*er than".

Signed-off-by: WANG Cong <wangcong@zeuux.org>
Cc: trivial@kernel.org

---
diff --git a/Documentation/crypto/descore-readme.txt b/Documentation/crypto/descore-readme.txt
index 16e9e63..067499e 100644
--- a/Documentation/crypto/descore-readme.txt
+++ b/Documentation/crypto/descore-readme.txt
@@ -323,7 +323,7 @@ Des{Small|Quick}{Fips|Core}{Encrypt|Decrypt}(d, m, s)
 	Fips slows down Quick by 10%, Small by 9%.
 	Small|Quick determines whether you use the normal routine
 	or the crazy quick one which gobbles up 64k more of memory.
-	Small is 50% slower then Quick, but Quick needs 32 times as much
+	Small is 50% slower than Quick, but Quick needs 32 times as much
 	memory.  Quick is included for programs that do nothing but DES,
 	e.g., encryption filters, etc.
 
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index eb1a47b..73291f7 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -41,7 +41,7 @@ Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
 What:	old tuner-3036 i2c driver
 When:	2.6.28
 Why:	This driver is for VERY old i2c-over-parallel port teletext receiver
-	boxes. Rather then spending effort on converting this driver to V4L2,
+	boxes. Rather than spending effort on converting this driver to V4L2,
 	and since it is extremely unlikely that anyone still uses one of these
 	devices, it was decided to drop it.
 Who:	Hans Verkuil <hverkuil@xs4all.nl>
diff --git a/Documentation/hwmon/lm75 b/Documentation/hwmon/lm75
index 8e6356f..7e29255 100644
--- a/Documentation/hwmon/lm75
+++ b/Documentation/hwmon/lm75
@@ -37,7 +37,7 @@ The LM75 implements one temperature sensor. Limits can be set through the
 Overtemperature Shutdown register and Hysteresis register. Each value can be
 set and read to half-degree accuracy.
 An alarm is issued (usually to a connected LM78) when the temperature
-gets higher then the Overtemperature Shutdown value; it stays on until
+gets higher than the Overtemperature Shutdown value; it stays on until
 the temperature falls below the Hysteresis value.
 All temperatures are in degrees Celsius, and are guaranteed within a
 range of -55 to +125 degrees.
diff --git a/Documentation/hwmon/thmc50 b/Documentation/hwmon/thmc50
index 9639ca9..c87bb87 100644
--- a/Documentation/hwmon/thmc50
+++ b/Documentation/hwmon/thmc50
@@ -36,7 +36,7 @@ many processors), and a controllable fan/analog_out DAC. For the temperature
 sensors, limits can be set through the appropriate Overtemperature Shutdown
 register and Hysteresis register. Each value can be set and read to half-degree
 accuracy.  An alarm is issued (usually to a connected LM78) when the
-temperature gets higher then the Overtemperature Shutdown value; it stays on
+temperature gets higher than the Overtemperature Shutdown value; it stays on
 until the temperature falls below the Hysteresis value. All temperatures are in
 degrees Celsius, and are guaranteed within a range of -55 to +125 degrees.
 
diff --git a/Documentation/hwmon/w83781d b/Documentation/hwmon/w83781d
index 6f800a0..f2acba0 100644
--- a/Documentation/hwmon/w83781d
+++ b/Documentation/hwmon/w83781d
@@ -82,7 +82,7 @@ is above the Overtemperature Shutdown value. The driver sets the
 hysteresis value for temp1 to 127 at initialization.
 
 For the other temperature sensor(s), an alarm is triggered when the
-temperature gets higher then the Overtemperature Shutdown value; it stays
+temperature gets higher than the Overtemperature Shutdown value; it stays
 on until the temperature falls below the Hysteresis value. But on the
 W83781D, there is only one alarm that functions for both other sensors!
 Temperatures are guaranteed within a range of -55 to +125 degrees. The
diff --git a/Documentation/networking/rxrpc.txt b/Documentation/networking/rxrpc.txt
index c3669a3..60d05eb 100644
--- a/Documentation/networking/rxrpc.txt
+++ b/Documentation/networking/rxrpc.txt
@@ -540,7 +540,7 @@ A client would issue an operation by:
      MSG_MORE should be set in msghdr::msg_flags on all but the last part of
      the request.  Multiple requests may be made simultaneously.
 
-     If a call is intended to go to a destination other then the default
+     If a call is intended to go to a destination other than the default
      specified through connect(), then msghdr::msg_name should be set on the
      first request message of that call.
 
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4b8acd2..62755d3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -752,7 +752,7 @@ config LOCAL_TIMERS
 	depends on SMP && (REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP)
 	default y
 	help
-	  Enable support for local timers on SMP platforms, rather then the
+	  Enable support for local timers on SMP platforms, rather than the
 	  legacy IPI broadcast method.  Local timers allows the system
 	  accounting to be spread across the timer interval, preventing a
 	  "thundering herd" at every timer tick.
diff --git a/arch/blackfin/kernel/kgdb.c b/arch/blackfin/kernel/kgdb.c
index a1f9641..f003bd5 100644
--- a/arch/blackfin/kernel/kgdb.c
+++ b/arch/blackfin/kernel/kgdb.c
@@ -123,7 +123,7 @@ void regs_to_gdb_regs(unsigned long *gdb_regs, struct pt_regs *regs)
  * Extracts ebp, esp and eip values understandable by gdb from the values
  * saved by switch_to.
  * thread.esp points to ebp. flags and ebp are pushed in switch_to hence esp
- * prior to entering switch_to is 8 greater then the value that is saved.
+ * prior to entering switch_to is 8 greater than the value that is saved.
  * If switch_to changes, change following code appropriately.
  */
 void sleeping_thread_to_gdb_regs(unsigned long *gdb_regs, struct task_struct *p)
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 5ff4de3..4dbe1fc 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -805,7 +805,7 @@ static int calculate_lfsr(int n)
 {
 	/*
 	 * The ranges and steps are in powers of 2 so the calculations
-	 * can be done using shifts rather then divide.
+	 * can be done using shifts rather than divide.
 	 */
 	int index;
 
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 8d41908..2ff2b08 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -280,8 +280,8 @@ config WARN_STACK
 	help
 	  This option enables the compiler options -mwarn-framesize and
 	  -mwarn-dynamicstack. If the compiler supports these options it
-	  will generate warnings for function which either use alloca or
-	  create a stack frame bigger then CONFIG_WARN_STACK_SIZE.
+	  will generate warnings for functions which either use alloca or
+	  create a stack frame bigger than CONFIG_WARN_STACK_SIZE.
 
 	  Say N if you are unsure.
 
diff --git a/arch/x86/kernel/mfgpt_32.c b/arch/x86/kernel/mfgpt_32.c
index 3b59951..299f878 100644
--- a/arch/x86/kernel/mfgpt_32.c
+++ b/arch/x86/kernel/mfgpt_32.c
@@ -252,7 +252,7 @@ EXPORT_SYMBOL_GPL(geode_mfgpt_alloc_timer);
 /*
  * The MFPGT timers on the CS5536 provide us with suitable timers to use
  * as clock event sources - not as good as a HPET or APIC, but certainly
- * better then the PIT.  This isn't a general purpose MFGPT driver, but
+ * better than the PIT.  This isn't a general purpose MFGPT driver, but
  * a simplified one designed specifically to act as a clock event source.
  * For full details about the MFGPT, please consult the CS5536 data sheet.
  */
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1bce84b..83e8abe 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -130,7 +130,7 @@ enum {
  * (5 min), we switch it to a lower frequency - IDETAPE_DSC_MA_SLOW (1 min).
  *
  * We also set a timeout for the timer, in case something goes wrong. The
- * timeout should be longer then the maximum execution time of a tape operation.
+ * timeout should be longer than the maximum execution time of a tape operation.
  */
 
 /* DSC timings. */
diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index d0866a3..c1ce896 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -364,7 +364,7 @@ int mlx4_ib_resize_cq(struct ib_cq *ibcq, int entries, struct ib_udata *udata)
 		if (err)
 			goto out;
 	} else {
-		/* Can't be smaller then the number of outstanding CQEs */
+		/* Can't be smaller than the number of outstanding CQEs */
 		outst_cqe = mlx4_ib_get_outstanding_cqes(cq);
 		if (entries < outst_cqe + 1) {
 			err = 0;
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index b9453d0..359ff82 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -215,7 +215,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
  * the original due to possible compaction).
  *
  * we build a "page vec" under the assumption that the SG meets the RDMA
- * alignment requirements. Other then the first and last SG elements, all
+ * alignment requirements. Other than the first and last SG elements, all
  * the "internal" elements can be compacted into a list whose elements are
  * dma addresses of physical pages. The code supports also the weird case
  * where --few fragments of the same page-- are present in the SG as
diff --git a/drivers/media/video/usbvideo/ibmcam.c b/drivers/media/video/usbvideo/ibmcam.c
index 59166b7..caf4306 100644
--- a/drivers/media/video/usbvideo/ibmcam.c
+++ b/drivers/media/video/usbvideo/ibmcam.c
@@ -488,7 +488,7 @@ static enum ParseState ibmcam_parse_lines(
 	 * Now we are sure that entire line (representing all 'scanLength'
 	 * pixels from the camera) is available in the buffer. We
 	 * start copying the line left-aligned to the V4L buffer.
-	 * If the camera line is shorter then we should pad the V4L
+	 * If the camera line is shorter than we should pad the V4L
 	 * buffer with something (black) to complete the line.
 	 */
 	assert(frame->data != NULL);
@@ -703,7 +703,7 @@ static enum ParseState ibmcam_model2_320x240_parse_lines(
 	 * pixels from the camera) is available in the scratch buffer. We
 	 * start copying the line left-aligned to the V4L buffer (which
 	 * might be larger - not smaller, hopefully). If the camera
-	 * line is shorter then we should pad the V4L buffer with something
+	 * line is shorter than we should pad the V4L buffer with something
 	 * (black in this case) to complete the line.
 	 */
 	f = frame->data + (v4l_linesize * frame->curline);
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 1bcdbbb..3d45817 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -390,7 +390,7 @@ static int i2o_scsi_reply(struct i2o_controller *c, u32 m,
  *	@i2o_dev: the I2O device which was added
  *
  *	If a I2O device is added we catch the notification, because I2O classes
- *	other then SCSI peripheral will not be received through
+ *	other than SCSI peripheral will not be received through
  *	i2o_scsi_probe().
  */
 static void i2o_scsi_notify_device_add(struct i2o_device *i2o_dev)
diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index d38bca6..d2fd550 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -34,7 +34,7 @@
  *	aperture size, not the dram size, and the V370PDC supplies no
  *	other method for memory size discovery.  This problem is
  *	mostly only relevant when compiled as a module, as the
- *	unloading of the module with an aperture size smaller then
+ *	unloading of the module with an aperture size smaller than
  *	the ram will cause the driver to detect the onboard memory
  *	size to be equal to the aperture size when the module is
  *	reloaded.  Soooo, to help, the module supports an msize
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 2fb64be..e577dc3 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -65,7 +65,7 @@
  *
  * A: because when writing a sub-page, MTD still writes a full 2K page but the
  * bytes which are no relevant to the sub-page are 0xFF. So, basically, writing
- * 4x512 sub-pages is 4 times slower then writing one 2KiB NAND page. Thus, we
+ * 4x512 sub-pages is 4 times slower than writing one 2KiB NAND page. Thus, we
  * prefer to use sub-pages only for EV and VID headers.
  *
  * As it was noted above, the VID header may start at a non-aligned offset.
diff --git a/drivers/mtd/ubi/kapi.c b/drivers/mtd/ubi/kapi.c
index 5d9bcf1..16bb71b 100644
--- a/drivers/mtd/ubi/kapi.c
+++ b/drivers/mtd/ubi/kapi.c
@@ -425,7 +425,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_write);
  *
  * This function changes the contents of a logical eraseblock atomically. @buf
  * has to contain new logical eraseblock data, and @len - the length of the
- * data, which has to be aligned. The length may be shorter then the logical
+ * data, which has to be aligned. The length may be shorter than the logical
  * eraseblock size, ant the logical eraseblock may be appended to more times
  * later on. This function guarantees that in case of an unclean reboot the old
  * contents is preserved. Returns zero in case of success and a negative error
@@ -508,7 +508,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_erase);
  *
  * This function un-maps logical eraseblock @lnum and schedules the
  * corresponding physical eraseblock for erasure, so that it will eventually be
- * physically erased in background. This operation is much faster then the
+ * physically erased in background. This operation is much faster than the
  * erase operation.
  *
  * Unlike erase, the un-map operation does not guarantee that the logical
@@ -527,7 +527,7 @@ EXPORT_SYMBOL_GPL(ubi_leb_erase);
  *
  * The main and obvious use-case of this function is when the contents of a
  * logical eraseblock has to be re-written. Then it is much more efficient to
- * first un-map it, then write new data, rather then first erase it, then write
+ * first un-map it, then write new data, rather than first erase it, then write
  * new data. Note, once new data has been written to the logical eraseblock,
  * UBI guarantees that the old contents has gone forever. In other words, if an
  * unclean reboot happens after the logical eraseblock has been un-mapped and
diff --git a/drivers/mtd/ubi/scan.c b/drivers/mtd/ubi/scan.c
index 967bb44..e98769e 100644
--- a/drivers/mtd/ubi/scan.c
+++ b/drivers/mtd/ubi/scan.c
@@ -229,7 +229,7 @@ static struct ubi_scan_volume *add_volume(struct ubi_scan_info *si, int vol_id,
  * case of success this function returns a positive value, in case of failure, a
  * negative error code is returned. The success return codes use the following
  * bits:
- *     o bit 0 is cleared: the first PEB (described by @seb) is newer then the
+ *     o bit 0 is cleared: the first PEB (described by @seb) is newer than the
  *       second PEB (described by @pnum and @vid_hdr);
  *     o bit 0 is set: the second PEB is newer;
  *     o bit 1 is cleared: no bit-flips were detected in the newer LEB;
@@ -450,7 +450,7 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,
 
 		if (cmp_res & 1) {
 			/*
-			 * This logical eraseblock is newer then the one
+			 * This logical eraseblock is newer than the one
 			 * found earlier.
 			 */
 			err = validate_vid_hdr(vid_hdr, sv, pnum);
@@ -478,7 +478,7 @@ int ubi_scan_add_used(struct ubi_device *ubi, struct ubi_scan_info *si,
 			return 0;
 		} else {
 			/*
-			 * This logical eraseblock is older then the one found
+			 * This logical eraseblock is older than the one found
 			 * previously.
 			 */
 			if (cmp_res & 4)
diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 2ad9404..c64540a 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -135,7 +135,7 @@ enum {
  * The erase counter header takes 64 bytes and has a plenty of unused space for
  * future usage. The unused fields are zeroed. The @version field is used to
  * indicate the version of UBI implementation which is supposed to be able to
- * work with this UBI image. If @version is greater then the current UBI
+ * work with this UBI image. If @version is greater than the current UBI
  * version, the image is rejected. This may be useful in future if something
  * is changed radically. This field is duplicated in the volume identifier
  * header.
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 05d7093..ce16ac8 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -108,7 +108,7 @@
  * situation when the picked physical eraseblock is constantly erased after the
  * data is written to it. So, we have a constant which limits the highest erase
  * counter of the free physical eraseblock to pick. Namely, the WL sub-system
- * does not pick eraseblocks with erase counter greater then the lowest erase
+ * does not pick eraseblocks with erase counter greater than the lowest erase
  * counter plus %WL_FREE_MAX_DIFF.
  */
 #define WL_FREE_MAX_DIFF (2*UBI_WL_THRESHOLD)
@@ -985,7 +985,7 @@ static int ensure_wear_leveling(struct ubi_device *ubi)
 		/*
 		 * We schedule wear-leveling only if the difference between the
 		 * lowest erase counter of used physical eraseblocks and a high
-		 * erase counter of free physical eraseblocks is greater then
+		 * erase counter of free physical eraseblocks is greater than
 		 * %UBI_WL_THRESHOLD.
 		 */
 		e1 = rb_entry(rb_first(&ubi->used), struct ubi_wl_entry, rb);
diff --git a/drivers/net/e1000/e1000_hw.c b/drivers/net/e1000/e1000_hw.c
index 9d6edf3..b0e47b6 100644
--- a/drivers/net/e1000/e1000_hw.c
+++ b/drivers/net/e1000/e1000_hw.c
@@ -6735,7 +6735,7 @@ static s32 e1000_get_cable_length(struct e1000_hw *hw, u16 *min_length,
  * returns: - E1000_ERR_XXX
  *            E1000_SUCCESS
  *
- * For phy's older then IGP, this function simply reads the polarity bit in the
+ * For phy's older than IGP, this function simply reads the polarity bit in the
  * Phy Status register.  For IGP phy's, this bit is valid only if link speed is
  * 10 Mbps.  If the link speed is 100 Mbps there is no polarity so this bit will
  * return 0.  If the link speed is 1000 Mbps the polarity status is in the
@@ -6811,7 +6811,7 @@ static s32 e1000_check_polarity(struct e1000_hw *hw,
  * returns: - E1000_ERR_XXX
  *            E1000_SUCCESS
  *
- * For phy's older then IGP, this function reads the Downshift bit in the Phy
+ * For phy's older than IGP, this function reads the Downshift bit in the Phy
  * Specific Status register.  For IGP phy's, it reads the Downgrade bit in the
  * Link Health register.  In IGP this bit is latched high, so the driver must
  * read it immediately after link is established.
diff --git a/drivers/net/slip.h b/drivers/net/slip.h
index 853e0f6..9ea5c11 100644
--- a/drivers/net/slip.h
+++ b/drivers/net/slip.h
@@ -75,7 +75,7 @@ struct slip {
   unsigned long         tx_errors;      /* Planned stuff                */
   unsigned long         rx_dropped;     /* No memory for skb            */
   unsigned long         tx_dropped;     /* When MTU change              */
-  unsigned long         rx_over_errors; /* Frame bigger then SLIP buf.  */
+  unsigned long         rx_over_errors; /* Frame bigger than SLIP buf.  */
 #ifdef SL_INCLUDE_CSLIP
   unsigned long		tx_compressed;
   unsigned long		rx_compressed;
diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index 91f9054..a7fc262 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1005,7 +1005,7 @@ static inline void bdx_rxdb_free_elem(struct rxdb *db, int n)
  * skb for rx. It assumes that Rx is desabled in HW
  * funcs are grouped for better cache usage
  *
- * RxD fifo is smaller then RxF fifo by design. Upon high load, RxD will be
+ * RxD fifo is smaller than RxF fifo by design. Upon high load, RxD will be
  * filled and packets will be dropped by nic without getting into host or
  * cousing interrupt. Anyway, in that condition, host has no chance to proccess
  * all packets, but dropping in nic is cheaper, since it takes 0 cpu cycles
@@ -1828,7 +1828,7 @@ static void bdx_tx_free(struct bdx_priv *priv)
  *
  * Pushes desc to TxD fifo and overlaps it if needed.
  * NOTE: this func does not check for available space. this is responsibility
- *    of the caller. Neither does it check that data size is smaller then
+ *    of the caller. Neither does it check that data size is smaller than
  *    fifo size.
  */
 static void bdx_tx_push_desc(struct bdx_priv *priv, void *data, int size)
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index fa73e6e..78db98e 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -3064,7 +3064,7 @@ static int smctr_load_node_addr(struct net_device *dev)
  * will consequently cause a timeout.
  *
  * NOTE 1: If the monitor_state is MS_BEACON_TEST_STATE, all transmit
- * queues other then the one used for the lobe_media_test should be
+ * queues other than the one used for the lobe_media_test should be
  * disabled.!?
  *
  * NOTE 2: If the monitor_state is MS_BEACON_TEST_STATE and the receive_mask
@@ -4051,7 +4051,7 @@ static int smctr_rcv_chg_param(struct net_device *dev, MAC_HEADER *rmf,
                 }
 
                 /* Let Sender Know if SUM of SV length's is
-                 * larger then length in MVID length field
+                 * larger than length in MVID length field
                  */
                 if((vlen -= rsv->svl) < 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4062,7 +4062,7 @@ static int smctr_rcv_chg_param(struct net_device *dev, MAC_HEADER *rmf,
         if(rcode == POSITIVE_ACK)
         {
                 /* Let Sender Know if MVID length field
-                 * is larger then SUM of SV length's
+                 * is larger than SUM of SV length's
                  */
                 if(vlen != 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4126,7 +4126,7 @@ static int smctr_rcv_init(struct net_device *dev, MAC_HEADER *rmf,
                 }
 
                 /* Let Sender Know if SUM of SV length's is
-                 * larger then length in MVID length field
+                 * larger than length in MVID length field
 		 */
                 if((vlen -= rsv->svl) < 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4137,7 +4137,7 @@ static int smctr_rcv_init(struct net_device *dev, MAC_HEADER *rmf,
         if(rcode == POSITIVE_ACK)
         {
                 /* Let Sender Know if MVID length field
-                 * is larger then SUM of SV length's
+                 * is larger than SUM of SV length's
                  */
                 if(vlen != 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4186,7 +4186,7 @@ static int smctr_rcv_tx_forward(struct net_device *dev, MAC_HEADER *rmf)
                 }
 
                 /* Let Sender Know if SUM of SV length's is
-                 * larger then length in MVID length field
+                 * larger than length in MVID length field
 		 */
                 if((vlen -= rsv->svl) < 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4197,7 +4197,7 @@ static int smctr_rcv_tx_forward(struct net_device *dev, MAC_HEADER *rmf)
         if(rcode == POSITIVE_ACK)
         {
                 /* Let Sender Know if MVID length field
-                 * is larger then SUM of SV length's
+                 * is larger than SUM of SV length's
                  */
                 if(vlen != 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4242,7 +4242,7 @@ static int smctr_rcv_rq_addr_state_attch(struct net_device *dev,
                 }
 
                 /* Let Sender Know if SUM of SV length's is
-                 * larger then length in MVID length field
+                 * larger than length in MVID length field
                  */
                 if((vlen -= rsv->svl) < 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
@@ -4253,7 +4253,7 @@ static int smctr_rcv_rq_addr_state_attch(struct net_device *dev,
         if(rcode == POSITIVE_ACK)
         {
                 /* Let Sender Know if MVID length field
-                 * is larger then SUM of SV length's
+                 * is larger than SUM of SV length's
                  */
                 if(vlen != 0)
                         rcode = E_VECTOR_LENGTH_ERROR;
diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..fed37b6 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -668,7 +668,7 @@ static int ipw_get_ordinal(struct ipw_priv *priv, u32 ord, void *val, u32 * len)
 
 		/* boundary check */
 		if (ord > priv->table0_len) {
-			IPW_DEBUG_ORD("ordinal value (%i) longer then "
+			IPW_DEBUG_ORD("ordinal value (%i) longer than "
 				      "max (%i)\n", ord, priv->table0_len);
 			return -EINVAL;
 		}
diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4c0538d..04d0a74 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -605,7 +605,7 @@ static void rt2400pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 	u8 reg;
 
 	/*
-	 * The link tuner should not run longer then 60 seconds,
+	 * The link tuner should not run longer than 60 seconds,
 	 * and should run once every 2 seconds.
 	 */
 	if (rt2x00dev->link.count > 60 || !(rt2x00dev->link.count & 1))
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 7e88ce5..3721f1b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -142,7 +142,7 @@ struct rt2x00_field32 {
  * Macro's to find first set bit in a variable.
  * These macro's behaves the same as the __ffs() function with
  * the most important difference that this is done during
- * compile-time rather then run-time.
+ * compile-time rather than run-time.
  */
 #define compile_ffs2(__x) \
 	__builtin_choose_expr(((__x) & 0x1), 0, 1)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 087e90b..2ee7052 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -873,7 +873,7 @@ static void rt61pci_link_tuner(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Special case: Change up_bound based on the rssi.
-	 * Lower up_bound when rssi is weaker then -74 dBm.
+	 * Lower up_bound when rssi is weaker than -74 dBm.
 	 */
 	up_bound -= 2 * (-74 - rssi);
 	if (low_bound > up_bound)
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 9761eaa..f9969b7 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -829,7 +829,7 @@ static void rt73usb_link_tuner(struct rt2x00_dev *rt2x00dev)
 
 	/*
 	 * Special case: Change up_bound based on the rssi.
-	 * Lower up_bound when rssi is weaker then -74 dBm.
+	 * Lower up_bound when rssi is weaker than -74 dBm.
 	 */
 	up_bound -= 2 * (-74 - rssi);
 	if (low_bound > up_bound)
diff --git a/drivers/net/wireless/strip.c b/drivers/net/wireless/strip.c
index 417e9e6..e84f23a 100644
--- a/drivers/net/wireless/strip.c
+++ b/drivers/net/wireless/strip.c
@@ -236,7 +236,7 @@ struct strip {
 	unsigned long tx_errors;	/* Planned stuff                */
 	unsigned long rx_dropped;	/* No memory for skb            */
 	unsigned long tx_dropped;	/* When MTU change              */
-	unsigned long rx_over_errors;	/* Frame bigger then STRIP buf. */
+	unsigned long rx_over_errors;	/* Frame bigger than STRIP buf. */
 
 	unsigned long pps_timer;	/* Timer to determine pps       */
 	unsigned long rx_pps_count;	/* Counter to determine pps     */
diff --git a/drivers/s390/block/dasd_alias.c b/drivers/s390/block/dasd_alias.c
index 20676cd..77434f2 100644
--- a/drivers/s390/block/dasd_alias.c
+++ b/drivers/s390/block/dasd_alias.c
@@ -638,7 +638,7 @@ struct dasd_device *dasd_alias_get_start_dev(struct dasd_device *base_device)
 
 /*
  * Summary unit check handling depends on the way alias devices
- * are handled so it is done here rather then in dasd_eckd.c
+ * are handled so it is done here rather than in dasd_eckd.c
  */
 static int reset_summary_unit_check(struct alias_lcu *lcu,
 				    struct dasd_device *device,
diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 29da441..e582a23 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -532,8 +532,8 @@ static int dasd_eer_open(struct inode *inp, struct file *filp)
 	    eerb->buffer_page_count > INT_MAX / PAGE_SIZE) {
 		kfree(eerb);
 		MESSAGE(KERN_WARNING, "can't open device since module "
-			"parameter eer_pages is smaller then 1 or"
-			" bigger then %d", (int)(INT_MAX / PAGE_SIZE));
+			"parameter eer_pages is smaller than 1 or"
+			" bigger than %d", (int)(INT_MAX / PAGE_SIZE));
 		unlock_kernel();
 		return -EINVAL;
 	}
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index c31faef..0c98143 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -282,7 +282,7 @@ static int vmlogrdr_recording(struct vmlogrdr_priv_t * logptr,
 	 * on success, but when the specific service was never connected
 	 * before then there might be an additional informational message
 	 * 'HCPCRC8072I Recording entry not found' before the
-         * 'Command complete'. So I use strstr rather then the strncmp.
+         * 'Command complete'. So I use strstr rather than the strncmp.
 	 */
 	if (strstr(cp_response,"Command complete"))
 		return 0;
@@ -426,7 +426,7 @@ static int vmlogrdr_receive_data(struct vmlogrdr_priv_t *priv)
 			buffer = priv->buffer + sizeof(int);
 		}
 		/*
-		 * If the record is bigger then our buffer, we receive only
+		 * If the record is bigger than our buffer, we receive only
 		 * a part of it. We can get the rest later.
 		 */
 		if (iucv_data_count > NET_BUFFER_SIZE)
@@ -436,7 +436,7 @@ static int vmlogrdr_receive_data(struct vmlogrdr_priv_t *priv)
 					  0, buffer, iucv_data_count,
 					  &priv->residual_length);
 		spin_unlock_bh(&priv->priv_lock);
-		/* An rc of 5 indicates that the record was bigger then
+		/* An rc of 5 indicates that the record was bigger than
 		 * the buffer, which is OK for us. A 9 indicates that the
 		 * record was purged befor we could receive it.
 		 */
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index a98d11b..990d25e 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1756,7 +1756,7 @@ lpfc_set_disctmo(struct lpfc_vport *vport)
 	uint32_t tmo;
 
 	if (vport->port_state == LPFC_LOCAL_CFG_LINK) {
-		/* For FAN, timeout should be greater then edtov */
+		/* For FAN, timeout should be greater than edtov */
 		tmo = (((phba->fc_edtov + 999) / 1000) + 1);
 	} else {
 		/* Normal discovery timeout should be > then ELS/CT timeout
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 50fe076..246a1f0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -312,7 +312,7 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 		if (unlikely(pring->local_getidx >= max_cmd_idx)) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 					"0315 Ring %d issue: portCmdGet %d "
-					"is bigger then cmd ring %d\n",
+					"is bigger than cmd ring %d\n",
 					pring->ringno,
 					pring->local_getidx, max_cmd_idx);
 
@@ -1289,12 +1289,12 @@ lpfc_sli_rsp_pointers_error(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
 		&phba->slim2p->mbx.us.s3_pgp.port[pring->ringno] :
 		&phba->slim2p->mbx.us.s2.port[pring->ringno];
 	/*
-	 * Ring <ringno> handler: portRspPut <portRspPut> is bigger then
+	 * Ring <ringno> handler: portRspPut <portRspPut> is bigger than
 	 * rsp ring <portRspMax>
 	 */
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0312 Ring %d handler: portRspPut %d "
-			"is bigger then rsp ring %d\n",
+			"is bigger than rsp ring %d\n",
 			pring->ringno, le32_to_cpu(pgp->rspPutInx),
 			pring->numRiocb);
 
@@ -1677,12 +1677,12 @@ lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 	portRspPut = le32_to_cpu(pgp->rspPutInx);
 	if (portRspPut >= portRspMax) {
 		/*
-		 * Ring <ringno> handler: portRspPut <portRspPut> is bigger then
+		 * Ring <ringno> handler: portRspPut <portRspPut> is bigger than
 		 * rsp ring <portRspMax>
 		 */
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0303 Ring %d handler: portRspPut %d "
-				"is bigger then rsp ring %d\n",
+				"is bigger than rsp ring %d\n",
 				pring->ringno, portRspPut, portRspMax);
 
 		phba->link_state = LPFC_HBA_ERROR;
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index bf94a77..5cb6672 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -1204,7 +1204,7 @@ static void e100_disable_txdma_channel(struct e100_serial *info)
 	unsigned long flags;
 
 	/* Disable output DMA channel for the serial port in question
-	 * ( set to something other then serialX)
+	 * ( set to something other than serialX)
 	 */
 	local_irq_save(flags);
 	DFLOW(DEBUG_LOG(info->line, "disable_txdma_channel %i\n", info->line));
@@ -1267,7 +1267,7 @@ static void e100_disable_rxdma_channel(struct e100_serial *info)
 	unsigned long flags;
 
 	/* Disable input DMA channel for the serial port in question
-	 * ( set to something other then serialX)
+	 * ( set to something other than serialX)
 	 */
 	local_irq_save(flags);
 	if (info->line == 0) {
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index 85dfe29..9f63ed5 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -890,7 +890,7 @@ static inline int c67x00_end_of_data(struct c67x00_td *td)
 	maxps = usb_maxpacket(td_udev(td), td->pipe, usb_pipeout(td->pipe));
 
 	if (unlikely(act_bytes < maxps))
-		return 1;	/* Smaller then full packet */
+		return 1;	/* Smaller than full packet */
 
 	remaining = urb->transfer_buffer_length - urb->actual_length;
 	need_empty = (urb->transfer_flags & URB_ZERO_PACKET) &&
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 22837a3..861046b 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -513,7 +513,7 @@ static int generic_startup(struct usb_serial *serial)
 	priv->termios_initialized = 0;
 	priv->rx_flags = 0;
 	/* Default packet format setting is determined by packet size.
-	   Anything with a size larger then 9 must have a separate
+	   Anything with a size larger than 9 must have a separate
 	   count field since the 3 bit count field is otherwise too
 	   small.  Otherwise we can use the slightly more compact
 	   format.  This is in accordance with the cypress_m8 serial
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 09779f6..3535d24 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -193,7 +193,7 @@ static int slave_configure(struct scsi_device *sdev)
 		sdev->allow_restart = 1;
 
 		/* Some USB cardreaders have trouble reading an sdcard's last
-		 * sector in a larger then 1 sector read, since the performance
+		 * sector in a larger than 1 sector read, since the performance
 		 * impact is negible we set this flag for all USB disks */
 		sdev->last_sector_bug = 1;
 	} else {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 865e9dd..148d54b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3465,7 +3465,7 @@ ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	struct ext4_group_info *grp;
 	struct ext4_inode_info *ei;
 
-	/* preallocate only when found space is larger then requested */
+	/* preallocate only when found space is larger than requested */
 	BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
 	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
 	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
@@ -3553,7 +3553,7 @@ ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	struct ext4_prealloc_space *pa;
 	struct ext4_group_info *grp;
 
-	/* preallocate only when found space is larger then requested */
+	/* preallocate only when found space is larger than requested */
 	BUG_ON(ac->ac_o_ex.fe_len >= ac->ac_b_ex.fe_len);
 	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
 	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
diff --git a/fs/jffs2/gc.c b/fs/jffs2/gc.c
index 090c556..ea01680 100644
--- a/fs/jffs2/gc.c
+++ b/fs/jffs2/gc.c
@@ -737,7 +737,7 @@ static int jffs2_garbage_collect_metadata(struct jffs2_sb_info *c, struct jffs2_
 
 	last_frag = frag_last(&f->fragtree);
 	if (last_frag)
-		/* Fetch the inode length from the fragtree rather then
+		/* Fetch the inode length from the fragtree rather than
 		 * from i_size since i_size may have not been updated yet */
 		ilen = last_frag->ofs + last_frag->size;
 	else
@@ -1008,7 +1008,7 @@ static int jffs2_garbage_collect_hole(struct jffs2_sb_info *c, struct jffs2_eras
 
 	frag = frag_last(&f->fragtree);
 	if (frag)
-		/* Fetch the inode length from the fragtree rather then
+		/* Fetch the inode length from the fragtree rather than
 		 * from i_size since i_size may have not been updated yet */
 		ilen = frag->ofs + frag->size;
 	else
diff --git a/fs/ubifs/Kconfig b/fs/ubifs/Kconfig
index 91ceeda..c7296b7 100644
--- a/fs/ubifs/Kconfig
+++ b/fs/ubifs/Kconfig
@@ -32,7 +32,7 @@ config UBIFS_FS_LZO
 	depends on UBIFS_FS
 	default y
 	help
-	   LZO compressor is generally faster then zlib but compresses worse.
+	   LZO compressor is generally faster than zlib but compresses worse.
 	   Say 'Y' if unsure.
 
 config UBIFS_FS_ZLIB
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 1540981..676a5a1 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -676,7 +676,7 @@ void ubifs_release_budget(struct ubifs_info *c, struct ubifs_budget_req *req)
  * @c: UBIFS file-system description object
  *
  * This function converts budget which was allocated for a new page of data to
- * the budget of changing an existing page of data. The latter is smaller then
+ * the budget of changing an existing page of data. The latter is smaller than
  * the former, so this function only does simple re-calculation and does not
  * involve any write-back.
  */
diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
index f248533..bfe0920 100644
--- a/fs/ubifs/shrinker.c
+++ b/fs/ubifs/shrinker.c
@@ -65,7 +65,7 @@ atomic_long_t ubifs_clean_zn_cnt;
  * @contention: if any contention, this is set to %1
  *
  * This function traverses TNC tree and frees clean znodes. It does not free
- * clean znodes which younger then @age. Returns number of freed znodes.
+ * clean znodes which younger than @age. Returns number of freed znodes.
  */
 static int shrink_tnc(struct ubifs_info *c, int nr, int age, int *contention)
 {
@@ -151,7 +151,7 @@ static int shrink_tnc(struct ubifs_info *c, int nr, int age, int *contention)
  * @contention: if any contention, this is set to %1
  *
  * This function walks the list of mounted UBIFS file-systems and frees clean
- * znodes which are older then @age, until at least @nr znodes are freed.
+ * znodes which are older than @age, until at least @nr znodes are freed.
  * Returns the number of freed znodes.
  */
 static int shrink_tnc_trees(int nr, int age, int *contention)
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c8bd2da..19489b3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -139,8 +139,8 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #endif
 
 /*
- * Rather then using noinline to prevent stack consumption, use
- * noinline_for_stack instead.  For documentaiton reasons.
+ * Rather than using noinline to prevent stack consumption, use
+ * noinline_for_stack instead.  For documentation reasons.
  */
 #define noinline_for_stack noinline
 
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 4be01bb..f28879e 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -325,9 +325,9 @@ extern struct spi_master *spi_busnum_to_master(u16 busnum);
  * @tx_dma: DMA address of tx_buf, if @spi_message.is_dma_mapped
  * @rx_dma: DMA address of rx_buf, if @spi_message.is_dma_mapped
  * @len: size of rx and tx buffers (in bytes)
- * @speed_hz: Select a speed other then the device default for this
+ * @speed_hz: Select a speed other than the device default for this
  *      transfer. If 0 the default (from @spi_device) is used.
- * @bits_per_word: select a bits_per_word other then the device default
+ * @bits_per_word: select a bits_per_word other than the device default
  *      for this transfer. If 0 the default (from @spi_device) is used.
  * @cs_change: affects chipselect after this transfer completes
  * @delay_usecs: microseconds to delay after this transfer before
diff --git a/include/mtd/ubi-user.h b/include/mtd/ubi-user.h
index ccdc562..2dc2eb2 100644
--- a/include/mtd/ubi-user.h
+++ b/include/mtd/ubi-user.h
@@ -253,7 +253,7 @@ struct ubi_mkvol_req {
  *
  * Re-sizing is possible for both dynamic and static volumes. But while dynamic
  * volumes may be re-sized arbitrarily, static volumes cannot be made to be
- * smaller then the number of bytes they bear. To arbitrarily shrink a static
+ * smaller than the number of bytes they bear. To arbitrarily shrink a static
  * volume, it must be wiped out first (by means of volume update operation with
  * zero number of bytes).
  */
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ff137fd..861fa1c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -610,7 +610,7 @@ enum ieee80211_key_len {
  *	the driver for a TKIP key if it requires Michael MIC
  *	generation in software.
  * @IEEE80211_KEY_FLAG_PAIRWISE: Set by mac80211, this flag indicates
- *	that the key is pairwise rather then a shared key.
+ *	that the key is pairwise rather than a shared key.
  */
 enum ieee80211_key_flags {
 	IEEE80211_KEY_FLAG_WMM_STA	= 1<<0,
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 0314074..87d473e 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -298,7 +298,7 @@ void compat_irq_chip_set_default_handler(struct irq_desc *desc)
 {
 	/*
 	 * If the architecture still has not overriden
-	 * the flow handler then zap the default. This
+	 * the flow handler then zaps the default. This
 	 * should catch incorrect flow-type setting.
 	 */
 	if (desc->handle_irq == &handle_bad_irq)
diff --git a/kernel/pid.c b/kernel/pid.c
index 064e76a..af9224c 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -475,7 +475,7 @@ pid_t task_session_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
 EXPORT_SYMBOL(task_session_nr_ns);
 
 /*
- * Used by proc to find the first pid that is greater then or equal to nr.
+ * Used by proc to find the first pid that is greater than or equal to nr.
  *
  * If there is a pid at nr this function is exactly the same as find_pid_ns.
  */
diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
index 4c256fd..368daa3 100644
--- a/kernel/time/jiffies.c
+++ b/kernel/time/jiffies.c
@@ -45,7 +45,7 @@
  *
  * The value 8 is somewhat carefully chosen, as anything
  * larger can result in overflows. NSEC_PER_JIFFY grows as
- * HZ shrinks, so values greater then 8 overflow 32bits when
+ * HZ shrinks, so values greater than 8 overflow 32bits when
  * HZ=100.
  */
 #define JIFFIES_SHIFT	8
diff --git a/net/irda/parameters.c b/net/irda/parameters.c
index fc1a205..4b87426 100644
--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -224,7 +224,7 @@ static int irda_extract_integer(void *self, __u8 *buf, int len, __u8 pi,
 
 	/*
 	 * Check that the integer length is what we expect it to be. If the
-	 * handler want a 16 bits integer then a 32 bits is not good enough
+	 * handler wants a 16 bits integer then a 32 bits is not good enough
 	 * PV_INTEGER means that the handler is flexible.
 	 */
 	if (((type & PV_MASK) != PV_INTEGER) && ((type & PV_MASK) != p.pl)) {
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 675a5c3..2241a39 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -137,8 +137,8 @@ void sctp_auth_destroy_keys(struct list_head *keys)
 /* Compare two byte vectors as numbers.  Return values
  * are:
  * 	  0 - vectors are equal
- * 	< 0 - vector 1 is smaller then vector2
- * 	> 0 - vector 1 is greater then vector2
+ * 	< 0 - vector 1 is smaller than vector2
+ * 	> 0 - vector 1 is greater than vector2
  *
  * Algorithm is:
  * 	This is performed by selecting the numerically smaller key vector...
diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index 8848d32..751a02b 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4233,7 +4233,7 @@ static sctp_disposition_t sctp_sf_violation_chunklen(
 
 /*
  * Handle a protocol violation when the parameter length is invalid.
- * "Invalid" length is identified as smaller then the minimal length a
+ * "Invalid" length is identified as smaller than the minimal length a
  * given parameter can be.
  */
 static sctp_disposition_t sctp_sf_violation_paramlen(
diff --git a/usr/Makefile b/usr/Makefile
index 201f27f..2b1e974 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -42,7 +42,7 @@ $(deps_initramfs): ;
 
 $(deps_initramfs): klibcdirs
 # We rebuild initramfs_data.cpio.gz if:
-# 1) Any included file is newer then initramfs_data.cpio.gz
+# 1) Any included file is newer than initramfs_data.cpio.gz
 # 2) There are changes in which files are included (added or deleted)
 # 3) If gen_init_cpio are newer than initramfs_data.cpio.gz
 # 4) arguments to gen_initramfs.sh changes
diff --git a/usr/initramfs_data.S b/usr/initramfs_data.S
index c2e1ad4..04025d5 100644
--- a/usr/initramfs_data.S
+++ b/usr/initramfs_data.S
@@ -2,7 +2,7 @@
   initramfs_data includes the compressed binary that is the
   filesystem used for early user space.
   Note: Older versions of "as" (prior to binutils 2.11.90.0.23
-  released on 2001-07-14) dit not support .incbin.
+  released on 2001-07-14) did not support .incbin.
   If you are forced to use older binutils than that then the
   following trick can be applied to create the resulting binary:
 

