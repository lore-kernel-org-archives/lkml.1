Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbXKDUC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbXKDUC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 15:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbXKDUCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 15:02:20 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:45909 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbXKDUCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 15:02:20 -0500
Date: Sun, 4 Nov 2007 12:01:55 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: sam@ranvborg.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH] Makefile: add 'includecheck' help text
Message-Id: <20071104120155.d1e85630.randy.dunlap@oracle.com>
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

Add 'includecheck' to the Static analyzers help list.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.24-rc1-git13.orig/Makefile
+++ linux-2.6.24-rc1-git13/Makefile
@@ -1169,6 +1169,7 @@ help:
 	@echo  'Static analysers'
 	@echo  '  checkstack      - Generate a list of stack hogs'
 	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
+	@echo  '  includecheck    - Check for duplicate included header files'
 	@echo  '  export_report   - List the usages of all exported symbols'
 	@if [ -r $(srctree)/include/asm-$(SRCARCH)/Kbuild ]; then \
 	 echo  '  headers_check   - Sanity check on exported headers'; \
