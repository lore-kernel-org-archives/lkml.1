Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405Ab0CLP3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 10:29:13 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:56907 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934399Ab0CLP3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 10:29:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hX51eilbQu28LEZY/Vyk+07ynMxVupK3DU2bCjjP8g3ZNBCypHJeLQuk8s+XjsJR0H
         iMFvSlBjU3E960jagkPCOZBPfZsjTl4AyzsIiAgrMMrIJkqjuWvnaDPdb/eQ1uOaguU2
         dMNgVNZFGPIARiV/4jhgbeE0Ao8j5a5Su3Oeo=
From: =?UTF-8?q?Andr=C3=A9=20Silva?= <andre.beat@gmail.com>
To: gregkh@suse.de, linville@tuxdriver.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Andre Silva <andre.beat@gmail.com>
Subject: [PATCH 2/2] Staging: arlan: fixed coding style issues in arlan-proc.c
Date: Fri, 12 Mar 2010 15:28:16 +0000
Message-Id: <1268407696-1649-2-git-send-email-andre.beat@gmail.com>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1268407696-1649-1-git-send-email-andre.beat@gmail.com>
References: <1268407696-1649-1-git-send-email-andre.beat@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Silva <andre.beat@gmail.com>

This is a patch to the arlan-proc.c file that fixes up multiple coding style
errors and warnings found by the checkpatch.pl.
I fixed some issues from my last patch as requested by Joe Perches.

Signed-off-by: Andre Silva <andre.beat@gmail.com>
---
 drivers/staging/arlan/arlan-proc.c |   30 ++++++++++++++++--------------
 1 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/arlan/arlan-proc.c b/drivers/staging/arlan/arlan-proc.c
index 62cd1d0..ee8dbab 100644
--- a/drivers/staging/arlan/arlan-proc.c
+++ b/drivers/staging/arlan/arlan-proc.c
@@ -9,21 +9,23 @@
 
 
 
-#define ARLAN_STR_SIZE 0x2ff0
-#define DEV_ARLAN_INFO 1
-#define DEV_ARLAN 1
-#define SARLG(type, var) {\
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", #var,\
-		READSHMB(priva->card->var));\
-	}
+#define ARLAN_STR_SIZE	0x2ff0
+#define DEV_ARLAN_INFO	1
+#define DEV_ARLAN	1
+#define SARLG(type, var)\
+	do {\
+	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x%x\n", \
+			#var, READSHMB(priva->card->var));\
+	} while (0)
 
-#define SARLBN(type, var, nn) {\
-	pos += sprintf(arlan_drive_info+pos, "%s\t=\t0x", #var);\
-	for (i = 0; i < nn; i++)\
-		pos += sprintf(arlan_drive_info+pos, "%02x",\
-			READSHMB(priva->card->var[i]));\
+#define SARLBN(type, var, nn)\
+	do {\
+		SARLG(type, var);\
+		for (i = 0; i < nn; i++)\
+			pos += sprintf(arlan_drive_info + pos, "%02x",\
+				READSHMB(priva->card->var[i]));\
 		pos += sprintf(arlan_drive_info+pos, "\n");\
-	}
+	} while (0)
 
 #define SARLBNpln(type, var, nn) {\
 	for (i = 0; i < nn; i++)\
-- 
1.7.0.2

