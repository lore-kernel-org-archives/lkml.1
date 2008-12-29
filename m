Return-Path: <linux-kernel-owner+w=401wt.eu-S1755645AbYL2Nz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645AbYL2Nz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbYL2NwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:52:04 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36127 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYL2Nvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:51 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 02/13] kconfig: explain symbol value defaults
Date: Mon, 29 Dec 2008 14:53:12 +0100
Message-Id: <1230558803-7168-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a few comments - no functional change.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/expr.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 9d4cba1..455f2c8 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -65,9 +65,13 @@ enum symbol_type {
 	S_UNKNOWN, S_BOOLEAN, S_TRISTATE, S_INT, S_HEX, S_STRING, S_OTHER
 };
 
+/* enum values are used as index to symbol.def[] */
 enum {
 	S_DEF_USER,		/* main user value */
-	S_DEF_AUTO,
+	S_DEF_AUTO,		/* values read from auto.conf */
+	S_DEF_DEF3,		/* Reserved for UI usage */
+	S_DEF_DEF4,		/* Reserved for UI usage */
+	S_DEF_COUNT
 };
 
 struct symbol {
@@ -75,7 +79,7 @@ struct symbol {
 	char *name;
 	enum symbol_type type;
 	struct symbol_value curr;
-	struct symbol_value def[4];
+	struct symbol_value def[S_DEF_COUNT];
 	tristate visible;
 	int flags;
 	struct property *prop;
-- 
1.6.0.2.GIT

