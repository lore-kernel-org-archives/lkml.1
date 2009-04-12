Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbZDLOSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbZDLOSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 10:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZDLOSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 10:18:11 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:41623 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406AbZDLOSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 10:18:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=HRSrMpc5k72kI2FnXi9QsS2SwYytlbW+K1k/pfBSzWANvTqM81xU6pMFLjOENNdYTG
         ox/LGXrvQOQA84EZOwQxagqv+3MqGbEbBtgYSQsyV4ncBpgIxmQVebL8nIZeHW3ZvN40
         FpmcKl41O0uzl2KTj5VR5Rd5OqUH2JN2smO6M=
From: Alessio Igor Bogani <abogani@texware.it>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: LNML <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH -next 3/4] Staging: comedi: replace __FUNCTION__ usages
Date: Sun, 12 Apr 2009 16:17:49 +0200
Message-Id: <1239545870-23779-3-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1239545870-23779-2-git-send-email-abogani@texware.it>
References: <1239545870-23779-1-git-send-email-abogani@texware.it>
 <1239545870-23779-2-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 drivers/staging/comedi/drivers/ni_660x.c       |    6 +++---
 drivers/staging/comedi/drivers/ni_mio_common.c |   24 ++++++++++++------------
 drivers/staging/comedi/drivers/ni_pcimio.c     |   10 +++++-----
 drivers/staging/comedi/drivers/ni_stc.h        |   14 +++++++-------
 drivers/staging/comedi/drivers/ni_tio.c        |    2 +-
 5 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 14e35ba..3388fac 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -694,7 +694,7 @@ static enum NI_660x_Register ni_gpct_to_660x_register(enum ni_gpct_register reg)
 		break;
 	default:
 		rt_printk("%s: unhandled register 0x%x in switch.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -718,7 +718,7 @@ static inline void ni_660x_write_register(struct comedi_device * dev,
 		break;
 	default:
 		rt_printk("%s: %s: bug! unhandled case (reg=0x%x) in switch.\n",
-			__FILE__, __FUNCTION__, reg);
+			__FILE__, __func__, reg);
 		BUG();
 		break;
 	}
@@ -740,7 +740,7 @@ static inline unsigned ni_660x_read_register(struct comedi_device * dev,
 		break;
 	default:
 		rt_printk("%s: %s: bug! unhandled case (reg=0x%x) in switch.\n",
-			__FILE__, __FUNCTION__, reg);
+			__FILE__, __func__, reg);
 		BUG();
 		break;
 	}
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 542bd0d..abff5ad 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -397,7 +397,7 @@ static inline void ni_set_bitfield(struct comedi_device * dev, int reg,
 		break;
 	default:
 		rt_printk("Warning %s() called with invalid register\n",
-			__FUNCTION__);
+			__func__);
 		rt_printk("reg is %d\n", reg);
 		break;
 	}
@@ -2845,7 +2845,7 @@ static int ni_m_series_ao_config_chanlist(struct comedi_device * dev,
 			break;
 		default:
 			rt_printk("%s: bug! unhandled ao reference voltage\n",
-				__FUNCTION__);
+				__func__);
 			break;
 		}
 		switch (krange->max + krange->min) {
@@ -2857,7 +2857,7 @@ static int ni_m_series_ao_config_chanlist(struct comedi_device * dev,
 			break;
 		default:
 			rt_printk("%s: bug! unhandled ao offset voltage\n",
-				__FUNCTION__);
+				__func__);
 			break;
 		}
 		if (timed)
@@ -4100,7 +4100,7 @@ static unsigned ni_gpct_to_stc_register(enum ni_gpct_register reg)
 		break;
 	default:
 		rt_printk("%s: unhandled register 0x%x in switch.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -5225,7 +5225,7 @@ static unsigned ni_old_get_pfi_routing(struct comedi_device * dev, unsigned chan
 		return NI_PFI_OUTPUT_G_GATE0;
 		break;
 	default:
-		rt_printk("%s: bug, unhandled case in switch.\n", __FUNCTION__);
+		rt_printk("%s: bug, unhandled case in switch.\n", __func__);
 		break;
 	}
 	return 0;
@@ -5390,7 +5390,7 @@ static int ni_mseries_get_pll_parameters(unsigned reference_period_ns,
 	}
 	if (best_period_picosec == 0) {
 		rt_printk("%s: bug, failed to find pll parameters\n",
-			__FUNCTION__);
+			__func__);
 		return -EIO;
 	}
 	*freq_divider = best_div;
