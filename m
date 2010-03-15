Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0CODpB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:45:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:49042 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab0CODpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:45:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mnB5qnOo3YRFfO/qDdUR1Qcwmi5xrGJ/RTJijv/6jmE7CGkHcKDOxGfeMijpR61+6Q
         3kdJOeapyHwobead6Ery++KgVw7x2lG6R2kGbyoQfjTuiuJireKLjph+NrdcJsmcCzjn
         /LNdnDlzBA2dDCEZGx2eqm2WoxZs48NQW1uTY=
From: Chihau Chau <chihau@gmail.com>
To: gregkh@suse.de
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Chihau Chau <chihau@gmail.com>
Subject: [PATCH] Staging: dream: smd: smd_qmi: fix code style issues
Date: Mon, 15 Mar 2010 00:44:54 -0300
Message-Id: <1268624694-11635-1-git-send-email-chihau@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chihau Chau <chihau@gmail.com>

This fixes some code style issues about to #include <linux/uaccess.h>
instead of <asm/uaccess.h> and some not necessary braces {}.

Signed-off-by: Chihau Chau <chihau@gmail.com>
---
 drivers/staging/dream/smd/smd_qmi.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/dream/smd/smd_qmi.c b/drivers/staging/dream/smd/smd_qmi.c
index 687db14..9e9067f 100644
--- a/drivers/staging/dream/smd/smd_qmi.c
+++ b/drivers/staging/dream/smd/smd_qmi.c
@@ -25,7 +25,7 @@
 #include <linux/miscdevice.h>
 #include <linux/workqueue.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <mach/msm_smd.h>
 
 #define QMI_CTL 0x00
@@ -643,11 +643,10 @@ static int qmi_print_state(struct qmi_ctxt *ctxt, char *buf, int max)
 	}
 
 	i = scnprintf(buf, max, "STATE=%s\n", statename);
-	i += scnprintf(buf + i, max - i, "CID=%d\n",ctxt->wds_client_id);
+	i += scnprintf(buf + i, max - i, "CID=%d\n", ctxt->wds_client_id);
 
-	if (ctxt->state != STATE_ONLINE){
+	if (ctxt->state != STATE_ONLINE)
 		return i;
-	}
 
 	i += scnprintf(buf + i, max - i, "ADDR=%d.%d.%d.%d\n",
 		ctxt->addr[0], ctxt->addr[1], ctxt->addr[2], ctxt->addr[3]);
-- 
1.5.6.3

