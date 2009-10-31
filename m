Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbZJaJnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbZJaJnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZJaJng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:43:36 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757371AbZJaJl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=c5HOMA5FcS8vBng3vKrTxQNVp3QJr7s4yH040wtUsNdfUm1OzMKlK9xTfM4v/jmsa/
         mIwLGepKLKDL4fSinFR+3PApy83W8OKv1N82ghNkS7PtmcRvS6LNlUMAtf5IOnhF2Nl3
         5T9HFx0cOM94tgNSJWnPFWDYRkg2u+gBvTS/Y=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:13 -0200
Message-ID: <b8bf37780910310241j18f6a97do4b35e418c1c5781b@mail.gmail.com>
Subject: [PATCH 07/16] trivial: fix assorted "default" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 74388405ad7362b5db87b82790be5b2d719153b3 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 06:48:13 -0200
Subject: [PATCH 07/16] trivial: fix assorted "default" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c
b/drivers/gpu/drm/i915/intel_sdvo.c
index 083bec2..e7fa327 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2726,7 +2726,7 @@ bool intel_sdvo_init(struct drm_device *dev, int
output_device)
 	/* Wrap with our custom algo which switches to DDC mode */
 	intel_output->ddc_bus->algo = &intel_sdvo_i2c_bit_algo;

