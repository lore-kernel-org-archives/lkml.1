Return-Path: <linux-kernel-owner+w=401wt.eu-S1762458AbYD3Qb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762458AbYD3Qb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYD3QbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:31:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:60885 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755913AbYD3QbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:31:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18f7IlfOnQfwBzc2enfUXhj2ziUyXjeby94JWfn7y
	qX2d3njyQspq0j
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: Mike Galbraith <efault@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20080430131204.0ce73b3b@gaivota>
References: <20080429185009.716c3284@gaivota>
	 <20080430074807.GA11224@elte.hu>
	 <20080430.005212.46815036.davem@davemloft.net>
	 <20080430081345.GA16519@elte.hu>
	 <1209544030.30990.2.camel@marge.simson.net>
	 <1209544951.15609.3.camel@marge.simson.net>
	 <1209545784.31419.2.camel@marge.simson.net>
	 <1209547231.4898.2.camel@marge.simson.net>
	 <20080430044009.6c5bbc8d.akpm@linux-foundation.org>
	 <1209560592.5265.2.camel@marge.simson.net>
	 <20080430122514.2a52942d@gaivota>
	 <1209570490.5157.1.camel@marge.simson.net>
	 <20080430131204.0ce73b3b@gaivota>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 18:31:09 +0200
Message-Id: <1209573069.4821.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 13:12 -0300, Mauro Carvalho Chehab wrote:
> On Wed, 30 Apr 2008 17:48:10 +0200
> Mike Galbraith <efault@gmx.de> wrote:
> 
> > 
> > On Wed, 2008-04-30 at 12:25 -0300, Mauro Carvalho Chehab wrote:
> > 
> > > Please try this patch. It should avoid an OOPS, if attach fails.
> > 
> > Different oops.
> > 
> 
> Detach order were wrong.
> 
> Try this, please.

