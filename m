Return-Path: <linux-kernel-owner+w=401wt.eu-S934566AbZLGDxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934566AbZLGDxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 22:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934512AbZLGDw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 22:52:57 -0500
Received: from xenotime.net ([72.52.64.118]:38316 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934475AbZLGDwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 22:52:54 -0500
Date: Sun, 06 Dec 2009 18:30:44 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/6] docs: fix signal_pending argument
Message-ID: <12601530443872@xenotime.net>
In-Reply-To: <12601530442994@xenotime.net>
X-Mailer: gregkh_patchbomb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: docbook: fix signal_pending() argument

Since signal_pending() takes a task_struct pointer as an argument, update
the example to pass in 'current'.

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/DocBook/kernel-hacking.tmpl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2632-rc6.orig/Documentation/DocBook/kernel-hacking.tmpl
+++ lnx-2632-rc6/Documentation/DocBook/kernel-hacking.tmpl
@@ -352,7 +352,7 @@ asmlinkage long sys_mycall(int arg)
   </para>
 
   <programlisting>
-if (signal_pending()) 
+if (signal_pending(current))
         return -ERESTARTSYS;
   </programlisting>
 


-- 

