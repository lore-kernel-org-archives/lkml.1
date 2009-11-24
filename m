Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbZKXSQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbZKXSQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933488AbZKXSQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:16:38 -0500
Received: from daytona.panasas.com ([67.152.220.89]:33713 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932245AbZKXSQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:16:36 -0500
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 13:16:36 EST
Message-ID: <4B0C1F98.4000204@panasas.com>
Date: Tue, 24 Nov 2009 20:02:00 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090924 Remi/fc10 Thunderbird/3.0b4
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@citi.umich.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       sparclinux <sparclinux@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       NFS list <linux-nfs@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/5] s390: remove unused nfsd #includes
References: <4B0C1EB7.50508@panasas.com>
In-Reply-To: <4B0C1EB7.50508@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2009 18:02:02.0776 (UTC) FILETIME=[39B8F180:01CA6D30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some unused includes removed.

This patch is in an effort to cleanup nfsd headers and move
private definitions to source directory.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 arch/s390/kernel/compat_linux.c |    6 ------
 arch/s390/kernel/compat_linux.h |    4 ----
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/s390/kernel/compat_linux.c b/arch/s390/kernel/compat_linux.c
index 0debcec..29a2f34 100644
--- a/arch/s390/kernel/compat_linux.c
+++ b/arch/s390/kernel/compat_linux.c
@@ -31,14 +31,8 @@
 #include <linux/shm.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
-#include <linux/nfs_fs.h>
 #include <linux/quota.h>
 #include <linux/module.h>
-#include <linux/sunrpc/svc.h>
-#include <linux/nfsd/nfsd.h>
-#include <linux/nfsd/cache.h>
-#include <linux/nfsd/xdr.h>
-#include <linux/nfsd/syscall.h>
 #include <linux/poll.h>
 #include <linux/personality.h>
 #include <linux/stat.h>
diff --git a/arch/s390/kernel/compat_linux.h b/arch/s390/kernel/compat_linux.h
index c07f9ca..81d6ee8 100644
--- a/arch/s390/kernel/compat_linux.h
+++ b/arch/s390/kernel/compat_linux.h
@@ -4,10 +4,6 @@
 #include <linux/compat.h>
 #include <linux/socket.h>
 #include <linux/syscalls.h>
-#include <linux/nfs_fs.h>
-#include <linux/sunrpc/svc.h>
-#include <linux/nfsd/nfsd.h>
-#include <linux/nfsd/export.h>
 
 /* Macro that masks the high order bit of an 32 bit pointer and converts it*/
 /*       to a 64 bit pointer */
-- 
1.6.5.2


