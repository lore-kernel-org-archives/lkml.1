Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbXEWAVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbXEWAVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757937AbXEWAVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:21:06 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:52732 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbXEWAVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:21:05 -0400
Date: Tue, 22 May 2007 17:26:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/3] kernel-doc: add tools doc in Makefile
Message-Id: <20070522172609.c1cc3ddd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add kernel-doc tools info in Makefile.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/Makefile |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- linux-2.6.22-rc2-git2.orig/Documentation/DocBook/Makefile
+++ linux-2.6.22-rc2-git2/Documentation/DocBook/Makefile
@@ -15,11 +15,11 @@ DOCBOOKS := wanbook.xml z8530book.xml mc
 
 ###
 # The build process is as follows (targets):
-#              (xmldocs)
-# file.tmpl --> file.xml +--> file.ps   (psdocs)
-#                        +--> file.pdf  (pdfdocs)
-#                        +--> DIR=file  (htmldocs)
-#                        +--> man/      (mandocs)
+#              (xmldocs) [by docproc]
+# file.tmpl --> file.xml +--> file.ps   (psdocs)   [by db2ps or xmlto]
+#                        +--> file.pdf  (pdfdocs)  [by db2pdf or xmlto]
+#                        +--> DIR=file  (htmldocs) [by xmlto]
+#                        +--> man/      (mandocs)  [by xmlto]
 
 
 # for PDF and PS output you can choose between xmlto and docbook-utils tools
