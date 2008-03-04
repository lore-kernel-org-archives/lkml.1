Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYCDADj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYCDADj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbYCDADY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:03:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:44331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYCDADN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:03:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XiZA+2w16/AskzYm10irxwT1fVc9NbcVQr8SDCHLr6V01xz+rQzfV4yk8bQsmHmauSrGHTlxJrqIVFrKj4TBGMNnbXPz+K5//5ywjAoprwIX5yt4Ui7DaeFPWkgyO4o4RAazhYePCt68T/scfN8kC0iGSMdg6ygWYHxeq/21muU=
Subject: [PATCH] media: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: "v4l-dvb-maintainer@linuxtv.org" <v4l-dvb-maintainer@linuxtv.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 16:03:10 -0800
Message-Id: <1204588990.22933.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/common/saa7146_core.c               |    8 +-
 drivers/media/common/saa7146_i2c.c                |    6 +-
 drivers/media/dvb/b2c2/flexcop-dma.c              |    4 +-
 drivers/media/dvb/b2c2/flexcop-sram.c             |   28 ++--
 drivers/media/dvb/bt8xx/dst.c                     |    2 +-
 drivers/media/dvb/bt8xx/dst_ca.c                  |   10 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c               |    2 +-
 drivers/media/dvb/cinergyT2/cinergyT2.c           |    2 +-
 drivers/media/dvb/dvb-core/dmxdev.c               |   10 +-
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c       |   36 +++---
 drivers/media/dvb/dvb-core/dvb_demux.c            |    4 +-
 drivers/media/dvb/dvb-core/dvb_frontend.c         |   30 ++--
 drivers/media/dvb/dvb-core/dvb_net.c              |   30 ++--
 drivers/media/dvb/dvb-core/dvbdev.c               |    4 +-
 drivers/media/dvb/dvb-usb/cxusb.c                 |    6 +-
 drivers/media/dvb/dvb-usb/gp8psk-fe.c             |    4 +-
 drivers/media/dvb/dvb-usb/m920x.c                 |   12 +-
 drivers/media/dvb/dvb-usb/vp702x-fe.c             |   18 ++--
 drivers/media/dvb/frontends/bcm3510.c             |    4 +-
 drivers/media/dvb/frontends/bcm3510.h             |    2 +-
 drivers/media/dvb/frontends/cx22700.c             |   12 +-
 drivers/media/dvb/frontends/cx22700.h             |    2 +-
 drivers/media/dvb/frontends/cx22702.c             |   24 ++--
 drivers/media/dvb/frontends/cx22702.h             |    2 +-
 drivers/media/dvb/frontends/cx24110.c             |    6 +-
 drivers/media/dvb/frontends/cx24110.h             |    2 +-
 drivers/media/dvb/frontends/cx24123.c             |   82 ++++++------
 drivers/media/dvb/frontends/cx24123.h             |    2 +-
 drivers/media/dvb/frontends/dib3000.h             |    2 +-
 drivers/media/dvb/frontends/dib3000mc.h           |    2 +-
 drivers/media/dvb/frontends/dvb-pll.c             |    2 +-
 drivers/media/dvb/frontends/dvb-pll.h             |    2 +-
 drivers/media/dvb/frontends/isl6421.h             |    2 +-
 drivers/media/dvb/frontends/l64781.c              |    2 +-
 drivers/media/dvb/frontends/l64781.h              |    2 +-
 drivers/media/dvb/frontends/lgdt330x.c            |   38 +++---
 drivers/media/dvb/frontends/lgdt330x.h            |    2 +-
 drivers/media/dvb/frontends/lnbp21.h              |    2 +-
 drivers/media/dvb/frontends/mt2060.h              |    2 +-
 drivers/media/dvb/frontends/mt2131.c              |   14 +-
 drivers/media/dvb/frontends/mt2131.h              |    2 +-
 drivers/media/dvb/frontends/mt2266.h              |    2 +-
 drivers/media/dvb/frontends/mt312.c               |    6 +-
 drivers/media/dvb/frontends/mt312.h               |    2 +-
 drivers/media/dvb/frontends/mt352.c               |    8 +-
 drivers/media/dvb/frontends/mt352.h               |    2 +-
 drivers/media/dvb/frontends/nxt200x.c             |   26 ++--
 drivers/media/dvb/frontends/nxt200x.h             |    2 +-
 drivers/media/dvb/frontends/nxt6000.h             |    2 +-
 drivers/media/dvb/frontends/or51132.c             |    6 +-
 drivers/media/dvb/frontends/or51132.h             |    2 +-
 drivers/media/dvb/frontends/or51211.c             |    6 +-
 drivers/media/dvb/frontends/or51211.h             |    2 +-
 drivers/media/dvb/frontends/qt1010.h              |    2 +-
 drivers/media/dvb/frontends/s5h1409.c             |   48 ++++----
 drivers/media/dvb/frontends/s5h1409.h             |    2 +-
 drivers/media/dvb/frontends/s5h1420.c             |    2 +-
 drivers/media/dvb/frontends/s5h1420.h             |    2 +-
 drivers/media/dvb/frontends/sp8870.c              |   26 ++--
 drivers/media/dvb/frontends/sp8870.h              |    2 +-
 drivers/media/dvb/frontends/sp887x.c              |   18 ++--
 drivers/media/dvb/frontends/sp887x.h              |    2 +-
 drivers/media/dvb/frontends/stv0297.c             |   14 +-
 drivers/media/dvb/frontends/stv0297.h             |    2 +-
 drivers/media/dvb/frontends/stv0299.c             |   40 +++---
 drivers/media/dvb/frontends/stv0299.h             |    2 +-
 drivers/media/dvb/frontends/tda10021.c            |    4 +-
 drivers/media/dvb/frontends/tda10023.c            |    4 +-
 drivers/media/dvb/frontends/tda1002x.h            |    4 +-
 drivers/media/dvb/frontends/tda1004x.c            |   56 ++++----
 drivers/media/dvb/frontends/tda1004x.h            |    4 +-
 drivers/media/dvb/frontends/tda10086.c            |   40 +++---
 drivers/media/dvb/frontends/tda10086.h            |    2 +-
 drivers/media/dvb/frontends/tda18271-priv.h       |    2 +-
 drivers/media/dvb/frontends/tda18271.h            |    2 +-
 drivers/media/dvb/frontends/tda8083.c             |    4 +-
 drivers/media/dvb/frontends/tda8083.h             |    2 +-
 drivers/media/dvb/frontends/tda826x.c             |   10 +-
 drivers/media/dvb/frontends/tda826x.h             |    2 +-
 drivers/media/dvb/frontends/tda827x.c             |   18 ++--
 drivers/media/dvb/frontends/tda827x.h             |    2 +-
 drivers/media/dvb/frontends/tua6100.c             |    2 +-
 drivers/media/dvb/frontends/tua6100.h             |    2 +-
 drivers/media/dvb/frontends/ves1820.c             |    4 +-
 drivers/media/dvb/frontends/ves1820.h             |    2 +-
 drivers/media/dvb/frontends/ves1x93.c             |    6 +-
 drivers/media/dvb/frontends/ves1x93.h             |    2 +-
 drivers/media/dvb/frontends/xc5000.c              |   44 +++---
 drivers/media/dvb/frontends/xc5000.h              |    2 +-
 drivers/media/dvb/frontends/zl10353.c             |    6 +-
 drivers/media/dvb/frontends/zl10353.h             |    2 +-
 drivers/media/dvb/ttpci/av7110.c                  |   12 +-
 drivers/media/dvb/ttpci/av7110.h                  |    2 +-
 drivers/media/dvb/ttpci/av7110_hw.c               |   42 +++---
 drivers/media/dvb/ttpci/av7110_ir.c               |    6 +-
 drivers/media/dvb/ttpci/av7110_v4l.c              |    4 +-
 drivers/media/dvb/ttpci/budget-ci.c               |    2 +-
 drivers/media/dvb/ttpci/budget-core.c             |    2 +-
 drivers/media/dvb/ttpci/budget.c                  |    6 +-
 drivers/media/dvb/ttpci/budget.h                  |    2 +-
 drivers/media/dvb/ttpci/ttpci-eeprom.c            |    2 +-
 drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |   44 +++---
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |  106 ++++++++--------
 drivers/media/dvb/ttusb-dec/ttusbdecfe.c          |    4 +-
 drivers/media/video/cpia.h                        |    4 +-
 drivers/media/video/cpia2/cpia2_core.c            |   12 +-
 drivers/media/video/cpia_usb.c                    |    2 +-
 drivers/media/video/cx23885/cx23885-cards.c       |    2 +-
 drivers/media/video/cx23885/cx23885-core.c        |   98 +++++++-------
 drivers/media/video/cx23885/cx23885-dvb.c         |   10 +-
 drivers/media/video/cx23885/cx23885-i2c.c         |   16 +-
 drivers/media/video/cx23885/cx23885-video.c       |   54 ++++----
 drivers/media/video/cx88/cx88-alsa.c              |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c         |    8 +-
 drivers/media/video/cx88/cx88-core.c              |    4 +-
 drivers/media/video/cx88/cx88-dvb.c               |    8 +-
 drivers/media/video/cx88/cx88-mpeg.c              |   16 +-
 drivers/media/video/cx88/cx88-tvaudio.c           |   24 ++--
 drivers/media/video/em28xx/em28xx-audio.c         |    2 +-
 drivers/media/video/em28xx/em28xx-core.c          |    6 +-
 drivers/media/video/em28xx/em28xx-i2c.c           |    2 +-
 drivers/media/video/em28xx/em28xx-video.c         |    2 +-
 drivers/media/video/et61x251/et61x251.h           |    6 +-
 drivers/media/video/ir-kbd-i2c.c                  |    2 +-
 drivers/media/video/mt20xx.h                      |    2 +-
 drivers/media/video/ov511.h                       |    2 +-
 drivers/media/video/ovcamchip/ovcamchip_priv.h    |    4 +-
 drivers/media/video/pvrusb2/pvrusb2-sysfs.c       |   20 ++--
 drivers/media/video/pwc/pwc-if.c                  |    6 +-
 drivers/media/video/saa7134/saa7134-dvb.c         |   12 +-
 drivers/media/video/saa7134/saa7134-empress.c     |    4 +-
 drivers/media/video/se401.c                       |    6 +-
 drivers/media/video/sn9c102/sn9c102.h             |    6 +-
 drivers/media/video/stk-webcam.c                  |    2 +-
 drivers/media/video/stv680.c                      |    2 +-
 drivers/media/video/tcm825x.c                     |    2 +-
 drivers/media/video/tda8290.c                     |    6 +-
 drivers/media/video/tda8290.h                     |    4 +-
 drivers/media/video/tda9840.c                     |    2 +-
 drivers/media/video/tda9887.h                     |    2 +-
 drivers/media/video/tea5761.h                     |    4 +-
 drivers/media/video/tea5767.h                     |    4 +-
 drivers/media/video/tea6415c.c                    |    2 +-
 drivers/media/video/tea6420.c                     |    2 +-
 drivers/media/video/tuner-simple.h                |    2 +-
 drivers/media/video/tuner-xc2028.c                |   28 ++--
 drivers/media/video/tuner-xc2028.h                |    2 +-
 drivers/media/video/usbvideo/konicawc.c           |    2 +-
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 drivers/media/video/usbvideo/usbvideo.c           |  142 ++++++++++----------
 drivers/media/video/usbvideo/vicam.c              |    2 +-
 drivers/media/video/usbvision/usbvision-core.c    |   24 ++--
 drivers/media/video/usbvision/usbvision-video.c   |   36 +++---
 drivers/media/video/videobuf-core.c               |    2 +-
 drivers/media/video/videobuf-dma-sg.c             |    4 +-
 drivers/media/video/videobuf-vmalloc.c            |    2 +-
 drivers/media/video/videodev.c                    |    4 +-
 drivers/media/video/vivi.c                        |   22 ++--
 drivers/media/video/w9966.c                       |    2 +-
 drivers/media/video/w9968cf.h                     |    6 +-
 drivers/media/video/zc0301/zc0301.h               |    6 +-
 drivers/media/video/zoran_driver.c                |    4 +-
 162 files changed, 892 insertions(+), 892 deletions(-)

diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 168a8d3..d4edec1 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -74,7 +74,7 @@ static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 		if (err) {
 			printk(KERN_ERR "%s: %s timed out while waiting for "
 					"registers getting programmed\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -89,7 +89,7 @@ static inline int saa7146_wait_for_debi_done_sleep(struct saa7146_dev *dev,
 		saa7146_read(dev, MC2);
 		if (err) {
 			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n",	dev->name, __FUNCTION__));
+				"completion\n",	dev->name, __func__));
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -111,7 +111,7 @@ static inline int saa7146_wait_for_debi_done_busyloop(struct saa7146_dev *dev,
 		if (!loops--) {
 			printk(KERN_ERR "%s: %s timed out while waiting for "
 					"registers getting programmed\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 			return -ETIMEDOUT;
 		}
 		udelay(1);
@@ -125,7 +125,7 @@ static inline int saa7146_wait_for_debi_done_busyloop(struct saa7146_dev *dev,
 		saa7146_read(dev, MC2);
 		if (!loops--) {
 			DEB_S(("%s: %s timed out while waiting for transfer "
-				"completion\n", dev->name, __FUNCTION__));
+				"completion\n", dev->name, __func__));
 			return -ETIMEDOUT;
 		}
 		udelay(5);
diff --git a/drivers/media/common/saa7146_i2c.c b/drivers/media/common/saa7146_i2c.c
index 7e7689a..35b01ec 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -203,7 +203,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 				return -ERESTARTSYS;
 
 			printk(KERN_WARNING "%s %s [irq]: timed out waiting for end of xfer\n",
-				dev->name, __FUNCTION__);
+				dev->name, __func__);
 			return -EIO;
 		}
 		status = saa7146_read(dev, I2C_STATUS);
@@ -221,7 +221,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 			}
 			if (time_after(jiffies,timeout)) {
 				printk(KERN_WARNING "%s %s: timed out waiting for MC2\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 				return -EIO;
 			}
 		}
@@ -238,7 +238,7 @@ static int saa7146_i2c_writeout(struct saa7146_dev *dev, u32* dword, int short_d
 				 * (no answer from nonexisistant device...)
 				 */
 				printk(KERN_WARNING "%s %s [poll]: timed out waiting for end of xfer\n",
-					dev->name, __FUNCTION__);
+					dev->name, __func__);
 				return -EIO;
 			}
 			if (++trial < 50 && short_delay)
diff --git a/drivers/media/dvb/b2c2/flexcop-dma.c b/drivers/media/dvb/b2c2/flexcop-dma.c
index 6f592bc..a91ed28 100644
--- a/drivers/media/dvb/b2c2/flexcop-dma.c
+++ b/drivers/media/dvb/b2c2/flexcop-dma.c
@@ -112,7 +112,7 @@ static int flexcop_dma_remap(struct flexcop_device *fc,
 {
 	flexcop_ibi_register r = (dma_idx & FC_DMA_1) ? dma1_00c : dma2_01c;
 	flexcop_ibi_value v = fc->read_ibi_reg(fc,r);
-	deb_info("%s\n",__FUNCTION__);
+	deb_info("%s\n",__func__);
 	v.dma_0xc.remap_enable = onoff;
 	fc->write_ibi_reg(fc,r,v);
 	return 0;
@@ -162,7 +162,7 @@ int flexcop_dma_config_timer(struct flexcop_device *fc,
 
 	flexcop_dma_remap(fc,dma_idx,0);
 
-	deb_info("%s\n",__FUNCTION__);
+	deb_info("%s\n",__func__);
 	v.dma_0x4_write.dmatimer = cycles;
 	fc->write_ibi_reg(fc,r,v);
 	return 0;
diff --git a/drivers/media/dvb/b2c2/flexcop-sram.c b/drivers/media/dvb/b2c2/flexcop-sram.c
index 01570ec..cda6952 100644
--- a/drivers/media/dvb/b2c2/flexcop-sram.c
+++ b/drivers/media/dvb/b2c2/flexcop-sram.c
@@ -90,7 +90,7 @@ static void flexcop_sram_write(struct adapter *adapter, u32 bank, u32 addr, u8 *
 		};
 
 		if (retries == 0)
-			printk("%s: SRAM timeout\n", __FUNCTION__);
+			printk("%s: SRAM timeout\n", __func__);
 
 		write_reg_dw(adapter, 0x700, command);
 
@@ -115,7 +115,7 @@ static void flex_sram_read(struct adapter *adapter, u32 bank, u32 addr, u8 *buf,
 		};
 
 		if (retries == 0)
-			printk("%s: SRAM timeout\n", __FUNCTION__);
+			printk("%s: SRAM timeout\n", __func__);
 
 		write_reg_dw(adapter, 0x700, command);
 
@@ -127,7 +127,7 @@ static void flex_sram_read(struct adapter *adapter, u32 bank, u32 addr, u8 *buf,
 		};
 
 		if (retries == 0)
-			printk("%s: SRAM timeout\n", __FUNCTION__);
+			printk("%s: SRAM timeout\n", __func__);
 
 		value = read_reg_dw(adapter, 0x700) >> 0x10;
 
@@ -240,13 +240,13 @@ static void sram_init(struct adapter *adapter)
 
 		adapter->dw_sram_type = tmp & 0x30000;
 
-		ddprintk("%s: dw_sram_type = %x\n", __FUNCTION__, adapter->dw_sram_type);
+		ddprintk("%s: dw_sram_type = %x\n", __func__, adapter->dw_sram_type);
 
 	} else {
 
 		adapter->dw_sram_type = 0x10000;
 
-		ddprintk("%s: dw_sram_type = %x\n", __FUNCTION__, adapter->dw_sram_type);
+		ddprintk("%s: dw_sram_type = %x\n", __func__, adapter->dw_sram_type);
 	}
 
 	/* return value is never used? */
@@ -257,7 +257,7 @@ static int sram_test_location(struct adapter *adapter, u32 mask, u32 addr)
 {
 	u8 tmp1, tmp2;
 
-	dprintk("%s: mask = %x, addr = %x\n", __FUNCTION__, mask, addr);
+	dprintk("%s: mask = %x, addr = %x\n", __func__, mask, addr);
 
 	sram_set_size(adapter, mask);
 	sram_init(adapter);
@@ -275,7 +275,7 @@ static int sram_test_location(struct adapter *adapter, u32 mask, u32 addr)
 	sram_read(adapter, addr, &tmp2, 1);
 	sram_read(adapter, addr, &tmp2, 1);
 
-	dprintk("%s: wrote 0xa5, read 0x%2x\n", __FUNCTION__, tmp2);
+	dprintk("%s: wrote 0xa5, read 0x%2x\n", __func__, tmp2);
 
 	if (tmp2 != 0xa5)
 		return 0;
@@ -293,7 +293,7 @@ static int sram_test_location(struct adapter *adapter, u32 mask, u32 addr)
 	sram_read(adapter, addr, &tmp2, 1);
 	sram_read(adapter, addr, &tmp2, 1);
 
-	dprintk("%s: wrote 0x5a, read 0x%2x\n", __FUNCTION__, tmp2);
+	dprintk("%s: wrote 0x5a, read 0x%2x\n", __func__, tmp2);
 
 	if (tmp2 != 0x5a)
 		return 0;
@@ -340,7 +340,7 @@ static int flexcop_sram_detect(struct flexcop_device *fc)
 
 	tmp3 = read_reg_dw(adapter, 0x71c);
 
-	dprintk("%s: tmp3 = %x\n", __FUNCTION__, tmp3);
+	dprintk("%s: tmp3 = %x\n", __func__, tmp3);
 
 	write_reg_dw(adapter, 0x71c, tmp2);
 
@@ -351,7 +351,7 @@ static int flexcop_sram_detect(struct flexcop_device *fc)
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 32K\n", __FUNCTION__);
+		dprintk("%s: sram size = 32K\n", __func__);
 
 		return 32;
 	}
@@ -361,7 +361,7 @@ static int flexcop_sram_detect(struct flexcop_device *fc)
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 128K\n", __FUNCTION__);
+		dprintk("%s: sram size = 128K\n", __func__);
 
 		return 128;
 	}
@@ -371,7 +371,7 @@ static int flexcop_sram_detect(struct flexcop_device *fc)
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 64K\n", __FUNCTION__);
+		dprintk("%s: sram size = 64K\n", __func__);
 
 		return 64;
 	}
@@ -381,7 +381,7 @@ static int flexcop_sram_detect(struct flexcop_device *fc)
 		sram_init(adapter);
 		write_reg_dw(adapter, 0x208, tmp);
 
-		dprintk("%s: sram size = 32K\n", __FUNCTION__);
+		dprintk("%s: sram size = 32K\n", __func__);
 
 		return 32;
 	}
@@ -390,7 +390,7 @@ static int flexcop_sram_detect(struct flexcop_device *fc)
 	sram_init(adapter);
 	write_reg_dw(adapter, 0x208, tmp);
 
-	dprintk("%s: SRAM detection failed. Set to 32K \n", __FUNCTION__);
+	dprintk("%s: SRAM detection failed. Set to 32K \n", __func__);
 
 	return 0;
 }
diff --git a/drivers/media/dvb/bt8xx/dst.c b/drivers/media/dvb/bt8xx/dst.c
index 307ff35..75711bd 100644
--- a/drivers/media/dvb/bt8xx/dst.c
+++ b/drivers/media/dvb/bt8xx/dst.c
@@ -1290,7 +1290,7 @@ static int dst_get_signal(struct dst_state *state)
 {
 	int retval;
 	u8 get_signal[] = { 0x00, 0x05, 0x00, 0x00, 0x00, 0x00, 0x00, 0xfb };
-	//dprintk("%s: Getting Signal strength and other parameters\n", __FUNCTION__);
+	//dprintk("%s: Getting Signal strength and other parameters\n", __func__);
 	if ((state->diseq_flags & ATTEMPT_TUNE) == 0) {
 		state->decode_lock = state->decode_strength = state->decode_snr = 0;
 		return 0;
diff --git a/drivers/media/dvb/bt8xx/dst_ca.c b/drivers/media/dvb/bt8xx/dst_ca.c
index 50bc32a..0258451 100644
--- a/drivers/media/dvb/bt8xx/dst_ca.c
+++ b/drivers/media/dvb/bt8xx/dst_ca.c
@@ -36,13 +36,13 @@
 #define dprintk(x, y, z, format, arg...) do {						\
 	if (z) {									\
 		if	((x > DST_CA_ERROR) && (x > y))					\
-			printk(KERN_ERR "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_ERR "%s: " format "\n", __func__ , ##arg);	\
 		else if	((x > DST_CA_NOTICE) && (x > y))				\
-			printk(KERN_NOTICE "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_NOTICE "%s: " format "\n", __func__ , ##arg);	\
 		else if ((x > DST_CA_INFO) && (x > y))					\
-			printk(KERN_INFO "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_INFO "%s: " format "\n", __func__ , ##arg);	\
 		else if ((x > DST_CA_DEBUG) && (x > y))					\
-			printk(KERN_DEBUG "%s: " format "\n", __FUNCTION__ , ##arg);	\
+			printk(KERN_DEBUG "%s: " format "\n", __func__ , ##arg);	\
 	} else {									\
 		if (x > y)								\
 			printk(format, ## arg);						\
@@ -162,7 +162,7 @@ static int ca_get_app_info(struct dst_state *state)
 	dprintk(verbose, DST_CA_INFO, 1, " ================================ CI Module Application Info ======================================");
 	dprintk(verbose, DST_CA_INFO, 1, " Application Type=[%d], Application Vendor=[%d], Vendor Code=[%d]\n%s: Application info=[%s]",
 		state->messages[7], (state->messages[8] << 8) | state->messages[9],
-		(state->messages[10] << 8) | state->messages[11], __FUNCTION__, (char *)(&state->messages[12]));
+		(state->messages[10] << 8) | state->messages[11], __func__, (char *)(&state->messages[12]));
 	dprintk(verbose, DST_CA_INFO, 1, " ==================================================================================================");
 
 	// Transform dst message to correct application_info message
diff --git a/drivers/media/dvb/bt8xx/dvb-bt8xx.c b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
index dedd30a..b93efec 100644
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -670,7 +670,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		state->dst_ca = NULL;
 		/*	DST is not a frontend, attaching the ASIC	*/
 		if (dvb_attach(dst_attach, state, &card->dvb_adapter) == NULL) {
-			printk("%s: Could not find a Twinhan DST.\n", __FUNCTION__);
+			printk("%s: Could not find a Twinhan DST.\n", __func__);
 			break;
 		}
 		/*	Attach other DST peripherals if any		*/
diff --git a/drivers/media/dvb/cinergyT2/cinergyT2.c b/drivers/media/dvb/cinergyT2/cinergyT2.c
index db08b0a..29b2459 100644
--- a/drivers/media/dvb/cinergyT2/cinergyT2.c
+++ b/drivers/media/dvb/cinergyT2/cinergyT2.c
@@ -62,7 +62,7 @@ MODULE_PARM_DESC(debug, "Turn on/off debugging (default:off).");
 do {									\
 	if ((debug & level)) {						\
 		printk("%s: %s(): ", KBUILD_MODNAME,			\
-		       __FUNCTION__);					\
+		       __func__);					\
 		printk(args); }						\
 } while (0)
 
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index f94bc31..0d9bacf 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -126,7 +126,7 @@ static int dvb_dvr_open(struct inode *inode, struct file *file)
 	struct dmxdev *dmxdev = dvbdev->priv;
 	struct dmx_frontend *front;
 
-	dprintk("function : %s\n", __FUNCTION__);
+	dprintk("function : %s\n", __func__);
 
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
@@ -550,7 +550,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 								   dvb_dmxdev_section_callback);
 			if (ret < 0) {
 				printk("DVB (%s): could not alloc feed\n",
-				       __FUNCTION__);
+				       __func__);
 				return ret;
 			}
 
@@ -558,7 +558,7 @@ static int dvb_dmxdev_filter_start(struct dmxdev_filter *filter)
 					      (para->flags & DMX_CHECK_CRC) ? 1 : 0);
 			if (ret < 0) {
 				printk("DVB (%s): could not set feed\n",
-				       __FUNCTION__);
+				       __func__);
 				dvb_dmxdev_feed_restart(filter);
 				return ret;
 			}
@@ -732,7 +732,7 @@ static int dvb_dmxdev_filter_set(struct dmxdev *dmxdev,
 				 struct dmxdev_filter *dmxdevfilter,
 				 struct dmx_sct_filter_params *params)
 {
-	dprintk("function : %s\n", __FUNCTION__);
+	dprintk("function : %s\n", __func__);
 
 	dvb_dmxdev_filter_stop(dmxdevfilter);
 
@@ -1038,7 +1038,7 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)
 	struct dmxdev *dmxdev = dvbdev->priv;
 	unsigned int mask = 0;
 
-	dprintk("function : %s\n", __FUNCTION__);
+	dprintk("function : %s\n", __func__);
 
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);
 
diff --git a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
index 89437fd..8cbdb0e 100644
--- a/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb/dvb-core/dvb_ca_en50221.c
@@ -250,7 +250,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 	unsigned long timeout;
 	unsigned long start;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* loop until timeout elapsed */
 	start = jiffies;
@@ -263,7 +263,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 
 		/* if we got the flags, it was successful! */
 		if (res & waitfor) {
-			dprintk("%s succeeded timeout:%lu\n", __FUNCTION__, jiffies - start);
+			dprintk("%s succeeded timeout:%lu\n", __func__, jiffies - start);
 			return 0;
 		}
 
@@ -276,7 +276,7 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 		msleep(1);
 	}
 
-	dprintk("%s failed timeout:%lu\n", __FUNCTION__, jiffies - start);
+	dprintk("%s failed timeout:%lu\n", __func__, jiffies - start);
 
 	/* if we get here, we've timed out */
 	return -ETIMEDOUT;
@@ -297,7 +297,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	int buf_size;
 	u8 buf[2];
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* we'll be determining these during this function */
 	ca->slot_info[slot].da_irq_supported = 0;
@@ -549,7 +549,7 @@ static int dvb_ca_en50221_set_configoption(struct dvb_ca_private *ca, int slot)
 {
 	int configoption;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set the config option */
 	ca->pub->write_attribute_mem(ca->pub, slot,
@@ -587,7 +587,7 @@ static int dvb_ca_en50221_read_data(struct dvb_ca_private *ca, int slot, u8 * eb
 	u8 buf[HOST_LINK_BUF_SIZE];
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* check if we have space for a link buf in the rx_buffer */
 	if (ebuf == NULL) {
@@ -708,7 +708,7 @@ static int dvb_ca_en50221_write_data(struct dvb_ca_private *ca, int slot, u8 * b
 	int status;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 
 	// sanity check
@@ -785,7 +785,7 @@ EXPORT_SYMBOL(dvb_ca_en50221_camchange_irq);
  */
 static int dvb_ca_en50221_slot_shutdown(struct dvb_ca_private *ca, int slot)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	ca->pub->slot_shutdown(ca->pub, slot);
 	ca->slot_info[slot].slot_state = DVB_CA_SLOTSTATE_NONE;
@@ -892,7 +892,7 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *pubca, int slot)
 static void dvb_ca_en50221_thread_wakeup(struct dvb_ca_private *ca)
 {
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	ca->wakeup = 1;
 	mb();
@@ -964,7 +964,7 @@ static int dvb_ca_en50221_thread(void *data)
 	int pktcount;
 	void *rxbuf;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* choose the correct initial delay */
 	dvb_ca_en50221_thread_update_delay(ca);
@@ -1172,7 +1172,7 @@ static int dvb_ca_en50221_io_do_ioctl(struct inode *inode, struct file *file,
 	int err = 0;
 	int slot;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	switch (cmd) {
 	case CA_RESET:
@@ -1266,7 +1266,7 @@ static ssize_t dvb_ca_en50221_io_write(struct file *file,
 	unsigned long timeout;
 	int written;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* Incoming packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
 	if (count < 2)
@@ -1401,7 +1401,7 @@ static ssize_t dvb_ca_en50221_io_read(struct file *file, char __user * buf,
 	int pktlen;
 	int dispose = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* Outgoing packet has a 2 byte header. hdr[0] = slot_id, hdr[1] = connection_id */
 	if (count < 2)
@@ -1490,7 +1490,7 @@ static int dvb_ca_en50221_io_open(struct inode *inode, struct file *file)
 	int err;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (!try_module_get(ca->pub->owner))
 		return -EIO;
@@ -1534,7 +1534,7 @@ static int dvb_ca_en50221_io_release(struct inode *inode, struct file *file)
 	struct dvb_ca_private *ca = dvbdev->priv;
 	int err;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* mark the CA device as closed */
 	ca->open = 0;
@@ -1564,7 +1564,7 @@ static unsigned int dvb_ca_en50221_io_poll(struct file *file, poll_table * wait)
 	int slot;
 	int result = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (dvb_ca_en50221_io_read_condition(ca, &result, &slot) == 1) {
 		mask |= POLLIN;
@@ -1626,7 +1626,7 @@ int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
 	struct dvb_ca_private *ca = NULL;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (slot_count < 1)
 		return -EINVAL;
@@ -1704,7 +1704,7 @@ void dvb_ca_en50221_release(struct dvb_ca_en50221 *pubca)
 	struct dvb_ca_private *ca = pubca->private;
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* shutdown the thread if there was one */
 	kthread_stop(ca->thread);
diff --git a/drivers/media/dvb/dvb-core/dvb_demux.c b/drivers/media/dvb/dvb-core/dvb_demux.c
index 7959020..09a69c8 100644
--- a/drivers/media/dvb/dvb-core/dvb_demux.c
+++ b/drivers/media/dvb/dvb-core/dvb_demux.c
@@ -553,7 +553,7 @@ static void dvb_demux_feed_add(struct dvb_demux_feed *feed)
 	spin_lock_irq(&feed->demux->lock);
 	if (dvb_demux_feed_find(feed)) {
 		printk(KERN_ERR "%s: feed already in list (type=%x state=%x pid=%x)\n",
-		       __FUNCTION__, feed->type, feed->state, feed->pid);
+		       __func__, feed->type, feed->state, feed->pid);
 		goto out;
 	}
 
@@ -567,7 +567,7 @@ static void dvb_demux_feed_del(struct dvb_demux_feed *feed)
 	spin_lock_irq(&feed->demux->lock);
 	if (!(dvb_demux_feed_find(feed))) {
 		printk(KERN_ERR "%s: feed not in list (type=%x state=%x pid=%x)\n",
-		       __FUNCTION__, feed->type, feed->state, feed->pid);
+		       __func__, feed->type, feed->state, feed->pid);
 		goto out;
 	}
 
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
index 925cfa6..2dddd08 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
@@ -135,7 +135,7 @@ static void dvb_frontend_add_event(struct dvb_frontend *fe, fe_status_t status)
 	struct dvb_frontend_event *e;
 	int wp;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (mutex_lock_interruptible (&events->mtx))
 		return;
@@ -171,7 +171,7 @@ static int dvb_frontend_get_event(struct dvb_frontend *fe,
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct dvb_fe_events *events = &fepriv->events;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (events->overflow) {
 		events->overflow = 0;
@@ -237,7 +237,7 @@ static void dvb_frontend_swzigzag_update_delay(struct dvb_frontend_private *fepr
 {
 	int q2;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (locked)
 		(fepriv->quality) = (fepriv->quality * 220 + 36*256) / 256;
@@ -329,7 +329,7 @@ static int dvb_frontend_swzigzag_autotune(struct dvb_frontend *fe, int check_wra
 
 	dprintk("%s: drift:%i inversion:%i auto_step:%i "
 		"auto_sub_step:%i started_auto_step:%i\n",
-		__FUNCTION__, fepriv->lnb_drift, fepriv->inversion,
+		__func__, fepriv->lnb_drift, fepriv->inversion,
 		fepriv->auto_step, fepriv->auto_sub_step, fepriv->started_auto_step);
 
 	/* set the frontend itself */
@@ -511,7 +511,7 @@ static int dvb_frontend_thread(void *data)
 	fe_status_t s;
 	struct dvb_frontend_parameters *params;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	fepriv->check_wrapped = 0;
 	fepriv->quality = 0;
@@ -597,7 +597,7 @@ static void dvb_frontend_stop(struct dvb_frontend *fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	fepriv->exit = 1;
 	mb();
@@ -665,7 +665,7 @@ static int dvb_frontend_start(struct dvb_frontend *fe)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	struct task_struct *fe_thread;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (fepriv->thread) {
 		if (!fepriv->exit)
@@ -763,7 +763,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int err = -EOPNOTSUPP;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (fepriv->exit)
 		return -ENODEV;
@@ -895,7 +895,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			int i;
 			u8 last = 1;
 			if (dvb_frontend_debug)
-				printk("%s switch command: 0x%04lx\n", __FUNCTION__, cmd);
+				printk("%s switch command: 0x%04lx\n", __func__, cmd);
 			do_gettimeofday(&nexttime);
 			if (dvb_frontend_debug)
 				memcpy(&tv[0], &nexttime, sizeof(struct timeval));
@@ -919,7 +919,7 @@ static int dvb_frontend_ioctl(struct inode *inode, struct file *file,
 			}
 			if (dvb_frontend_debug) {
 				printk("%s(%d): switch delay (should be 32k followed by all 8k\n",
-					__FUNCTION__, fe->dvb->num);
+					__func__, fe->dvb->num);
 				for (i = 1; i < 10; i++)
 					printk("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
 			}
@@ -1037,7 +1037,7 @@ static unsigned int dvb_frontend_poll(struct file *file, struct poll_table_struc
 	struct dvb_frontend *fe = dvbdev->priv;
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	poll_wait (file, &fepriv->events.wait_queue, wait);
 
@@ -1054,7 +1054,7 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (dvbdev->users == -1 && fe->ops.ts_bus_ctrl) {
 		if ((ret = fe->ops.ts_bus_ctrl(fe, 1)) < 0)
@@ -1095,7 +1095,7 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
 	int ret;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if ((file->f_flags & O_ACCMODE) != O_RDONLY)
 		fepriv->release_jiffies = jiffies;
@@ -1135,7 +1135,7 @@ int dvb_register_frontend(struct dvb_adapter* dvb,
 		.kernel_ioctl = dvb_frontend_ioctl
 	};
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&frontend_mutex))
 		return -ERESTARTSYS;
@@ -1169,7 +1169,7 @@ EXPORT_SYMBOL(dvb_register_frontend);
 int dvb_unregister_frontend(struct dvb_frontend* fe)
 {
 	struct dvb_frontend_private *fepriv = fe->frontend_priv;
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	mutex_lock(&frontend_mutex);
 	dvb_frontend_stop (fe);
diff --git a/drivers/media/dvb/dvb-core/dvb_net.c b/drivers/media/dvb/dvb-core/dvb_net.c
index ed3f826..b18188d 100644
--- a/drivers/media/dvb/dvb-core/dvb_net.c
+++ b/drivers/media/dvb/dvb-core/dvb_net.c
@@ -965,17 +965,17 @@ static int dvb_net_feed_start(struct net_device *dev)
 	struct dmx_demux *demux = priv->demux;
 	unsigned char *mac = (unsigned char *) dev->dev_addr;
 
-	dprintk("%s: rx_mode %i\n", __FUNCTION__, priv->rx_mode);
+	dprintk("%s: rx_mode %i\n", __func__, priv->rx_mode);
 	mutex_lock(&priv->mutex);
 	if (priv->tsfeed || priv->secfeed || priv->secfilter || priv->multi_secfilter[0])
-		printk("%s: BUG %d\n", __FUNCTION__, __LINE__);
+		printk("%s: BUG %d\n", __func__, __LINE__);
 
 	priv->secfeed=NULL;
 	priv->secfilter=NULL;
 	priv->tsfeed = NULL;
 
 	if (priv->feedtype == DVB_NET_FEEDTYPE_MPE) {
-		dprintk("%s: alloc secfeed\n", __FUNCTION__);
+		dprintk("%s: alloc secfeed\n", __func__);
 		ret=demux->allocate_section_feed(demux, &priv->secfeed,
 					 dvb_net_sec_callback);
 		if (ret<0) {
@@ -993,38 +993,38 @@ static int dvb_net_feed_start(struct net_device *dev)
 		}
 
 		if (priv->rx_mode != RX_MODE_PROMISC) {
-			dprintk("%s: set secfilter\n", __FUNCTION__);
+			dprintk("%s: set secfilter\n", __func__);
 			dvb_net_filter_sec_set(dev, &priv->secfilter, mac, mask_normal);
 		}
 
 		switch (priv->rx_mode) {
 		case RX_MODE_MULTI:
 			for (i = 0; i < priv->multi_num; i++) {
-				dprintk("%s: set multi_secfilter[%d]\n", __FUNCTION__, i);
+				dprintk("%s: set multi_secfilter[%d]\n", __func__, i);
 				dvb_net_filter_sec_set(dev, &priv->multi_secfilter[i],
 						       priv->multi_macs[i], mask_normal);
 			}
 			break;
 		case RX_MODE_ALL_MULTI:
 			priv->multi_num=1;
-			dprintk("%s: set multi_secfilter[0]\n", __FUNCTION__);
+			dprintk("%s: set multi_secfilter[0]\n", __func__);
 			dvb_net_filter_sec_set(dev, &priv->multi_secfilter[0],
 					       mac_allmulti, mask_allmulti);
 			break;
 		case RX_MODE_PROMISC:
 			priv->multi_num=0;
-			dprintk("%s: set secfilter\n", __FUNCTION__);
+			dprintk("%s: set secfilter\n", __func__);
 			dvb_net_filter_sec_set(dev, &priv->secfilter, mac, mask_promisc);
 			break;
 		}
 
-		dprintk("%s: start filtering\n", __FUNCTION__);
+		dprintk("%s: start filtering\n", __func__);
 		priv->secfeed->start_filtering(priv->secfeed);
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		struct timespec timeout = { 0, 10000000 }; // 10 msec
 
 		/* we have payloads encapsulated in TS */
-		dprintk("%s: alloc tsfeed\n", __FUNCTION__);
+		dprintk("%s: alloc tsfeed\n", __func__);
 		ret = demux->allocate_ts_feed(demux, &priv->tsfeed, dvb_net_ts_callback);
 		if (ret < 0) {
 			printk("%s: could not allocate ts feed\n", dev->name);
@@ -1048,7 +1048,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 			goto error;
 		}
 
-		dprintk("%s: start filtering\n", __FUNCTION__);
+		dprintk("%s: start filtering\n", __func__);
 		priv->tsfeed->start_filtering(priv->tsfeed);
 	} else
 		ret = -EINVAL;
@@ -1063,17 +1063,17 @@ static int dvb_net_feed_stop(struct net_device *dev)
 	struct dvb_net_priv *priv = dev->priv;
 	int i, ret = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	mutex_lock(&priv->mutex);
 	if (priv->feedtype == DVB_NET_FEEDTYPE_MPE) {
 		if (priv->secfeed) {
 			if (priv->secfeed->is_filtering) {
-				dprintk("%s: stop secfeed\n", __FUNCTION__);
+				dprintk("%s: stop secfeed\n", __func__);
 				priv->secfeed->stop_filtering(priv->secfeed);
 			}
 
 			if (priv->secfilter) {
-				dprintk("%s: release secfilter\n", __FUNCTION__);
+				dprintk("%s: release secfilter\n", __func__);
 				priv->secfeed->release_filter(priv->secfeed,
 							      priv->secfilter);
 				priv->secfilter=NULL;
@@ -1082,7 +1082,7 @@ static int dvb_net_feed_stop(struct net_device *dev)
 			for (i=0; i<priv->multi_num; i++) {
 				if (priv->multi_secfilter[i]) {
 					dprintk("%s: release multi_filter[%d]\n",
-						__FUNCTION__, i);
+						__func__, i);
 					priv->secfeed->release_filter(priv->secfeed,
 								      priv->multi_secfilter[i]);
 					priv->multi_secfilter[i] = NULL;
@@ -1096,7 +1096,7 @@ static int dvb_net_feed_stop(struct net_device *dev)
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		if (priv->tsfeed) {
 			if (priv->tsfeed->is_filtering) {
-				dprintk("%s: stop tsfeed\n", __FUNCTION__);
+				dprintk("%s: stop tsfeed\n", __func__);
 				priv->tsfeed->stop_filtering(priv->tsfeed);
 			}
 			priv->demux->release_ts_feed(priv->demux, priv->tsfeed);
diff --git a/drivers/media/dvb/dvb-core/dvbdev.c b/drivers/media/dvb/dvb-core/dvbdev.c
index 18738fa..636d564 100644
--- a/drivers/media/dvb/dvb-core/dvbdev.c
+++ b/drivers/media/dvb/dvb-core/dvbdev.c
@@ -196,7 +196,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 	if ((id = dvbdev_get_free_id (adap, type)) < 0){
 		mutex_unlock(&dvbdev_register_lock);
 		*pdvbdev = NULL;
-		printk(KERN_ERR "%s: couldn't find free device id\n", __FUNCTION__);
+		printk(KERN_ERR "%s: couldn't find free device id\n", __func__);
 		return -ENFILE;
 	}
 
@@ -235,7 +235,7 @@ int dvb_register_device(struct dvb_adapter *adap, struct dvb_device **pdvbdev,
 			       "dvb%d.%s%d", adap->num, dnames[type], id);
 	if (IS_ERR(clsdev)) {
 		printk(KERN_ERR "%s: failed to create device dvb%d.%s%d (%ld)\n",
-		       __FUNCTION__, adap->num, dnames[type], id, PTR_ERR(clsdev));
+		       __func__, adap->num, dnames[type], id, PTR_ERR(clsdev));
 		return PTR_ERR(clsdev);
 	}
 
diff --git a/drivers/media/dvb/dvb-usb/cxusb.c b/drivers/media/dvb/dvb-usb/cxusb.c
index c583650..7e3cf5a 100644
--- a/drivers/media/dvb/dvb-usb/cxusb.c
+++ b/drivers/media/dvb/dvb-usb/cxusb.c
@@ -488,14 +488,14 @@ static int dvico_bluebird_xc2028_callback(void *ptr, int command, int arg)
 
 	switch (command) {
 	case XC2028_TUNER_RESET:
-		deb_info("%s: XC2028_TUNER_RESET %d\n", __FUNCTION__, arg);
+		deb_info("%s: XC2028_TUNER_RESET %d\n", __func__, arg);
 		cxusb_bluebird_gpio_pulse(d, 0x01, 1);
 		break;
 	case XC2028_RESET_CLK:
-		deb_info("%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
+		deb_info("%s: XC2028_RESET_CLK %d\n", __func__, arg);
 		break;
 	default:
-		deb_info("%s: unknown command %d, arg %d\n", __FUNCTION__,
+		deb_info("%s: unknown command %d, arg %d\n", __func__,
 			 command, arg);
 		return -EINVAL;
 	}
diff --git a/drivers/media/dvb/dvb-usb/gp8psk-fe.c b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
index e37142d..262a858 100644
--- a/drivers/media/dvb/dvb-usb/gp8psk-fe.c
+++ b/drivers/media/dvb/dvb-usb/gp8psk-fe.c
@@ -152,7 +152,7 @@ static int gp8psk_fe_send_diseqc_msg (struct dvb_frontend* fe,
 {
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	if (gp8psk_usb_out_op(st->d,SEND_DISEQC_COMMAND, m->msg[0], 0,
 			m->msg, m->msg_len)) {
@@ -167,7 +167,7 @@ static int gp8psk_fe_send_diseqc_burst (struct dvb_frontend* fe,
 	struct gp8psk_fe_state *st = fe->demodulator_priv;
 	u8 cmd;
 
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	/* These commands are certainly wrong */
 	cmd = (burst == SEC_MINI_A) ? 0x00 : 0x01;
diff --git a/drivers/media/dvb/dvb-usb/m920x.c b/drivers/media/dvb/dvb-usb/m920x.c
index a956bc5..29ec2b9 100644
--- a/drivers/media/dvb/dvb-usb/m920x.c
+++ b/drivers/media/dvb/dvb-usb/m920x.c
@@ -477,7 +477,7 @@ static struct qt1010_config m920x_qt1010_config = {
 /* Callbacks for DVB USB */
 static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if ((adap->fe = dvb_attach(mt352_attach,
 				   &m920x_mt352_config,
@@ -489,7 +489,7 @@ static int m920x_mt352_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int m920x_tda10046_08_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if ((adap->fe = dvb_attach(tda10046_attach,
 				   &m920x_tda10046_08_config,
@@ -501,7 +501,7 @@ static int m920x_tda10046_08_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int m920x_tda10046_0b_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if ((adap->fe = dvb_attach(tda10046_attach,
 				   &m920x_tda10046_0b_config,
@@ -513,7 +513,7 @@ static int m920x_tda10046_0b_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int m920x_qt1010_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if (dvb_attach(qt1010_attach, adap->fe, &adap->dev->i2c_adap, &m920x_qt1010_config) == NULL)
 		return -ENODEV;
@@ -523,7 +523,7 @@ static int m920x_qt1010_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int m920x_tda8275_60_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if (dvb_attach(tda827x_attach, adap->fe, 0x60, &adap->dev->i2c_adap, NULL) == NULL)
 		return -ENODEV;
@@ -533,7 +533,7 @@ static int m920x_tda8275_60_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int m920x_tda8275_61_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	deb("%s\n",__FUNCTION__);
+	deb("%s\n",__func__);
 
 	if (dvb_attach(tda827x_attach, adap->fe, 0x61, &adap->dev->i2c_adap, NULL) == NULL)
 		return -ENODEV;
diff --git a/drivers/media/dvb/dvb-usb/vp702x-fe.c b/drivers/media/dvb/dvb-usb/vp702x-fe.c
index c3fdc7c..ccc7e44 100644
--- a/drivers/media/dvb/dvb-usb/vp702x-fe.c
+++ b/drivers/media/dvb/dvb-usb/vp702x-fe.c
@@ -67,7 +67,7 @@ static int vp702x_fe_read_status(struct dvb_frontend* fe, fe_status_t *status)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	vp702x_fe_refresh_state(st);
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	if (st->lock == 0)
 		*status = FE_HAS_LOCK | FE_HAS_SYNC | FE_HAS_VITERBI | FE_HAS_SIGNAL | FE_HAS_CARRIER;
@@ -121,7 +121,7 @@ static int vp702x_fe_read_snr(struct dvb_frontend* fe, u16 *snr)
 
 static int vp702x_fe_get_tune_settings(struct dvb_frontend* fe, struct dvb_frontend_tune_settings *tune)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	tune->min_delay_ms = 2000;
 	return 0;
 }
@@ -183,21 +183,21 @@ static int vp702x_fe_set_frontend(struct dvb_frontend* fe,
 static int vp702x_fe_init(struct dvb_frontend *fe)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	vp702x_usb_in_op(st->d, RESET_TUNER, 0, 0, NULL, 0);
 	return 0;
 }
 
 static int vp702x_fe_sleep(struct dvb_frontend *fe)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	return 0;
 }
 
 static int vp702x_fe_get_frontend(struct dvb_frontend* fe,
 				  struct dvb_frontend_parameters *fep)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	return 0;
 }
 
@@ -208,7 +208,7 @@ static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 	u8 cmd[8],ibuf[10];
 	memset(cmd,0,8);
 
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	if (m->msg_len > 4)
 		return -EINVAL;
@@ -230,7 +230,7 @@ static int vp702x_fe_send_diseqc_msg (struct dvb_frontend* fe,
 
 static int vp702x_fe_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t burst)
 {
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 	return 0;
 }
 
@@ -238,7 +238,7 @@ static int vp702x_fe_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	u8 ibuf[10];
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	st->tone_mode = tone;
 
@@ -263,7 +263,7 @@ static int vp702x_fe_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t
 {
 	struct vp702x_fe_state *st = fe->demodulator_priv;
 	u8 ibuf[10];
-	deb_fe("%s\n",__FUNCTION__);
+	deb_fe("%s\n",__func__);
 
 	st->voltage = voltage;
 
diff --git a/drivers/media/dvb/frontends/bcm3510.c b/drivers/media/dvb/frontends/bcm3510.c
index a913f49..d268e65 100644
--- a/drivers/media/dvb/frontends/bcm3510.c
+++ b/drivers/media/dvb/frontends/bcm3510.c
@@ -91,7 +91,7 @@ static int bcm3510_writebytes (struct bcm3510_state *state, u8 reg, u8 *buf, u8
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 
 		deb_info("%s: i2c write error (addr %02x, reg %02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, reg,  err);
+			__func__, state->config->demod_address, reg,  err);
 		return -EREMOTEIO;
 	}
 
@@ -110,7 +110,7 @@ static int bcm3510_readbytes (struct bcm3510_state *state, u8 reg, u8 *buf, u8 l
 
 	if ((err = i2c_transfer (state->i2c, msg, 2)) != 2) {
 		deb_info("%s: i2c read error (addr %02x, reg %02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, reg,  err);
+			__func__, state->config->demod_address, reg,  err);
 		return -EREMOTEIO;
 	}
 	deb_i2c("i2c rd %02x: ",reg);
diff --git a/drivers/media/dvb/frontends/bcm3510.h b/drivers/media/dvb/frontends/bcm3510.h
index 7e4f95e..f4575c0 100644
--- a/drivers/media/dvb/frontends/bcm3510.h
+++ b/drivers/media/dvb/frontends/bcm3510.h
@@ -41,7 +41,7 @@ extern struct dvb_frontend* bcm3510_attach(const struct bcm3510_config* config,
 static inline struct dvb_frontend* bcm3510_attach(const struct bcm3510_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_BCM3510
diff --git a/drivers/media/dvb/frontends/cx22700.c b/drivers/media/dvb/frontends/cx22700.c
index 11a4968..ace5cb1 100644
--- a/drivers/media/dvb/frontends/cx22700.c
+++ b/drivers/media/dvb/frontends/cx22700.c
@@ -73,13 +73,13 @@ static int cx22700_writereg (struct cx22700_state* state, u8 reg, u8 data)
 	u8 buf [] = { reg, data };
 	struct i2c_msg msg = { .addr = state->config->demod_address, .flags = 0, .buf = buf, .len = 2 };
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	ret = i2c_transfer (state->i2c, &msg, 1);
 
 	if (ret != 1)
 		printk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -92,7 +92,7 @@ static int cx22700_readreg (struct cx22700_state* state, u8 reg)
 	struct i2c_msg msg [] = { { .addr = state->config->demod_address, .flags = 0, .buf = b0, .len = 1 },
 			   { .addr = state->config->demod_address, .flags = I2C_M_RD, .buf = b1, .len = 1 } };
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	ret = i2c_transfer (state->i2c, msg, 2);
 
@@ -105,7 +105,7 @@ static int cx22700_set_inversion (struct cx22700_state* state, int inversion)
 {
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	switch (inversion) {
 	case INVERSION_AUTO:
@@ -127,7 +127,7 @@ static int cx22700_set_tps (struct cx22700_state *state, struct dvb_ofdm_paramet
 	static const u8 fec_tab [6] = { 0, 1, 2, 0, 3, 4 };
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (p->code_rate_HP < FEC_1_2 || p->code_rate_HP > FEC_7_8)
 		return -EINVAL;
@@ -191,7 +191,7 @@ static int cx22700_get_tps (struct cx22700_state* state, struct dvb_ofdm_paramet
 						    FEC_5_6, FEC_7_8 };
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (!(cx22700_readreg(state, 0x07) & 0x20))  /*  tps valid? */
 		return -EAGAIN;
diff --git a/drivers/media/dvb/frontends/cx22700.h b/drivers/media/dvb/frontends/cx22700.h
index 7ac3369..4757a93 100644
--- a/drivers/media/dvb/frontends/cx22700.h
+++ b/drivers/media/dvb/frontends/cx22700.h
@@ -38,7 +38,7 @@ extern struct dvb_frontend* cx22700_attach(const struct cx22700_config* config,
 static inline struct dvb_frontend* cx22700_attach(const struct cx22700_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX22700
diff --git a/drivers/media/dvb/frontends/cx22702.c b/drivers/media/dvb/frontends/cx22702.c
index 1dc164d..cd2e5a8 100644
--- a/drivers/media/dvb/frontends/cx22702.c
+++ b/drivers/media/dvb/frontends/cx22702.c
@@ -90,7 +90,7 @@ static int cx22702_writereg (struct cx22702_state* state, u8 reg, u8 data)
 
 	if (ret != 1)
 		printk("%s: writereg error (reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -108,7 +108,7 @@ static u8 cx22702_readreg (struct cx22702_state* state, u8 reg)
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2)
-		printk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		printk("%s: readreg error (ret == %i)\n", __func__, ret);
 
 	return b1[0];
 }
@@ -195,7 +195,7 @@ static int cx22702_get_tps (struct cx22702_state *state, struct dvb_ofdm_paramet
 static int cx22702_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
 	struct cx22702_state* state = fe->demodulator_priv;
-	dprintk ("%s(%d)\n", __FUNCTION__, enable);
+	dprintk ("%s(%d)\n", __func__, enable);
 	if (enable)
 		return cx22702_writereg (state, 0x0D, cx22702_readreg(state, 0x0D) & 0xfe);
 	else
@@ -228,7 +228,7 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		cx22702_writereg(state, 0x0C, cx22702_readreg(state, 0x0C) &0xcf );
 		break;
 	default:
-		dprintk ("%s: invalid bandwidth\n",__FUNCTION__);
+		dprintk ("%s: invalid bandwidth\n",__func__);
 		return -EINVAL;
 	}
 
@@ -250,7 +250,7 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		cx22702_writereg(state, 0x0B, cx22702_readreg(state, 0x0B) & 0xfc );
 		cx22702_writereg(state, 0x0C, (cx22702_readreg(state, 0x0C) & 0xBF) | 0x40 );
 		cx22702_writereg(state, 0x00, 0x01); /* Begin aquisition */
-		dprintk("%s: Autodetecting\n",__FUNCTION__);
+		dprintk("%s: Autodetecting\n",__func__);
 		return 0;
 	}
 
@@ -261,7 +261,7 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		case QAM_16: val = (val&0xe7)|0x08; break;
 		case QAM_64: val = (val&0xe7)|0x10; break;
 		default:
-			dprintk ("%s: invalid constellation\n",__FUNCTION__);
+			dprintk ("%s: invalid constellation\n",__func__);
 			return -EINVAL;
 	}
 	switch(p->u.ofdm.hierarchy_information) {
@@ -270,7 +270,7 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		case    HIERARCHY_2: val = (val&0xf8)|2; break;
 		case    HIERARCHY_4: val = (val&0xf8)|3; break;
 		default:
-			dprintk ("%s: invalid hierarchy\n",__FUNCTION__);
+			dprintk ("%s: invalid hierarchy\n",__func__);
 			return -EINVAL;
 	}
 	cx22702_writereg (state, 0x06, val);
@@ -284,7 +284,7 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		case FEC_5_6: val = (val&0xc7)|0x18; break;
 		case FEC_7_8: val = (val&0xc7)|0x20; break;
 		default:
-			dprintk ("%s: invalid code_rate_HP\n",__FUNCTION__);
+			dprintk ("%s: invalid code_rate_HP\n",__func__);
 			return -EINVAL;
 	}
 	switch(p->u.ofdm.code_rate_LP) {
@@ -295,7 +295,7 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		case FEC_5_6: val = (val&0xf8)|3; break;
 		case FEC_7_8: val = (val&0xf8)|4; break;
 		default:
-			dprintk ("%s: invalid code_rate_LP\n",__FUNCTION__);
+			dprintk ("%s: invalid code_rate_LP\n",__func__);
 			return -EINVAL;
 	}
 	cx22702_writereg (state, 0x07, val);
@@ -307,14 +307,14 @@ static int cx22702_set_tps (struct dvb_frontend* fe, struct dvb_frontend_paramet
 		case  GUARD_INTERVAL_1_8: val = (val&0xf3)|0x08; break;
 		case  GUARD_INTERVAL_1_4: val = (val&0xf3)|0x0c; break;
 		default:
-			dprintk ("%s: invalid guard_interval\n",__FUNCTION__);
+			dprintk ("%s: invalid guard_interval\n",__func__);
 			return -EINVAL;
 	}
 	switch(p->u.ofdm.transmission_mode) {
 		case TRANSMISSION_MODE_2K: val = (val&0xfc); break;
 		case TRANSMISSION_MODE_8K: val = (val&0xfc)|1; break;
 		default:
-			dprintk ("%s: invalid transmission_mode\n",__FUNCTION__);
+			dprintk ("%s: invalid transmission_mode\n",__func__);
 			return -EINVAL;
 	}
 	cx22702_writereg(state, 0x08, val);
@@ -360,7 +360,7 @@ static int cx22702_read_status(struct dvb_frontend* fe, fe_status_t* status)
 	reg23 = cx22702_readreg (state, 0x23);
 
 	dprintk ("%s: status demod=0x%02x agc=0x%02x\n"
-		,__FUNCTION__,reg0A,reg23);
+		,__func__,reg0A,reg23);
 
 	if(reg0A & 0x10) {
 		*status |= FE_HAS_LOCK;
diff --git a/drivers/media/dvb/frontends/cx22702.h b/drivers/media/dvb/frontends/cx22702.h
index 9cd64da..8af766a 100644
--- a/drivers/media/dvb/frontends/cx22702.h
+++ b/drivers/media/dvb/frontends/cx22702.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* cx22702_attach(const struct cx22702_config* config,
 static inline struct dvb_frontend* cx22702_attach(const struct cx22702_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX22702
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index b03d828..87ae29d 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -121,7 +121,7 @@ static int cx24110_writereg (struct cx24110_state* state, int reg, int data)
 
 	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
 		dprintk ("%s: writereg error (err == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+			 " data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -247,7 +247,7 @@ static int cx24110_set_symbolrate (struct cx24110_state* state, u32 srate)
 	static const u32 bands[]={5000000UL,15000000UL,90999000UL/2};
 	int i;
 
-	dprintk("cx24110 debug: entering %s(%d)\n",__FUNCTION__,srate);
+	dprintk("cx24110 debug: entering %s(%d)\n",__func__,srate);
 	if (srate>90999000UL/2)
 		srate=90999000UL/2;
 	if (srate<500000)
@@ -358,7 +358,7 @@ static int cx24110_initfe(struct dvb_frontend* fe)
 /* fixme (low): error handling */
 	int i;
 
-	dprintk("%s: init chip\n", __FUNCTION__);
+	dprintk("%s: init chip\n", __func__);
 
 	for(i = 0; i < ARRAY_SIZE(cx24110_regdata); i++) {
 		cx24110_writereg(state, cx24110_regdata[i].reg, cx24110_regdata[i].data);
diff --git a/drivers/media/dvb/frontends/cx24110.h b/drivers/media/dvb/frontends/cx24110.h
index 0ca3af4..1792adb 100644
--- a/drivers/media/dvb/frontends/cx24110.h
+++ b/drivers/media/dvb/frontends/cx24110.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* cx24110_attach(const struct cx24110_config* config,
 static inline struct dvb_frontend* cx24110_attach(const struct cx24110_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX24110
diff --git a/drivers/media/dvb/frontends/cx24123.c b/drivers/media/dvb/frontends/cx24123.c
index d74fdbd..11aa15a 100644
--- a/drivers/media/dvb/frontends/cx24123.c
+++ b/drivers/media/dvb/frontends/cx24123.c
@@ -233,11 +233,11 @@ static int cx24123_writereg(struct cx24123_state* state, int reg, int data)
 
 	if (debug>1)
 		printk("cx24123: %s:  write reg 0x%02x, value 0x%02x\n",
-						__FUNCTION__,reg, data);
+						__func__,reg, data);
 
 	if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
 		printk("%s: writereg error(err == %i, reg == 0x%02x,"
-			 " data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+			 " data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -257,7 +257,7 @@ static int cx24123_readreg(struct cx24123_state* state, u8 reg)
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		printk("%s: reg=0x%x (error=%d)\n", __FUNCTION__, reg, ret);
+		printk("%s: reg=0x%x (error=%d)\n", __func__, reg, ret);
 		return ret;
 	}
 
@@ -274,17 +274,17 @@ static int cx24123_set_inversion(struct cx24123_state* state, fe_spectral_invers
 
 	switch (inversion) {
 	case INVERSION_OFF:
-		dprintk("%s:  inversion off\n",__FUNCTION__);
+		dprintk("%s:  inversion off\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg & ~0x80);
 		cx24123_writereg(state, 0x10, auto_reg | 0x80);
 		break;
 	case INVERSION_ON:
-		dprintk("%s:  inversion on\n",__FUNCTION__);
+		dprintk("%s:  inversion on\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x80);
 		cx24123_writereg(state, 0x10, auto_reg | 0x80);
 		break;
 	case INVERSION_AUTO:
-		dprintk("%s:  inversion auto\n",__FUNCTION__);
+		dprintk("%s:  inversion auto\n",__func__);
 		cx24123_writereg(state, 0x10, auto_reg & ~0x80);
 		break;
 	default:
@@ -301,10 +301,10 @@ static int cx24123_get_inversion(struct cx24123_state* state, fe_spectral_invers
 	val = cx24123_readreg(state, 0x1b) >> 7;
 
 	if (val == 0) {
-		dprintk("%s:  read inversion off\n",__FUNCTION__);
+		dprintk("%s:  read inversion off\n",__func__);
 		*inversion = INVERSION_OFF;
 	} else {
-		dprintk("%s:  read inversion on\n",__FUNCTION__);
+		dprintk("%s:  read inversion on\n",__func__);
 		*inversion = INVERSION_ON;
 	}
 
@@ -326,42 +326,42 @@ static int cx24123_set_fec(struct cx24123_state* state, fe_code_rate_t fec)
 
 	switch (fec) {
 	case FEC_1_2:
-		dprintk("%s:  set FEC to 1/2\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 1/2\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x01);
 		cx24123_writereg(state, 0x0f, 0x02);
 		break;
 	case FEC_2_3:
-		dprintk("%s:  set FEC to 2/3\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 2/3\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x02);
 		cx24123_writereg(state, 0x0f, 0x04);
 		break;
 	case FEC_3_4:
-		dprintk("%s:  set FEC to 3/4\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 3/4\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x03);
 		cx24123_writereg(state, 0x0f, 0x08);
 		break;
 	case FEC_4_5:
-		dprintk("%s:  set FEC to 4/5\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 4/5\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x04);
 		cx24123_writereg(state, 0x0f, 0x10);
 		break;
 	case FEC_5_6:
-		dprintk("%s:  set FEC to 5/6\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 5/6\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x05);
 		cx24123_writereg(state, 0x0f, 0x20);
 		break;
 	case FEC_6_7:
-		dprintk("%s:  set FEC to 6/7\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 6/7\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x06);
 		cx24123_writereg(state, 0x0f, 0x40);
 		break;
 	case FEC_7_8:
-		dprintk("%s:  set FEC to 7/8\n",__FUNCTION__);
+		dprintk("%s:  set FEC to 7/8\n",__func__);
 		cx24123_writereg(state, 0x0e, nom_reg | 0x07);
 		cx24123_writereg(state, 0x0f, 0x80);
 		break;
 	case FEC_AUTO:
-		dprintk("%s:  set FEC to auto\n",__FUNCTION__);
+		dprintk("%s:  set FEC to auto\n",__func__);
 		cx24123_writereg(state, 0x0f, 0xfe);
 		break;
 	default:
@@ -490,7 +490,7 @@ static int cx24123_set_symbolrate(struct cx24123_state* state, u32 srate)
 	tmp = cx24123_readreg(state, 0x0c) & ~0xe0;
 	cx24123_writereg(state, 0x0c, tmp | sample_gain << 5);
 
-	dprintk("%s: srate=%d, ratio=0x%08x, sample_rate=%i sample_gain=%d\n", __FUNCTION__, srate, ratio, sample_rate, sample_gain);
+	dprintk("%s: srate=%d, ratio=0x%08x, sample_rate=%i sample_gain=%d\n", __func__, srate, ratio, sample_rate, sample_gain);
 
 	return 0;
 }
@@ -570,7 +570,7 @@ static int cx24123_pll_writereg(struct dvb_frontend* fe, struct dvb_frontend_par
 	struct cx24123_state *state = fe->demodulator_priv;
 	unsigned long timeout;
 
-	dprintk("%s:  pll writereg called, data=0x%08x\n",__FUNCTION__,data);
+	dprintk("%s:  pll writereg called, data=0x%08x\n",__func__,data);
 
 	/* align the 21 bytes into to bit23 boundary */
 	data = data << 3;
@@ -583,7 +583,7 @@ static int cx24123_pll_writereg(struct dvb_frontend* fe, struct dvb_frontend_par
 	cx24123_writereg(state, 0x22, (data >> 16) & 0xff);
 	while ((cx24123_readreg(state, 0x20) & 0x40) == 0) {
 		if (time_after(jiffies, timeout)) {
-			printk("%s:  demodulator is not responding, possibly hung, aborting.\n", __FUNCTION__);
+			printk("%s:  demodulator is not responding, possibly hung, aborting.\n", __func__);
 			return -EREMOTEIO;
 		}
 		msleep(10);
@@ -594,7 +594,7 @@ static int cx24123_pll_writereg(struct dvb_frontend* fe, struct dvb_frontend_par
 	cx24123_writereg(state, 0x22, (data>>8) & 0xff );
 	while ((cx24123_readreg(state, 0x20) & 0x40) == 0) {
 		if (time_after(jiffies, timeout)) {
-			printk("%s:  demodulator is not responding, possibly hung, aborting.\n", __FUNCTION__);
+			printk("%s:  demodulator is not responding, possibly hung, aborting.\n", __func__);
 			return -EREMOTEIO;
 		}
 		msleep(10);
@@ -605,7 +605,7 @@ static int cx24123_pll_writereg(struct dvb_frontend* fe, struct dvb_frontend_par
 	cx24123_writereg(state, 0x22, (data) & 0xff );
 	while ((cx24123_readreg(state, 0x20) & 0x80)) {
 		if (time_after(jiffies, timeout)) {
-			printk("%s:  demodulator is not responding, possibly hung, aborting.\n", __FUNCTION__);
+			printk("%s:  demodulator is not responding, possibly hung, aborting.\n", __func__);
 			return -EREMOTEIO;
 		}
 		msleep(10);
@@ -626,7 +626,7 @@ static int cx24123_pll_tune(struct dvb_frontend* fe, struct dvb_frontend_paramet
 	dprintk("frequency=%i\n", p->frequency);
 
 	if (cx24123_pll_calculate(fe, p) != 0) {
-		printk("%s: cx24123_pll_calcutate failed\n",__FUNCTION__);
+		printk("%s: cx24123_pll_calcutate failed\n",__func__);
 		return -EINVAL;
 	}
 
@@ -643,7 +643,7 @@ static int cx24123_pll_tune(struct dvb_frontend* fe, struct dvb_frontend_paramet
 	cx24123_writereg(state, 0x27, state->FILTune >> 2);
 	cx24123_writereg(state, 0x28, val | (state->FILTune & 0x3));
 
-	dprintk("%s:  pll tune VCA=%d, band=%d, pll=%d\n",__FUNCTION__,state->VCAarg,
+	dprintk("%s:  pll tune VCA=%d, band=%d, pll=%d\n",__func__,state->VCAarg,
 			state->bandselectarg,state->pllarg);
 
 	return 0;
@@ -654,7 +654,7 @@ static int cx24123_initfe(struct dvb_frontend* fe)
 	struct cx24123_state *state = fe->demodulator_priv;
 	int i;
 
-	dprintk("%s:  init frontend\n",__FUNCTION__);
+	dprintk("%s:  init frontend\n",__func__);
 
 	/* Configure the demod to a good set of defaults */
 	for (i = 0; i < ARRAY_SIZE(cx24123_regdata); i++)
@@ -676,10 +676,10 @@ static int cx24123_set_voltage(struct dvb_frontend* fe, fe_sec_voltage_t voltage
 
 	switch (voltage) {
 	case SEC_VOLTAGE_13:
-		dprintk("%s: setting voltage 13V\n", __FUNCTION__);
+		dprintk("%s: setting voltage 13V\n", __func__);
 		return cx24123_writereg(state, 0x29, val & 0x7f);
 	case SEC_VOLTAGE_18:
-		dprintk("%s: setting voltage 18V\n", __FUNCTION__);
+		dprintk("%s: setting voltage 18V\n", __func__);
 		return cx24123_writereg(state, 0x29, val | 0x80);
 	case SEC_VOLTAGE_OFF:
 		/* already handled in cx88-dvb */
@@ -697,7 +697,7 @@ static void cx24123_wait_for_diseqc(struct cx24123_state *state)
 	unsigned long timeout = jiffies + msecs_to_jiffies(200);
 	while (!(cx24123_readreg(state, 0x29) & 0x40)) {
 		if(time_after(jiffies, timeout)) {
-			printk("%s: diseqc queue not ready, command may be lost.\n", __FUNCTION__);
+			printk("%s: diseqc queue not ready, command may be lost.\n", __func__);
 			break;
 		}
 		msleep(10);
@@ -709,7 +709,7 @@ static int cx24123_send_diseqc_msg(struct dvb_frontend* fe, struct dvb_diseqc_ma
 	struct cx24123_state *state = fe->demodulator_priv;
 	int i, val, tone;
 
-	dprintk("%s:\n",__FUNCTION__);
+	dprintk("%s:\n",__func__);
 
 	/* stop continuous tone if enabled */
 	tone = cx24123_readreg(state, 0x29);
@@ -744,7 +744,7 @@ static int cx24123_diseqc_send_burst(struct dvb_frontend* fe, fe_sec_mini_cmd_t
 	struct cx24123_state *state = fe->demodulator_priv;
 	int val, tone;
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	/* stop continuous tone if enabled */
 	tone = cx24123_readreg(state, 0x29);
@@ -813,7 +813,7 @@ static int cx24123_read_ber(struct dvb_frontend* fe, u32* ber)
 		(cx24123_readreg(state, 0x1d) << 8 |
 		 cx24123_readreg(state, 0x1e));
 
-	dprintk("%s:  BER = %d\n",__FUNCTION__,*ber);
+	dprintk("%s:  BER = %d\n",__func__,*ber);
 
 	return 0;
 }
@@ -824,7 +824,7 @@ static int cx24123_read_signal_strength(struct dvb_frontend* fe, u16* signal_str
 
 	*signal_strength = cx24123_readreg(state, 0x3b) << 8; /* larger = better */
 
-	dprintk("%s:  Signal strength = %d\n",__FUNCTION__,*signal_strength);
+	dprintk("%s:  Signal strength = %d\n",__func__,*signal_strength);
 
 	return 0;
 }
@@ -838,7 +838,7 @@ static int cx24123_read_snr(struct dvb_frontend* fe, u16* snr)
 	*snr = 65535 - (((u16)cx24123_readreg(state, 0x18) << 8) |
 			 (u16)cx24123_readreg(state, 0x19));
 
-	dprintk("%s:  read S/N index = %d\n",__FUNCTION__,*snr);
+	dprintk("%s:  read S/N index = %d\n",__func__,*snr);
 
 	return 0;
 }
@@ -847,7 +847,7 @@ static int cx24123_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 {
 	struct cx24123_state *state = fe->demodulator_priv;
 
-	dprintk("%s:  set_frontend\n",__FUNCTION__);
+	dprintk("%s:  set_frontend\n",__func__);
 
 	if (state->config->set_ts_params)
 		state->config->set_ts_params(fe, 0);
@@ -872,14 +872,14 @@ static int cx24123_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 {
 	struct cx24123_state *state = fe->demodulator_priv;
 
-	dprintk("%s:  get_frontend\n",__FUNCTION__);
+	dprintk("%s:  get_frontend\n",__func__);
 
 	if (cx24123_get_inversion(state, &p->inversion) != 0) {
-		printk("%s: Failed to get inversion status\n",__FUNCTION__);
+		printk("%s: Failed to get inversion status\n",__func__);
 		return -EREMOTEIO;
 	}
 	if (cx24123_get_fec(state, &p->u.qpsk.fec_inner) != 0) {
-		printk("%s: Failed to get fec status\n",__FUNCTION__);
+		printk("%s: Failed to get fec status\n",__func__);
 		return -EREMOTEIO;
 	}
 	p->frequency = state->currentfreq;
@@ -900,13 +900,13 @@ static int cx24123_set_tone(struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 
 	switch (tone) {
 	case SEC_TONE_ON:
-		dprintk("%s: setting tone on\n", __FUNCTION__);
+		dprintk("%s: setting tone on\n", __func__);
 		return cx24123_writereg(state, 0x29, val | 0x10);
 	case SEC_TONE_OFF:
-		dprintk("%s: setting tone off\n",__FUNCTION__);
+		dprintk("%s: setting tone off\n",__func__);
 		return cx24123_writereg(state, 0x29, val & 0xef);
 	default:
-		printk("%s: CASE reached default with tone=%d\n", __FUNCTION__, tone);
+		printk("%s: CASE reached default with tone=%d\n", __func__, tone);
 		return -EINVAL;
 	}
 
@@ -939,7 +939,7 @@ static int cx24123_get_algo(struct dvb_frontend *fe)
 static void cx24123_release(struct dvb_frontend* fe)
 {
 	struct cx24123_state* state = fe->demodulator_priv;
-	dprintk("%s\n",__FUNCTION__);
+	dprintk("%s\n",__func__);
 	kfree(state);
 }
 
@@ -951,7 +951,7 @@ struct dvb_frontend* cx24123_attach(const struct cx24123_config* config,
 	struct cx24123_state* state = NULL;
 	int ret;
 
-	dprintk("%s\n",__FUNCTION__);
+	dprintk("%s\n",__func__);
 
 	/* allocate memory for the internal state */
 	state = kmalloc(sizeof(struct cx24123_state), GFP_KERNEL);
diff --git a/drivers/media/dvb/frontends/cx24123.h b/drivers/media/dvb/frontends/cx24123.h
index 84f9e4f..00fc2f1 100644
--- a/drivers/media/dvb/frontends/cx24123.h
+++ b/drivers/media/dvb/frontends/cx24123.h
@@ -42,7 +42,7 @@ extern struct dvb_frontend* cx24123_attach(const struct cx24123_config* config,
 static inline struct dvb_frontend* cx24123_attach(const struct cx24123_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_CX24123
diff --git a/drivers/media/dvb/frontends/dib3000.h b/drivers/media/dvb/frontends/dib3000.h
index a6d3854..ba91735 100644
--- a/drivers/media/dvb/frontends/dib3000.h
+++ b/drivers/media/dvb/frontends/dib3000.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* dib3000mb_attach(const struct dib3000_config* config
 static inline struct dvb_frontend* dib3000mb_attach(const struct dib3000_config* config,
 					     struct i2c_adapter* i2c, struct dib_fe_xfer_ops *xfer_ops)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_DIB3000MB
diff --git a/drivers/media/dvb/frontends/dib3000mc.h b/drivers/media/dvb/frontends/dib3000mc.h
index 72d4757..4142ed7 100644
--- a/drivers/media/dvb/frontends/dib3000mc.h
+++ b/drivers/media/dvb/frontends/dib3000mc.h
@@ -44,7 +44,7 @@ extern struct dvb_frontend * dib3000mc_attach(struct i2c_adapter *i2c_adap, u8 i
 #else
 static inline struct dvb_frontend * dib3000mc_attach(struct i2c_adapter *i2c_adap, u8 i2c_addr, struct dib3000mc_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_DIB3000MC
diff --git a/drivers/media/dvb/frontends/dvb-pll.c b/drivers/media/dvb/frontends/dvb-pll.c
index 8c8d734..e74d24e 100644
--- a/drivers/media/dvb/frontends/dvb-pll.c
+++ b/drivers/media/dvb/frontends/dvb-pll.c
@@ -422,7 +422,7 @@ static void tuv1236d_rf(struct dvb_frontend *fe, u8 *buf,
 		default:
 			printk(KERN_WARNING
 			       "%s: unhandled rf input selection: %d",
-			       __FUNCTION__, new_rf);
+			       __func__, new_rf);
 	}
 }
 
diff --git a/drivers/media/dvb/frontends/dvb-pll.h b/drivers/media/dvb/frontends/dvb-pll.h
index e93a810..83f85ef 100644
--- a/drivers/media/dvb/frontends/dvb-pll.h
+++ b/drivers/media/dvb/frontends/dvb-pll.h
@@ -52,7 +52,7 @@ static inline struct dvb_frontend *dvb_pll_attach(struct dvb_frontend *fe,
 					   struct i2c_adapter *i2c,
 					   unsigned int pll_desc_id)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/dvb/frontends/isl6421.h b/drivers/media/dvb/frontends/isl6421.h
index ea7f78a..47e4518 100644
--- a/drivers/media/dvb/frontends/isl6421.h
+++ b/drivers/media/dvb/frontends/isl6421.h
@@ -47,7 +47,7 @@ extern struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_a
 static inline struct dvb_frontend *isl6421_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 i2c_addr,
 						  u8 override_set, u8 override_clear)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_ISL6421
diff --git a/drivers/media/dvb/frontends/l64781.c b/drivers/media/dvb/frontends/l64781.c
index 443d904..e1e70e9 100644
--- a/drivers/media/dvb/frontends/l64781.c
+++ b/drivers/media/dvb/frontends/l64781.c
@@ -57,7 +57,7 @@ static int l64781_writereg (struct l64781_state* state, u8 reg, u8 data)
 
 	if ((ret = i2c_transfer(state->i2c, &msg, 1)) != 1)
 		dprintk ("%s: write_reg error (reg == %02x) = %02x!\n",
-			 __FUNCTION__, reg, ret);
+			 __func__, reg, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
diff --git a/drivers/media/dvb/frontends/l64781.h b/drivers/media/dvb/frontends/l64781.h
index cd15f76..1305a9e 100644
--- a/drivers/media/dvb/frontends/l64781.h
+++ b/drivers/media/dvb/frontends/l64781.h
@@ -38,7 +38,7 @@ extern struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 static inline struct dvb_frontend* l64781_attach(const struct l64781_config* config,
 					  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_L64781
diff --git a/drivers/media/dvb/frontends/lgdt330x.c b/drivers/media/dvb/frontends/lgdt330x.c
index bdc9fa8..130adda 100644
--- a/drivers/media/dvb/frontends/lgdt330x.c
+++ b/drivers/media/dvb/frontends/lgdt330x.c
@@ -88,7 +88,7 @@ static int i2c_write_demod_bytes (struct lgdt330x_state* state,
 
 	for (i=0; i<len-1; i+=2){
 		if ((err = i2c_transfer(state->i2c, &msg, 1)) != 1) {
-			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n", __FUNCTION__, msg.buf[0], msg.buf[1], err);
+			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n", __func__, msg.buf[0], msg.buf[1], err);
 			if (err < 0)
 				return err;
 			else
@@ -117,7 +117,7 @@ static u8 i2c_read_demod_bytes (struct lgdt330x_state* state,
 	int ret;
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
-		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __FUNCTION__, state->config->demod_address, reg, ret);
+		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n", __func__, state->config->demod_address, reg, ret);
 	} else {
 		ret = 0;
 	}
@@ -256,7 +256,7 @@ static int lgdt330x_init(struct dvb_frontend* fe)
 		printk (KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
-	dprintk("%s entered as %s\n", __FUNCTION__, chip_name);
+	dprintk("%s entered as %s\n", __func__, chip_name);
 	if (err < 0)
 		return err;
 	return lgdt330x_SwReset(state);
@@ -334,7 +334,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 	if (state->current_modulation != param->u.vsb.modulation) {
 		switch(param->u.vsb.modulation) {
 		case VSB_8:
-			dprintk("%s: VSB_8 MODE\n", __FUNCTION__);
+			dprintk("%s: VSB_8 MODE\n", __func__);
 
 			/* Select VSB mode */
 			top_ctrl_cfg[1] = 0x03;
@@ -350,7 +350,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 			break;
 
 		case QAM_64:
-			dprintk("%s: QAM_64 MODE\n", __FUNCTION__);
+			dprintk("%s: QAM_64 MODE\n", __func__);
 
 			/* Select QAM_64 mode */
 			top_ctrl_cfg[1] = 0x00;
@@ -366,7 +366,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 			break;
 
 		case QAM_256:
-			dprintk("%s: QAM_256 MODE\n", __FUNCTION__);
+			dprintk("%s: QAM_256 MODE\n", __func__);
 
 			/* Select QAM_256 mode */
 			top_ctrl_cfg[1] = 0x01;
@@ -381,7 +381,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend* fe,
 			}
 			break;
 		default:
-			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __FUNCTION__, param->u.vsb.modulation);
+			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n", __func__, param->u.vsb.modulation);
 			return -1;
 		}
 		/*
@@ -431,7 +431,7 @@ static int lgdt3302_read_status(struct dvb_frontend* fe, fe_status_t* status)
 
 	/* AGC status register */
 	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
-	dprintk("%s: AGC_STATUS = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
 	if ((buf[0] & 0x0c) == 0x8){
 		/* Test signal does not exist flag */
 		/* as well as the AGC lock flag.   */
@@ -445,7 +445,7 @@ static int lgdt3302_read_status(struct dvb_frontend* fe, fe_status_t* status)
 	 */
 	/* signal status */
 	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
-	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n", __FUNCTION__, buf[0], buf[1], buf[2]);
+	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n", __func__, buf[0], buf[1], buf[2]);
 
 
 	/* sync status */
@@ -461,7 +461,7 @@ static int lgdt3302_read_status(struct dvb_frontend* fe, fe_status_t* status)
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __func__, buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -474,7 +474,7 @@ static int lgdt3302_read_status(struct dvb_frontend* fe, fe_status_t* status)
 			*status |= FE_HAS_CARRIER;
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __FUNCTION__);
+		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __func__);
 	}
 
 	return 0;
@@ -493,7 +493,7 @@ static int lgdt3303_read_status(struct dvb_frontend* fe, fe_status_t* status)
 	if (err < 0)
 		return err;
 
-	dprintk("%s: AGC_STATUS = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
 	if ((buf[0] & 0x21) == 0x01){
 		/* Test input signal does not exist flag */
 		/* as well as the AGC lock flag.   */
@@ -502,7 +502,7 @@ static int lgdt3303_read_status(struct dvb_frontend* fe, fe_status_t* status)
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __FUNCTION__, buf[0]);
+	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __func__, buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -533,7 +533,7 @@ static int lgdt3303_read_status(struct dvb_frontend* fe, fe_status_t* status)
 		}
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __FUNCTION__);
+		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n", __func__);
 	}
 	return 0;
 }
@@ -607,14 +607,14 @@ static int lgdt3302_read_snr(struct dvb_frontend* fe, u16* snr)
 		break;
 	default:
 		printk(KERN_ERR "lgdt330x: %s: Modulation set to unsupported value\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __FUNCTION__, noise,
+	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -651,14 +651,14 @@ static int lgdt3303_read_snr(struct dvb_frontend* fe, u16* snr)
 		break;
 	default:
 		printk(KERN_ERR "lgdt330x: %s: Modulation set to unsupported value\n",
-		       __FUNCTION__);
+		       __func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __FUNCTION__, noise,
+	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -743,7 +743,7 @@ struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 
 error:
 	kfree(state);
-	dprintk("%s: ERROR\n",__FUNCTION__);
+	dprintk("%s: ERROR\n",__func__);
 	return NULL;
 }
 
diff --git a/drivers/media/dvb/frontends/lgdt330x.h b/drivers/media/dvb/frontends/lgdt330x.h
index 9950590..9012504 100644
--- a/drivers/media/dvb/frontends/lgdt330x.h
+++ b/drivers/media/dvb/frontends/lgdt330x.h
@@ -59,7 +59,7 @@ extern struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config
 static inline struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
 					    struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_LGDT330X
diff --git a/drivers/media/dvb/frontends/lnbp21.h b/drivers/media/dvb/frontends/lnbp21.h
index 68906ac..8fe094b 100644
--- a/drivers/media/dvb/frontends/lnbp21.h
+++ b/drivers/media/dvb/frontends/lnbp21.h
@@ -45,7 +45,7 @@ extern struct dvb_frontend *lnbp21_attach(struct dvb_frontend *fe, struct i2c_ad
 #else
 static inline struct dvb_frontend *lnbp21_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, u8 override_set, u8 override_clear)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_LNBP21
diff --git a/drivers/media/dvb/frontends/mt2060.h b/drivers/media/dvb/frontends/mt2060.h
index 0a86eab..acba005 100644
--- a/drivers/media/dvb/frontends/mt2060.h
+++ b/drivers/media/dvb/frontends/mt2060.h
@@ -35,7 +35,7 @@ extern struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_a
 #else
 static inline struct dvb_frontend * mt2060_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2060_config *cfg, u16 if1)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_MT2060
diff --git a/drivers/media/dvb/frontends/mt2131.c b/drivers/media/dvb/frontends/mt2131.c
index 13cf166..e254bcf 100644
--- a/drivers/media/dvb/frontends/mt2131.c
+++ b/drivers/media/dvb/frontends/mt2131.c
@@ -110,7 +110,7 @@ static int mt2131_set_params(struct dvb_frontend *fe,
 		priv->bandwidth = 0;
 
 	freq = params->frequency / 1000;  // Hz -> kHz
-	dprintk(1, "%s() freq=%d\n", __FUNCTION__, freq);
+	dprintk(1, "%s() freq=%d\n", __func__, freq);
 
 	f_lo1 = freq + MT2131_IF1 * 1000;
 	f_lo1 = (f_lo1 / 250) * 250;
@@ -187,7 +187,7 @@ static int mt2131_set_params(struct dvb_frontend *fe,
 static int mt2131_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	*frequency = priv->frequency;
 	return 0;
 }
@@ -195,7 +195,7 @@ static int mt2131_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 static int mt2131_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	*bandwidth = priv->bandwidth;
 	return 0;
 }
@@ -214,7 +214,7 @@ static int mt2131_get_status(struct dvb_frontend *fe, u32 *status)
 
 	mt2131_readreg(priv, 0x09, &afc_status);
 	dprintk(1, "%s() - LO Status = 0x%x, AFC Status = 0x%x\n",
-		__FUNCTION__, lock_status, afc_status);
+		__func__, lock_status, afc_status);
 
 	return 0;
 }
@@ -223,7 +223,7 @@ static int mt2131_init(struct dvb_frontend *fe)
 {
 	struct mt2131_priv *priv = fe->tuner_priv;
 	int ret;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if ((ret = mt2131_writeregs(priv, mt2131_config1,
 				    sizeof(mt2131_config1))) < 0)
@@ -243,7 +243,7 @@ static int mt2131_init(struct dvb_frontend *fe)
 
 static int mt2131_release(struct dvb_frontend *fe)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
 	return 0;
@@ -273,7 +273,7 @@ struct dvb_frontend * mt2131_attach(struct dvb_frontend *fe,
 	struct mt2131_priv *priv = NULL;
 	u8 id = 0;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	priv = kzalloc(sizeof(struct mt2131_priv), GFP_KERNEL);
 	if (priv == NULL)
diff --git a/drivers/media/dvb/frontends/mt2131.h b/drivers/media/dvb/frontends/mt2131.h
index 1e4ffe7..606d857 100644
--- a/drivers/media/dvb/frontends/mt2131.h
+++ b/drivers/media/dvb/frontends/mt2131.h
@@ -41,7 +41,7 @@ static inline struct dvb_frontend* mt2131_attach(struct dvb_frontend *fe,
 						 struct mt2131_config *cfg,
 						 u16 if1)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_TUNER_MT2131 */
diff --git a/drivers/media/dvb/frontends/mt2266.h b/drivers/media/dvb/frontends/mt2266.h
index f31dd61..c5113ef 100644
--- a/drivers/media/dvb/frontends/mt2266.h
+++ b/drivers/media/dvb/frontends/mt2266.h
@@ -29,7 +29,7 @@ extern struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_a
 #else
 static inline struct dvb_frontend * mt2266_attach(struct dvb_frontend *fe, struct i2c_adapter *i2c, struct mt2266_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_MT2266
diff --git a/drivers/media/dvb/frontends/mt312.c b/drivers/media/dvb/frontends/mt312.c
index 1638301..daca855 100644
--- a/drivers/media/dvb/frontends/mt312.c
+++ b/drivers/media/dvb/frontends/mt312.c
@@ -76,7 +76,7 @@ static int mt312_read(struct mt312_state *state, const enum mt312_reg_addr reg,
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		printk(KERN_ERR "%s: ret == %d\n", __FUNCTION__, ret);
+		printk(KERN_ERR "%s: ret == %d\n", __func__, ret);
 		return -EREMOTEIO;
 	}
 
@@ -117,7 +117,7 @@ static int mt312_write(struct mt312_state *state, const enum mt312_reg_addr reg,
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1) {
-		dprintk("%s: ret == %d\n", __FUNCTION__, ret);
+		dprintk("%s: ret == %d\n", __func__, ret);
 		return -EREMOTEIO;
 	}
 
@@ -499,7 +499,7 @@ static int mt312_set_frontend(struct dvb_frontend *fe,
 	    { 0x00, 0x01, 0x02, 0x04, 0x3f, 0x08, 0x10, 0x20, 0x3f, 0x3f };
 	const u8 inv_tab[3] = { 0x00, 0x40, 0x80 };
 
-	dprintk("%s: Freq %d\n", __FUNCTION__, p->frequency);
+	dprintk("%s: Freq %d\n", __func__, p->frequency);
 
 	if ((p->frequency < fe->ops.info.frequency_min)
 	    || (p->frequency > fe->ops.info.frequency_max))
diff --git a/drivers/media/dvb/frontends/mt312.h b/drivers/media/dvb/frontends/mt312.h
index f17cb93..afe24fd 100644
--- a/drivers/media/dvb/frontends/mt312.h
+++ b/drivers/media/dvb/frontends/mt312.h
@@ -40,7 +40,7 @@ struct dvb_frontend *vp310_mt312_attach(const struct mt312_config *config,
 static inline struct dvb_frontend *vp310_mt312_attach(
 	const struct mt312_config *config, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_MT312 */
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index 7cd190b..beba5aa 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -95,7 +95,7 @@ static int mt352_read_register(struct mt352_state* state, u8 reg)
 
 	if (ret != 2) {
 		printk("%s: readreg error (reg=%d, ret==%i)\n",
-		       __FUNCTION__, reg, ret);
+		       __func__, reg, ret);
 		return ret;
 	}
 
@@ -135,7 +135,7 @@ static void mt352_calc_nominal_rate(struct mt352_state* state,
 	value = 64 * bw * (1<<16) / (7 * 8);
 	value = value * 1000 / adc_clock;
 	dprintk("%s: bw %d, adc_clock %d => 0x%x\n",
-		__FUNCTION__, bw, adc_clock, value);
+		__func__, bw, adc_clock, value);
 	buf[0] = msb(value);
 	buf[1] = lsb(value);
 }
@@ -161,7 +161,7 @@ static void mt352_calc_input_freq(struct mt352_state* state,
 	}
 	value = -16374 * ife / adc_clock;
 	dprintk("%s: if2 %d, ife %d, adc_clock %d => %d / 0x%x\n",
-		__FUNCTION__, if2, ife, adc_clock, value, value & 0x3fff);
+		__func__, if2, ife, adc_clock, value, value & 0x3fff);
 	buf[0] = msb(value);
 	buf[1] = lsb(value);
 }
@@ -521,7 +521,7 @@ static int mt352_init(struct dvb_frontend* fe)
 
 	static u8 mt352_reset_attach [] = { RESET, 0xC0 };
 
-	dprintk("%s: hello\n",__FUNCTION__);
+	dprintk("%s: hello\n",__func__);
 
 	if ((mt352_read_register(state, CLOCK_CTL) & 0x10) == 0 ||
 	    (mt352_read_register(state, CONFIG) & 0x20) == 0) {
diff --git a/drivers/media/dvb/frontends/mt352.h b/drivers/media/dvb/frontends/mt352.h
index e996408..595092f 100644
--- a/drivers/media/dvb/frontends/mt352.h
+++ b/drivers/media/dvb/frontends/mt352.h
@@ -58,7 +58,7 @@ extern struct dvb_frontend* mt352_attach(const struct mt352_config* config,
 static inline struct dvb_frontend* mt352_attach(const struct mt352_config* config,
 					 struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_MT352
diff --git a/drivers/media/dvb/frontends/nxt200x.c b/drivers/media/dvb/frontends/nxt200x.c
index fcf964f..23d0228 100644
--- a/drivers/media/dvb/frontends/nxt200x.c
+++ b/drivers/media/dvb/frontends/nxt200x.c
@@ -74,7 +74,7 @@ static int i2c_writebytes (struct nxt200x_state* state, u8 addr, u8 *buf, u8 len
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk (KERN_WARNING "nxt200x: %s: i2c write error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, addr, err);
+			__func__, addr, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -87,7 +87,7 @@ static u8 i2c_readbytes (struct nxt200x_state* state, u8 addr, u8* buf, u8 len)
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk (KERN_WARNING "nxt200x: %s: i2c read error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, addr, err);
+			__func__, addr, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -104,7 +104,7 @@ static int nxt200x_writebytes (struct nxt200x_state* state, u8 reg, u8 *buf, u8
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk (KERN_WARNING "nxt200x: %s: i2c write error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, err);
+			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -121,7 +121,7 @@ static u8 nxt200x_readbytes (struct nxt200x_state* state, u8 reg, u8* buf, u8 le
 
 	if ((err = i2c_transfer (state->i2c, msg, 2)) != 2) {
 		printk (KERN_WARNING "nxt200x: %s: i2c read error (addr 0x%02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, err);
+			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
 	return 0;
@@ -146,7 +146,7 @@ static u16 nxt200x_crc(u16 crc, u8 c)
 static int nxt200x_writereg_multibyte (struct nxt200x_state* state, u8 reg, u8* data, u8 len)
 {
 	u8 attr, len2, buf;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set mutli register register */
 	nxt200x_writebytes(state, 0x35, &reg, 1);
@@ -207,7 +207,7 @@ static int nxt200x_readreg_multibyte (struct nxt200x_state* state, u8 reg, u8* d
 {
 	int i;
 	u8 buf, len2, attr;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set mutli register register */
 	nxt200x_writebytes(state, 0x35, &reg, 1);
@@ -254,7 +254,7 @@ static int nxt200x_readreg_multibyte (struct nxt200x_state* state, u8 reg, u8* d
 static void nxt200x_microcontroller_stop (struct nxt200x_state* state)
 {
 	u8 buf, stopval, counter = 0;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* set correct stop value */
 	switch (state->demod_chip) {
@@ -287,7 +287,7 @@ static void nxt200x_microcontroller_stop (struct nxt200x_state* state)
 static void nxt200x_microcontroller_start (struct nxt200x_state* state)
 {
 	u8 buf;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	buf = 0x00;
 	nxt200x_writebytes(state, 0x22, &buf, 1);
@@ -297,7 +297,7 @@ static void nxt2004_microcontroller_init (struct nxt200x_state* state)
 {
 	u8 buf[9];
 	u8 counter = 0;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	buf[0] = 0x00;
 	nxt200x_writebytes(state, 0x2b, buf, 1);
@@ -328,7 +328,7 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 {
 	u8 buf, count = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dprintk("Tuner Bytes: %02X %02X %02X %02X\n", data[1], data[2], data[3], data[4]);
 
@@ -387,7 +387,7 @@ static int nxt200x_writetuner (struct nxt200x_state* state, u8* data)
 static void nxt200x_agc_reset(struct nxt200x_state* state)
 {
 	u8 buf;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	switch (state->demod_chip) {
 		case NXT2002:
@@ -416,7 +416,7 @@ static int nxt2002_load_firmware (struct dvb_frontend* fe, const struct firmware
 	u8 buf[3], written = 0, chunkpos = 0;
 	u16 rambase, position, crc = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	dprintk("Firmware is %zu bytes\n", fw->size);
 
 	/* Get the RAM base for this nxt2002 */
@@ -483,7 +483,7 @@ static int nxt2004_load_firmware (struct dvb_frontend* fe, const struct firmware
 	u8 buf[3];
 	u16 rambase, position, crc=0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	dprintk("Firmware is %zu bytes\n", fw->size);
 
 	/* set rambase */
diff --git a/drivers/media/dvb/frontends/nxt200x.h b/drivers/media/dvb/frontends/nxt200x.h
index bb0ef58..f3c8458 100644
--- a/drivers/media/dvb/frontends/nxt200x.h
+++ b/drivers/media/dvb/frontends/nxt200x.h
@@ -49,7 +49,7 @@ extern struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 static inline struct dvb_frontend* nxt200x_attach(const struct nxt200x_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_NXT200X
diff --git a/drivers/media/dvb/frontends/nxt6000.h b/drivers/media/dvb/frontends/nxt6000.h
index 13d2251..878eb38 100644
--- a/drivers/media/dvb/frontends/nxt6000.h
+++ b/drivers/media/dvb/frontends/nxt6000.h
@@ -40,7 +40,7 @@ extern struct dvb_frontend* nxt6000_attach(const struct nxt6000_config* config,
 static inline struct dvb_frontend* nxt6000_attach(const struct nxt6000_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_NXT6000
diff --git a/drivers/media/dvb/frontends/or51132.c b/drivers/media/dvb/frontends/or51132.c
index 1d2d28c..8a64cb4 100644
--- a/drivers/media/dvb/frontends/or51132.c
+++ b/drivers/media/dvb/frontends/or51132.c
@@ -419,7 +419,7 @@ static int or51132_read_status(struct dvb_frontend* fe, fe_status_t* status)
 		*status = 0;
 		return -EREMOTEIO;
 	}
-	dprintk("%s: read_status %04x\n", __FUNCTION__, reg);
+	dprintk("%s: read_status %04x\n", __func__, reg);
 
 	if (reg & 0x0100) /* Receiver Lock */
 		*status = FE_HAS_SIGNAL|FE_HAS_CARRIER|FE_HAS_VITERBI|
@@ -504,14 +504,14 @@ start:
 		if (retry--) goto start;
 		return -EREMOTEIO;
 	}
-	dprintk("%s: modulation %02x, NTSC rej O%s\n", __FUNCTION__,
+	dprintk("%s: modulation %02x, NTSC rej O%s\n", __func__,
 		reg&0xff, reg&0x1000?"n":"ff");
 
 	/* Calculate SNR using noise, c, and NTSC rejection correction */
 	state->snr = calculate_snr(noise, c) - usK;
 	*snr = (state->snr) >> 16;
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __FUNCTION__, noise,
+	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
diff --git a/drivers/media/dvb/frontends/or51132.h b/drivers/media/dvb/frontends/or51132.h
index add24f0..1b8e04d 100644
--- a/drivers/media/dvb/frontends/or51132.h
+++ b/drivers/media/dvb/frontends/or51132.h
@@ -41,7 +41,7 @@ extern struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 static inline struct dvb_frontend* or51132_attach(const struct or51132_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_OR51132
diff --git a/drivers/media/dvb/frontends/or51211.c b/drivers/media/dvb/frontends/or51211.c
index 6a6b0d7..7eaa476 100644
--- a/drivers/media/dvb/frontends/or51211.c
+++ b/drivers/media/dvb/frontends/or51211.c
@@ -307,19 +307,19 @@ static int or51211_read_snr(struct dvb_frontend* fe, u16* snr)
 
 	if (i2c_writebytes(state,state->config->demod_address,snd_buf,3)) {
 		printk(KERN_WARNING "%s: error writing snr reg\n",
-		       __FUNCTION__);
+		       __func__);
 		return -1;
 	}
 	if (i2c_readbytes(state,state->config->demod_address,rec_buf,2)) {
 		printk(KERN_WARNING "%s: read_status read error\n",
-		       __FUNCTION__);
+		       __func__);
 		return -1;
 	}
 
 	state->snr = calculate_snr(rec_buf[0], 89599047);
 	*snr = (state->snr) >> 16;
 
-	dprintk("%s: noise = 0x%02x, snr = %d.%02d dB\n", __FUNCTION__, rec_buf[0],
+	dprintk("%s: noise = 0x%02x, snr = %d.%02d dB\n", __func__, rec_buf[0],
 		state->snr >> 24, (((state->snr>>8) & 0xffff) * 100) >> 16);
 
 	return 0;
diff --git a/drivers/media/dvb/frontends/or51211.h b/drivers/media/dvb/frontends/or51211.h
index 8aad840..3ce0508 100644
--- a/drivers/media/dvb/frontends/or51211.h
+++ b/drivers/media/dvb/frontends/or51211.h
@@ -44,7 +44,7 @@ extern struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 static inline struct dvb_frontend* or51211_attach(const struct or51211_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_OR51211
diff --git a/drivers/media/dvb/frontends/qt1010.h b/drivers/media/dvb/frontends/qt1010.h
index 3ab4aa0..cff6a7c 100644
--- a/drivers/media/dvb/frontends/qt1010.h
+++ b/drivers/media/dvb/frontends/qt1010.h
@@ -45,7 +45,7 @@ static inline struct dvb_frontend *qt1010_attach(struct dvb_frontend *fe,
 						 struct i2c_adapter *i2c,
 						 struct qt1010_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_QT1010
diff --git a/drivers/media/dvb/frontends/s5h1409.c b/drivers/media/dvb/frontends/s5h1409.c
index 8194334..38bf984 100644
--- a/drivers/media/dvb/frontends/s5h1409.c
+++ b/drivers/media/dvb/frontends/s5h1409.c
@@ -312,7 +312,7 @@ static int s5h1409_writereg(struct s5h1409_state* state, u8 reg, u16 data)
 
 	if (ret != 1)
 		printk("%s: writereg error (reg == 0x%02x, val == 0x%04x, "
-		       "ret == %i)\n", __FUNCTION__, reg, data, ret);
+		       "ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -332,7 +332,7 @@ static u16 s5h1409_readreg(struct s5h1409_state* state, u8 reg)
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2)
-		printk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		printk("%s: readreg error (ret == %i)\n", __func__, ret);
 	return (b1[0] << 8) | b1[1];
 }
 
@@ -340,7 +340,7 @@ static int s5h1409_softreset(struct dvb_frontend* fe)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	s5h1409_writereg(state, 0xf5, 0);
 	s5h1409_writereg(state, 0xf5, 1);
@@ -356,7 +356,7 @@ static int s5h1409_set_if_freq(struct dvb_frontend* fe, int KHz)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d KHz)\n", __FUNCTION__, KHz);
+	dprintk("%s(%d KHz)\n", __func__, KHz);
 
 	switch (KHz) {
 	case 4000:
@@ -381,7 +381,7 @@ static int s5h1409_set_spectralinversion(struct dvb_frontend* fe, int inverted)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, inverted);
+	dprintk("%s(%d)\n", __func__, inverted);
 
 	if(inverted == 1)
 		return s5h1409_writereg(state, 0x1b, 0x1101); /* Inverted */
@@ -394,25 +394,25 @@ static int s5h1409_enable_modulation(struct dvb_frontend* fe,
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(0x%08x)\n", __FUNCTION__, m);
+	dprintk("%s(0x%08x)\n", __func__, m);
 
 	switch(m) {
 	case VSB_8:
-		dprintk("%s() VSB_8\n", __FUNCTION__);
+		dprintk("%s() VSB_8\n", __func__);
 		if (state->if_freq != S5H1409_VSB_IF_FREQ)
 			s5h1409_set_if_freq(fe, S5H1409_VSB_IF_FREQ);
 		s5h1409_writereg(state, 0xf4, 0);
 		break;
 	case QAM_64:
 	case QAM_256:
-		dprintk("%s() QAM_AUTO (64/256)\n", __FUNCTION__);
+		dprintk("%s() QAM_AUTO (64/256)\n", __func__);
 		if (state->if_freq != S5H1409_QAM_IF_FREQ)
 			s5h1409_set_if_freq(fe, S5H1409_QAM_IF_FREQ);
 		s5h1409_writereg(state, 0xf4, 1);
 		s5h1409_writereg(state, 0x85, 0x110);
 		break;
 	default:
-		dprintk("%s() Invalid modulation\n", __FUNCTION__);
+		dprintk("%s() Invalid modulation\n", __func__);
 		return -EINVAL;
 	}
 
@@ -426,7 +426,7 @@ static int s5h1409_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, enable);
+	dprintk("%s(%d)\n", __func__, enable);
 
 	if (enable)
 		return s5h1409_writereg(state, 0xf3, 1);
@@ -438,7 +438,7 @@ static int s5h1409_set_gpio(struct dvb_frontend* fe, int enable)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, enable);
+	dprintk("%s(%d)\n", __func__, enable);
 
 	if (enable)
 		return s5h1409_writereg(state, 0xe3,
@@ -452,7 +452,7 @@ static int s5h1409_sleep(struct dvb_frontend* fe, int enable)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(%d)\n", __FUNCTION__, enable);
+	dprintk("%s(%d)\n", __func__, enable);
 
 	return s5h1409_writereg(state, 0xf2, enable);
 }
@@ -461,7 +461,7 @@ static int s5h1409_register_reset(struct dvb_frontend* fe)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	return s5h1409_writereg(state, 0xfa, 0);
 }
@@ -534,7 +534,7 @@ static int s5h1409_set_frontend (struct dvb_frontend* fe,
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 
-	dprintk("%s(frequency=%d)\n", __FUNCTION__, p->frequency);
+	dprintk("%s(frequency=%d)\n", __func__, p->frequency);
 
 	s5h1409_softreset(fe);
 
@@ -565,7 +565,7 @@ static int s5h1409_set_mpeg_timing(struct dvb_frontend *fe, int mode)
 	struct s5h1409_state *state = fe->demodulator_priv;
 	u16 val;
 
-	dprintk("%s(%d)\n", __FUNCTION__, mode);
+	dprintk("%s(%d)\n", __func__, mode);
 
 	val = s5h1409_readreg(state, 0xac) & 0xcfff;
 	switch (mode) {
@@ -573,7 +573,7 @@ static int s5h1409_set_mpeg_timing(struct dvb_frontend *fe, int mode)
 		val |= 0x0000;
 		break;
 	case S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK:
-		dprintk("%s(%d) Mode1 or Defaulting\n", __FUNCTION__, mode);
+		dprintk("%s(%d) Mode1 or Defaulting\n", __func__, mode);
 		val |= 0x1000;
 		break;
 	case S5H1409_MPEGTIMING_NONCONTINOUS_INVERTING_CLOCK:
@@ -597,7 +597,7 @@ static int s5h1409_init (struct dvb_frontend* fe)
 	int i;
 
 	struct s5h1409_state* state = fe->demodulator_priv;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	s5h1409_sleep(fe, 0);
 	s5h1409_register_reset(fe);
@@ -663,7 +663,7 @@ static int s5h1409_read_status(struct dvb_frontend* fe, fe_status_t* status)
 		break;
 	}
 
-	dprintk("%s() status 0x%08x\n", __FUNCTION__, *status);
+	dprintk("%s() status 0x%08x\n", __func__, *status);
 
 	return 0;
 }
@@ -671,7 +671,7 @@ static int s5h1409_read_status(struct dvb_frontend* fe, fe_status_t* status)
 static int s5h1409_qam256_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 {
 	int i, ret = -EINVAL;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	for (i=0; i < ARRAY_SIZE(qam256_snr_tab); i++) {
 		if (v < qam256_snr_tab[i].val) {
@@ -686,7 +686,7 @@ static int s5h1409_qam256_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 static int s5h1409_qam64_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 {
 	int i, ret = -EINVAL;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	for (i=0; i < ARRAY_SIZE(qam64_snr_tab); i++) {
 		if (v < qam64_snr_tab[i].val) {
@@ -701,7 +701,7 @@ static int s5h1409_qam64_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 static int s5h1409_vsb_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 {
 	int i, ret = -EINVAL;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	for (i=0; i < ARRAY_SIZE(vsb_snr_tab); i++) {
 		if (v > vsb_snr_tab[i].val) {
@@ -710,7 +710,7 @@ static int s5h1409_vsb_lookup_snr(struct dvb_frontend* fe, u16* snr, u16 v)
 			break;
 		}
 	}
-	dprintk("%s() snr=%d\n", __FUNCTION__, *snr);
+	dprintk("%s() snr=%d\n", __func__, *snr);
 	return ret;
 }
 
@@ -718,7 +718,7 @@ static int s5h1409_read_snr(struct dvb_frontend* fe, u16* snr)
 {
 	struct s5h1409_state* state = fe->demodulator_priv;
 	u16 reg;
-	dprintk("%s()\n", __FUNCTION__);
+	dprintk("%s()\n", __func__);
 
 	switch(state->current_modulation) {
 	case QAM_64:
@@ -812,7 +812,7 @@ struct dvb_frontend* s5h1409_attach(const struct s5h1409_config* config,
 
 	if (s5h1409_init(&state->frontend) != 0) {
 		printk(KERN_ERR "%s: Failed to initialize correctly\n",
-			__FUNCTION__);
+			__func__);
 		goto error;
 	}
 
diff --git a/drivers/media/dvb/frontends/s5h1409.h b/drivers/media/dvb/frontends/s5h1409.h
index f0bb13f..59f4335 100644
--- a/drivers/media/dvb/frontends/s5h1409.h
+++ b/drivers/media/dvb/frontends/s5h1409.h
@@ -67,7 +67,7 @@ extern struct dvb_frontend* s5h1409_attach(const struct s5h1409_config* config,
 static inline struct dvb_frontend* s5h1409_attach(const struct s5h1409_config* config,
 						  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_S5H1409 */
diff --git a/drivers/media/dvb/frontends/s5h1420.c b/drivers/media/dvb/frontends/s5h1420.c
index 2c2c344..2f3d61b 100644
--- a/drivers/media/dvb/frontends/s5h1420.c
+++ b/drivers/media/dvb/frontends/s5h1420.c
@@ -63,7 +63,7 @@ static int s5h1420_writereg (struct s5h1420_state* state, u8 reg, u8 data)
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
diff --git a/drivers/media/dvb/frontends/s5h1420.h b/drivers/media/dvb/frontends/s5h1420.h
index 1555870..2cc7850 100644
--- a/drivers/media/dvb/frontends/s5h1420.h
+++ b/drivers/media/dvb/frontends/s5h1420.h
@@ -41,7 +41,7 @@ extern struct dvb_frontend* s5h1420_attach(const struct s5h1420_config* config,
 static inline struct dvb_frontend* s5h1420_attach(const struct s5h1420_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_S5H1420
diff --git a/drivers/media/dvb/frontends/sp8870.c b/drivers/media/dvb/frontends/sp8870.c
index da876f7..4c379c4 100644
--- a/drivers/media/dvb/frontends/sp8870.c
+++ b/drivers/media/dvb/frontends/sp8870.c
@@ -70,7 +70,7 @@ static int sp8870_writereg (struct sp8870_state* state, u16 reg, u16 data)
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -88,7 +88,7 @@ static int sp8870_readreg (struct sp8870_state* state, u16 reg)
 	ret = i2c_transfer (state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dprintk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		dprintk("%s: readreg error (ret == %i)\n", __func__, ret);
 		return -1;
 	}
 
@@ -104,7 +104,7 @@ static int sp8870_firmware_upload (struct sp8870_state* state, const struct firm
 	int tx_len;
 	int err = 0;
 
-	dprintk ("%s: ...\n", __FUNCTION__);
+	dprintk ("%s: ...\n", __func__);
 
 	if (fw->size < SP8870_FIRMWARE_SIZE + SP8870_FIRMWARE_OFFSET)
 		return -EINVAL;
@@ -131,14 +131,14 @@ static int sp8870_firmware_upload (struct sp8870_state* state, const struct firm
 		msg.buf = tx_buf;
 		msg.len = tx_len + 2;
 		if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-			printk("%s: firmware upload failed!\n", __FUNCTION__);
-			printk ("%s: i2c error (err == %i)\n", __FUNCTION__, err);
+			printk("%s: firmware upload failed!\n", __func__);
+			printk ("%s: i2c error (err == %i)\n", __func__, err);
 			return err;
 		}
 		fw_pos += tx_len;
 	}
 
-	dprintk ("%s: done!\n", __FUNCTION__);
+	dprintk ("%s: done!\n", __func__);
 	return 0;
 };
 
@@ -310,7 +310,7 @@ static int sp8870_init (struct dvb_frontend* fe)
 	if (state->initialised) return 0;
 	state->initialised = 1;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 
 	/* request the firmware, this will block until someone uploads it */
@@ -475,7 +475,7 @@ static int sp8870_set_frontend (struct dvb_frontend* fe, struct dvb_frontend_par
 	int trials = 0;
 	int check_count = 0;
 
-	dprintk("%s: frequency = %i\n", __FUNCTION__, p->frequency);
+	dprintk("%s: frequency = %i\n", __func__, p->frequency);
 
 	for (trials = 1; trials <= MAXTRIALS; trials++) {
 
@@ -487,7 +487,7 @@ static int sp8870_set_frontend (struct dvb_frontend* fe, struct dvb_frontend_par
 			valid = sp8870_read_data_valid_signal(state);
 			if (valid) {
 				dprintk("%s: delay = %i usec\n",
-					__FUNCTION__, check_count * 10);
+					__func__, check_count * 10);
 				break;
 			}
 			udelay(10);
@@ -497,20 +497,20 @@ static int sp8870_set_frontend (struct dvb_frontend* fe, struct dvb_frontend_par
 	}
 
 	if (!valid) {
-		printk("%s: firmware crash!!!!!!\n", __FUNCTION__);
+		printk("%s: firmware crash!!!!!!\n", __func__);
 		return -EIO;
 	}
 
 	if (debug) {
 		if (valid) {
 			if (trials > 1) {
-				printk("%s: firmware lockup!!!\n", __FUNCTION__);
-				printk("%s: recovered after %i trial(s))\n",  __FUNCTION__, trials - 1);
+				printk("%s: firmware lockup!!!\n", __func__);
+				printk("%s: recovered after %i trial(s))\n",  __func__, trials - 1);
 				lockups++;
 			}
 		}
 		switches++;
-		printk("%s: switches = %i lockups = %i\n", __FUNCTION__, switches, lockups);
+		printk("%s: switches = %i lockups = %i\n", __func__, switches, lockups);
 	}
 
 	return 0;
diff --git a/drivers/media/dvb/frontends/sp8870.h b/drivers/media/dvb/frontends/sp8870.h
index 909cefe..a764a79 100644
--- a/drivers/media/dvb/frontends/sp8870.h
+++ b/drivers/media/dvb/frontends/sp8870.h
@@ -42,7 +42,7 @@ extern struct dvb_frontend* sp8870_attach(const struct sp8870_config* config,
 static inline struct dvb_frontend* sp8870_attach(const struct sp8870_config* config,
 					  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_SP8870
diff --git a/drivers/media/dvb/frontends/sp887x.c b/drivers/media/dvb/frontends/sp887x.c
index 1aa2539..49f5587 100644
--- a/drivers/media/dvb/frontends/sp887x.c
+++ b/drivers/media/dvb/frontends/sp887x.c
@@ -43,7 +43,7 @@ static int i2c_writebytes (struct sp887x_state* state, u8 *buf, u8 len)
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
 		printk ("%s: i2c write error (addr %02x, err == %i)\n",
-			__FUNCTION__, state->config->demod_address, err);
+			__func__, state->config->demod_address, err);
 		return -EREMOTEIO;
 	}
 
@@ -65,7 +65,7 @@ static int sp887x_writereg (struct sp887x_state* state, u16 reg, u16 data)
 		{
 			printk("%s: writereg error "
 			       "(reg %03x, data %03x, ret == %i)\n",
-			       __FUNCTION__, reg & 0xffff, data & 0xffff, ret);
+			       __func__, reg & 0xffff, data & 0xffff, ret);
 			return ret;
 		}
 	}
@@ -82,7 +82,7 @@ static int sp887x_readreg (struct sp887x_state* state, u16 reg)
 			 { .addr = state->config->demod_address, .flags = I2C_M_RD, .buf = b1, .len = 2 }};
 
 	if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-		printk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		printk("%s: readreg error (ret == %i)\n", __func__, ret);
 		return -1;
 	}
 
@@ -91,7 +91,7 @@ static int sp887x_readreg (struct sp887x_state* state, u16 reg)
 
 static void sp887x_microcontroller_stop (struct sp887x_state* state)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	sp887x_writereg(state, 0xf08, 0x000);
 	sp887x_writereg(state, 0xf09, 0x000);
 
@@ -101,7 +101,7 @@ static void sp887x_microcontroller_stop (struct sp887x_state* state)
 
 static void sp887x_microcontroller_start (struct sp887x_state* state)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	sp887x_writereg(state, 0xf08, 0x000);
 	sp887x_writereg(state, 0xf09, 0x000);
 
@@ -112,7 +112,7 @@ static void sp887x_microcontroller_start (struct sp887x_state* state)
 static void sp887x_setup_agc (struct sp887x_state* state)
 {
 	/* setup AGC parameters */
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	sp887x_writereg(state, 0x33c, 0x054);
 	sp887x_writereg(state, 0x33b, 0x04c);
 	sp887x_writereg(state, 0x328, 0x000);
@@ -142,7 +142,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 	int fw_size = fw->size;
 	unsigned char *mem = fw->data;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	/* ignore the first 10 bytes, then we expect 0x4000 bytes of firmware */
 	if (fw_size < FW_SIZE+10)
@@ -155,7 +155,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 
 	sp887x_microcontroller_stop (state);
 
-	printk ("%s: firmware upload... ", __FUNCTION__);
+	printk ("%s: firmware upload... ", __func__);
 
 	/* setup write pointer to -1 (end of memory) */
 	/* bit 0x8000 in address is set to enable 13bit mode */
@@ -181,7 +181,7 @@ static int sp887x_initial_setup (struct dvb_frontend* fe, const struct firmware
 
 		if ((err = i2c_writebytes (state, buf, c+2)) < 0) {
 			printk ("failed.\n");
-			printk ("%s: i2c error (err == %i)\n", __FUNCTION__, err);
+			printk ("%s: i2c error (err == %i)\n", __func__, err);
 			return err;
 		}
 	}
diff --git a/drivers/media/dvb/frontends/sp887x.h b/drivers/media/dvb/frontends/sp887x.h
index 7ee78d7..04eff6e 100644
--- a/drivers/media/dvb/frontends/sp887x.h
+++ b/drivers/media/dvb/frontends/sp887x.h
@@ -24,7 +24,7 @@ extern struct dvb_frontend* sp887x_attach(const struct sp887x_config* config,
 static inline struct dvb_frontend* sp887x_attach(const struct sp887x_config* config,
 					  struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_SP887X
diff --git a/drivers/media/dvb/frontends/stv0297.c b/drivers/media/dvb/frontends/stv0297.c
index 7c23775..62caf80 100644
--- a/drivers/media/dvb/frontends/stv0297.c
+++ b/drivers/media/dvb/frontends/stv0297.c
@@ -58,7 +58,7 @@ static int stv0297_writereg(struct stv0297_state *state, u8 reg, u8 data)
 
 	if (ret != 1)
 		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __FUNCTION__, reg, data, ret);
+			"ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -75,16 +75,16 @@ static int stv0297_readreg(struct stv0297_state *state, u8 reg)
 	// this device needs a STOP between the register and data
 	if (state->config->stop_during_read) {
 		if ((ret = i2c_transfer(state->i2c, &msg[0], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg, ret);
 			return -1;
 		}
 		if ((ret = i2c_transfer(state->i2c, &msg[1], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg, ret);
 			return -1;
 		}
 	} else {
 		if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg, ret);
 			return -1;
 		}
 	}
@@ -115,16 +115,16 @@ static int stv0297_readregs(struct stv0297_state *state, u8 reg1, u8 * b, u8 len
 	// this device needs a STOP between the register and data
 	if (state->config->stop_during_read) {
 		if ((ret = i2c_transfer(state->i2c, &msg[0], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg1, ret);
 			return -1;
 		}
 		if ((ret = i2c_transfer(state->i2c, &msg[1], 1)) != 1) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg1, ret);
 			return -1;
 		}
 	} else {
 		if ((ret = i2c_transfer(state->i2c, msg, 2)) != 2) {
-			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __FUNCTION__, reg1, ret);
+			dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n", __func__, reg1, ret);
 			return -1;
 		}
 	}
diff --git a/drivers/media/dvb/frontends/stv0297.h b/drivers/media/dvb/frontends/stv0297.h
index 69f4515..3f8f946 100644
--- a/drivers/media/dvb/frontends/stv0297.h
+++ b/drivers/media/dvb/frontends/stv0297.h
@@ -49,7 +49,7 @@ extern struct dvb_frontend* stv0297_attach(const struct stv0297_config* config,
 static inline struct dvb_frontend* stv0297_attach(const struct stv0297_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_STV0297
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 035dd7b..f7c3674 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -86,7 +86,7 @@ static int stv0299_writeregI (struct stv0299_state* state, u8 reg, u8 data)
 
 	if (ret != 1)
 		dprintk("%s: writereg error (reg == 0x%02x, val == 0x%02x, "
-			"ret == %i)\n", __FUNCTION__, reg, data, ret);
+			"ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -113,7 +113,7 @@ static u8 stv0299_readreg (struct stv0299_state* state, u8 reg)
 
 	if (ret != 2)
 		dprintk("%s: readreg error (reg == 0x%02x, ret == %i)\n",
-				__FUNCTION__, reg, ret);
+				__func__, reg, ret);
 
 	return b1[0];
 }
@@ -127,14 +127,14 @@ static int stv0299_readregs (struct stv0299_state* state, u8 reg1, u8 *b, u8 len
 	ret = i2c_transfer (state->i2c, msg, 2);
 
 	if (ret != 2)
-		dprintk("%s: readreg error (ret == %i)\n", __FUNCTION__, ret);
+		dprintk("%s: readreg error (ret == %i)\n", __func__, ret);
 
 	return ret == 2 ? 0 : ret;
 }
 
 static int stv0299_set_FEC (struct stv0299_state* state, fe_code_rate_t fec)
 {
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	switch (fec) {
 	case FEC_AUTO:
@@ -174,7 +174,7 @@ static fe_code_rate_t stv0299_get_fec (struct stv0299_state* state)
 					     FEC_7_8, FEC_1_2 };
 	u8 index;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	index = stv0299_readreg (state, 0x1b);
 	index &= 0x7;
@@ -189,11 +189,11 @@ static int stv0299_wait_diseqc_fifo (struct stv0299_state* state, int timeout)
 {
 	unsigned long start = jiffies;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	while (stv0299_readreg(state, 0x0a) & 1) {
 		if (jiffies - start > timeout) {
-			dprintk ("%s: timeout!!\n", __FUNCTION__);
+			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(10);
@@ -206,11 +206,11 @@ static int stv0299_wait_diseqc_idle (struct stv0299_state* state, int timeout)
 {
 	unsigned long start = jiffies;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	while ((stv0299_readreg(state, 0x0a) & 3) != 2 ) {
 		if (jiffies - start > timeout) {
-			dprintk ("%s: timeout!!\n", __FUNCTION__);
+			dprintk ("%s: timeout!!\n", __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(10);
@@ -245,7 +245,7 @@ static int stv0299_get_symbolrate (struct stv0299_state* state)
 	u8 sfr[3];
 	s8 rtf;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	stv0299_readregs (state, 0x1f, sfr, 3);
 	stv0299_readregs (state, 0x1a, (u8 *)&rtf, 1);
@@ -257,8 +257,8 @@ static int stv0299_get_symbolrate (struct stv0299_state* state)
 	offset = (s32) rtf * (srate / 4096L);
 	offset /= 128;
 
-	dprintk ("%s : srate = %i\n", __FUNCTION__, srate);
-	dprintk ("%s : ofset = %i\n", __FUNCTION__, offset);
+	dprintk ("%s : srate = %i\n", __func__, srate);
+	dprintk ("%s : ofset = %i\n", __func__, offset);
 
 	srate += offset;
 
@@ -276,7 +276,7 @@ static int stv0299_send_diseqc_msg (struct dvb_frontend* fe,
 	u8 val;
 	int i;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (stv0299_wait_diseqc_idle (state, 100) < 0)
 		return -ETIMEDOUT;
@@ -305,7 +305,7 @@ static int stv0299_send_diseqc_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t
 	struct stv0299_state* state = fe->demodulator_priv;
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (stv0299_wait_diseqc_idle (state, 100) < 0)
 		return -ETIMEDOUT;
@@ -355,7 +355,7 @@ static int stv0299_set_voltage (struct dvb_frontend* fe, fe_sec_voltage_t voltag
 	u8 reg0x08;
 	u8 reg0x0c;
 
-	dprintk("%s: %s\n", __FUNCTION__,
+	dprintk("%s: %s\n", __func__,
 		voltage == SEC_VOLTAGE_13 ? "SEC_VOLTAGE_13" :
 		voltage == SEC_VOLTAGE_18 ? "SEC_VOLTAGE_18" : "??");
 
@@ -408,7 +408,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 
 	cmd = cmd << 1;
 	if (debug_legacy_dish_switch)
-		printk ("%s switch command: 0x%04lx\n",__FUNCTION__, cmd);
+		printk ("%s switch command: 0x%04lx\n",__func__, cmd);
 
 	do_gettimeofday (&nexttime);
 	if (debug_legacy_dish_switch)
@@ -433,7 +433,7 @@ static int stv0299_send_legacy_dish_cmd (struct dvb_frontend* fe, unsigned long
 	}
 	if (debug_legacy_dish_switch) {
 		printk ("%s(%d): switch delay (should be 32k followed by all 8k\n",
-			__FUNCTION__, fe->dvb->num);
+			__func__, fe->dvb->num);
 		for (i = 1; i < 10; i++)
 			printk ("%d: %d\n", i, timeval_usec_diff(tv[i-1] , tv[i]));
 	}
@@ -461,7 +461,7 @@ static int stv0299_read_status(struct dvb_frontend* fe, fe_status_t* status)
 	u8 signal = 0xff - stv0299_readreg (state, 0x18);
 	u8 sync = stv0299_readreg (state, 0x1b);
 
-	dprintk ("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __FUNCTION__, sync);
+	dprintk ("%s : FE_READ_STATUS : VSTATUS: 0x%02x\n", __func__, sync);
 	*status = 0;
 
 	if (signal > 10)
@@ -499,7 +499,7 @@ static int stv0299_read_signal_strength(struct dvb_frontend* fe, u16* strength)
 	s32 signal =  0xffff - ((stv0299_readreg (state, 0x18) << 8)
 			       | stv0299_readreg (state, 0x19));
 
-	dprintk ("%s : FE_READ_SIGNAL_STRENGTH : AGC2I: 0x%02x%02x, signal=0x%04x\n", __FUNCTION__,
+	dprintk ("%s : FE_READ_SIGNAL_STRENGTH : AGC2I: 0x%02x%02x, signal=0x%04x\n", __func__,
 		 stv0299_readreg (state, 0x18),
 		 stv0299_readreg (state, 0x19), (int) signal);
 
@@ -536,7 +536,7 @@ static int stv0299_set_frontend(struct dvb_frontend* fe, struct dvb_frontend_par
 	struct stv0299_state* state = fe->demodulator_priv;
 	int invval = 0;
 
-	dprintk ("%s : FE_SET_FRONTEND\n", __FUNCTION__);
+	dprintk ("%s : FE_SET_FRONTEND\n", __func__);
 
 	// set the inversion
 	if (p->inversion == INVERSION_OFF) invval = 0;
diff --git a/drivers/media/dvb/frontends/stv0299.h b/drivers/media/dvb/frontends/stv0299.h
index 33df949..84eaeb5 100644
--- a/drivers/media/dvb/frontends/stv0299.h
+++ b/drivers/media/dvb/frontends/stv0299.h
@@ -96,7 +96,7 @@ extern struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
 static inline struct dvb_frontend* stv0299_attach(const struct stv0299_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_STV0299
diff --git a/drivers/media/dvb/frontends/tda10021.c b/drivers/media/dvb/frontends/tda10021.c
index 45137d2..f648fdb 100644
--- a/drivers/media/dvb/frontends/tda10021.c
+++ b/drivers/media/dvb/frontends/tda10021.c
@@ -79,7 +79,7 @@ static int _tda10021_writereg (struct tda10021_state* state, u8 reg, u8 data)
 	if (ret != 1)
 		printk("DVB: TDA10021(%d): %s, writereg error "
 			"(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			state->frontend.dvb->num, __FUNCTION__, reg, data, ret);
+			state->frontend.dvb->num, __func__, reg, data, ret);
 
 	msleep(10);
 	return (ret != 1) ? -EREMOTEIO : 0;
@@ -97,7 +97,7 @@ static u8 tda10021_readreg (struct tda10021_state* state, u8 reg)
 	// Don't print an error message if the id is read.
 	if (ret != 2 && reg != 0x1a)
 		printk("DVB: TDA10021: %s: readreg error (ret == %i)\n",
-				__FUNCTION__, ret);
+				__func__, ret);
 	return b1[0];
 }
 
diff --git a/drivers/media/dvb/frontends/tda10023.c b/drivers/media/dvb/frontends/tda10023.c
index 364bc01..0727b80 100644
--- a/drivers/media/dvb/frontends/tda10023.c
+++ b/drivers/media/dvb/frontends/tda10023.c
@@ -118,7 +118,7 @@ static u8 tda10023_readreg (struct tda10023_state* state, u8 reg)
 	ret = i2c_transfer (state->i2c, msg, 2);
 	if (ret != 2)
 		printk("DVB: TDA10023: %s: readreg error (ret == %i)\n",
-				 __FUNCTION__, ret);
+				 __func__, ret);
 	return b1[0];
 }
 
@@ -132,7 +132,7 @@ static int tda10023_writereg (struct tda10023_state* state, u8 reg, u8 data)
 	if (ret != 1)
 		printk("DVB: TDA10023(%d): %s, writereg error "
 			"(reg == 0x%02x, val == 0x%02x, ret == %i)\n",
-			state->frontend.dvb->num, __FUNCTION__, reg, data, ret);
+			state->frontend.dvb->num, __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
diff --git a/drivers/media/dvb/frontends/tda1002x.h b/drivers/media/dvb/frontends/tda1002x.h
index e9094d8..1bcc0d4 100644
--- a/drivers/media/dvb/frontends/tda1002x.h
+++ b/drivers/media/dvb/frontends/tda1002x.h
@@ -40,7 +40,7 @@ extern struct dvb_frontend* tda10021_attach(const struct tda1002x_config* config
 static inline struct dvb_frontend* tda10021_attach(const struct tda1002x_config* config,
 					    struct i2c_adapter* i2c, u8 pwm)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA10021
@@ -52,7 +52,7 @@ extern struct dvb_frontend* tda10023_attach(const struct tda1002x_config* config
 static inline struct dvb_frontend* tda10023_attach(const struct tda1002x_config* config,
 					    struct i2c_adapter* i2c, u8 pwm)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA10023
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index 8415a8a..4997384 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -131,16 +131,16 @@ static int tda1004x_write_byteI(struct tda1004x_state *state, int reg, int data)
 	u8 buf[] = { reg, data };
 	struct i2c_msg msg = { .flags = 0, .buf = buf, .len = 2 };
 
-	dprintk("%s: reg=0x%x, data=0x%x\n", __FUNCTION__, reg, data);
+	dprintk("%s: reg=0x%x, data=0x%x\n", __func__, reg, data);
 
 	msg.addr = state->config->demod_address;
 	ret = i2c_transfer(state->i2c, &msg, 1);
 
 	if (ret != 1)
 		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
-	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __FUNCTION__,
+	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __func__,
 		reg, data, ret);
 	return (ret != 1) ? -1 : 0;
 }
@@ -153,19 +153,19 @@ static int tda1004x_read_byte(struct tda1004x_state *state, int reg)
 	struct i2c_msg msg[] = {{ .flags = 0, .buf = b0, .len = 1 },
 				{ .flags = I2C_M_RD, .buf = b1, .len = 1 }};
 
-	dprintk("%s: reg=0x%x\n", __FUNCTION__, reg);
+	dprintk("%s: reg=0x%x\n", __func__, reg);
 
 	msg[0].addr = state->config->demod_address;
 	msg[1].addr = state->config->demod_address;
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dprintk("%s: error reg=0x%x, ret=%i\n", __FUNCTION__, reg,
+		dprintk("%s: error reg=0x%x, ret=%i\n", __func__, reg,
 			ret);
 		return -1;
 	}
 
-	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __FUNCTION__,
+	dprintk("%s: success reg=0x%x, data=0x%x, ret=%i\n", __func__,
 		reg, b1[0], ret);
 	return b1[0];
 }
@@ -173,7 +173,7 @@ static int tda1004x_read_byte(struct tda1004x_state *state, int reg)
 static int tda1004x_write_mask(struct tda1004x_state *state, int reg, int mask, int data)
 {
 	int val;
-	dprintk("%s: reg=0x%x, mask=0x%x, data=0x%x\n", __FUNCTION__, reg,
+	dprintk("%s: reg=0x%x, mask=0x%x, data=0x%x\n", __func__, reg,
 		mask, data);
 
 	// read a byte and check
@@ -194,7 +194,7 @@ static int tda1004x_write_buf(struct tda1004x_state *state, int reg, unsigned ch
 	int i;
 	int result;
 
-	dprintk("%s: reg=0x%x, len=0x%x\n", __FUNCTION__, reg, len);
+	dprintk("%s: reg=0x%x, len=0x%x\n", __func__, reg, len);
 
 	result = 0;
 	for (i = 0; i < len; i++) {
@@ -209,7 +209,7 @@ static int tda1004x_write_buf(struct tda1004x_state *state, int reg, unsigned ch
 static int tda1004x_enable_tuner_i2c(struct tda1004x_state *state)
 {
 	int result;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	result = tda1004x_write_mask(state, TDA1004X_CONFC4, 2, 2);
 	msleep(20);
@@ -218,7 +218,7 @@ static int tda1004x_enable_tuner_i2c(struct tda1004x_state *state)
 
 static int tda1004x_disable_tuner_i2c(struct tda1004x_state *state)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	return tda1004x_write_mask(state, TDA1004X_CONFC4, 2, 0);
 }
@@ -345,7 +345,7 @@ static int tda1004x_do_upload(struct tda1004x_state *state,
 		}
 		pos += tx_size;
 
-		dprintk("%s: fw_pos=0x%x\n", __FUNCTION__, pos);
+		dprintk("%s: fw_pos=0x%x\n", __func__, pos);
 	}
 	// give the DSP a chance to settle 03/10/05 Hac
 	msleep(100);
@@ -444,10 +444,10 @@ static void tda10046_init_plls(struct dvb_frontend* fe)
 		tda1004x_write_byteI(state, TDA10046H_CONFPLL2, 0x03); // PLL M = 3
 	}
 	if (state->config->xtal_freq == TDA10046_XTAL_4M ) {
-		dprintk("%s: setting up PLLs for a 4 MHz Xtal\n", __FUNCTION__);
+		dprintk("%s: setting up PLLs for a 4 MHz Xtal\n", __func__);
 		tda1004x_write_byteI(state, TDA10046H_CONFPLL3, 0); // PLL P = N = 0
 	} else {
-		dprintk("%s: setting up PLLs for a 16 MHz Xtal\n", __FUNCTION__);
+		dprintk("%s: setting up PLLs for a 16 MHz Xtal\n", __func__);
 		tda1004x_write_byteI(state, TDA10046H_CONFPLL3, 3); // PLL P = 0, N = 3
 	}
 	if(tda10046_clk53m)
@@ -488,7 +488,7 @@ static int tda10046_fwupload(struct dvb_frontend* fe)
 	if (state->config->xtal_freq == TDA10046_XTAL_4M) {
 		tda1004x_write_byteI(state, TDA1004X_CONFC4, 0);
 	} else {
-		dprintk("%s: 16MHz Xtal, reducing I2C speed\n", __FUNCTION__);
+		dprintk("%s: 16MHz Xtal, reducing I2C speed\n", __func__);
 		tda1004x_write_byteI(state, TDA1004X_CONFC4, 0x80);
 	}
 	tda1004x_write_mask(state, TDA10046H_CONF_TRISTATE1, 1, 0);
@@ -594,7 +594,7 @@ static int tda10045_init(struct dvb_frontend* fe)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (tda10045_fwupload(fe)) {
 		printk("tda1004x: firmware upload failed\n");
@@ -624,7 +624,7 @@ static int tda10045_init(struct dvb_frontend* fe)
 static int tda10046_init(struct dvb_frontend* fe)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (tda10046_fwupload(fe)) {
 		printk("tda1004x: firmware upload failed\n");
@@ -686,7 +686,7 @@ static int tda1004x_set_fe(struct dvb_frontend* fe,
 	int tmp;
 	int inversion;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (state->demod_type == TDA1004X_DEMOD_TDA10046) {
 		// setup auto offset
@@ -881,7 +881,7 @@ static int tda1004x_get_fe(struct dvb_frontend* fe, struct dvb_frontend_paramete
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// inversion status
 	fe_params->inversion = INVERSION_OFF;
@@ -989,7 +989,7 @@ static int tda1004x_read_status(struct dvb_frontend* fe, fe_status_t * fe_status
 	int cber;
 	int vber;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read status
 	status = tda1004x_read_byte(state, TDA1004X_STATUS_CD);
@@ -1048,7 +1048,7 @@ static int tda1004x_read_status(struct dvb_frontend* fe, fe_status_t * fe_status
 	}
 
 	// success
-	dprintk("%s: fe_status=0x%x\n", __FUNCTION__, *fe_status);
+	dprintk("%s: fe_status=0x%x\n", __func__, *fe_status);
 	return 0;
 }
 
@@ -1058,7 +1058,7 @@ static int tda1004x_read_signal_strength(struct dvb_frontend* fe, u16 * signal)
 	int tmp;
 	int reg = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// determine the register to use
 	switch (state->demod_type) {
@@ -1077,7 +1077,7 @@ static int tda1004x_read_signal_strength(struct dvb_frontend* fe, u16 * signal)
 		return -EIO;
 
 	*signal = (tmp << 8) | tmp;
-	dprintk("%s: signal=0x%x\n", __FUNCTION__, *signal);
+	dprintk("%s: signal=0x%x\n", __func__, *signal);
 	return 0;
 }
 
@@ -1086,7 +1086,7 @@ static int tda1004x_read_snr(struct dvb_frontend* fe, u16 * snr)
 	struct tda1004x_state* state = fe->demodulator_priv;
 	int tmp;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read it
 	tmp = tda1004x_read_byte(state, TDA1004X_SNR);
@@ -1095,7 +1095,7 @@ static int tda1004x_read_snr(struct dvb_frontend* fe, u16 * snr)
 	tmp = 255 - tmp;
 
 	*snr = ((tmp << 8) | tmp);
-	dprintk("%s: snr=0x%x\n", __FUNCTION__, *snr);
+	dprintk("%s: snr=0x%x\n", __func__, *snr);
 	return 0;
 }
 
@@ -1106,7 +1106,7 @@ static int tda1004x_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	int tmp2;
 	int counter;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read the UCBLOCKS and reset
 	counter = 0;
@@ -1132,7 +1132,7 @@ static int tda1004x_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 	else
 		*ucblocks = 0xffffffff;
 
-	dprintk("%s: ucblocks=0x%x\n", __FUNCTION__, *ucblocks);
+	dprintk("%s: ucblocks=0x%x\n", __func__, *ucblocks);
 	return 0;
 }
 
@@ -1141,7 +1141,7 @@ static int tda1004x_read_ber(struct dvb_frontend* fe, u32* ber)
 	struct tda1004x_state* state = fe->demodulator_priv;
 	int tmp;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	// read it in
 	tmp = tda1004x_read_byte(state, TDA1004X_CBER_LSB);
@@ -1155,7 +1155,7 @@ static int tda1004x_read_ber(struct dvb_frontend* fe, u32* ber)
 	// The address 0x20 should be read to cope with a TDA10046 bug
 	tda1004x_read_byte(state, TDA1004X_CBER_RESET);
 
-	dprintk("%s: ber=0x%x\n", __FUNCTION__, *ber);
+	dprintk("%s: ber=0x%x\n", __func__, *ber);
 	return 0;
 }
 
diff --git a/drivers/media/dvb/frontends/tda1004x.h b/drivers/media/dvb/frontends/tda1004x.h
index abae843..3c2b069 100644
--- a/drivers/media/dvb/frontends/tda1004x.h
+++ b/drivers/media/dvb/frontends/tda1004x.h
@@ -128,13 +128,13 @@ extern struct dvb_frontend* tda10046_attach(const struct tda1004x_config* config
 static inline struct dvb_frontend* tda10045_attach(const struct tda1004x_config* config,
 					    struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 static inline struct dvb_frontend* tda10046_attach(const struct tda1004x_config* config,
 					    struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA1004X
diff --git a/drivers/media/dvb/frontends/tda10086.c b/drivers/media/dvb/frontends/tda10086.c
index 0d2b69a..ccd3da9 100644
--- a/drivers/media/dvb/frontends/tda10086.c
+++ b/drivers/media/dvb/frontends/tda10086.c
@@ -60,7 +60,7 @@ static int tda10086_write_byte(struct tda10086_state *state, int reg, int data)
 
 	if (ret != 1)
 		dprintk("%s: error reg=0x%x, data=0x%x, ret=%i\n",
-			__FUNCTION__, reg, data, ret);
+			__func__, reg, data, ret);
 
 	return (ret != 1) ? ret : 0;
 }
@@ -78,7 +78,7 @@ static int tda10086_read_byte(struct tda10086_state *state, int reg)
 	ret = i2c_transfer(state->i2c, msg, 2);
 
 	if (ret != 2) {
-		dprintk("%s: error reg=0x%x, ret=%i\n", __FUNCTION__, reg,
+		dprintk("%s: error reg=0x%x, ret=%i\n", __func__, reg,
 			ret);
 		return ret;
 	}
@@ -108,7 +108,7 @@ static int tda10086_init(struct dvb_frontend* fe)
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -173,7 +173,7 @@ static void tda10086_diseqc_wait(struct tda10086_state *state)
 	unsigned long timeout = jiffies + msecs_to_jiffies(200);
 	while (!(tda10086_read_byte(state, 0x50) & 0x01)) {
 		if(time_after(jiffies, timeout)) {
-			printk("%s: diseqc queue not ready, command may be lost.\n", __FUNCTION__);
+			printk("%s: diseqc queue not ready, command may be lost.\n", __func__);
 			break;
 		}
 		msleep(10);
@@ -185,7 +185,7 @@ static int tda10086_set_tone (struct dvb_frontend* fe, fe_sec_tone_mode_t tone)
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -211,7 +211,7 @@ static int tda10086_send_master_cmd (struct dvb_frontend* fe,
 	u8 oldval;
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -239,7 +239,7 @@ static int tda10086_send_burst (struct dvb_frontend* fe, fe_sec_mini_cmd_t minic
 	u8 oldval = tda10086_read_byte(state, 0x36);
 	u8 t22k_off = 0x80;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (state->config->diseqc_tone)
 		t22k_off = 0;
@@ -266,7 +266,7 @@ static int tda10086_set_inversion(struct tda10086_state *state,
 {
 	u8 invval = 0x80;
 
-	dprintk ("%s %i %i\n", __FUNCTION__, fe_params->inversion, state->config->invert);
+	dprintk ("%s %i %i\n", __func__, fe_params->inversion, state->config->invert);
 
 	switch(fe_params->inversion) {
 	case INVERSION_OFF:
@@ -300,7 +300,7 @@ static int tda10086_set_symbol_rate(struct tda10086_state *state,
 	u32 bdri;
 	u32 symbol_rate = fe_params->u.qpsk.symbol_rate;
 
-	dprintk ("%s %i\n", __FUNCTION__, symbol_rate);
+	dprintk ("%s %i\n", __func__, symbol_rate);
 
 	// setup the decimation and anti-aliasing filters..
 	if (symbol_rate < (u32) (SACLK * 0.0137)) {
@@ -366,7 +366,7 @@ static int tda10086_set_fec(struct tda10086_state *state,
 {
 	u8 fecval;
 
-	dprintk ("%s %i\n", __FUNCTION__, fe_params->u.qpsk.fec_inner);
+	dprintk ("%s %i\n", __func__, fe_params->u.qpsk.fec_inner);
 
 	switch(fe_params->u.qpsk.fec_inner) {
 	case FEC_1_2:
@@ -412,7 +412,7 @@ static int tda10086_set_frontend(struct dvb_frontend* fe,
 	u32 freq = 0;
 	int freqoff;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// modify parameters for tuning
 	tda10086_write_byte(state, 0x02, 0x35);
@@ -459,7 +459,7 @@ static int tda10086_get_frontend(struct dvb_frontend* fe, struct dvb_frontend_pa
 	int tmp;
 	u64 tmp64;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// check for invalid symbol rate
 	if (fe_params->u.qpsk.symbol_rate < 500000)
@@ -550,7 +550,7 @@ static int tda10086_read_status(struct dvb_frontend* fe, fe_status_t *fe_status)
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 val;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	val = tda10086_read_byte(state, 0x0e);
 	*fe_status = 0;
@@ -579,7 +579,7 @@ static int tda10086_read_signal_strength(struct dvb_frontend* fe, u16 * signal)
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 _str;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	_str = 0xff - tda10086_read_byte(state, 0x43);
 	*signal = (_str << 8) | _str;
@@ -592,7 +592,7 @@ static int tda10086_read_snr(struct dvb_frontend* fe, u16 * snr)
 	struct tda10086_state* state = fe->demodulator_priv;
 	u8 _snr;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	_snr = 0xff - tda10086_read_byte(state, 0x1c);
 	*snr = (_snr << 8) | _snr;
@@ -604,7 +604,7 @@ static int tda10086_read_ucblocks(struct dvb_frontend* fe, u32* ucblocks)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// read it
 	*ucblocks = tda10086_read_byte(state, 0x18) & 0x7f;
@@ -620,7 +620,7 @@ static int tda10086_read_ber(struct dvb_frontend* fe, u32* ber)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	// read it
 	*ber = 0;
@@ -635,7 +635,7 @@ static int tda10086_sleep(struct dvb_frontend* fe)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	tda10086_write_mask(state, 0x00, 0x08, 0x08);
 
@@ -646,7 +646,7 @@ static int tda10086_i2c_gate_ctrl(struct dvb_frontend* fe, int enable)
 {
 	struct tda10086_state* state = fe->demodulator_priv;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	if (enable) {
 		tda10086_write_mask(state, 0x00, 0x10, 0x10);
@@ -737,7 +737,7 @@ struct dvb_frontend* tda10086_attach(const struct tda10086_config* config,
 {
 	struct tda10086_state *state;
 
-	dprintk ("%s\n", __FUNCTION__);
+	dprintk ("%s\n", __func__);
 
 	/* allocate memory for the internal state */
 	state = kmalloc(sizeof(struct tda10086_state), GFP_KERNEL);
diff --git a/drivers/media/dvb/frontends/tda10086.h b/drivers/media/dvb/frontends/tda10086.h
index eeceaee..197c237 100644
--- a/drivers/media/dvb/frontends/tda10086.h
+++ b/drivers/media/dvb/frontends/tda10086.h
@@ -45,7 +45,7 @@ extern struct dvb_frontend* tda10086_attach(const struct tda10086_config* config
 static inline struct dvb_frontend* tda10086_attach(const struct tda10086_config* config,
 						   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA10086
diff --git a/drivers/media/dvb/frontends/tda18271-priv.h b/drivers/media/dvb/frontends/tda18271-priv.h
index 7b939a5..758a559 100644
--- a/drivers/media/dvb/frontends/tda18271-priv.h
+++ b/drivers/media/dvb/frontends/tda18271-priv.h
@@ -133,7 +133,7 @@ extern int tda18271_debug;
 #define DBG_CAL  16
 
 #define tda_printk(kern, fmt, arg...) \
-	printk(kern "%s: " fmt, __FUNCTION__, ##arg)
+	printk(kern "%s: " fmt, __func__, ##arg)
 
 #define dprintk(kern, lvl, fmt, arg...) do {\
 	if (tda18271_debug & lvl) \
diff --git a/drivers/media/dvb/frontends/tda18271.h b/drivers/media/dvb/frontends/tda18271.h
index 24b0e35..f489247 100644
--- a/drivers/media/dvb/frontends/tda18271.h
+++ b/drivers/media/dvb/frontends/tda18271.h
@@ -70,7 +70,7 @@ static inline struct dvb_frontend *tda18271_attach(struct dvb_frontend *fe,
 						   struct i2c_adapter *i2c,
 						   struct tda18271_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/dvb/frontends/tda8083.c b/drivers/media/dvb/frontends/tda8083.c
index 011b74f..5b843b2 100644
--- a/drivers/media/dvb/frontends/tda8083.c
+++ b/drivers/media/dvb/frontends/tda8083.c
@@ -68,7 +68,7 @@ static int tda8083_writereg (struct tda8083_state* state, u8 reg, u8 data)
 
 	if (ret != 1)
 		dprintk ("%s: writereg error (reg %02x, ret == %i)\n",
-			__FUNCTION__, reg, ret);
+			__func__, reg, ret);
 
 	return (ret != 1) ? -1 : 0;
 }
@@ -83,7 +83,7 @@ static int tda8083_readregs (struct tda8083_state* state, u8 reg1, u8 *b, u8 len
 
 	if (ret != 2)
 		dprintk ("%s: readreg error (reg %02x, ret == %i)\n",
-			__FUNCTION__, reg1, ret);
+			__func__, reg1, ret);
 
 	return ret == 2 ? 0 : -1;
 }
diff --git a/drivers/media/dvb/frontends/tda8083.h b/drivers/media/dvb/frontends/tda8083.h
index 2d33079..5a03c14 100644
--- a/drivers/media/dvb/frontends/tda8083.h
+++ b/drivers/media/dvb/frontends/tda8083.h
@@ -42,7 +42,7 @@ extern struct dvb_frontend* tda8083_attach(const struct tda8083_config* config,
 static inline struct dvb_frontend* tda8083_attach(const struct tda8083_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA8083
diff --git a/drivers/media/dvb/frontends/tda826x.c b/drivers/media/dvb/frontends/tda826x.c
index bd3ebc2..2056809 100644
--- a/drivers/media/dvb/frontends/tda826x.c
+++ b/drivers/media/dvb/frontends/tda826x.c
@@ -54,7 +54,7 @@ static int tda826x_sleep(struct dvb_frontend *fe)
 	u8 buf [] = { 0x00, 0x8d };
 	struct i2c_msg msg = { .addr = priv->i2c_address, .flags = 0, .buf = buf, .len = 2 };
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	if (!priv->has_loopthrough)
 		buf[1] = 0xad;
@@ -62,7 +62,7 @@ static int tda826x_sleep(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if ((ret = i2c_transfer (priv->i2c, &msg, 1)) != 1) {
-		dprintk("%s: i2c error\n", __FUNCTION__);
+		dprintk("%s: i2c error\n", __func__);
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -78,7 +78,7 @@ static int tda826x_set_params(struct dvb_frontend *fe, struct dvb_frontend_param
 	u8 buf [11];
 	struct i2c_msg msg = { .addr = priv->i2c_address, .flags = 0, .buf = buf, .len = 11 };
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	div = (params->frequency + (1000-1)) / 1000;
 
@@ -99,7 +99,7 @@ static int tda826x_set_params(struct dvb_frontend *fe, struct dvb_frontend_param
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if ((ret = i2c_transfer (priv->i2c, &msg, 1)) != 1) {
-		dprintk("%s: i2c error\n", __FUNCTION__);
+		dprintk("%s: i2c error\n", __func__);
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
@@ -138,7 +138,7 @@ struct dvb_frontend *tda826x_attach(struct dvb_frontend *fe, int addr, struct i2
 	};
 	int ret;
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
diff --git a/drivers/media/dvb/frontends/tda826x.h b/drivers/media/dvb/frontends/tda826x.h
index ad99811..89e9792 100644
--- a/drivers/media/dvb/frontends/tda826x.h
+++ b/drivers/media/dvb/frontends/tda826x.h
@@ -45,7 +45,7 @@ static inline struct dvb_frontend* tda826x_attach(struct dvb_frontend *fe,
 						  struct i2c_adapter *i2c,
 						  int has_loopthrough)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA826X
diff --git a/drivers/media/dvb/frontends/tda827x.c b/drivers/media/dvb/frontends/tda827x.c
index 229b119..79567a6 100644
--- a/drivers/media/dvb/frontends/tda827x.c
+++ b/drivers/media/dvb/frontends/tda827x.c
@@ -142,7 +142,7 @@ static int tda827xo_set_params(struct dvb_frontend *fe,
 	int i, tuner_freq, if_freq;
 	u32 N;
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 	switch (params->u.ofdm.bandwidth) {
 	case BANDWIDTH_6_MHZ:
 		if_freq = 4000000;
@@ -186,7 +186,7 @@ static int tda827xo_set_params(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (i2c_transfer(priv->i2c_adap, &msg, 1) != 1) {
 		printk("%s: could not write to tuner at addr: 0x%02x\n",
-		       __FUNCTION__, priv->i2c_addr << 1);
+		       __func__, priv->i2c_addr << 1);
 		return -EIO;
 	}
 	msleep(500);
@@ -212,7 +212,7 @@ static int tda827xo_sleep(struct dvb_frontend *fe)
 	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	i2c_transfer(priv->i2c_adap, &msg, 1);
@@ -401,7 +401,7 @@ static int tda827xa_set_params(struct dvb_frontend *fe,
 	int i, tuner_freq, if_freq;
 	u32 N;
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 	if (priv->cfg && priv->cfg->lna_gain)
 		priv->cfg->lna_gain(fe, 1);
 	msleep(20);
@@ -444,7 +444,7 @@ static int tda827xa_set_params(struct dvb_frontend *fe,
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (i2c_transfer(priv->i2c_adap, &msg, 1) != 1) {
 		printk("%s: could not write to tuner at addr: 0x%02x\n",
-		       __FUNCTION__, priv->i2c_addr << 1);
+		       __func__, priv->i2c_addr << 1);
 		return -EIO;
 	}
 	buf[0] = 0x90;
@@ -530,7 +530,7 @@ static int tda827xa_sleep(struct dvb_frontend *fe)
 	struct i2c_msg msg = { .addr = priv->i2c_addr, .flags = 0,
 			       .buf = buf, .len = sizeof(buf) };
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 
@@ -726,7 +726,7 @@ static int tda827x_get_bandwidth(struct dvb_frontend *fe, u32 *bandwidth)
 static int tda827x_init(struct dvb_frontend *fe)
 {
 	struct tda827x_priv *priv = fe->tuner_priv;
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 	if (priv->cfg && priv->cfg->init)
 		priv->cfg->init(fe);
 
@@ -794,7 +794,7 @@ static int tda827x_probe_version(struct dvb_frontend *fe)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if (i2c_transfer(priv->i2c_adap, &msg, 1) != 1) {
 		printk("%s: could not read from tuner at addr: 0x%02x\n",
-		       __FUNCTION__, msg.addr << 1);
+		       __func__, msg.addr << 1);
 		return -EIO;
 	}
 	if ((data & 0x3c) == 0) {
@@ -818,7 +818,7 @@ struct dvb_frontend *tda827x_attach(struct dvb_frontend *fe, int addr,
 {
 	struct tda827x_priv *priv = NULL;
 
-	dprintk("%s:\n", __FUNCTION__);
+	dprintk("%s:\n", __func__);
 	priv = kzalloc(sizeof(struct tda827x_priv), GFP_KERNEL);
 	if (priv == NULL)
 		return NULL;
diff --git a/drivers/media/dvb/frontends/tda827x.h b/drivers/media/dvb/frontends/tda827x.h
index 92eb65b..9176cf6 100644
--- a/drivers/media/dvb/frontends/tda827x.h
+++ b/drivers/media/dvb/frontends/tda827x.h
@@ -61,7 +61,7 @@ static inline struct dvb_frontend* tda827x_attach(struct dvb_frontend *fe,
 						  struct i2c_adapter *i2c,
 						  struct tda827x_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TDA827X
diff --git a/drivers/media/dvb/frontends/tua6100.c b/drivers/media/dvb/frontends/tua6100.c
index 6ba0029..1790bae 100644
--- a/drivers/media/dvb/frontends/tua6100.c
+++ b/drivers/media/dvb/frontends/tua6100.c
@@ -58,7 +58,7 @@ static int tua6100_sleep(struct dvb_frontend *fe)
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 1);
 	if ((ret = i2c_transfer (priv->i2c, &msg, 1)) != 1) {
-		printk("%s: i2c error\n", __FUNCTION__);
+		printk("%s: i2c error\n", __func__);
 	}
 	if (fe->ops.i2c_gate_ctrl)
 		fe->ops.i2c_gate_ctrl(fe, 0);
diff --git a/drivers/media/dvb/frontends/tua6100.h b/drivers/media/dvb/frontends/tua6100.h
index 03a665e..f83dbd5 100644
--- a/drivers/media/dvb/frontends/tua6100.h
+++ b/drivers/media/dvb/frontends/tua6100.h
@@ -39,7 +39,7 @@ extern struct dvb_frontend *tua6100_attach(struct dvb_frontend *fe, int addr, st
 #else
 static inline struct dvb_frontend* tua6100_attach(struct dvb_frontend *fe, int addr, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUA6100
diff --git a/drivers/media/dvb/frontends/ves1820.c b/drivers/media/dvb/frontends/ves1820.c
index 8791701..a184597 100644
--- a/drivers/media/dvb/frontends/ves1820.c
+++ b/drivers/media/dvb/frontends/ves1820.c
@@ -66,7 +66,7 @@ static int ves1820_writereg(struct ves1820_state *state, u8 reg, u8 data)
 
 	if (ret != 1)
 		printk("ves1820: %s(): writereg error (reg == 0x%02x, "
-			"val == 0x%02x, ret == %i)\n", __FUNCTION__, reg, data, ret);
+			"val == 0x%02x, ret == %i)\n", __func__, reg, data, ret);
 
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
@@ -85,7 +85,7 @@ static u8 ves1820_readreg(struct ves1820_state *state, u8 reg)
 
 	if (ret != 2)
 		printk("ves1820: %s(): readreg error (reg == 0x%02x, "
-		"ret == %i)\n", __FUNCTION__, reg, ret);
+		"ret == %i)\n", __func__, reg, ret);
 
 	return b1[0];
 }
diff --git a/drivers/media/dvb/frontends/ves1820.h b/drivers/media/dvb/frontends/ves1820.h
index e4a2a32..e902ed6 100644
--- a/drivers/media/dvb/frontends/ves1820.h
+++ b/drivers/media/dvb/frontends/ves1820.h
@@ -48,7 +48,7 @@ extern struct dvb_frontend* ves1820_attach(const struct ves1820_config* config,
 static inline struct dvb_frontend* ves1820_attach(const struct ves1820_config* config,
 					   struct i2c_adapter* i2c, u8 pwm)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_VES1820
diff --git a/drivers/media/dvb/frontends/ves1x93.c b/drivers/media/dvb/frontends/ves1x93.c
index 23fd030..2de928f 100644
--- a/drivers/media/dvb/frontends/ves1x93.c
+++ b/drivers/media/dvb/frontends/ves1x93.c
@@ -98,7 +98,7 @@ static int ves1x93_writereg (struct ves1x93_state* state, u8 reg, u8 data)
 	int err;
 
 	if ((err = i2c_transfer (state->i2c, &msg, 1)) != 1) {
-		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __FUNCTION__, err, reg, data);
+		dprintk ("%s: writereg error (err == %i, reg == 0x%02x, data == 0x%02x)\n", __func__, err, reg, data);
 		return -EREMOTEIO;
 	}
 
@@ -179,7 +179,7 @@ static int ves1x93_set_symbolrate (struct ves1x93_state* state, u32 srate)
 	u32 tmp;
 	u32 FIN;
 
-	dprintk("%s: srate == %d\n", __FUNCTION__, (unsigned int) srate);
+	dprintk("%s: srate == %d\n", __func__, (unsigned int) srate);
 
 	if (srate > state->config->xin/2)
 		srate = state->config->xin/2;
@@ -266,7 +266,7 @@ static int ves1x93_init (struct dvb_frontend* fe)
 	int i;
 	int val;
 
-	dprintk("%s: init chip\n", __FUNCTION__);
+	dprintk("%s: init chip\n", __func__);
 
 	for (i = 0; i < state->tab_size; i++) {
 		if (state->init_1x93_wtab[i]) {
diff --git a/drivers/media/dvb/frontends/ves1x93.h b/drivers/media/dvb/frontends/ves1x93.h
index d507f89..8a5a49e 100644
--- a/drivers/media/dvb/frontends/ves1x93.h
+++ b/drivers/media/dvb/frontends/ves1x93.h
@@ -47,7 +47,7 @@ extern struct dvb_frontend* ves1x93_attach(const struct ves1x93_config* config,
 static inline struct dvb_frontend* ves1x93_attach(const struct ves1x93_config* config,
 					   struct i2c_adapter* i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_VES1X93
diff --git a/drivers/media/dvb/frontends/xc5000.c b/drivers/media/dvb/frontends/xc5000.c
index f642ca2..6e27bb7 100644
--- a/drivers/media/dvb/frontends/xc5000.c
+++ b/drivers/media/dvb/frontends/xc5000.c
@@ -209,7 +209,7 @@ static void xc5000_TunerReset(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (priv->cfg->tuner_callback) {
 		ret = priv->cfg->tuner_callback(priv->cfg->priv,
@@ -330,7 +330,7 @@ static int xc_load_i2c_sequence(struct dvb_frontend *fe, u8 i2c_sequence[])
 
 static int xc_initialize(struct xc5000_priv *priv)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	return xc_write_reg(priv, XREG_INIT, 0);
 }
 
@@ -338,9 +338,9 @@ static int xc_SetTVStandard(struct xc5000_priv *priv,
 	u16 VideoMode, u16 AudioMode)
 {
 	int ret;
-	dprintk(1, "%s(0x%04x,0x%04x)\n", __FUNCTION__, VideoMode, AudioMode);
+	dprintk(1, "%s(0x%04x,0x%04x)\n", __func__, VideoMode, AudioMode);
 	dprintk(1, "%s() Standard = %s\n",
-		__FUNCTION__,
+		__func__,
 		XC5000_Standard[priv->video_standard].Name);
 
 	ret = xc_write_reg(priv, XREG_VIDEO_MODE, VideoMode);
@@ -361,7 +361,7 @@ static int xc_shutdown(struct xc5000_priv *priv)
 
 static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
 {
-	dprintk(1, "%s(%d) Source = %s\n", __FUNCTION__, rf_mode,
+	dprintk(1, "%s(%d) Source = %s\n", __func__, rf_mode,
 		rf_mode == XC_RF_MODE_AIR ? "ANTENNA" : "CABLE");
 
 	if ((rf_mode != XC_RF_MODE_AIR) && (rf_mode != XC_RF_MODE_CABLE))
@@ -369,7 +369,7 @@ static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
 		rf_mode = XC_RF_MODE_CABLE;
 		printk(KERN_ERR
 			"%s(), Invalid mode, defaulting to CABLE",
-			__FUNCTION__);
+			__func__);
 	}
 	return xc_write_reg(priv, XREG_SIGNALSOURCE, rf_mode);
 }
@@ -380,7 +380,7 @@ static int xc_set_RF_frequency(struct xc5000_priv *priv, u32 freq_hz)
 {
 	u16 freq_code;
 
-	dprintk(1, "%s(%u)\n", __FUNCTION__, freq_hz);
+	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	if ((freq_hz > xc5000_tuner_ops.info.frequency_max) ||
 		(freq_hz < xc5000_tuner_ops.info.frequency_min))
@@ -396,7 +396,7 @@ static int xc_set_IF_frequency(struct xc5000_priv *priv, u32 freq_khz)
 {
 	u32 freq_code = (freq_khz * 1024)/1000;
 	dprintk(1, "%s(freq_khz = %d) freq_code = 0x%x\n",
-		__FUNCTION__, freq_khz, freq_code);
+		__func__, freq_khz, freq_code);
 
 	return xc_write_reg(priv, XREG_IF_OUT, freq_code);
 }
@@ -488,7 +488,7 @@ static int xc_tune_channel(struct xc5000_priv *priv, u32 freq_hz)
 {
 	int found = 0;
 
-	dprintk(1, "%s(%u)\n", __FUNCTION__, freq_hz);
+	dprintk(1, "%s(%u)\n", __func__, freq_hz);
 
 	if (xc_set_RF_frequency(priv, freq_hz) != XC_RESULT_SUCCESS)
 		return 0;
@@ -627,12 +627,12 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dprintk(1, "%s() frequency=%d (Hz)\n", __FUNCTION__, params->frequency);
+	dprintk(1, "%s() frequency=%d (Hz)\n", __func__, params->frequency);
 
 	switch(params->u.vsb.modulation) {
 	case VSB_8:
 	case VSB_16:
-		dprintk(1, "%s() VSB modulation\n", __FUNCTION__);
+		dprintk(1, "%s() VSB modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_AIR;
 		priv->freq_hz = params->frequency - 1750000;
 		priv->bandwidth = BANDWIDTH_6_MHZ;
@@ -641,7 +641,7 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 	case QAM_64:
 	case QAM_256:
 	case QAM_AUTO:
-		dprintk(1, "%s() QAM modulation\n", __FUNCTION__);
+		dprintk(1, "%s() QAM modulation\n", __func__);
 		priv->rf_mode = XC_RF_MODE_CABLE;
 		priv->freq_hz = params->frequency - 1750000;
 		priv->bandwidth = BANDWIDTH_6_MHZ;
@@ -652,7 +652,7 @@ static int xc5000_set_params(struct dvb_frontend *fe,
 	}
 
 	dprintk(1, "%s() frequency=%d (compensated)\n",
-		__FUNCTION__, priv->freq_hz);
+		__func__, priv->freq_hz);
 
 	ret = xc_SetSignalSource(priv, priv->rf_mode);
 	if (ret != XC_RESULT_SUCCESS) {
@@ -697,7 +697,7 @@ static int xc5000_set_analog_params(struct dvb_frontend *fe,
 		xc_load_fw_and_init_tuner(fe);
 
 	dprintk(1, "%s() frequency=%d (in units of 62.5khz)\n",
-		__FUNCTION__, params->frequency);
+		__func__, params->frequency);
 
 	priv->rf_mode = XC_RF_MODE_CABLE; /* Fix me: it could be air. */
 
@@ -775,7 +775,7 @@ tune_channel:
 static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	*freq = priv->freq_hz;
 	return 0;
 }
@@ -783,7 +783,7 @@ static int xc5000_get_frequency(struct dvb_frontend *fe, u32 *freq)
 static int xc5000_get_bandwidth(struct dvb_frontend *fe, u32 *bw)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	*bw = priv->bandwidth;
 	return 0;
@@ -796,7 +796,7 @@ static int xc5000_get_status(struct dvb_frontend *fe, u32 *status)
 
 	xc_get_lock_status(priv, &lock_status);
 
-	dprintk(1, "%s() lock_status = 0x%08x\n", __FUNCTION__, lock_status);
+	dprintk(1, "%s() lock_status = 0x%08x\n", __func__, lock_status);
 
 	*status = lock_status;
 
@@ -836,7 +836,7 @@ static int xc5000_sleep(struct dvb_frontend *fe)
 	struct xc5000_priv *priv = fe->tuner_priv;
 	int ret;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* On Pinnacle PCTV HD 800i, the tuner cannot be reinitialized
 	 * once shutdown without reloading the driver. Maybe I am not
@@ -848,7 +848,7 @@ static int xc5000_sleep(struct dvb_frontend *fe)
 	if(ret != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR
 			"xc5000: %s() unable to shutdown tuner\n",
-			__FUNCTION__);
+			__func__);
 		return -EREMOTEIO;
 	}
 	else {
@@ -860,7 +860,7 @@ static int xc5000_sleep(struct dvb_frontend *fe)
 static int xc5000_init(struct dvb_frontend *fe)
 {
 	struct xc5000_priv *priv = fe->tuner_priv;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (xc_load_fw_and_init_tuner(fe) != XC_RESULT_SUCCESS) {
 		printk(KERN_ERR "xc5000: Unable to initialise tuner\n");
@@ -875,7 +875,7 @@ static int xc5000_init(struct dvb_frontend *fe)
 
 static int xc5000_release(struct dvb_frontend *fe)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	kfree(fe->tuner_priv);
 	fe->tuner_priv = NULL;
 	return 0;
@@ -907,7 +907,7 @@ struct dvb_frontend * xc5000_attach(struct dvb_frontend *fe,
 	struct xc5000_priv *priv = NULL;
 	u16 id = 0;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	priv = kzalloc(sizeof(struct xc5000_priv), GFP_KERNEL);
 	if (priv == NULL)
diff --git a/drivers/media/dvb/frontends/xc5000.h b/drivers/media/dvb/frontends/xc5000.h
index 32a5f1c..b890883 100644
--- a/drivers/media/dvb/frontends/xc5000.h
+++ b/drivers/media/dvb/frontends/xc5000.h
@@ -55,7 +55,7 @@ static inline struct dvb_frontend* xc5000_attach(struct dvb_frontend *fe,
 						 struct i2c_adapter *i2c,
 						 struct xc5000_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif // CONFIG_DVB_TUNER_XC5000
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 276e3b6..de4583c 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -88,7 +88,7 @@ static int zl10353_read_register(struct zl10353_state *state, u8 reg)
 
 	if (ret != 2) {
 		printk("%s: readreg error (reg=%d, ret==%i)\n",
-		       __FUNCTION__, reg, ret);
+		       __func__, reg, ret);
 		return ret;
 	}
 
@@ -152,7 +152,7 @@ static void zl10353_calc_nominal_rate(struct dvb_frontend *fe,
 	*nominal_rate = value;
 
 	dprintk("%s: bw %d, adc_clock %d => 0x%x\n",
-		__FUNCTION__, bw, adc_clock, *nominal_rate);
+		__func__, bw, adc_clock, *nominal_rate);
 }
 
 static void zl10353_calc_input_freq(struct dvb_frontend *fe,
@@ -181,7 +181,7 @@ static void zl10353_calc_input_freq(struct dvb_frontend *fe,
 	*input_freq = -value;
 
 	dprintk("%s: if2 %d, ife %d, adc_clock %d => %d / 0x%x\n",
-		__FUNCTION__, if2, ife, adc_clock, -(int)value, *input_freq);
+		__func__, if2, ife, adc_clock, -(int)value, *input_freq);
 }
 
 static int zl10353_sleep(struct dvb_frontend *fe)
diff --git a/drivers/media/dvb/frontends/zl10353.h b/drivers/media/dvb/frontends/zl10353.h
index fc734c2..fdbb88f 100644
--- a/drivers/media/dvb/frontends/zl10353.h
+++ b/drivers/media/dvb/frontends/zl10353.h
@@ -47,7 +47,7 @@ extern struct dvb_frontend* zl10353_attach(const struct zl10353_config *config,
 static inline struct dvb_frontend* zl10353_attach(const struct zl10353_config *config,
 					   struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif /* CONFIG_DVB_ZL10353 */
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 0e5701b..78919b9 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -359,7 +359,7 @@ static inline void start_debi_dma(struct av7110 *av7110, int dir,
 {
 	dprintk(8, "%c %08lx %u\n", dir == DEBI_READ ? 'R' : 'W', addr, len);
 	if (saa7146_wait_for_debi_done(av7110->dev, 0)) {
-		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __FUNCTION__);
+		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __func__);
 		return;
 	}
 
@@ -497,7 +497,7 @@ static void gpioirq(unsigned long data)
 		       saa7146_read(av7110->dev, SSR));
 
 	if (saa7146_wait_for_debi_done(av7110->dev, 0)) {
-		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __FUNCTION__);
+		printk(KERN_ERR "%s: saa7146_wait_for_debi_done timed out\n", __func__);
 		BUG(); /* maybe we should try resetting the debi? */
 	}
 
@@ -827,7 +827,7 @@ static int StartHWFilter(struct dvb_demux_filter *dvbdmxfilter)
 	if (ret != 0 || handle >= 32) {
 		printk("dvb-ttpci: %s error  buf %04x %04x %04x %04x  "
 				"ret %d  handle %04x\n",
-				__FUNCTION__, buf[0], buf[1], buf[2], buf[3],
+				__func__, buf[0], buf[1], buf[2], buf[3],
 				ret, handle);
 		dvbdmxfilter->hw_handle = 0xffff;
 		if (!ret)
@@ -854,7 +854,7 @@ static int StopHWFilter(struct dvb_demux_filter *dvbdmxfilter)
 	handle = dvbdmxfilter->hw_handle;
 	if (handle >= 32) {
 		printk("%s tried to stop invalid filter %04x, filter type = %x\n",
-				__FUNCTION__, handle, dvbdmxfilter->type);
+				__func__, handle, dvbdmxfilter->type);
 		return -EINVAL;
 	}
 
@@ -867,7 +867,7 @@ static int StopHWFilter(struct dvb_demux_filter *dvbdmxfilter)
 	if (ret != 0 || answ[1] != handle) {
 		printk("dvb-ttpci: %s error  cmd %04x %04x %04x  ret %x  "
 				"resp %04x %04x  pid %d\n",
-				__FUNCTION__, buf[0], buf[1], buf[2], ret,
+				__func__, buf[0], buf[1], buf[2], ret,
 				answ[0], answ[1], dvbdmxfilter->feed->pid);
 		if (!ret)
 			ret = -1;
@@ -1122,7 +1122,7 @@ static int dvb_get_stc(struct dmx_demux *demux, unsigned int num,
 
 	ret = av7110_fw_request(av7110, &tag, 0, fwstc, 4);
 	if (ret) {
-		printk(KERN_ERR "%s: av7110_fw_request error\n", __FUNCTION__);
+		printk(KERN_ERR "%s: av7110_fw_request error\n", __func__);
 		return ret;
 	}
 	dprintk(2, "fwstc = %04hx %04hx %04hx %04hx\n",
diff --git a/drivers/media/dvb/ttpci/av7110.h b/drivers/media/dvb/ttpci/av7110.h
index 39fbf7d..e494e04 100644
--- a/drivers/media/dvb/ttpci/av7110.h
+++ b/drivers/media/dvb/ttpci/av7110.h
@@ -40,7 +40,7 @@
 extern int av7110_debug;
 
 #define dprintk(level,args...) \
-	    do { if ((av7110_debug & level)) { printk("dvb-ttpci: %s(): ", __FUNCTION__); printk(args); } } while (0)
+	    do { if ((av7110_debug & level)) { printk("dvb-ttpci: %s(): ", __func__); printk(args); } } while (0)
 
 #define MAXFILT 32
 
diff --git a/drivers/media/dvb/ttpci/av7110_hw.c b/drivers/media/dvb/ttpci/av7110_hw.c
index a468aa2..9d81074 100644
--- a/drivers/media/dvb/ttpci/av7110_hw.c
+++ b/drivers/media/dvb/ttpci/av7110_hw.c
@@ -53,11 +53,11 @@ int av7110_debiwrite(struct av7110 *av7110, u32 config,
 	struct saa7146_dev *dev = av7110->dev;
 
 	if (count <= 0 || count > 32764) {
-		printk("%s: invalid count %d\n", __FUNCTION__, count);
+		printk("%s: invalid count %d\n", __func__, count);
 		return -1;
 	}
 	if (saa7146_wait_for_debi_done(av7110->dev, 0) < 0) {
-		printk("%s: wait_for_debi_done failed\n", __FUNCTION__);
+		printk("%s: wait_for_debi_done failed\n", __func__);
 		return -1;
 	}
 	saa7146_write(dev, DEBI_CONFIG, config);
@@ -76,11 +76,11 @@ u32 av7110_debiread(struct av7110 *av7110, u32 config, int addr, int count)
 	u32 result = 0;
 
 	if (count > 32764 || count <= 0) {
-		printk("%s: invalid count %d\n", __FUNCTION__, count);
+		printk("%s: invalid count %d\n", __func__, count);
 		return 0;
 	}
 	if (saa7146_wait_for_debi_done(av7110->dev, 0) < 0) {
-		printk("%s: wait_for_debi_done #1 failed\n", __FUNCTION__);
+		printk("%s: wait_for_debi_done #1 failed\n", __func__);
 		return 0;
 	}
 	saa7146_write(dev, DEBI_AD, av7110->debi_bus);
@@ -91,7 +91,7 @@ u32 av7110_debiread(struct av7110 *av7110, u32 config, int addr, int count)
 	if (count > 4)
 		return count;
 	if (saa7146_wait_for_debi_done(av7110->dev, 0) < 0) {
-		printk("%s: wait_for_debi_done #2 failed\n", __FUNCTION__);
+		printk("%s: wait_for_debi_done #2 failed\n", __func__);
 		return 0;
 	}
 
@@ -332,7 +332,7 @@ int av7110_wait_msgstate(struct av7110 *av7110, u16 flags)
 			break;
 		if (err) {
 			printk(KERN_ERR "%s: timeout waiting for MSGSTATE %04x\n",
-				__FUNCTION__, stat & flags);
+				__func__, stat & flags);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -362,7 +362,7 @@ static int __av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 		if (rdebi(av7110, DEBINOSWAP, COMMAND, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for COMMAND idle\n", __FUNCTION__);
+			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for COMMAND idle\n", __func__);
 			av7110->arm_errors++;
 			return -ETIMEDOUT;
 		}
@@ -379,7 +379,7 @@ static int __av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 		if (rdebi(av7110, DEBINOSWAP, HANDSHAKE_REG, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for HANDSHAKE_REG\n", __FUNCTION__);
+			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for HANDSHAKE_REG\n", __func__);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -419,14 +419,14 @@ static int __av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 			stat = rdebi(av7110, DEBINOSWAP, MSGSTATE, 0, 2);
 			if (stat & flags[0]) {
 				printk(KERN_ERR "%s: %s QUEUE overflow\n",
-					__FUNCTION__, type);
+					__func__, type);
 				return -1;
 			}
 			if ((stat & flags[1]) == 0)
 				break;
 			if (err) {
 				printk(KERN_ERR "%s: timeout waiting on busy %s QUEUE\n",
-					__FUNCTION__, type);
+					__func__, type);
 				return -ETIMEDOUT;
 			}
 			msleep(1);
@@ -454,7 +454,7 @@ static int __av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 			break;
 		if (err) {
 			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for COMMAND %d to complete\n",
-			       __FUNCTION__, (buf[0] >> 8) & 0xff);
+			       __func__, (buf[0] >> 8) & 0xff);
 			return -ETIMEDOUT;
 		}
 		msleep(1);
@@ -462,11 +462,11 @@ static int __av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 
 	stat = rdebi(av7110, DEBINOSWAP, MSGSTATE, 0, 2);
 	if (stat & GPMQOver) {
-		printk(KERN_ERR "dvb-ttpci: %s(): GPMQOver\n", __FUNCTION__);
+		printk(KERN_ERR "dvb-ttpci: %s(): GPMQOver\n", __func__);
 		return -ENOSPC;
 	}
 	else if (stat & OSDQOver) {
-		printk(KERN_ERR "dvb-ttpci: %s(): OSDQOver\n", __FUNCTION__);
+		printk(KERN_ERR "dvb-ttpci: %s(): OSDQOver\n", __func__);
 		return -ENOSPC;
 	}
 #endif
@@ -491,7 +491,7 @@ static int av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 	mutex_unlock(&av7110->dcomlock);
 	if (ret && ret!=-ERESTARTSYS)
 		printk(KERN_ERR "dvb-ttpci: %s(): av7110_send_fw_cmd error %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	return ret;
 }
 
@@ -575,7 +575,7 @@ int av7110_fw_request(struct av7110 *av7110, u16 *request_buf,
 		if (rdebi(av7110, DEBINOSWAP, COMMAND, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "%s: timeout waiting for COMMAND to complete\n", __FUNCTION__);
+			printk(KERN_ERR "%s: timeout waiting for COMMAND to complete\n", __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -591,7 +591,7 @@ int av7110_fw_request(struct av7110 *av7110, u16 *request_buf,
 		if (rdebi(av7110, DEBINOSWAP, HANDSHAKE_REG, 0, 2) == 0)
 			break;
 		if (err) {
-			printk(KERN_ERR "%s: timeout waiting for HANDSHAKE_REG\n", __FUNCTION__);
+			printk(KERN_ERR "%s: timeout waiting for HANDSHAKE_REG\n", __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -602,12 +602,12 @@ int av7110_fw_request(struct av7110 *av7110, u16 *request_buf,
 #ifdef COM_DEBUG
 	stat = rdebi(av7110, DEBINOSWAP, MSGSTATE, 0, 2);
 	if (stat & GPMQOver) {
-		printk(KERN_ERR "%s: GPMQOver\n", __FUNCTION__);
+		printk(KERN_ERR "%s: GPMQOver\n", __func__);
 		mutex_unlock(&av7110->dcomlock);
 		return -1;
 	}
 	else if (stat & OSDQOver) {
-		printk(KERN_ERR "%s: OSDQOver\n", __FUNCTION__);
+		printk(KERN_ERR "%s: OSDQOver\n", __func__);
 		mutex_unlock(&av7110->dcomlock);
 		return -1;
 	}
@@ -741,7 +741,7 @@ static int FlushText(struct av7110 *av7110)
 			break;
 		if (err) {
 			printk(KERN_ERR "dvb-ttpci: %s(): timeout waiting for BUFF1_BASE == 0\n",
-			       __FUNCTION__);
+			       __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -768,7 +768,7 @@ static int WriteText(struct av7110 *av7110, u8 win, u16 x, u16 y, char *buf)
 			break;
 		if (ret) {
 			printk(KERN_ERR "dvb-ttpci: %s: timeout waiting for BUFF1_BASE == 0\n",
-			       __FUNCTION__);
+			       __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
@@ -782,7 +782,7 @@ static int WriteText(struct av7110 *av7110, u8 win, u16 x, u16 y, char *buf)
 			break;
 		if (ret) {
 			printk(KERN_ERR "dvb-ttpci: %s: timeout waiting for HANDSHAKE_REG\n",
-			       __FUNCTION__);
+			       __func__);
 			mutex_unlock(&av7110->dcomlock);
 			return -ETIMEDOUT;
 		}
diff --git a/drivers/media/dvb/ttpci/av7110_ir.c b/drivers/media/dvb/ttpci/av7110_ir.c
index a283e1d..23a1c63 100644
--- a/drivers/media/dvb/ttpci/av7110_ir.c
+++ b/drivers/media/dvb/ttpci/av7110_ir.c
@@ -133,7 +133,7 @@ static void av7110_emit_key(unsigned long parm)
 		break;
 
 	default:
-		printk("%s invalid protocol %x\n", __FUNCTION__, ir->protocol);
+		printk("%s invalid protocol %x\n", __func__, ir->protocol);
 		return;
 	}
 
@@ -143,7 +143,7 @@ static void av7110_emit_key(unsigned long parm)
 	keycode = ir->key_map[data];
 
 	dprintk(16, "%s: code %08x -> addr %i data 0x%02x -> keycode %i\n",
-		__FUNCTION__, ircom, addr, data, keycode);
+		__func__, ircom, addr, data, keycode);
 
 	/* check device address */
 	if (!(ir->device_mask & (1 << addr)))
@@ -151,7 +151,7 @@ static void av7110_emit_key(unsigned long parm)
 
 	if (!keycode) {
 		printk ("%s: code %08x -> addr %i data 0x%02x -> unknown key!\n",
-			__FUNCTION__, ircom, addr, data);
+			__func__, ircom, addr, data);
 		return;
 	}
 
diff --git a/drivers/media/dvb/ttpci/av7110_v4l.c b/drivers/media/dvb/ttpci/av7110_v4l.c
index e2f066f..b4a0cc5 100644
--- a/drivers/media/dvb/ttpci/av7110_v4l.c
+++ b/drivers/media/dvb/ttpci/av7110_v4l.c
@@ -573,7 +573,7 @@ static int av7110_vbi_reset(struct inode *inode, struct file *file)
 	struct saa7146_dev *dev = fh->dev;
 	struct av7110 *av7110 = (struct av7110*) dev->ext_priv;
 
-	dprintk(2, "%s\n", __FUNCTION__);
+	dprintk(2, "%s\n", __func__);
 	av7110->wssMode = 0;
 	av7110->wssData = 0;
 	if (FW_VERSION(av7110->arm_app) < 0x2623)
@@ -590,7 +590,7 @@ static ssize_t av7110_vbi_write(struct file *file, const char __user *data, size
 	struct v4l2_sliced_vbi_data d;
 	int rc;
 
-	dprintk(2, "%s\n", __FUNCTION__);
+	dprintk(2, "%s\n", __func__);
 	if (FW_VERSION(av7110->arm_app) < 0x2623 || !av7110->wssMode || count != sizeof d)
 		return -EINVAL;
 	if (copy_from_user(&d, data, count))
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 5093492..fbebcc9 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -1121,7 +1121,7 @@ static void frontend_init(struct budget_ci *budget_ci)
 
 			budget_ci->budget.dvb_frontend->ops.dishnetwork_send_legacy_command = NULL;
 			if (dvb_attach(lnbp21_attach, budget_ci->budget.dvb_frontend, &budget_ci->budget.i2c_adap, LNBP21_LLC, 0) == NULL) {
-				printk("%s: No LNBP21 found!\n", __FUNCTION__);
+				printk("%s: No LNBP21 found!\n", __func__);
 				dvb_frontend_detach(budget_ci->budget.dvb_frontend);
 				budget_ci->budget.dvb_frontend = NULL;
 			}
diff --git a/drivers/media/dvb/ttpci/budget-core.c b/drivers/media/dvb/ttpci/budget-core.c
index 0252081..06bbce4 100644
--- a/drivers/media/dvb/ttpci/budget-core.c
+++ b/drivers/media/dvb/ttpci/budget-core.c
@@ -223,7 +223,7 @@ static void vpeirq(unsigned long data)
 
 	if (budget->buffer_warnings && time_after(jiffies, budget->buffer_warning_time)) {
 		printk("%s %s: used %d times >80%% of buffer (%u bytes now)\n",
-			budget->dev->name, __FUNCTION__, budget->buffer_warnings, count);
+			budget->dev->name, __func__, budget->buffer_warnings, count);
 		budget->buffer_warning_time = jiffies + BUFFER_WARNING_WAIT;
 		budget->buffer_warnings = 0;
 	}
diff --git a/drivers/media/dvb/ttpci/budget.c b/drivers/media/dvb/ttpci/budget.c
index 14b00f5..6cbb52d 100644
--- a/drivers/media/dvb/ttpci/budget.c
+++ b/drivers/media/dvb/ttpci/budget.c
@@ -438,7 +438,7 @@ static void frontend_init(struct budget *budget)
 		if (budget->dvb_frontend) {
 			budget->dvb_frontend->ops.tuner_ops.set_params = s5h1420_tuner_set_params;
 			if (dvb_attach(lnbp21_attach, budget->dvb_frontend, &budget->i2c_adap, 0, 0) == NULL) {
-				printk("%s: No LNBP21 found!\n", __FUNCTION__);
+				printk("%s: No LNBP21 found!\n", __func__);
 				goto error_out;
 			}
 			break;
@@ -454,9 +454,9 @@ static void frontend_init(struct budget *budget)
 		budget->dvb_frontend = dvb_attach(tda10086_attach, &tda10086_config, &budget->i2c_adap);
 		if (budget->dvb_frontend) {
 			if (dvb_attach(tda826x_attach, budget->dvb_frontend, 0x60, &budget->i2c_adap, 0) == NULL)
-				printk("%s: No tda826x found!\n", __FUNCTION__);
+				printk("%s: No tda826x found!\n", __func__);
 			if (dvb_attach(lnbp21_attach, budget->dvb_frontend, &budget->i2c_adap, 0, 0) == NULL) {
-				printk("%s: No LNBP21 found!\n", __FUNCTION__);
+				printk("%s: No LNBP21 found!\n", __func__);
 				goto error_out;
 			}
 			break;
diff --git a/drivers/media/dvb/ttpci/budget.h b/drivers/media/dvb/ttpci/budget.h
index d764ffa..bc8956f 100644
--- a/drivers/media/dvb/ttpci/budget.h
+++ b/drivers/media/dvb/ttpci/budget.h
@@ -21,7 +21,7 @@ extern int budget_debug;
 #endif
 
 #define dprintk(level,args...) \
-	    do { if ((budget_debug & level)) { printk("%s: %s(): ", KBUILD_MODNAME, __FUNCTION__); printk(args); } } while (0)
+	    do { if ((budget_debug & level)) { printk("%s: %s(): ", KBUILD_MODNAME, __func__); printk(args); } } while (0)
 
 struct budget_info {
 	char *name;
diff --git a/drivers/media/dvb/ttpci/ttpci-eeprom.c b/drivers/media/dvb/ttpci/ttpci-eeprom.c
index 1f31e91..7dd54b3 100644
--- a/drivers/media/dvb/ttpci/ttpci-eeprom.c
+++ b/drivers/media/dvb/ttpci/ttpci-eeprom.c
@@ -95,7 +95,7 @@ static int ttpci_eeprom_read_encodedMAC(struct i2c_adapter *adapter, u8 * encode
 		{ .addr = 0x50, .flags = I2C_M_RD, .buf = encodedMAC, .len = 20 }
 	};
 
-	/* dprintk("%s\n", __FUNCTION__); */
+	/* dprintk("%s\n", __func__); */
 
 	ret = i2c_transfer(adapter, msg, 2);
 
diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
index 7902ae1..b762be1 100644
--- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
+++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
@@ -153,12 +153,12 @@ static int ttusb_cmd(struct ttusb *ttusb,
 			   (u8 *) data, len, &actual_len, 1000);
 	if (err != 0) {
 		dprintk("%s: usb_bulk_msg(send) failed, err == %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 		mutex_unlock(&ttusb->semusb);
 		return err;
 	}
 	if (actual_len != len) {
-		dprintk("%s: only wrote %d of %d bytes\n", __FUNCTION__,
+		dprintk("%s: only wrote %d of %d bytes\n", __func__,
 			actual_len, len);
 		mutex_unlock(&ttusb->semusb);
 		return -1;
@@ -168,7 +168,7 @@ static int ttusb_cmd(struct ttusb *ttusb,
 			   ttusb->last_result, 32, &actual_len, 1000);
 
 	if (err != 0) {
-		printk("%s: failed, receive error %d\n", __FUNCTION__,
+		printk("%s: failed, receive error %d\n", __func__,
 		       err);
 		mutex_unlock(&ttusb->semusb);
 		return err;
@@ -229,7 +229,7 @@ static int ttusb_i2c_msg(struct ttusb *ttusb,
 		if (err || b[0] != 0x55 || b[1] != id) {
 			dprintk
 			    ("%s: usb_bulk_msg(recv) failed, err == %i, id == %02x, b == ",
-			     __FUNCTION__, err, id);
+			     __func__, err, id);
 			return -EREMOTEIO;
 		}
 
@@ -273,7 +273,7 @@ static int master_xfer(struct i2c_adapter* adapter, struct i2c_msg *msg, int num
 				    snd_buf, snd_len, rcv_buf, rcv_len);
 
 		if (err < rcv_len) {
-			dprintk("%s: i == %i\n", __FUNCTION__, i);
+			dprintk("%s: i == %i\n", __func__, i);
 			break;
 		}
 
@@ -327,7 +327,7 @@ static int ttusb_boot_dsp(struct ttusb *ttusb)
       done:
 	if (err) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 
 	return err;
@@ -427,7 +427,7 @@ static int ttusb_init_controller(struct ttusb *ttusb)
 	if ((err = ttusb_result(ttusb, get_version, sizeof(get_version))))
 		return err;
 
-	dprintk("%s: stc-version: %c%c%c%c%c\n", __FUNCTION__,
+	dprintk("%s: stc-version: %c%c%c%c%c\n", __func__,
 		get_version[4], get_version[5], get_version[6],
 		get_version[7], get_version[8]);
 
@@ -437,7 +437,7 @@ static int ttusb_init_controller(struct ttusb *ttusb)
 	    memcmp(get_version + 4, "V 2.2", 5)) {
 		printk
 		    ("%s: unknown STC version %c%c%c%c%c, please report!\n",
-		     __FUNCTION__, get_version[4], get_version[5],
+		     __func__, get_version[4], get_version[5],
 		     get_version[6], get_version[7], get_version[8]);
 	}
 
@@ -453,7 +453,7 @@ static int ttusb_init_controller(struct ttusb *ttusb)
 	    ttusb_result(ttusb, get_dsp_version, sizeof(get_dsp_version));
 	if (err)
 		return err;
-	printk("%s: dsp-version: %c%c%c\n", __FUNCTION__,
+	printk("%s: dsp-version: %c%c%c\n", __func__,
 	       get_dsp_version[4], get_dsp_version[5], get_dsp_version[6]);
 	return 0;
 }
@@ -476,7 +476,7 @@ static int ttusb_send_diseqc(struct dvb_frontend* fe,
 	/* Diseqc */
 	if ((err = ttusb_cmd(ttusb, b, 4 + b[3], 0))) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 
 	return err;
@@ -494,7 +494,7 @@ static int ttusb_update_lnb(struct ttusb *ttusb)
 	/* SetLNB */
 	if ((err = ttusb_cmd(ttusb, b, sizeof(b), 0))) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 
 	return err;
@@ -528,7 +528,7 @@ static void ttusb_set_led_freq(struct ttusb *ttusb, u8 freq)
 	err = ttusb_cmd(ttusb, b, sizeof(b), 0);
 	if (err) {
 		dprintk("%s: usb_bulk_msg() failed, return value %i!\n",
-			__FUNCTION__, err);
+			__func__, err);
 	}
 }
 #endif
@@ -554,7 +554,7 @@ static void ttusb_process_muxpack(struct ttusb *ttusb, const u8 * muxpack,
 		csum ^= le16_to_cpup((u16 *) (muxpack + i));
 	if (csum) {
 		printk("%s: muxpack with incorrect checksum, ignoring\n",
-		       __FUNCTION__);
+		       __func__);
 		numinvalid++;
 		return;
 	}
@@ -563,7 +563,7 @@ static void ttusb_process_muxpack(struct ttusb *ttusb, const u8 * muxpack,
 	cc &= 0x7FFF;
 	if ((cc != ttusb->cc) && (ttusb->cc != -1))
 		printk("%s: cc discontinuity (%d frames missing)\n",
-		       __FUNCTION__, (cc - ttusb->cc) & 0x7FFF);
+		       __func__, (cc - ttusb->cc) & 0x7FFF);
 	ttusb->cc = (cc + 1) & 0x7FFF;
 	if (muxpack[0] & 0x80) {
 #ifdef TTUSB_HWSECTIONS
@@ -613,7 +613,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 	int maxwork = 1024;
 	while (len) {
 		if (!(maxwork--)) {
-			printk("%s: too much work\n", __FUNCTION__);
+			printk("%s: too much work\n", __func__);
 			break;
 		}
 
@@ -632,7 +632,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 #else
 				if (ttusb->insync) {
 					printk("%s: lost sync.\n",
-					       __FUNCTION__);
+					       __func__);
 					ttusb->insync = 0;
 				}
 #endif
@@ -691,7 +691,7 @@ static void ttusb_process_frame(struct ttusb *ttusb, u8 * data, int len)
 					else {
 						dprintk
 						    ("%s: invalid state: first byte is %x\n",
-						     __FUNCTION__,
+						     __func__,
 						     ttusb->muxpack[0]);
 						ttusb->mux_state = 0;
 					}
@@ -740,7 +740,7 @@ static void ttusb_iso_irq(struct urb *urb)
 
 #if 0
 	printk("%s: status %d, errcount == %d, length == %i\n",
-	       __FUNCTION__,
+	       __func__,
 	       urb->status, urb->error_count, urb->actual_length);
 #endif
 
@@ -833,7 +833,7 @@ static int ttusb_start_iso_xfer(struct ttusb *ttusb)
 	int i, j, err, buffer_offset = 0;
 
 	if (ttusb->iso_streaming) {
-		printk("%s: iso xfer already running!\n", __FUNCTION__);
+		printk("%s: iso xfer already running!\n", __func__);
 		return 0;
 	}
 
@@ -869,7 +869,7 @@ static int ttusb_start_iso_xfer(struct ttusb *ttusb)
 			ttusb_stop_iso_xfer(ttusb);
 			printk
 			    ("%s: failed urb submission (%i: err = %i)!\n",
-			     __FUNCTION__, i, err);
+			     __func__, i, err);
 			return err;
 		}
 	}
@@ -1643,7 +1643,7 @@ static int ttusb_probe(struct usb_interface *intf, const struct usb_device_id *i
 	struct ttusb *ttusb;
 	int result;
 
-	dprintk("%s: TTUSB DVB connected\n", __FUNCTION__);
+	dprintk("%s: TTUSB DVB connected\n", __func__);
 
 	udev = interface_to_usbdev(intf);
 
@@ -1773,7 +1773,7 @@ static void ttusb_disconnect(struct usb_interface *intf)
 
 	kfree(ttusb);
 
-	dprintk("%s: TTUSB DVB disconnected\n", __FUNCTION__);
+	dprintk("%s: TTUSB DVB disconnected\n", __func__);
 }
 
 static struct usb_device_id ttusb_table[] = {
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index 1ec981d..95110c4 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -217,11 +217,11 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 		case -ETIME:
 			/* this urb is dead, cleanup */
 			dprintk("%s:urb shutting down with status: %d\n",
-					__FUNCTION__, urb->status);
+					__func__, urb->status);
 			return;
 		default:
 			dprintk("%s:nonzero status received: %d\n",
-					__FUNCTION__,urb->status);
+					__func__,urb->status);
 			goto exit;
 	}
 
@@ -235,7 +235,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 		 * keyrepeat signal is recieved for lets say 200ms.
 		 * this should/could be added later ...
 		 * for now lets report each signal as a key down and up*/
-		dprintk("%s:rc signal:%d\n", __FUNCTION__, buffer[4]);
+		dprintk("%s:rc signal:%d\n", __func__, buffer[4]);
 		input_report_key(dec->rc_input_dev, rc_keys[buffer[4] - 1], 1);
 		input_sync(dec->rc_input_dev);
 		input_report_key(dec->rc_input_dev, rc_keys[buffer[4] - 1], 0);
@@ -245,7 +245,7 @@ static void ttusb_dec_handle_irq( struct urb *urb)
 exit:	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if(retval)
 		printk("%s - usb_commit_urb failed with result: %d\n",
-			__FUNCTION__, retval);
+			__func__, retval);
 }
 
 static u16 crc16(u16 crc, const u8 *buf, size_t len)
@@ -268,7 +268,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 	int result, actual_len, i;
 	u8 *b;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	b = kmalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
 	if (!b)
@@ -276,7 +276,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 
 	if ((result = mutex_lock_interruptible(&dec->usb_mutex))) {
 		kfree(b);
-		printk("%s: Failed to lock usb mutex.\n", __FUNCTION__);
+		printk("%s: Failed to lock usb mutex.\n", __func__);
 		return result;
 	}
 
@@ -289,7 +289,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 		memcpy(&b[4], params, param_length);
 
 	if (debug) {
-		printk("%s: command: ", __FUNCTION__);
+		printk("%s: command: ", __func__);
 		for (i = 0; i < param_length + 4; i++)
 			printk("0x%02X ", b[i]);
 		printk("\n");
@@ -300,7 +300,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 
 	if (result) {
 		printk("%s: command bulk message failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 		mutex_unlock(&dec->usb_mutex);
 		kfree(b);
 		return result;
@@ -311,13 +311,13 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 
 	if (result) {
 		printk("%s: result bulk message failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 		mutex_unlock(&dec->usb_mutex);
 		kfree(b);
 		return result;
 	} else {
 		if (debug) {
-			printk("%s: result: ", __FUNCTION__);
+			printk("%s: result: ", __func__);
 			for (i = 0; i < actual_len; i++)
 				printk("0x%02X ", b[i]);
 			printk("\n");
@@ -343,7 +343,7 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
 	int result;
 	unsigned int tmp;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
 	if (result)
@@ -400,7 +400,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
 	u16 audio = htons(dec->pid[DMX_PES_AUDIO]);
 	u16 video = htons(dec->pid[DMX_PES_VIDEO]);
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	memcpy(&b[0], &pcr, 2);
 	memcpy(&b[2], &audio, 2);
@@ -419,12 +419,12 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
 static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
 {
 	if (length < 8) {
-		printk("%s: packet too short - discarding\n", __FUNCTION__);
+		printk("%s: packet too short - discarding\n", __func__);
 		return;
 	}
 
 	if (length > 8 + MAX_PVA_LENGTH) {
-		printk("%s: packet too long - discarding\n", __FUNCTION__);
+		printk("%s: packet too long - discarding\n", __func__);
 		return;
 	}
 
@@ -507,7 +507,7 @@ static void ttusb_dec_process_pva(struct ttusb_dec *dec, u8 *pva, int length)
 		break;
 
 	default:
-		printk("%s: unknown PVA type: %02x.\n", __FUNCTION__,
+		printk("%s: unknown PVA type: %02x.\n", __func__,
 		       pva[2]);
 		break;
 	}
@@ -546,7 +546,7 @@ static void ttusb_dec_process_packet(struct ttusb_dec *dec)
 	u16 packet_id;
 
 	if (dec->packet_length % 2) {
-		printk("%s: odd sized packet - discarding\n", __FUNCTION__);
+		printk("%s: odd sized packet - discarding\n", __func__);
 		return;
 	}
 
@@ -554,7 +554,7 @@ static void ttusb_dec_process_packet(struct ttusb_dec *dec)
 		csum ^= ((dec->packet[i] << 8) + dec->packet[i + 1]);
 
 	if (csum) {
-		printk("%s: checksum failed - discarding\n", __FUNCTION__);
+		printk("%s: checksum failed - discarding\n", __func__);
 		return;
 	}
 
@@ -563,7 +563,7 @@ static void ttusb_dec_process_packet(struct ttusb_dec *dec)
 
 	if ((packet_id != dec->next_packet_id) && dec->next_packet_id) {
 		printk("%s: warning: lost packets between %u and %u\n",
-		       __FUNCTION__, dec->next_packet_id - 1, packet_id);
+		       __func__, dec->next_packet_id - 1, packet_id);
 	}
 
 	if (packet_id == 0xffff)
@@ -652,7 +652,7 @@ static void ttusb_dec_process_urb_frame(struct ttusb_dec *dec, u8 *b,
 					dec->packet_state = 7;
 				} else {
 					printk("%s: unknown packet type: "
-					       "%02x%02x\n", __FUNCTION__,
+					       "%02x%02x\n", __func__,
 					       dec->packet[0], dec->packet[1]);
 					dec->packet_state = 0;
 				}
@@ -724,7 +724,7 @@ static void ttusb_dec_process_urb_frame(struct ttusb_dec *dec, u8 *b,
 
 		default:
 			printk("%s: illegal packet state encountered.\n",
-			       __FUNCTION__);
+			       __func__);
 			dec->packet_state = 0;
 		}
 	}
@@ -792,7 +792,7 @@ static void ttusb_dec_process_urb(struct urb *urb)
 	} else {
 		 /* -ENOENT is expected when unlinking urbs */
 		if (urb->status != -ENOENT)
-			dprintk("%s: urb error: %d\n", __FUNCTION__,
+			dprintk("%s: urb error: %d\n", __func__,
 				urb->status);
 	}
 
@@ -804,7 +804,7 @@ static void ttusb_dec_setup_urbs(struct ttusb_dec *dec)
 {
 	int i, j, buffer_offset = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	for (i = 0; i < ISO_BUF_COUNT; i++) {
 		int frame_offset = 0;
@@ -834,7 +834,7 @@ static void ttusb_dec_stop_iso_xfer(struct ttusb_dec *dec)
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&dec->iso_mutex))
 		return;
@@ -889,7 +889,7 @@ static int ttusb_dec_start_iso_xfer(struct ttusb_dec *dec)
 {
 	int i, result;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (mutex_lock_interruptible(&dec->iso_mutex))
 		return -EAGAIN;
@@ -905,7 +905,7 @@ static int ttusb_dec_start_iso_xfer(struct ttusb_dec *dec)
 			if ((result = usb_submit_urb(dec->iso_urb[i],
 						     GFP_ATOMIC))) {
 				printk("%s: failed urb submission %d: "
-				       "error %d\n", __FUNCTION__, i, result);
+				       "error %d\n", __func__, i, result);
 
 				while (i) {
 					usb_kill_urb(dec->iso_urb[i - 1]);
@@ -932,7 +932,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
 	u8 b0[] = { 0x05 };
 	int result = 0;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dprintk("  ts_type:");
 
@@ -1012,7 +1012,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 	unsigned long flags;
 	u8 x = 1;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	pid = htons(dvbdmxfeed->pid);
 	memcpy(&b0[0], &pid, 2);
@@ -1052,7 +1052,7 @@ static int ttusb_dec_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_demux *dvbdmx = dvbdmxfeed->demux;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (!dvbdmx->dmx.frontend)
 		return -EINVAL;
@@ -1113,7 +1113,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
 
 static int ttusb_dec_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	switch (dvbdmxfeed->type) {
 	case DMX_TYPE_TS:
@@ -1132,7 +1132,7 @@ static void ttusb_dec_free_iso_urbs(struct ttusb_dec *dec)
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	for (i = 0; i < ISO_BUF_COUNT; i++)
 		usb_free_urb(dec->iso_urb[i]);
@@ -1147,7 +1147,7 @@ static int ttusb_dec_alloc_iso_urbs(struct ttusb_dec *dec)
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dec->iso_buffer = pci_alloc_consistent(NULL,
 					       ISO_FRAME_SIZE *
@@ -1214,7 +1214,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
 
 	dec->rc_input_dev = input_dev;
 	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
-		printk("%s: usb_submit_urb failed\n",__FUNCTION__);
+		printk("%s: usb_submit_urb failed\n",__func__);
 	/* enable irq pipe */
 	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
 
@@ -1223,7 +1223,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
 
 static void ttusb_dec_init_v_pes(struct ttusb_dec *dec)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dec->v_pes[0] = 0x00;
 	dec->v_pes[1] = 0x00;
@@ -1233,7 +1233,7 @@ static void ttusb_dec_init_v_pes(struct ttusb_dec *dec)
 
 static int ttusb_dec_init_usb(struct ttusb_dec *dec)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	mutex_init(&dec->usb_mutex);
 	mutex_init(&dec->iso_mutex);
@@ -1281,11 +1281,11 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	u32 crc32_csum, crc32_check, tmp;
 	const struct firmware *fw_entry = NULL;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (request_firmware(&fw_entry, dec->firmware_name, &dec->udev->dev)) {
 		printk(KERN_ERR "%s: Firmware (%s) unavailable.\n",
-		       __FUNCTION__, dec->firmware_name);
+		       __func__, dec->firmware_name);
 		return 1;
 	}
 
@@ -1294,7 +1294,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 
 	if (firmware_size < 60) {
 		printk("%s: firmware size too small for DSP code (%zu < 60).\n",
-			__FUNCTION__, firmware_size);
+			__func__, firmware_size);
 		release_firmware(fw_entry);
 		return -1;
 	}
@@ -1308,7 +1308,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 	if (crc32_csum != crc32_check) {
 		printk("%s: crc32 check of DSP code failed (calculated "
 		       "0x%08x != 0x%08x in file), file invalid.\n",
-			__FUNCTION__, crc32_csum, crc32_check);
+			__func__, crc32_csum, crc32_check);
 		release_firmware(fw_entry);
 		return -1;
 	}
@@ -1376,7 +1376,7 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 	int result;
 	unsigned int mode, model, version;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	result = ttusb_dec_get_stb_state(dec, &mode, &model, &version);
 
@@ -1415,7 +1415,7 @@ static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 			default:
 				printk(KERN_ERR "%s: unknown model returned "
 				       "by firmware (%08x) - please report\n",
-				       __FUNCTION__, model);
+				       __func__, model);
 				return -1;
 				break;
 			}
@@ -1434,12 +1434,12 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 {
 	int result;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if ((result = dvb_register_adapter(&dec->adapter,
 					   dec->model_name, THIS_MODULE, &dec->udev->dev)) < 0) {
 		printk("%s: dvb_register_adapter failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 
 		return result;
 	}
@@ -1454,7 +1454,7 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 	dec->demux.write_to_decoder = NULL;
 
 	if ((result = dvb_dmx_init(&dec->demux)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __FUNCTION__,
+		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
 
 		dvb_unregister_adapter(&dec->adapter);
@@ -1468,7 +1468,7 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 
 	if ((result = dvb_dmxdev_init(&dec->dmxdev, &dec->adapter)) < 0) {
 		printk("%s: dvb_dmxdev_init failed: error %d\n",
-		       __FUNCTION__, result);
+		       __func__, result);
 
 		dvb_dmx_release(&dec->demux);
 		dvb_unregister_adapter(&dec->adapter);
@@ -1480,7 +1480,7 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 
 	if ((result = dec->demux.dmx.add_frontend(&dec->demux.dmx,
 						  &dec->frontend)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __FUNCTION__,
+		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
 
 		dvb_dmxdev_release(&dec->dmxdev);
@@ -1492,7 +1492,7 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 
 	if ((result = dec->demux.dmx.connect_frontend(&dec->demux.dmx,
 						      &dec->frontend)) < 0) {
-		printk("%s: dvb_dmx_init failed: error %d\n", __FUNCTION__,
+		printk("%s: dvb_dmx_init failed: error %d\n", __func__,
 		       result);
 
 		dec->demux.dmx.remove_frontend(&dec->demux.dmx, &dec->frontend);
@@ -1510,7 +1510,7 @@ static int ttusb_dec_init_dvb(struct ttusb_dec *dec)
 
 static void ttusb_dec_exit_dvb(struct ttusb_dec *dec)
 {
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dvb_net_release(&dec->dvb_net);
 	dec->demux.dmx.close(&dec->demux.dmx);
@@ -1528,7 +1528,7 @@ static void ttusb_dec_exit_dvb(struct ttusb_dec *dec)
 static void ttusb_dec_exit_rc(struct ttusb_dec *dec)
 {
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 	/* we have to check whether the irq URB is already submitted.
 	  * As the irq is submitted after the interface is changed,
 	  * this is the best method i figured out.
@@ -1552,7 +1552,7 @@ static void ttusb_dec_exit_usb(struct ttusb_dec *dec)
 {
 	int i;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	dec->iso_stream_count = 0;
 
@@ -1612,12 +1612,12 @@ static int ttusb_dec_probe(struct usb_interface *intf,
 	struct usb_device *udev;
 	struct ttusb_dec *dec;
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	udev = interface_to_usbdev(intf);
 
 	if (!(dec = kzalloc(sizeof(struct ttusb_dec), GFP_KERNEL))) {
-		printk("%s: couldn't allocate memory.\n", __FUNCTION__);
+		printk("%s: couldn't allocate memory.\n", __func__);
 		return -ENOMEM;
 	}
 
@@ -1692,7 +1692,7 @@ static void ttusb_dec_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 
-	dprintk("%s\n", __FUNCTION__);
+	dprintk("%s\n", __func__);
 
 	if (dec->active) {
 		ttusb_dec_exit_tasklet(dec);
@@ -1749,7 +1749,7 @@ static int __init ttusb_dec_init(void)
 	int result;
 
 	if ((result = usb_register(&ttusb_dec_driver)) < 0) {
-		printk("%s: initialisation failed: error %d.\n", __FUNCTION__,
+		printk("%s: initialisation failed: error %d.\n", __func__,
 		       result);
 		return result;
 	}
diff --git a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
index a6fb1d6..eb5eaec 100644
--- a/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
+++ b/drivers/media/dvb/ttusb-dec/ttusbdecfe.c
@@ -53,7 +53,7 @@ static int ttusbdecfe_read_status(struct dvb_frontend* fe, fe_status_t* status)
 		return ret;
 
 	if(len != 4) {
-		printk(KERN_ERR "%s: unexpected reply\n", __FUNCTION__);
+		printk(KERN_ERR "%s: unexpected reply\n", __func__);
 		return -EIO;
 	}
 
@@ -70,7 +70,7 @@ static int ttusbdecfe_read_status(struct dvb_frontend* fe, fe_status_t* status)
 			break;
 		default:
 			pr_info("%s: returned unknown value: %d\n",
-				__FUNCTION__, result[3]);
+				__func__, result[3]);
 			return -EIO;
 	}
 
diff --git a/drivers/media/video/cpia.h b/drivers/media/video/cpia.h
index 78392fb..5096058 100644
--- a/drivers/media/video/cpia.h
+++ b/drivers/media/video/cpia.h
@@ -412,11 +412,11 @@ void cpia_unregister_camera(struct cam_data *cam);
 /* ErrorCode */
 #define ERROR_FLICKER_BELOW_MIN_EXP     0x01 /*flicker exposure got below minimum exposure */
 #define ALOG(fmt,args...) printk(fmt, ##args)
-#define LOG(fmt,args...) ALOG(KERN_INFO __FILE__ ":%s(%d):" fmt, __FUNCTION__ , __LINE__ , ##args)
+#define LOG(fmt,args...) ALOG(KERN_INFO __FILE__ ":%s(%d):" fmt, __func__ , __LINE__ , ##args)
 
 #ifdef _CPIA_DEBUG_
 #define ADBG(fmt,args...) printk(fmt, jiffies, ##args)
-#define DBG(fmt,args...) ADBG(KERN_DEBUG __FILE__" (%ld):%s(%d):" fmt, __FUNCTION__, __LINE__ , ##args)
+#define DBG(fmt,args...) ADBG(KERN_DEBUG __FILE__" (%ld):%s(%d):" fmt, __func__, __LINE__ , ##args)
 #else
 #define DBG(fmn,args...) do {} while(0)
 #endif
diff --git a/drivers/media/video/cpia2/cpia2_core.c b/drivers/media/video/cpia2/cpia2_core.c
index a76bd78..86922e3 100644
--- a/drivers/media/video/cpia2/cpia2_core.c
+++ b/drivers/media/video/cpia2/cpia2_core.c
@@ -570,7 +570,7 @@ int cpia2_send_command(struct camera_data *cam, struct cpia2_command *cmd)
 			    block_name[block_index]);
 		break;
 	default:
-		LOG("%s: invalid request mode\n",__FUNCTION__);
+		LOG("%s: invalid request mode\n",__func__);
 		return -EINVAL;
 	}
 
@@ -952,7 +952,7 @@ static int set_default_user_mode(struct camera_data *cam)
 			frame_rate = CPIA2_VP_FRAMERATE_30;
 		break;
 	default:
-		LOG("%s: Invalid sensor flag value 0x%0X\n",__FUNCTION__,
+		LOG("%s: Invalid sensor flag value 0x%0X\n",__func__,
 		    cam->params.version.sensor_flags);
 		return -EINVAL;
 	}
@@ -2356,12 +2356,12 @@ long cpia2_read(struct camera_data *cam,
 	}
 
 	if (!buf) {
-		ERR("%s: buffer NULL\n",__FUNCTION__);
+		ERR("%s: buffer NULL\n",__func__);
 		return -EINVAL;
 	}
 
 	if (!cam) {
-		ERR("%s: Internal error, camera_data NULL!\n",__FUNCTION__);
+		ERR("%s: Internal error, camera_data NULL!\n",__func__);
 		return -EINVAL;
 	}
 
@@ -2370,7 +2370,7 @@ long cpia2_read(struct camera_data *cam,
 		return -ERESTARTSYS;
 
 	if (!cam->present) {
-		LOG("%s: camera removed\n",__FUNCTION__);
+		LOG("%s: camera removed\n",__func__);
 		mutex_unlock(&cam->busy_lock);
 		return 0;	/* EOF */
 	}
@@ -2434,7 +2434,7 @@ unsigned int cpia2_poll(struct camera_data *cam, struct file *filp,
 	unsigned int status=0;
 
 	if(!cam) {
-		ERR("%s: Internal error, camera_data not found!\n",__FUNCTION__);
+		ERR("%s: Internal error, camera_data not found!\n",__func__);
 		return POLLERR;
 	}
 
diff --git a/drivers/media/video/cpia_usb.c b/drivers/media/video/cpia_usb.c
index 9da4726..ef1f893 100644
--- a/drivers/media/video/cpia_usb.c
+++ b/drivers/media/video/cpia_usb.c
@@ -170,7 +170,7 @@ static void cpia_usb_complete(struct urb *urb)
 	/* resubmit */
 	urb->dev = ucpia->dev;
 	if ((i = usb_submit_urb(urb, GFP_ATOMIC)) != 0)
-		printk(KERN_ERR "%s: usb_submit_urb ret %d\n", __FUNCTION__,  i);
+		printk(KERN_ERR "%s: usb_submit_urb ret %d\n", __func__,  i);
 }
 
 static int cpia_usb_open(void *privdata)
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index 2d414da..15ab4cb 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -263,7 +263,7 @@ int cx23885_tuner_callback(void *priv, int command, int arg)
 		}
 		else {
 			printk(KERN_ERR
-				"%s(): Unknow command.\n", __FUNCTION__);
+				"%s(): Unknow command.\n", __func__);
 			return -EINVAL;
 		}
 		break;
diff --git a/drivers/media/video/cx23885/cx23885-core.c b/drivers/media/video/cx23885/cx23885-core.c
index 8e40c7b..fa90b35 100644
--- a/drivers/media/video/cx23885/cx23885-core.c
+++ b/drivers/media/video/cx23885/cx23885-core.c
@@ -391,7 +391,7 @@ void cx23885_wakeup(struct cx23885_tsport *port,
 	}
 	if (bc != 1)
 		printk("%s: %d buffers handled (should be 1)\n",
-		       __FUNCTION__, bc);
+		       __func__, bc);
 }
 
 int cx23885_sram_channel_setup(struct cx23885_dev *dev,
@@ -403,7 +403,7 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
 
 	if (ch->cmds_start == 0)
 	{
-		dprintk(1, "%s() Erasing channel [%s]\n", __FUNCTION__,
+		dprintk(1, "%s() Erasing channel [%s]\n", __func__,
 			ch->name);
 		cx_write(ch->ptr1_reg, 0);
 		cx_write(ch->ptr2_reg, 0);
@@ -411,7 +411,7 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
 		cx_write(ch->cnt1_reg, 0);
 		return 0;
 	} else {
-		dprintk(1, "%s() Configuring channel [%s]\n", __FUNCTION__,
+		dprintk(1, "%s() Configuring channel [%s]\n", __func__,
 			ch->name);
 	}
 
@@ -428,7 +428,7 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
 
 	/* write CDT */
 	for (i = 0; i < lines; i++) {
-		dprintk(2, "%s() 0x%08x <- 0x%08x\n", __FUNCTION__, cdt + 16*i,
+		dprintk(2, "%s() 0x%08x <- 0x%08x\n", __func__, cdt + 16*i,
 			ch->fifo_start + bpl*i);
 		cx_write(cdt + 16*i, ch->fifo_start + bpl*i);
 		cx_write(cdt + 16*i +  4, 0);
@@ -580,7 +580,7 @@ static void cx23885_shutdown(struct cx23885_dev *dev)
 
 static void cx23885_reset(struct cx23885_dev *dev)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	cx23885_shutdown(dev);
 
@@ -613,7 +613,7 @@ static void cx23885_reset(struct cx23885_dev *dev)
 
 static int cx23885_pci_quirks(struct cx23885_dev *dev)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* The cx23885 bridge has a weird bug which causes NMI to be asserted
 	 * when DMA begins if RDR_TLCTL0 bit4 is not cleared. It does not
@@ -644,7 +644,7 @@ int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
 
 static int cx23885_init_tsport(struct cx23885_dev *dev, struct cx23885_tsport *port, int portno)
 {
-	dprintk(1, "%s(portno=%d)\n", __FUNCTION__, portno);
+	dprintk(1, "%s(portno=%d)\n", __func__, portno);
 
 	/* Transport bus init dma queue  - Common settings */
 	port->dma_ctl_val        = 0x11; /* Enable RISC controller and Fifo */
@@ -735,14 +735,14 @@ static void cx23885_dev_checkrevision(struct cx23885_dev *dev)
 		break;
 	default:
 		printk(KERN_ERR "%s() New hardware revision found 0x%x\n",
-			__FUNCTION__, dev->hwrevision);
+			__func__, dev->hwrevision);
 	}
 	if (dev->hwrevision)
 		printk(KERN_INFO "%s() Hardware revision = 0x%02x\n",
-			__FUNCTION__, dev->hwrevision);
+			__func__, dev->hwrevision);
 	else
 		printk(KERN_ERR "%s() Hardware revision unknown 0x%x\n",
-			__FUNCTION__, dev->hwrevision);
+			__func__, dev->hwrevision);
 }
 
 static int cx23885_dev_setup(struct cx23885_dev *dev)
@@ -776,7 +776,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 		BUG();
 
 	dprintk(1, "%s() Memory configured for PCIe bridge type %d\n",
-		__FUNCTION__, dev->bridge);
+		__func__, dev->bridge);
 
 	/* board config */
 	dev->board = UNSET;
@@ -866,9 +866,9 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	dev->radio_addr = cx23885_boards[dev->board].radio_addr;
 
 	dprintk(1, "%s() tuner_type = 0x%x tuner_addr = 0x%x\n",
-		__FUNCTION__, dev->tuner_type, dev->tuner_addr);
+		__func__, dev->tuner_type, dev->tuner_addr);
 	dprintk(1, "%s() radio_type = 0x%x radio_addr = 0x%x\n",
-		__FUNCTION__, dev->radio_type, dev->radio_addr);
+		__func__, dev->radio_type, dev->radio_addr);
 
 	/* init hardware */
 	cx23885_reset(dev);
@@ -883,21 +883,21 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	if (cx23885_boards[dev->board].porta == CX23885_ANALOG_VIDEO) {
 		if (cx23885_video_register(dev) < 0) {
 			printk(KERN_ERR "%s() Failed to register analog "
-				"video adapters on VID_A\n", __FUNCTION__);
+				"video adapters on VID_A\n", __func__);
 		}
 	}
 
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
 		if (cx23885_dvb_register(&dev->ts1) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_B\n",
-			       __FUNCTION__);
+			       __func__);
 		}
 	}
 
 	if (cx23885_boards[dev->board].portc == CX23885_MPEG_DVB) {
 		if (cx23885_dvb_register(&dev->ts2) < 0) {
 			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_C\n",
-			       __FUNCTION__);
+			       __func__);
 		}
 	}
 
@@ -1092,50 +1092,50 @@ static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
 
-	dprintk(1, "%s() Register Dump\n", __FUNCTION__);
-	dprintk(1, "%s() DEV_CNTRL2               0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() Register Dump\n", __func__);
+	dprintk(1, "%s() DEV_CNTRL2               0x%08X\n", __func__,
 		cx_read(DEV_CNTRL2));
-	dprintk(1, "%s() PCI_INT_MSK              0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() PCI_INT_MSK              0x%08X\n", __func__,
 		cx_read(PCI_INT_MSK));
-	dprintk(1, "%s() AUD_INT_INT_MSK          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_INT_INT_MSK          0x%08X\n", __func__,
 		cx_read(AUDIO_INT_INT_MSK));
-	dprintk(1, "%s() AUD_INT_DMA_CTL          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_INT_DMA_CTL          0x%08X\n", __func__,
 		cx_read(AUD_INT_DMA_CTL));
-	dprintk(1, "%s() AUD_EXT_INT_MSK          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_EXT_INT_MSK          0x%08X\n", __func__,
 		cx_read(AUDIO_EXT_INT_MSK));
-	dprintk(1, "%s() AUD_EXT_DMA_CTL          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() AUD_EXT_DMA_CTL          0x%08X\n", __func__,
 		cx_read(AUD_EXT_DMA_CTL));
-	dprintk(1, "%s() PAD_CTRL                 0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() PAD_CTRL                 0x%08X\n", __func__,
 		cx_read(PAD_CTRL));
-	dprintk(1, "%s() ALT_PIN_OUT_SEL          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() ALT_PIN_OUT_SEL          0x%08X\n", __func__,
 		cx_read(ALT_PIN_OUT_SEL));
-	dprintk(1, "%s() GPIO2                    0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() GPIO2                    0x%08X\n", __func__,
 		cx_read(GPIO2));
-	dprintk(1, "%s() gpcnt(0x%08X)          0x%08X\n", __FUNCTION__,
+	dprintk(1, "%s() gpcnt(0x%08X)          0x%08X\n", __func__,
 		port->reg_gpcnt, cx_read(port->reg_gpcnt));
-	dprintk(1, "%s() gpcnt_ctl(0x%08X)      0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() gpcnt_ctl(0x%08X)      0x%08x\n", __func__,
 		port->reg_gpcnt_ctl, cx_read(port->reg_gpcnt_ctl));
-	dprintk(1, "%s() dma_ctl(0x%08X)        0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() dma_ctl(0x%08X)        0x%08x\n", __func__,
 		port->reg_dma_ctl, cx_read(port->reg_dma_ctl));
-	dprintk(1, "%s() src_sel(0x%08X)        0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() src_sel(0x%08X)        0x%08x\n", __func__,
 		port->reg_src_sel, cx_read(port->reg_src_sel));
-	dprintk(1, "%s() lngth(0x%08X)          0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() lngth(0x%08X)          0x%08x\n", __func__,
 		port->reg_lngth, cx_read(port->reg_lngth));
-	dprintk(1, "%s() hw_sop_ctrl(0x%08X)    0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() hw_sop_ctrl(0x%08X)    0x%08x\n", __func__,
 		port->reg_hw_sop_ctrl, cx_read(port->reg_hw_sop_ctrl));
-	dprintk(1, "%s() gen_ctrl(0x%08X)       0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() gen_ctrl(0x%08X)       0x%08x\n", __func__,
 		port->reg_gen_ctrl, cx_read(port->reg_gen_ctrl));
-	dprintk(1, "%s() bd_pkt_status(0x%08X)  0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() bd_pkt_status(0x%08X)  0x%08x\n", __func__,
 		port->reg_bd_pkt_status, cx_read(port->reg_bd_pkt_status));
-	dprintk(1, "%s() sop_status(0x%08X)     0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() sop_status(0x%08X)     0x%08x\n", __func__,
 		port->reg_sop_status, cx_read(port->reg_sop_status));
-	dprintk(1, "%s() fifo_ovfl_stat(0x%08X) 0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() fifo_ovfl_stat(0x%08X) 0x%08x\n", __func__,
 		port->reg_fifo_ovfl_stat, cx_read(port->reg_fifo_ovfl_stat));
-	dprintk(1, "%s() vld_misc(0x%08X)       0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() vld_misc(0x%08X)       0x%08x\n", __func__,
 		port->reg_vld_misc, cx_read(port->reg_vld_misc));
-	dprintk(1, "%s() ts_clk_en(0x%08X)      0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() ts_clk_en(0x%08X)      0x%08x\n", __func__,
 		port->reg_ts_clk_en, cx_read(port->reg_ts_clk_en));
-	dprintk(1, "%s() ts_int_msk(0x%08X)     0x%08x\n", __FUNCTION__,
+	dprintk(1, "%s() ts_int_msk(0x%08X)     0x%08x\n", __func__,
 		port->reg_ts_int_msk, cx_read(port->reg_ts_int_msk));
 }
 
@@ -1145,7 +1145,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
 {
 	struct cx23885_dev *dev = port->dev;
 
-	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __FUNCTION__,
+	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __func__,
 		buf->vb.width, buf->vb.height, buf->vb.field);
 
 	/* setup fifo + format */
@@ -1163,7 +1163,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
 	if ( (!(cx23885_boards[dev->board].portb & CX23885_MPEG_DVB)) &&
 		(!(cx23885_boards[dev->board].portc & CX23885_MPEG_DVB)) ) {
 		printk( "%s() Failed. Unsupported value in .portb/c (0x%08x)/(0x%08x)\n",
-			__FUNCTION__,
+			__func__,
 			cx23885_boards[dev->board].portb,
 			cx23885_boards[dev->board].portc );
 		return -EINVAL;
@@ -1190,7 +1190,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
 	case CX23885_BRIDGE_885:
 	case CX23885_BRIDGE_887:
 		/* enable irqs */
-		dprintk(1, "%s() enabling TS int's and DMA\n", __FUNCTION__ );
+		dprintk(1, "%s() enabling TS int's and DMA\n", __func__ );
 		cx_set(port->reg_ts_int_msk,  port->ts_int_msk_val);
 		cx_set(port->reg_dma_ctl, port->dma_ctl_val);
 		cx_set(PCI_INT_MSK, dev->pci_irqmask | port->pci_irqmask);
@@ -1210,7 +1210,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
 static int cx23885_stop_dma(struct cx23885_tsport *port)
 {
 	struct cx23885_dev *dev = port->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* Stop interrupts and DMA */
 	cx_clear(port->reg_ts_int_msk, port->ts_int_msk_val);
@@ -1225,13 +1225,13 @@ int cx23885_restart_queue(struct cx23885_tsport *port,
 	struct cx23885_dev *dev = port->dev;
 	struct cx23885_buffer *buf;
 
-	dprintk(5, "%s()\n", __FUNCTION__);
+	dprintk(5, "%s()\n", __func__);
 	if (list_empty(&q->active))
 	{
 		struct cx23885_buffer *prev;
 		prev = NULL;
 
-		dprintk(5, "%s() queue is empty\n", __FUNCTION__);
+		dprintk(5, "%s() queue is empty\n", __func__);
 
 		for (;;) {
 			if (list_empty(&q->queued))
@@ -1286,7 +1286,7 @@ int cx23885_buf_prepare(struct videobuf_queue *q, struct cx23885_tsport *port,
 	int size = port->ts_packet_size * port->ts_packet_count;
 	int rc;
 
-	dprintk(1, "%s: %p\n", __FUNCTION__, buf);
+	dprintk(1, "%s: %p\n", __func__, buf);
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 
@@ -1329,7 +1329,7 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
 		buf->count    = cx88q->count++;
 		mod_timer(&cx88q->timeout, jiffies + BUFFER_TIMEOUT);
 		dprintk(1, "[%p/%d] %s - first active\n",
-			buf, buf->vb.i, __FUNCTION__);
+			buf, buf->vb.i, __func__);
 	} else {
 		dprintk( 1, "queue is not empty - append to active\n" );
 		prev = list_entry(cx88q->active.prev, struct cx23885_buffer,
@@ -1340,7 +1340,7 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		prev->risc.jmp[2] = cpu_to_le32(0); /* 64 bit bits 63-32 */
 		dprintk( 1, "[%p/%d] %s - append to active\n",
-			 buf, buf->vb.i, __FUNCTION__);
+			 buf, buf->vb.i, __func__);
 	}
 }
 
@@ -1377,7 +1377,7 @@ static void cx23885_timeout(unsigned long data)
 	struct cx23885_tsport *port = (struct cx23885_tsport *)data;
 	struct cx23885_dev *dev = port->dev;
 
-	dprintk(1, "%s()\n",__FUNCTION__);
+	dprintk(1, "%s()\n",__func__);
 
 	if (debug > 5)
 		cx23885_sram_channel_dump(dev, &dev->sram_channels[ port->sram_chno ]);
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index ed465c0..a6d42c9 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -182,7 +182,7 @@ static int cx23885_hvr1500_xc3028_callback(void *ptr, int command, int arg)
 	case XC2028_TUNER_RESET:
 		/* Send the tuner in then out of reset */
 		/* GPIO-2 xc3028 tuner */
-		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __FUNCTION__, arg);
+		dprintk(1, "%s: XC2028_TUNER_RESET %d\n", __func__, arg);
 
 		cx_set(GP0_IO, 0x00040000);
 		cx_clear(GP0_IO, 0x00000004);
@@ -192,10 +192,10 @@ static int cx23885_hvr1500_xc3028_callback(void *ptr, int command, int arg)
 		msleep(5);
 		break;
 	case XC2028_RESET_CLK:
-		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
+		dprintk(1, "%s: XC2028_RESET_CLK %d\n", __func__, arg);
 		break;
 	default:
-		dprintk(1, "%s: unknown command %d, arg %d\n", __FUNCTION__,
+		dprintk(1, "%s: unknown command %d, arg %d\n", __func__,
 			command, arg);
 		return -EINVAL;
 	}
@@ -338,7 +338,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 	struct cx23885_dev *dev = port->dev;
 	int err;
 
-	dprintk(1, "%s\n", __FUNCTION__);
+	dprintk(1, "%s\n", __func__);
 	dprintk(1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		dev->board,
 		dev->name,
@@ -354,7 +354,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 			    sizeof(struct cx23885_buffer), port);
 	err = dvb_register(port);
 	if (err != 0)
-		printk("%s() dvb_register failed err = %d\n", __FUNCTION__, err);
+		printk("%s() dvb_register failed err = %d\n", __func__, err);
 
 	return err;
 }
diff --git a/drivers/media/video/cx23885/cx23885-i2c.c b/drivers/media/video/cx23885/cx23885-i2c.c
index 92fe0bd..4ed30a4 100644
--- a/drivers/media/video/cx23885/cx23885-i2c.c
+++ b/drivers/media/video/cx23885/cx23885-i2c.c
@@ -87,10 +87,10 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 	int retval, cnt;
 
 	if (joined_rlen)
-		dprintk(1, "%s(msg->wlen=%d, nextmsg->rlen=%d)\n", __FUNCTION__,
+		dprintk(1, "%s(msg->wlen=%d, nextmsg->rlen=%d)\n", __func__,
 			msg->len, joined_rlen);
 	else
-		dprintk(1, "%s(msg->len=%d)\n", __FUNCTION__, msg->len);
+		dprintk(1, "%s(msg->len=%d)\n", __func__, msg->len);
 
 	/* Deal with i2c probe functions with zero payload */
 	if (msg->len == 0) {
@@ -101,7 +101,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_slave_did_ack(i2c_adap))
 			return -EIO;
 
-		dprintk(1, "%s() returns 0\n", __FUNCTION__);
+		dprintk(1, "%s() returns 0\n", __func__);
 		return 0;
 	}
 
@@ -176,7 +176,7 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 
 
 	if (i2c_debug && !joined)
-		dprintk(1, "%s(msg->len=%d)\n", __FUNCTION__, msg->len);
+		dprintk(1, "%s(msg->len=%d)\n", __func__, msg->len);
 
 	/* Deal with i2c probe functions with zero payload */
 	if (msg->len == 0) {
@@ -188,7 +188,7 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 			return -EIO;
 
 
-		dprintk(1, "%s() returns 0\n", __FUNCTION__);
+		dprintk(1, "%s() returns 0\n", __func__);
 		return 0;
 	}
 
@@ -238,11 +238,11 @@ static int i2c_xfer(struct i2c_adapter *i2c_adap,
 	struct cx23885_dev *dev = bus->dev;
 	int i, retval = 0;
 
-	dprintk(1, "%s(num = %d)\n", __FUNCTION__, num);
+	dprintk(1, "%s(num = %d)\n", __func__, num);
 
 	for (i = 0 ; i < num; i++) {
 		dprintk(1, "%s(num = %d) addr = 0x%02x  len = 0x%x\n",
-			__FUNCTION__, num, msgs[i].addr, msgs[i].len);
+			__func__, num, msgs[i].addr, msgs[i].len);
 		if (msgs[i].flags & I2C_M_RD) {
 			/* read */
 			retval = i2c_readbytes(i2c_adap, &msgs[i], 0);
@@ -383,7 +383,7 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 {
 	struct cx23885_dev *dev = bus->dev;
 
-	dprintk(1, "%s(bus = %d)\n", __FUNCTION__, bus->nr);
+	dprintk(1, "%s(bus = %d)\n", __func__, bus->nr);
 
 	memcpy(&bus->i2c_adap, &cx23885_i2c_adap_template,
 	       sizeof(bus->i2c_adap));
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index d3c4d2c..bbc6459 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -141,7 +141,7 @@ static struct cx23885_fmt *format_by_fourcc(unsigned int fourcc)
 		if (formats[i].fourcc == fourcc)
 			return formats+i;
 
-	printk(KERN_ERR "%s(0x%08x) NOT FOUND\n", __FUNCTION__, fourcc);
+	printk(KERN_ERR "%s(0x%08x) NOT FOUND\n", __func__, fourcc);
 	return NULL;
 }
 
@@ -292,13 +292,13 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 	}
 	if (bc != 1)
 		printk(KERN_ERR "%s: %d buffers handled (should be 1)\n",
-			__FUNCTION__, bc);
+			__func__, bc);
 }
 
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
 {
 	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
-		__FUNCTION__,
+		__func__,
 		(unsigned int)norm,
 		v4l2_norm_to_name(norm));
 
@@ -319,7 +319,7 @@ struct video_device *cx23885_vdev_init(struct cx23885_dev *dev,
 				    char *type)
 {
 	struct video_device *vfd;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	vfd = video_device_alloc();
 	if (NULL == vfd)
@@ -358,7 +358,7 @@ EXPORT_SYMBOL(cx23885_ctrl_query);
 static int res_get(struct cx23885_dev *dev, struct cx23885_fh *fh,
 	unsigned int bit)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	if (fh->resources & bit)
 		/* have it already allocated */
 		return 1;
@@ -392,7 +392,7 @@ static void res_free(struct cx23885_dev *dev, struct cx23885_fh *fh,
 	unsigned int bits)
 {
 	BUG_ON((fh->resources & bits) != bits);
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	mutex_lock(&dev->lock);
 	fh->resources  &= ~bits;
@@ -407,7 +407,7 @@ int cx23885_video_mux(struct cx23885_dev *dev, unsigned int input)
 	memset(&route, 0, sizeof(route));
 
 	dprintk(1, "%s() video_mux: %d [vmux=%d, gpio=0x%x,0x%x,0x%x,0x%x]\n",
-		__FUNCTION__,
+		__func__,
 		input, INPUT(input)->vmux,
 		INPUT(input)->gpio0, INPUT(input)->gpio1,
 		INPUT(input)->gpio2, INPUT(input)->gpio3);
@@ -427,7 +427,7 @@ EXPORT_SYMBOL(cx23885_video_mux);
 int cx23885_set_scale(struct cx23885_dev *dev, unsigned int width,
 	unsigned int height, enum v4l2_field field)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	return 0;
 }
 
@@ -435,7 +435,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
 			   struct cx23885_dmaqueue *q,
 			   struct cx23885_buffer *buf)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	/* setup fifo + format */
 	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH01],
@@ -463,7 +463,7 @@ static int cx23885_restart_video_queue(struct cx23885_dev *dev,
 {
 	struct cx23885_buffer *buf, *prev;
 	struct list_head *item;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (!list_empty(&q->active)) {
 		buf = list_entry(q->active.next, struct cx23885_buffer,
@@ -579,13 +579,13 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 			if (dev->tvnorm & V4L2_STD_NTSC) {
 				/* cx25840 transmits NTSC bottom field first */
 				dprintk(1, "%s() Creating NTSC risc\n",
-					__FUNCTION__);
+					__func__);
 				line0_offset = buf->bpl;
 				line1_offset = 0;
 			} else {
 				/* All other formats are top field first */
 				dprintk(1, "%s() Creating PAL/SECAM risc\n",
-					__FUNCTION__);
+					__func__);
 				line0_offset = 0;
 				line1_offset = buf->bpl;
 			}
@@ -885,7 +885,7 @@ static int video_mmap(struct file *file, struct vm_area_struct *vma)
 
 int cx23885_get_control(struct cx23885_dev *dev, struct v4l2_control *ctl)
 {
-	dprintk(1, "%s() calling cx25840(VIDIOC_G_CTRL)\n", __FUNCTION__);
+	dprintk(1, "%s() calling cx25840(VIDIOC_G_CTRL)\n", __func__);
 	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_G_CTRL, ctl);
 	return 0;
 }
@@ -894,7 +894,7 @@ EXPORT_SYMBOL(cx23885_get_control);
 int cx23885_set_control(struct cx23885_dev *dev, struct v4l2_control *ctl)
 {
 	dprintk(1, "%s() calling cx25840(VIDIOC_S_CTRL)"
-		" (disabled - no action)\n", __FUNCTION__);
+		" (disabled - no action)\n", __func__);
 	return 0;
 }
 EXPORT_SYMBOL(cx23885_set_control);
@@ -990,7 +990,7 @@ static int vidioc_s_fmt_cap(struct file *file, void *priv,
 	struct cx23885_dev *dev  = ((struct cx23885_fh *)priv)->dev;
 	int err;
 
-	dprintk(2, "%s()\n", __FUNCTION__);
+	dprintk(2, "%s()\n", __func__);
 	err = vidioc_try_fmt_cap(file, priv, f);
 
 	if (0 != err)
@@ -999,7 +999,7 @@ static int vidioc_s_fmt_cap(struct file *file, void *priv,
 	fh->width      = f->fmt.pix.width;
 	fh->height     = f->fmt.pix.height;
 	fh->vidq.field = f->fmt.pix.field;
-	dprintk(2, "%s() width=%d height=%d field=%d\n", __FUNCTION__,
+	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__,
 		fh->width, fh->height, fh->vidq.field);
 	cx23885_call_i2c_clients(&dev->i2c_bus[2], VIDIOC_S_FMT, f);
 	return 0;
@@ -1101,7 +1101,7 @@ static int vidioc_streamon(struct file *file, void *priv,
 {
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (unlikely(fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE))
 		return -EINVAL;
@@ -1118,7 +1118,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
 	int err, res;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1136,7 +1136,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *tvnorms)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	mutex_lock(&dev->lock);
 	cx23885_set_tvnorm(dev, *tvnorms);
@@ -1159,7 +1159,7 @@ int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
 		[CX23885_VMUX_DEBUG]      = "for debug only",
 	};
 	unsigned int n;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 
 	n = i->index;
 	if (n >= 4)
@@ -1184,7 +1184,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	return cx23885_enum_input(dev, i);
 }
 
@@ -1193,7 +1193,7 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
 	*i = dev->input;
-	dprintk(1, "%s() returns %d\n", __FUNCTION__, *i);
+	dprintk(1, "%s() returns %d\n", __func__, *i);
 	return 0;
 }
 
@@ -1201,10 +1201,10 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 {
 	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
 
-	dprintk(1, "%s(%d)\n", __FUNCTION__, i);
+	dprintk(1, "%s(%d)\n", __func__, i);
 
 	if (i >= 4) {
-		dprintk(1, "%s() -EINVAL\n", __FUNCTION__);
+		dprintk(1, "%s() -EINVAL\n", __func__);
 		return -EINVAL;
 	}
 
@@ -1389,7 +1389,7 @@ int cx23885_video_irq(struct cx23885_dev *dev, u32 status)
 		return handled;
 	cx_write(VID_A_INT_STAT, status);
 
-	dprintk(2, "%s() status = 0x%08x\n", __FUNCTION__, status);
+	dprintk(2, "%s() status = 0x%08x\n", __func__, status);
 	/* risc op code error */
 	if (status & (1 << 16)) {
 		printk(KERN_WARNING "%s/0: video risc op code error\n",
@@ -1487,7 +1487,7 @@ static const struct file_operations radio_fops = {
 
 void cx23885_video_unregister(struct cx23885_dev *dev)
 {
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	cx_clear(PCI_INT_MSK, 1);
 
 	if (dev->video_dev) {
@@ -1505,7 +1505,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
 {
 	int err;
 
-	dprintk(1, "%s()\n", __FUNCTION__);
+	dprintk(1, "%s()\n", __func__);
 	spin_lock_init(&dev->slock);
 
 	/* Initialize VBI template */
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 316b106..4345342 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -494,7 +494,7 @@ static snd_pcm_uframes_t snd_cx88_pointer(struct snd_pcm_substream *substream)
 
 	count = atomic_read(&chip->count);
 
-//	dprintk(2, "%s - count %d (+%u), period %d, frame %lu\n", __FUNCTION__,
+//	dprintk(2, "%s - count %d (+%u), period %d, frame %lu\n", __func__,
 //		count, new, count & (runtime->periods-1),
 //		runtime->period_size * (count & (runtime->periods-1)));
 	return runtime->period_size * (count & (runtime->periods-1));
diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index a99e9d5..b01e530 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -314,7 +314,7 @@ static int blackbird_mbox_func(void *priv, u32 command, int in, int out, u32 dat
 	u32 value, flag, retval;
 	int i;
 
-	dprintk(1,"%s: 0x%X\n", __FUNCTION__, command);
+	dprintk(1,"%s: 0x%X\n", __func__, command);
 
 	/* this may not be 100% safe if we can't read any memory location
 	   without side effects */
@@ -1055,7 +1055,7 @@ static int mpeg_open(struct inode *inode, struct file *file)
 
 	dev = cx8802_get_device(inode);
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	if (dev == NULL)
 		return -ENODEV;
@@ -1065,7 +1065,7 @@ static int mpeg_open(struct inode *inode, struct file *file)
 	if (drv) {
 		err = drv->request_acquire(drv);
 		if(err != 0) {
-			dprintk(1,"%s: Unable to acquire hardware, %d\n", __FUNCTION__, err);
+			dprintk(1,"%s: Unable to acquire hardware, %d\n", __func__, err);
 			return err;
 		}
 	}
@@ -1284,7 +1284,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	struct cx8802_dev *dev = core->dvbdev;
 	int err;
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 01e2ac9..37e82a9 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -548,7 +548,7 @@ void cx88_wakeup(struct cx88_core *core,
 		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
 	}
 	if (bc != 1)
-		printk("%s: %d buffers handled (should be 1)\n",__FUNCTION__,bc);
+		printk("%s: %d buffers handled (should be 1)\n",__func__,bc);
 }
 
 void cx88_shutdown(struct cx88_core *core)
@@ -577,7 +577,7 @@ void cx88_shutdown(struct cx88_core *core)
 
 int cx88_reset(struct cx88_core *core)
 {
-	dprintk(1,"%s\n",__FUNCTION__);
+	dprintk(1,"%s\n",__func__);
 	cx88_shutdown(core);
 
 	/* clear irq status */
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index f7b41eb..447e427 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -266,7 +266,7 @@ static int lgdt330x_pll_rf_set(struct dvb_frontend* fe, int index)
 	struct cx8802_dev *dev= fe->dvb->priv;
 	struct cx88_core *core = dev->core;
 
-	dprintk(1, "%s: index = %d\n", __FUNCTION__, index);
+	dprintk(1, "%s: index = %d\n", __func__, index);
 	if (index == 0)
 		cx_clear(MO_GP0_IO, 8);
 	else
@@ -685,7 +685,7 @@ static int cx8802_dvb_advise_acquire(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -708,7 +708,7 @@ static int cx8802_dvb_advise_release(struct cx8802_driver *drv)
 {
 	struct cx88_core *core = drv->core;
 	int err = 0;
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_HAUPPAUGE_HVR1300:
@@ -726,7 +726,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 	struct cx8802_dev *dev = drv->core->dvbdev;
 	int err;
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 	dprintk( 1, " ->being probed by Card=%d Name=%s, PCI %02x:%02x\n",
 		core->boardnr,
 		core->name,
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index e357f41..c771f5d 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -146,7 +146,7 @@ static int cx8802_start_dma(struct cx8802_dev    *dev,
 		cx_write(TS_GEN_CNTRL, 0x06); /* punctured clock TS & posedge driven */
 		udelay(100);
 	} else {
-		printk( "%s() Failed. Unsupported value in .mpeg (0x%08x)\n", __FUNCTION__,
+		printk( "%s() Failed. Unsupported value in .mpeg (0x%08x)\n", __func__,
 			core->board.mpeg );
 		return -EINVAL;
 	}
@@ -247,7 +247,7 @@ int cx8802_buf_prepare(struct videobuf_queue *q, struct cx8802_dev *dev,
 	struct videobuf_dmabuf *dma=videobuf_to_dma(&buf->vb);
 	int rc;
 
-	dprintk(1, "%s: %p\n", __FUNCTION__, buf);
+	dprintk(1, "%s: %p\n", __func__, buf);
 	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
 		return -EINVAL;
 
@@ -289,7 +289,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 		buf->count    = cx88q->count++;
 		mod_timer(&cx88q->timeout, jiffies+BUFFER_TIMEOUT);
 		dprintk(1,"[%p/%d] %s - first active\n",
-			buf, buf->vb.i, __FUNCTION__);
+			buf, buf->vb.i, __func__);
 
 	} else {
 		dprintk( 1, "queue is not empty - append to active\n" );
@@ -299,7 +299,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 		buf->count    = cx88q->count++;
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
 		dprintk( 1, "[%p/%d] %s - append to active\n",
-			buf, buf->vb.i, __FUNCTION__);
+			buf, buf->vb.i, __func__);
 	}
 }
 
@@ -342,7 +342,7 @@ static void cx8802_timeout(unsigned long data)
 {
 	struct cx8802_dev *dev = (struct cx8802_dev*)data;
 
-	dprintk(1, "%s\n",__FUNCTION__);
+	dprintk(1, "%s\n",__func__);
 
 	if (debug)
 		cx88_sram_channel_dump(dev->core, &cx88_sram_channels[SRAM_CH28]);
@@ -623,7 +623,7 @@ static int cx8802_request_acquire(struct cx8802_driver *drv)
 		}
 		mutex_unlock(&drv->core->lock);
 
-		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __FUNCTION__, cx_read(MO_GP0_IO));
+		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
 
 	return 0;
@@ -639,7 +639,7 @@ static int cx8802_request_release(struct cx8802_driver *drv)
 	{
 		drv->advise_release(drv);
 		core->active_type_id = CX88_BOARD_NONE;
-		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __FUNCTION__, cx_read(MO_GP0_IO));
+		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
 	mutex_unlock(&drv->core->lock);
 
@@ -813,7 +813,7 @@ static void __devexit cx8802_remove(struct pci_dev *pci_dev)
 
 	dev = pci_get_drvdata(pci_dev);
 
-	dprintk( 1, "%s\n", __FUNCTION__);
+	dprintk( 1, "%s\n", __func__);
 
 	if (!list_empty(&dev->drvlist)) {
 		struct cx8802_driver *drv, *tmp;
diff --git a/drivers/media/video/cx88/cx88-tvaudio.c b/drivers/media/video/cx88/cx88-tvaudio.c
index 76e5c78..8f4c1d2 100644
--- a/drivers/media/video/cx88/cx88-tvaudio.c
+++ b/drivers/media/video/cx88/cx88-tvaudio.c
@@ -265,12 +265,12 @@ static void set_audio_standard_BTSC(struct cx88_core *core, unsigned int sap,
 	mode |= EN_FMRADIO_EN_RDS;
 
 	if (sap) {
-		dprintk("%s SAP (status: unknown)\n", __FUNCTION__);
+		dprintk("%s SAP (status: unknown)\n", __func__);
 		set_audio_start(core, SEL_SAP);
 		set_audio_registers(core, btsc_sap);
 		set_audio_finish(core, mode);
 	} else {
-		dprintk("%s (status: known-good)\n", __FUNCTION__);
+		dprintk("%s (status: known-good)\n", __func__);
 		set_audio_start(core, SEL_BTSC);
 		set_audio_registers(core, btsc);
 		set_audio_finish(core, mode);
@@ -351,16 +351,16 @@ static void set_audio_standard_NICAM(struct cx88_core *core, u32 mode)
 	set_audio_start(core,SEL_NICAM);
 	switch (core->tvaudio) {
 	case WW_L:
-		dprintk("%s SECAM-L NICAM (status: devel)\n", __FUNCTION__);
+		dprintk("%s SECAM-L NICAM (status: devel)\n", __func__);
 		set_audio_registers(core, nicam_l);
 		break;
 	case WW_I:
-		dprintk("%s PAL-I NICAM (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-I NICAM (status: known-good)\n", __func__);
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_i);
 		break;
 	default:
-		dprintk("%s PAL-BGDK NICAM (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-BGDK NICAM (status: known-good)\n", __func__);
 		set_audio_registers(core, nicam_bgdki_common);
 		set_audio_registers(core, nicam_default);
 		break;
@@ -600,28 +600,28 @@ static void set_audio_standard_A2(struct cx88_core *core, u32 mode)
 	set_audio_start(core, SEL_A2);
 	switch (core->tvaudio) {
 	case WW_BG:
-		dprintk("%s PAL-BG A1/2 (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-BG A1/2 (status: known-good)\n", __func__);
 		set_audio_registers(core, a2_bgdk_common);
 		set_audio_registers(core, a2_bg);
 		set_audio_registers(core, a2_deemph50);
 		break;
 	case WW_DK:
-		dprintk("%s PAL-DK A1/2 (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-DK A1/2 (status: known-good)\n", __func__);
 		set_audio_registers(core, a2_bgdk_common);
 		set_audio_registers(core, a2_dk);
 		set_audio_registers(core, a2_deemph50);
 		break;
 	case WW_I:
-		dprintk("%s PAL-I A1 (status: known-good)\n", __FUNCTION__);
+		dprintk("%s PAL-I A1 (status: known-good)\n", __func__);
 		set_audio_registers(core, a1_i);
 		set_audio_registers(core, a2_deemph50);
 		break;
 	case WW_L:
-		dprintk("%s AM-L (status: devel)\n", __FUNCTION__);
+		dprintk("%s AM-L (status: devel)\n", __func__);
 		set_audio_registers(core, am_l);
 		break;
 	default:
-		dprintk("%s Warning: wrong value\n", __FUNCTION__);
+		dprintk("%s Warning: wrong value\n", __func__);
 		return;
 		break;
 	};
@@ -637,7 +637,7 @@ static void set_audio_standard_EIAJ(struct cx88_core *core)
 
 		{ /* end of list */ },
 	};
-	dprintk("%s (status: unknown)\n", __FUNCTION__);
+	dprintk("%s (status: unknown)\n", __func__);
 
 	set_audio_start(core, SEL_EIAJ);
 	set_audio_registers(core, eiaj);
@@ -691,7 +691,7 @@ static void set_audio_standard_FM(struct cx88_core *core,
 		{ /* end of list */ },
 	};
 
-	dprintk("%s (status: unknown)\n", __FUNCTION__);
+	dprintk("%s (status: unknown)\n", __func__);
 	set_audio_start(core, SEL_FMRADIO);
 
 	switch (deemph) {
diff --git a/drivers/media/video/em28xx/em28xx-audio.c b/drivers/media/video/em28xx/em28xx-audio.c
index 8c67f67..92b2a6d 100644
--- a/drivers/media/video/em28xx/em28xx-audio.c
+++ b/drivers/media/video/em28xx/em28xx-audio.c
@@ -51,7 +51,7 @@ MODULE_PARM_DESC(debug, "activates debug info");
 #define dprintk(fmt, arg...) do {					\
 	    if (debug)							\
 		printk(KERN_INFO "em28xx-audio %s: " fmt,		\
-				  __FUNCTION__, ##arg); 		\
+				  __func__, ##arg); 		\
 	} while (0)
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;
diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
index 7d1537c..26b466c 100644
--- a/drivers/media/video/em28xx/em28xx-core.c
+++ b/drivers/media/video/em28xx/em28xx-core.c
@@ -38,7 +38,7 @@ MODULE_PARM_DESC(core_debug,"enable debug messages [core]");
 #define em28xx_coredbg(fmt, arg...) do {\
 	if (core_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 static unsigned int reg_debug = 0;
 module_param(reg_debug,int,0644);
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(reg_debug,"enable debug messages [URB reg]");
 #define em28xx_regdbg(fmt, arg...) do {\
 	if (reg_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 static unsigned int isoc_debug = 0;
 module_param(isoc_debug,int,0644);
@@ -56,7 +56,7 @@ MODULE_PARM_DESC(isoc_debug,"enable debug messages [isoc transfers]");
 #define em28xx_isocdbg(fmt, arg...) do {\
 	if (isoc_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 static int alt = EM28XX_PINOUT;
 module_param(alt, int, 0644);
diff --git a/drivers/media/video/em28xx/em28xx-i2c.c b/drivers/media/video/em28xx/em28xx-i2c.c
index cacd04d..6dc8b54 100644
--- a/drivers/media/video/em28xx/em28xx-i2c.c
+++ b/drivers/media/video/em28xx/em28xx-i2c.c
@@ -45,7 +45,7 @@ MODULE_PARM_DESC(i2c_debug, "enable debug messages [i2c]");
 			printk(fmt, ##args); } while (0)
 #define dprintk2(lvl,fmt, args...) if (i2c_debug>=lvl) do{ \
 			printk(KERN_DEBUG "%s at %s: " fmt, \
-			dev->name, __FUNCTION__ , ##args); } while (0)
+			dev->name, __func__ , ##args); } while (0)
 
 /*
  * em2800_i2c_send_max4()
diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 4abe670..a4b9d70 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -52,7 +52,7 @@
 #define em28xx_videodbg(fmt, arg...) do {\
 	if (video_debug) \
 		printk(KERN_INFO "%s %s :"fmt, \
-			 dev->name, __FUNCTION__ , ##arg); } while (0)
+			 dev->name, __func__ , ##arg); } while (0)
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
diff --git a/drivers/media/video/et61x251/et61x251.h b/drivers/media/video/et61x251/et61x251.h
index 02c741d..cc77d14 100644
--- a/drivers/media/video/et61x251/et61x251.h
+++ b/drivers/media/video/et61x251/et61x251.h
@@ -199,7 +199,7 @@ do {                                                                          \
 			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
 		else if ((level) >= 3)                                        \
 			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
-				 __FILE__, __FUNCTION__, __LINE__ , ## args); \
+				 __FILE__, __func__, __LINE__ , ## args); \
 	}                                                                     \
 } while (0)
 #	define KDBG(level, fmt, args...)                                      \
@@ -209,7 +209,7 @@ do {                                                                          \
 			pr_info("et61x251: " fmt "\n", ## args);              \
 		else if ((level) == 3)                                        \
 			pr_debug("sn9c102: [%s:%s:%d] " fmt "\n", __FILE__,   \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #	define V4LDBG(level, name, cmd)                                       \
@@ -225,7 +225,7 @@ do {                                                                          \
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __FUNCTION__,   \
+dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index 9851987..f8effa2 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -154,7 +154,7 @@ static int get_key_fusionhdtv(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 	}
 
 	if(buf[0] !=0 || buf[1] !=0 || buf[2] !=0 || buf[3] != 0)
-		dprintk(2, "%s: 0x%2x 0x%2x 0x%2x 0x%2x\n", __FUNCTION__,
+		dprintk(2, "%s: 0x%2x 0x%2x 0x%2x 0x%2x\n", __func__,
 			buf[0], buf[1], buf[2], buf[3]);
 
 	/* no key pressed or signal from other ir remote */
diff --git a/drivers/media/video/mt20xx.h b/drivers/media/video/mt20xx.h
index 5e9c825..aa848e1 100644
--- a/drivers/media/video/mt20xx.h
+++ b/drivers/media/video/mt20xx.h
@@ -29,7 +29,7 @@ static inline struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
 					     struct i2c_adapter* i2c_adap,
 					     u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/ov511.h b/drivers/media/video/ov511.h
index 18c6422..1010e51 100644
--- a/drivers/media/video/ov511.h
+++ b/drivers/media/video/ov511.h
@@ -12,7 +12,7 @@
 #ifdef OV511_DEBUG
 	#define PDEBUG(level, fmt, args...) \
 		if (debug >= (level)) info("[%s:%d] " fmt, \
-		__FUNCTION__, __LINE__ , ## args)
+		__func__, __LINE__ , ## args)
 #else
 	#define PDEBUG(level, fmt, args...) do {} while(0)
 #endif
diff --git a/drivers/media/video/ovcamchip/ovcamchip_priv.h b/drivers/media/video/ovcamchip/ovcamchip_priv.h
index 50c7763..9afa4fe 100644
--- a/drivers/media/video/ovcamchip/ovcamchip_priv.h
+++ b/drivers/media/video/ovcamchip/ovcamchip_priv.h
@@ -24,11 +24,11 @@ extern int ovcamchip_debug;
 
 #define PDEBUG(level, fmt, args...) \
 	if (ovcamchip_debug >= (level))	pr_debug("[%s:%d] " fmt "\n", \
-		__FUNCTION__, __LINE__ , ## args)
+		__func__, __LINE__ , ## args)
 
 #define DDEBUG(level, dev, fmt, args...) \
 	if (ovcamchip_debug >= (level))	dev_dbg(dev, "[%s:%d] " fmt "\n", \
-		__FUNCTION__, __LINE__ , ## args)
+		__func__, __LINE__ , ## args)
 
 /* Number of times to retry chip detection. Increase this if you are getting
  * "Failed to init camera chip" */
diff --git a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
index 7a1cd87..734c1aa 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-sysfs.c
@@ -606,7 +606,7 @@ static void pvr2_sysfs_add_control(struct pvr2_sysfs *sfp,int ctl_id)
 	ret = sysfs_create_group(&sfp->class_dev->kobj,&cip->grp);
 	if (ret) {
 		printk(KERN_WARNING "%s: sysfs_create_group error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 		return;
 	}
 	cip->created_ok = !0;
@@ -638,14 +638,14 @@ static void pvr2_sysfs_add_debugifc(struct pvr2_sysfs *sfp)
 	ret = device_create_file(sfp->class_dev,&dip->attr_debugcmd);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		dip->debugcmd_created_ok = !0;
 	}
 	ret = device_create_file(sfp->class_dev,&dip->attr_debuginfo);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		dip->debuginfo_created_ok = !0;
 	}
@@ -849,7 +849,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	ret = device_register(class_dev);
 	if (ret) {
 		printk(KERN_ERR "%s: device_register failed\n",
-		       __FUNCTION__);
+		       __func__);
 		kfree(class_dev);
 		return;
 	}
@@ -862,7 +862,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 				       &sfp->attr_v4l_minor_number);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->v4l_minor_number_created_ok = !0;
 	}
@@ -875,7 +875,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 				       &sfp->attr_v4l_radio_minor_number);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->v4l_radio_minor_number_created_ok = !0;
 	}
@@ -887,7 +887,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 	ret = device_create_file(sfp->class_dev,&sfp->attr_unit_number);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->unit_number_created_ok = !0;
 	}
@@ -900,7 +900,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 				       &sfp->attr_bus_info);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->bus_info_created_ok = !0;
 	}
@@ -913,7 +913,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 				 &sfp->attr_hdw_name);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->hdw_name_created_ok = !0;
 	}
@@ -926,7 +926,7 @@ static void class_dev_create(struct pvr2_sysfs *sfp,
 				 &sfp->attr_hdw_desc);
 	if (ret < 0) {
 		printk(KERN_WARNING "%s: device_create_file error: %d\n",
-		       __FUNCTION__, ret);
+		       __func__, ret);
 	} else {
 		sfp->hdw_desc_created_ok = !0;
 	}
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index f991d72..3ab68d4 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -487,7 +487,7 @@ static void pwc_reset_buffers(struct pwc_device *pdev)
 	int i;
 	unsigned long flags;
 
-	PWC_DEBUG_MEMORY(">> %s __enter__\n", __FUNCTION__);
+	PWC_DEBUG_MEMORY(">> %s __enter__\n", __func__);
 
 	spin_lock_irqsave(&pdev->ptrlock, flags);
 	pdev->full_frames = NULL;
@@ -509,7 +509,7 @@ static void pwc_reset_buffers(struct pwc_device *pdev)
 	pdev->fill_image = 0;
 	spin_unlock_irqrestore(&pdev->ptrlock, flags);
 
-	PWC_DEBUG_MEMORY("<< %s __leaving__\n", __FUNCTION__);
+	PWC_DEBUG_MEMORY("<< %s __leaving__\n", __func__);
 }
 
 
@@ -1426,7 +1426,7 @@ static int pwc_video_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long page, pos = 0;
 	int index;
 
-	PWC_DEBUG_MEMORY(">> %s\n", __FUNCTION__);
+	PWC_DEBUG_MEMORY(">> %s\n", __func__);
 	pdev = vdev->priv;
 	size = vma->vm_end - vma->vm_start;
 	start = vma->vm_start;
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index ea2be9e..e8e06d9 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -91,7 +91,7 @@ static int pinnacle_antenna_pwr(struct saa7134_dev *dev, int on)
 	saa_setl(SAA7134_GPIO_GPSTATUS0 >> 2,   (1 << 28));
 	udelay(10);
 	ok = saa_readl(SAA7134_GPIO_GPSTATUS0) & (1 << 27);
-	dprintk("%s %s\n", __FUNCTION__, ok ? "on" : "off");
+	dprintk("%s %s\n", __func__, ok ? "on" : "off");
 
 	if (!ok)
 		saa_clearl(SAA7134_GPIO_GPSTATUS0 >> 2,   (1 << 26));
@@ -111,7 +111,7 @@ static int mt352_pinnacle_init(struct dvb_frontend* fe)
 	static u8 irq_cfg []       = { INTERRUPT_EN_0, 0x00, 0x00, 0x00, 0x00 };
 	struct saa7134_dev *dev= fe->dvb->priv;
 
-	dprintk("%s called\n", __FUNCTION__);
+	dprintk("%s called\n", __func__);
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
 	udelay(200);
@@ -963,11 +963,11 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (dev->dvb.frontend) {
 				if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
-					wprintk("%s: Lifeview Trio, No tda826x found!\n", __FUNCTION__);
+					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
 				}
 				if (dvb_attach(isl6421_attach, dev->dvb.frontend, &dev->i2c_adap,
 										0x08, 0, 0) == NULL) {
-					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __FUNCTION__);
+					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
 				}
 			}
 		}
@@ -1014,11 +1014,11 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (dev->dvb.frontend) {
 			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
 				       &dev->i2c_adap, 0) == NULL) {
-				wprintk("%s: No tda826x found!\n", __FUNCTION__);
+				wprintk("%s: No tda826x found!\n", __func__);
 			}
 			if (dvb_attach(isl6421_attach, dev->dvb.frontend,
 				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
-				wprintk("%s: No ISL6421 found!\n", __FUNCTION__);
+				wprintk("%s: No ISL6421 found!\n", __func__);
 			}
 		}
 		break;
diff --git a/drivers/media/video/saa7134/saa7134-empress.c b/drivers/media/video/saa7134/saa7134-empress.c
index 3d2ec30..95511f8 100644
--- a/drivers/media/video/saa7134/saa7134-empress.c
+++ b/drivers/media/video/saa7134/saa7134-empress.c
@@ -402,7 +402,7 @@ static int empress_init(struct saa7134_dev *dev)
 {
 	int err;
 
-	dprintk("%s: %s\n",dev->name,__FUNCTION__);
+	dprintk("%s: %s\n",dev->name,__func__);
 	dev->empress_dev = video_device_alloc();
 	if (NULL == dev->empress_dev)
 		return -ENOMEM;
@@ -440,7 +440,7 @@ static int empress_init(struct saa7134_dev *dev)
 
 static int empress_fini(struct saa7134_dev *dev)
 {
-	dprintk("%s: %s\n",dev->name,__FUNCTION__);
+	dprintk("%s: %s\n",dev->name,__func__);
 
 	if (NULL == dev->empress_dev)
 		return 0;
diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
index d5d7d6c..08550e8 100644
--- a/drivers/media/video/se401.c
+++ b/drivers/media/video/se401.c
@@ -300,10 +300,10 @@ static void se401_button_irq(struct urb *urb)
 	case -ENOENT:
 	case -ESHUTDOWN:
 		/* this urb is terminated, clean up */
-		dbg("%s - urb shutting down with status: %d", __FUNCTION__, urb->status);
+		dbg("%s - urb shutting down with status: %d", __func__, urb->status);
 		return;
 	default:
-		dbg("%s - nonzero urb status received: %d", __FUNCTION__, urb->status);
+		dbg("%s - nonzero urb status received: %d", __func__, urb->status);
 		goto exit;
 	}
 
@@ -315,7 +315,7 @@ exit:
 	status = usb_submit_urb (urb, GFP_ATOMIC);
 	if (status)
 		err ("%s - usb_submit_urb failed with result %d",
-		     __FUNCTION__, status);
+		     __func__, status);
 }
 
 static void se401_video_irq(struct urb *urb)
diff --git a/drivers/media/video/sn9c102/sn9c102.h b/drivers/media/video/sn9c102/sn9c102.h
index 2e3c3de..0c8d87d 100644
--- a/drivers/media/video/sn9c102/sn9c102.h
+++ b/drivers/media/video/sn9c102/sn9c102.h
@@ -176,7 +176,7 @@ do {                                                                          \
 			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
 		else if ((level) >= 3)                                        \
 			dev_info(&cam->usbdev->dev, "[%s:%d] " fmt "\n",      \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #	define V4LDBG(level, name, cmd)                                       \
@@ -191,7 +191,7 @@ do {                                                                          \
 			pr_info("sn9c102: " fmt "\n", ## args);               \
 		else if ((level) == 3)                                        \
 			pr_debug("sn9c102: [%s:%d] " fmt "\n",                \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #else
@@ -202,7 +202,7 @@ do {                                                                          \
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __FUNCTION__,   \
+dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
diff --git a/drivers/media/video/stk-webcam.c b/drivers/media/video/stk-webcam.c
index ceba45a..1239bda 100644
--- a/drivers/media/video/stk-webcam.c
+++ b/drivers/media/video/stk-webcam.c
@@ -1100,7 +1100,7 @@ static int stk_setup_format(struct stk_camera *dev)
 			&& i < ARRAY_SIZE(stk_sizes))
 		i++;
 	if (i == ARRAY_SIZE(stk_sizes)) {
-		STK_ERROR("Something is broken in %s\n", __FUNCTION__);
+		STK_ERROR("Something is broken in %s\n", __func__);
 		return -EFAULT;
 	}
 	/* This registers controls some timings, not sure of what. */
diff --git a/drivers/media/video/stv680.c b/drivers/media/video/stv680.c
index afc32aa..1414122 100644
--- a/drivers/media/video/stv680.c
+++ b/drivers/media/video/stv680.c
@@ -80,7 +80,7 @@ static unsigned int debug = 0;
 #define PDEBUG(level, fmt, args...) \
 	do { \
 	if (debug >= level)	\
-		info("[%s:%d] " fmt, __FUNCTION__, __LINE__ , ## args);	\
+		info("[%s:%d] " fmt, __func__, __LINE__ , ## args);	\
 	} while (0)
 
 
diff --git a/drivers/media/video/tcm825x.c b/drivers/media/video/tcm825x.c
index fb895f6..6943b44 100644
--- a/drivers/media/video/tcm825x.c
+++ b/drivers/media/video/tcm825x.c
@@ -906,7 +906,7 @@ static int __init tcm825x_init(void)
 	rval = i2c_add_driver(&tcm825x_i2c_driver);
 	if (rval)
 		printk(KERN_INFO "%s: failed registering " TCM825X_NAME "\n",
-		       __FUNCTION__);
+		       __func__);
 
 	return rval;
 }
diff --git a/drivers/media/video/tda8290.c b/drivers/media/video/tda8290.c
index 55bc89a..3685617 100644
--- a/drivers/media/video/tda8290.c
+++ b/drivers/media/video/tda8290.c
@@ -365,7 +365,7 @@ static void tda8295_set_params(struct dvb_frontend *fe,
 
 	set_audio(fe, params);
 
-	tuner_dbg("%s: freq = %d\n", __FUNCTION__, params->frequency);
+	tuner_dbg("%s: freq = %d\n", __func__, params->frequency);
 
 	tda8295_power(fe, 1);
 	tda8295_agc1_out(fe, 1);
@@ -616,7 +616,7 @@ static int tda8290_probe(struct tuner_i2c_props *i2c_props)
 	if (tda8290_id[1] == TDA8290_ID) {
 		if (debug)
 			printk(KERN_DEBUG "%s: tda8290 detected @ %d-%04x\n",
-			       __FUNCTION__, i2c_adapter_id(i2c_props->adap),
+			       __func__, i2c_adapter_id(i2c_props->adap),
 			       i2c_props->addr);
 		return 0;
 	}
@@ -636,7 +636,7 @@ static int tda8295_probe(struct tuner_i2c_props *i2c_props)
 	if (tda8295_id[1] == TDA8295_ID) {
 		if (debug)
 			printk(KERN_DEBUG "%s: tda8295 detected @ %d-%04x\n",
-			       __FUNCTION__, i2c_adapter_id(i2c_props->adap),
+			       __func__, i2c_adapter_id(i2c_props->adap),
 			       i2c_props->addr);
 		return 0;
 	}
diff --git a/drivers/media/video/tda8290.h b/drivers/media/video/tda8290.h
index dc8ef31..405d511 100644
--- a/drivers/media/video/tda8290.h
+++ b/drivers/media/video/tda8290.h
@@ -39,7 +39,7 @@ extern struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 #else
 static inline int tda829x_probe(struct i2c_adapter *i2c_adap, u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return -EINVAL;
 }
 
@@ -49,7 +49,7 @@ static inline struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 						  struct tda829x_config *cfg)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index ef494fe..542e984 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -35,7 +35,7 @@ static int debug = 0;		/* insmod parameter */
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 #define dprintk(args...) \
-	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __FUNCTION__, __LINE__); printk(args); } } while (0)
+	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __func__, __LINE__); printk(args); } } while (0)
 
 #define	SWITCH		0x00
 #define	LEVEL_ADJUST	0x02
diff --git a/drivers/media/video/tda9887.h b/drivers/media/video/tda9887.h
index 8f873a8..be49dcb 100644
--- a/drivers/media/video/tda9887.h
+++ b/drivers/media/video/tda9887.h
@@ -30,7 +30,7 @@ static inline struct dvb_frontend *tda9887_attach(struct dvb_frontend *fe,
 						  struct i2c_adapter *i2c_adap,
 						  u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/tea5761.h b/drivers/media/video/tea5761.h
index 73a03b4..8eb6272 100644
--- a/drivers/media/video/tea5761.h
+++ b/drivers/media/video/tea5761.h
@@ -31,7 +31,7 @@ static inline int tea5761_autodetection(struct i2c_adapter* i2c_adap,
 					u8 i2c_addr)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return -EINVAL;
 }
 
@@ -39,7 +39,7 @@ static inline struct dvb_frontend *tea5761_attach(struct dvb_frontend *fe,
 						   struct i2c_adapter* i2c_adap,
 						   u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/tea5767.h b/drivers/media/video/tea5767.h
index a44451f..7b547c0 100644
--- a/drivers/media/video/tea5767.h
+++ b/drivers/media/video/tea5767.h
@@ -50,7 +50,7 @@ static inline int tea5767_autodetection(struct i2c_adapter* i2c_adap,
 					u8 i2c_addr)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return -EINVAL;
 }
 
@@ -58,7 +58,7 @@ static inline struct dvb_frontend *tea5767_attach(struct dvb_frontend *fe,
 						   struct i2c_adapter* i2c_adap,
 						   u8 i2c_addr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 523df0b..01d876b 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -37,7 +37,7 @@ static int debug = 0;		/* insmod parameter */
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 #define dprintk(args...) \
-	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __FUNCTION__, __LINE__); printk(args); } } while (0)
+	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __func__, __LINE__); printk(args); } } while (0)
 
 #define TEA6415C_NUM_INPUTS	8
 #define TEA6415C_NUM_OUTPUTS	6
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index ca05cd6..6bda3e1 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -37,7 +37,7 @@ static int debug = 0;		/* insmod parameter */
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off device debugging (default:off).");
 #define dprintk(args...) \
-	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __FUNCTION__, __LINE__); printk(args); } } while (0)
+	    do { if (debug) { printk("%s: %s()[%d]: ", KBUILD_MODNAME, __func__, __LINE__); printk(args); } } while (0)
 
 /* addresses to scan, found only at 0x4c and/or 0x4d (7-Bit) */
 static unsigned short normal_i2c[] = { I2C_ADDR_TEA6420_1, I2C_ADDR_TEA6420_2, I2C_CLIENT_END };
diff --git a/drivers/media/video/tuner-simple.h b/drivers/media/video/tuner-simple.h
index 9089939..d084dd3 100644
--- a/drivers/media/video/tuner-simple.h
+++ b/drivers/media/video/tuner-simple.h
@@ -38,7 +38,7 @@ static inline struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
 						       u8 i2c_addr,
 						       struct simple_tuner_config *cfg)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __FUNCTION__);
+	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/tuner-xc2028.c b/drivers/media/video/tuner-xc2028.c
index 50cf876..76b3e6a 100644
--- a/drivers/media/video/tuner-xc2028.c
+++ b/drivers/media/video/tuner-xc2028.c
@@ -132,7 +132,7 @@ static unsigned int xc2028_get_reg(struct xc2028_data *priv, u16 reg, u16 *val)
 	unsigned char buf[2];
 	unsigned char ibuf[2];
 
-	tuner_dbg("%s %04x called\n", __FUNCTION__, reg);
+	tuner_dbg("%s %04x called\n", __func__, reg);
 
 	buf[0] = reg >> 8;
 	buf[1] = (unsigned char) reg;
@@ -256,7 +256,7 @@ static int load_all_firmwares(struct dvb_frontend *fe)
 	int		      n, n_array;
 	char		      name[33];
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	tuner_dbg("Reading firmware %s\n", priv->ctrl.fname);
 	rc = request_firmware(&fw, priv->ctrl.fname,
@@ -397,7 +397,7 @@ static int seek_firmware(struct dvb_frontend *fe, unsigned int type,
 	int                 i, best_i = -1, best_nr_matches = 0;
 	unsigned int        ign_firm_type_mask = 0;
 
-	tuner_dbg("%s called, want type=", __FUNCTION__);
+	tuner_dbg("%s called, want type=", __func__);
 	if (debug) {
 		dump_firm_type(type);
 		printk("(%x), id %016llx.\n", type, (unsigned long long)*id);
@@ -483,7 +483,7 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 	int                pos, rc;
 	unsigned char      *p, *endp, buf[priv->ctrl.max_len];
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	pos = seek_firmware(fe, type, id);
 	if (pos < 0)
@@ -586,7 +586,7 @@ static int load_scode(struct dvb_frontend *fe, unsigned int type,
 	int                pos, rc;
 	unsigned char	   *p;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (!int_freq) {
 		pos = seek_firmware(fe, type, id);
@@ -650,7 +650,7 @@ static int check_firmware(struct dvb_frontend *fe, unsigned int type,
 	u16			   version, hwmodel;
 	v4l2_std_id		   std0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (!priv->firm) {
 		if (!priv->ctrl.fname) {
@@ -824,7 +824,7 @@ static int xc2028_signal(struct dvb_frontend *fe, u16 *strength)
 	u16                 frq_lock, signal = 0;
 	int                 rc;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
@@ -861,7 +861,7 @@ static int generic_set_freq(struct dvb_frontend *fe, u32 freq /* in HZ */,
 	unsigned char	   buf[4];
 	u32		   div, offset = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
@@ -942,7 +942,7 @@ static int xc2028_set_analog_freq(struct dvb_frontend *fe,
 	struct xc2028_data *priv = fe->tuner_priv;
 	unsigned int       type=0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (p->mode == V4L2_TUNER_RADIO) {
 		type |= FM;
@@ -975,7 +975,7 @@ static int xc2028_set_params(struct dvb_frontend *fe,
 	fe_bandwidth_t     bw = BANDWIDTH_8_MHZ;
 	u16                demod = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	if (priv->ctrl.d2633)
 		type |= D2633;
@@ -1045,7 +1045,7 @@ static int xc2028_sleep(struct dvb_frontend *fe)
 	struct xc2028_data *priv = fe->tuner_priv;
 	int rc = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
@@ -1066,7 +1066,7 @@ static int xc2028_dvb_release(struct dvb_frontend *fe)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&xc2028_list_mutex);
 
@@ -1091,7 +1091,7 @@ static int xc2028_get_frequency(struct dvb_frontend *fe, u32 *frequency)
 {
 	struct xc2028_data *priv = fe->tuner_priv;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	*frequency = priv->frequency;
 
@@ -1104,7 +1104,7 @@ static int xc2028_set_config(struct dvb_frontend *fe, void *priv_cfg)
 	struct xc2028_ctrl *p    = priv_cfg;
 	int                 rc   = 0;
 
-	tuner_dbg("%s called\n", __FUNCTION__);
+	tuner_dbg("%s called\n", __func__);
 
 	mutex_lock(&priv->lock);
 
diff --git a/drivers/media/video/tuner-xc2028.h b/drivers/media/video/tuner-xc2028.h
index 3eb8420..612e490 100644
--- a/drivers/media/video/tuner-xc2028.h
+++ b/drivers/media/video/tuner-xc2028.h
@@ -55,7 +55,7 @@ static inline struct dvb_frontend *xc2028_attach(struct dvb_frontend *fe,
 						 struct xc2028_config *cfg)
 {
 	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
-	       __FUNCTION__);
+	       __func__);
 	return NULL;
 }
 #endif
diff --git a/drivers/media/video/usbvideo/konicawc.c b/drivers/media/video/usbvideo/konicawc.c
index 719b17c..78afaee 100644
--- a/drivers/media/video/usbvideo/konicawc.c
+++ b/drivers/media/video/usbvideo/konicawc.c
@@ -57,7 +57,7 @@ static struct usbvideo *cams;
 static int debug;
 #define DEBUG(n, format, arg...) \
 	if (n <= debug) {	 \
-		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __FUNCTION__ , ## arg); \
+		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __func__ , ## arg); \
 	}
 #else
 #define DEBUG(n, arg...)
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index a2acba0..e9670f0 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -46,7 +46,7 @@
 static int debug;
 #define DEBUG(n, format, arg...) \
 	if (n <= debug) {	 \
-		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __FUNCTION__ , ## arg); \
+		printk(KERN_DEBUG __FILE__ ":%s(): " format "\n", __func__ , ## arg); \
 	}
 #else
 #define DEBUG(n, arg...)
diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index fb434b5..1c5c729 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -525,11 +525,11 @@ void usbvideo_TestPattern(struct uvd *uvd, int fullframe, int pmode)
 	static int num_pass = 0;
 
 	if (uvd == NULL) {
-		err("%s: uvd == NULL", __FUNCTION__);
+		err("%s: uvd == NULL", __func__);
 		return;
 	}
 	if ((uvd->curframe < 0) || (uvd->curframe >= USBVIDEO_NUMFRAMES)) {
-		err("%s: uvd->curframe=%d.", __FUNCTION__, uvd->curframe);
+		err("%s: uvd->curframe=%d.", __func__, uvd->curframe);
 		return;
 	}
 
@@ -630,15 +630,15 @@ EXPORT_SYMBOL(usbvideo_HexDump);
 static int usbvideo_ClientIncModCount(struct uvd *uvd)
 {
 	if (uvd == NULL) {
-		err("%s: uvd == NULL", __FUNCTION__);
+		err("%s: uvd == NULL", __func__);
 		return -EINVAL;
 	}
 	if (uvd->handle == NULL) {
-		err("%s: uvd->handle == NULL", __FUNCTION__);
+		err("%s: uvd->handle == NULL", __func__);
 		return -EINVAL;
 	}
 	if (!try_module_get(uvd->handle->md_module)) {
-		err("%s: try_module_get() == 0", __FUNCTION__);
+		err("%s: try_module_get() == 0", __func__);
 		return -ENODEV;
 	}
 	return 0;
@@ -647,15 +647,15 @@ static int usbvideo_ClientIncModCount(struct uvd *uvd)
 static void usbvideo_ClientDecModCount(struct uvd *uvd)
 {
 	if (uvd == NULL) {
-		err("%s: uvd == NULL", __FUNCTION__);
+		err("%s: uvd == NULL", __func__);
 		return;
 	}
 	if (uvd->handle == NULL) {
-		err("%s: uvd->handle == NULL", __FUNCTION__);
+		err("%s: uvd->handle == NULL", __func__);
 		return;
 	}
 	if (uvd->handle->md_module == NULL) {
-		err("%s: uvd->handle->md_module == NULL", __FUNCTION__);
+		err("%s: uvd->handle->md_module == NULL", __func__);
 		return;
 	}
 	module_put(uvd->handle->md_module);
@@ -675,13 +675,13 @@ int usbvideo_register(
 
 	/* Check parameters for sanity */
 	if ((num_cams <= 0) || (pCams == NULL) || (cbTbl == NULL)) {
-		err("%s: Illegal call", __FUNCTION__);
+		err("%s: Illegal call", __func__);
 		return -EINVAL;
 	}
 
 	/* Check registration callback - must be set! */
 	if (cbTbl->probe == NULL) {
-		err("%s: probe() is required!", __FUNCTION__);
+		err("%s: probe() is required!", __func__);
 		return -EINVAL;
 	}
 
@@ -692,7 +692,7 @@ int usbvideo_register(
 		return -ENOMEM;
 	}
 	dbg("%s: Allocated $%p (%d. bytes) for %d. cameras",
-	    __FUNCTION__, cams, base_size, num_cams);
+	    __func__, cams, base_size, num_cams);
 
 	/* Copy callbacks, apply defaults for those that are not set */
 	memmove(&cams->cb, cbTbl, sizeof(cams->cb));
@@ -721,7 +721,7 @@ int usbvideo_register(
 			up->user_data = kmalloc(up->user_size, GFP_KERNEL);
 			if (up->user_data == NULL) {
 				err("%s: Failed to allocate user_data (%d. bytes)",
-				    __FUNCTION__, up->user_size);
+				    __func__, up->user_size);
 				while (i) {
 					up = &cams->cam[--i];
 					kfree(up->user_data);
@@ -730,7 +730,7 @@ int usbvideo_register(
 				return -ENOMEM;
 			}
 			dbg("%s: Allocated cams[%d].user_data=$%p (%d. bytes)",
-			     __FUNCTION__, i, up->user_data, up->user_size);
+			     __func__, i, up->user_data, up->user_size);
 		}
 	}
 
@@ -776,19 +776,19 @@ void usbvideo_Deregister(struct usbvideo **pCams)
 	int i;
 
 	if (pCams == NULL) {
-		err("%s: pCams == NULL", __FUNCTION__);
+		err("%s: pCams == NULL", __func__);
 		return;
 	}
 	cams = *pCams;
 	if (cams == NULL) {
-		err("%s: cams == NULL", __FUNCTION__);
+		err("%s: cams == NULL", __func__);
 		return;
 	}
 
-	dbg("%s: Deregistering %s driver.", __FUNCTION__, cams->drvName);
+	dbg("%s: Deregistering %s driver.", __func__, cams->drvName);
 	usb_deregister(&cams->usbdrv);
 
-	dbg("%s: Deallocating cams=$%p (%d. cameras)", __FUNCTION__, cams, cams->num_cameras);
+	dbg("%s: Deallocating cams=$%p (%d. cameras)", __func__, cams, cams->num_cameras);
 	for (i=0; i < cams->num_cameras; i++) {
 		struct uvd *up = &cams->cam[i];
 		int warning = 0;
@@ -802,16 +802,16 @@ void usbvideo_Deregister(struct usbvideo **pCams)
 		}
 		if (warning) {
 			err("%s: Warning: user_data=$%p user_size=%d.",
-			    __FUNCTION__, up->user_data, up->user_size);
+			    __func__, up->user_data, up->user_size);
 		} else {
 			dbg("%s: Freeing %d. $%p->user_data=$%p",
-			    __FUNCTION__, i, up, up->user_data);
+			    __func__, i, up, up->user_data);
 			kfree(up->user_data);
 		}
 	}
 	/* Whole array was allocated in one chunk */
 	dbg("%s: Freed %d uvd structures",
-	    __FUNCTION__, cams->num_cameras);
+	    __func__, cams->num_cameras);
 	kfree(cams);
 	*pCams = NULL;
 }
@@ -846,7 +846,7 @@ static void usbvideo_Disconnect(struct usb_interface *intf)
 	int i;
 
 	if (uvd == NULL) {
-		err("%s($%p): Illegal call.", __FUNCTION__, intf);
+		err("%s($%p): Illegal call.", __func__, intf);
 		return;
 	}
 
@@ -854,7 +854,7 @@ static void usbvideo_Disconnect(struct usb_interface *intf)
 
 	usbvideo_ClientIncModCount(uvd);
 	if (uvd->debug > 0)
-		info("%s(%p.)", __FUNCTION__, intf);
+		info("%s(%p.)", __func__, intf);
 
 	mutex_lock(&uvd->lock);
 	uvd->remove_pending = 1; /* Now all ISO data will be ignored */
@@ -870,10 +870,10 @@ static void usbvideo_Disconnect(struct usb_interface *intf)
 
 	video_unregister_device(&uvd->vdev);
 	if (uvd->debug > 0)
-		info("%s: Video unregistered.", __FUNCTION__);
+		info("%s: Video unregistered.", __func__);
 
 	if (uvd->user)
-		info("%s: In use, disconnect pending.", __FUNCTION__);
+		info("%s: In use, disconnect pending.", __func__);
 	else
 		usbvideo_CameraRelease(uvd);
 	mutex_unlock(&uvd->lock);
@@ -895,7 +895,7 @@ static void usbvideo_Disconnect(struct usb_interface *intf)
 static void usbvideo_CameraRelease(struct uvd *uvd)
 {
 	if (uvd == NULL) {
-		err("%s: Illegal call", __FUNCTION__);
+		err("%s: Illegal call", __func__);
 		return;
 	}
 
@@ -1011,18 +1011,18 @@ int usbvideo_RegisterVideoDevice(struct uvd *uvd)
 	char tmp1[20], tmp2[20];	/* Buffers for printing */
 
 	if (uvd == NULL) {
-		err("%s: Illegal call.", __FUNCTION__);
+		err("%s: Illegal call.", __func__);
 		return -EINVAL;
 	}
 	if (uvd->video_endp == 0) {
-		info("%s: No video endpoint specified; data pump disabled.", __FUNCTION__);
+		info("%s: No video endpoint specified; data pump disabled.", __func__);
 	}
 	if (uvd->paletteBits == 0) {
-		err("%s: No palettes specified!", __FUNCTION__);
+		err("%s: No palettes specified!", __func__);
 		return -EINVAL;
 	}
 	if (uvd->defaultPalette == 0) {
-		info("%s: No default palette!", __FUNCTION__);
+		info("%s: No default palette!", __func__);
 	}
 
 	uvd->max_frame_size = VIDEOSIZE_X(uvd->canvas) *
@@ -1032,17 +1032,17 @@ int usbvideo_RegisterVideoDevice(struct uvd *uvd)
 
 	if (uvd->debug > 0) {
 		info("%s: iface=%d. endpoint=$%02x paletteBits=$%08lx",
-		     __FUNCTION__, uvd->iface, uvd->video_endp, uvd->paletteBits);
+		     __func__, uvd->iface, uvd->video_endp, uvd->paletteBits);
 	}
 	if (video_register_device(&uvd->vdev, VFL_TYPE_GRABBER, video_nr) == -1) {
-		err("%s: video_register_device failed", __FUNCTION__);
+		err("%s: video_register_device failed", __func__);
 		return -EPIPE;
 	}
 	if (uvd->debug > 1) {
-		info("%s: video_register_device() successful", __FUNCTION__);
+		info("%s: video_register_device() successful", __func__);
 	}
 	if (uvd->dev == NULL) {
-		err("%s: uvd->dev == NULL", __FUNCTION__);
+		err("%s: uvd->dev == NULL", __func__);
 		return -EINVAL;
 	}
 
@@ -1110,14 +1110,14 @@ static int usbvideo_v4l_open(struct inode *inode, struct file *file)
 	int i, errCode = 0;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, dev);
+		info("%s($%p)", __func__, dev);
 
 	if (0 < usbvideo_ClientIncModCount(uvd))
 		return -ENODEV;
 	mutex_lock(&uvd->lock);
 
 	if (uvd->user) {
-		err("%s: Someone tried to open an already opened device!", __FUNCTION__);
+		err("%s: Someone tried to open an already opened device!", __func__);
 		errCode = -EBUSY;
 	} else {
 		/* Clear statistics */
@@ -1133,7 +1133,7 @@ static int usbvideo_v4l_open(struct inode *inode, struct file *file)
 		RingQueue_Allocate(&uvd->dp, RING_QUEUE_SIZE);
 		if ((uvd->fbuf == NULL) ||
 		    (!RingQueue_IsAllocated(&uvd->dp))) {
-			err("%s: Failed to allocate fbuf or dp", __FUNCTION__);
+			err("%s: Failed to allocate fbuf or dp", __func__);
 			errCode = -ENOMEM;
 		} else {
 			/* Allocate all buffers */
@@ -1177,19 +1177,19 @@ static int usbvideo_v4l_open(struct inode *inode, struct file *file)
 		if (errCode == 0) {
 			if (VALID_CALLBACK(uvd, setupOnOpen)) {
 				if (uvd->debug > 1)
-					info("%s: setupOnOpen callback", __FUNCTION__);
+					info("%s: setupOnOpen callback", __func__);
 				errCode = GET_CALLBACK(uvd, setupOnOpen)(uvd);
 				if (errCode < 0) {
 					err("%s: setupOnOpen callback failed (%d.).",
-					    __FUNCTION__, errCode);
+					    __func__, errCode);
 				} else if (uvd->debug > 1) {
-					info("%s: setupOnOpen callback successful", __FUNCTION__);
+					info("%s: setupOnOpen callback successful", __func__);
 				}
 			}
 			if (errCode == 0) {
 				uvd->settingsAdjusted = 0;
 				if (uvd->debug > 1)
-					info("%s: Open succeeded.", __FUNCTION__);
+					info("%s: Open succeeded.", __func__);
 				uvd->user++;
 				file->private_data = uvd;
 			}
@@ -1199,7 +1199,7 @@ static int usbvideo_v4l_open(struct inode *inode, struct file *file)
 	if (errCode != 0)
 		usbvideo_ClientDecModCount(uvd);
 	if (uvd->debug > 0)
-		info("%s: Returning %d.", __FUNCTION__, errCode);
+		info("%s: Returning %d.", __func__, errCode);
 	return errCode;
 }
 
@@ -1222,7 +1222,7 @@ static int usbvideo_v4l_close(struct inode *inode, struct file *file)
 	int i;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, dev);
+		info("%s($%p)", __func__, dev);
 
 	mutex_lock(&uvd->lock);
 	GET_CALLBACK(uvd, stopDataPump)(uvd);
@@ -1249,7 +1249,7 @@ static int usbvideo_v4l_close(struct inode *inode, struct file *file)
 	usbvideo_ClientDecModCount(uvd);
 
 	if (uvd->debug > 1)
-		info("%s: Completed.", __FUNCTION__);
+		info("%s: Completed.", __func__);
 	file->private_data = NULL;
 	return 0;
 }
@@ -1503,7 +1503,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 		return -EFAULT;
 
 	if (uvd->debug >= 1)
-		info("%s: %Zd. bytes, noblock=%d.", __FUNCTION__, count, noblock);
+		info("%s: %Zd. bytes, noblock=%d.", __func__, count, noblock);
 
 	mutex_lock(&uvd->lock);
 
@@ -1550,7 +1550,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 	 */
 	if (frmx == -1) {
 		if (uvd->defaultPalette == 0) {
-			err("%s: No default palette; don't know what to do!", __FUNCTION__);
+			err("%s: No default palette; don't know what to do!", __func__);
 			count = -EFAULT;
 			goto read_done;
 		}
@@ -1622,7 +1622,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 	frame->seqRead_Index += count;
 	if (uvd->debug >= 1) {
 		err("%s: {copy} count used=%Zd, new seqRead_Index=%ld",
-			__FUNCTION__, count, frame->seqRead_Index);
+			__func__, count, frame->seqRead_Index);
 	}
 
 	/* Finally check if the frame is done with and "release" it */
@@ -1633,7 +1633,7 @@ static ssize_t usbvideo_v4l_read(struct file *file, char __user *buf,
 		/* Mark it as available to be used again. */
 		uvd->frame[frmx].frameState = FrameState_Unused;
 		if (usbvideo_NewFrame(uvd, (frmx + 1) % USBVIDEO_NUMFRAMES)) {
-			err("%s: usbvideo_NewFrame failed.", __FUNCTION__);
+			err("%s: usbvideo_NewFrame failed.", __func__);
 		}
 	}
 read_done:
@@ -1740,10 +1740,10 @@ static int usbvideo_StartDataPump(struct uvd *uvd)
 	int i, errFlag;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, uvd);
+		info("%s($%p)", __func__, uvd);
 
 	if (!CAMERA_IS_OPERATIONAL(uvd)) {
-		err("%s: Camera is not operational", __FUNCTION__);
+		err("%s: Camera is not operational", __func__);
 		return -EFAULT;
 	}
 	uvd->curframe = -1;
@@ -1751,14 +1751,14 @@ static int usbvideo_StartDataPump(struct uvd *uvd)
 	/* Alternate interface 1 is is the biggest frame size */
 	i = usb_set_interface(dev, uvd->iface, uvd->ifaceAltActive);
 	if (i < 0) {
-		err("%s: usb_set_interface error", __FUNCTION__);
+		err("%s: usb_set_interface error", __func__);
 		uvd->last_error = i;
 		return -EBUSY;
 	}
 	if (VALID_CALLBACK(uvd, videoStart))
 		GET_CALLBACK(uvd, videoStart)(uvd);
 	else
-		err("%s: videoStart not set", __FUNCTION__);
+		err("%s: videoStart not set", __func__);
 
 	/* We double buffer the Iso lists */
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
@@ -1783,12 +1783,12 @@ static int usbvideo_StartDataPump(struct uvd *uvd)
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
 		errFlag = usb_submit_urb(uvd->sbuf[i].urb, GFP_KERNEL);
 		if (errFlag)
-			err("%s: usb_submit_isoc(%d) ret %d", __FUNCTION__, i, errFlag);
+			err("%s: usb_submit_isoc(%d) ret %d", __func__, i, errFlag);
 	}
 
 	uvd->streaming = 1;
 	if (uvd->debug > 1)
-		info("%s: streaming=1 video_endp=$%02x", __FUNCTION__, uvd->video_endp);
+		info("%s: streaming=1 video_endp=$%02x", __func__, uvd->video_endp);
 	return 0;
 }
 
@@ -1810,14 +1810,14 @@ static void usbvideo_StopDataPump(struct uvd *uvd)
 		return;
 
 	if (uvd->debug > 1)
-		info("%s($%p)", __FUNCTION__, uvd);
+		info("%s($%p)", __func__, uvd);
 
 	/* Unschedule all of the iso td's */
 	for (i=0; i < USBVIDEO_NUMSBUF; i++) {
 		usb_kill_urb(uvd->sbuf[i].urb);
 	}
 	if (uvd->debug > 1)
-		info("%s: streaming=0", __FUNCTION__);
+		info("%s: streaming=0", __func__);
 	uvd->streaming = 0;
 
 	if (!uvd->remove_pending) {
@@ -1825,12 +1825,12 @@ static void usbvideo_StopDataPump(struct uvd *uvd)
 		if (VALID_CALLBACK(uvd, videoStop))
 			GET_CALLBACK(uvd, videoStop)(uvd);
 		else
-			err("%s: videoStop not set", __FUNCTION__);
+			err("%s: videoStop not set", __func__);
 
 		/* Set packet size to 0 */
 		j = usb_set_interface(uvd->dev, uvd->iface, uvd->ifaceAltInactive);
 		if (j < 0) {
-			err("%s: usb_set_interface() error %d.", __FUNCTION__, j);
+			err("%s: usb_set_interface() error %d.", __func__, j);
 			uvd->last_error = j;
 		}
 	}
@@ -1954,12 +1954,12 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 	struct usbvideo_frame *frame = &uvd->frame[frameNum];
 
 	if (uvd->debug >= 2)
-		info("%s($%p,%d.)", __FUNCTION__, uvd, frameNum);
+		info("%s($%p,%d.)", __func__, uvd, frameNum);
 
 	switch (frame->frameState) {
 	case FrameState_Unused:
 		if (uvd->debug >= 2)
-			info("%s: FrameState_Unused", __FUNCTION__);
+			info("%s: FrameState_Unused", __func__);
 		return -EINVAL;
 	case FrameState_Ready:
 	case FrameState_Grabbing:
@@ -1969,7 +1969,7 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 	redo:
 		if (!CAMERA_IS_OPERATIONAL(uvd)) {
 			if (uvd->debug >= 2)
-				info("%s: Camera is not operational (1)", __FUNCTION__);
+				info("%s: Camera is not operational (1)", __func__);
 			return -EIO;
 		}
 		ntries = 0;
@@ -1978,24 +1978,24 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 			signalPending = signal_pending(current);
 			if (!CAMERA_IS_OPERATIONAL(uvd)) {
 				if (uvd->debug >= 2)
-					info("%s: Camera is not operational (2)", __FUNCTION__);
+					info("%s: Camera is not operational (2)", __func__);
 				return -EIO;
 			}
 			assert(uvd->fbuf != NULL);
 			if (signalPending) {
 				if (uvd->debug >= 2)
-					info("%s: Signal=$%08x", __FUNCTION__, signalPending);
+					info("%s: Signal=$%08x", __func__, signalPending);
 				if (uvd->flags & FLAGS_RETRY_VIDIOCSYNC) {
 					usbvideo_TestPattern(uvd, 1, 0);
 					uvd->curframe = -1;
 					uvd->stats.frame_num++;
 					if (uvd->debug >= 2)
-						info("%s: Forced test pattern screen", __FUNCTION__);
+						info("%s: Forced test pattern screen", __func__);
 					return 0;
 				} else {
 					/* Standard answer: Interrupted! */
 					if (uvd->debug >= 2)
-						info("%s: Interrupted!", __FUNCTION__);
+						info("%s: Interrupted!", __func__);
 					return -EINTR;
 				}
 			} else {
@@ -2005,17 +2005,17 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 				else if (VALID_CALLBACK(uvd, processData))
 					GET_CALLBACK(uvd, processData)(uvd, frame);
 				else
-					err("%s: processData not set", __FUNCTION__);
+					err("%s: processData not set", __func__);
 			}
 		} while (frame->frameState == FrameState_Grabbing);
 		if (uvd->debug >= 2) {
 			info("%s: Grabbing done; state=%d. (%lu. bytes)",
-			     __FUNCTION__, frame->frameState, frame->seqRead_Length);
+			     __func__, frame->frameState, frame->seqRead_Length);
 		}
 		if (frame->frameState == FrameState_Error) {
 			int ret = usbvideo_NewFrame(uvd, frameNum);
 			if (ret < 0) {
-				err("%s: usbvideo_NewFrame() failed (%d.)", __FUNCTION__, ret);
+				err("%s: usbvideo_NewFrame() failed (%d.)", __func__, ret);
 				return ret;
 			}
 			goto redo;
@@ -2047,7 +2047,7 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 		}
 		frame->frameState = FrameState_Done_Hold;
 		if (uvd->debug >= 2)
-			info("%s: Entered FrameState_Done_Hold state.", __FUNCTION__);
+			info("%s: Entered FrameState_Done_Hold state.", __func__);
 		return 0;
 
 	case FrameState_Done_Hold:
@@ -2058,12 +2058,12 @@ static int usbvideo_GetFrame(struct uvd *uvd, int frameNum)
 		 * it will be released back into the wild to roam freely.
 		 */
 		if (uvd->debug >= 2)
-			info("%s: FrameState_Done_Hold state.", __FUNCTION__);
+			info("%s: FrameState_Done_Hold state.", __func__);
 		return 0;
 	}
 
 	/* Catch-all for other cases. We shall not be here. */
-	err("%s: Invalid state %d.", __FUNCTION__, frame->frameState);
+	err("%s: Invalid state %d.", __func__, frame->frameState);
 	frame->frameState = FrameState_Unused;
 	return 0;
 }
@@ -2159,7 +2159,7 @@ static void usbvideo_SoftwareContrastAdjustment(struct uvd *uvd,
 	const int ccm = 128; /* Color correction median - see below */
 
 	if ((uvd == NULL) || (frame == NULL)) {
-		err("%s: Illegal call.", __FUNCTION__);
+		err("%s: Illegal call.", __func__);
 		return;
 	}
 	adj = (uvd->vpic.contrast - 0x8000) >> 8; /* -128..+127 = -ccm..+(ccm-1)*/
diff --git a/drivers/media/video/usbvideo/vicam.c b/drivers/media/video/usbvideo/vicam.c
index da1ba02..7f145b6 100644
--- a/drivers/media/video/usbvideo/vicam.c
+++ b/drivers/media/video/usbvideo/vicam.c
@@ -48,7 +48,7 @@
 // #define VICAM_DEBUG
 
 #ifdef VICAM_DEBUG
-#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __FUNCTION__, lineno, ##args)
+#define ADBG(lineno,fmt,args...) printk(fmt, jiffies, __func__, lineno, ##args)
 #define DBG(fmt,args...) ADBG((__LINE__),KERN_DEBUG __FILE__"(%ld):%s (%d):"fmt,##args)
 #else
 #define DBG(fmn,args...) do {} while(0)
diff --git a/drivers/media/video/usbvision/usbvision-core.c b/drivers/media/video/usbvision/usbvision-core.c
index 56775ab..8066366 100644
--- a/drivers/media/video/usbvision/usbvision-core.c
+++ b/drivers/media/video/usbvision/usbvision-core.c
@@ -384,7 +384,7 @@ int usbvision_scratch_alloc(struct usb_usbvision *usbvision)
 	scratch_reset(usbvision);
 	if(usbvision->scratch == NULL) {
 		err("%s: unable to allocate %d bytes for scratch",
-		    __FUNCTION__, scratch_buf_size);
+		    __func__, scratch_buf_size);
 		return -ENOMEM;
 	}
 	return 0;
@@ -493,7 +493,7 @@ int usbvision_decompress_alloc(struct usb_usbvision *usbvision)
 	int IFB_size = MAX_FRAME_WIDTH * MAX_FRAME_HEIGHT * 3 / 2;
 	usbvision->IntraFrameBuffer = vmalloc_32(IFB_size);
 	if (usbvision->IntraFrameBuffer == NULL) {
-		err("%s: unable to allocate %d for compr. frame buffer", __FUNCTION__, IFB_size);
+		err("%s: unable to allocate %d for compr. frame buffer", __func__, IFB_size);
 		return -ENOMEM;
 	}
 	return 0;
@@ -1516,7 +1516,7 @@ static void usbvision_isocIrq(struct urb *urb)
 
 	if(errCode) {
 		err("%s: usb_submit_urb failed: error %d",
-		    __FUNCTION__, errCode);
+		    __func__, errCode);
 	}
 
 	return;
@@ -1547,7 +1547,7 @@ int usbvision_read_reg(struct usb_usbvision *usbvision, unsigned char reg)
 				0, (__u16) reg, buffer, 1, HZ);
 
 	if (errCode < 0) {
-		err("%s: failed: error %d", __FUNCTION__, errCode);
+		err("%s: failed: error %d", __func__, errCode);
 		return errCode;
 	}
 	return buffer[0];
@@ -1575,7 +1575,7 @@ int usbvision_write_reg(struct usb_usbvision *usbvision, unsigned char reg,
 				USB_RECIP_ENDPOINT, 0, (__u16) reg, &value, 1, HZ);
 
 	if (errCode < 0) {
-		err("%s: failed: error %d", __FUNCTION__, errCode);
+		err("%s: failed: error %d", __func__, errCode);
 	}
 	return errCode;
 }
@@ -1851,7 +1851,7 @@ int usbvision_set_output(struct usb_usbvision *usbvision, int width,
 				 0, (__u16) USBVISION_LXSIZE_O, value, 4, HZ);
 
 		if (errCode < 0) {
-			err("%s failed: error %d", __FUNCTION__, errCode);
+			err("%s failed: error %d", __func__, errCode);
 			return errCode;
 		}
 		usbvision->curwidth = usbvision->stretch_width * UsbWidth;
@@ -2237,7 +2237,7 @@ static int usbvision_set_dram_settings(struct usb_usbvision *usbvision)
 			     (__u16) USBVISION_DRM_PRM1, value, 8, HZ);
 
 	if (rc < 0) {
-		err("%sERROR=%d", __FUNCTION__, rc);
+		err("%sERROR=%d", __func__, rc);
 		return rc;
 	}
 
@@ -2486,7 +2486,7 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
 
 		urb = usb_alloc_urb(USBVISION_URB_FRAMES, GFP_KERNEL);
 		if (urb == NULL) {
-			err("%s: usb_alloc_urb() failed", __FUNCTION__);
+			err("%s: usb_alloc_urb() failed", __func__);
 			return -ENOMEM;
 		}
 		usbvision->sbuf[bufIdx].urb = urb;
@@ -2520,13 +2520,13 @@ int usbvision_init_isoc(struct usb_usbvision *usbvision)
 						 GFP_KERNEL);
 		if (errCode) {
 			err("%s: usb_submit_urb(%d) failed: error %d",
-			    __FUNCTION__, bufIdx, errCode);
+			    __func__, bufIdx, errCode);
 		}
 	}
 
 	usbvision->streaming = Stream_Idle;
 	PDEBUG(DBG_ISOC, "%s: streaming=1 usbvision->video_endp=$%02x",
-	       __FUNCTION__,
+	       __func__,
 	       usbvision->video_endp);
 	return 0;
 }
@@ -2560,7 +2560,7 @@ void usbvision_stop_isoc(struct usb_usbvision *usbvision)
 	}
 
 
-	PDEBUG(DBG_ISOC, "%s: streaming=Stream_Off\n", __FUNCTION__);
+	PDEBUG(DBG_ISOC, "%s: streaming=Stream_Off\n", __func__);
 	usbvision->streaming = Stream_Off;
 
 	if (!usbvision->remove_pending) {
@@ -2571,7 +2571,7 @@ void usbvision_stop_isoc(struct usb_usbvision *usbvision)
 					    usbvision->ifaceAlt);
 		if (errCode < 0) {
 			err("%s: usb_set_interface() failed: error %d",
-			    __FUNCTION__, errCode);
+			    __func__, errCode);
 			usbvision->last_error = errCode;
 		}
 		regValue = (16-usbvision_read_reg(usbvision, USBVISION_ALTER_REG)) & 0x0F;
diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index df52f8a..660ba79 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -343,7 +343,7 @@ static void usbvision_create_sysfs(struct video_device *vdev)
 			return;
 	} while (0);
 
-	err("%s error: %d\n", __FUNCTION__, res);
+	err("%s error: %d\n", __func__, res);
 }
 
 static void usbvision_remove_sysfs(struct video_device *vdev)
@@ -490,7 +490,7 @@ static int usbvision_v4l2_close(struct inode *inode, struct file *file)
 	mutex_unlock(&usbvision->lock);
 
 	if (usbvision->remove_pending) {
-		printk(KERN_INFO "%s: Final disconnect\n", __FUNCTION__);
+		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
 	}
 
@@ -522,7 +522,7 @@ static int vidioc_g_register (struct file *file, void *priv,
 	errCode = usbvision_read_reg(usbvision, reg->reg&0xff);
 	if (errCode < 0) {
 		err("%s: VIDIOC_DBG_G_REGISTER failed: error %d",
-		    __FUNCTION__, errCode);
+		    __func__, errCode);
 		return errCode;
 	}
 	reg->val = errCode;
@@ -543,7 +543,7 @@ static int vidioc_s_register (struct file *file, void *priv,
 	errCode = usbvision_write_reg(usbvision, reg->reg&0xff, reg->val);
 	if (errCode < 0) {
 		err("%s: VIDIOC_DBG_S_REGISTER failed: error %d",
-		    __FUNCTION__, errCode);
+		    __func__, errCode);
 		return errCode;
 	}
 	return 0;
@@ -1102,7 +1102,7 @@ static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
 	int ret,i;
 	struct usbvision_frame *frame;
 
-	PDEBUG(DBG_IO, "%s: %ld bytes, noblock=%d", __FUNCTION__,
+	PDEBUG(DBG_IO, "%s: %ld bytes, noblock=%d", __func__,
 	       (unsigned long)count, noblock);
 
 	if (!USBVISION_IS_OPERATIONAL(usbvision) || (buf == NULL))
@@ -1171,7 +1171,7 @@ static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
 	}
 
 	PDEBUG(DBG_IO, "%s: frmx=%d, bytes_read=%ld, scanlength=%ld",
-	       __FUNCTION__,
+	       __func__,
 	       frame->index, frame->bytes_read, frame->scanlength);
 
 	/* copy bytes to user space; we allow for partials reads */
@@ -1184,7 +1184,7 @@ static ssize_t usbvision_v4l2_read(struct file *file, char __user *buf,
 
 	frame->bytes_read += count;
 	PDEBUG(DBG_IO, "%s: {copy} count used=%ld, new bytes_read=%ld",
-	       __FUNCTION__,
+	       __func__,
 	       (unsigned long)count, frame->bytes_read);
 
 	/* For now, forget the frame if it has not been read in one shot. */
@@ -1269,12 +1269,12 @@ static int usbvision_radio_open(struct inode *inode, struct file *file)
 		(struct usb_usbvision *) video_get_drvdata(dev);
 	int errCode = 0;
 
-	PDEBUG(DBG_IO, "%s:", __FUNCTION__);
+	PDEBUG(DBG_IO, "%s:", __func__);
 
 	mutex_lock(&usbvision->lock);
 
 	if (usbvision->user) {
-		err("%s: Someone tried to open an already opened USBVision Radio!", __FUNCTION__);
+		err("%s: Someone tried to open an already opened USBVision Radio!", __func__);
 		errCode = -EBUSY;
 	}
 	else {
@@ -1342,7 +1342,7 @@ static int usbvision_radio_close(struct inode *inode, struct file *file)
 	mutex_unlock(&usbvision->lock);
 
 	if (usbvision->remove_pending) {
-		printk(KERN_INFO "%s: Final disconnect\n", __FUNCTION__);
+		printk(KERN_INFO "%s: Final disconnect\n", __func__);
 		usbvision_release(usbvision);
 	}
 
@@ -1507,7 +1507,7 @@ static struct video_device *usbvision_vdev_init(struct usb_usbvision *usbvision,
 	struct video_device *vdev;
 
 	if (usb_dev == NULL) {
-		err("%s: usbvision->dev is not set", __FUNCTION__);
+		err("%s: usbvision->dev is not set", __func__);
 		return NULL;
 	}
 
@@ -1759,7 +1759,7 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 		PDEBUG(DBG_PROBE, "model out of bounds %d",model);
 		return -ENODEV;
 	}
-	printk(KERN_INFO "%s: %s found\n", __FUNCTION__,
+	printk(KERN_INFO "%s: %s found\n", __func__,
 				usbvision_device_data[model].ModelString);
 
 	if (usbvision_device_data[model].Interface >= 0) {
@@ -1771,20 +1771,20 @@ static int __devinit usbvision_probe(struct usb_interface *intf,
 	if ((endpoint->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) !=
 	    USB_ENDPOINT_XFER_ISOC) {
 		err("%s: interface %d. has non-ISO endpoint!",
-		    __FUNCTION__, ifnum);
+		    __func__, ifnum);
 		err("%s: Endpoint attributes %d",
-		    __FUNCTION__, endpoint->bmAttributes);
+		    __func__, endpoint->bmAttributes);
 		return -ENODEV;
 	}
 	if ((endpoint->bEndpointAddress & USB_ENDPOINT_DIR_MASK) ==
 	    USB_DIR_OUT) {
 		err("%s: interface %d. has ISO OUT endpoint!",
-		    __FUNCTION__, ifnum);
+		    __func__, ifnum);
 		return -ENODEV;
 	}
 
 	if ((usbvision = usbvision_alloc(dev)) == NULL) {
-		err("%s: couldn't allocate USBVision struct", __FUNCTION__);
+		err("%s: couldn't allocate USBVision struct", __func__);
 		return -ENOMEM;
 	}
 
@@ -1868,7 +1868,7 @@ static void __devexit usbvision_disconnect(struct usb_interface *intf)
 	PDEBUG(DBG_PROBE, "");
 
 	if (usbvision == NULL) {
-		err("%s: usb_get_intfdata() failed", __FUNCTION__);
+		err("%s: usb_get_intfdata() failed", __func__);
 		return;
 	}
 	usb_set_intfdata (intf, NULL);
@@ -1891,7 +1891,7 @@ static void __devexit usbvision_disconnect(struct usb_interface *intf)
 
 	if (usbvision->user) {
 		printk(KERN_INFO "%s: In use, disconnect pending\n",
-		       __FUNCTION__);
+		       __func__);
 		wake_up_interruptible(&usbvision->wait_frame);
 		wake_up_interruptible(&usbvision->wait_stream);
 	} else {
diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index eab79ff..e8ca03b 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -919,7 +919,7 @@ ssize_t videobuf_read_stream(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
-	dprintk(2, "%s\n", __FUNCTION__);
+	dprintk(2, "%s\n", __func__);
 	mutex_lock(&q->vb_lock);
 	retval = -EBUSY;
 	if (q->streaming)
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 53fed4b..3da0e53 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -249,7 +249,7 @@ int videobuf_dma_map(struct videobuf_queue* q,struct videobuf_dmabuf *dma)
 					dma->nr_pages, dma->direction);
 		if (0 == dma->sglen) {
 			printk(KERN_WARNING
-			       "%s: videobuf_map_sg failed\n",__FUNCTION__);
+			       "%s: videobuf_map_sg failed\n",__func__);
 			kfree(dma->sglist);
 			dma->sglist = NULL;
 			dma->sglen = 0;
@@ -431,7 +431,7 @@ static void *__videobuf_alloc(size_t size)
 	videobuf_dma_init(&mem->dma);
 
 	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
-		__FUNCTION__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
+		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
 		mem,(long)sizeof(*mem));
 
 	return vb;
diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
index 5266ecc..31df8b5 100644
--- a/drivers/media/video/videobuf-vmalloc.c
+++ b/drivers/media/video/videobuf-vmalloc.c
@@ -116,7 +116,7 @@ static void *__videobuf_alloc(size_t size)
 	mem->magic=MAGIC_VMAL_MEM;
 
 	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
-		__FUNCTION__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
+		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
 		mem,(long)sizeof(*mem));
 
 	return vb;
diff --git a/drivers/media/video/videodev.c b/drivers/media/video/videodev.c
index 0d9b637..0bf0566 100644
--- a/drivers/media/video/videodev.c
+++ b/drivers/media/video/videodev.c
@@ -2019,7 +2019,7 @@ int video_register_device(struct video_device *vfd, int type, int nr)
 			break;
 		default:
 			printk(KERN_ERR "%s called with unknown type: %d\n",
-			       __FUNCTION__, type);
+			       __func__, type);
 			return -1;
 	}
 
@@ -2057,7 +2057,7 @@ int video_register_device(struct video_device *vfd, int type, int nr)
 	ret = device_register(&vfd->class_dev);
 	if (ret < 0) {
 		printk(KERN_ERR "%s: device_register failed\n",
-		       __FUNCTION__);
+		       __func__);
 		goto fail_minor;
 	}
 
diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 1db067c..89c4866 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -422,7 +422,7 @@ static void vivi_thread_tick(struct vivi_dmaqueue  *dma_q)
 	}
 	if (bc != 1)
 		dprintk(dev, 1, "%s: %d buffers handled (should be 1)\n",
-			__FUNCTION__, bc);
+			__func__, bc);
 	spin_unlock(&dev->slock);
 }
 
@@ -435,7 +435,7 @@ static void vivi_sleep(struct vivi_dmaqueue  *dma_q)
 	int timeout, running_time;
 	DECLARE_WAITQUEUE(wait, current);
 
-	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __FUNCTION__,
+	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __func__,
 		(unsigned long)dma_q);
 
 	add_wait_queue(&dma_q->wq, &wait);
@@ -508,7 +508,7 @@ static int vivi_start_thread(struct vivi_dmaqueue  *dma_q)
 	dma_q->frame = 0;
 	dma_q->ini_jiffies = jiffies;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	dma_q->kthread = kthread_run(vivi_thread, dma_q, "vivi");
 
@@ -519,7 +519,7 @@ static int vivi_start_thread(struct vivi_dmaqueue  *dma_q)
 	/* Wakes thread */
 	wake_up_interruptible(&dma_q->wq);
 
-	dprintk(dev, 1, "returning from %s\n", __FUNCTION__);
+	dprintk(dev, 1, "returning from %s\n", __func__);
 	return 0;
 }
 
@@ -527,7 +527,7 @@ static void vivi_stop_thread(struct vivi_dmaqueue  *dma_q)
 {
 	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 	/* shutdown control thread */
 	if (dma_q->kthread) {
 		kthread_stop(dma_q->kthread);
@@ -540,7 +540,7 @@ static int restart_video_queue(struct vivi_dmaqueue *dma_q)
 	struct vivi_dev *dev = container_of(dma_q, struct vivi_dev, vidq);
 	struct vivi_buffer *buf, *prev;
 
-	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __FUNCTION__,
+	dprintk(dev, 1, "%s dma_q=0x%08lx\n", __func__,
 		(unsigned long)dma_q);
 
 	if (!list_empty(&dma_q->active)) {
@@ -637,7 +637,7 @@ buffer_setup(struct videobuf_queue *vq, unsigned int *count, unsigned int *size)
 	while (*size * *count > vid_limit * 1024 * 1024)
 		(*count)--;
 
-	dprintk(dev, 1, "%s, count=%d, size=%d\n", __FUNCTION__,
+	dprintk(dev, 1, "%s, count=%d, size=%d\n", __func__,
 		*count, *size);
 
 	return 0;
@@ -648,7 +648,7 @@ static void free_buffer(struct videobuf_queue *vq, struct vivi_buffer *buf)
 	struct vivi_fh  *fh = vq->priv_data;
 	struct vivi_dev *dev  = fh->dev;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	if (in_interrupt())
 		BUG();
@@ -669,7 +669,7 @@ buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	struct vivi_buffer *buf = container_of(vb, struct vivi_buffer, vb);
 	int rc, init_buffer = 0;
 
-	dprintk(dev, 1, "%s, field=%d\n", __FUNCTION__, field);
+	dprintk(dev, 1, "%s, field=%d\n", __func__, field);
 
 	BUG_ON(NULL == fh->fmt);
 	if (fh->width  < 48 || fh->width  > norm_maxw() ||
@@ -760,7 +760,7 @@ static void buffer_release(struct videobuf_queue *vq,
 	struct vivi_dev      *dev  = (struct vivi_dev *)fh->dev;
 	struct vivi_dmaqueue *vidq = &dev->vidq;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	vivi_stop_thread(vidq);
 
@@ -1106,7 +1106,7 @@ vivi_poll(struct file *file, struct poll_table_struct *wait)
 	struct vivi_dev       *dev = fh->dev;
 	struct videobuf_queue *q = &fh->vb_vidq;
 
-	dprintk(dev, 1, "%s\n", __FUNCTION__);
+	dprintk(dev, 1, "%s\n", __func__);
 
 	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
 		return POLLERR;
diff --git a/drivers/media/video/w9966.c b/drivers/media/video/w9966.c
index 08aaae0..82c937b 100644
--- a/drivers/media/video/w9966.c
+++ b/drivers/media/video/w9966.c
@@ -64,7 +64,7 @@
 //#define DEBUG				// Undef me for production
 
 #ifdef DEBUG
-#define DPRINTF(x, a...) printk(KERN_DEBUG "W9966: %s(): "x, __FUNCTION__ , ##a)
+#define DPRINTF(x, a...) printk(KERN_DEBUG "W9966: %s(): "x, __func__ , ##a)
 #else
 #define DPRINTF(x...)
 #endif
diff --git a/drivers/media/video/w9968cf.h b/drivers/media/video/w9968cf.h
index ec7696e..3c95316 100644
--- a/drivers/media/video/w9968cf.h
+++ b/drivers/media/video/w9968cf.h
@@ -298,7 +298,7 @@ struct w9968cf_device {
 			dev_warn(&cam->dev, fmt "\n", ## args);               \
 		else if ((level) >= 5)                                        \
 			dev_info(&cam->dev, "[%s:%d] " fmt "\n",              \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 }
 /* For generic kernel (not device specific) messages */
@@ -309,7 +309,7 @@ struct w9968cf_device {
 		if ((level) >= 1 && (level) <= 4)                             \
 			pr_info("w9968cf: " fmt "\n", ## args);               \
 		else if ((level) >= 5)                                        \
-			pr_debug("w9968cf: [%s:%d] " fmt "\n", __FUNCTION__,  \
+			pr_debug("w9968cf: [%s:%d] " fmt "\n", __func__,  \
 				 __LINE__ , ## args);                         \
 	}                                                                     \
 }
@@ -321,7 +321,7 @@ struct w9968cf_device {
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->dev, "[%s:%d] " fmt "\n", __FUNCTION__, __LINE__ , ## args);
+dev_info(&cam->dev, "[%s:%d] " fmt "\n", __func__, __LINE__ , ## args);
 
 #undef PDBGG
 #define PDBGG(fmt, args...) do {;} while(0); /* nothing: it's a placeholder */
diff --git a/drivers/media/video/zc0301/zc0301.h b/drivers/media/video/zc0301/zc0301.h
index a2de50e..7bbab54 100644
--- a/drivers/media/video/zc0301/zc0301.h
+++ b/drivers/media/video/zc0301/zc0301.h
@@ -160,7 +160,7 @@ do {                                                                          \
 			dev_info(&cam->usbdev->dev, fmt "\n", ## args);       \
 		else if ((level) >= 3)                                        \
 			dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n",   \
-				 __FILE__, __FUNCTION__, __LINE__ , ## args); \
+				 __FILE__, __func__, __LINE__ , ## args); \
 	}                                                                     \
 } while (0)
 #	define KDBG(level, fmt, args...)                                      \
@@ -170,7 +170,7 @@ do {                                                                          \
 			pr_info("zc0301: " fmt "\n", ## args);                \
 		else if ((level) == 3)                                        \
 			pr_debug("sn9c102: [%s:%s:%d] " fmt "\n", __FILE__,   \
-				 __FUNCTION__, __LINE__ , ## args);           \
+				 __func__, __LINE__ , ## args);           \
 	}                                                                     \
 } while (0)
 #	define V4LDBG(level, name, cmd)                                       \
@@ -186,7 +186,7 @@ do {                                                                          \
 
 #undef PDBG
 #define PDBG(fmt, args...)                                                    \
-dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __FUNCTION__,   \
+dev_info(&cam->usbdev->dev, "[%s:%s:%d] " fmt "\n", __FILE__, __func__,   \
 	 __LINE__ , ## args)
 
 #undef PDBGG
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index dd3d7d2..c0daed8 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -4247,7 +4247,7 @@ zoran_poll (struct file *file,
 		dprintk(3,
 			KERN_DEBUG
 			"%s: %s() raw - active=%c, sync_tail=%lu/%c, pend_tail=%lu, pend_head=%lu\n",
-			ZR_DEVNAME(zr), __FUNCTION__,
+			ZR_DEVNAME(zr), __func__,
 			"FAL"[fh->v4l_buffers.active], zr->v4l_sync_tail,
 			"UPMD"[zr->v4l_buffers.buffer[frame].state],
 			zr->v4l_pend_tail, zr->v4l_pend_head);
@@ -4269,7 +4269,7 @@ zoran_poll (struct file *file,
 		dprintk(3,
 			KERN_DEBUG
 			"%s: %s() jpg - active=%c, que_tail=%lu/%c, que_head=%lu, dma=%lu/%lu\n",
-			ZR_DEVNAME(zr), __FUNCTION__,
+			ZR_DEVNAME(zr), __func__,
 			"FAL"[fh->jpg_buffers.active], zr->jpg_que_tail,
 			"UPMD"[zr->jpg_buffers.buffer[frame].state],
 			zr->jpg_que_head, zr->jpg_dma_tail, zr->jpg_dma_head);
-- 
1.5.4.3.500.g83a2c



