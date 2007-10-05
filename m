Return-Path: <linux-kernel-owner+w=401wt.eu-S1764423AbXJEWnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764423AbXJEWnr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 18:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762491AbXJEWnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 18:43:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:16255 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762304AbXJEWni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 18:43:38 -0400
Date: Fri, 5 Oct 2007 15:42:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] dontdiff: update based on gitignore updates
Message-Id: <20071005154227.0c1a28b3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Update dontdiff, based on .gitignore patches from
Pete Zaitcev and Adrian Bunk.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/dontdiff |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- linux-2.6.23-rc9-git3.orig/Documentation/dontdiff
+++ linux-2.6.23-rc9-git3/Documentation/dontdiff
@@ -42,6 +42,9 @@
 *.9.gz
 .*
 .cscope
+.gitignore
+.mailmap
+.mm
 53c700_d.h
 53c7xx_d.h
 53c7xx_u.h
@@ -176,11 +179,13 @@ times.h*
 tkparse
 trix_boot.h
 utsrelease.h*
+vdso.lds
 version.h*
 vmlinux
 vmlinux-*
 vmlinux.aout
-vmlinux.lds
+vmlinux*.lds*
+vmlinux*.scr
 vsyscall.lds
 wanxlfw.inc
 uImage
