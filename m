Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab0CAPO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:57 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34562 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab0CAPOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:54 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 24/26] w35und: Convert _TXVGA_FOR_50 typedef to struct wb35_txvga_for_50
Date: Mon,  1 Mar 2010 17:04:26 +0200
Message-Id: <1267455868-4533-24-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbhal_s.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index d8c32c0..bcb709f 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -371,10 +371,10 @@ struct wb35_descriptor {		// Skip length = 8 DWORD
 #define MAX_TXVGA_EEPROM	9	//How many word(u16) of EEPROM will be used for TxVGA
 #define MAX_RF_PARAMETER	32
 
-typedef struct _TXVGA_FOR_50 {
+struct wb35_txvga_for_50 {
 	u8      ChanNo;
 	u8      TxVgaValue;
-} TXVGA_FOR_50;
+};
 
 
 //=====================================================================
@@ -497,7 +497,7 @@ struct hw_data {
 
 	u8		TxVgaSettingInEEPROM[ (((MAX_TXVGA_EEPROM*2)+3) & ~0x03) ]; // 20060621 For backup EEPROM value
 	u8		TxVgaFor24[16]; // Max is 14, 2 for alignment
-	TXVGA_FOR_50	TxVgaFor50[36];	// 35 channels in 5G. 35x2 = 70 byte. 2 for alignments
+	struct wb35_txvga_for_50	TxVgaFor50[36];	// 35 channels in 5G. 35x2 = 70 byte. 2 for alignments
 
 	u16		Scan_Interval;
 	u16		RESERVED6;
-- 
1.6.3.3

