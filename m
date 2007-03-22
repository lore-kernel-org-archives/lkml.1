Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbXCVCab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbXCVCab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 22:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXCVCab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 22:30:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38765 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbXCVCa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 22:30:29 -0400
Date: Wed, 21 Mar 2007 19:27:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: p.hardwick@option.com, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] nozomi: use NULL for pointers
Message-Id: <20070321192734.c6583a6c.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointers:
drivers/char/nozomi.c:1028:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1029:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1031:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1032:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1034:70: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1035:70: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1037:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1039:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1040:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1042:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1043:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1045:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1046:68: warning: Using plain integer as NULL pointer
drivers/char/nozomi.c:1048:64: warning: Using plain integer as NULL pointer

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/char/nozomi.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- linux-2.6.21-rc4-mm1.orig/drivers/char/nozomi.c
+++ linux-2.6.21-rc4-mm1/drivers/char/nozomi.c
@@ -1025,27 +1025,27 @@ static char *interrupt2str(u16 interrupt
 	static char buf[TMP_BUF_MAX];
 	char *p = buf;
 
-	interrupt & MDM_DL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL1 ") : 0;
-	interrupt & MDM_DL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL2 ") : 0;
+	interrupt & MDM_DL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL1 ") : NULL;
+	interrupt & MDM_DL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_DL2 ") : NULL;
 
-	interrupt & MDM_UL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL1 ") : 0;
-	interrupt & MDM_UL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL2 ") : 0;
+	interrupt & MDM_UL1 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL1 ") : NULL;
+	interrupt & MDM_UL2 ? p += snprintf(p, TMP_BUF_MAX, "MDM_UL2 ") : NULL;
 
-	interrupt & DIAG_DL1 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL1 ") : 0;
-	interrupt & DIAG_DL2 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL2 ") : 0;
+	interrupt & DIAG_DL1 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL1 ") : NULL;
+	interrupt & DIAG_DL2 ? p += snprintf(p, TMP_BUF_MAX, "DIAG_DL2 ") : NULL;
 
-	interrupt & DIAG_UL ? p += snprintf(p, TMP_BUF_MAX, "DIAG_UL ") : 0;
+	interrupt & DIAG_UL ? p += snprintf(p, TMP_BUF_MAX, "DIAG_UL ") : NULL;
 
-	interrupt & APP1_DL ? p += snprintf(p, TMP_BUF_MAX, "APP1_DL ") : 0;
-	interrupt & APP2_DL ? p += snprintf(p, TMP_BUF_MAX, "APP2_DL ") : 0;
+	interrupt & APP1_DL ? p += snprintf(p, TMP_BUF_MAX, "APP1_DL ") : NULL;
+	interrupt & APP2_DL ? p += snprintf(p, TMP_BUF_MAX, "APP2_DL ") : NULL;
 
-	interrupt & APP1_UL ? p += snprintf(p, TMP_BUF_MAX, "APP1_UL ") : 0;
-	interrupt & APP2_UL ? p += snprintf(p, TMP_BUF_MAX, "APP2_UL ") : 0;
+	interrupt & APP1_UL ? p += snprintf(p, TMP_BUF_MAX, "APP1_UL ") : NULL;
+	interrupt & APP2_UL ? p += snprintf(p, TMP_BUF_MAX, "APP2_UL ") : NULL;
 
-	interrupt & CTRL_DL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_DL ") : 0;
-	interrupt & CTRL_UL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_UL ") : 0;
+	interrupt & CTRL_DL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_DL ") : NULL;
+	interrupt & CTRL_UL ? p += snprintf(p, TMP_BUF_MAX, "CTRL_UL ") : NULL;
 
-	interrupt & RESET ? p += snprintf(p, TMP_BUF_MAX, "RESET ") : 0;
+	interrupt & RESET ? p += snprintf(p, TMP_BUF_MAX, "RESET ") : NULL;
 
 	return buf;
 }
