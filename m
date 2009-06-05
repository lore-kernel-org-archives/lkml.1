Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZFEXtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZFEXtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZFEXmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:42:00 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45070 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Markus Heidelberg <markus.heidelberg@web.de>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 24/39] kconfig: add a note about the deps to the 'silentoldconfig' help
Date: Sat,  6 Jun 2009 01:42:42 +0200
Message-Id: <1244245377-17441-24-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Heidelberg <markus.heidelberg@web.de>

Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 README                   |    1 +
 scripts/kconfig/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/README b/README
index d6c6c74..7a078ff 100644
--- a/README
+++ b/README
@@ -174,6 +174,7 @@ CONFIGURING the kernel:
 	"make silentoldconfig"
 			   Like above, but avoids cluttering the screen
 			   with questions already answered.
+			   Additionally updates the dependencies.
 	"make defconfig"   Create a ./.config file by using the default
 			   symbol values from arch/$ARCH/defconfig.
 	"make allyesconfig"
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 47e3f2e..5ddf8be 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -83,7 +83,7 @@ help:
 	@echo  '  xconfig	  - Update current config utilising a QT based front-end'
 	@echo  '  gconfig	  - Update current config utilising a GTK based front-end'
 	@echo  '  oldconfig	  - Update current config utilising a provided .config as base'
-	@echo  '  silentoldconfig - Same as oldconfig, but quietly'
+	@echo  '  silentoldconfig - Same as oldconfig, but quietly, additionally update deps'
 	@echo  '  randconfig	  - New config with random answer to all options'
 	@echo  '  defconfig	  - New config with default answer to all options'
 	@echo  '  allmodconfig	  - New config selecting modules when possible'
-- 
1.6.3.rc3.40.g75b44

