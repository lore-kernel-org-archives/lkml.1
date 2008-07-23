Return-Path: <linux-kernel-owner+w=401wt.eu-S1754249AbYGWPp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbYGWPp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYGWPps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:45:48 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56060 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbYGWPps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:45:48 -0400
Date: Wed, 23 Jul 2008 11:45:33 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] lockd: trivial sparse endian annotations
Message-ID: <20080723154533.GA12595@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720234211.4c77f506.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 11:42:11PM -0700, Andrew Morton wrote:
> On Thu, 17 Jul 2008 17:41:35 -0700 Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > fs/lockd/svcproc.c:115:11: warning: incorrect type in initializer (different base types)
> > fs/lockd/svcproc.c:115:11:    expected int [signed] rc
> > fs/lockd/svcproc.c:115:11:    got restricted __be32 [usertype] <noident>
> > ... and so on...
> 
> Bruce handles lockd stuff.

Actually Trond normally handles client-specific lockd code (e.g.
fs/lockd/clnt*.c), though of course I'm happy to triage stuff and pass
it along.

> Not that a reader of ./MAINTAINERS would know this </hint>.

Would this help?

--b.

commit e8b43555a2a8c71e8501924e260f62b9545c598b
Author: J. Bruce Fields <bfields@citi.umich.edu>
Date:   Wed Jul 23 08:49:50 2008 -0400

    MAINTAINERS: mention lockd and sunrpc in nfs entries
    
    The actual division of labor is a little vague in some of the common
    code, but if the patches get to one of us then we can sort it out.
    
    Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0652ab3..c382ad3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2418,7 +2418,7 @@ L:	kernel-janitors@vger.kernel.org
 W:	http://www.kerneljanitors.org/
 S:	Maintained
 
-KERNEL NFSD
+KERNEL NFSD, SUNRPC, AND LOCKD SERVERS
 P:	J. Bruce Fields
 M:	bfields@fieldses.org
 P:	Neil Brown
@@ -3036,7 +3036,7 @@ M:	ja@ssi.bg
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-NFS CLIENT
+NFS, SUNRPC, AND LOCKD CLIENTS
 P:	Trond Myklebust
 M:	Trond.Myklebust@netapp.com
 L:	linux-nfs@vger.kernel.org
