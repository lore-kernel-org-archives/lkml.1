Return-Path: <linux-kernel-owner+w=401wt.eu-S1765295AbXLQTtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765295AbXLQTtB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:49:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761571AbXLQTcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:11 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3046 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761441AbXLQTcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:32:04 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "LinuxTV.org Project" <v4l-dvb-maintainer@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael Hunold <michael@mihu.de>, Mike Isely <isely@pobox.com>,
       Ronald Bultje <rbultje@ronald.bitfreak.net>,
       mjpeg-users@lists.sourceforge.net, video4linux-list@redhat.com
Subject: [PATCH] drivers/media/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:40 -0800
Message-Id: <1197919875-5288-41-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/common/saa7146_core.c               |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c              |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c            |    2 +-
 drivers/media/video/bt8xx/bttv-driver.c           |    2 +-
 drivers/media/video/indycam.c                     |    2 +-
 drivers/media/video/mt20xx.c                      |    2 +-
 drivers/media/video/pvrusb2/pvrusb2.h             |    2 +-
 drivers/media/video/tea6420.c                     |    2 +-
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 drivers/media/video/usbvision/usbvision-video.c   |    2 +-
 drivers/media/video/vpx3220.c                     |    2 +-
 drivers/media/video/zoran_card.c                  |    2 +-
 drivers/media/video/zr36050.c                     |    2 +-
 drivers/media/video/zr36060.c                     |    2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 7d04a6f..168a8d3 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -388,7 +388,7 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 	}
 	dev->revision &= 0xf;
 
-	/* remap the memory from virtual to physical adress */
+	/* remap the memory from virtual to physical address */
 
 	err = pci_request_region(pci, 0, "saa7146");
 	if (err < 0)
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index a33eb59..ed3f826 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -681,7 +681,7 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 							drop = 1;
 						/* else: destination address matches the MAC address of our receiver device */
 					}
