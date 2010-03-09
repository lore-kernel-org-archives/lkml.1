Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0CIRjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:39:08 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:48144 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781Ab0CIRjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:39:04 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH] enable DEBUG_SECTION_MISMATCH for Blackfin systems
Date: Tue,  9 Mar 2010 12:42:12 -0500
Message-Id: <1268156532-11658-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see only one section mismatch now after thousands of randconfigs, and a
bug has been filed about that one.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 lib/Kconfig.debug |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..a2f6be0 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -103,7 +103,8 @@ config HEADERS_CHECK
 
 config DEBUG_SECTION_MISMATCH
 	bool "Enable full Section mismatch analysis"
-	depends on UNDEFINED
+	depends on UNDEFINED || (BLACKFIN)
+	default y
 	# This option is on purpose disabled for now.
 	# It will be enabled when we are down to a reasonable number
 	# of section mismatch warnings (< 10 for an allyesconfig build)
-- 
1.7.0.2

