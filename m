Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab0CAPQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:16:23 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60576 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab0CAPOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:16 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 08/26] w35und: Remove unused typedef TXRETRY_REC
Date: Mon,  1 Mar 2010 17:04:10 +0200
Message-Id: <1267455868-4533-8-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mto.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/mto.h b/drivers/staging/winbond/mto.h
index 4fe24b0..fb4781d 100644
--- a/drivers/staging/winbond/mto.h
+++ b/drivers/staging/winbond/mto.h
@@ -141,11 +141,6 @@ extern u16  MTO_Frag_Th_Tbl[];
 #define MTO_DATA_RATE()          MTO_Data_Rate_Tbl[MTO_RATE_LEVEL()]
 #define MTO_FRAG_TH()            MTO_Frag_Th_Tbl[MTO_FRAG_TH_LEVEL()]
 
-typedef struct {
-	u8 tx_rate;
-	u8 tx_retry_rate;
-} TXRETRY_REC;
-
 extern void MTO_Init(struct wbsoft_priv *);
 extern void MTO_PeriodicTimerExpired(struct wbsoft_priv *);
 extern void MTO_SetDTORateRange(struct wbsoft_priv *, u8 *, u8);
-- 
1.6.3.3

