Return-Path: <linux-kernel-owner+w=401wt.eu-S1761904AbZLPJGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761904AbZLPJGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 04:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761868AbZLPJGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 04:06:00 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761840AbZLPJFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 04:05:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Joe Perches <joe@perches.com>,
       Jens Rosenboom <jens@mcbone.net>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] lib/vsprintf.c: document more vsnprintf extensions
Date: Wed, 16 Dec 2009 10:05:46 +0100
Message-Id: <1260954346-14369-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
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

These were added in

9ac6e44 (lib/vsprintf.c: add %pU to print UUID/GUIDs)
c7dabef (vsprintf: use %pR, %pr instead of %pRt, %pRf)
8a27f7c (lib/vsprintf.c: Add "%pI6c" - print pointer as compressed ipv6 address)
4aa9960 (printk: add %I4, %I6, %i4, %i6 format specifiers)
dd45c9c (printk: add %pM format specifier for MAC addresses)

but only added comments to pointer() not vsnprintf() that is refered to
by printk's comments.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Joe Perches <joe@perches.com>
Cc: Jens Rosenboom <jens@mcbone.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 lib/vsprintf.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 735343f..d4996cf 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1179,7 +1179,18 @@ qualifier:
  * %ps output the name of a text symbol without offset
  * %pF output the name of a function pointer with its offset
  * %pf output the name of a function pointer without its offset
- * %pR output the address range in a struct resource
+ * %pR output the address range in a struct resource with decoded flags
+ * %pr output the address range in a struct resource with raw flags
+ * %pM output a 6-byte MAC address with colons
+ * %pm output a 6-byte MAC address without colons
+ * %pI4 print an IPv4 address without leading zeros
+ * %pi4 print an IPv4 address with leading zeros
+ * %pI6 print an IPv6 address with colons
+ * %pi6 print an IPv6 address without colons
+ * %pI6c print an IPv6 address as specified by
+ *   http://www.ietf.org/id/draft-kawamura-ipv6-text-representation-03.txt
+ * %pU[bBlL] print a UUID/GUID in big or little endian using lower or upper
+ *   case.
  * %n is ignored
  *
  * The return value is the number of characters which would
-- 
1.6.5.2

