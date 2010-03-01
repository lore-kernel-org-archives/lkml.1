Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab0CAPOh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:37 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:57867 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab0CAPOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:34 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 06/26] w35und: Remove unused struct _PMKID
Date: Mon,  1 Mar 2010 17:04:08 +0200
Message-Id: <1267455868-4533-6-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mac_structures.h |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 861b471..5d2d642 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -480,11 +480,6 @@ struct RSN_Capability_Element
 }__attribute__ ((packed)) ;
 
 #ifdef _WPA2_
-typedef struct _PMKID
-{
-  u8 pValue[16];
-}PMKID;
-
 struct	WPA2_RSN_Information_Element
 {
 	u8					Element_ID;
@@ -503,12 +498,6 @@ struct WPA2_RSN_Auth_Sub_Information_Element
 }__attribute__ ((packed));
 
 
-struct PMKID_Information_Element
-{
-	u16				PMKID_Count;
-	PMKID pmkid [16] ;
-}__attribute__ ((packed));
-
 #endif //enddef _WPA2_
 //============================================================
 // MAC Frame structure (different type) and subfield structure
-- 
1.6.3.3