[   13.552565] saa7130/34: v4l2 driver version 0.2.14 loaded
[   13.566864] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   13.613250] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   13.627572] saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 84, mmio: 0xfddff000
[   13.640970] saa7133[0]: subsystem: 16be:000d, board: Medion Md8800 Quadro [card=96,autodetected]
[   13.655597] saa7133[0]: board init: gpio is 0
[   13.819782] saa7133[0]: i2c eeprom 00: be 16 0d 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   13.833102] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
[   13.846870] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 29 02 51 96 2b
[   13.861549] saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
[   13.876947] saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f
[   13.893136] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.906301] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.920147] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.934434] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.949006] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.963781] saa7133[0]: i2c eeprom a0:<7>ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc000152c873]
[   13.979917]  ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.990784] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.004791] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.018891] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.032819] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.046597] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.106836] TUNER: Unable to find symbol tda829x_probe()
[   14.115431] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
[   14.128599] DVB: Unable to find symbol tda9887_attach()
[   14.149167] saa7133[0]: registered device video0 [v4l2]
[   14.157472] saa7133[0]: registered device vbi0
[   14.261713] DVB: Unable to find symbol tda827x_attach()
[   14.269949] saa7133[0]/dvb: no tda827x tuner found at addr: 60
[   14.278700] BUG: unable to handle kernel NULL pointer dereference at 0000000000000200
[   14.289562] IP: [<ffffffffa02ded6b>] :dvb_core:dvb_frontend_stop+0x2e/0x85
[   14.299451] PGD bd022067 PUD be877067 PMD 0 
[   14.306703] Oops: 0002 [1] SMP 
[   14.312706] CPU 2 
[   14.317400] Modules linked in: tda1004x saa7134_dvb(+) videobuf_dvb dvb_core tuner saa7134 snd_hda_intel compat_ioctl32 videodev snd_pcm v4l1_compat firewire_ohci v4l2_common firewire_core videobuf_dma_sg snd_timer videobuf_core usbhid snd_page_alloc ir_kbd_i2c crc_itu_t snd_hwdep sr_mod snd ir_common ohci1394 rtc_cmos tveeprom hid i2c_i801 ieee1394 cdrom e1000e usb_storage rtc_core iTCO_wdt i2c_core rtc_lib button intel_agp ff_memless serio_raw iTCO_vendor_support sg soundcore uhci_hcd ehci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[   14.377661] Pid: 2226, comm: modprobe Not tainted 2.6.26-smp #7
[   14.377663] RIP: 0010:[<ffffffffa02ded6b>]  [<ffffffffa02ded6b>] :dvb_core:dvb_frontend_stop+0x2e/0x85
[   14.377673] RSP: 0000:ffff8100be00dc98  EFLAGS: 00010246
[   14.377675] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8100be00db38
[   14.377677] RDX: 00000000ffffffea RSI: ffff8100be00c010 RDI: ffff81003746c410
[   14.377678] RBP: ffff8100be00dca8 R08: 0000000000000000 R09: 0000000000000000
[   14.377680] R10: ffff8100be00da68 R11: ffff81003785ec60 R12: 0000000000000000
[   14.377681] R13: ffffffffa02f7580 R14: ffff8100bd410170 R15: ffffc20010300e00
[   14.377683] FS:  00007fcb72d686f0(0000) GS:ffff8100bf806780(0000) knlGS:0000000000000000
[   14.377685] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   14.377686] CR2: 0000000000000200 CR3: 00000000bddeb000 CR4: 00000000000006e0
[   14.377688] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   14.377690] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   14.377691] Process modprobe (pid: 2226, threadinfo ffff8100be00c000, task ffff8100bd031620)
[   14.377693] Stack:  ffff8100be00dcc8 ffff81003746c410 ffff8100be00dcf8 ffffffffa02dff5b
[   14.377696]  ffffffffa000b4c0 ffff81003746c410 ffff8100be00dcf8 ffffffffa02f2533
[   14.377699]  ffff8100bd410000 ffff8100bd410000 ffff8100bd410000 ffff8100bd410000
[   14.377701] Call Trace:
[   14.377712]  [<ffffffffa02dff5b>] :dvb_core:dvb_unregister_frontend+0x47/0xf9
[   14.377718]  [<ffffffffa02f2533>] ? :saa7134_dvb:configure_tda827x_fe+0x123/0x133
[   14.377725]  [<ffffffffa02f39e9>] :saa7134_dvb:dvb_init+0x14a6/0x1603
[   14.377733]  [<ffffffff80270d2e>] ? get_pageblock_migratetype+0x1b/0x1d
[   14.377740]  [<ffffffff8028c92e>] ? virt_to_head_page+0x31/0x41
[   14.377756]  [<ffffffffa02a9efa>] :saa7134:mpeg_ops_attach+0x36/0x46
[   14.377767]  [<ffffffffa02aaed9>] :saa7134:saa7134_ts_register+0x2a/0x73
[   14.377773]  [<ffffffffa012e010>] :saa7134_dvb:dvb_register+0x10/0x12
[   14.377777]  [<ffffffff80256170>] sys_init_module+0x18be/0x19f4
[   14.377818]  [<ffffffff8023d1e4>] ? msleep+0x0/0x1e
[   14.377823]  [<ffffffff80290142>] ? vfs_read+0xa8/0x102
[   14.377840]  [<ffffffff8020c18b>] system_call_after_swapgs+0x7b/0x80
[   14.377859] 
[   14.377860] 
[   14.377860] Code: e5 53 48 83 ec 08 83 3d fb ef 00 00 00 48 8b 9f d8 02 00 00 74 15 48 c7 c6 50 2d 2e a0 48 c7 c7 12 4b 2e a0 31 c0 e8 36 62 f5 df <c7> 83 00 02 00 00 01 00 00 00 0f ae f0 48 8b bb f0 01 00 00 48 
[   14.377873] RIP  [<ffffffffa02ded6b>] :dvb_core:dvb_frontend_stop+0x2e/0x85
[   14.377881]  RSP <ffff8100be00dc98>
[   14.377882] CR2: 0000000000000200
[   14.377888] ---[ end trace 0fbfd864057429c5 ]---

To be sure we're on the same page, the sum of applied patches is..

diff --git a/drivers/media/Makefile b/drivers/media/Makefile
index 73f742c..cc11c4c 100644
--- a/drivers/media/Makefile
+++ b/drivers/media/Makefile
@@ -2,6 +2,8 @@
 # Makefile for the kernel multimedia device drivers.
 #
 
+obj-y := common/
+
 obj-$(CONFIG_VIDEO_MEDIA) += common/
 
 # Since hybrid devices are here, should be compiled if DVB and/or V4L
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 1c7fe68..d4801ce 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -509,8 +509,8 @@ static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 	if (!fe) {
 		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 		       dev->core->name);
-		dvb_frontend_detach(dev->dvb.frontend);
 		dvb_unregister_frontend(dev->dvb.frontend);
+		dvb_frontend_detach(dev->dvb.frontend);
 		dev->dvb.frontend = NULL;
 		return -EINVAL;
 	}
