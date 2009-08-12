Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566AbZHLIDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566AbZHLIDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZHLIDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:03:44 -0400
Received: from smtp6.welho.com ([213.243.153.40]:57030 "EHLO smtp6.welho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179AbZHLIDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:03:39 -0400
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 5/7] w35und: Remove unused struct _STATISTICS_INFO
Date: Wed, 12 Aug 2009 11:03:37 +0300
Message-Id: <1250064219-7372-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>
References: <1250064219-7372-1-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-2-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-3-git-send-email-penberg@cs.helsinki.fi>
 <1250064219-7372-4-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mto.h |   49 -----------------------------------------
 1 files changed, 0 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index 56f2465..5990ba3 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -209,55 +209,6 @@ typedef struct {
 	u8 tx_retry_rate;
 } TXRETRY_REC;
 
-typedef struct _STATISTICS_INFO {
-	u32   Rate54M;
-	u32   Rate48M;
-	u32   Rate36M;
-	u32   Rate24M;
-	u32   Rate18M;
-	u32   Rate12M;
-	u32   Rate9M;
-	u32   Rate6M;
-	u32   Rate11MS;
-	u32   Rate11ML;
-	u32   Rate55MS;
-	u32   Rate55ML;
-	u32   Rate2MS;
-	u32   Rate2ML;
-	u32   Rate1M;
-	u32   Rate54MOK;
-	u32   Rate48MOK;
-	u32   Rate36MOK;
-	u32   Rate24MOK;
-	u32   Rate18MOK;
-	u32   Rate12MOK;
-	u32   Rate9MOK;
-	u32   Rate6MOK;
-	u32   Rate11MSOK;
-	u32   Rate11MLOK;
-	u32   Rate55MSOK;
-	u32   Rate55MLOK;
-	u32   Rate2MSOK;
-	u32   Rate2MLOK;
-	u32   Rate1MOK;
-	u32   SQ3;
-	s32   RSSIAVG;
-	s32   RSSIMAX;
-	s32   TXRATE;
-	s32   TxRetryRate;
-	s32   BSS_PK_CNT;
-	s32   NIDLESLOT;
-	s32   SLOT_CNT;
-	s32   INTERF_CNT;
-	s32   GAP_CNT;
-	s32   DS_EVM;
-	s32   RcvBeaconNum;
-	s32   RXRATE;
-	s32   RxBytes;
-	s32   TxBytes;
-	s32   Antenna;
-} STATISTICS_INFO, *PSTATISTICS_INFO;
-
 extern void MTO_Init(struct wbsoft_priv *);
 extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
 extern void MTO_SetDTORateRange(struct wbsoft_priv *, u8 *, u8);
-- 
1.5.6.3

