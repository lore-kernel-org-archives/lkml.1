Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYBYA0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYBYA0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 19:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYBYAZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 19:25:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:9622 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbYBYAZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 19:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Xn/xZFb5mY1K/aq+CpgL147pF2vXR5EJcIpYwSzFto908LAhi7leEYw/zb4X02z5lehqUgG5uz2lAix9oF8UBW+rM8pHSq/sY9MJg+YXu2e2YWIINId9TbiKVBeHFa+RK5A2pORBSfNSXhv3b/MxdQK2XTnqnigFh7mt7CgcyQE=
Subject: [PATCH 2/6] xen: make blkif_getgeo static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
References: <5ce117613299590dd08d11d24d3a33d9077fe2b0.1203898924.git.harvey.harrison@gmail.com>
Content-Type: text/plain
Date: Sun, 24 Feb 2008 16:25:35 -0800
Message-Id: <1203899135.1767.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced between 2.6.25-rc2 and -rc3
drivers/block/xen-blkfront.c:139:5: warning: symbol 'blkif_getgeo' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 9c6f3f9..ae7ee16 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -136,7 +136,7 @@ static void blkif_restart_queue_callback(void *arg)
 	schedule_work(&info->work);
 }
 
-int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
+static int blkif_getgeo(struct block_device *bd, struct hd_geometry *hg)
 {
 	/* We don't have real geometry info, but let's at least return
 	   values consistent with the size of the device */
-- 
1.5.4.2.200.g99e75