diff --git a/drivers/media/video/saa7134/saa7134-dvb.c b/drivers/media/video/saa7134/saa7134-dvb.c
index 2d16be2..7b7bcef 100644
--- a/drivers/media/video/saa7134/saa7134-dvb.c
+++ b/drivers/media/video/saa7134/saa7134-dvb.c
@@ -538,19 +538,23 @@ static int philips_tda827x_tuner_sleep(struct dvb_frontend *fe)
 	return 0;
 }
 
-static void configure_tda827x_fe(struct saa7134_dev *dev, struct tda1004x_config *cdec_conf,
-							  struct tda827x_config *tuner_conf)
+static int configure_tda827x_fe(struct saa7134_dev *dev,
+				struct tda1004x_config *cdec_conf,
+				struct tda827x_config *tuner_conf)
 {
 	dev->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
 	if (dev->dvb.frontend) {
 		if (cdec_conf->i2c_gate)
 			dev->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
-		if (dvb_attach(tda827x_attach, dev->dvb.frontend, cdec_conf->tuner_address,
-							&dev->i2c_adap, tuner_conf) == NULL) {
-			wprintk("no tda827x tuner found at addr: %02x\n",
+		if (dvb_attach(tda827x_attach, dev->dvb.frontend,
+			       cdec_conf->tuner_address,
+			       &dev->i2c_adap, tuner_conf))
+			return 0;
+
+		wprintk("no tda827x tuner found at addr: %02x\n",
 				cdec_conf->tuner_address);
-		}
 	}
+	return -EINVAL;
 }
 
 /* ------------------------------------------------------------------ */
@@ -997,7 +1001,9 @@ static int dvb_init(struct saa7134_dev *dev)
 		break;
 	case SAA7134_BOARD_FLYDVBTDUO:
 	case SAA7134_BOARD_FLYDVBT_DUO_CARDBUS:
-		configure_tda827x_fe(dev, &tda827x_lifeview_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_EUROPA:
 	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
@@ -1022,36 +1028,52 @@ static int dvb_init(struct saa7134_dev *dev)
 		}
 		break;
 	case SAA7134_BOARD_KWORLD_DVBT_210:
-		configure_tda827x_fe(dev, &kworld_dvb_t_210_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &kworld_dvb_t_210_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_TIGER:
-		configure_tda827x_fe(dev, &philips_tiger_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &philips_tiger_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PINNACLE_PCTV_310i:
-		configure_tda827x_fe(dev, &pinnacle_pctv_310i_config, &tda827x_cfg_1);
+		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
+					 &tda827x_cfg_1) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
-		configure_tda827x_fe(dev, &hauppauge_hvr_1110_config, &tda827x_cfg_1);
+		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
+					 &tda827x_cfg_1) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
-		configure_tda827x_fe(dev, &asus_p7131_dual_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &asus_p7131_dual_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVBT_LR301:
-		configure_tda827x_fe(dev, &tda827x_lifeview_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_FLYDVB_TRIO:
-		if(! use_frontend) {	/* terrestrial */
-			configure_tda827x_fe(dev, &lifeview_trio_config, &tda827x_cfg_0);
+		if (!use_frontend) {	/* terrestrial */
+			if (configure_tda827x_fe(dev, &lifeview_trio_config,
+						 &tda827x_cfg_0) < 0)
+				goto dettach_frontend;
 		} else {  		/* satellite */
 			dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
 			if (dev->dvb.frontend) {
 				if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x63,
 									&dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
+					goto dettach_frontend;
 				}
 				if (dvb_attach(isl6421_attach, dev->dvb.frontend, &dev->i2c_adap,
 										0x08, 0, 0) == NULL) {
 					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
+					goto dettach_frontend;
 				}
 			}
 		}
@@ -1067,15 +1089,20 @@ static int dvb_init(struct saa7134_dev *dev)
 								&ads_duo_cfg) == NULL) {
 				wprintk("no tda827x tuner found at addr: %02x\n",
 					ads_tech_duo_config.tuner_address);
+				goto dettach_frontend;
 			}
 		}
 		break;
 	case SAA7134_BOARD_TEVION_DVBT_220RF:
