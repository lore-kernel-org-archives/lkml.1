Return-Path: <linux-kernel-owner+w=401wt.eu-S933072AbZLRVJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072AbZLRVJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933001AbZLRVI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:27 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:37073 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 1/8] w35und: Convert typedef LOCAL_PARA to struct wb_local_para
Date: Fri, 18 Dec 2009 23:08:15 +0200
Message-Id: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h      |    2 +-
 drivers/staging/winbond/localpara.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 7d4bd5e..0a2060b 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -14,7 +14,7 @@
 struct wbsoft_priv {
 	u32 adapterIndex;	// 20060703.4 Add for using padapterContext global adapter point
 
-	WB_LOCALDESCRIPT sLocalPara;	// Myself connected parameters
+	struct wb_local_para sLocalPara;	// Myself connected parameters
 
 	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
 
diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index 5626a76..b731875 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -136,7 +136,7 @@ typedef struct _RadioOff
 } RadioOff, *psRadioOff;
 
 //===========================================================================
-typedef struct LOCAL_PARA
+struct wb_local_para
 {
 	u8			PermanentAddress[ MAC_ADDR_LENGTH + 2 ]; 	// read from EPROM, manufacture set for each NetCard
     u8    		ThisMacAddress[ MAC_ADDR_LENGTH + 2 ];			// the driver will use actually.
@@ -274,6 +274,6 @@ typedef struct LOCAL_PARA
 	u16		IE_Append_size;
 	u16		reserved_7;
 
-} WB_LOCALDESCRIPT, *PWB_LOCALDESCRIPT;
+};
 
 #endif
-- 
1.6.0.4

