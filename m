Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab0CAPRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:17:34 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60578 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0CAPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:13 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 03/26] w35und: Remove unused struct _CHAN_LIST
Date: Mon,  1 Mar 2010 17:04:05 +0200
Message-Id: <1267455868-4533-3-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    7 -------
 drivers/staging/winbond/scan_s.h    |    2 --
 2 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index bdce73c..54ab3b7 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -116,12 +116,6 @@ typedef struct _ChanInfo
 	u8		ChanNo;
 } ChanInfo, *pChanInfo;
 
-typedef struct _CHAN_LIST
-{
-	u16				Count;
-	ChanInfo		Channel[50]; // 100B
-} CHAN_LIST, *psCHAN_LIST;
-
 typedef struct _RadioOff
 {
 	u8			boHwRadioOff;
@@ -250,7 +244,6 @@ typedef struct LOCAL_PARA
 	u8		reserved_5[2];		//It may not be used after considering RF type,
 									//region and modulation type.
 
-	CHAN_LIST	sSupportChanList;	// 86B. It will be obtained according to RF type and region
 	u8		reserved_6[2];		//two variables are for wep key error detection added by ws 02/02/04
 
     u32	      bWepKeyError;
diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index 775bb81..d35f194 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -34,8 +34,6 @@
 typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
 {
 	u32				ScanType;			//passive/active scan
-
-	CHAN_LIST		sChannelList;	// 86B
 	u8			reserved_1[2];
 
 	struct SSID_Element	sSSID; // 34B. scan only for this SSID
-- 
1.6.3.3

