Return-Path: <linux-kernel-owner+w=401wt.eu-S1752123AbZKEALO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbZKEALO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 19:11:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZKEALN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 19:11:13 -0500
Received: from xenotime.net ([72.52.64.118]:51149 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751614AbZKEALM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 19:11:12 -0500
Date: Wed, 04 Nov 2009 16:04:52 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: linux-kernel@vger.kernel.org
Cc: Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 4/8] docbook: signal_pending has an argument
Message-ID: <12573794922091@xenotime.net>
In-Reply-To: <1257379492822@xenotime.net>
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

