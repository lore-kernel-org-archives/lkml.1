Return-Path: <linux-kernel-owner+w=401wt.eu-S1764883AbZFMQfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764883AbZFMQfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762514AbZFMQdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:33:40 -0400
Received: from mail-fx0-f206.google.com ([209.85.220.206]:52100 "EHLO
	mail-fx0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762965AbZFMQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=ForXMjnURAEGk4U8DAKs45ndEkl+nGB7Xk+FpDIAQsfzv0yLg7TfcM1Fa55qJyGGi9
         2mL2dwtZHLGzB2sQKzqn7N6AiCrB9YY+mCOCrEt/auM4Ampfc0vwN/5eNHVN2eefVtPf
         ReUNDqI3IYC+1WISM0jDVNVcv0Ea6GHzB3Ayc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH 5/6] Staging: rtl8187se/ieee80211: remove unused dump_chnl_map()
Date: Sat, 13 Jun 2009 18:33:17 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090612-07181-g84f26e4; KDE/4.2.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906131833.18040.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/dot11d.c            |   10 ----------
 drivers/staging/rtl8187se/ieee80211/dot11d.h            |    2 --
 drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    1 -
 3 files changed, 13 deletions(-)

Index: b/drivers/staging/rtl8187se/ieee80211/dot11d.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.c
@@ -130,16 +130,6 @@ Dot11d_UpdateCountryIe(
 	pDot11dInfo->State = DOT11D_STATE_LEARNED;
 }
 
-void dump_chnl_map(u8 * channel_map)
-{
-	int i;
-	printk("Channel List:");
-	for(i=1; i<= MAX_CHANNEL_NUMBER; i++)
-		if(channel_map[i] > 0)
-			printk(" %d(%d)", i, channel_map[i]);
-	printk("\n");
-}
-
 u8
 DOT11D_GetMaxTxPwrInDbm(
 	struct ieee80211_device *dev,
Index: b/drivers/staging/rtl8187se/ieee80211/dot11d.h
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/dot11d.h
+++ b/drivers/staging/rtl8187se/ieee80211/dot11d.h
@@ -97,6 +97,4 @@ int ToLegalChannel(
 	struct ieee80211_device * dev,
 	u8 channel
 );
-
-void dump_chnl_map(u8 * channel_map);
 #endif // #ifndef __INC_DOT11D_H
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -449,7 +449,6 @@ void ieee80211_softmac_scan_syncro(struc
 #endif
 	down(&ieee->scan_sem);
 //	printk("==================> Sync scan\n");
-//	dump_chnl_map(channel_map);
 
 	while(1)
 	{
