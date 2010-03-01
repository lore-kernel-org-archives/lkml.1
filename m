Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649Ab0CAPNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:13:30 -0500
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:46342 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0CAPMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:12:51 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 07/26] w35und: Remove unused struct _SUITE_SELECTOR_
Date: Mon,  1 Mar 2010 17:04:09 +0200
Message-Id: <1267455868-4533-7-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mac_structures.h |   50 ------------------------------
 1 files changed, 0 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 5d2d642..12013d8 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -418,36 +418,6 @@ struct Extended_Supported_Rates_Element
 #define OUI_CIPHER_CCMP				0x04
 #define OUI_CIPHER_WEP_104			0x05
 
-typedef struct _SUITE_SELECTOR_
-{
-	union
-	{
-		u8	Value[4];
-		struct _SUIT_
-		{
-			u8	OUI[3];
-			u8	Type;
-		}SuitSelector;
-	};
-}SUITE_SELECTOR;
-
-//--  WPA  --
-struct	RSN_Information_Element
-{
-	u8					Element_ID;
-	u8					Length;
-	SUITE_SELECTOR	OuiWPAAdditional;//WPA version 2.0 additional field, and should be 00:50:F2:01
-	u16					Version;
-	SUITE_SELECTOR		GroupKeySuite;
-	u16					PairwiseKeySuiteCount;
-	SUITE_SELECTOR		PairwiseKeySuite[1];
-}__attribute__ ((packed));
-struct RSN_Auth_Sub_Information_Element
-{
-	u16				AuthKeyMngtSuiteCount;
-	SUITE_SELECTOR	AuthKeyMngtSuite[1];
-}__attribute__ ((packed));
-
 //--  WPA2  --
 struct RSN_Capability_Element
 {
@@ -479,26 +449,6 @@ struct RSN_Capability_Element
   }__attribute__ ((packed)) ;
 }__attribute__ ((packed)) ;
 
-#ifdef _WPA2_
-struct	WPA2_RSN_Information_Element
-{
-	u8					Element_ID;
-	u8					Length;
-	u16					Version;
-	SUITE_SELECTOR		GroupKeySuite;
-	u16					PairwiseKeySuiteCount;
-	SUITE_SELECTOR		PairwiseKeySuite[1];
-
-}__attribute__ ((packed));
-
-struct WPA2_RSN_Auth_Sub_Information_Element
-{
-	u16				AuthKeyMngtSuiteCount;
-	SUITE_SELECTOR	AuthKeyMngtSuite[1];
-}__attribute__ ((packed));
-
-
-#endif //enddef _WPA2_
 //============================================================
 // MAC Frame structure (different type) and subfield structure
 //============================================================
-- 
1.6.3.3

