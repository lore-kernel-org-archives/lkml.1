Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYDUNYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYDUNYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760020AbYDUNTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:19:09 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:8449 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbYDUNTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:19:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:in-reply-to:references:date:subject:cc:from;
        b=EeXuA4d9v3ObWaFfVAxyRiAxRRJrXTmTYDg3Cl3ZT85EmmzuX2Y7bMHJGDm7FvAymuhihuBhTIR3C2xPc5MwAJhw6k4mGxYrqhXn8/pTYnGEyMXHFWM/BQGWDTTQguUlobtOr6KVLNJg3Wc1m4HYlVXYkjW6zX0x3QO5wxsoy4Y=
Message-Id: <f23c1d7579211c801494c7a8d6fca12905f7949f.1208783694.git.dmitry.torokhov@gmail.com>
In-Reply-To: <cover.1208783694.git.dmitry.torokhov@gmail.com>
References: <cover.1208783694.git.dmitry.torokhov@gmail.com>
Date: Wed, 2 Apr 2008 10:02:06 -0400
Subject: [PATCH 09/37] Input: appletouch - add product IDs for the 4th generation MacBooks
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz, akpm@linux-foundation.org
From: Tobias Mueller <dmitry.torokhov@gmail.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/mouse/appletouch.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index b4423a4..8dd3942 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -62,6 +62,10 @@
 #define GEYSER4_ISO_PRODUCT_ID	0x021B
 #define GEYSER4_JIS_PRODUCT_ID	0x021C
 
+#define GEYSER4_HF_ANSI_PRODUCT_ID	0x0229
+#define GEYSER4_HF_ISO_PRODUCT_ID	0x022A
+#define GEYSER4_HF_JIS_PRODUCT_ID	0x022B
+
 #define ATP_DEVICE(prod)					\
 	.match_flags = USB_DEVICE_ID_MATCH_DEVICE |		\
 		       USB_DEVICE_ID_MATCH_INT_CLASS |		\
@@ -93,6 +97,10 @@ static struct usb_device_id atp_table [] = {
 	{ ATP_DEVICE(GEYSER4_ISO_PRODUCT_ID) },
 	{ ATP_DEVICE(GEYSER4_JIS_PRODUCT_ID) },
 
+	{ ATP_DEVICE(GEYSER4_HF_ANSI_PRODUCT_ID) },
+	{ ATP_DEVICE(GEYSER4_HF_ISO_PRODUCT_ID) },
+	{ ATP_DEVICE(GEYSER4_HF_JIS_PRODUCT_ID) },
+
 	/* Terminating entry */
 	{ }
 };
@@ -217,7 +225,10 @@ static inline int atp_is_geyser_3(struct atp *dev)
 		(productId == GEYSER3_JIS_PRODUCT_ID) ||
 		(productId == GEYSER4_ANSI_PRODUCT_ID) ||
 		(productId == GEYSER4_ISO_PRODUCT_ID) ||
-		(productId == GEYSER4_JIS_PRODUCT_ID);
+		(productId == GEYSER4_JIS_PRODUCT_ID) ||
+		(productId == GEYSER4_HF_ANSI_PRODUCT_ID) ||
+		(productId == GEYSER4_HF_ISO_PRODUCT_ID) ||
+		(productId == GEYSER4_HF_JIS_PRODUCT_ID);
 }
 
 /*
-- 
1.5.5.rc2.6.gf58d


