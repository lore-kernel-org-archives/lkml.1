Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbYJXFzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbYJXFzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYJXFza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:55:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56847 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYJXFza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:55:30 -0400
Date: Fri, 24 Oct 2008 16:55:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Fw: [PATCH] nfsctl: credentials error
Message-Id: <20081024165524.1a1ff01c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added recipients]

I have added this patch to today's linux-next.

Begin forwarded message:

Date: Thu, 23 Oct 2008 18:17:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] nfsctl: credentials error


From: Randy Dunlap <randy.dunlap@oracle.com>

Needs headers help for current_cred:

Adding only cred.h wasn't enough.

linux-next-20081023/fs/nfsctl.c:45: error: implicit declaration of function 'current_cred'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/nfsctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20081023.orig/fs/nfsctl.c
+++ linux-next-20081023/fs/nfsctl.c
@@ -10,6 +10,8 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/syscall.h>
+#include <linux/cred.h>
+#include <linux/sched.h>
 #include <linux/linkage.h>
 #include <linux/namei.h>
 #include <linux/mount.h>



-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
