Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbYL2NzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbYL2NzR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:55:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbYL2NwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:52:00 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36129 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbYL2Nvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:51 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 03/13] kconfig: add comments to symbol flags
Date: Mon, 29 Dec 2008 14:53:13 +0100
Message-Id: <1230558803-7168-3-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes - only comments.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/expr.h |   34 ++++++++++++++++++----------------
 1 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 455f2c8..0bdb58e 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -88,22 +88,24 @@ struct symbol {
 
 #define for_all_symbols(i, sym) for (i = 0; i < 257; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
 
-#define SYMBOL_CONST		0x0001
-#define SYMBOL_CHECK		0x0008
-#define SYMBOL_CHOICE		0x0010
-#define SYMBOL_CHOICEVAL	0x0020
-#define SYMBOL_VALID		0x0080
-#define SYMBOL_OPTIONAL		0x0100
-#define SYMBOL_WRITE		0x0200
-#define SYMBOL_CHANGED		0x0400
-#define SYMBOL_AUTO		0x1000
-#define SYMBOL_CHECKED		0x2000
-#define SYMBOL_WARNED		0x8000
-#define SYMBOL_DEF		0x10000
-#define SYMBOL_DEF_USER		0x10000
-#define SYMBOL_DEF_AUTO		0x20000
-#define SYMBOL_DEF3		0x40000
-#define SYMBOL_DEF4		0x80000
+#define SYMBOL_CONST      0x0001  /* symbol is const */
+#define SYMBOL_CHECK      0x0008  /* used during dependency checking */
+#define SYMBOL_CHOICE     0x0010  /* start of a choice block (null name) */
+#define SYMBOL_CHOICEVAL  0x0020  /* used as a value in a choice block */
+#define SYMBOL_VALID      0x0080  /* set when symbol.curr is calculated */
+#define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
+#define SYMBOL_WRITE      0x0200  /* ? */
+#define SYMBOL_CHANGED    0x0400  /* ? */
+#define SYMBOL_AUTO       0x1000  /* value from environment variable */
+#define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
+#define SYMBOL_WARNED     0x8000  /* warning has been issued */
+
+/* Set when symbol.def[] is used */
+#define SYMBOL_DEF        0x10000  /* First bit of SYMBOL_DEF */
+#define SYMBOL_DEF_USER   0x10000  /* symbol.def[S_DEF_USER] is valid */
+#define SYMBOL_DEF_AUTO   0x20000  /* symbol.def[S_DEF_AUTO] is valid */
+#define SYMBOL_DEF3       0x40000  /* symbol.def[S_DEF_3] is valid */
+#define SYMBOL_DEF4       0x80000  /* symbol.def[S_DEF_4] is valid */
 
 #define SYMBOL_MAXLENGTH	256
 #define SYMBOL_HASHSIZE		257
-- 
1.6.0.2.GIT

