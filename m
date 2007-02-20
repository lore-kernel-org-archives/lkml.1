Return-Path: <linux-kernel-owner+w=401wt.eu-S1751022AbXBTTSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbXBTTSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbXBTTSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:18:48 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:15783 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbXBTTSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:18:48 -0500
Date: Tue, 20 Feb 2007 11:14:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel-doc: allow space after __attribute__
Message-Id: <20070220111439.77ca994e.randy.dunlap@oracle.com>
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

Allow space(s) between "__attribute__" and "((blah))" so that
kernel-doc does not complain like:

Warning(/tester/linsrc/linux-2.6.20-git15//kernel/timer.c:939): No description found for parameter 'read_persistent_clock(void'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kernel-doc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-git15.orig/scripts/kernel-doc
+++ linux-2.6.20-git15/scripts/kernel-doc
@@ -1547,7 +1547,7 @@ sub dump_function($$) {
     $prototype =~ s/^noinline +//;
     $prototype =~ s/__devinit +//;
     $prototype =~ s/^#define\s+//; #ak added
-    $prototype =~ s/__attribute__ \(\([a-z,]*\)\)//;
+    $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
     # 1. Return type (may be nothing if we're looking at a macro)
