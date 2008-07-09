Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYGIMxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYGIMxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYGIMxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:53:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42108 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbYGIMxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:53:06 -0400
Message-Id: <20080709082904.463179000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:45 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 11/11] remove CONFIG_KMOD
Content-Disposition: inline; filename=013-config-kmod-remove.patch
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

--- linux-next.orig/init/Kconfig	2008-07-08 23:52:17.000000000 +0200
+++ linux-next/init/Kconfig	2008-07-08 23:55:41.000000000 +0200
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
