Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbZF2X77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbZF2X77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZF2X7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:59:52 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:64204 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZF2X7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:59:51 -0400
Message-ID: <4A49553B.2040300@oracle.com>
Date: Mon, 29 Jun 2009 16:58:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: samr <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kernel hacking: move STRIP_ASM_SYMS from General
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt001.oracle.com [141.146.116.10]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010204.4A49553D.0169:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Sam suggested moving STRIP_ASM_SYMS into the Kernel hacking menu
from the General Setup menu.  It makes more sense there.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 init/Kconfig      |    8 --------
 lib/Kconfig.debug |    8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.31-rc1-git5.orig/init/Kconfig
+++ linux-2.6.31-rc1-git5/init/Kconfig
@@ -995,14 +995,6 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
-config STRIP_ASM_SYMS
-	bool "Strip assembler-generated symbols during link"
-	default n
-	help
-	  Strip internal assembler-generated symbols during a link (symbols
-	  that look like '.Lxxx') so they don't pollute the output of
-	  get_wchan() and suchlike.
-
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
--- linux-2.6.31-rc1-git5.orig/lib/Kconfig.debug
+++ linux-2.6.31-rc1-git5/lib/Kconfig.debug
@@ -50,6 +50,14 @@ config MAGIC_SYSRQ
 	  keys are documented in <file:Documentation/sysrq.txt>. Don't say Y
 	  unless you really know what this hack does.
 
+config STRIP_ASM_SYMS
+	bool "Strip assembler-generated symbols during link"
+	default n
+	help
+	  Strip internal assembler-generated symbols during a link (symbols
+	  that look like '.Lxxx') so they don't pollute the output of
+	  get_wchan() and suchlike.
+
 config UNUSED_SYMBOLS
 	bool "Enable unused/obsolete exported symbols"
 	default y if X86



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
