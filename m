Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbXH2X3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbXH2X3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXH2X3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:29:17 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37911 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753037AbXH2X3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:29:17 -0400
Date: Thu, 30 Aug 2007 01:29:16 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] update .gitignore
Message-ID: <20070829232916.GX26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some shipped files were wrongly ignored by git.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 .gitignore |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

45a1318453ecc5fa346d323e8d806a5630a7191c 
diff --git a/.gitignore b/.gitignore
index 27c3e83..80d891b 100644
--- a/.gitignore
+++ b/.gitignore
@@ -17,15 +17,21 @@
 *.lst
 *.symtypes
 
+# .gitignore files
+!.gitignore
+
 #
 # Top-level generic files
 #
 tags
 TAGS
 vmlinux*
-!vmlinux.lds.S
+!vmlinux*.lds*
+!vmlinux*.scr
 System.map
 Module.symvers
+!.mailmap
+!.mm
 
 #
 # Generated include files

