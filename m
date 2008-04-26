Return-Path: <linux-kernel-owner+w=401wt.eu-S1762894AbYDZCDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762894AbYDZCDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 22:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbYDZCDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 22:03:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:49238 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbYDZCDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 22:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t5lPbFb6BdkM0CD65PbVFwndABNXhQtwE5jRxT/KuNq30RcgrAUUpHfLsENuInAsBJTQeLsQf88RwM8XMWYlvWI9zSdFW0ghS26C4SnDQNIUJK/ZobJMg4/KcZh0KdX4fB72C20L38zqSmPPhTHGmI/CeHNLR/SrV3ApnqfSyd0=
Subject: [BUILDFIX PATCH] v4l/dvb: add statics to avoid multiple definitions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 19:03:08 -0700
Message-Id: <1209175388.14173.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    4 ++--
 drivers/media/video/cx23885/cx23885-dvb.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 6477fc6..3462238 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -299,7 +299,7 @@ static int stk7700d_tuner_attach(struct dvb_usb_adapter *adap)
 }
 
 /* STK7700-PH: Digital/Analog Hybrid Tuner, e.h. Cinergy HT USB HE */
-struct dibx000_agc_config xc3028_agc_config = {
+static struct dibx000_agc_config xc3028_agc_config = {
 	BAND_VHF | BAND_UHF,       /* band_caps */
 
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=0,
@@ -342,7 +342,7 @@ struct dibx000_agc_config xc3028_agc_config = {
 };
 
 /* PLL Configuration for COFDM BW_MHz = 8.00 with external clock = 30.00 */
-struct dibx000_bandwidth_config xc3028_bw_config = {
+static struct dibx000_bandwidth_config xc3028_bw_config = {
 	60000, 30000, /* internal, sampling */
 	1, 8, 3, 1, 0, /* pll_cfg: prediv, ratio, range, reset, bypass */
 	0, 0, 1, 1, 0, /* misc: refdiv, bypclk_div, IO_CLK_en_core, ADClkSrc,
diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 870d6e1..f056497 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -191,7 +191,7 @@ static struct tda18271_config hauppauge_hvr1200_tuner_config = {
 	.gate    = TDA18271_GATE_ANALOG,
 };
 
-struct dibx000_agc_config xc3028_agc_config = {
+static struct dibx000_agc_config xc3028_agc_config = {
 	BAND_VHF | BAND_UHF,	/* band_caps */
 
 	/* P_agc_use_sd_mod1=0, P_agc_use_sd_mod2=0, P_agc_freq_pwm_div=0,
@@ -237,7 +237,7 @@ struct dibx000_agc_config xc3028_agc_config = {
 
 /* PLL Configuration for COFDM BW_MHz = 8.000000
  * With external clock = 30.000000 */
-struct dibx000_bandwidth_config xc3028_bw_config = {
+static struct dibx000_bandwidth_config xc3028_bw_config = {
 	60000,	/* internal */
 	30000,	/* sampling */
 	1,	/* pll_cfg: prediv */
-- 
1.5.5.1.270.g89765



