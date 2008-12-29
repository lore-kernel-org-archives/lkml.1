Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYL2NyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYL2NyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 08:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbYL2Nv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 08:51:57 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:36143 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbYL2Nvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 08:51:51 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Hannes Eder <hannes@hanneseder.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 11/13] kbuild: disable sparse warning "returning void-valued expression"
Date: Mon, 29 Dec 2008 14:53:21 +0100
Message-Id: <1230558803-7168-11-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081229134402.GA7069@uranus.ravnborg.org>
References: <20081229134402.GA7069@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

The sparse warning -Wreturn-void ("returning void-valued expression")
is off by default, but it is enabled with -Wall, so add
-Wno-return-void to CHECKFLAGS to disable it.

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 09ff7d8..f40e07a 100644
--- a/Makefile
+++ b/Makefile
@@ -320,7 +320,8 @@ KALLSYMS	= scripts/kallsyms
 PERL		= perl
 CHECK		= sparse
 
-CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ -Wbitwise $(CF)
+CHECKFLAGS     := -D__linux__ -Dlinux -D__STDC__ -Dunix -D__unix__ \
+		  -Wbitwise -Wno-return-void $(CF)
 MODFLAGS	= -DMODULE
 CFLAGS_MODULE   = $(MODFLAGS)
 AFLAGS_MODULE   = $(MODFLAGS)
-- 
1.6.0.2.GIT

