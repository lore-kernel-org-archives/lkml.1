Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0BRS62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:58:28 -0500
Received: from smtp.nokia.com ([192.100.122.233]:51757 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756070Ab0BRS5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:57:24 -0500
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 03/12] staging: remove unused methods
Date: Thu, 18 Feb 2010 20:55:42 +0200
Message-Id: <1266519351-3218-4-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
References: <1266519351-3218-1-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-2-git-send-email-andy.shevchenko@gmail.com>
 <1266519351-3218-3-git-send-email-andy.shevchenko@gmail.com>
X-OriginalArrivalTime: 18 Feb 2010 18:57:15.0015 (UTC) FILETIME=[2F7F0170:01CAB0CC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>

There are two methods to convert hex value to binary format. This certain
methods aren't used anywhere in kernel.

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/staging/otus/apdbg.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/otus/apdbg.c b/drivers/staging/otus/apdbg.c
index 0eb93f1..30d07ef 100644
--- a/drivers/staging/otus/apdbg.c
+++ b/drivers/staging/otus/apdbg.c
@@ -90,9 +90,6 @@ struct zdap_ioctl {
 
 #endif
 
-char hex(char);
-unsigned char asctohex(char *str);
-
 char *prgname;
 
 int set_ioctl(int sock, struct ifreq *req)
@@ -380,25 +377,3 @@ fail:
 	exit(0);
 }
 
-unsigned char asctohex(char *str)
-{
-	unsigned char value;
-
-	value = hex(*str) & 0x0f;
-	value = value << 4;
-	str++;
-	value |= hex(*str) & 0x0f;
-
-	return value;
-}
-
-char hex(char v)
-{
-	if (isdigit(v))
-		return v - '0';
-	else if (isxdigit(v))
-		return tolower(v) - 'a' + 10;
-	else
-		return 0;
-}
-
-- 
1.5.6.5

