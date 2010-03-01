Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab0CAPPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:15:40 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34578 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0CAPOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:55 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 16/26] w35und: Convert WB_LOCALDESCRIPT typedef to struct wb35_local_para
Date: Mon,  1 Mar 2010 17:04:18 +0200
Message-Id: <1267455868-4533-16-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h      |    2 +-
 drivers/staging/winbond/localpara.h |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 7d4bd5e..4dc6b71 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -14,7 +14,7 @@
 struct wbsoft_priv {
 	u32 adapterIndex;	// 20060703.4 Add for using padapterContext global adapter point
 
-	WB_LOCALDESCRIPT sLocalPara;	// Myself connected parameters
+	struct wb35_local_para sLocalPara;	// Myself connected parameters
 
 	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
 
diff --git a/drivers/staging/winbond/localpara.h b/drivers/staging/winbond/localpara.h
index ebce37f..4e761b7 100644
--- a/drivers/staging/winbond/localpara.h
+++ b/drivers/staging/winbond/localpara.h
@@ -121,8 +121,7 @@ struct wb35_radio_off {
 };
 
 //===========================================================================
-typedef struct LOCAL_PARA
-{
+struct wb35_local_para {
 	u8			PermanentAddress[ MAC_ADDR_LENGTH + 2 ]; 	// read from EPROM, manufacture set for each NetCard
     u8    		ThisMacAddress[ MAC_ADDR_LENGTH + 2 ];			// the driver will use actually.
 
@@ -256,6 +255,6 @@ typedef struct LOCAL_PARA
 	u16		IE_Append_size;
 	u16		reserved_7;
 
-} WB_LOCALDESCRIPT, *PWB_LOCALDESCRIPT;
+};
 
 #endif
-- 
1.6.3.3

