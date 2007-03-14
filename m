Return-Path: <linux-kernel-owner+w=401wt.eu-S1030705AbXCNJP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030705AbXCNJP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030715AbXCNJP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:15:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60722 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030705AbXCNJPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:15:55 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 6/13] stacktrace doesn't work on uml
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1HRPaM-00038c-M8@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:15:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


and no, it's not the case of "let's pull bits from underlying architecture"

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index b3a21ba..354cc6b 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -44,7 +44,7 @@ config LOCKDEP_SUPPORT
 
 config STACKTRACE_SUPPORT
 	bool
-	default y
+	default n
 
 config GENERIC_CALIBRATE_DELAY
 	bool
-- 
1.5.0-rc2.GIT


