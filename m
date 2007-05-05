Return-Path: <linux-kernel-owner+w=401wt.eu-S933278AbXEEUSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933278AbXEEUSf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 16:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933463AbXEEUSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 16:18:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:48854 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933332AbXEEUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 16:18:33 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Adrian Brunyate <abrunyate@yahoo.com>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 2/3] Unionfs: Check remount options for being NULL
Date: Sat,  5 May 2007 16:18:24 -0400
Message-Id: <11783963053173-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
References: <11783963052286-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Brunyate <abrunyate@yahoo.com>

Signed-off-by: Adrian Brunyate <abrunyate@yahoo.com>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index ee12d03..02c0cc8 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -442,7 +442,7 @@ static int unionfs_remount_fs(struct super_block *sb, int *flags,
 	 * the union to a "ro" or "rw" and the VFS took care of it.  So
 	 * nothing to do and we're done.
 	 */
-	if (options[0] == '\0')
+	if (!options || options[0] == '\0')
 		goto out_error;
 
 	/*
-- 
1.5.0.3.1043.g4342