-		configure_tda827x_fe(dev, &tevion_dvbt220rf_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &tevion_dvbt220rf_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
 		if (!use_frontend) {     /* terrestrial */
-			configure_tda827x_fe(dev, &md8800_dvbt_config, &tda827x_cfg_0);
+			if (configure_tda827x_fe(dev, &md8800_dvbt_config,
+						 &tda827x_cfg_0) < 0)
+				goto dettach_frontend;
 		} else {        /* satellite */
 			dev->dvb.frontend = dvb_attach(tda10086_attach,
 							&flydvbs, &dev->i2c_adap);
@@ -1086,16 +1113,20 @@ static int dvb_init(struct saa7134_dev *dev)
 				struct i2c_msg msg = {.addr = 0x08, .flags = 0, .len = 1};
 
 				if (dvb_attach(tda826x_attach, dev->dvb.frontend,
-						0x60, &dev->i2c_adap, 0) == NULL)
+						0x60, &dev->i2c_adap, 0) == NULL) {
 					wprintk("%s: Medion Quadro, no tda826x "
 						"found !\n", __func__);
+					goto dettach_frontend;
+				}
 				if (dev_id != 0x08) {
 					/* we need to open the i2c gate (we know it exists) */
 					fe->ops.i2c_gate_ctrl(fe, 1);
 					if (dvb_attach(isl6405_attach, fe,
-							&dev->i2c_adap, 0x08, 0, 0) == NULL)
+							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
 						wprintk("%s: Medion Quadro, no ISL6405 "
 							"found !\n", __func__);
+						goto dettach_frontend;
+					}
 					if (dev_id == 0x07) {
 						/* fire up the 2nd section of the LNB supply since
 						   we can't do this from the other section */
@@ -1117,19 +1148,17 @@ static int dvb_init(struct saa7134_dev *dev)
 	case SAA7134_BOARD_AVERMEDIA_AVERTVHD_A180:
 		dev->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
+		if (dev->dvb.frontend)
 			dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x61,
 				   NULL, DVB_PLL_TDHU2);
-		}
 		break;
 	case SAA7134_BOARD_KWORLD_ATSC110:
 		dev->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
 					       &dev->i2c_adap);
-		if (dev->dvb.frontend) {
+		if (dev->dvb.frontend)
 			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
 				   &dev->i2c_adap, 0x61,
 				   TUNER_PHILIPS_TUV1236D);
-		}
 		break;
 	case SAA7134_BOARD_FLYDVBS_LR300:
 		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
@@ -1138,10 +1167,12 @@ static int dvb_init(struct saa7134_dev *dev)
 			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
 				       &dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
+				goto dettach_frontend;
 			}
 			if (dvb_attach(isl6421_attach, dev->dvb.frontend,
 				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: No ISL6421 found!\n", __func__);
+				goto dettach_frontend;
 			}
 		}
 		break;
@@ -1168,43 +1199,65 @@ static int dvb_init(struct saa7134_dev *dev)
 		}
 		break;
 	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
-		configure_tda827x_fe(dev, &cinergy_ht_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &cinergy_ht_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_CINERGY_HT_PCI:
-		configure_tda827x_fe(dev, &cinergy_ht_pci_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &cinergy_ht_pci_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_TIGER_S:
-		configure_tda827x_fe(dev, &philips_tiger_s_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_ASUS_P7131_4871:
-		configure_tda827x_fe(dev, &asus_p7131_4871_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &asus_p7131_4871_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
-		configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
-		configure_tda827x_fe(dev, &avermedia_super_007_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &avermedia_super_007_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
-		configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config, &tda827x_cfg_2_sw42);
+		if (configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config,
+					 &tda827x_cfg_2_sw42) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_PHILIPS_SNAKE:
 		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
 						&dev->i2c_adap);
 		if (dev->dvb.frontend) {
 			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
-					&dev->i2c_adap, 0) == NULL)
+					&dev->i2c_adap, 0) == NULL) {
 				wprintk("%s: No tda826x found!\n", __func__);
+				goto dettach_frontend;
+			}
 			if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
-					&dev->i2c_adap, 0, 0) == NULL)
+					&dev->i2c_adap, 0, 0) == NULL) {
 				wprintk("%s: No lnbp21 found!\n", __func__);
+				goto dettach_frontend;
+			}
 		}
 		break;
 	case SAA7134_BOARD_CREATIX_CTX953:
-		configure_tda827x_fe(dev, &md8800_dvbt_config, &tda827x_cfg_0);
+		if (configure_tda827x_fe(dev, &md8800_dvbt_config,
+					 &tda827x_cfg_0) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
-		configure_tda827x_fe(dev, &philips_tiger_s_config, &tda827x_cfg_2);
+		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
+					 &tda827x_cfg_2) < 0)
+			goto dettach_frontend;
 		break;
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 		dev->dvb.frontend = dvb_attach(mt352_attach,
@@ -1218,16 +1271,20 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (dev->dvb.frontend) {
 			struct dvb_frontend *fe;
 			if (dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x60,
-				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL)
+				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no SD1878 "
 					"found !\n", __func__);
+				goto dettach_frontend;
+			}
 			/* we need to open the i2c gate (we know it exists) */
 			fe = dev->dvb.frontend;
 			fe->ops.i2c_gate_ctrl(fe, 1);
 			if (dvb_attach(isl6405_attach, fe,
-					&dev->i2c_adap, 0x08, 0, 0) == NULL)
+					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
 				wprintk("%s: MD7134 DVB-S, no ISL6405 "
 					"found !\n", __func__);
