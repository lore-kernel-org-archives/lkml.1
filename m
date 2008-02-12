Return-Path: <linux-kernel-owner+w=401wt.eu-S1757089AbYBLBc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089AbYBLBc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 20:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759843AbYBLBb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 20:31:56 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:62629 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbYBLBbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 20:31:47 -0500
Date: Mon, 11 Feb 2008 17:28:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: viro@zeniv.linux.org.uk, akpm <akpm@linux-foundation.org>
Subject: [PATCH 3/4] docbook: move pipe and splice to filesystems docbook
Message-Id: <20080211172820.6db6eb20.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Move pipes and splice docbook to filesystems book.
kernel-api book is huge (10x most other books) & slow to process.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/filesystems.tmpl |   20 ++++++++++++++++++++
 Documentation/DocBook/kernel-api.tmpl  |   20 --------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

--- linux-2.6.25-rc1.orig/Documentation/DocBook/filesystems.tmpl
+++ linux-2.6.25-rc1/Documentation/DocBook/filesystems.tmpl
@@ -398,4 +398,24 @@ an example.
 
   </chapter>
 
+  <chapter id="splice">
+      <title>splice API</title>
+  <para>
+	splice is a method for moving blocks of data around inside the
+	kernel, without continually transferring them between the kernel
+	and user space.
+  </para>
+!Ffs/splice.c
+  </chapter>
+
+  <chapter id="pipes">
+      <title>pipes API</title>
+  <para>
+	Pipe interfaces are all for in-kernel (builtin image) use.
+	They are not exported for use by modules.
+  </para>
+!Iinclude/linux/pipe_fs_i.h
+!Ffs/pipe.c
+  </chapter>
+
 </book>
--- linux-2.6.25-rc1.orig/Documentation/DocBook/kernel-api.tmpl
+++ linux-2.6.25-rc1/Documentation/DocBook/kernel-api.tmpl
@@ -718,24 +718,4 @@ X!Idrivers/video/console/fonts.c
 !Edrivers/i2c/i2c-core.c
   </chapter>
 
-  <chapter id="splice">
-      <title>splice API</title>
-  <para>
-	splice is a method for moving blocks of data around inside the
-	kernel, without continually transferring them between the kernel
-	and user space.
-  </para>
-!Ffs/splice.c
-  </chapter>
-
-  <chapter id="pipes">
-      <title>pipes API</title>
-  <para>
-	Pipe interfaces are all for in-kernel (builtin image) use.
-	They are not exported for use by modules.
-  </para>
-!Iinclude/linux/pipe_fs_i.h
-!Ffs/pipe.c
-  </chapter>
-
 </book>
