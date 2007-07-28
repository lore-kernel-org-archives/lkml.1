Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXG1QeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXG1QeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXG1QeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:34:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58810 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbXG1QeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:34:15 -0400
Date: Sat, 28 Jul 2007 09:38:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: chrisw@sous-sol.org, akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] fix LSM kernel-doc
Message-Id: <20070728093812.3b4b8fbd.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
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

I'd like mainline (Linus's git) to be kernel-doc clean (it's not,
but all of the patches for it have been sent, just getting them
merged is the challenge).  One way to address this for future
merges is to fix -mm kernel-doc.


The security-convert-to-static patches need this docbook change.

Warning(linux-2.6.23-rc1-mm1//security/security.c): no structured comments found

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-api.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm1.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.23-rc1-mm1/Documentation/DocBook/kernel-api.tmpl
@@ -334,7 +334,7 @@ X!Earch/i386/kernel/mca.c
 
   <chapter id="security">
      <title>Security Framework</title>
-!Esecurity/security.c
+!Isecurity/security.c
   </chapter>
 
   <chapter id="audit">
