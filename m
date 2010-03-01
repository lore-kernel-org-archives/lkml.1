Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534Ab0CAPMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:12:53 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46306 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0CAPMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:48 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 09/26] w35und: Remove unused struct _Reason_Code
Date: Mon,  1 Mar 2010 17:04:11 +0200
Message-Id: <1267455868-4533-9-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mlme_s.h |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index ea12684..1217a1c 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -165,14 +165,6 @@ typedef struct _AUTHREQ {
 
 } MLME_AUTHREQ_PARA, *psMLME_AUTHREQ_PARA;
 
-struct _Reason_Code {
-
-	u8	peerMACaddr[MAC_ADDR_LENGTH];
-	u16	wReasonCode;
-};
-typedef struct _Reason_Code MLME_DEAUTHREQ_PARA, *psMLME_DEAUTHREQ_PARA;
-typedef struct _Reason_Code MLME_DISASSOCREQ_PARA, *psMLME_DISASSOCREQ_PARA;
-
 typedef struct _ASSOCREQ {
   u8       PeerSTAAddr[MAC_ADDR_LENGTH];
   u16       CapabilityInfo;
-- 
1.6.3.3

