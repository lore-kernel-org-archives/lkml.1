Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZHIOVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZHIOVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 10:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZHIOVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 10:21:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:49940 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754026AbZHIOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 10:21:41 -0400
Subject: [PATCH] mm: includecheck fix for mm/shmem.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Aug 2009 19:50:20 +0530
Message-Id: <1249827620.2957.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  mm/shmem.c: linux/vfs.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 mm/shmem.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d713239..34e56aa 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -49,7 +49,6 @@ static struct vfsmount *shm_mnt;
 #include <linux/backing-dev.h>
 #include <linux/shmem_fs.h>
 #include <linux/writeback.h>
-#include <linux/vfs.h>
 #include <linux/blkdev.h>
 #include <linux/security.h>
 #include <linux/swapops.h>
-- 
1.6.0.6



