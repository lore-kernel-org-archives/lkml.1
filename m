Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZJaJlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZJaJlP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757497AbZJaJlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:14 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492AbZJaJlE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=qhgG5AjLsjHNBL/bV7p9mr0vJG6RWS4Qz/e83yJk2ujYzrRnT+4WOnf/ZX+++5Ei33
         aQ8vChn/HkCPpD9O9rR9tfuVvnGNcYifLvIk48y8wEAcDmgHLjCGzVg7c9AwgBRVSBca
         bqstaJdIMfEyqhoLiL0hQHvIEy9rMK/0kFMiQ=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:40:49 -0200
Message-ID: <b8bf37780910310240u4aecdf89hb938df7952b572e@mail.gmail.com>
Subject: [PATCH 03/16] trivial: fix assorted "through" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f5d73ba151304056e4f7ea37e515493d1d3df38f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 06:16:07 -0200
Subject: [PATCH 03/16] trivial: fix assorted "through" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
index 446f867..0c7802b 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mx3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mx3.h
@@ -112,7 +112,7 @@ enum iomux_gp_func {
  * setups a single pin:
  * 	- reserves the pin so that it is not claimed by another driver
  * 	- setups the iomux according to the configuration
- * 	- if the pin is configured as a GPIO, we claim it throug kernel gpiolib
+ * 	- if the pin is configured as a GPIO, we claim it through kernel gpiolib
  */
 int mxc_iomux_alloc_pin(const unsigned int pin, const char *label);
 /*
diff --git a/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
b/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
index 9f13061..3887f3f 100644
--- a/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-mxc91231.h
@@ -48,7 +48,7 @@
  * setups a single pin:
  * 	- reserves the pin so that it is not claimed by another driver
  * 	- setups the iomux according to the configuration
- * 	- if the pin is configured as a GPIO, we claim it throug kernel gpiolib
+ * 	- if the pin is configured as a GPIO, we claim it through kernel gpiolib
  */
 int mxc_iomux_alloc_pin(const unsigned int pin_mode, const char *label);
 /*
diff --git a/arch/avr32/boards/hammerhead/Kconfig
b/arch/avr32/boards/hammerhead/Kconfig
index fda2331..5c13d78 100644
--- a/arch/avr32/boards/hammerhead/Kconfig
+++ b/arch/avr32/boards/hammerhead/Kconfig
@@ -24,7 +24,7 @@ config BOARD_HAMMERHEAD_SND
 	bool "Atmel AC97 Sound support"
 	help
 	  This enables Sound support for the Hammerhead board. You may
-	  also go trough the ALSA settings to get it working.
+	  also go through the ALSA settings to get it working.

 	  Choose 'Y' here if you have ordered a Corona daugther board and
 	  want to make your board funky.
diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
index f7b9cdc..b52c1f8 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
@@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)

 #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
 	d_cache = CPLB_L1_CHBL;
-#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
+#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
 	d_cache |= CPLB_L1_AOW | CPLB_WT;
 #endif
 #endif
diff --git a/arch/ia64/ia32/ia32_entry.S b/arch/ia64/ia32/ia32_entry.S
index af9405c..02d1fb7 100644
--- a/arch/ia64/ia32/ia32_entry.S
+++ b/arch/ia64/ia32/ia32_entry.S
@@ -79,7 +79,7 @@ GLOBAL_ENTRY(ia32_ret_from_clone)
 (p6)	br.cond.spnt .ia32_strace_check_retval
 	;;					// prevent RAW on r8
 END(ia32_ret_from_clone)
-	// fall thrugh
+	// fall through
 GLOBAL_ENTRY(ia32_ret_from_syscall)
 	PT_REGS_UNWIND_INFO(0)

diff --git a/arch/mips/math-emu/dp_sub.c b/arch/mips/math-emu/dp_sub.c
index b30c5b1..a2127d6 100644
--- a/arch/mips/math-emu/dp_sub.c
+++ b/arch/mips/math-emu/dp_sub.c
@@ -110,7 +110,7 @@ ieee754dp ieee754dp_sub(ieee754dp x, ieee754dp y)

 	case CLPAIR(IEEE754_CLASS_DNORM, IEEE754_CLASS_DNORM):
 		DPDNORMX;
-		/* FAAL THOROUGH */
+		/* FALL THROUGH */

 	case CLPAIR(IEEE754_CLASS_NORM, IEEE754_CLASS_DNORM):
 		/* normalize ym,ye */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index ad59a92..67e86b8 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2394,7 +2394,7 @@ int __init amd_iommu_init_passthrough(void)
 	struct pci_dev *dev = NULL;
 	u16 devid, devid2;

-	/* allocate passthroug domain */
+	/* allocate passthrough domain */
 	pt_domain = protection_domain_alloc();
 	if (!pt_domain)
 		return -ENOMEM;
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 1f3186c..5b8c750 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -481,7 +481,7 @@ static int __kprobes reenter_kprobe(struct kprobe
*p, struct pt_regs *regs,

 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate and they
- * remain disabled thorough out this function.
+ * remain disabled throughout this function.
  */
 static int __kprobes kprobe_handler(struct pt_regs *regs)
 {
@@ -818,7 +818,7 @@ no_change:

 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate and they
- * remain disabled thoroughout this function.
+ * remain disabled throughout this function.
  */
 static int __kprobes post_kprobe_handler(struct pt_regs *regs)
 {
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 11a4ad4..07bcc30 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -203,7 +203,7 @@ static void disarm_kmmio_fault_page(struct
kmmio_fault_page *f)
  */
 /*
  * Interrupts are disabled on entry as trap3 is an interrupt gate
- * and they remain disabled thorough out this function.
+ * and they remain disabled throughout this function.
  */
 int kmmio_handler(struct pt_regs *regs, unsigned long addr)
 {
@@ -302,7 +302,7 @@ no_kmmio:

 /*
  * Interrupts are disabled on entry as trap1 is an interrupt gate
- * and they remain disabled thorough out this function.
+ * and they remain disabled throughout this function.
  * This must always get called as the pair to kmmio_handler().
  */
 static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 6934025..c1d8b54 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -602,7 +602,7 @@ static void receive_char(struct r3964_info *pInfo,
const unsigned char c)
 		}
 		break;
 	case R3964_WAIT_FOR_RX_REPEAT:
-		/* FALLTROUGH */
+		/* FALLTHROUGH */
 	case R3964_IDLE:
 		if (c == STX) {
 			/* Prevent rx_queue from overflow: */
diff --git a/drivers/char/rio/route.h b/drivers/char/rio/route.h
index 20ed73f..46e9637 100644
--- a/drivers/char/rio/route.h
+++ b/drivers/char/rio/route.h
@@ -67,7 +67,7 @@
 typedef struct COST_ROUTE COST_ROUTE;
 struct COST_ROUTE {
 	unsigned char cost;	/* Cost down this link */
-	unsigned char route[NODE_BYTES];	/* Nodes thorough this route */
+	unsigned char route[NODE_BYTES];	/* Nodes through this route */
 };

 typedef struct ROUTE_STR ROUTE_STR;
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c
b/drivers/isdn/hardware/mISDN/hfcsusb.c
index fc46a26..a64bb6c 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -721,7 +721,7 @@ hfcsusb_setup_bch(struct bchannel *bch, int protocol)
 	switch (protocol) {
 	case (-1):	/* used for init */
 		bch->state = -1;
-		/* fall trough */
+		/* fall through */
 	case (ISDN_P_NONE):
 		if (bch->state == ISDN_P_NONE)
 			return 0; /* already in idle state */
diff --git a/drivers/media/common/saa7146_i2c.c
b/drivers/media/common/saa7146_i2c.c
index 7e8f568..48cb154 100644
--- a/drivers/media/common/saa7146_i2c.c
+++ b/drivers/media/common/saa7146_i2c.c
@@ -98,7 +98,7 @@ static int saa7146_i2c_msg_cleanup(const struct
i2c_msg *m, int num, __le32 *op)

 		op_count++;

-		/* loop throgh all bytes of message i */
+		/* loop through all bytes of message i */
 		for(j = 0; j < m[i].len; j++) {
 			/* write back all bytes that could have been read */
 			m[i].buf[j] = (le32_to_cpu(op[op_count/3]) >> ((3-(op_count%3))*8));
diff --git a/drivers/media/radio/radio-mr800.c
b/drivers/media/radio/radio-mr800.c
index a123908..5f79acb 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -28,7 +28,7 @@
  * http://av-usbradio.sourceforge.net/index.php
  * http://sourceforge.net/projects/av-usbradio/
  * Latest release of theirs project was in 2005.
- * Probably, this driver could be improved trough using their
+ * Probably, this driver could be improved through using their
  * achievements (specifications given).
  * Also, Faidon Liambotis <paravoid@debian.org> wrote nice driver for
this radio
  * in 2007. He allowed to use his driver to improve current mr800 radio driver.
diff --git a/drivers/media/video/cx231xx/cx231xx-avcore.c
b/drivers/media/video/cx231xx/cx231xx-avcore.c
index 28f48f4..c217441 100644
--- a/drivers/media/video/cx231xx/cx231xx-avcore.c
+++ b/drivers/media/video/cx231xx/cx231xx-avcore.c
@@ -2414,9 +2414,11 @@ int cx231xx_gpio_i2c_read_ack(struct cx231xx *dev)
 		cx231xx_info("No ACK after %d msec -GPIO I2C failed!",
 			     nInit * 10);

-	/* readAck
-	   throuth clock stretch ,slave has given a SCL signal,
-	   so the SDA data can be directly read.  */
+	/*
+	 * readAck
+	 * through clock stretch, slave has given a SCL signal,
+	 * so the SDA data can be directly read.
+	 */
 	status = cx231xx_get_gpio_bit(dev, dev->gpio_dir, (u8 *)&dev->gpio_val);

 	if ((dev->gpio_val & 1 << dev->board.tuner_sda_gpio) == 0) {
diff --git a/drivers/media/video/gspca/sonixb.c
b/drivers/media/video/gspca/sonixb.c
index cf3af8d..e39efb4 100644
--- a/drivers/media/video/gspca/sonixb.c
+++ b/drivers/media/video/gspca/sonixb.c
@@ -304,7 +304,7 @@ static const __u8 initOv6650[] = {
 };
 static const __u8 ov6650_sensor_init[][8] =
 {
-	/* Bright, contrast, etc are set througth SCBB interface.
+	/* Bright, contrast, etc are set through SCBB interface.
 	 * AVCAP on win2 do not send any data on this 	controls. */
 	/* Anyway, some registers appears to alter bright and constrat */

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c
b/drivers/net/wireless/iwmc3200wifi/commands.c
index 84158b6..8d154fa 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -49,7 +49,7 @@
 #include "commands.h"
 #include "debug.h"

-static int iwm_send_lmac_ptrough_cmd(struct iwm_priv *iwm,
+static int iwm_send_lmac_pthrough_cmd(struct iwm_priv *iwm,
 				     u8 lmac_cmd_id,
 				     const void *lmac_payload,
 				     u16 lmac_payload_size,
@@ -185,7 +185,7 @@ int iwm_send_prio_table(struct iwm_priv *iwm)
 	} else
 		IWM_WARN(iwm, "coexistense disabled\n");

-	return iwm_send_lmac_ptrough_cmd(iwm, COEX_PRIORITY_TABLE_CMD,
+	return iwm_send_lmac_pthrough_cmd(iwm, COEX_PRIORITY_TABLE_CMD,
 				&coex_table_cmd,
 				sizeof(struct iwm_coex_prio_table_cmd), 1);
 }
@@ -202,7 +202,7 @@ int iwm_send_init_calib_cfg(struct iwm_priv *iwm,
u8 calib_requested)
 	cal_cfg_cmd.ucode_cfg.flags =
 		cpu_to_le32(CALIB_CFG_FLAG_SEND_COMPLETE_NTFY_AFTER_MSK);

-	return iwm_send_lmac_ptrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
+	return iwm_send_lmac_pthrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
 				sizeof(struct iwm_lmac_cal_cfg_cmd), 1);
 }

@@ -215,7 +215,7 @@ int iwm_send_periodic_calib_cfg(struct iwm_priv
*iwm, u8 calib_requested)
 	cal_cfg_cmd.ucode_cfg.periodic.enable = cpu_to_le32(calib_requested);
 	cal_cfg_cmd.ucode_cfg.periodic.start = cpu_to_le32(calib_requested);

-	return iwm_send_lmac_ptrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
+	return iwm_send_lmac_pthrough_cmd(iwm, CALIBRATION_CFG_CMD, &cal_cfg_cmd,
 				sizeof(struct iwm_lmac_cal_cfg_cmd), 0);
 }

@@ -261,7 +261,7 @@ int iwm_send_calib_results(struct iwm_priv *iwm)
 			     &iwm->calib_done_map)) {
 			IWM_DBG_CMD(iwm, DBG,
 				    "Send calibration %d result\n", i);
-			ret |= iwm_send_lmac_ptrough_cmd(iwm,
+			ret |= iwm_send_lmac_pthrough_cmd(iwm,
 					REPLY_PHY_CALIBRATION_CMD,
 					iwm->calib_res[i].buf,
 					iwm->calib_res[i].size, 0);
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c
b/drivers/net/wireless/iwmc3200wifi/hal.c
index c430418..d13c885 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -411,7 +411,7 @@ static void iwm_build_lmac_hdr(struct iwm_priv
*iwm, struct iwm_lmac_hdr *hdr,
 /*
  * iwm_hal_send_host_cmd(): sends commands to the UMAC or the LMAC.
  * Sending command to the LMAC is equivalent to sending a
- * regular UMAC command with the LMAC passtrough or the LMAC
+ * regular UMAC command with the LMAC passthrough or the LMAC
  * wrapper UMAC command IDs.
  */
 int iwm_hal_send_host_cmd(struct iwm_priv *iwm,
diff --git a/drivers/staging/rt3090/common/spectrum.c
b/drivers/staging/rt3090/common/spectrum.c
index c26f057..f0e5508 100644
--- a/drivers/staging/rt3090/common/spectrum.c
+++ b/drivers/staging/rt3090/common/spectrum.c
@@ -1362,7 +1362,7 @@ VOID NotifyChSwAnnToPeerAPs(
 	if (!((pRA[0] & 0xff) == 0xff)) // is pRA a broadcase address.
 	{
 		INT i;
-		// info neighbor APs that Radar signal found throgh WDS link.
+		// info neighbor APs that Radar signal found through WDS link.
 		for (i = 0; i < MAX_WDS_ENTRY; i++)
 		{
 			if (ValidWdsEntry(pAd, i))
diff --git a/drivers/staging/rtl8187se/r8180_core.c
b/drivers/staging/rtl8187se/r8180_core.c
index 53e654d..c65de92 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -1919,8 +1919,8 @@ rate)
 	/*
 	* This function doesn't require lock because we make
 	* sure it's called with the tx_lock already acquired.
-	* this come from the kernel's hard_xmit callback (trought
-	* the ieee stack, or from the try_wake_queue (again trought
+	* this come from the kernel's hard_xmit callback (throught
+	* the ieee stack, or from the try_wake_queue (again throught
 	* the ieee stack.
 	*/
 	priority = AC2Q(skb->priority);
diff --git a/include/net/wimax.h b/include/net/wimax.h
index 2af7bf8..3b07f6a 100644
--- a/include/net/wimax.h
+++ b/include/net/wimax.h
@@ -79,7 +79,7 @@
  * drivers have to only report state changes due to external
  * conditions.
  *
- * All API operations are 'atomic', serialized thorough a mutex in the
+ * All API operations are 'atomic', serialized through a mutex in the
  * `struct wimax_dev`.
  *
  * EXPORTING TO USER SPACE THROUGH GENERIC NETLINK
diff --git a/net/irda/irlap.c b/net/irda/irlap.c
index 356e65b..783c5f3 100644
--- a/net/irda/irlap.c
+++ b/net/irda/irlap.c
@@ -450,10 +450,10 @@ void irlap_disconnect_request(struct irlap_cb *self)

 	/* Check if we are in the right state for disconnecting */
 	switch (self->state) {
-	case LAP_XMIT_P:        /* FALLTROUGH */
-	case LAP_XMIT_S:        /* FALLTROUGH */
-	case LAP_CONN:          /* FALLTROUGH */
-	case LAP_RESET_WAIT:    /* FALLTROUGH */
+	case LAP_XMIT_P:        /* FALLTHROUGH */
+	case LAP_XMIT_S:        /* FALLTHROUGH */
+	case LAP_CONN:          /* FALLTHROUGH */
+	case LAP_RESET_WAIT:    /* FALLTHROUGH */
 	case LAP_RESET_CHECK:
 		irlap_do_event(self, DISCONNECT_REQUEST, NULL, NULL);
 		break;
@@ -485,9 +485,9 @@ void irlap_disconnect_indication(struct irlap_cb
*self, LAP_REASON reason)
 		IRDA_DEBUG(1, "%s(), Sending reset request!\n", __func__);
 		irlap_do_event(self, RESET_REQUEST, NULL, NULL);
 		break;
-	case LAP_NO_RESPONSE:	   /* FALLTROUGH */
-	case LAP_DISC_INDICATION:  /* FALLTROUGH */
-	case LAP_FOUND_NONE:       /* FALLTROUGH */
+	case LAP_NO_RESPONSE:	   /* FALLTHROUGH */
+	case LAP_DISC_INDICATION:  /* FALLTHROUGH */
+	case LAP_FOUND_NONE:       /* FALLTHROUGH */
 	case LAP_MEDIA_BUSY:
 		irlmp_link_disconnect_indication(self->notify.instance, self,
 						 reason, NULL);
diff --git a/sound/pci/cs46xx/imgs/cwcdma.asp b/sound/pci/cs46xx/imgs/cwcdma.asp
index 09d24c7..a65e119 100644
--- a/sound/pci/cs46xx/imgs/cwcdma.asp
+++ b/sound/pci/cs46xx/imgs/cwcdma.asp
@@ -26,10 +26,11 @@
 //
 //
 // The purpose of this code is very simple: make it possible to tranfser
-// the samples 'as they are' with no alteration from a PCMreader SCB
(DMA from host)
-// to any other SCB. This is useful for AC3 throug SPDIF. SRC (source
rate converters)
-// task always alters the samples in some how, however it's from
48khz -> 48khz. The
-// alterations are not audible, but AC3 wont work.
+// the samples 'as they are' with no alteration from a PCMreader
+// SCB (DMA from host) to any other SCB. This is useful for AC3 through SPDIF.
+// SRC (source rate converters) task always alters the samples in somehow,
+// however it's from 48khz -> 48khz.
+// The alterations are not audible, but AC3 wont work.
 //
 //        ...
 //         |
-- 
1.6.5.2.101.gcd0f8