@@ -5426,7 +5426,7 @@ static int ni_mseries_set_pll_master_clock(struct comedi_device * dev, unsigned
 	if (period_ns < min_period_ns || period_ns > max_period_ns) {
 		rt_printk
 			("%s: you must specify an input clock frequency between %i and %i nanosec "
-			"for the phased-lock loop.\n", __FUNCTION__,
+			"for the phased-lock loop.\n", __func__,
 			min_period_ns, max_period_ns);
 		return -EINVAL;
 	}
@@ -5498,7 +5498,7 @@ static int ni_mseries_set_pll_master_clock(struct comedi_device * dev, unsigned
 	if (i == timeout) {
 		rt_printk
 			("%s: timed out waiting for PLL to lock to reference clock source %i with period %i ns.\n",
-			__FUNCTION__, source, period_ns);
+			__func__, source, period_ns);
 		return -ETIMEDOUT;
 	}
 	return 3;
@@ -5535,7 +5535,7 @@ static int ni_set_master_clock(struct comedi_device * dev, unsigned source,
 				if (period_ns == 0) {
 					rt_printk
 						("%s: we don't handle an unspecified clock period correctly yet, returning error.\n",
-						__FUNCTION__);
+						__func__);
 					return -EINVAL;
 				} else {
 					devpriv->clock_ns = period_ns;
@@ -5558,7 +5558,7 @@ static int ni_valid_rtsi_output_source(struct comedi_device * dev, unsigned chan
 			else {
 				rt_printk
 					("%s: invalid source for channel=%i, channel %i is always the RTSI clock for pre-m-series boards.\n",
-					__FUNCTION__, chan,
+					__func__, chan,
 					old_RTSI_clock_channel);
 				return 0;
 			}
@@ -5621,7 +5621,7 @@ static unsigned ni_get_rtsi_routing(struct comedi_device * dev, unsigned chan)
 	} else {
 		if (chan == old_RTSI_clock_channel)
 			return NI_RTSI_OUTPUT_RTSI_OSC;
-		rt_printk("%s: bug! should never get here?\n", __FUNCTION__);
+		rt_printk("%s: bug! should never get here?\n", __func__);
 		return 0;
 	}
 }
@@ -5716,7 +5716,7 @@ static int cs5529_wait_for_idle(struct comedi_device * dev)
 	}
 //printk("looped %i times waiting for idle\n", i);
 	if (i == timeout) {
-		rt_printk("%s: %s: timeout\n", __FILE__, __FUNCTION__);
+		rt_printk("%s: %s: timeout\n", __FILE__, __func__);
 		return -ETIME;
 	}
 	return 0;
