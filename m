Return-Path: <linux-kernel-owner+w=401wt.eu-S1760296AbYFYQ1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760296AbYFYQ1v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758080AbYFYQ1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:27:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:46149 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757899AbYFYQ1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:27:16 -0400
Date: Wed, 25 Jun 2008 19:25:11 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] remove unused UNIX98_PTY_COUNT options
Message-ID: <20080625162511.GE10285@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The h8300 and sparc options somehow survived when the code stopped using 
CONFIG_UNIX98_PTY_COUNT.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/h8300/Kconfig |   14 --------------
 arch/sparc/Kconfig |   14 --------------
 2 files changed, 28 deletions(-)

153f95e9cbfc5292daf1b115392e5fb231490aaf diff --git a/arch/h8300/Kconfig b/arch/h8300/Kconfig
index 085dc6e..396ab05 100644
--- a/arch/h8300/Kconfig
+++ b/arch/h8300/Kconfig
@@ -203,20 +203,6 @@ config UNIX98_PTYS
 	  Read the instructions in <file:Documentation/Changes> pertaining to
 	  pseudo terminals. It's safe to say N.
 
-config UNIX98_PTY_COUNT
-	int "Maximum number of Unix98 PTYs in use (0-2048)"
-	depends on UNIX98_PTYS
-	default "256"
-	help
-	  The maximum number of Unix98 PTYs that can be used at any one time.
-	  The default is 256, and should be enough for desktop systems. Server
-	  machines which support incoming telnet/rlogin/ssh connections and/or
-	  serve several X terminals may want to increase this: every incoming
-	  connection and every xterm uses up one PTY.
-
-	  When not in use, each additional set of 256 PTYs occupy
-	  approximately 8 KB of kernel memory on 32-bit architectures.
-
 source "drivers/char/pcmcia/Kconfig"
 
 source "drivers/serial/Kconfig"
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 789724e..375de7c 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -298,20 +298,6 @@ config UNIX98_PTYS
 	  Read the instructions in <file:Documentation/Changes> pertaining to
 	  pseudo terminals. It's safe to say N.
 
-config UNIX98_PTY_COUNT
-	int "Maximum number of Unix98 PTYs in use (0-2048)"
-	depends on UNIX98_PTYS
-	default "256"
-	help
-	  The maximum number of Unix98 PTYs that can be used at any one time.
-	  The default is 256, and should be enough for desktop systems. Server
-	  machines which support incoming telnet/rlogin/ssh connections and/or
-	  serve several X terminals may want to increase this: every incoming
-	  connection and every xterm uses up one PTY.
-
-	  When not in use, each additional set of 256 PTYs occupy
-	  approximately 8 KB of kernel memory on 32-bit architectures.
-
 endmenu
 
 source "fs/Kconfig"

