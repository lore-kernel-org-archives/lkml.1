Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbZLRVKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbZLRVKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932932AbZLRVI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:27 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:33529 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 6/8] w35und: Remove unused typedef TXRETRY_REC
Date: Fri, 18 Dec 2009 23:08:20 +0200
Message-Id: <1261170502-1479-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261170502-1479-5-git-send-email-penberg@cs.helsinki.fi>
References: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-3-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-4-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-5-git-send-email-penberg@cs.helsinki.fi>
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
1.6.0.4

