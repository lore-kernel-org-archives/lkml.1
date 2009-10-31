Return-Path: <linux-kernel-owner+w=401wt.eu-S932513AbZJaJlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513AbZJaJlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZJaJlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:44 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbZJaJlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=VtiDN5MhaVqrdxBk1MO1mv/eqdTWBEGDCtoszVJDZJnif6wnfFdLxoCrpSZbnI1z43
         puRWktEN2+ra2EdcpUSg1cg1FtzyQv1LRzGY8YKCOVA0jsCI1tS7l80Aj2Od1Gyu8T9R
         SJIJlSYzHYxTh+jIdu6qjHCbYyIZI3cRDjvNM=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:26 -0200
Message-ID: <b8bf37780910310241j1694270bo2712428226659d2c@mail.gmail.com>
Subject: [PATCH 09/16] trivial: fix assorted "[con]currently" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1a1727bd799cec083b42d98f8604968072b14023 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 06:57:46 -0200
Subject: [PATCH 09/16] trivial: fix assorted "[con]currently" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/gpu/drm/i915/intel_fb.c b/drivers/gpu/drm/i915/intel_fb.c
index 2b0fe54..40fcf6f 100644
--- a/drivers/gpu/drm/i915/intel_fb.c
+++ b/drivers/gpu/drm/i915/intel_fb.c
@@ -70,7 +70,7 @@ static struct drm_fb_helper_funcs intel_fb_helper_funcs = {


 /**
- * Curretly it is assumed that the old framebuffer is reused.
+ * Currently it is assumed that the old framebuffer is reused.
  *
  * LOCKING
  * caller should hold the mode config lock.
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c
b/drivers/gpu/drm/radeon/radeon_fb.c
index b38c4c8..d10eb43 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -59,7 +59,7 @@ static struct fb_ops radeonfb_ops = {
 };

 /**
- * Curretly it is assumed that the old framebuffer is reused.
+ * Currently it is assumed that the old framebuffer is reused.
  *
  * LOCKING
  * caller should hold the mode config lock.
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c
b/drivers/media/video/cx23885/cx23885-dvb.c
index 45e13ee..16c6a92 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -940,7 +940,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 	int err, i;

 	/* Here we need to allocate the correct number of frontends,
-	 * as reflected in the cards struct. The reality is that currrently
+	 * as reflected in the cards struct. The reality is that currently
 	 * no cx23885 boards support this - yet. But, if we don't modify this
 	 * code then the second frontend would never be allocated (later)
 	 * and fail with error before the attach in dvb_register().
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
index 5b152ff..5fcad28 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw-internal.h
@@ -332,7 +332,7 @@ struct pvr2_hdw {

 	/* Bit mask of PVR2_CVAL_INPUT choices which are valid for the hardware */
 	unsigned int input_avail_mask;
-	/* Bit mask of PVR2_CVAL_INPUT choices which are currenly allowed */
+	/* Bit mask of PVR2_CVAL_INPUT choices which are currently allowed */
 	unsigned int input_allowed_mask;

 	/* Location of eeprom or a negative number if none */
diff --git a/drivers/net/benet/be_cmds.h b/drivers/net/benet/be_cmds.h
index 4995378..f0bb62b 100644
--- a/drivers/net/benet/be_cmds.h
+++ b/drivers/net/benet/be_cmds.h
@@ -435,7 +435,7 @@ enum be_if_flags {
  * filtering capabilities. */
 struct be_cmd_req_if_create {
 	struct be_cmd_req_hdr hdr;
-	u32 version;		/* ignore currntly */
+	u32 version;		/* ignore currently */
 	u32 capability_flags;
 	u32 enable_flags;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/wavelan_cs.c
b/drivers/net/wireless/wavelan_cs.c
index 431a20e..b3b0b5b 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -4011,7 +4011,7 @@ wavelan_interrupt(int		irq,
 #endif

   /* Prevent reentrancy. We need to do that because we may have
-   * multiple interrupt handler running concurently.
+   * multiple interrupt handler running concurrently.
    * It is safe because interrupts are disabled before aquiring
    * the spinlock. */
   spin_lock(&lp->spinlock);
diff --git a/drivers/ps3/ps3-sys-manager.c b/drivers/ps3/ps3-sys-manager.c
index 88cb740..3cbaf18 100644
--- a/drivers/ps3/ps3-sys-manager.c
+++ b/drivers/ps3/ps3-sys-manager.c
@@ -46,7 +46,7 @@
 /**
  * struct ps3_sys_manager_header - System manager message header.
  * @version: Header version, currently 1.
- * @size: Header size in bytes, curently 16.
+ * @size: Header size in bytes, currently 16.
  * @payload_size: Message payload size in bytes.
  * @service_id: Message type, one of enum ps3_sys_manager_service_id.
  * @request_tag: Unique number to identify reply.
diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c
b/drivers/staging/comedi/drivers/cb_pcidio.c
index 09e6e3b..7daad0a 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -109,12 +109,12 @@ MODULE_DEVICE_TABLE(pci, pcidio_pci_table);
    several hardware drivers keep similar information in this structure,
    feel free to suggest moving the variable to the struct
comedi_device struct.  */
 struct pcidio_private {
-	int data;		/*  curently unused */
+	int data;		/*  currently unused */

 	/* would be useful for a PCI device */
 	struct pci_dev *pci_dev;

-	/* used for DO readback, curently unused */
+	/* used for DO readback, currently unused */
 	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold
96 bits for PCI-DIO96 */

 	unsigned long dio_reg_base;	/*  address of port A of the first 8255
chip on board */
diff --git a/drivers/staging/octeon/ethernet-tx.c
b/drivers/staging/octeon/ethernet-tx.c
index 81a8513..5352941 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -624,7 +624,7 @@ int cvm_oct_transmit_qos(struct net_device *dev,
void *work_queue_entry,
 EXPORT_SYMBOL(cvm_oct_transmit_qos);

 /**
- * This function frees all skb that are currenty queued for TX.
+ * This function frees all skb that are currently queued for TX.
  *
  * @dev:    Device being shutdown
  */
diff --git a/drivers/staging/rtl8187se/r8180_core.c
b/drivers/staging/rtl8187se/r8180_core.c
index c65de92..95674cf 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -4144,7 +4144,7 @@ void rtl8180_tx_isr(struct net_device *dev, int
pri,short error)
 		}

 	/* we check all the descriptors between the head and the nic,
-	 * but not the currenly pointed by the nic (the next to be txed)
+	 * but not the currently pointed by the nic (the next to be txed)
 	 * and the previous of the pointed (might be in process ??)
 	*/
 	offs = (nic - nicbegin);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5d0fde1..4b35f7e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -39,7 +39,7 @@

 /*
  * MAX_REQ is the maximum number of requests that WE will send
- * on one socket concurently. It also matches the most common
+ * on one socket concurrently. It also matches the most common
  * value of max multiplex returned by servers.  We may
  * eventually want to use the negotiated value (in case
  * future servers can handle more) when we are more confident that
diff --git a/fs/jffs2/xattr.c b/fs/jffs2/xattr.c
index 082e844..4b10788 100644
--- a/fs/jffs2/xattr.c
+++ b/fs/jffs2/xattr.c
@@ -31,7 +31,7 @@
  *   is used to release xattr name/value pair and detach from c->xattrindex.
  * reclaim_xattr_datum(c)
  *   is used to reclaim xattr name/value pairs on the xattr
name/value pair cache when
- *   memory usage by cache is over c->xdatum_mem_threshold.
Currentry, this threshold
+ *   memory usage by cache is over c->xdatum_mem_threshold.
Currently, this threshold
  *   is hard coded as 32KiB.
  * do_verify_xattr_datum(c, xd)
  *   is used to load the xdatum informations without name/value pair
from the medium.
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 93fcb6c..2cfd5f0 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -755,7 +755,7 @@ int dbAlloc(struct inode *ip, s64 hint, s64
nblocks, s64 * results)
 	 * allocation group.
 	 */
 	if ((blkno & (bmp->db_agsize - 1)) == 0)
-		/* check if the AG is currenly being written to.
+		/* check if the AG is currently being written to.
 		 * if so, call dbNextAG() to find a non-busy
 		 * AG with sufficient free space.
 		 */
diff --git a/lib/decompress_bunzip2.c b/lib/decompress_bunzip2.c
index 600f473..7607420 100644
--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -299,7 +299,7 @@ static int INIT get_next_block(struct bunzip_data *bd)
 		   again when using them (during symbol decoding).*/
 		base = hufGroup->base-1;
 		limit = hufGroup->limit-1;
-		/* Calculate permute[].  Concurently, initialize
+		/* Calculate permute[].  Concurrently, initialize
 		 * temp[] and limit[]. */
 		pp = 0;
 		for (i = minLen; i <= maxLen; i++) {
diff --git a/sound/soc/s3c24xx/s3c24xx_simtec.c
b/sound/soc/s3c24xx/s3c24xx_simtec.c
index 1966e0d..3c7ccb7 100644
--- a/sound/soc/s3c24xx/s3c24xx_simtec.c
+++ b/sound/soc/s3c24xx/s3c24xx_simtec.c
@@ -270,7 +270,7 @@ static int attach_gpio_amp(struct device *dev,
 		gpio_direction_output(pd->amp_gain[1], 0);
 	}

-	/* note, curently we assume GPA0 isn't valid amp */
+	/* note, currently we assume GPA0 isn't valid amp */
 	if (pdata->amp_gpio > 0) {
 		ret = gpio_request(pd->amp_gpio, "gpio-amp");
 		if (ret) {
-- 
1.6.5.2.101.gcd0f8
