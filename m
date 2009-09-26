Return-Path: <linux-kernel-owner+w=401wt.eu-S1752153AbZIZRjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbZIZRjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 13:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZIZRjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 13:39:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:43294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbZIZRjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 13:39:41 -0400
Subject: [PATCH] isdn: Fix HISAX_DE_AOC it should be CONFIG_DE_AOC
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>,
       Hansjoerg Lipp <hjlipp@web.de>, Tilman Schmidt <tilman@imap.cc>,
       isdn4linux@listserv.isdn4linux.de, LKML <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 23:09:07 +0530
Message-Id: <1253986747.4568.69.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


HISAX_DE_AOC is not defined, it should be CONFIG_DE_AOC

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: Armin Schindler <mac@melware.de>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/hisax/l3dss1.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/hisax/l3dss1.c b/drivers/isdn/hisax/l3dss1.c
index a12fa4d..1e5b80b 100644
--- a/drivers/isdn/hisax/l3dss1.c
+++ b/drivers/isdn/hisax/l3dss1.c
@@ -352,7 +352,7 @@ l3dss1_parse_facility(struct PStack *st, struct l3_process *pc,
 			         { l3dss1_dummy_invoke(st, cr, id, ident, p, nlen);
                                    return;
                                  } 
-#ifdef HISAX_DE_AOC
+#ifdef CONFIG_DE_AOC
 			{
 
 #define FOO1(s,a,b) \
@@ -421,9 +421,9 @@ l3dss1_parse_facility(struct PStack *st, struct l3_process *pc,
 #undef FOO1
 
 			}
-#else  /* not HISAX_DE_AOC */
+#else  /* not CONFIG_DE_AOC */
                         l3_debug(st, "invoke break");
-#endif /* not HISAX_DE_AOC */
+#endif /* not CONFIG_DE_AOC */
 			break;
 		case 2:	/* return result */
 			 /* if no process available handle separately */ 
-- 
1.6.0.6


