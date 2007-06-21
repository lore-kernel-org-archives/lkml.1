Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbXFUEcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbXFUEcr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 00:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756271AbXFUEbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 00:31:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:59885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbXFUEbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 00:31:15 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2007 14:31:05 +1000
Message-Id: <1070621043105.1129@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 006 of 8] knfsd: nfsd: remove unused header interface.h
References: <20070621142604.727.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "J. Bruce Fields" <bfields@fieldses.org>


It looks like Al Viro gutted this header file five years ago and it
hasn't been touched since.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfsctl.c               |    1 -
 ./include/linux/nfsd/interface.h |   13 -------------
 ./include/linux/nfsd/nfsd.h      |    1 -
 3 files changed, 15 deletions(-)

diff .prev/fs/nfsd/nfsctl.c ./fs/nfsd/nfsctl.c
--- .prev/fs/nfsd/nfsctl.c	2007-06-21 13:46:36.000000000 +1000
+++ ./fs/nfsd/nfsctl.c	2007-06-21 14:13:57.000000000 +1000
@@ -35,7 +35,6 @@
 #include <linux/nfsd/cache.h>
 #include <linux/nfsd/xdr.h>
 #include <linux/nfsd/syscall.h>
-#include <linux/nfsd/interface.h>
 
 #include <asm/uaccess.h>
 

diff .prev/include/linux/nfsd/interface.h ./include/linux/nfsd/interface.h
--- .prev/include/linux/nfsd/interface.h	2007-06-21 13:46:36.000000000 +1000
+++ ./include/linux/nfsd/interface.h	1970-01-01 10:00:00.000000000 +1000
@@ -1,13 +0,0 @@
-/*
- * include/linux/nfsd/interface.h
- *
- * defines interface between nfsd and other bits of
- * the kernel.  Particularly filesystems (eventually).
- *
- * Copyright (C) 2000 Neil Brown <neilb@cse.unsw.edu.au>
- */
-
-#ifndef LINUX_NFSD_INTERFACE_H
-#define LINUX_NFSD_INTERFACE_H
-
-#endif /* LINUX_NFSD_INTERFACE_H */

diff .prev/include/linux/nfsd/nfsd.h ./include/linux/nfsd/nfsd.h
--- .prev/include/linux/nfsd/nfsd.h	2007-06-21 13:46:36.000000000 +1000
+++ ./include/linux/nfsd/nfsd.h	2007-06-21 14:13:57.000000000 +1000
@@ -22,7 +22,6 @@
 #include <linux/nfsd/export.h>
 #include <linux/nfsd/auth.h>
 #include <linux/nfsd/stats.h>
-#include <linux/nfsd/interface.h>
 /*
  * nfsd version
  */