-					/* else: promiscious mode; pass everything up the stack */
+					/* else: promiscuous mode; pass everything up the stack */
 
 					if (drop) {
 #ifdef ULE_DEBUG
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 585d1ef..9a80277 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -4732,7 +4732,7 @@ static void rv605_muxsel(struct bttv *btv, unsigned int input)
 	gpio_bits(0x200,0x000);
 	mdelay(1);
 
-	/* create a new conection */
+	/* create a new connection */
 	gpio_bits(0x480,0x080);
 	gpio_bits(0x480,0x480);
 	mdelay(1);
diff --git a/drivers/media/video/bt8xx/bttv-driver.c b/drivers/media/video/bt8xx/bttv-driver.c
index c02d92d..5c41e49 100644
--- a/drivers/media/video/bt8xx/bttv-driver.c
+++ b/drivers/media/video/bt8xx/bttv-driver.c
@@ -3624,7 +3624,7 @@ static int bttv_ioctl(struct inode *inode, struct file *file,
 		    fh->vbi_fmt.fmt.start[1] != tvnorm->vbistart[1] ||
 		    fh->vbi_fmt.fmt.count[0] != fh->vbi_fmt.fmt.count[1]) {
 			/* BTTV_VBISIZE cannot express these parameters,
-			   however open() resets the paramters to defaults
+			   however open() resets the parameters to defaults
 			   and apps shouldn't call BTTV_VBISIZE after
 			   VIDIOC_S_FMT. */
 			return -EINVAL;
diff --git a/drivers/media/video/indycam.c b/drivers/media/video/indycam.c
index 5c2c402..84b9e4f 100644
--- a/drivers/media/video/indycam.c
+++ b/drivers/media/video/indycam.c
@@ -326,7 +326,7 @@ static int indycam_attach(struct i2c_adapter *adap, int addr, int kind)
 	// initialize
 	err = indycam_write_block(client, 0, sizeof(initseq), (u8 *)&initseq);
 	if (err) {
-		printk(KERN_ERR "IndyCam initalization failed\n");
+		printk(KERN_ERR "IndyCam initialization failed\n");
 		err = -EIO;
 		goto out_detach_client;
 	}
diff --git a/drivers/media/video/mt20xx.c b/drivers/media/video/mt20xx.c
index f49d1f4..e6dc674 100644
--- a/drivers/media/video/mt20xx.c
+++ b/drivers/media/video/mt20xx.c
@@ -369,7 +369,7 @@ static struct dvb_tuner_ops mt2032_tuner_ops = {
 	.get_frequency     = microtune_get_frequency,
 };
 
-// Initalization as described in "MT203x Programming Procedures", Rev 1.2, Feb.2001
+// Initialization as described in "MT203x Programming Procedures", Rev 1.2, Feb.2001
 static int mt2032_init(struct dvb_frontend *fe)
 {
 	struct microtune_priv *priv = fe->tuner_priv;
diff --git a/drivers/media/video/pvrusb2/pvrusb2.h b/drivers/media/video/pvrusb2/pvrusb2.h
index 074533e..1a9a4ba 100644
--- a/drivers/media/video/pvrusb2/pvrusb2.h
+++ b/drivers/media/video/pvrusb2/pvrusb2.h
@@ -27,7 +27,7 @@
    might want to increase this - however the driver operation will not
    be impaired if it is too small.  Instead additional units just
    won't have an ID assigned and it might not be possible to specify
-   module paramters for those extra units. */
+   module parameters for those extra units. */
 #define PVR_NUM 20
 
 #endif /* __PVRUSB2_H */
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index e0ff811..ca05cd6 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -57,7 +57,7 @@ static int tea6420_switch(struct i2c_client *client, int i, int o, int g)
 
 	dprintk("adr:0x%02x, i:%d, o:%d, g:%d\n", client->addr, i, o, g);
 
-	/* check if the paramters are valid */
+	/* check if the parameters are valid */
 	if (i < 1 || i > 6 || o < 1 || o > 4 || g < 0 || g > 6 || g % 2 != 0)
 		return -1;
 
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index d847273..5e7b795 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -258,7 +258,7 @@ static void qcm_hsv2rgb(u16 hue, u16 sat, u16 val, u16 *r, u16 *g, u16 *b)
 	unsigned int p;
 
 	/*
-	the registers controling gain are 8 bit of which
+	the registers controlling gain are 8 bit of which
 	we affect only the last 4 bits with our gain.
 	we know that if saturation is 0, (unsaturated) then
 	we're grayscale (center axis of the colour cone) so
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index 36e689f..14297d9 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -131,7 +131,7 @@ static struct usbvision_v4l2_format_st usbvision_v4l2_format[] = {
 /* Function prototypes */
 static void usbvision_release(struct usb_usbvision *usbvision);
 
-/* Default initalization of device driver parameters */
+/* Default initialization of device driver parameters */
 /* Set the default format for ISOC endpoint */
 static int isocMode = ISOC_MODE_COMPRESS;
 /* Set the default Debug Mode of the device driver */
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index 8ef31ed..a913385 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -566,7 +566,7 @@ vpx3220_init_client (struct i2c_client *client)
 }
 
 /* -----------------------------------------------------------------------
- * Client managment code
+ * Client management code
  */
 
 /*
diff --git a/drivers/media/video/zoran_card.c b/drivers/media/video/zoran_card.c
index 6e0ac4c..690281b 100644
--- a/drivers/media/video/zoran_card.c
+++ b/drivers/media/video/zoran_card.c
@@ -1270,7 +1270,7 @@ zoran_setup_videocodec (struct zoran *zr,
 }
 
 /*
- *   Scan for a Buz card (actually for the PCI contoler ZR36057),
+ *   Scan for a Buz card (actually for the PCI controller ZR36057),
  *   request the irq and map the io memory
  */
 static int __devinit
diff --git a/drivers/media/video/zr36050.c b/drivers/media/video/zr36050.c
index 9f622e0..faae4ec 100644
--- a/drivers/media/video/zr36050.c
+++ b/drivers/media/video/zr36050.c
@@ -161,7 +161,7 @@ zr36050_wait_end (struct zr36050 *ptr)
 		udelay(1);
 		if (i++ > 200000) {	// 200ms, there is for sure something wrong!!!
 			dprintk(1,
-				"%s: timout at wait_end (last status: 0x%02x)\n",
+				"%s: timeout at wait_end (last status: 0x%02x)\n",
 				ptr->name, ptr->status1);
 			break;
 		}
diff --git a/drivers/media/video/zr36060.c b/drivers/media/video/zr36060.c
index 1ef14fe..7849b65 100644
--- a/drivers/media/video/zr36060.c
+++ b/drivers/media/video/zr36060.c
@@ -163,7 +163,7 @@ zr36060_wait_end (struct zr36060 *ptr)
 		udelay(1);
 		if (i++ > 200000) {	// 200ms, there is for sure something wrong!!!
 			dprintk(1,
-				"%s: timout at wait_end (last status: 0x%02x)\n",
+				"%s: timeout at wait_end (last status: 0x%02x)\n",
 				ptr->name, ptr->status);
 			break;
 		}
-- 
1.5.3.7.949.g2221a6

