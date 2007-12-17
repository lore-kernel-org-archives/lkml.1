Return-Path: <linux-kernel-owner+w=401wt.eu-S1765903AbXLQTsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765903AbXLQTsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761534AbXLQTcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:32:09 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3039 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761404AbXLQTcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:32:01 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Armin Schindler <mac@melware.de>, Karsten Keil <kkeil@suse.de>,
       isdn4linux@listserv.isdn4linux.de
Subject: [PATCH] drivers/isdn/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:38 -0800
Message-Id: <1197919875-5288-39-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/hardware/eicon/debuglib.h |    2 +-
 drivers/isdn/hardware/eicon/di.c       |    2 +-
 drivers/isdn/hardware/eicon/message.c  |    2 +-
 drivers/isdn/hysdn/hycapi.c            |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/debuglib.h b/drivers/isdn/hardware/eicon/debuglib.h
index 11b3b9e..016410c 100644
--- a/drivers/isdn/hardware/eicon/debuglib.h
+++ b/drivers/isdn/hardware/eicon/debuglib.h
@@ -177,7 +177,7 @@ DBG_DECL(PRV3)
 } }
 #endif
 /*
- * For event level debug use a separate define, the paramete are
+ * For event level debug use a separate define, the parameter are
  * different and cause compiler errors on some systems.
  */
 #define DBG_EVL_ID(args) \
diff --git a/drivers/isdn/hardware/eicon/di.c b/drivers/isdn/hardware/eicon/di.c
index ce8df38..10760b3 100644
--- a/drivers/isdn/hardware/eicon/di.c
+++ b/drivers/isdn/hardware/eicon/di.c
@@ -285,7 +285,7 @@ byte pr_dpc(ADAPTER * a)
                 a->ram_in(a, &RcIn->RcId),
                 a->ram_in(a, &RcIn->RcCh),
                 a->ram_inw(a, &RcIn->Reference),
-                tmp[0],  /* type of extended informtion */
+                tmp[0],  /* type of extended information */
                 tmp[1]); /* extended information        */
         a->ram_out(a, &RcIn->Rc, 0);
       }
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index ccd35d0..b9177ca 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -4941,7 +4941,7 @@ void sig_ind(PLCI   * plci)
       /* b = IE1                */
       /* S = IE1 length + cont. */
       /* b = IE2                */
-      /* S = IE2 lenght + cont. */
+      /* S = IE2 length + cont. */
       sendf(plci->appl,
         _MANUFACTURER_I,
         Id,
diff --git a/drivers/isdn/hysdn/hycapi.c b/drivers/isdn/hysdn/hycapi.c
index f854501..d3999a8 100644
--- a/drivers/isdn/hysdn/hycapi.c
+++ b/drivers/isdn/hysdn/hycapi.c
@@ -541,7 +541,7 @@ hycapi_rx_capipkt(hysdn_card * card, unsigned char *buf, unsigned short len)
 	}
 	ctrl = &cinfo->capi_ctrl;
 	if(len < CAPI_MSG_BASELEN) {
-		printk(KERN_ERR "HYSDN Card%d: invalid CAPI-message, lenght %d!\n",
+		printk(KERN_ERR "HYSDN Card%d: invalid CAPI-message, length %d!\n",
 		       card->myid, len);
 		return;
 	}	
-- 
1.5.3.7.949.g2221a6

