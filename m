Return-Path: <linux-kernel-owner+w=401wt.eu-S965387AbXA3NYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965387AbXA3NYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965372AbXA3NX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:23:59 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41147 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965365AbXA3NXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:42 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] fix indentation-related breakage in Kconfig.i386
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1HBsxY-0002NE-Uo@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Kconfig recognizes the end of help text by receding indentation depth.
Recent patch had broken HOST_VMSPLIT_... choice in arch/um/Kconfig.i386 -
all alternatives are interpreted as part of help text now.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/um/Kconfig.i386 |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 77558a8..d6cffb2 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -36,14 +36,14 @@ choice
 
 	So, if you do not know what to do here, say 'Default split'.
 
-	config HOST_VMSPLIT_3G
-		bool "Default split (3G/1G user/kernel host split)"
-	config HOST_VMSPLIT_3G_OPT
-		bool "3G/1G user/kernel host split (for full 1G low memory)"
-	config HOST_VMSPLIT_2G
-		bool "2G/2G user/kernel host split"
-	config HOST_VMSPLIT_1G
-		bool "1G/3G user/kernel host split"
+config HOST_VMSPLIT_3G
+	bool "Default split (3G/1G user/kernel host split)"
+config HOST_VMSPLIT_3G_OPT
+	bool "3G/1G user/kernel host split (for full 1G low memory)"
+config HOST_VMSPLIT_2G
+	bool "2G/2G user/kernel host split"
+config HOST_VMSPLIT_1G
+	bool "1G/3G user/kernel host split"
 endchoice
 
 config TOP_ADDR
-- 
1.5.0-rc2.GIT


