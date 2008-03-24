Return-Path: <linux-kernel-owner+w=401wt.eu-S1762665AbYCXPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665AbYCXPOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbYCXPOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:14:24 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60509 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760452AbYCXPOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:14:23 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org
Subject: [PATCH] kbuild: silence documentation GEN xml messages according to $(quiet)
Date: Mon, 24 Mar 2008 11:16:55 -0400
Message-Id: <1206371815-32376-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 Documentation/DocBook/Makefile |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
index 300e170..f6a4ba3 100644
--- a/Documentation/DocBook/Makefile
+++ b/Documentation/DocBook/Makefile
@@ -186,8 +186,11 @@ quiet_cmd_fig2png = FIG2PNG $@
 
 ###
 # Rule to convert a .c file to inline XML documentation
+       gen_xml = :
+ quiet_gen_xml = echo '  GEN     $@'
+silent_gen_xml = :
 %.xml: %.c
-	@echo '  GEN     $@'
+	@$($(quiet)gen_xml)
 	@(                            \
 	   echo "<programlisting>";   \
 	   expand --tabs=8 < $< |     \
-- 
1.5.4.4