+				goto dettach_frontend;
+			}
 			fe->ops.i2c_gate_ctrl(fe, 0);
 			dev->original_set_voltage = fe->ops.set_voltage;
 			fe->ops.set_voltage = md8800_set_voltage;
@@ -1254,10 +1311,7 @@ static int dvb_init(struct saa7134_dev *dev)
 		if (!fe) {
 			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
 			       dev->name);
-			dvb_frontend_detach(dev->dvb.frontend);
-			dvb_unregister_frontend(dev->dvb.frontend);
-			dev->dvb.frontend = NULL;
-			return -1;
+			goto dettach_frontend;
 		}
 	}
 
@@ -1282,6 +1336,13 @@ static int dvb_init(struct saa7134_dev *dev)
 			dev->dvb.frontend->ops.tuner_ops.sleep(dev->dvb.frontend);
 	}
 	return ret;
+
+dettach_frontend:
+	dvb_unregister_frontend(dev->dvb.frontend);
+	dvb_frontend_detach(dev->dvb.frontend);
+	dev->dvb.frontend = NULL;
+
+	return -1;
 }
 
 static int dvb_fini(struct saa7134_dev *dev)
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 6bf104e..ab7cd45 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -40,11 +40,11 @@
 	typeof(&FUNCTION) __a = symbol_request(FUNCTION); \
 	if (__a) { \
 		__r = (int) __a(ARGS); \
+		symbol_put(FUNCTION); \
 	} else { \
 		printk(KERN_ERR "TUNER: Unable to find " \
 				"symbol "#FUNCTION"()\n"); \
 	} \
-	symbol_put(FUNCTION); \
 	__r; \
 })
 
@@ -340,16 +340,6 @@ static void tuner_i2c_address_check(struct tuner *t)
 	tuner_warn("====================== WARNING! ======================\n");
 }
 
-static void attach_tda829x(struct tuner *t)
-{
-	struct tda829x_config cfg = {
-		.lna_cfg        = t->config,
-		.tuner_callback = t->tuner_callback,
-	};
-	dvb_attach(tda829x_attach,
-		   &t->fe, t->i2c->adapter, t->i2c->addr, &cfg);
-}
-
 static struct xc5000_config xc5000_cfg;
 
 static void set_type(struct i2c_client *c, unsigned int type,
@@ -385,12 +375,19 @@ static void set_type(struct i2c_client *c, unsigned int type,
 
 	switch (t->type) {
 	case TUNER_MT2032:
-		dvb_attach(microtune_attach,
-			   &t->fe, t->i2c->adapter, t->i2c->addr);
+		if (!dvb_attach(microtune_attach,
+			   &t->fe, t->i2c->adapter, t->i2c->addr))
+			goto attach_failed;
 		break;
 	case TUNER_PHILIPS_TDA8290:
 	{
-		attach_tda829x(t);
+		struct tda829x_config cfg = {
+			.lna_cfg        = t->config,
+			.tuner_callback = t->tuner_callback,
+		};
+		if (!dvb_attach(tda829x_attach, &t->fe, t->i2c->adapter,
+				t->i2c->addr, &cfg))
+			goto attach_failed;
 		break;
 	}
 	case TUNER_TEA5767:
@@ -441,8 +438,9 @@ static void set_type(struct i2c_client *c, unsigned int type,
 		break;
 	}
 	case TUNER_TDA9887:
-		dvb_attach(tda9887_attach,
-			   &t->fe, t->i2c->adapter, t->i2c->addr);
+		if (!dvb_attach(tda9887_attach,
+			   &t->fe, t->i2c->adapter, t->i2c->addr))
+			goto attach_failed;
 		break;
 	case TUNER_XC5000:
 	{
@@ -1181,7 +1179,7 @@ static int tuner_probe(struct i2c_client *client,
 		case 0x60:
 			if (tuner_symbol_probe(tea5767_autodetection,
 					       t->i2c->adapter, t->i2c->addr)
-					!= EINVAL) {
+					!= -EINVAL) {
 				t->type = TUNER_TEA5767;
 				t->mode_mask = T_RADIO;
 				t->mode = T_STANDBY;


