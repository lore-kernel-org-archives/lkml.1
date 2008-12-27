Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYL0JY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYL0JY0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 04:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYL0JXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 04:23:24 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:50727 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbYL0JXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 04:23:22 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/4] kconfig: explain symbol value defaults
Date: Sat, 27 Dec 2008 10:24:51 +0100
Message-Id: <1230369894-10510-1-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081227090339.GA6279@uranus.ravnborg.org>
References: <20081227090339.GA6279@uranus.ravnborg.org>
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

