Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYFIWbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYFIWbk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbYFIW2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:28:36 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:47363 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762071AbYFIW2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:28:35 -0400
Date: Tue, 10 Jun 2008 01:27:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] remove unused #include <linux/dirent.h>'s
Message-ID: <20080609222741.GB1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes some unused #include <linux/dirent.h>'s.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/mips/kernel/linux32.c |    1 -
 fs/compat_ioctl.c          |    1 -
 fs/smbfs/cache.c           |    1 -
 fs/smbfs/proc.c            |    1 -
 include/linux/nfsd/nfsd.h  |    1 -
 5 files changed, 5 deletions(-)

95351d35188d388bcd1d95e71dd7eefac51ba027 diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
index 65af3cc..09e79ea 100644
--- a/arch/mips/kernel/linux32.c
+++ b/arch/mips/kernel/linux32.c
@@ -11,7 +11,6 @@
 #include <linux/file.h>
 #include <linux/smp_lock.h>
 #include <linux/highuid.h>
-#include <linux/dirent.h>
 #include <linux/resource.h>
 #include <linux/highmem.h>
 #include <linux/time.h>
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 97dba0d..9bb581e 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -25,7 +25,6 @@
 #include <linux/slab.h>
 #include <linux/raid/md.h>
 #include <linux/kd.h>
-#include <linux/dirent.h>
 #include <linux/route.h>
 #include <linux/in6.h>
 #include <linux/ipv6_route.h>
diff --git a/fs/smbfs/cache.c b/fs/smbfs/cache.c
index 8182f05..8c177eb 100644
--- a/fs/smbfs/cache.c
+++ b/fs/smbfs/cache.c
@@ -13,7 +13,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
-#include <linux/dirent.h>
 #include <linux/smb_fs.h>
 #include <linux/pagemap.h>
 #include <linux/net.h>
diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
index d517a27..ee536e8 100644
--- a/fs/smbfs/proc.c
+++ b/fs/smbfs/proc.c
@@ -16,7 +16,6 @@
 #include <linux/stat.h>
 #include <linux/fcntl.h>
 #include <linux/dcache.h>
-#include <linux/dirent.h>
 #include <linux/nls.h>
 #include <linux/smp_lock.h>
 #include <linux/net.h>
diff --git a/include/linux/nfsd/nfsd.h b/include/linux/nfsd/nfsd.h
index 41d30c9..134dc9d 100644
--- a/include/linux/nfsd/nfsd.h
+++ b/include/linux/nfsd/nfsd.h
@@ -12,7 +12,6 @@
 
 #include <linux/types.h>
 #include <linux/unistd.h>
-#include <linux/dirent.h>
 #include <linux/fs.h>
 #include <linux/posix_acl.h>
 #include <linux/mount.h>

