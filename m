Return-Path: <linux-kernel-owner+w=401wt.eu-S933764AbZDJUCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbZDJUCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 16:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759964AbZDJUBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 16:01:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759691AbZDJUBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 16:01:53 -0400
Date: Fri, 10 Apr 2009 13:00:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hugh@veritas.com
Subject: Re: mmotm 2009-04-10-02-21 uploaded (shmem)
Message-Id: <20090410130009.caf2285b.akpm@linux-foundation.org>
In-Reply-To: <49DFA3B3.3080003@oracle.com>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
	<49DFA3B3.3080003@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009 12:53:23 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-04-10-02-21 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.30-rc1:
> 
> 
> I get a few of these build errors, but I don't see why.
> (config attached)
> 
> 
> mm/shmem.c: In function 'shmem_file_setup':
> mm/shmem.c:2622: error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)

Thanks.

--- a/mm/shmem.c~shmem-respect-max_lfs_filesize-fix
+++ a/mm/shmem.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/vfs.h>
 #include <linux/mount.h>
+#include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/mm.h>
 #include <linux/module.h>
_

