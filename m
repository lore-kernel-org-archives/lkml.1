Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYAXWe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYAXWe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 17:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYAXWc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 17:32:26 -0500
Received: from smtp06.mtu.ru ([62.5.255.53]:52064 "EHLO smtp06.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764AbYAXWcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 17:32:25 -0500
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, tigran@aivazian.fsnet.co.uk
Subject: [PATCH 9/9] bfs: use the proper header file for inclusion
Date: Fri, 25 Jan 2008 01:32:08 +0300
Message-Id: <1201213928-18183-10-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1201213928-18183-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp06.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The checkpatch.pl reported the following warning:

$ ./scripts/checkpatch.pl --strict --file fs/bfs/inode.c
CHECK: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
+#include <asm/uaccess.h>

This patch fixes this warning.

No functional changes introduced.

This patch was compile-tested by building the BFS driver both
as a module and as a part of the kernel proper.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 fs/bfs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/bfs/inode.c b/fs/bfs/inode.c
index 7eefafb..00c54fa 100644
--- a/fs/bfs/inode.c
+++ b/fs/bfs/inode.c
@@ -15,7 +15,7 @@
 #include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "bfs.h"
 
 MODULE_AUTHOR("Tigran Aivazian <tigran@aivazian.fsnet.co.uk>");
-- 
1.5.3

