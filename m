Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502Ab0CAPMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:12:51 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46307 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab0CAPMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:48 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Mar 2010 10:12:47 EST
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 17/26] w35und: Convert MLME_FRAME typedef to struct wb35_mlme_frame
Date: Mon,  1 Mar 2010 17:04:19 +0200
Message-Id: <1267455868-4533-17-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h   |    2 +-
 drivers/staging/winbond/mlme_s.h |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 4dc6b71..cf09dbe 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -16,7 +16,7 @@ struct wbsoft_priv {
 
 	struct wb35_local_para sLocalPara;	// Myself connected parameters
 
-	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
+	struct wb35_mlme_frame sMlmeFrame;	// connect to peerSTA parameters
 
 	struct wb35_mto_params sMtoPara;	// MTO_struct ...
 	struct hw_data sHwData;	//For HAL
diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index 2126d13..88f9666 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -131,8 +131,7 @@
 #define boMLME_IdleScanState(_BB_)	(_BB_->wState==IDLE_SCAN)
 #define boMLME_FoundSTAinfo(_CC_)	(_CC_->wState>=IDLE_SCAN)
 
-typedef struct _MLME_FRAME
-{
+struct wb35_mlme_frame {
 	//NDIS_PACKET		MLME_Packet;
 	s8 *			pMMPDU;
 	u16			len;
@@ -156,7 +155,7 @@ typedef struct _MLME_FRAME
 	u16		wNumRxMMPDUInMLME; 	// Number of the Rx MMPDU
 	u16		reserved_1;			//  in MLME.
                     	            //  excluding the discarded
-} MLME_FRAME, *psMLME_FRAME;
+};
 
 typedef struct _RXDATA
 {
-- 
1.6.3.3

