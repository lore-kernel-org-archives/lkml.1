Return-Path: <linux-kernel-owner+w=401wt.eu-S932639AbZJaJlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbZJaJlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932371AbZJaJlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:50 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:35835 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589AbZJaJlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=C7UqRJO/p3Jc+hh7dam0ZHN1DKinhLmn3YTjaBGBs3Ri0JqT6hes54i+3kIMlLOXzS
         OO0Io2EqpGShRFcZl0+BHQxq0niCiSgMWLgpmK7ZPLHDzzL5FP0MkCjEaQpYHPBdFKjt
         mCqab4xcJp1kS1I8LtEvzuUQHkOp39Whe3+oE=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:32 -0200
Message-ID: <b8bf37780910310241r1bf7eaffqf0ad0079cdd2c3ff@mail.gmail.com>
Subject: [PATCH 10/16] trivial: fix assorted "temperature" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 82c935b26acbcdc6f3067341b0639a5836b85faf Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 07:00:13 -0200
Subject: [PATCH 10/16] trivial: fix assorted "temperature" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index fc36cad..c48a284 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -928,7 +928,7 @@ static void lm93_update_client_common(struct
lm93_data *data,
 	data->prochot_interval = lm93_read_byte(client,
 			LM93_REG_PROCHOT_INTERVAL);

-	/* Fan Boost Termperature registers */
+	/* Fan Boost Temperature registers */
 	for (i = 0; i < 4; i++)
 		data->boost[i] = lm93_read_byte(client, LM93_REG_BOOST(i));

diff --git a/drivers/macintosh/therm_windtunnel.c
b/drivers/macintosh/therm_windtunnel.c
index 8b93644..3fbe41b 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -15,7 +15,7 @@
  *
  *	WARNING: This driver has only been testen on Apple's
  *	1.25 MHz Dual G4 (March 03). It is tuned for a CPU
- *	temperatur around 57 C.
+ *	temperature around 57 C.
  *
  *   Copyright (C) 2003, 2004 Samuel Rydh (samuel@ibrium.se)
  *
diff --git a/drivers/net/wireless/ath/ath5k/phy.c
b/drivers/net/wireless/ath/ath5k/phy.c
index 6464e31..6f04cc7 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -117,7 +117,7 @@ static unsigned int ath5k_hw_rfb_op(struct ath5k_hw *ah,

 /*
  * This code is used to optimize rf gain on different environments
- * (temprature mostly) based on feedback from a power detector.
+ * (temperature mostly) based on feedback from a power detector.
  *
  * It's only used on RF5111 and RF5112, later RF chips seem to have
  * auto adjustment on hw -notice they have a much smaller BANK 7 and
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 58e583b..aa2b60a 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -92,11 +92,11 @@
 #define ENVCTRL_CPUTEMP_MON			1    /* cpu temperature monitor */
 #define ENVCTRL_CPUVOLTAGE_MON	  	2    /* voltage monitor         */
 #define ENVCTRL_FANSTAT_MON  		3    /* fan status monitor      */
-#define ENVCTRL_ETHERTEMP_MON		4    /* ethernet temperarture */
+#define ENVCTRL_ETHERTEMP_MON		4    /* ethernet temperature */
 					     /* monitor                     */
 #define ENVCTRL_VOLTAGESTAT_MON	  	5    /* voltage status monitor  */
 #define ENVCTRL_MTHRBDTEMP_MON		6    /* motherboard temperature */
-#define ENVCTRL_SCSITEMP_MON		7    /* scsi temperarture */
+#define ENVCTRL_SCSITEMP_MON		7    /* scsi temperature */
 #define ENVCTRL_GLOBALADDR_MON		8    /* global address */

 /* Child device type.
diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index 512c2cc..d310f49 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -381,7 +381,7 @@ typedef struct {
 	u8	battery_status;	/*
 				 * BIT 0: battery module missing
 				 * BIT 1: VBAD
-				 * BIT 2: temprature high
+				 * BIT 2: temperature high
 				 * BIT 3: battery pack missing
 				 * BIT 4,5:
 				 *   00 - charge complete
diff --git a/drivers/scsi/megaraid/mbox_defs.h
b/drivers/scsi/megaraid/mbox_defs.h
index b25b747..ce2487a 100644
--- a/drivers/scsi/megaraid/mbox_defs.h
+++ b/drivers/scsi/megaraid/mbox_defs.h
@@ -497,7 +497,7 @@ typedef struct {
  * @inserted_drive		: channel:Id of inserted drive
  * @battery_status		: bit 0: battery module missing
  *				bit 1: VBAD
- *				bit 2: temprature high
+ *				bit 2: temperature high
  *				bit 3: battery pack missing
  *				bit 4,5:
  *					00 - charge complete
diff --git a/drivers/staging/rtl8192e/r8192E_dm.c
b/drivers/staging/rtl8192e/r8192E_dm.c
index bf87632..23afca4 100644
--- a/drivers/staging/rtl8192e/r8192E_dm.c
+++ b/drivers/staging/rtl8192e/r8192E_dm.c
@@ -571,7 +571,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
 	0x5a400169,	// 3, +3db
 	0x50800142,	// 4, +2db
 	0x47c0011f,	// 5, +1db
-	0x40000100,	// 6, +0db ===> default, upper for higher temprature,
lower for low temprature
+	0x40000100,	// 6, +0db ===> default, upper for higher temperature,
lower for low temperature
 	0x390000e4,	// 7, -1db
 	0x32c000cb,	// 8, -2db
 	0x2d4000b5,	// 9, -3db
@@ -932,14 +932,14 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n", tmpRegA);
 	if(tmpRegA < 3 || tmpRegA > 13)
 		return;
-	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temprature
+	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temperature
 		tmpRegA = 12;
 	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
 	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion
 	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion

-	//Get current RF-A temprature index
-	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temprature
+	//Get current RF-A temperature index
+	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temperature
 	{
 		tmpOFDMindex = tmpCCK20Mindex = 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
 		tmpCCK40Mindex = tmpCCK20Mindex - 6;
@@ -953,7 +953,7 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	else
 	{
 		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
-		if(tmpval >= 6)								// higher temprature
+		if(tmpval >= 6)								// higher temperature
 			tmpOFDMindex = tmpCCK20Mindex = 0;		// max to +6dB
 		else
 			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
diff --git a/drivers/staging/rtl8192su/r8192U_dm.c
b/drivers/staging/rtl8192su/r8192U_dm.c
index 5358ae8..7891e96 100644
--- a/drivers/staging/rtl8192su/r8192U_dm.c
+++ b/drivers/staging/rtl8192su/r8192U_dm.c
@@ -593,7 +593,7 @@ static u32 OFDMSwingTable[OFDM_Table_Length] = {
 	0x5a400169,	// 3, +3db
 	0x50800142,	// 4, +2db
 	0x47c0011f,	// 5, +1db
-	0x40000100,	// 6, +0db ===> default, upper for higher temprature,
lower for low temprature
+	0x40000100,	// 6, +0db ===> default, upper for higher temperature,
lower for low temperature
 	0x390000e4,	// 7, -1db
 	0x32c000cb,	// 8, -2db
 	0x2d4000b5,	// 9, -3db
@@ -912,14 +912,14 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	RT_TRACE(COMP_POWER_TRACKING, "Readback ThermalMeterA = %d \n", tmpRegA);
 	if(tmpRegA < 3 || tmpRegA > 13)
 		return;
-	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temprature
+	if(tmpRegA >= 12)	// if over 12, TP will be bad when high temperature
 		tmpRegA = 12;
 	RT_TRACE(COMP_POWER_TRACKING, "Valid ThermalMeterA = %d \n", tmpRegA);
 	priv->ThermalMeter[0] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion
 	priv->ThermalMeter[1] = ThermalMeterVal;	//We use fixed value by
Bryant's suggestion

-	//Get current RF-A temprature index
-	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temprature
+	//Get current RF-A temperature index
+	if(priv->ThermalMeter[0] >= (u8)tmpRegA)	//lower temperature
 	{
 		tmpOFDMindex = tmpCCK20Mindex = 6+(priv->ThermalMeter[0]-(u8)tmpRegA);
 		tmpCCK40Mindex = tmpCCK20Mindex - 6;
@@ -933,7 +933,7 @@ static void
dm_TXPowerTrackingCallback_ThermalMeter(struct net_device * dev)
 	else
 	{
 		tmpval = ((u8)tmpRegA - priv->ThermalMeter[0]);
-		if(tmpval >= 6)								// higher temprature
+		if(tmpval >= 6)								// higher temperature
 			tmpOFDMindex = tmpCCK20Mindex = 0;		// max to +6dB
 		else
 			tmpOFDMindex = tmpCCK20Mindex = 6 - tmpval;
-- 
1.6.5.2.101.gcd0f8
