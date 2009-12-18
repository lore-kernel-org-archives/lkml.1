Return-Path: <linux-kernel-owner+w=401wt.eu-S933059AbZLRVIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933059AbZLRVIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933022AbZLRVI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:08:29 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56238 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863AbZLRVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:08:25 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 8/8] w35und: Remove unused typedefs MLME_DEAUTHREQ_PARA and MLME_DISASSOCREQ_PARA
Date: Fri, 18 Dec 2009 23:08:22 +0200
Message-Id: <1261170502-1479-8-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1261170502-1479-7-git-send-email-penberg@cs.helsinki.fi>
References: <1261170502-1479-1-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-2-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-3-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-4-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-5-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-6-git-send-email-penberg@cs.helsinki.fi>
 <1261170502-1479-7-git-send-email-penberg@cs.helsinki.fi>
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
1.6.0.4

