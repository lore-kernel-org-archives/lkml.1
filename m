Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbYGIMtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbYGIMtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYGIMsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:48:51 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33099 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbYGIMsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:48:50 -0400
Message-Id: <20080709082902.841134000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 01/11] make CONFIG_KMOD invisible
Content-Disposition: inline; filename=003-config-kmod-invisible.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... as preparation for removing it completely, make it an
invisible bool defaulting to yes.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 init/Kconfig |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- everything.orig/init/Kconfig	2008-07-08 21:53:13.000000000 +0200
+++ everything/init/Kconfig	2008-07-08 22:00:24.000000000 +0200
@@ -893,16 +893,8 @@ config MODULE_SRCVERSION_ALL
 	  will be created for all modules.  If unsure, say N.
 
 config KMOD
-	bool "Automatic kernel module loading"
+	def_bool y
 	depends on MODULES
-	help
-	  Normally when you have selected some parts of the kernel to
-	  be created as kernel modules, you must load them (using the
-	  "modprobe" command) before you can use them. If you say Y
-	  here, some parts of the kernel will be able to load modules
-	  automatically: when a part of the kernel needs a module, it
-	  runs modprobe with the appropriate arguments, thereby
-	  loading the module if it is available.  If unsure, say Y.
 
 config STOP_MACHINE
 	bool

-- 
