Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbYBOA5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbYBOA5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:57:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbYBOA5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:57:12 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59804 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbYBOA5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:57:10 -0500
Date: Fri, 15 Feb 2008 02:56:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] let DEBUG_SECTION_MISMATCH depend on BROKEN
Message-ID: <20080215005648.GK23227@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pattern for making a config option on purpose not available is a 
dependency on BROKEN.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
79b6f4490cadd62b3601f653df8a27ec2295adf0 diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index a370fe8..9fad6da 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -81,7 +81,7 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED
+	depends on BROKEN
 	help
 	  The section mismatch analysis checks if there are illegal
 	  references from one section to another section.

