Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbZKXSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbZKXSBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:01:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933737AbZKXSBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:01:22 -0500
Received: from daytona.panasas.com ([67.152.220.89]:4489 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933701AbZKXSBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:01:20 -0500
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 13:01:18 EST
Message-ID: <4B0C1F1A.8070605@panasas.com>
Date: Tue, 24 Nov 2009 19:59:54 +0200
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
Subject: [PATCH 1/5] parsic: remove unused nfsd #includes
References: <4B0C1EB7.50508@panasas.com>
In-Reply-To: <4B0C1EB7.50508@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2009 17:59:57.0366 (UTC) FILETIME=[EEF8E560:01CA6D2F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some unused includes removed.

This patch is in an effort to cleanup nfsd headers and move
private definitions to source directory.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 arch/parisc/kernel/sys_parisc32.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/parisc/kernel/sys_parisc32.c b/arch/parisc/kernel/sys_parisc32.c
index 561388b..4a8ca63 100644
--- a/arch/parisc/kernel/sys_parisc32.c
+++ b/arch/parisc/kernel/sys_parisc32.c
@@ -26,13 +26,7 @@
 #include <linux/shm.h>
 #include <linux/slab.h>
 #include <linux/uio.h>
-#include <linux/nfs_fs.h>
 #include <linux/ncp_fs.h>
-#include <linux/sunrpc/svc.h>
-#include <linux/nfsd/nfsd.h>
-#include <linux/nfsd/cache.h>
-#include <linux/nfsd/xdr.h>
-#include <linux/nfsd/syscall.h>
 #include <linux/poll.h>
 #include <linux/personality.h>
 #include <linux/stat.h>
-- 
1.6.5.2


