Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXHANLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXHANLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 09:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762266AbXHANLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 09:11:14 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56626 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762510AbXHANLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 09:11:13 -0400
Date: Wed, 1 Aug 2007 15:10:51 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] update .gitignore
Message-ID: <20070801131051.GO3972@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some shipped files were wrongly ignored by git.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 .gitignore |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm2/.gitignore.old	2007-08-01 14:12:43.000000000 +0200
+++ linux-2.6.23-rc1-mm2/.gitignore	2007-08-01 14:52:51.000000000 +0200
@@ -14,18 +14,25 @@
 *.so
 *.mod.c
 *.i
+!include/asm-*/*.i
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

