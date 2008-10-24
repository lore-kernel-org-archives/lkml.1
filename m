Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbYJXFyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbYJXFyl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 01:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYJXFy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 01:54:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56812 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbYJXFy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 01:54:28 -0400
Date: Fri, 24 Oct 2008 16:54:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Fw: [PATCH] coda: credentials error
Message-Id: <20081024165421.1221819a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added more recipients]

I have added this patch to today's linux-next.

Begin forwarded message:

Date: Thu, 23 Oct 2008 18:17:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] coda: credentials error


From: Randy Dunlap <randy.dunlap@oracle.com>

Needs a header file for credentials struct:

linux-next-20081023/fs/coda/file.c:177: error: dereferencing pointer to incomplete type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 fs/coda/file.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20081023.orig/fs/coda/file.c
+++ linux-next-20081023/fs/coda/file.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
+#include <linux/cred.h>
 #include <linux/errno.h>
 #include <linux/smp_lock.h>
 #include <linux/string.h>



-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
