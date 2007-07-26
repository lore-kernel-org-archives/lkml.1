Return-Path: <linux-kernel-owner+w=401wt.eu-S935757AbXGZQme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935757AbXGZQme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934688AbXGZQgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:36:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43365 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934595AbXGZQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:36:21 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] raw1394 __user annotation
Cc: linux-kernel@vger.kernel.org, ben.collins@ubuntu.com
Message-Id: <E1IE6K3-0005T9-S0@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 26 Jul 2007 17:36:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ieee1394/raw1394.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index 336e5ff..cadf047 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -2677,7 +2677,7 @@ static long raw1394_iso_xmit_recv_packets32(struct file *file, unsigned int cmd,
                                           struct raw1394_iso_packets32 __user *arg)
 {
 	compat_uptr_t infos32;
-	void *infos;
+	void __user *infos;
 	long err = -EFAULT;
 	struct raw1394_iso_packets __user *dst = compat_alloc_user_space(sizeof(struct raw1394_iso_packets));
 
-- 
1.5.3.GIT


