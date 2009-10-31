Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbZJaJkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbZJaJkz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZJaJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:40:54 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309AbZJaJks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=Z6/bZGTcyOd9yVsf65d5O2tITmHbz3a+UT/1EcBY8sqy8t144lvMBabaLAHQHcybvn
         0DC11lwr3Q8Blsw5NyWn15oqwZlss2HFlUJ2Bh40cvLz/KMVg53RKUC6AdexWfhsGR3C
         Du47/KEwf8KXC7L8vf2iSCi37PAh1l9PIwyJg=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:40:32 -0200
Message-ID: <b8bf37780910310240i55ec5e0ag74fee707bb4f5a8a@mail.gmail.com>
Subject: [PATCH 01/16] trivial: fix assorted "success" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From b81a0ec27dd1c855362c0af105f0e89623bba52a Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 03:40:34 -0200
Subject: [PATCH 01/16] trivial: fix assorted "success" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/Documentation/ABI/testing/procfs-diskstats
b/Documentation/ABI/testing/procfs-diskstats
index 9923390..f91a973 100644
--- a/Documentation/ABI/testing/procfs-diskstats
+++ b/Documentation/ABI/testing/procfs-diskstats
@@ -8,7 +8,7 @@ Description:
 		 1 - major number
 		 2 - minor mumber
 		 3 - device name
-		 4 - reads completed succesfully
+		 4 - reads completed successfully
 		 5 - reads merged
 		 6 - sectors read
 		 7 - time spent reading (ms)
diff --git a/Documentation/ABI/testing/sysfs-block
b/Documentation/ABI/testing/sysfs-block
index 5f3beda..d2f9033 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -4,7 +4,7 @@ Contact:	Jerome Marchand <jmarchan@redhat.com>
 Description:
 		The /sys/block/<disk>/stat files displays the I/O
 		statistics of disk <disk>. They contain 11 fields:
-		 1 - reads completed succesfully
+		 1 - reads completed successfully
 		 2 - reads merged
 		 3 - sectors read
 		 4 - time spent reading (ms)
diff --git a/Documentation/scsi/ChangeLog.megaraid_sas
b/Documentation/scsi/ChangeLog.megaraid_sas
index c851ef4..84524e0 100644
--- a/Documentation/scsi/ChangeLog.megaraid_sas
+++ b/Documentation/scsi/ChangeLog.megaraid_sas
@@ -185,7 +185,7 @@ ii.	FW enables WCE bit in Mode Sense cmd for
drives that are configured
 	Disks are exposed with WCE=1. User is advised to enable Write Back
 	mode only when the controller has battery backup. At this time
 	Synhronize cache is not supported by the FW. Driver will short-cycle
-	the cmd and return sucess without sending down to FW.
+	the cmd and return success without sending down to FW.

 1 Release Date    : Sun Jan. 14 11:21:32 PDT 2007 -
 		 Sumant Patro <Sumant.Patro@lsil.com>/Bo Yang
