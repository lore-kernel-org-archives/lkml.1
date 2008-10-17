Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYJPLMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYJPLMw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYJPLMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:12:17 -0400
Received: from ozlabs.org ([203.10.76.45]:46640 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbYJPLMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:12:15 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu Oct 16 22:10:38 EST 2008
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/5] remove CONFIG_KMOD
Cc: Johannes Berg <johannes@sipsolutions.net>
Message-Id: <20081016111214.417B8DDFAF@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes@sipsolutions.net>

Now that nothing depends on it any more, remove CONFIG_KMOD.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 init/Kconfig |    6 ------
 1 file changed, 6 deletions(-)

diff -r 06f472832c66 init/Kconfig
--- a/init/Kconfig	Tue Aug 12 16:34:24 2008 +1000
+++ b/init/Kconfig	Tue Aug 12 17:35:27 2008 +1000
@@ -894,12 +894,6 @@ config MODULE_SRCVERSION_ALL
 	  the version).  With this option, such a "srcversion" field
 	  will be created for all modules.  If unsure, say N.
 
-config KMOD
-	def_bool y
-	help
-	  This is being removed soon.  These days, CONFIG_MODULES
-	  implies CONFIG_KMOD, so use that instead.
-
 endif # MODULES
 
 config STOP_MACHINE

