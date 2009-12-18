Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbZLRJl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbZLRJl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZLRJl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:41:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39619 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbZLRJlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:41:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vsnprintf: fix reference for compressed ipv6 addresses
Date: Fri, 18 Dec 2009 10:41:48 +0100
Message-Id: <1261129308-5568-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <20091218085345.GA25816@orion.carnet.hr>
References: <20091218085345.GA25816@orion.carnet.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reported-by: Josip Rodin <joy@entuzijast.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/vsprintf.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index d4996cf..3b8aeec 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -903,7 +903,7 @@ static char *uuid_string(char *buf, char *end, const u8 *addr,
  *       IPv6 omits the colons (01020304...0f)
  *       IPv4 uses dot-separated decimal with leading 0's (010.123.045.006)
  * - 'I6c' for IPv6 addresses printed as specified by
- *       http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03.txt
+ *       http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
  * - 'U' For a 16 byte UUID/GUID, it prints the UUID/GUID in the form
  *       "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  *       Options for %pU are:
@@ -1188,7 +1188,7 @@ qualifier:
  * %pI6 print an IPv6 address with colons
  * %pi6 print an IPv6 address without colons
  * %pI6c print an IPv6 address as specified by
- *   http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03.txt
+ *   http://tools.ietf.org/html/draft-ietf-6man-text-addr-representation-00
  * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
  *   case.
  * %n is ignored
-- 
1.6.5.2