-	/* In defaut case sdvo lvds is false */
+	/* In default case sdvo lvds is false */
 	intel_sdvo_get_capabilities(intel_output, &sdvo_priv->caps);

 	if (intel_sdvo_output_setup(intel_output,
diff --git a/drivers/media/dvb/frontends/cx24110.c
b/drivers/media/dvb/frontends/cx24110.c
index ffbcfab..00a4e8f 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -1,4 +1,4 @@
-	/*
+/*
     cx24110 - Single Chip Satellite Channel Receiver driver module

     Copyright (C) 2002 Peter Hettkamp <peter.hettkamp@htp-tel.de> based on
@@ -96,7 +96,7 @@ static struct {u8 reg; u8 data;} cx24110_regdata[]=
 	 {0x42,0x00}, /* @ middle bytes " */
 	 {0x43,0x00}, /* @ LSB          " */
 		      /* leave the carrier tracking loop parameters on default */
-		      /* leave the bit timing loop parameters at gefault */
+		      /* leave the bit timing loop parameters at default */
 	 {0x56,0x4d}, /* set the filtune voltage to 2.7V, as recommended by */
 		      /* the cx24108 data sheet for symbol rates above 15MS/s */
 	 {0x57,0x00}, /* @ Filter sigma delta enabled, positive */
diff --git a/drivers/net/wireless/prism54/isl_ioctl.c
b/drivers/net/wireless/prism54/isl_ioctl.c
index cf91990..f7f5c79 100644
--- a/drivers/net/wireless/prism54/isl_ioctl.c
+++ b/drivers/net/wireless/prism54/isl_ioctl.c
@@ -1897,7 +1897,7 @@ prism54_get_mac(struct net_device *ndev, struct
iw_request_info *info,
 	return 0;
 }

-/* Setting policy also clears the MAC acl, even if we don't change the defaut
+/* Setting policy also clears the MAC acl, even if we don't change the default
  * policy
  */

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h
b/drivers/net/wireless/rt2x00/rt2400pci.h
index ccd6441..aced057 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.h
+++ b/drivers/net/wireless/rt2x00/rt2400pci.h
@@ -35,7 +35,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		100

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h
b/drivers/net/wireless/rt2x00/rt2500pci.h
index 54d3795..3db9041 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.h
+++ b/drivers/net/wireless/rt2x00/rt2500pci.h
@@ -46,7 +46,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		121

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.h
b/drivers/net/wireless/rt2x00/rt2500usb.h
index b01edca..d300082 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.h
+++ b/drivers/net/wireless/rt2x00/rt2500usb.h
@@ -46,7 +46,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.h
b/drivers/net/wireless/rt2x00/rt2800usb.h
index 2344571..4cc7026 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/rt2x00/rt2800usb.h
@@ -61,7 +61,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120 /* FIXME */

diff --git a/drivers/net/wireless/rt2x00/rt61pci.h
b/drivers/net/wireless/rt2x00/rt61pci.h
index 93eb699..77b5116 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.h
+++ b/drivers/net/wireless/rt2x00/rt61pci.h
@@ -37,7 +37,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120

diff --git a/drivers/net/wireless/rt2x00/rt73usb.h
b/drivers/net/wireless/rt2x00/rt73usb.h
index 81fe0be..e194332 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.h
+++ b/drivers/net/wireless/rt2x00/rt73usb.h
@@ -37,7 +37,7 @@

 /*
  * Signal information.
- * Defaul offset is required for RSSI <-> dBm conversion.
+ * Default offset is required for RSSI <-> dBm conversion.
  */
 #define DEFAULT_RSSI_OFFSET		120

diff --git a/drivers/staging/comedi/drivers/pcl816.c
b/drivers/staging/comedi/drivers/pcl816.c
index 666be53..d7c0fde 100644
--- a/drivers/staging/comedi/drivers/pcl816.c
+++ b/drivers/staging/comedi/drivers/pcl816.c
@@ -112,7 +112,7 @@ struct pcl816_board {
 	int n_dichan;		/*  num of DI chans */
 	int n_dochan;		/*  num of DO chans */
 	const struct comedi_lrange *ai_range_type;	/*  default A/D rangelist */
-	const struct comedi_lrange *ao_range_type;	/*  dafault D/A rangelist */
+	const struct comedi_lrange *ao_range_type;	/*  default D/A rangelist */
 	unsigned int io_range;	/*  len of IO space */
 	unsigned int IRQbits;	/*  allowed interrupts */
 	unsigned int DMAbits;	/*  allowed DMA chans */
diff --git a/drivers/staging/rt2860/common/rtmp_init.c
b/drivers/staging/rt2860/common/rtmp_init.c
index 0e10e23..1b93945 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -3344,7 +3344,7 @@ VOID	UserCfgInit(
 	pAd->CommonCfg.TxPower = 100; //mW
 	pAd->CommonCfg.TxPowerPercentage = 0xffffffff; // AUTO
 	pAd->CommonCfg.TxPowerDefault = 0xffffffff; // AUTO
-	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by defaut
+	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by default
 	pAd->CommonCfg.bUseZeroToDisableFragment = FALSE;
 	pAd->CommonCfg.RtsThreshold = 2347;
 	pAd->CommonCfg.FragmentThreshold = 2346;
diff --git a/drivers/staging/rt3090/common/rtmp_init.c
b/drivers/staging/rt3090/common/rtmp_init.c
index 04b54fc..9c18528 100644
--- a/drivers/staging/rt3090/common/rtmp_init.c
+++ b/drivers/staging/rt3090/common/rtmp_init.c
@@ -2677,7 +2677,7 @@ VOID	UserCfgInit(
 	pAd->CommonCfg.TxPower = 100; //mW
 	pAd->CommonCfg.TxPowerPercentage = 0xffffffff; // AUTO
 	pAd->CommonCfg.TxPowerDefault = 0xffffffff; // AUTO
-	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by defaut
+	pAd->CommonCfg.TxPreamble = Rt802_11PreambleAuto; // use Long
preamble on TX by default
 	pAd->CommonCfg.bUseZeroToDisableFragment = FALSE;
 	pAd->CommonCfg.RtsThreshold = 2347;
 	pAd->CommonCfg.FragmentThreshold = 2346;
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 16256a3..54ce8d7 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -164,7 +164,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //defalt support hw security. //use
module_param instead.
+	//ieee->hwsec_support = 1; //default support hw security. //use
module_param instead.
 	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.

 	ieee80211_softmac_init(ieee);
diff --git a/drivers/staging/rtl8192e/r8192E_core.c
b/drivers/staging/rtl8192e/r8192E_core.c
index b0802a7..ff8fe7e 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -1041,7 +1041,7 @@ static void rtl8192_tx_isr(struct net_device
*dev, int prio)
         tx_desc_819x_pci *entry = &ring->desc[ring->idx];
         struct sk_buff *skb;

-        /* beacon packet will only use the first descriptor defautly,
+        /* beacon packet will only use the first descriptor defaultly,
          * and the OWN may not be cleared by the hardware
          * */
         if(prio != BEACON_QUEUE) {
@@ -2562,7 +2562,7 @@ static void rtl8192_read_eeprom_info(struct
net_device* dev)
 		priv->bTXPowerDataReadFromEEPORM = false;
 	}

-	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE dafault=1T2R
+	// 2007/11/15 MH 8190PCI Default=2T4R, 8192PCIE default=1T2R
 	priv->rf_type = RTL819X_DEFAULT_RF_TYPE;

 	if(priv->card_8192_version > VERSION_8190_BD)
@@ -3554,7 +3554,7 @@ void rtl8192_prepare_beacon(struct r8192_priv *priv)
 	//spin_lock_irqsave(&priv->tx_lock,flags);
 	/* prepare misc info for the beacon xmit */
 	tcb_desc->queue_index = BEACON_QUEUE;
-	/* IBSS does not support HT yet, use 1M defautly */
+	/* IBSS does not support HT yet, use 1M defaultly */
 	tcb_desc->data_rate = 2;
 	tcb_desc->RATRIndex = 7;
 	tcb_desc->bTxDisableRateFallBack = 1;
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
index 68dc8fa..a764476 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
@@ -156,7 +156,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
  	ieee->privacy_invoked = 0;
  	ieee->ieee802_1x = 1;
 	ieee->raw_tx = 0;
-	//ieee->hwsec_support = 1; //defalt support hw security. //use
module_param instead.
+	//ieee->hwsec_support = 1; //default support hw security. //use
module_param instead.
 	ieee->hwsec_active = 0; //disable hwsec, switch it on when necessary.

 	ieee80211_softmac_init(ieee);
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c
b/drivers/staging/serqt_usb2/serqt_usb2.c
index 52af44c..060e9de 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -929,7 +929,7 @@ static int qt_open(struct tty_struct *tty,
 	dbg(__FILE__ "qt_setuart completed.\n");

 	/*
-	 * Put this here to make it responsive to stty and defauls set by
+	 * Put this here to make it responsive to stty and defaults set by
 	 * the tty layer
 	 */
 	/* FIXME: is this needed? */
diff --git a/drivers/video/backlight/atmel-pwm-bl.c
b/drivers/video/backlight/atmel-pwm-bl.c
index 505c082..2cf7ba5 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -158,7 +158,7 @@ static int atmel_pwm_bl_probe(struct platform_device *pdev)
 			goto err_free_pwm;
 		}

-		/* Turn display off by defatult. */
+		/* Turn display off by default. */
 		retval = gpio_direction_output(pwmbl->gpio_on,
 				0 ^ pdata->on_active_low);
 		if (retval)
diff --git a/drivers/video/backlight/tosa_lcd.c
b/drivers/video/backlight/tosa_lcd.c
index 50ec17d..fa32b94 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -177,7 +177,7 @@ static int __devinit tosa_lcd_probe(struct spi_device *spi)
 	if (!data)
 		return -ENOMEM;

-	data->is_vga = true; /* defaut to VGA mode */
+	data->is_vga = true; /* default to VGA mode */

 	/*
 	 * bits_per_word cannot be configured in platform data
diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 381026c..923cc68 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -508,7 +508,7 @@ void coh901327_watchdog_reset(void)
 	 * deactivating the watchdog before it is shut down by it.
 	 *
 	 * NOTE: on future versions of the watchdog, this restriction is
-	 * gone: the watchdog will be reloaded with a defaul value (1 min)
+	 * gone: the watchdog will be reloaded with a default value (1 min)
 	 * instead of last value, and you can conveniently set the watchdog
 	 * timeout to 10ms (value = 1) without any problems.
 	 */
diff --git a/sound/pci/hda/patch_cmedia.c b/sound/pci/hda/patch_cmedia.c
index 780e1a7..8917071 100644
--- a/sound/pci/hda/patch_cmedia.c
+++ b/sound/pci/hda/patch_cmedia.c
@@ -66,7 +66,7 @@ struct cmi_spec {

 	struct hda_pcm pcm_rec[2];	/* PCM information */

-	/* pin deafault configuration */
+	/* pin default configuration */
 	hda_nid_t pin_nid[NUM_PINS];
 	unsigned int def_conf[NUM_PINS];
 	unsigned int pin_def_confs;
-- 
1.6.5.2.101.gcd0f8
