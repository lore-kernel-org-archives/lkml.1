Return-Path: <linux-kernel-owner+w=401wt.eu-S964893AbXDIO7I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964893AbXDIO7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:59:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933751AbXDIOyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:54:39 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44000 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933688AbXDIOyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:35 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 07/21] Unionfs: Actually verify if dentry's info node is locked
Date: Mon,  9 Apr 2007 10:53:58 -0400
Message-Id: <11761304543311-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/fanout.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index 3d1dd4c..e8c0fee 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -205,6 +205,7 @@ static inline void unionfs_unlock_dentry(struct dentry *d)
 
 static inline void verify_locked(struct dentry *d)
 {
+	BUG_ON(!mutex_is_locked(&UNIONFS_D(d)->lock));
 }
 
 #endif	/* _FANOUT_H */
-- 
1.5.0.3.268.g3dda

