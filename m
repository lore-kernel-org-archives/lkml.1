Return-Path: <linux-kernel-owner+w=401wt.eu-S1762865AbZEONTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762865AbZEONTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbZEONSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:18:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:34690 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760384AbZEONSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:18:53 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Frank Rowand <frank.rowand@am.sony.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/3] kgdb: gdb documentation fix
Date: Fri, 15 May 2009 08:17:59 -0500
Message-Id: <1242393479-19351-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1242393479-19351-3-git-send-email-jason.wessel@windriver.com>
References: <1242393479-19351-1-git-send-email-jason.wessel@windriver.com>
 <1242393479-19351-2-git-send-email-jason.wessel@windriver.com>
 <1242393479-19351-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 15 May 2009 13:18:12.0893 (UTC) FILETIME=[996544D0:01C9D55F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

gdb command "set remote debug 1" is not valid, change to correct command.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 372dec2..5cff41a 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -281,7 +281,7 @@
     seriously wrong while debugging, it will most often be the case
     that you want to enable gdb to be verbose about its target
     communications.  You do this prior to issuing the <constant>target
-    remote</constant> command by typing in: <constant>set remote debug 1</constant>
+    remote</constant> command by typing in: <constant>set debug remote 1</constant>
     </para>
   </chapter>
   <chapter id="KGDBTestSuite">
-- 
1.6.3.1.9.g95405b

