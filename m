Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYGHRGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYGHRGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758946AbYGHRG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:06:26 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520AbYGHRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:06:25 -0400
Message-Id: <20080708170049.961308000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 11/11] remove CONFIG_KMOD
Content-Disposition: inline; filename=config-kmod-remove.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that nothing depends on it any more, remove CONFIG_KMOD.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 init/Kconfig |    4 ----
 1 file changed, 4 deletions(-)

--- everything.orig/init/Kconfig	2008-07-08 17:15:10.000000000 +0200
+++ everything/init/Kconfig	2008-07-08 17:22:17.000000000 +0200
@@ -892,10 +892,6 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
-config KMOD
-	def_bool y
-	depends on MODULES
-
 config STOP_MACHINE
 	bool
 	default y

-- 

