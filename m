Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbZLRVJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbZLRVJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933005AbZLRVI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:28 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56233 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5/8] w35und: Remove unused typedef CHAN_LIST
Date: Fri, 18 Dec 2009 23:08:19 +0200
Message-Id: <1261170502-1479-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261170502-1479-4-git-send-email-penberg@cs.helsinki.fi>
References: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-3-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-4-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/localpara.h |    7 -------
 drivers/staging/winbond/scan_s.h    |    1 -
 2 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 7ca58d0..fcf6a04 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -116,12 +116,6 @@ struct chan_info
 	u8		ChanNo;
 };
 
-typedef struct _CHAN_LIST
-{
-	u16				Count;
-	struct chan_info		Channel[50]; // 100B
-} CHAN_LIST, *psCHAN_LIST;
-
 struct radio_off
 {
 	u8			boHwRadioOff;
@@ -250,7 +244,6 @@ struct wb_local_para
 	u8		reserved_5[2];		//It may not be used after considering RF type,
 									//region and modulation type.
 
-	CHAN_LIST	sSupportChanList;	// 86B. It will be obtained according to RF type and region
 	u8		reserved_6[2];		//two variables are for wep key error detection added by ws 02/02/04
 
     u32	      bWepKeyError;
diff --git a/drivers/staging/winbond/scan_s.h b/drivers/staging/winbond/scan_s.h
index 775bb81..209717f 100644
--- a/drivers/staging/winbond/scan_s.h
+++ b/drivers/staging/winbond/scan_s.h
@@ -35,7 +35,6 @@ typedef struct _SCAN_REQ_PARA	//mandatory parameters for SCAN request
 {
 	u32				ScanType;			//passive/active scan
 
-	CHAN_LIST		sChannelList;	// 86B
 	u8			reserved_1[2];
 
 	struct SSID_Element	sSSID; // 34B. scan only for this SSID
-- 
1.6.0.4

