Return-Path: <linux-kernel-owner+w=401wt.eu-S940623AbXGUPMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940623AbXGUPMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 11:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938743AbXGUPE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 11:04:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:40095 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939348AbXGUPEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 11:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=Qd6OzfKCZ4ihzdk/xyHLZhu+1Ll09/Yd77H+VqGb5LLM+gsgv1/BCZcB+Y5Pm2PaZpldDUoUarDOVEBQNUNu7Sdpgg/MM53ocQx2Ot+wUUk/sFGwWvMm15i3465EmQTfgFXy/ThBPzqdO/0put3SIgVUtcoSlKEI9ZR8SNaczJ8=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][20/37] Clean up duplicate includes in fs/ntfs/
Date: Sat, 21 Jul 2007 17:03:24 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       linux-ntfs-dev@lists.sourceforge.net,
       Anton Altaparmakov <aia21@cantab.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200707211703.24950.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch cleans up duplicate includes in
	fs/ntfs/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ffcc504..21cde01 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -26,7 +26,6 @@
 #include <linux/swap.h>
 #include <linux/uio.h>
 #include <linux/writeback.h>
-#include <linux/sched.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
diff --git a/fs/ntfs/inode.c b/fs/ntfs/inode.c
index b532a73..5031e2d 100644
--- a/fs/ntfs/inode.c
+++ b/fs/ntfs/inode.c
@@ -34,7 +34,6 @@
 #include "dir.h"
 #include "debug.h"
 #include "inode.h"
-#include "attrib.h"
 #include "lcnalloc.h"
 #include "malloc.h"
 #include "mft.h"