diff --git a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
index 375066a..1e24420 100644
--- a/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
+++ b/arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
@@ -83,7 +83,7 @@ typedef struct {
 *  @brief   Get next available transaction width
 *
 *
-*  @return  On sucess  : Next avail able transaction width
+*  @return  On success  : Next avail able transaction width
 *           On failure : dmacHw_TRANSACTION_WIDTH_8
 *
 *  @note
diff --git a/arch/arm/mach-bcmring/include/mach/dma.h
b/arch/arm/mach-bcmring/include/mach/dma.h
index 847980c..1f2c531 100644
--- a/arch/arm/mach-bcmring/include/mach/dma.h
+++ b/arch/arm/mach-bcmring/include/mach/dma.h
@@ -651,7 +651,7 @@ int dma_map_add_region(DMA_MemMap_t *memMap,	/*
Stores state information about t
 /**
 *   Creates a descriptor ring from a memory mapping.
 *
-*   @return 0 on sucess, error code otherwise.
+*   @return 0 on success, error code otherwise.
 */
 /****************************************************************************/

diff --git a/arch/arm/mach-s3c6400/setup-sdhci.c
b/arch/arm/mach-s3c6400/setup-sdhci.c
index b93dafb..1039937 100644
--- a/arch/arm/mach-s3c6400/setup-sdhci.c
+++ b/arch/arm/mach-s3c6400/setup-sdhci.c
@@ -30,7 +30,7 @@ char *s3c6400_hsmmc_clksrcs[4] = {
 	[0] = "hsmmc",
 	[1] = "hsmmc",
 	[2] = "mmc_bus",
-	/* [3] = "48m", - note not succesfully used yet */
+	/* [3] = "48m", - note not successfully used yet */
 };

 void s3c6400_setup_sdhci_cfg_card(struct platform_device *dev,
diff --git a/arch/arm/mach-s3c6410/setup-sdhci.c
b/arch/arm/mach-s3c6410/setup-sdhci.c
index 20666f3..816d2d9 100644
--- a/arch/arm/mach-s3c6410/setup-sdhci.c
+++ b/arch/arm/mach-s3c6410/setup-sdhci.c
@@ -30,7 +30,7 @@ char *s3c6410_hsmmc_clksrcs[4] = {
 	[0] = "hsmmc",
 	[1] = "hsmmc",
 	[2] = "mmc_bus",
-	/* [3] = "48m", - note not succesfully used yet */
+	/* [3] = "48m", - note not successfully used yet */
 };


diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index b53125f..0e30891 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -1232,7 +1232,7 @@ static void create_dma_lch_chain(int lch_head,
int lch_queue)
  * 					      OMAP_DMA_DYNAMIC_CHAIN
  * @params - Channel parameters
  *
- * @return - Succes : 0
+ * @return - Success : 0
  * 	     Failure: -EINVAL/-ENOMEM
  */
 int omap_request_dma_chain(int dev_id, const char *dev_name,
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 6b7325d..78cb3d3 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -619,7 +619,7 @@ asmlinkage notrace void trap_c(struct pt_regs *fp)

 /*
  * Similar to get_user, do some address checking, then dereference
- * Return true on sucess, false on bad address
+ * Return true on success, false on bad address
  */
 static bool get_instruction(unsigned short *val, unsigned short *address)
 {
diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
index 6a907c5..cc2108b 100644
--- a/arch/microblaze/lib/memcpy.c
+++ b/arch/microblaze/lib/memcpy.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/microblaze/lib/memmove.c b/arch/microblaze/lib/memmove.c
index d4e9f49..0929198 100644
--- a/arch/microblaze/lib/memmove.c
+++ b/arch/microblaze/lib/memmove.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/microblaze/lib/memset.c b/arch/microblaze/lib/memset.c
index 941dc8f..4df851d 100644
--- a/arch/microblaze/lib/memset.c
+++ b/arch/microblaze/lib/memset.c
@@ -9,7 +9,7 @@
  * It is based on demo code originally Copyright 2001 by Intel Corp, taken from
  * http://www.embedded.com/showArticle.jhtml?articleID=19205567
  *
- * Attempts were made, unsuccesfully, to contact the original
+ * Attempts were made, unsuccessfully, to contact the original
  * author of this code (Michael Morrow, Intel).  Below is the original
  * copyright notice.
  *
diff --git a/arch/powerpc/platforms/powermac/pci.c
b/arch/powerpc/platforms/powermac/pci.c
index e81403b..ab2027c 100644
--- a/arch/powerpc/platforms/powermac/pci.c
+++ b/arch/powerpc/platforms/powermac/pci.c
@@ -302,7 +302,7 @@ static void __init setup_chaos(struct pci_controller *hose,
  *  1 -> Skip the device but act as if the access was successfull
  *       (return 0xff's on reads, eventually, cache config space
  *       accesses in a later version)
- * -1 -> Hide the device (unsuccessful acess)
+ * -1 -> Hide the device (unsuccessful access)
  */
 static int u3_ht_skip_device(struct pci_controller *hose,
 			     struct pci_bus *bus, unsigned int devfn)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 98f230f..ad59a92 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1635,7 +1635,7 @@ retry:
 			goto out;

 		/*
-		 * aperture was sucessfully enlarged by 128 MB, try
+		 * aperture was successfully enlarged by 128 MB, try
 		 * allocation again
 		 */
 		goto retry;
diff --git a/block/blk-iopoll.c b/block/blk-iopoll.c
index ca56420..58916af 100644
--- a/block/blk-iopoll.c
+++ b/block/blk-iopoll.c
@@ -28,7 +28,7 @@ static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
  * Description:
  *     Add this blk_iopoll structure to the pending poll list and trigger the
  *     raise of the blk iopoll softirq. The driver must already have gotten a
- *     succesful return from blk_iopoll_sched_prep() before calling this.
+ *     successful return from blk_iopoll_sched_prep() before calling this.
  **/
 void blk_iopoll_sched(struct blk_iopoll *iop)
 {
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 979d159..ee95c76 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -188,7 +188,7 @@ EXPORT_SYMBOL_GPL(wait_for_device_probe);
  * @dev: device to try to bind to the driver
  *
  * This function returns -ENODEV if the device is not registered,
- * 1 if the device is bound sucessfully and 0 otherwise.
+ * 1 if the device is bound successfully and 0 otherwise.
  *
  * This function must be called with @dev->sem held.  When called for a
  * USB interface, @dev->parent->sem must be held as well.
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 5f753fc..09ad915 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -863,7 +863,7 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 		dev->dmareg |= HIFN_DMAIER_PUBDONE;
 		hifn_write_1(dev, HIFN_1_DMA_IER, dev->dmareg);

-		dprintk("Chip %s: Public key engine has been sucessfully "
+		dprintk("Chip %s: Public key engine has been successfully "
 				"initialised.\n", dev->name);
 	}

diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index fddf2b3..d373d17 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -183,7 +183,7 @@ static inline struct fw_node *fw_node(struct list_head *l)
  * This function builds the tree representation of the topology given
  * by the self IDs from the latest bus reset.  During the construction
  * of the tree, the function checks that the self IDs are valid and
- * internally consistent.  On succcess this function returns the
+ * internally consistent.  On success this function returns the
  * fw_node corresponding to the local card otherwise NULL.
  */
 static struct fw_node *build_tree(struct fw_card *card,
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 5cae0b3..0321889 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2328,7 +2328,7 @@ int drm_mode_connector_property_set_ioctl(struct
drm_device *dev,
 	} else if (connector->funcs->set_property)
 		ret = connector->funcs->set_property(connector, property, out_resp->value);

-	/* store the property value if succesful */
+	/* store the property value if successful */
 	if (!ret)
 		drm_connector_property_set_value(connector, property, out_resp->value);
 out:
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index 1c9410d..bcc2d30 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -955,7 +955,7 @@ static int __init hp_sdc_init_hppa(struct parisc_device *d)
 	INIT_DELAYED_WORK(&moduleloader_work, request_module_delayed);

 	ret = hp_sdc_init();
-	/* after sucessfull initialization give SDC some time to settle
+	/* after successfull initialization give SDC some time to settle
 	 * and then load the hp_sdc_mlc upper layer driver */
 	if (!ret)
 		schedule_delayed_work(&moduleloader_work,
diff --git a/drivers/isdn/mISDN/tei.c b/drivers/isdn/mISDN/tei.c
index e04bad6..6d4da60 100644
--- a/drivers/isdn/mISDN/tei.c
+++ b/drivers/isdn/mISDN/tei.c
@@ -725,7 +725,7 @@ tei_id_ver_tout_net(struct FsmInst *fi, int event,
void *arg)
 	if (tm->rcnt == 1) {
 		if (*debug & DEBUG_L2_TEI)
 			tm->tei_m.printdebug(fi,
-			    "check req for tei %d sucessful\n", tm->l2->tei);
+			    "check req for tei %d successful\n", tm->l2->tei);
 		mISDN_FsmChangeState(fi, ST_TEI_NOP);
 	} else if (tm->rcnt > 1) {
 		/* duplicate assignment; remove */
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h
b/drivers/media/dvb/dvb-core/dvb_frontend.h
index 810f07d..52e4ce4 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -160,7 +160,7 @@ struct tuner_state {
  * search callback possible return status
  *
  * DVBFE_ALGO_SEARCH_SUCCESS
- * The frontend search algorithm completed and returned succesfully
+ * The frontend search algorithm completed and returned successfully
  *
  * DVBFE_ALGO_SEARCH_ASLEEP
  * The frontend search algorithm is sleeping
diff --git a/drivers/media/dvb/frontends/cx24113.c
b/drivers/media/dvb/frontends/cx24113.c
index 075b2b5..e9ee555 100644
--- a/drivers/media/dvb/frontends/cx24113.c
+++ b/drivers/media/dvb/frontends/cx24113.c
@@ -589,7 +589,7 @@ struct dvb_frontend *cx24113_attach(struct dvb_frontend *fe,
 		info("detected CX24113 variant\n");
 		break;
 	case REV_CX24113:
-		info("sucessfully detected\n");
+		info("successfully detected\n");
 		break;
 	default:
 		err("unsupported device id: %x\n", state->rev);
diff --git a/drivers/media/dvb/frontends/stb0899_drv.c
b/drivers/media/dvb/frontends/stb0899_drv.c
index a04c782..1570669 100644
--- a/drivers/media/dvb/frontends/stb0899_drv.c
+++ b/drivers/media/dvb/frontends/stb0899_drv.c
@@ -1571,7 +1571,7 @@ static enum dvbfe_search stb0899_search(struct
dvb_frontend *fe, struct dvb_fron
  * stb0899_track
  * periodically check the signal level against a specified
  * threshold level and perform derotator centering.
- * called once we have a lock from a succesful search
+ * called once we have a lock from a successful search
  * event.
  *
  * Will be called periodically called to maintain the
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index d505b68..e39986a 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -940,7 +940,7 @@ static const struct block_device_operations
i2o_block_fops = {
  *	Allocate memory for the i2o_block_device struct, gendisk and request
  *	queue and initialize them as far as no additional information is needed.
  *
- *	Returns a pointer to the allocated I2O Block device on succes or a
+ *	Returns a pointer to the allocated I2O Block device on success or a
  *	negative error code on failure.
  */
 static struct i2o_block_device *i2o_block_device_alloc(void)
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 27cf4af..e5ab621 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -132,7 +132,7 @@ u32 i2o_cntxt_list_add(struct i2o_controller * c, void *ptr)
  *	Removes a previously added pointer from the context list and returns
  *	the matching context id.
  *
- *	Returns context id on succes or 0 on failure.
+ *	Returns context id on success or 0 on failure.
  */
 u32 i2o_cntxt_list_remove(struct i2o_controller * c, void *ptr)
 {
@@ -198,7 +198,7 @@ void *i2o_cntxt_list_get(struct i2o_controller *c,
u32 context)
  *	@c: controller to which the context list belong
  *	@ptr: pointer to which the context id should be fetched
  *
- *	Returns context id which matches to the pointer on succes or 0 on
+ *	Returns context id which matches to the pointer on success or 0 on
  *	failure.
  */
 u32 i2o_cntxt_list_get_ptr(struct i2o_controller * c, void *ptr)
diff --git a/drivers/mtd/nand/diskonchip.c b/drivers/mtd/nand/diskonchip.c
index e51c1ed..b126cf8 100644
--- a/drivers/mtd/nand/diskonchip.c
+++ b/drivers/mtd/nand/diskonchip.c
@@ -1056,7 +1056,7 @@ static struct nand_ecclayout doc200x_oobinfo = {
 };

 /* Find the (I)NFTL Media Header, and optionally also the mirror media header.
-   On sucessful return, buf will contain a copy of the media header for
+   On successful return, buf will contain a copy of the media header for
    further processing.  id is the string to scan for, and will presumably be
    either "ANAND" or "BNAND".  If findmirror=1, also look for the mirror media
    header.  The page #s of the found media headers are placed in mh0_page and
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 11dc7e6..68b5b3a 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -875,7 +875,7 @@ static void s3c2410_nand_init_chip(struct
s3c2410_nand_info *info,
  * @info: The controller instance.
  * @nmtd: The driver version of the MTD instance.
  *
- * This routine is called after the chip probe has succesfully completed
+ * This routine is called after the chip probe has successfully completed
  * and the relevant per-chip information updated. This call ensure that
  * we update the internal state accordingly.
  *
diff --git a/drivers/net/benet/be_main.c b/drivers/net/benet/be_main.c
index 1f941f0..02a0908 100644
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -1876,7 +1876,7 @@ int be_load_fw(struct be_adapter *adapter, u8 *func)
 		goto fw_exit;
 	}

-	dev_info(&adapter->pdev->dev, "Firmware flashed succesfully\n");
+	dev_info(&adapter->pdev->dev, "Firmware flashed successfully\n");

 fw_exit:
 	release_firmware(fw);
diff --git a/drivers/net/e1000e/82571.c b/drivers/net/e1000e/82571.c
index d1e0563..61c083a 100644
--- a/drivers/net/e1000e/82571.c
+++ b/drivers/net/e1000e/82571.c
@@ -1412,7 +1412,7 @@ static s32
e1000_check_for_serdes_link_82571(struct e1000_hw *hw)
 		case e1000_serdes_link_autoneg_progress:
 			/*
 			 * If the LU bit is set in the STATUS register,
-			 * autoneg has completed sucessfully. If not,
+			 * autoneg has completed successfully. If not,
 			 * try foring the link because the far end may be
 			 * available but not capable of autonegotiation.
 			 */
diff --git a/drivers/net/e1000e/lib.c b/drivers/net/e1000e/lib.c
index 99ba2b8..b065ba4 100644
--- a/drivers/net/e1000e/lib.c
+++ b/drivers/net/e1000e/lib.c
@@ -571,7 +571,7 @@ s32 e1000e_check_for_serdes_link(struct e1000_hw *hw)
 				if (!(rxcw & E1000_RXCW_IV)) {
 					mac->serdes_has_link = true;
 					hw_dbg(hw, "SERDES: Link up - autoneg "
-					   "completed sucessfully.\n");
+					   "completed successfully.\n");
 				} else {
 					mac->serdes_has_link = false;
 					hw_dbg(hw, "SERDES: Link down - invalid"
diff --git a/drivers/net/ehea/ehea_ethtool.c b/drivers/net/ehea/ehea_ethtool.c
index d768852..75b099c 100644
--- a/drivers/net/ehea/ehea_ethtool.c
+++ b/drivers/net/ehea/ehea_ethtool.c
@@ -118,7 +118,7 @@ doit:
 	ret = ehea_set_portspeed(port, sp);

 	if (!ret)
-		ehea_info("%s: Port speed succesfully set: %dMbps "
+		ehea_info("%s: Port speed successfully set: %dMbps "
 			  "%s Duplex",
 			  port->netdev->name, port->port_speed,
 			  port->full_duplex == 1 ? "Full" : "Half");
@@ -134,7 +134,7 @@ static int ehea_nway_reset(struct net_device *dev)
 	ret = ehea_set_portspeed(port, EHEA_SPEED_AUTONEG);

 	if (!ret)
-		ehea_info("%s: Port speed succesfully set: %dMbps "
+		ehea_info("%s: Port speed successfully set: %dMbps "
 			  "%s Duplex",
 			  port->netdev->name, port->port_speed,
 			  port->full_duplex == 1 ? "Full" : "Half");
diff --git a/drivers/net/mlx4/mlx4_en.h b/drivers/net/mlx4/mlx4_en.h
index 4376147..82c3ebc 100644
--- a/drivers/net/mlx4/mlx4_en.h
+++ b/drivers/net/mlx4/mlx4_en.h
@@ -162,7 +162,7 @@ enum {
 #define MLX4_EN_DEF_RX_PAUSE	1
 #define MLX4_EN_DEF_TX_PAUSE	1

-/* Interval between sucessive polls in the Tx routine when polling is used
+/* Interval between successive polls in the Tx routine when polling is used
    instead of interrupts (in per-core Tx rings) - should be power of 2 */
 #define MLX4_EN_TX_POLL_MODER	16
 #define MLX4_EN_TX_POLL_TIMEOUT	(HZ / 4)
diff --git a/drivers/net/ps3_gelic_net.c b/drivers/net/ps3_gelic_net.c
index b211613..86fde1a 100644
--- a/drivers/net/ps3_gelic_net.c
+++ b/drivers/net/ps3_gelic_net.c
@@ -296,7 +296,7 @@ static void gelic_card_reset_chain(struct gelic_card *card,
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * return 0 on succes, <0 on failure
+ * return 0 on success, <0 on failure
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
diff --git a/drivers/net/sfc/falcon.c b/drivers/net/sfc/falcon.c
index c049364..70c1232 100644
--- a/drivers/net/sfc/falcon.c
+++ b/drivers/net/sfc/falcon.c
@@ -1264,7 +1264,7 @@ int falcon_flush_queues(struct efx_nic *efx)
 		msleep(FALCON_FLUSH_INTERVAL);
 		falcon_poll_flush_events(efx);

-		/* Check if every queue has been succesfully flushed */
+		/* Check if every queue has been successfully flushed */
 		outstanding = false;
 		efx_for_each_tx_queue(tx_queue, efx)
 			outstanding |= !tx_queue->flushed;
diff --git a/drivers/net/smsc911x.c b/drivers/net/smsc911x.c
index ccdd196..4a00940 100644
--- a/drivers/net/smsc911x.c
+++ b/drivers/net/smsc911x.c
@@ -816,7 +816,7 @@ static int smsc911x_mii_probe(struct net_device *dev)
 	SMSC_TRACE(HW, "Passed Loop Back Test");
 #endif				/* USE_PHY_WORK_AROUND */

-	SMSC_TRACE(HW, "phy initialised succesfully");
+	SMSC_TRACE(HW, "phy initialised successfully");
 	return 0;
 }

diff --git a/drivers/net/smsc911x.h b/drivers/net/smsc911x.h
index b5716bd..016360c 100644
--- a/drivers/net/smsc911x.h
+++ b/drivers/net/smsc911x.h
@@ -30,7 +30,7 @@
 #define SMSC_NAPI_WEIGHT	16

 /* implements a PHY loopback test at initialisation time, to ensure a packet
- * can be succesfully looped back */
+ * can be successfully looped back */
 #define USE_PHY_WORK_AROUND

 #define DPRINTK(nlevel, klevel, fmt, args...) \
diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index 90e663f..40b51e6 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -409,7 +409,7 @@ spider_net_free_rx_chain_contents(struct
spider_net_card *card)
  * @card: card structure
  * @descr: descriptor to re-init
  *
- * Return 0 on succes, <0 on failure.
+ * Return 0 on success, <0 on failure.
  *
  * Allocates a new rx skb, iommu-maps it and attaches it to the
  * descriptor. Mark the descriptor as activated, ready-to-use.
diff --git a/drivers/net/ucc_geth.h b/drivers/net/ucc_geth.h
index 03a6ca0..a007e2a 100644
--- a/drivers/net/ucc_geth.h
+++ b/drivers/net/ucc_geth.h
@@ -80,16 +80,16 @@ struct ucc_geth {
 				   frames) received that were between 128
 				   (Including FCS length==4) and 255 octets */
 	u32 txok;		/* Total number of octets residing in frames
-				   that where involved in succesfull
+				   that where involved in successfull
 				   transmission */
 	u16 txcf;		/* Total number of PAUSE control frames
 				   transmitted by this MAC */
 	u8 res4[0x2];
 	u32 tmca;		/* Total number of frames that were transmitted
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
 	u32 tbca;		/* Total number of frames transmitted
-				   succesfully that had destination address
+				   successfully that had destination address
 				   field equal to the broadcast address */
 	u32 rxfok;		/* Total number of frames received OK */
 	u32 rxbok;		/* Total number of octets received OK */
@@ -98,9 +98,9 @@ struct ucc_geth {
 				   HW because it includes octets in frames that
 				   never even reach the UCC */
 	u32 rmca;		/* Total number of frames that were received
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
-	u32 rbca;		/* Total number of frames received succesfully
+	u32 rbca;		/* Total number of frames received successfully
 				   that had destination address equal to the
 				   broadcast address */
 	u32 scar;		/* Statistics carry register */
@@ -759,15 +759,15 @@ struct ucc_geth_hardware_statistics {
 				   frames) received that were between 128
 				   (Including FCS length==4) and 255 octets */
 	u32 txok;		/* Total number of octets residing in frames
-				   that where involved in succesfull
+				   that where involved in successfull
 				   transmission */
 	u16 txcf;		/* Total number of PAUSE control frames
 				   transmitted by this MAC */
 	u32 tmca;		/* Total number of frames that were transmitted
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
 	u32 tbca;		/* Total number of frames transmitted
-				   succesfully that had destination address
+				   successfully that had destination address
 				   field equal to the broadcast address */
 	u32 rxfok;		/* Total number of frames received OK */
 	u32 rxbok;		/* Total number of octets received OK */
@@ -776,9 +776,9 @@ struct ucc_geth_hardware_statistics {
 				   HW because it includes octets in frames that
 				   never even reach the UCC */
 	u32 rmca;		/* Total number of frames that were received
-				   succesfully with the group address bit set
+				   successfully with the group address bit set
 				   that are not broadcast frames */
-	u32 rbca;		/* Total number of frames received succesfully
+	u32 rbca;		/* Total number of frames received successfully
 				   that had destination address equal to the
 				   broadcast address */
 } __attribute__ ((packed));
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index c6c9222..0c3c738 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -748,7 +748,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 	mii_nway_restart(&dev->mii);

 	if (netif_msg_ifup(dev))
-		devdbg(dev, "phy initialised succesfully");
+		devdbg(dev, "phy initialised successfully");
 	return 0;
 }

diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index 07c32e6..99d2747 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -1114,7 +1114,7 @@ error:
  * device. See the file header for the format. Run all checks on the
  * buffer header, then run over each payload's descriptors, verify
  * their consistency and act on each payload's contents.  If
- * everything is succesful, update the device's statistics.
+ * everything is successful, update the device's statistics.
  *
  * Note: You need to set the skb to contain only the length of the
  * received buffer; for that, use skb_trim(skb, RECEIVED_SIZE).
diff --git a/drivers/net/wireless/ath/ath9k/rc.c
b/drivers/net/wireless/ath/ath9k/rc.c
index 16a2717..2d3b4e7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -969,7 +969,7 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 				 * Since this probe succeeded, we allow the next
 				 * probe twice as soon.  This allows the maxRate
 				 * to move up faster if the probes are
-				 * succesful.
+				 * successful.
 				 */
 				ath_rc_priv->probe_time =
 					now_msec - rate_table->probe_interval / 2;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c
b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 5015448..422288b 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -193,7 +193,7 @@ static void rt2x00usb_interrupt_txdone(struct urb *urb)
 	 * Obtain the status about this packet.
 	 * Note that when the status is 0 it does not mean the
 	 * frame was send out correctly. It only means the frame
-	 * was succesfully pushed to the hardware, we have no
+	 * was successfully pushed to the hardware, we have no
 	 * way to determine the transmission status right now.
 	 * (Only indirectly by looking at the failed TX counters
 	 * in the register).
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
b/drivers/net/wireless/zd1211rw/zd_mac.c
index 6d66635..2b7f965 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -312,7 +312,7 @@ static void tx_status(struct ieee80211_hw *hw,
struct sk_buff *skb,
  * zd_mac_tx_failed - callback for failed frames
  * @dev: the mac80211 wireless device
  *
- * This function is called if a frame couldn't be succesfully be
+ * This function is called if a frame couldn't be successfully be
  * transferred. The first frame from the tx queue, will be selected and
  * reported as error to the upper layers.
  */
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 097d384..f54b1ee 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -74,7 +74,7 @@ fs3270_do_io(struct raw3270_view *view, struct
raw3270_request *rq)
 		}
 		rc = raw3270_start(view, rq);
 		if (rc == 0) {
-			/* Started sucessfully. Now wait for completion. */
+			/* Started successfully. Now wait for completion. */
 			wait_event(fp->wait, raw3270_request_final(rq));
 		}
 	} while (rc == -EACCES);
diff --git a/drivers/s390/cio/chp.c b/drivers/s390/cio/chp.c
index 8ab5160..c268a2e 100644
--- a/drivers/s390/cio/chp.c
+++ b/drivers/s390/cio/chp.c
@@ -65,7 +65,7 @@ static void set_chp_logically_online(struct chp_id
chpid, int onoff)
 	chpid_to_chp(chpid)->state = onoff;
 }

-/* On succes return 0 if channel-path is varied offline, 1 if it is varied
+/* On success return 0 if channel-path is varied offline, 1 if it is varied
  * online. Return -ENODEV if channel-path is not registered. */
 int chp_get_status(struct chp_id chpid)
 {
diff --git a/drivers/scsi/aic7xxx/aic79xx.seq b/drivers/scsi/aic7xxx/aic79xx.seq
index 58bc175..da2bcec 100644
--- a/drivers/scsi/aic7xxx/aic79xx.seq
+++ b/drivers/scsi/aic7xxx/aic79xx.seq
@@ -217,7 +217,7 @@ BEGIN_CRITICAL;
 scbdma_tohost_done:
 	test	CCSCBCTL, CCARREN jz fill_qoutfifo_dmadone;
 	/*
-	 * An SCB has been succesfully uploaded to the host.
+	 * An SCB has been successfully uploaded to the host.
 	 * If the SCB was uploaded for some reason other than
 	 * bad SCSI status (currently only for underruns), we
 	 * queue the SCB for normal completion.  Otherwise, we
diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c
b/drivers/scsi/aic7xxx/aic79xx_core.c
index 63b521d..4d419c1 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -2487,7 +2487,7 @@ ahd_handle_scsiint(struct ahd_softc *ahd, u_int intstat)
 		/*
 		 * Although the driver does not care about the
 		 * 'Selection in Progress' status bit, the busy
-		 * LED does.  SELINGO is only cleared by a sucessfull
+		 * LED does.  SELINGO is only cleared by a successfull
 		 * selection, so we must manually clear it to insure
 		 * the LED turns off just incase no future successful
 		 * selections occur (e.g. no devices on the bus).
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c
b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 8dfb59d..45aa728 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1733,7 +1733,7 @@ ahc_handle_scsiint(struct ahc_softc *ahc, u_int intstat)
 		/*
 		 * Although the driver does not care about the
 		 * 'Selection in Progress' status bit, the busy
-		 * LED does.  SELINGO is only cleared by a sucessfull
+		 * LED does.  SELINGO is only cleared by a successfull
 		 * selection, so we must manually clear it to insure
 		 * the LED turns off just incase no future successful
 		 * selections occur (e.g. no devices on the bus).
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index bd2f771..6486ae4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -56,7 +56,7 @@
  * at the same time.
  *
  * When discovery succeeds or fails a callback is made to the lport as
- * notification. Currently, succesful discovery causes the lport to take no
+ * notification. Currently, successful discovery causes the lport to take no
  * action. A failure will cause the lport to reset. There is likely a circular
  * locking problem with this implementation.
  */
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 2e0746d..ca25ee5 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1004,7 +1004,7 @@ static struct iscsi_r2t_info
*iscsi_tcp_get_curr_r2t(struct iscsi_task *task)
  * iscsi_tcp_task_xmit - xmit normal PDU task
  * @task: iscsi command task
  *
- * We're expected to return 0 when everything was transmitted succesfully,
+ * We're expected to return 0 when everything was transmitted successfully,
  * -EAGAIN if there's still data in the queue, or != 0 for any other kind
  * of error.
  */
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e1a30a1..9bd19aa 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -654,7 +654,7 @@ lpfc_selective_reset(struct lpfc_hba *phba)
  * Notes:
  * Assumes any error from lpfc_selective_reset() will be negative.
  * If lpfc_selective_reset() returns zero then the length of the buffer
- * is returned which indicates succcess
+ * is returned which indicates success
  *
  * Returns:
  * -EINVAL if the buffer does not contain the string "selective"
@@ -3147,7 +3147,7 @@ sysfs_ctlreg_write(struct kobject *kobj, struct
bin_attribute *bin_attr,
  * sysfs_ctlreg_read - Read method for reading from ctlreg
  * @kobj: kernel kobject that contains the kernel class device.
  * @bin_attr: kernel attributes passed to us.
- * @buf: if succesful contains the data from the adapter IOREG space.
+ * @buf: if successful contains the data from the adapter IOREG space.
  * @off: offset into buffer to beginning of data.
  * @count: bytes to transfer.
  *
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index b31ff7f..30200ee 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -802,7 +802,7 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phba, struct
lpfc_iocbq *cmdiocb,

 	/* FLOGI completes successfully */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
-			 "0101 FLOGI completes sucessfully "
+			 "0101 FLOGI completes successfully "
 			 "Data: x%x x%x x%x x%x\n",
 			 irsp->un.ulpWord[4], sp->cmn.e_d_tov,
 			 sp->cmn.w2.r_a_tov, sp->cmn.edtovResolution);
@@ -4134,7 +4134,7 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport,
struct lpfc_iocbq *cmdiocb,
 	/* Indicate we are walking fc_rscn_id_list on this vport */
 	vport->fc_rscn_flush = 1;
 	spin_unlock_irq(shost->host_lock);
-	/* Get the array count after sucessfully have the token */
+	/* Get the array count after successfully have the token */
 	rscn_cnt = vport->fc_rscn_id_cnt;
 	/* If we are already processing an RSCN, save the received
 	 * RSCN payload buffer, cmdiocb->context2 to process later.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 562d8ce..82f8ab5 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -645,7 +645,7 @@ lpfc_hba_down_prep(struct lpfc_hba *phba)
  * down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 static int
@@ -700,7 +700,7 @@ lpfc_hba_down_post_s3(struct lpfc_hba *phba)
  * down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 static int
@@ -755,7 +755,7 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
  * uninitialization after the HBA is reset when bring down the SLI Layer.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 int
@@ -1254,7 +1254,7 @@ lpfc_handle_eratt_s4(struct lpfc_hba *phba)
  * routine from the API jump table function pointer from the lpfc_hba struct.
  *
  * Return codes
- *   0 - sucess.
+ *   0 - success.
  *   Any other value - error.
  **/
 void
@@ -3124,7 +3124,7 @@ static void lpfc_log_intr_mode(struct lpfc_hba
*phba, uint32_t intr_mode)
  * PCI devices.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3220,7 +3220,7 @@ lpfc_reset_hba(struct lpfc_hba *phba)
  * support the SLI-3 HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3321,7 +3321,7 @@ lpfc_sli_driver_resource_unset(struct lpfc_hba *phba)
  * support the SLI-4 HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3642,7 +3642,7 @@ lpfc_init_api_table_setup(struct lpfc_hba *phba,
uint8_t dev_grp)
  * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3688,7 +3688,7 @@ lpfc_setup_driver_resource_phase1(struct lpfc_hba *phba)
  * device specific resource setup to support the HBA device it attached to.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -3753,7 +3753,7 @@ lpfc_free_iocb_list(struct lpfc_hba *phba)
  * list and set up the IOCB tag array accordingly.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3872,7 +3872,7 @@ lpfc_free_active_sgl(struct lpfc_hba *phba)
  * list and set up the sgl xritag tag array accordingly.
  *
  * Return codes
- *	0 - sucessful
+ *	0 - successful
  *	other values - error
  **/
 static int
@@ -3986,7 +3986,7 @@ out_free_mem:
  * enabled and the driver is reinitializing the device.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4146,7 +4146,7 @@ lpfc_sli4_remove_rpi_hdrs(struct lpfc_hba *phba)
  * PCI device data structure is set.
  *
  * Return codes
- *      pointer to @phba - sucessful
+ *      pointer to @phba - successful
  *      NULL - error
  **/
 static struct lpfc_hba *
@@ -4202,7 +4202,7 @@ lpfc_hba_free(struct lpfc_hba *phba)
  * host with it.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      other values - error
  **/
 static int
@@ -4365,7 +4365,7 @@ lpfc_post_init_setup(struct lpfc_hba *phba)
  * with SLI-3 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -4662,7 +4662,7 @@ lpfc_sli4_bar2_register_memmap(struct lpfc_hba
*phba, uint32_t vf)
  * this routine.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - could not allocated memory.
  **/
 static int
@@ -4761,7 +4761,7 @@ lpfc_destroy_bootstrap_mbox(struct lpfc_hba *phba)
  * allocation for the port.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4861,7 +4861,7 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
  * HBA consistent with the SLI-4 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -4910,7 +4910,7 @@ lpfc_setup_endian_order(struct lpfc_hba *phba)
  * we just use some constant number as place holder.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5218,7 +5218,7 @@ out_error:
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5286,7 +5286,7 @@ lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5552,7 +5552,7 @@ out_error:
  * operation.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5599,7 +5599,7 @@ lpfc_sli4_queue_unset(struct lpfc_hba *phba)
  * Later, this can be used for all the slow-path events.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      -ENOMEM - No availble memory
  **/
 static int
@@ -5760,7 +5760,7 @@ lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
  * all resources assigned to the PCI function which originates this request.
  *
  * Return codes
- *      0 - sucessful
+ *      0 - successful
  *      ENOMEM - No availble memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -5923,7 +5923,7 @@ lpfc_sli4_fcfi_unreg(struct lpfc_hba *phba, uint16_t fcfi)
  * with SLI-4 interface spec.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -6052,7 +6052,7 @@ lpfc_sli4_pci_mem_unset(struct lpfc_hba *phba)
  * will be left with MSI-X enabled and leaks its vectors.
  *
  * Return codes
- *   0 - sucessful
+ *   0 - successful
  *   other values - error
  **/
 static int
@@ -6184,7 +6184,7 @@ lpfc_sli_disable_msix(struct lpfc_hba *phba)
  * is done in this function.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  */
 static int
@@ -6243,7 +6243,7 @@ lpfc_sli_disable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- *   0 - sucessful
+ *   0 - successful
  *   other values - error
  **/
 static uint32_t
@@ -6333,7 +6333,7 @@ lpfc_sli_disable_intr(struct lpfc_hba *phba)
  * enabled and leaks its vectors.
  *
  * Return codes
- * 0 - sucessful
+ * 0 - successful
  * other values - error
  **/
 static int
@@ -6443,7 +6443,7 @@ lpfc_sli4_disable_msix(struct lpfc_hba *phba)
  * which is done in this function.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static int
@@ -6508,7 +6508,7 @@ lpfc_sli4_disable_msi(struct lpfc_hba *phba)
  * MSI-X -> MSI -> IRQ.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	other values - error
  **/
 static uint32_t
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43cbe33..0a4bcac 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4163,7 +4163,7 @@ lpfc_sli4_read_fcoe_params(struct lpfc_hba *phba,
  * addition, this routine gets the port vpd data.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - could not allocated memory.
  **/
 static int
@@ -11091,7 +11091,7 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba)
  * sequential.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  *      EIO - The mailbox failed to complete successfully.
  * 	When this error occurs, the driver is not guaranteed
  *	to have any rpi regions posted to the device and
@@ -11129,7 +11129,7 @@ lpfc_sli4_post_all_rpi_hdrs(struct lpfc_hba *phba)
  * maps up to 64 rpi context regions.
  *
  * Return codes
- * 	0 - sucessful
+ * 	0 - successful
  * 	ENOMEM - No available memory
  *      EIO - The mailbox failed to complete successfully.
  **/
@@ -11191,7 +11191,7 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba,
struct lpfc_rpi_hdr *rpi_page)
  * PAGE_SIZE modulo 64 rpi context headers.
  *
  * Returns
- * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if sucessful
+ * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if successful
  * 	LPFC_RPI_ALLOC_ERROR if no rpis are available.
  **/
 int
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c
b/drivers/scsi/megaraid/megaraid_mbox.c
index 234f0b7..f9ae803 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2704,7 +2704,7 @@ megaraid_reset_handler(struct scsi_cmnd *scp)
 	}
 	else {
 		con_log(CL_ANN, (KERN_NOTICE
-		"megaraid mbox: reset sequence completed sucessfully\n"));
+		"megaraid mbox: reset sequence completed successfully\n"));
 	}


diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 86ab32d..756e509 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2894,7 +2894,7 @@ _scsih_normalize_sense(char *sense_buffer,
struct sense_info *data)

 #ifdef CONFIG_SCSI_MPT2SAS_LOGGING
 /**
- * _scsih_scsi_ioc_info - translated non-succesfull SCSI_IO request
+ * _scsih_scsi_ioc_info - translated non-successfull SCSI_IO request
  * @ioc: per adapter object
  * @scmd: pointer to scsi command object
  * @mpi_reply: reply mf payload returned from firmware
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f7c70e2..d3d39f8 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3342,7 +3342,7 @@ static int pmcraid_chr_fasync(int fd, struct
file *filep, int mode)
  * @direction : data transfer direction
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static int pmcraid_build_passthrough_ioadls(
 	struct pmcraid_cmd *cmd,
@@ -3401,7 +3401,7 @@ static int pmcraid_build_passthrough_ioadls(
  * @direction: data transfer direction
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static void pmcraid_release_passthrough_ioadls(
 	struct pmcraid_cmd *cmd,
@@ -3429,7 +3429,7 @@ static void pmcraid_release_passthrough_ioadls(
  * @arg: pointer to pmcraid_passthrough_buffer user buffer
  *
  * Return value
- *  0 on sucess, non-zero error code on failure
+ *  0 on success, non-zero error code on failure
  */
 static long pmcraid_ioctl_passthrough(
 	struct pmcraid_instance *pinstance,
diff --git a/drivers/scsi/scsi_netlink.c b/drivers/scsi/scsi_netlink.c
index 723fdec..0fd6ae6 100644
--- a/drivers/scsi/scsi_netlink.c
+++ b/drivers/scsi/scsi_netlink.c
@@ -613,7 +613,7 @@ EXPORT_SYMBOL_GPL(scsi_nl_send_transport_msg);
  * @data_buf:		pointer to vendor unique data buffer
  *
  * Returns:
- *   0 on succesful return
+ *   0 on successful return
  *   otherwise, failing error code
  *
  * Notes:
diff --git a/drivers/scsi/scsi_transport_sas.c
b/drivers/scsi/scsi_transport_sas.c
index fd47cb1..f27e52d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -666,7 +666,7 @@ EXPORT_SYMBOL(sas_phy_add);
  *
  * Note:
  *   This function must only be called on a PHY that has not
- *   sucessfully been added using sas_phy_add().
+ *   successfully been added using sas_phy_add().
  */
 void sas_phy_free(struct sas_phy *phy)
 {
@@ -896,7 +896,7 @@ EXPORT_SYMBOL(sas_port_add);
  *
  * Note:
  *   This function must only be called on a PORT that has not
- *   sucessfully been added using sas_port_add().
+ *   successfully been added using sas_port_add().
  */
 void sas_port_free(struct sas_port *port)
 {
@@ -1476,7 +1476,7 @@ EXPORT_SYMBOL(sas_rphy_add);
  *
  * Note:
  *   This function must only be called on a remote
- *   PHY that has not sucessfully been added using
+ *   PHY that has not successfully been added using
  *   sas_rphy_add() (or has been sas_rphy_remove()'d)
  */
 void sas_rphy_free(struct sas_rphy *rphy)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c
b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 45374d6..2b38f6a 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1864,7 +1864,7 @@ static pci_ers_result_t sym2_io_slot_dump(struct
pci_dev *pdev)
  *
  * This routine is similar to sym_set_workarounds(), except
  * that, at this point, we already know that the device was
- * succesfully intialized at least once before, and so most
+ * successfully intialized at least once before, and so most
  * of the steps taken there are un-needed here.
  */
 static void sym2_reset_workarounds(struct pci_dev *pdev)
diff --git a/drivers/serial/ucc_uart.c b/drivers/serial/ucc_uart.c
index 0c08f28..46de564 100644
--- a/drivers/serial/ucc_uart.c
+++ b/drivers/serial/ucc_uart.c
@@ -313,7 +313,7 @@ static void qe_uart_stop_tx(struct uart_port *port)
  * This function will attempt to stuff of all the characters from the
  * kernel's transmit buffer into TX BDs.
  *
- * A return value of non-zero indicates that it sucessfully stuffed all
+ * A return value of non-zero indicates that it successfully stuffed all
  * characters from the kernel buffer.
  *
  * A return value of zero indicates that there are still characters in the
diff --git a/drivers/staging/altpciechdma/altpciechdma.c
b/drivers/staging/altpciechdma/altpciechdma.c
index e0c5ba4..2f07dd4 100644
--- a/drivers/staging/altpciechdma/altpciechdma.c
+++ b/drivers/staging/altpciechdma/altpciechdma.c
@@ -212,7 +212,7 @@ struct ape_dev {
 	int msi_enabled;
 	/* whether this driver could obtain the regions */
 	int got_regions;
-	/* irq line succesfully requested by this driver, -1 otherwise */
+	/* irq line successfully requested by this driver, -1 otherwise */
 	int irq_line;
 	/* board revision */
 	u8 revision;
@@ -336,7 +336,7 @@ static int __devinit map_bars(struct ape_dev *ape,
struct pci_dev *dev)
 		printk(KERN_DEBUG "BAR[%d] mapped at 0x%p with length %lu(/%lu).\n", i,
 		ape->bar[i], bar_min_len[i], bar_length);
 	}
-	/* succesfully mapped all required BAR regions */
+	/* successfully mapped all required BAR regions */
 	rc = 0;
 	goto success;
 fail:
@@ -911,7 +911,7 @@ static int __devinit probe(struct pci_dev *dev,
const struct pci_device_id *id)
 	/* perform DMA engines loop back test */
 	rc = dma_test(ape, dev);
 	(void)rc;
-	/* succesfully took the device */
+	/* successfully took the device */
 	rc = 0;
 	printk(KERN_DEBUG "probe() successful.\n");
 	goto end;
diff --git a/drivers/staging/comedi/drivers/me4000.c
b/drivers/staging/comedi/drivers/me4000.c
index 6079913..8b9fa0f 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -840,7 +840,7 @@ static int xilinx_download(struct comedi_device *dev)
 		       "comedi%d: me4000: xilinx_download(): DONE flag is not set\n",
 		       dev->minor);
 		printk(KERN_ERR
-		       "comedi%d: me4000: xilinx_download(): Download not succesful\n",
+		       "comedi%d: me4000: xilinx_download(): Download not successful\n",
 		       dev->minor);
 		return -EIO;
 	}
diff --git a/drivers/staging/dst/export.c b/drivers/staging/dst/export.c
index 4fbd848..a4ed16c 100644
--- a/drivers/staging/dst/export.c
+++ b/drivers/staging/dst/export.c
@@ -202,7 +202,7 @@ err_out_exit:
  * so to play good with all cases we just queue BIO into the queue
  * and wake up processing thread, which gets completed request and
  * send (encrypting if needed) it back to the client (if it was a read
- * request), or sends back reply that writing succesfully completed.
+ * request), or sends back reply that writing successfully completed.
  */
 static int dst_export_process_request_queue(struct dst_state *st)
 {
diff --git a/drivers/staging/hv/hv_api.h b/drivers/staging/hv/hv_api.h
index 251e2d1..9eb818e 100644
--- a/drivers/staging/hv/hv_api.h
+++ b/drivers/staging/hv/hv_api.h
@@ -316,13 +316,13 @@

 /*
  * HV_STATUS_VMX_INSTRUCTION_FAILED
- * The requested VMX instruction failed to complete succesfully.
+ * The requested VMX instruction failed to complete successfully.
  */
 #define HV_STATUS_VMX_INSTRUCTION_FAILED		((u16)0x1011)

 /*
  * HV_STATUS_VMX_INSTRUCTION_FAILED_WITH_STATUS
- * The requested VMX instruction failed to complete succesfully indicating
+ * The requested VMX instruction failed to complete successfully indicating
  * status.
  */
 #define HV_STATUS_VMX_INSTRUCTION_FAILED_WITH_STATUS	((u16)0x1012)
diff --git a/drivers/staging/octeon/cvmx-pow.h
b/drivers/staging/octeon/cvmx-pow.h
index c5d66f2..bf9e069 100644
--- a/drivers/staging/octeon/cvmx-pow.h
+++ b/drivers/staging/octeon/cvmx-pow.h
@@ -1959,7 +1959,7 @@ static inline uint32_t
cvmx_pow_tag_get_hw_bits(uint64_t tag)
  * @buffer_size:
  *               The size of the supplied buffer
  *
- * Returns Zero on sucess, negative on failure
+ * Returns Zero on success, negative on failure
  */
 extern int cvmx_pow_capture(void *buffer, int buffer_size);

diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c
b/drivers/staging/quatech_usb2/quatech_usb2.c
index 2acef94..81877e7 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -1670,7 +1670,7 @@ __func__);
 		dbg("%s(): failed resubmitting read urb, error %d",
 			__func__, result);
 	} else {
-		dbg("%s() sucessfully resumitted read urb", __func__);
+		dbg("%s() successfully resumitted read urb", __func__);
 		if (tty_st && RxCount) {
 			/* if some inbound data was processed, then
 			 * we need to push that through the tty layer
diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index 9805d74..24700b1 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -66,7 +66,7 @@ static int __init rar_init_handler(void);
 static void __exit rar_exit_handler(void);

 /*
-  function that is activated on the succesfull probe of the RAR device
+  function that is activated on the successfull probe of the RAR device
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct
pci_device_id *ent);

@@ -319,7 +319,7 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 }

 /*
-  function that is activaed on the succesfull probe of the RAR device
+  function that is activaed on the successfull probe of the RAR device
 */
 static int __devinit rar_probe(struct pci_dev *pdev, const struct
pci_device_id *ent)
 {
diff --git a/drivers/staging/rt2860/common/rtmp_init.c
b/drivers/staging/rt2860/common/rtmp_init.c
index 20c2ce2..0e10e23 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -2691,7 +2691,7 @@ VOID NICUpdateFifoStaCounters(

 				pEntry->FIFOCount = 0;
 				pEntry->OneSecTxNoRetryOkCount++;
-				// update NoDataIdleCount when sucessful send packet to STA.
+				// update NoDataIdleCount when successful send packet to STA.
 				pEntry->NoDataIdleCount = 0;
 				pEntry->ContinueTxFailCnt = 0;
 			}
diff --git a/drivers/staging/rt2860/sta/connect.c
b/drivers/staging/rt2860/sta/connect.c
index 7bc75ab..0dae822 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -58,8 +58,8 @@ UCHAR	CipherSuiteWpaNoneAes[] = {
 		};
 UCHAR	CipherSuiteWpaNoneAesLen = (sizeof(CipherSuiteWpaNoneAes) /
sizeof(UCHAR));

-// The following MACRO is called after 1. starting an new IBSS, 2.
succesfully JOIN an IBSS,
-// or 3. succesfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
+// The following MACRO is called after 1. starting an new IBSS, 2.
successfully JOIN an IBSS,
+// or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
 // All settings successfuly negotiated furing MLME state machines
become final settings
 // and are copied to pAd->StaActive
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)
                  \
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c
b/drivers/staging/rt2860/sta/rtmp_data.c
index f751ab6..6df1fe2 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -898,7 +898,7 @@ Arguments:
 	pPacket 	Pointer to send packet

 Return Value:
-	NDIS_STATUS_SUCCESS			If succes to queue the packet into TxSwQueue.
+	NDIS_STATUS_SUCCESS			If success to queue the packet into TxSwQueue.
 	NDIS_STATUS_FAILURE			If failed to do en-queue.

 Note:
diff --git a/drivers/staging/rt2860/sta/wpa.c b/drivers/staging/rt2860/sta/wpa.c
index 8c34e39..dc3e6e2 100644
--- a/drivers/staging/rt2860/sta/wpa.c
+++ b/drivers/staging/rt2860/sta/wpa.c
@@ -276,7 +276,7 @@ VOID WpaEAPOLKeyAction(
 			DBGPRINT(RT_DEBUG_TRACE, ("Receive EAPOL Key Group Message 1\n"));
 		}

-		// We will assume link is up (assoc suceess and port not secured).
+		// We will assume link is up (assoc success and port not secured).
 		// All state has to be able to process message from previous state
 		switch(pAd->StaCfg.WpaState)
 		{
@@ -366,7 +366,7 @@ VOID WpaEAPOLKeyAction(
 			DBGPRINT(RT_DEBUG_TRACE, ("Receive EAPOL Key Group Message 1\n"));
 		}

-		// We will assume link is up (assoc suceess and port not secured).
+		// We will assume link is up (assoc success and port not secured).
 		// All state has to be able to process message from previous state
 		switch(pAd->StaCfg.WpaState)
 		{
diff --git a/drivers/staging/rt3090/common/rtmp_init.c
b/drivers/staging/rt3090/common/rtmp_init.c
index 48b95b7..04b54fc 100644
--- a/drivers/staging/rt3090/common/rtmp_init.c
+++ b/drivers/staging/rt3090/common/rtmp_init.c
@@ -2111,7 +2111,7 @@ VOID NICUpdateFifoStaCounters(
 #endif // DOT11_N_SUPPORT //
 				pEntry->FIFOCount = 0;
 				pEntry->OneSecTxNoRetryOkCount++;
-				// update NoDataIdleCount when sucessful send packet to STA.
+				// update NoDataIdleCount when successful send packet to STA.
 				pEntry->NoDataIdleCount = 0;
 				pEntry->ContinueTxFailCnt = 0;
 #ifdef WDS_SUPPORT
diff --git a/drivers/staging/rt3090/sta/connect.c
b/drivers/staging/rt3090/sta/connect.c
index 4aa35ee..583d6ee 100644
--- a/drivers/staging/rt3090/sta/connect.c
+++ b/drivers/staging/rt3090/sta/connect.c
@@ -60,8 +60,8 @@ UCHAR	CipherSuiteWpaNoneAes[] = {
 		};
 UCHAR	CipherSuiteWpaNoneAesLen = (sizeof(CipherSuiteWpaNoneAes) /
sizeof(UCHAR));

-// The following MACRO is called after 1. starting an new IBSS, 2.
succesfully JOIN an IBSS,
-// or 3. succesfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
+// The following MACRO is called after 1. starting an new IBSS, 2.
successfully JOIN an IBSS,
+// or 3. successfully ASSOCIATE to a BSS, 4. successfully RE_ASSOCIATE to a BSS
 // All settings successfuly negotiated furing MLME state machines
become final settings
 // and are copied to pAd->StaActive
 #define COPY_SETTINGS_FROM_MLME_AUX_TO_ACTIVE_CFG(_pAd)
                  \
diff --git a/drivers/staging/rt3090/sta/rtmp_data.c
b/drivers/staging/rt3090/sta/rtmp_data.c
index 5591364..c1b83be 100644
--- a/drivers/staging/rt3090/sta/rtmp_data.c
+++ b/drivers/staging/rt3090/sta/rtmp_data.c
@@ -981,7 +981,7 @@ Arguments:
 	pPacket		Pointer to send packet

 Return Value:
-	NDIS_STATUS_SUCCESS			If succes to queue the packet into TxSwQueue.
+	NDIS_STATUS_SUCCESS			If success to queue the packet into TxSwQueue.
 	NDIS_STATUS_FAILURE			If failed to do en-queue.

 Note:
diff --git a/drivers/staging/rt3090/sta_ioctl.c
b/drivers/staging/rt3090/sta_ioctl.c
index b8ab84a..b1c2b5a 100644
--- a/drivers/staging/rt3090/sta_ioctl.c
+++ b/drivers/staging/rt3090/sta_ioctl.c
@@ -5000,7 +5000,7 @@ INT RTMPQueryInformation(
                 // add the most up-to-date h/w raw counters into
software counters
 			    NICUpdateRawCounters(pAd);

-                // Sanity check for calculation of sucessful count
+                // Sanity check for calculation of successful count
                 if
(pAd->WlanCounters.TransmittedFragmentCount.QuadPart <
pAd->WlanCounters.RetryCount.QuadPart)

pAd->WlanCounters.TransmittedFragmentCount.QuadPart =
pAd->WlanCounters.RetryCount.QuadPart;

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index f890a16..be19afe 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2447,7 +2447,7 @@ static void sep_configure_dma_burst(struct
sep_device *sep)
 #endif

 /*
-  Function that is activaed on the succesful probe of the SEP device
+  Function that is activaed on the successful probe of the SEP device
 */
 static int __devinit sep_probe(struct pci_dev *pdev, const struct
pci_device_id *ent)
 {
diff --git a/drivers/staging/vt6655/device_main.c
b/drivers/staging/vt6655/device_main.c
index 53450b4..0db8d7b 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -661,7 +661,7 @@ else
    if(zonetype!=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
       printk("zonetype in file[%02x] mismatch with in
EEPROM[%02x]\n",zonetype,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
    else
-      printk("Read Zonetype file sucess,use default zonetype
setting[%02x]\n",zonetype);
+      printk("Read Zonetype file success,use default zonetype
setting[%02x]\n",zonetype);
  }
  	}
   else
diff --git a/drivers/staging/vt6655/ioctl.c b/drivers/staging/vt6655/ioctl.c
index fc9cbe0..b15ce8a 100644
--- a/drivers/staging/vt6655/ioctl.c
+++ b/drivers/staging/vt6655/ioctl.c
@@ -692,7 +692,7 @@ if(wpa_Result.authenticated==TRUE) {
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
    #endif
-         pDevice->fWPA_Authened = TRUE;           //is sucessful peer
to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = TRUE;           //is successful
peer to wpa_Result.authenticated?
 }

         //printk("get private wpa_supplicant announce WPA SM\n");
diff --git a/drivers/staging/vt6655/mib.h b/drivers/staging/vt6655/mib.h
index 69e04f7..2aa2b91 100644
--- a/drivers/staging/vt6655/mib.h
+++ b/drivers/staging/vt6655/mib.h
@@ -325,10 +325,10 @@ typedef struct tagSStatCounter {
    #ifdef Calcu_LinkQual
        //Tx count:
     ULONG TxNoRetryOkCount;         //success tx no retry !
-    ULONG TxRetryOkCount;              //sucess tx but retry !
+    ULONG TxRetryOkCount;              //success tx but retry !
     ULONG TxFailCount;                      //fail tx ?
       //Rx count:
-    ULONG RxOkCnt;                          //sucess rx !
+    ULONG RxOkCnt;                          //success rx !
     ULONG RxFcsErrCnt;                    //fail rx ?
       //statistic
     ULONG SignalStren;
diff --git a/drivers/staging/vt6656/baseband.c
b/drivers/staging/vt6656/baseband.c
index 820a7b8..49f419e 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1041,7 +1041,7 @@ else {
    if(pDevice->config_file.ZoneType !=pDevice->abyEEPROM[EEP_OFS_ZONETYPE])
       printk("zonetype in file[%02x] mismatch with in
EEPROM[%02x]\n",pDevice->config_file.ZoneType,pDevice->abyEEPROM[EEP_OFS_ZONETYPE]);
    else
-      printk("Read Zonetype file sucess,use default zonetype
setting[%02x]\n",pDevice->config_file.ZoneType);
+      printk("Read Zonetype file success,use default zonetype
setting[%02x]\n",pDevice->config_file.ZoneType);
  }
 }

diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index d94131f..76dcb5e 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -679,7 +679,7 @@ if(wpa_Result.authenticated==TRUE) {
      wireless_send_event(pDevice->dev, IWEVCUSTOM, &wrqu, pItemSSID->abySSID);
    }
    #endif
-         pDevice->fWPA_Authened = TRUE;           //is sucessful peer
to wpa_Result.authenticated?
+         pDevice->fWPA_Authened = TRUE;           //is successful
peer to wpa_Result.authenticated?
 }

         //printk("get private wpa_supplicant announce WPA SM\n");
diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index aa8d1a2..b7c6a22 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1724,7 +1724,7 @@ int iwctl_siwauth(struct net_device *dev,
 	case IW_AUTH_WPA_ENABLED:
 		//pDevice->bWPADEVUp = !! wrq->value;
 		//if(pDevice->bWPADEVUp==TRUE)
-		  // printk("iwctl_siwauth:set WPADEV to enable sucessful*******\n");
+		  // printk("iwctl_siwauth:set WPADEV to enable successful*******\n");
 		//else
 		 //  printk("iwctl_siwauth:set WPADEV to enable fail?????\n");
 		break;
diff --git a/drivers/staging/vt6656/main_usb.c
b/drivers/staging/vt6656/main_usb.c
index 7f96bca..fefec79 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1546,7 +1546,7 @@ if(result!=0) {
   return buffer;
 }

-//return --->-1:fail;  >=0:sucessful
+//return --->-1:fail;  >=0:successful
 static int Read_config_file(PSDevice pDevice) {
   int result=0;
   UCHAR      tmpbuffer[100];
diff --git a/drivers/staging/vt6656/mib.h b/drivers/staging/vt6656/mib.h
index b806b4d..ac996d2 100644
--- a/drivers/staging/vt6656/mib.h
+++ b/drivers/staging/vt6656/mib.h
@@ -357,10 +357,10 @@ typedef struct tagSStatCounter {
    #ifdef Calcu_LinkQual
        //Tx count:
     ULONG TxNoRetryOkCount;         //success tx no retry !
-    ULONG TxRetryOkCount;              //sucess tx but retry !
+    ULONG TxRetryOkCount;              //success tx but retry !
     ULONG TxFailCount;                      //fail tx ?
       //Rx count:
-    ULONG RxOkCnt;                          //sucess rx !
+    ULONG RxOkCnt;                          //success rx !
     ULONG RxFcsErrCnt;                    //fail rx ?
       //statistic
     ULONG SignalStren;
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 6912344..f0dfcd0 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -1332,7 +1332,7 @@ BSSvSecondTxData(
     }

   spin_lock_irq(&pDevice->lock);
-  //is wap_supplicant running sucessful OR only open && sharekey mode!
+  //is wap_supplicant running successful OR only open && sharekey mode!
   #if 1
   if(((pDevice->bLinkPass ==TRUE)&&(pMgmt->eAuthenMode <
WMAC_AUTH_WPA)) ||  //open && sharekey linking
       (pDevice->fWPA_Authened == TRUE)) {   //wpa linking
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index da718e8..e80f1af 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1890,7 +1890,7 @@ static void cancel_async_set_config(struct
usb_device *udev)
  * routine gets around the normal restrictions by using a work thread to
  * submit the change-config request.
  *
- * Returns 0 if the request was succesfully queued, error code otherwise.
+ * Returns 0 if the request was successfully queued, error code otherwise.
  * The caller has no way to know whether the queued request will eventually
  * succeed.
  */
diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index 7953948..4e36578 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -432,7 +432,7 @@ static void acm_disable(struct usb_function *f)
  * @length: size of data
  * Context: irqs blocked, acm->lock held, acm_notify_req non-null
  *
- * Returns zero on sucess or a negative errno.
+ * Returns zero on success or a negative errno.
  *
  * See section 6.3.5 of the CDC 1.1 specification for information
  * about the only notification we issue:  SerialState change.
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 1937d8c..adda120 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1524,7 +1524,7 @@ static int pxa_udc_get_frame(struct usb_gadget *_gadget)
  * pxa_udc_wakeup - Force udc device out of suspend
  * @_gadget: usb gadget
  *
- * Returns 0 if succesfull, error code otherwise
+ * Returns 0 if successfull, error code otherwise
  */
 static int pxa_udc_wakeup(struct usb_gadget *_gadget)
 {
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 62a226b..00a2985 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -627,7 +627,7 @@ irqreturn_t fhci_irq(struct usb_hcd *hcd)


 /*
- * Process normal completions(error or sucess) and clean the schedule.
+ * Process normal completions(error or success) and clean the schedule.
  *
  * This is the main path for handing urbs back to drivers. The only other patth
  * is process_del_list(),which unlinks URBs by scanning EDs,instead of scanning
diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
index 9ec7fd5..9579cf4 100644
--- a/drivers/usb/wusbcore/crypto.c
+++ b/drivers/usb/wusbcore/crypto.c
@@ -111,7 +111,7 @@ struct aes_ccm_b1 {
  *
  * CCM uses Ax blocks to generate a keystream with which the MIC and
  * the message's payload are encoded. A0 always encrypts/decrypts the
- * MIC. Ax (x>0) are used for the sucesive payload blocks.
+ * MIC. Ax (x>0) are used for the successive payload blocks.
  *
  * The x is the counter, and is increased for each block.
  */
diff --git a/drivers/usb/wusbcore/wa-xfer.c b/drivers/usb/wusbcore/wa-xfer.c
index 613a5fc..489b478 100644
--- a/drivers/usb/wusbcore/wa-xfer.c
+++ b/drivers/usb/wusbcore/wa-xfer.c
@@ -558,7 +558,7 @@ static void wa_seg_dto_cb(struct urb *urb)
 /*
  * Callback for the segment request
  *
- * If succesful transition state (unless already transitioned or
+ * If successful transition state (unless already transitioned or
  * outbound transfer); otherwise, take a note of the error, mark this
  * segment done and try completion.
  *
@@ -1364,7 +1364,7 @@ segment_aborted:
 /*
  * Callback for the IN data phase
  *
- * If succesful transition state; otherwise, take a note of the
+ * If successful transition state; otherwise, take a note of the
  * error, mark this segment done and try completion.
  *
  * Note we don't access until we are sure that the transfer hasn't
diff --git a/drivers/uwb/i1480/dfu/usb.c b/drivers/uwb/i1480/dfu/usb.c
index c7080d4..0bb665a 100644
--- a/drivers/uwb/i1480/dfu/usb.c
+++ b/drivers/uwb/i1480/dfu/usb.c
@@ -229,7 +229,7 @@ void i1480_usb_neep_cb(struct urb *urb)
  * will verify it.
  *
  * Set i1480->evt_result with the result of getting the event or its
- * size (if succesful).
+ * size (if successful).
  *
  * Delivers the data directly to i1480->evt_buf
  */
diff --git a/drivers/uwb/wlp/txrx.c b/drivers/uwb/wlp/txrx.c
index 86a853b..7350ed6 100644
--- a/drivers/uwb/wlp/txrx.c
+++ b/drivers/uwb/wlp/txrx.c
@@ -282,7 +282,7 @@ EXPORT_SYMBOL_GPL(wlp_receive_frame);
  *         and transmission will be done by the calling function.
  * @dst:   On return this will contain the device address to which the
  *         frame is destined.
- * @returns: 0 on success no tx : WLP header sucessfully applied to skb buffer,
+ * @returns: 0 on success no tx : WLP header successfully applied to
skb buffer,
  *                                calling function can proceed with tx
  *           1 on success with tx : WLP will take over transmission of this
  *                                  frame
diff --git a/drivers/watchdog/wdrtas.c b/drivers/watchdog/wdrtas.c
index 3bde56b..5bfb1f2 100644
--- a/drivers/watchdog/wdrtas.c
+++ b/drivers/watchdog/wdrtas.c
@@ -542,7 +542,7 @@ static struct notifier_block wdrtas_notifier = {
 /**
  * wdrtas_get_tokens - reads in RTAS tokens
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * wdrtas_get_tokens reads in the tokens for the RTAS calls used in
  * this watchdog driver. It tolerates, if "get-sensor-state" and
@@ -598,7 +598,7 @@ static void wdrtas_unregister_devs(void)
 /**
  * wdrtas_register_devs - registers the misc dev handlers
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * wdrtas_register_devs registers the watchdog and temperature watchdog
  * misc devs
@@ -630,7 +630,7 @@ static int wdrtas_register_devs(void)
 /**
  * wdrtas_init - init function of the watchdog driver
  *
- * returns 0 on succes, <0 on failure
+ * returns 0 on success, <0 on failure
  *
  * registers the file handlers and the reboot notifier
  */
diff --git a/fs/bio.c b/fs/bio.c
index 402cb84..a82f389 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(bio_init);
  *   for a &struct bio to become free. If a %NULL @bs is passed in, we will
  *   fall back to just using @kmalloc to allocate the required memory.
  *
- *   Note that the caller must set ->bi_destructor on succesful return
+ *   Note that the caller must set ->bi_destructor on successful return
  *   of a bio, to do the appropriate freeing of the bio once the reference
  *   count drops to zero.
  **/
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 2c726b7..6815d2a 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -256,7 +256,7 @@ out:
  * Insert @em into @tree or perform a simple forward/backward merge with
  * existing mappings.  The extent_map struct passed in will be inserted
  * into the tree directly, with an additional reference taken, or a
- * reference dropped if the merge attempt was sucessfull.
+ * reference dropped if the merge attempt was successfull.
  */
 int add_extent_mapping(struct extent_map_tree *tree,
 		       struct extent_map *em)
diff --git a/fs/dlm/plock.c b/fs/dlm/plock.c
index 16f682e..b540aa5 100644
--- a/fs/dlm/plock.c
+++ b/fs/dlm/plock.c
@@ -143,7 +143,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(dlm_posix_lock);

-/* Returns failure iff a succesful lock operation should be canceled */
+/* Returns failure iff a successful lock operation should be canceled */
 static int dlm_plock_callback(struct plock_op *op)
 {
 	struct file *file;
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 1a80301..378991c 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -931,7 +931,7 @@ static inline int read_unknown(struct
jffs2_sb_info *c, struct jffs2_raw_node_re
  * Helper function for jffs2_get_inode_nodes().
  * The function detects whether more data should be read and reads it if yes.
  *
- * Returns: 0 on succes;
+ * Returns: 0 on success;
  * 	    negative error code on failure.
  */
 static int read_more(struct jffs2_sb_info *c, struct jffs2_raw_node_ref *ref,
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 663c0e3..5397396 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1281,7 +1281,7 @@ rl_not_mapped_enoent:

 /*
  * Copy as much as we can into the pages and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then clear the pages
+ * were successfully copied.  If a fault is encountered then clear the pages
  * out to (ofs + bytes) and return the number of bytes which were copied.
  */
 static inline size_t ntfs_copy_from_user(struct page **pages,
diff --git a/fs/ntfs/logfile.c b/fs/ntfs/logfile.c
index 89b0298..4dadcdf 100644
--- a/fs/ntfs/logfile.c
+++ b/fs/ntfs/logfile.c
@@ -338,7 +338,7 @@ err_out:
  * copy of the complete multi sector transfer deprotected page.  On failure,
  * *@wrp is undefined.
  *
- * Simillarly, if @lsn is not NULL, on succes *@lsn will be set to the current
+ * Simillarly, if @lsn is not NULL, on success *@lsn will be set to the current
  * logfile lsn according to this restart page.  On failure, *@lsn is undefined.
  *
  * The following error codes are defined:
diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 38a42f5..7c7198a 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2398,7 +2398,7 @@ static int ocfs2_leftmost_rec_contains(struct
ocfs2_extent_list *el, u32 cpos)
  *
  * The array is assumed to be large enough to hold an entire path (tree depth).
  *
- * Upon succesful return from this function:
+ * Upon successful return from this function:
  *
  * - The 'right_path' array will contain a path to the leaf block
  *   whose range contains e_cpos.
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index 0d38d67..c5e4a49 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -1855,7 +1855,7 @@ int ocfs2_file_lock(struct file *file, int ex,
int trylock)
 		 * outstanding lock request, so a cancel convert is
 		 * required. We intentionally overwrite 'ret' - if the
 		 * cancel fails and the lock was granted, it's easier
-		 * to just bubble sucess back up to the user.
+		 * to just bubble success back up to the user.
 		 */
 		ret = ocfs2_flock_handle_signal(lockres, level);
 	} else if (!ret && (level > lockres->l_level)) {
diff --git a/fs/omfs/bitmap.c b/fs/omfs/bitmap.c
index e1c0ec0..0822345 100644
--- a/fs/omfs/bitmap.c
+++ b/fs/omfs/bitmap.c
@@ -85,7 +85,7 @@ out:
 }

 /*
- * Tries to allocate exactly one block.  Returns true if sucessful.
+ * Tries to allocate exactly one block.  Returns true if successful.
  */
 int omfs_allocate_block(struct super_block *sb, u64 block)
 {
diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index f94ddf7..868a55e 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -23,7 +23,7 @@
 /*
  * This file implements functions needed to recover from unclean un-mounts.
  * When UBIFS is mounted, it checks a flag on the master node to determine if
- * an un-mount was completed sucessfully. If not, the process of mounting
+ * an un-mount was completed successfully. If not, the process of mounting
  * incorparates additional checking and fixing of on-flash data structures.
  * UBIFS always cleans away all remnants of an unclean un-mount, so that
  * errors do not accumulate. However UBIFS defers recovery if it is mounted
diff --git a/include/linux/pktcdvd.h b/include/linux/pktcdvd.h
index 6c0d7cf..4434453 100644
--- a/include/linux/pktcdvd.h
+++ b/include/linux/pktcdvd.h
@@ -30,7 +30,7 @@

 /*
  * use drive write caching -- we need deferred error handling to be
- * able to sucessfully recover with this option (drive will return good
+ * able to successfully recover with this option (drive will return good
  * status as soon as the cdb is validated).
  */
 #if defined(CONFIG_CDROM_PKTCDVD_WCACHE)
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 03a49c7..1827e7f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1260,7 +1260,7 @@ static inline struct sk_buff
*tcp_write_queue_prev(struct sock *sk, struct sk_bu
 	skb_queue_walk_from_safe(&(sk)->sk_write_queue, skb, tmp)

 /* This function calculates a "timeout" which is equivalent to the timeout of a
- * TCP connection after "boundary" unsucessful, exponentially backed-off
+ * TCP connection after "boundary" unsuccessful, exponentially backed-off
  * retransmissions with an initial RTO of TCP_RTO_MIN.
  */
 static inline bool retransmits_timed_out(const struct sock *sk,
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a69d4ed..b1d0e10 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -420,7 +420,7 @@ static void perf_event_remove_from_context(struct
perf_event *event)
 	if (!task) {
 		/*
 		 * Per cpu events are removed via an smp call and
-		 * the removal is always sucessful.
+		 * the removal is always successful.
 		 */
 		smp_call_function_single(event->cpu,
 					 __perf_event_remove_from_context,
@@ -828,7 +828,7 @@ perf_install_in_context(struct perf_event_context *ctx,
 	if (!task) {
 		/*
 		 * Per cpu events are installed via an smp call and
-		 * the install is always sucessful.
+		 * the install is always successful.
 		 */
 		smp_call_function_single(cpu, __perf_install_in_context,
 					 event, 1);
diff --git a/mm/filemap.c b/mm/filemap.c
index ef169f3..c3d3506 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1844,7 +1844,7 @@ static size_t __iovec_copy_from_user_inatomic(char *vaddr,

 /*
  * Copy as much as we can into the page and return the number of bytes which
- * were sucessfully copied.  If a fault is encountered then return
the number of
+ * were successfully copied.  If a fault is encountered then return
the number of
  * bytes which were copied.
  */
 size_t iov_iter_copy_from_user_atomic(struct page *page,
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 751c4d0..719ddbc 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -244,7 +244,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx,
struct ieee80211_sub_if_data
  * @addr: destination address of the path (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 on sucess
+ * Returns: 0 on success
  *
  * State: the initial state of the new path is set to 0
  */
@@ -530,7 +530,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
  * @addr: dst address (ETH_ALEN length)
  * @sdata: local subif
  *
- * Returns: 0 if succesful
+ * Returns: 0 if successful
  */
 int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/netlabel/netlabel_domainhash.c
b/net/netlabel/netlabel_domainhash.c
index 7a10bbe..c5d9f97 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -682,7 +682,7 @@ struct netlbl_domaddr6_map
*netlbl_domhsh_getentry_af6(const char *domain,
  * buckets and @skip_chain entries.  For each entry in the table call
  * @callback, if @callback returns a negative value stop 'walking' through the
  * table and return.  Updates the values in @skip_bkt and @skip_chain on
- * return.  Returns zero on succcess, negative values on failure.
+ * return.  Returns zero on success, negative values on failure.
  *
  */
 int netlbl_domhsh_walk(u32 *skip_bkt,
diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 8674d49..29d8501 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -719,7 +719,7 @@ static void sctp_cmd_new_state(sctp_cmd_seq_t *cmds,

 	if (sctp_style(sk, TCP)) {
 		/* Change the sk->sk_state of a TCP-style socket that has
-		 * sucessfully completed a connect() call.
+		 * successfully completed a connect() call.
 		 */
 		if (sctp_state(asoc, ESTABLISHED) && sctp_sstate(sk, CLOSED))
 			sk->sk_state = SCTP_SS_ESTABLISHED;
diff --git a/net/wimax/op-reset.c b/net/wimax/op-reset.c
index ca26917..35f3700 100644
--- a/net/wimax/op-reset.c
+++ b/net/wimax/op-reset.c
@@ -62,7 +62,7 @@
  * Called when wanting to reset the device for any reason. Device is
  * taken back to power on status.
  *
- * This call blocks; on succesful return, the device has completed the
+ * This call blocks; on successful return, the device has completed the
  * reset process and is ready to operate.
  */
 int wimax_reset(struct wimax_dev *wimax_dev)
diff --git a/security/selinux/netlabel.c b/security/selinux/netlabel.c
index e688237..2534400 100644
--- a/security/selinux/netlabel.c
+++ b/security/selinux/netlabel.c
@@ -204,7 +204,7 @@ int selinux_netlbl_skbuff_getsid(struct sk_buff *skb,
  *
  * Description
  * Call the NetLabel mechanism to set the label of a packet using @sid.
- * Returns zero on auccess, negative values on failure.
+ * Returns zero on success, negative values on failure.
  *
  */
 int selinux_netlbl_skbuff_setsid(struct sk_buff *skb,
diff --git a/sound/sound_core.c b/sound/sound_core.c
index 49c9981..dbca7c9 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -353,7 +353,7 @@ static struct sound_unit *chains[SOUND_STEP];
  *      @dev: device pointer
  *
  *	Allocate a special sound device by minor number from the sound
- *	subsystem. The allocated number is returned on succes. On failure
+ *	subsystem. The allocated number is returned on success. On failure
  *	a negative error code is returned.
  */

-- 
1.6.5.2.101.gcd0f8
