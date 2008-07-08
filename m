Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYGHRE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYGHRE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757264AbYGHREO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:04:14 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbYGHREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:04:13 -0400
Message-Id: <20080708170041.271121000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 01/11] make CONFIG_KMOD invisible
Content-Disposition: inline; filename=config-kmod-invisible.patch
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

--- everything.orig/init/Kconfig	2008-07-08 13:42:10.000000000 +0200
+++ everything/init/Kconfig	2008-07-08 16:30:31.000000000 +0200
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

