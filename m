Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0CAPNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:13:54 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46340 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0CAPMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:49 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 12/26] w35und: Remove unused structs _AUTHREQ, _ASSOCREQ, and _REASSOCREQ
Date: Mon,  1 Mar 2010 17:04:14 +0200
Message-Id: <1267455868-4533-12-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mlme_s.h |   21 ---------------------
 1 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index 1217a1c..cab3b38 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -158,27 +158,6 @@ typedef struct _MLME_FRAME
                     	            //  excluding the discarded
 } MLME_FRAME, *psMLME_FRAME;
 
-typedef struct _AUTHREQ {
-
-	u8 	peerMACaddr[MAC_ADDR_LENGTH];
-	u16	wAuthAlgorithm;
-
-} MLME_AUTHREQ_PARA, *psMLME_AUTHREQ_PARA;
-
-typedef struct _ASSOCREQ {
-  u8       PeerSTAAddr[MAC_ADDR_LENGTH];
-  u16       CapabilityInfo;
-  u16       ListenInterval;
-
-}__attribute__ ((packed)) MLME_ASSOCREQ_PARA, *psMLME_ASSOCREQ_PARA;
-
-typedef struct _REASSOCREQ {
-  u8       NewAPAddr[MAC_ADDR_LENGTH];
-  u16       CapabilityInfo;
-  u16       ListenInterval;
-
-}__attribute__ ((packed)) MLME_REASSOCREQ_PARA, *psMLME_REASSOCREQ_PARA;
-
 typedef struct _MLMECALLBACK {
 
   u8 	*psFramePtr;
-- 
1.6.3.3

