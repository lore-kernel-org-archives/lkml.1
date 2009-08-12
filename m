Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZHLIE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZHLIE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbZHLIEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:04:54 -0400
Received: from smtp6.welho.com ([213.243.153.40]:57040 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbZHLIDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:03:41 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 6/7] w35und: Convert typedef MTO_PARAMETERS to struct wb35_mto_param
Date: Wed, 12 Aug 2009 11:03:38 +0300
Message-Id: <1250064219-7372-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/core.h |    2 +-
 drivers/staging/winbond/mto.h  |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/core.h b/drivers/staging/winbond/core.h
index 42c9868..7d4bd5e 100644
--- a/drivers/staging/winbond/core.h
+++ b/drivers/staging/winbond/core.h
@@ -18,7 +18,7 @@ struct wbsoft_priv {
 
 	MLME_FRAME sMlmeFrame;	// connect to peerSTA parameters
 
-	MTO_PARAMETERS sMtoPara;	// MTO_struct ...
+	struct wb35_mto_params sMtoPara;	// MTO_struct ...
 	struct hw_data sHwData;	//For HAL
 	struct wb35_mds Mds;
 
diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index 5990ba3..e6d2ccb 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -50,8 +50,7 @@ typedef enum {
 //
 //   Defines the parameters used in the MAC Throughput Optimization algorithm
 //============================================================================
-typedef struct _MTO_PARAMETERS
-{
+struct wb35_mto_params {
 	u8      Th_Fixant;
 	u8      Th_Cnt;
 	u8      Th_SQ3;
@@ -130,7 +129,7 @@ typedef struct _MTO_PARAMETERS
 	s32		RSSI_high;
 	s32		RSSI_low;
 
-} MTO_PARAMETERS, *PMTO_PARAMETERS;
+};
 
 
 #define MTO_DATA()                  (adapter->sMtoPara)
-- 
1.5.6.3