diff --git a/drivers/staging/comedi/drivers/ni_pcimio.c b/drivers/staging/comedi/drivers/ni_pcimio.c
index 3a2aba7..d11beb6 100644
--- a/drivers/staging/comedi/drivers/ni_pcimio.c
+++ b/drivers/staging/comedi/drivers/ni_pcimio.c
@@ -1350,7 +1350,7 @@ static void m_series_stc_writew(struct comedi_device * dev, uint16_t data, int r
 	case DIO_Control_Register:
 		rt_printk
 			("%s: FIXME: register 0x%x does not map cleanly on to m-series boards.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		return;
 		break;
 	case G_Autoincrement_Register(0):
@@ -1411,7 +1411,7 @@ static void m_series_stc_writew(struct comedi_device * dev, uint16_t data, int r
 		   and M_Offset_SCXI_Serial_Data_Out (8 bit) */
 	default:
 		rt_printk("%s: bug! unhandled register=0x%x in switch.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		BUG();
 		return;
 		break;
@@ -1446,7 +1446,7 @@ static uint16_t m_series_stc_readw(struct comedi_device * dev, int reg)
 		break;
 	default:
 		rt_printk("%s: bug! unhandled register=0x%x in switch.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
@@ -1487,7 +1487,7 @@ static void m_series_stc_writel(struct comedi_device * dev, uint32_t data, int r
 		break;
 	default:
 		rt_printk("%s: bug! unhandled register=0x%x in switch.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		BUG();
 		return;
 		break;
@@ -1513,7 +1513,7 @@ static uint32_t m_series_stc_readl(struct comedi_device * dev, int reg)
 		break;
 	default:
 		rt_printk("%s: bug! unhandled register=0x%x in switch.\n",
-			__FUNCTION__, reg);
+			__func__, reg);
 		BUG();
 		return 0;
 		break;
diff --git a/drivers/staging/comedi/drivers/ni_stc.h b/drivers/staging/comedi/drivers/ni_stc.h
index 1ebf521..509a2da 100644
--- a/drivers/staging/comedi/drivers/ni_stc.h
+++ b/drivers/staging/comedi/drivers/ni_stc.h
@@ -339,7 +339,7 @@ static inline unsigned RTSI_Output_Bit(unsigned channel, int is_mseries)
 		max_channel = 6;
 	}
 	if (channel > max_channel) {
-		rt_printk("%s: bug, invalid RTSI_channel=%i\n", __FUNCTION__,
+		rt_printk("%s: bug, invalid RTSI_channel=%i\n", __func__,
 			channel);
 		return 0;
 	}
@@ -1085,7 +1085,7 @@ static inline int M_Offset_Static_AI_Control(int i)
 		0x263,
 	};
 	if (((unsigned)i) >= sizeof(offset) / sizeof(offset[0])) {
-		rt_printk("%s: invalid channel=%i\n", __FUNCTION__, i);
+		rt_printk("%s: invalid channel=%i\n", __func__, i);
 		return offset[0];
 	}
 	return offset[i];
@@ -1099,7 +1099,7 @@ static inline int M_Offset_AO_Reference_Attenuation(int channel)
 		0x267
 	};
 	if (((unsigned)channel) >= sizeof(offset) / sizeof(offset[0])) {
-		rt_printk("%s: invalid channel=%i\n", __FUNCTION__, channel);
+		rt_printk("%s: invalid channel=%i\n", __func__, channel);
 		return offset[0];
 	}
 	return offset[channel];
@@ -1108,7 +1108,7 @@ static inline unsigned M_Offset_PFI_Output_Select(unsigned n)
 {
 	if (n < 1 || n > NUM_PFI_OUTPUT_SELECT_REGS) {
 		rt_printk("%s: invalid pfi output select register=%i\n",
-			__FUNCTION__, n);
+			__func__, n);
 		return M_Offset_PFI_Output_Select_1;
 	}
 	return M_Offset_PFI_Output_Select_1 + (n - 1) * 2;
@@ -1162,7 +1162,7 @@ static inline unsigned MSeries_PLL_In_Source_Select_RTSI_Bits(unsigned
 	RTSI_channel)
 {
 	if (RTSI_channel > 7) {
-		rt_printk("%s: bug, invalid RTSI_channel=%i\n", __FUNCTION__,
+		rt_printk("%s: bug, invalid RTSI_channel=%i\n", __func__,
 			RTSI_channel);
 		return 0;
 	}
@@ -1183,7 +1183,7 @@ static inline unsigned MSeries_PLL_Divisor_Bits(unsigned divisor)
 {
 	static const unsigned max_divisor = 0x10;
 	if (divisor < 1 || divisor > max_divisor) {
-		rt_printk("%s: bug, invalid divisor=%i\n", __FUNCTION__,
+		rt_printk("%s: bug, invalid divisor=%i\n", __func__,
 			divisor);
 		return 0;
 	}
@@ -1193,7 +1193,7 @@ static inline unsigned MSeries_PLL_Multiplier_Bits(unsigned multiplier)
 {
 	static const unsigned max_multiplier = 0x100;
 	if (multiplier < 1 || multiplier > max_multiplier) {
-		rt_printk("%s: bug, invalid multiplier=%i\n", __FUNCTION__,
+		rt_printk("%s: bug, invalid multiplier=%i\n", __func__,
 			multiplier);
 		return 0;
 	}
diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
index 05a9575..f22fb43 100644
--- a/drivers/staging/comedi/drivers/ni_tio.c
+++ b/drivers/staging/comedi/drivers/ni_tio.c
@@ -1273,7 +1273,7 @@ static int ni_tio_set_other_src(struct ni_gpct *counter, unsigned index,
 		counter_dev->regs[abz_reg] &= ~mask;
 		counter_dev->regs[abz_reg] |= (source << shift) & mask;
 		write_register(counter, counter_dev->regs[abz_reg], abz_reg);
-//              rt_printk("%s %x %d %d\n", __FUNCTION__, counter_dev->regs[abz_reg], index, source);
+//              rt_printk("%s %x %d %d\n", __func__, counter_dev->regs[abz_reg], index, source);
 		return 0;
 	}
 	return -EINVAL;
-- 
1.6.0.4

