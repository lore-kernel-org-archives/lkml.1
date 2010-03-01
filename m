Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0CAPQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:16:01 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34561 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0CAPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:54 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 10/26] w35und: Remove unused struct _SCAN_REQ_PARA
Date: Mon,  1 Mar 2010 17:04:12 +0200
Message-Id: <1267455868-4533-10-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/scan_s.h |   54 --------------------------------------
 1 files changed, 0 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index d35f194..a577884 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -31,60 +31,6 @@
 
 ///////////////////////////////////////////////////////////////////////////
 //Global data structures, Initial Scan & Background Scan
-typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
-{
-	u32				ScanType;			//passive/active scan
-	u8			reserved_1[2];
-
-	struct SSID_Element	sSSID; // 34B. scan only for this SSID
-	u8			reserved_2[2];
-
-} SCAN_REQ_PARA, *psSCAN_REQ_PARA;
-
-typedef struct _SCAN_PARAMETERS
-{
-	u16				wState;
-	u16				iCurrentChannelIndex;
-
-	SCAN_REQ_PARA	sScanReq;
-
-	u8				BSSID[MAC_ADDR_LENGTH + 2];		//scan only for this BSSID
-
-	u32				BssType;						//scan only for this BSS type
-
-	//struct SSID_Element	sSSID;						//scan only for this SSID
-	u16				ProbeDelay;
-	u16				MinChannelTime;
-
-	u16				MaxChannelTime;
-	u16				reserved_1;
-
-    s32				iBgScanPeriod;				// XP: 5 sec
-
-    u8				boBgScan;					// Wb: enable BG scan, For XP, this value must be FALSE
-    u8				boFastScan;					// Wb: reserved
-	u8				boCCAbusy;					// Wb: HWMAC CCA busy status
-	u8				reserved_2;
-
-	struct timer_list timer;
-
-	u32				ScanTimeStamp;			//Increase 1 per background scan(1 minute)
-	u32				BssTimeStamp;			//Increase 1 per connect status check
-	u32				RxNumPerAntenna[2];		//
-
-	u8				AntennaToggle;			//
-	u8				boInTimerHandler;
-	u8 				boTimerActive;				// Wb: reserved
-	u8				boSave;
-
-	u32				BScanEnable; // Background scan enable. Default is On
-
-} SCAN_PARAMETERS, *psSCAN_PARAMETERS;
-
-// Encapsulate 'adapter' data structure
-#define psSCAN			(&(adapter->sScanPara))
-#define psSCANREQ			(&(adapter->sScanPara.sScanReq))
-
 //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 //	scan.h
 //		Define the related definitions of scan module
-- 
1.6.3.3

