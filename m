Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab0CAPOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:55 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:57879 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0CAPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:35 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 05/26] w35und: Remove unused enum enum_TxRate
Date: Mon,  1 Mar 2010 17:04:07 +0200
Message-Id: <1267455868-4533-5-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mac_structures.h |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/winbond/mac_structures.h b/drivers/staging/winbond/mac_structures.h
index 8a9c5e8..861b471 100644
--- a/drivers/staging/winbond/mac_structures.h
+++ b/drivers/staging/winbond/mac_structures.h
@@ -175,24 +175,6 @@ enum enum_MMPDUResultCode
 } WB_MMPDURESULTCODE, *PWB_MMPDURESULTCODE;
 */
 
-//===========================================================
-// enum_TxRate --
-//   Define the transmission constants based on W89C32 MAC
-//   target specification.
-//===========================================================
-typedef enum enum_TxRate
-{
-    TXRATE_1M               = 0,
-    TXRATE_2MLONG           = 2,
-    TXRATE_2MSHORT          = 3,
-    TXRATE_55MLONG          = 4,
-    TXRATE_55MSHORT         = 5,
-    TXRATE_11MLONG          = 6,
-    TXRATE_11MSHORT         = 7,
-    TXRATE_AUTO             = 255           // PD43 20021108
-} WB_TXRATE, *PWB_TXRATE;
-
-
 #define	RATE_BITMAP_1M				1
 #define	RATE_BITMAP_2M				2
 #define	RATE_BITMAP_5dot5M			5
-- 
1.6.3.3

