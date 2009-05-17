Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZEQXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZEQXhf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZEQXgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 19:36:49 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:46379 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491AbZEQXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 19:36:47 -0400
From: Markus Heidelberg <markus.heidelberg@web.de>
To: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       Markus Heidelberg <markus.heidelberg@web.de>
Subject: [PATCH resend 02/10] kconfig: add a note about the deps to the 'silentoldconfig' help
Date: Mon, 18 May 2009 01:36:46 +0200
Message-Id: <1242603414-9267-3-git-send-email-markus.heidelberg@web.de>
X-Mailer: git-send-email 1.6.3.1.20.ga30f
In-Reply-To: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
References: <1242603414-9267-1-git-send-email-markus.heidelberg@web.de>
X-Provags-ID: V01U2FsdGVkX18jKV8YD8ZZ//wDmkxUdL05jGlJ6UWV9eZ1DFU2
	NQo5A1mFSeH1vc2LfDWnHnx1g7R8baXbcJBR2IOXKH7x9OFO+y
	/hMiEMB1E9BKU2/JBULg==
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
1.6.3.1.20.ga30f

