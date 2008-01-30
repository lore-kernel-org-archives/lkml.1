Return-Path: <linux-kernel-owner+w=401wt.eu-S1760634AbYA3PMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634AbYA3PMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 10:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYA3PM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 10:12:27 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35416 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbYA3PM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 10:12:26 -0500
Message-ID: <47A093D6.3000105@tiscali.nl>
Date: Wed, 30 Jan 2008 16:12:22 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: sam@ravnborg.org
CC: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][scripts/{genksyms/parse.c,kconfig/zconf.tab)_shipped] duplicate
 YYSTYPE_IS_TRIVIAL =>1st *_DECLARED
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Untested patch, please confirm it's the right fix.
--
duplicate YYSTYPE_IS_TRIVIAL, 2nd should be YYSTYPE_IS_DECLARED

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/scripts/genksyms/parse.c_shipped b/scripts/genksyms/parse.c_shipped
index 3e6079f..61f7539 100644
--- a/scripts/genksyms/parse.c_shipped
+++ b/scripts/genksyms/parse.c_shipped
@@ -377,7 +377,7 @@ void free (void *); /* INFRINGES ON USER NAME SPACE */
 
 #if (! defined yyoverflow \
      && (! defined __cplusplus \
-	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
+	 || (defined YYSTYPE_IS_DECLARED && YYSTYPE_IS_TRIVIAL)))
 
 /* A type that is properly aligned for any stack member.  */
 union yyalloc
diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index d22d924..9a7bcc7 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -389,7 +389,7 @@ void free (void *); /* INFRINGES ON USER NAME SPACE */
 
 #if (! defined yyoverflow \
      && (! defined __cplusplus \
-	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))
+	 || (defined YYSTYPE_IS_DECLARED && YYSTYPE_IS_TRIVIAL)))
 
 /* A type that is properly aligned for any stack member.  */
 union yyalloc
