Return-Path: <linux-kernel-owner+w=401wt.eu-S933851AbZKXSQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933851AbZKXSQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:16:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933786AbZKXSQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:16:41 -0500
Received: from daytona.panasas.com ([67.152.220.89]:33713 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933231AbZKXSQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:16:38 -0500
X-Greylist: delayed 917 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 13:16:36 EST
Message-ID: <4B0C201C.4040400@panasas.com>
Date: Tue, 24 Nov 2009 20:04:12 +0200
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
Subject: [PATCH 5/5] vfs: nfsctl.c unused nfsd #includes
References: <4B0C1EB7.50508@panasas.com>
In-Reply-To: <4B0C1EB7.50508@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Nov 2009 18:04:15.0670 (UTC) FILETIME=[88EEF560:01CA6D30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Only linux/nfsd/syscall.h is actually used. Remove the
other nfsd #includes, so they can be moved to source
directory.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/nfsctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfsctl.c b/fs/nfsctl.c
index 8f9a205..d3854d9 100644
--- a/fs/nfsctl.c
+++ b/fs/nfsctl.c
@@ -7,8 +7,6 @@
 #include <linux/types.h>
 #include <linux/file.h>
 #include <linux/fs.h>
-#include <linux/sunrpc/svc.h>
-#include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/syscall.h>
 #include <linux/cred.h>
 #include <linux/sched.h>
-- 
1.6.5.2


