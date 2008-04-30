Return-Path: <linux-kernel-owner+w=401wt.eu-S1760502AbYD3Ps1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760502AbYD3Ps1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbYD3PsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:48:19 -0400
Received: from mail.gmx.net ([213.165.64.20]:48983 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757641AbYD3PsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:48:17 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19riQlTy2BrTepWjMBX2kla4f5oICQH6Qfjeab2is
	JF2k3ayDb6uiuC
Subject: Re: [patch, -git] drivers/media build fix for modular builds
From: Mike Galbraith <efault@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20080430122514.2a52942d@gaivota>
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
Content-Type: text/plain
Date: Wed, 30 Apr 2008 17:48:10 +0200
Message-Id: <1209570490.5157.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-30 at 12:25 -0300, Mauro Carvalho Chehab wrote:

> Please try this patch. It should avoid an OOPS, if attach fails.

Different oops.

[   12.902828] saa7130/34: v4l2 driver version 0.2.14 loaded
[   12.912627] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   12.924485] saa7133[0]: found at 0000:02:00.0, rev: 209, irq: 16, latency: 84, mmio: 0xfddff000
[   12.937653] saa7133[0]: subsystem: 16be:000d, board: Medion Md8800 Quadro [card=96,autodetected]
[   12.950974] saa7133[0]: board init: gpio is 0
[   13.114915] saa7133[0]: i2c eeprom 00: be 16 0d 00 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
[   13.127996] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff 00 01 50 32 79 01 3c ca 50
[   13.141256] saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 01 00 06 ff 00 29 02 51 96 2b
[   13.155298] saa7133[0]: i2c eeprom 30: a7 58 7a 1f 03 8e 84 5e da 7a 04 b3 05 87 b2 3c
[   13.169896] saa7133[0]: i2c eeprom 40: ff 28 00 c0 96 10 03 00 c0 1c fd 79 44 9f c2 8f
[   13.185133] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189136] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189140] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189144] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189148] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189151] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189155] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189159] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189163] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189167] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.189171] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.424687] TUNER: Unable to find symbol tda829x_probe()
[   13.432752] tuner' 1-004b: chip found @ 0x96 (saa7133[0])
[   13.445868] DVB: Unable to find symbol tda9887_attach()
[   13.463549] saa7133[0]: registered device video0 [v4l2]
[   13.471373] saa7133[0]: registered device vbi0
[   13.522538] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0010dc000152c873]
[   13.574255] DVB: Unable to find symbol tda827x_attach()
[   13.582130] saa7133[0]/dvb: no tda827x tuner found at addr: 60
[   13.590603] BUG: unable to handle kernel NULL pointer dereference at 0000000000000200
[   13.598702] IP: [<ffffffffa02e0d6b>] :dvb_core:dvb_frontend_stop+0x2e/0x85
[   13.610533] PGD 37434067 PUD 37404067 PMD 0 
[   13.614703] Oops: 0002 [1] SMP 
[   13.622704] CPU 0 
[   13.626704] Modules linked in: tda1004x saa7134_dvb(+) videobuf_dvb dvb_core tuner saa7134 snd_hda_intel compat_ioctl32 firewire_ohci videodev firewire_core v4l1_compat v4l2_common crc_itu_t snd_pcm videobuf_dma_sg usb_storage videobuf_core usbhid snd_timer ir_kbd_i2c ohci1394 snd_page_alloc e1000e ir_common snd_hwdep rtc_cmos snd sr_mod hid ieee1394 rtc_core tveeprom iTCO_wdt cdrom serio_raw i2c_i801 ff_memless rtc_lib sg soundcore intel_agp i2c_core iTCO_vendor_support button ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[   13.694708] Pid: 2198, comm: modprobe Not tainted 2.6.26-smp #5
[   13.702709] RIP: 0010:[<ffffffffa02e0d6b>]  [<ffffffffa02e0d6b>] :dvb_core:dvb_frontend_stop+0x2e/0x85
[   13.718710] RSP: 0018:ffff8100bd143c98  EFLAGS: 00010246
[   13.729659] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffffa02fb044
[   13.738711] RDX: 0000000000001bb4 RSI: ffff8100bd142010 RDI: ffff8100bd1bd410
[   13.750712] RBP: ffff8100bd143ca8 R08: ffff8100bd143cd8 R09: ffff8100bd9a2000
[   13.762542] R10: ffff8100bd143a68 R11: ffff810037855760 R12: 0000000000000000
[   13.770713] R13: ffffffffa02f9580 R14: ffff8100bd9a2170 R15: ffffc20010300e00
[   13.782714] FS:  00007f2cb80d16f0(0000) GS:ffffffff8055d000(0000) knlGS:0000000000000000
[   13.794715] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   13.806545] CR2: 0000000000000200 CR3: 00000000bd15f000 CR4: 00000000000006e0
[   13.817664] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   13.826717] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   13.838718] Process modprobe (pid: 2198, threadinfo ffff8100bd142000, task ffff8100be824260)
[   13.850718] Stack:  ffff8100bd1bd410 ffff8100bd1bd410 ffff8100bd143cf8 ffffffffa02e1f5b
[   13.862719]  ffff8100bd143cd8 ffffffff802562d4 ffff8100bd143cd8 ffffffffa02fb034
[   13.874720]  ffff8100bd143cf8 ffffffffa02e09b5 ffff8100bd9a2000 ffff8100bd9a2000
[   13.882720] Call Trace:
[   13.894721]  [<ffffffffa02e1f5b>] :dvb_core:dvb_unregister_frontend+0x47/0xf9
[   13.906722]  [<ffffffff802562d4>] ? symbol_put_addr+0x2e/0x33
[   13.914722]  [<ffffffffa02fb034>] ? :tda1004x:tda1004x_release+0x0/0x12
[   13.926723]  [<ffffffffa02e09b5>] ? :dvb_core:dvb_frontend_detach+0x7d/0x82
[   13.938724]  [<ffffffffa02f59f6>] :saa7134_dvb:dvb_init+0x14b3/0x1603
[   13.946724]  [<ffffffff80270d2e>] ? get_pageblock_migratetype+0x1b/0x1d
[   13.958725]  [<ffffffff8028c92e>] ? virt_to_head_page+0x31/0x41
[   13.970555]  [<ffffffffa02abefa>] :saa7134:mpeg_ops_attach+0x36/0x46
[   13.978726]  [<ffffffffa02aced9>] :saa7134:saa7134_ts_register+0x2a/0x73
[   13.990727]  [<ffffffffa00e1010>] :saa7134_dvb:dvb_register+0x10/0x12
[   14.001676]  [<ffffffff80256170>] sys_init_module+0x18be/0x19f4
[   14.010728]  [<ffffffff8023d1e4>] ? msleep+0x0/0x1e
[   14.018729]  [<ffffffff80290142>] ? vfs_read+0xa8/0x102
[   14.026729]  [<ffffffff8020c18b>] system_call_after_swapgs+0x7b/0x80
[   14.038559] 
[   14.042730] 
[   14.046731] Code: e5 53 48 83 ec 08 83 3d fb ef 00 00 00 48 8b 9f d8 02 00 00 74 15 48 c7 c6 50 4d 2e a0 48 c7 c7 12 6b 2e a0 31 c0 e8 36 42 f5 df <c7> 83 00 02 00 00 01 00 00 00 0f ae f0 48 8b bb f0 01 00 00 48 
[   14.077681] RIP  [<ffffffffa02e0d6b>] :dvb_core:dvb_frontend_stop+0x2e/0x85
[   14.086733]  RSP <ffff8100bd143c98>
[   14.094734] CR2: 0000000000000200
[   14.101895] ---[ end trace ebf2e3676b0ceae9 ]---

> Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
> 
> diff -r 341e0cd5c1a4 linux/drivers/media/video/saa7134/saa7134-dvb.c
> --- a/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Apr 30 11:40:17 2008 +0000
> +++ b/linux/drivers/media/video/saa7134/saa7134-dvb.c	Wed Apr 30 12:16:38 2008 -0300
> @@ -541,19 +541,23 @@
>  	return 0;
>  }
>  
> -static void configure_tda827x_fe(struct saa7134_dev *dev, struct tda1004x_config *cdec_conf,
> -							  struct tda827x_config *tuner_conf)
> +static int configure_tda827x_fe(struct saa7134_dev *dev,
> +				struct tda1004x_config *cdec_conf,
> +				struct tda827x_config *tuner_conf)
>  {
>  	dev->dvb.frontend = dvb_attach(tda10046_attach, cdec_conf, &dev->i2c_adap);
>  	if (dev->dvb.frontend) {
>  		if (cdec_conf->i2c_gate)
>  			dev->dvb.frontend->ops.i2c_gate_ctrl = tda8290_i2c_gate_ctrl;
> -		if (dvb_attach(tda827x_attach, dev->dvb.frontend, cdec_conf->tuner_address,
> -							&dev->i2c_adap, tuner_conf) == NULL) {
> -			wprintk("no tda827x tuner found at addr: %02x\n",
> +		if (dvb_attach(tda827x_attach, dev->dvb.frontend,
> +			       cdec_conf->tuner_address,
> +			       &dev->i2c_adap, tuner_conf))
> +			return 0;
> +
> +		wprintk("no tda827x tuner found at addr: %02x\n",
>  				cdec_conf->tuner_address);
> -		}
>  	}
> +	return -EINVAL;
>  }
>  
>  /* ------------------------------------------------------------------ */
> @@ -1000,7 +1004,9 @@
>  		break;
>  	case SAA7134_BOARD_FLYDVBTDUO:
>  	case SAA7134_BOARD_FLYDVBT_DUO_CARDBUS:
> -		configure_tda827x_fe(dev, &tda827x_lifeview_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_EUROPA:
>  	case SAA7134_BOARD_VIDEOMATE_DVBT_300:
> @@ -1025,36 +1031,52 @@
>  		}
>  		break;
>  	case SAA7134_BOARD_KWORLD_DVBT_210:
> -		configure_tda827x_fe(dev, &kworld_dvb_t_210_config, &tda827x_cfg_2);
> +		if (configure_tda827x_fe(dev, &kworld_dvb_t_210_config,
> +					 &tda827x_cfg_2) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_TIGER:
> -		configure_tda827x_fe(dev, &philips_tiger_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &philips_tiger_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PINNACLE_PCTV_310i:
> -		configure_tda827x_fe(dev, &pinnacle_pctv_310i_config, &tda827x_cfg_1);
> +		if (configure_tda827x_fe(dev, &pinnacle_pctv_310i_config,
> +					 &tda827x_cfg_1) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_HAUPPAUGE_HVR1110:
> -		configure_tda827x_fe(dev, &hauppauge_hvr_1110_config, &tda827x_cfg_1);
> +		if (configure_tda827x_fe(dev, &hauppauge_hvr_1110_config,
> +					 &tda827x_cfg_1) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_ASUSTeK_P7131_DUAL:
> -		configure_tda827x_fe(dev, &asus_p7131_dual_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &asus_p7131_dual_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_FLYDVBT_LR301:
> -		configure_tda827x_fe(dev, &tda827x_lifeview_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &tda827x_lifeview_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_FLYDVB_TRIO:
> -		if(! use_frontend) {	/* terrestrial */
> -			configure_tda827x_fe(dev, &lifeview_trio_config, &tda827x_cfg_0);
> +		if (!use_frontend) {	/* terrestrial */
> +			if (configure_tda827x_fe(dev, &lifeview_trio_config,
> +						 &tda827x_cfg_0) < 0)
> +				goto dettach_frontend;
>  		} else {  		/* satellite */
>  			dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs, &dev->i2c_adap);
>  			if (dev->dvb.frontend) {
>  				if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x63,
>  									&dev->i2c_adap, 0) == NULL) {
>  					wprintk("%s: Lifeview Trio, No tda826x found!\n", __func__);
> +					goto dettach_frontend;
>  				}
>  				if (dvb_attach(isl6421_attach, dev->dvb.frontend, &dev->i2c_adap,
>  										0x08, 0, 0) == NULL) {
>  					wprintk("%s: Lifeview Trio, No ISL6421 found!\n", __func__);
> +					goto dettach_frontend;
>  				}
>  			}
>  		}
> @@ -1070,15 +1092,20 @@
>  								&ads_duo_cfg) == NULL) {
>  				wprintk("no tda827x tuner found at addr: %02x\n",
>  					ads_tech_duo_config.tuner_address);
> +				goto dettach_frontend;
>  			}
>  		}
>  		break;
>  	case SAA7134_BOARD_TEVION_DVBT_220RF:
> -		configure_tda827x_fe(dev, &tevion_dvbt220rf_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &tevion_dvbt220rf_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_MEDION_MD8800_QUADRO:
>  		if (!use_frontend) {     /* terrestrial */
> -			configure_tda827x_fe(dev, &md8800_dvbt_config, &tda827x_cfg_0);
> +			if (configure_tda827x_fe(dev, &md8800_dvbt_config,
> +						 &tda827x_cfg_0) < 0)
> +				goto dettach_frontend;
>  		} else {        /* satellite */
>  			dev->dvb.frontend = dvb_attach(tda10086_attach,
>  							&flydvbs, &dev->i2c_adap);
> @@ -1089,16 +1116,20 @@
>  				struct i2c_msg msg = {.addr = 0x08, .flags = 0, .len = 1};
>  
>  				if (dvb_attach(tda826x_attach, dev->dvb.frontend,
> -						0x60, &dev->i2c_adap, 0) == NULL)
> +						0x60, &dev->i2c_adap, 0) == NULL) {
>  					wprintk("%s: Medion Quadro, no tda826x "
>  						"found !\n", __func__);
> +					goto dettach_frontend;
> +				}
>  				if (dev_id != 0x08) {
>  					/* we need to open the i2c gate (we know it exists) */
>  					fe->ops.i2c_gate_ctrl(fe, 1);
>  					if (dvb_attach(isl6405_attach, fe,
> -							&dev->i2c_adap, 0x08, 0, 0) == NULL)
> +							&dev->i2c_adap, 0x08, 0, 0) == NULL) {
>  						wprintk("%s: Medion Quadro, no ISL6405 "
>  							"found !\n", __func__);
> +						goto dettach_frontend;
> +					}
>  					if (dev_id == 0x07) {
>  						/* fire up the 2nd section of the LNB supply since
>  						   we can't do this from the other section */
> @@ -1120,19 +1151,17 @@
>  	case SAA7134_BOARD_AVERMEDIA_AVERTVHD_A180:
>  		dev->dvb.frontend = dvb_attach(nxt200x_attach, &avertvhda180,
>  					       &dev->i2c_adap);
> -		if (dev->dvb.frontend) {
> +		if (dev->dvb.frontend)
>  			dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x61,
>  				   NULL, DVB_PLL_TDHU2);
> -		}
>  		break;
>  	case SAA7134_BOARD_KWORLD_ATSC110:
>  		dev->dvb.frontend = dvb_attach(nxt200x_attach, &kworldatsc110,
>  					       &dev->i2c_adap);
> -		if (dev->dvb.frontend) {
> +		if (dev->dvb.frontend)
>  			dvb_attach(simple_tuner_attach, dev->dvb.frontend,
>  				   &dev->i2c_adap, 0x61,
>  				   TUNER_PHILIPS_TUV1236D);
> -		}
>  		break;
>  	case SAA7134_BOARD_FLYDVBS_LR300:
>  		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
> @@ -1141,10 +1170,12 @@
>  			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
>  				       &dev->i2c_adap, 0) == NULL) {
>  				wprintk("%s: No tda826x found!\n", __func__);
> +				goto dettach_frontend;
>  			}
>  			if (dvb_attach(isl6421_attach, dev->dvb.frontend,
>  				       &dev->i2c_adap, 0x08, 0, 0) == NULL) {
>  				wprintk("%s: No ISL6421 found!\n", __func__);
> +				goto dettach_frontend;
>  			}
>  		}
>  		break;
> @@ -1171,43 +1202,65 @@
>  		}
>  		break;
>  	case SAA7134_BOARD_CINERGY_HT_PCMCIA:
> -		configure_tda827x_fe(dev, &cinergy_ht_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &cinergy_ht_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_CINERGY_HT_PCI:
> -		configure_tda827x_fe(dev, &cinergy_ht_pci_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &cinergy_ht_pci_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_TIGER_S:
> -		configure_tda827x_fe(dev, &philips_tiger_s_config, &tda827x_cfg_2);
> +		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
> +					 &tda827x_cfg_2) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_ASUS_P7131_4871:
> -		configure_tda827x_fe(dev, &asus_p7131_4871_config, &tda827x_cfg_2);
> +		if (configure_tda827x_fe(dev, &asus_p7131_4871_config,
> +					 &tda827x_cfg_2) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
> -		configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config, &tda827x_cfg_2);
> +		if (configure_tda827x_fe(dev, &asus_p7131_hybrid_lna_config,
> +					 &tda827x_cfg_2) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_SUPER_007:
> -		configure_tda827x_fe(dev, &avermedia_super_007_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &avermedia_super_007_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_TWINHAN_DTV_DVB_3056:
> -		configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config, &tda827x_cfg_2_sw42);
> +		if (configure_tda827x_fe(dev, &twinhan_dtv_dvb_3056_config,
> +					 &tda827x_cfg_2_sw42) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_PHILIPS_SNAKE:
>  		dev->dvb.frontend = dvb_attach(tda10086_attach, &flydvbs,
>  						&dev->i2c_adap);
>  		if (dev->dvb.frontend) {
>  			if (dvb_attach(tda826x_attach, dev->dvb.frontend, 0x60,
> -					&dev->i2c_adap, 0) == NULL)
> +					&dev->i2c_adap, 0) == NULL) {
>  				wprintk("%s: No tda826x found!\n", __func__);
> +				goto dettach_frontend;
> +			}
>  			if (dvb_attach(lnbp21_attach, dev->dvb.frontend,
> -					&dev->i2c_adap, 0, 0) == NULL)
> +					&dev->i2c_adap, 0, 0) == NULL) {
>  				wprintk("%s: No lnbp21 found!\n", __func__);
> +				goto dettach_frontend;
> +			}
>  		}
>  		break;
>  	case SAA7134_BOARD_CREATIX_CTX953:
> -		configure_tda827x_fe(dev, &md8800_dvbt_config, &tda827x_cfg_0);
> +		if (configure_tda827x_fe(dev, &md8800_dvbt_config,
> +					 &tda827x_cfg_0) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_MSI_TVANYWHERE_AD11:
> -		configure_tda827x_fe(dev, &philips_tiger_s_config, &tda827x_cfg_2);
> +		if (configure_tda827x_fe(dev, &philips_tiger_s_config,
> +					 &tda827x_cfg_2) < 0)
> +			goto dettach_frontend;
>  		break;
>  	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
>  #if 0
> @@ -1225,16 +1278,20 @@
>  		if (dev->dvb.frontend) {
>  			struct dvb_frontend *fe;
>  			if (dvb_attach(dvb_pll_attach, dev->dvb.frontend, 0x60,
> -				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL)
> +				  &dev->i2c_adap, DVB_PLL_PHILIPS_SD1878_TDA8261) == NULL) {
>  				wprintk("%s: MD7134 DVB-S, no SD1878 "
>  					"found !\n", __func__);
> +				goto dettach_frontend;
> +			}
>  			/* we need to open the i2c gate (we know it exists) */
>  			fe = dev->dvb.frontend;
>  			fe->ops.i2c_gate_ctrl(fe, 1);
>  			if (dvb_attach(isl6405_attach, fe,
> -					&dev->i2c_adap, 0x08, 0, 0) == NULL)
> +					&dev->i2c_adap, 0x08, 0, 0) == NULL) {
>  				wprintk("%s: MD7134 DVB-S, no ISL6405 "
>  					"found !\n", __func__);
> +				goto dettach_frontend;
> +			}
>  			fe->ops.i2c_gate_ctrl(fe, 0);
>  			dev->original_set_voltage = fe->ops.set_voltage;
>  			fe->ops.set_voltage = md8800_set_voltage;
> @@ -1261,10 +1318,7 @@
>  		if (!fe) {
>  			printk(KERN_ERR "%s/2: xc3028 attach failed\n",
>  			       dev->name);
> -			dvb_frontend_detach(dev->dvb.frontend);
> -			dvb_unregister_frontend(dev->dvb.frontend);
> -			dev->dvb.frontend = NULL;
> -			return -1;
> +			goto dettach_frontend;
>  		}
>  	}
>  
> @@ -1289,6 +1343,13 @@
>  			dev->dvb.frontend->ops.tuner_ops.sleep(dev->dvb.frontend);
>  	}
>  	return ret;
> +
> +dettach_frontend:
> +	dvb_frontend_detach(dev->dvb.frontend);
> +	dvb_unregister_frontend(dev->dvb.frontend);
> +	dev->dvb.frontend = NULL;
> +
> +	return -1;
>  }
>  
>  static int dvb_fini(struct saa7134_dev *dev)
> diff -r 341e0cd5c1a4 linux/drivers/media/video/tuner-core.c
> --- a/linux/drivers/media/video/tuner-core.c	Wed Apr 30 11:40:17 2008 +0000
> +++ b/linux/drivers/media/video/tuner-core.c	Wed Apr 30 12:16:38 2008 -0300
> @@ -369,16 +369,6 @@
>  	tuner_warn("====================== WARNING! ======================\n");
>  }
>  
> -static void attach_tda829x(struct tuner *t)
> -{
> -	struct tda829x_config cfg = {
> -		.lna_cfg        = t->config,
> -		.tuner_callback = t->tuner_callback,
> -	};
> -	dvb_attach(tda829x_attach,
> -		   &t->fe, t->i2c->adapter, t->i2c->addr, &cfg);
> -}
> -
>  static struct xc5000_config xc5000_cfg;
>  
>  static void set_type(struct i2c_client *c, unsigned int type,
> @@ -414,12 +404,19 @@
>  
>  	switch (t->type) {
>  	case TUNER_MT2032:
> -		dvb_attach(microtune_attach,
> -			   &t->fe, t->i2c->adapter, t->i2c->addr);
> +		if (!dvb_attach(microtune_attach,
> +			   &t->fe, t->i2c->adapter, t->i2c->addr))
> +			goto attach_failed;
>  		break;
>  	case TUNER_PHILIPS_TDA8290:
>  	{
> -		attach_tda829x(t);
> +		struct tda829x_config cfg = {
> +			.lna_cfg        = t->config,
> +			.tuner_callback = t->tuner_callback,
> +		};
> +		if (!dvb_attach(tda829x_attach, &t->fe, t->i2c->adapter,
> +				t->i2c->addr, &cfg))
> +			goto attach_failed;
>  		break;
>  	}
>  	case TUNER_TEA5767:
> @@ -470,8 +467,9 @@
>  		break;
>  	}
>  	case TUNER_TDA9887:
> -		dvb_attach(tda9887_attach,
> -			   &t->fe, t->i2c->adapter, t->i2c->addr);
> +		if (!dvb_attach(tda9887_attach,
> +			   &t->fe, t->i2c->adapter, t->i2c->addr))
> +			goto attach_failed;
>  		break;
>  	case TUNER_XC5000:
>  	{

