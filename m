Return-Path: <linux-kernel-owner+w=401wt.eu-S1761144AbZDSNmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144AbZDSNmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 09:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760174AbZDSNlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 09:41:24 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:53339 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758231AbZDSNlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 09:41:21 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH 02/10] kconfig: add a note about the deps to the 'silentoldconfig' help
Date: Sun, 19 Apr 2009 15:41:19 +0200
Message-Id: <1240148487-27584-3-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.rc1.24.g467d50
In-Reply-To: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
References: <1240148487-27584-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX19Fm8IvMtol7+35WN7B8KGNkbpy+iWBMWeCv9Ji
	fqnCX+glr+FCFn/cArYJ5/e6dP1LVKApKr+bdDIlGzkLFKtVar
	XD16KfQu4AVnC/HUfGgA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Markus Heidelberg <markus.heidelberg@web.de>
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
1.6.3.rc1.24.g467d50

