Return-Path: <linux-kernel-owner+w=401wt.eu-S933751AbXDIO7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751AbXDIO7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXDIOyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:54:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:43997 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933681AbXDIOye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:54:34 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 04/21] Unionfs: Proper comment on rwsem field
Date: Mon,  9 Apr 2007 10:53:55 -0400
Message-Id: <11761304533622-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.268.g3dda
In-Reply-To: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
References: <11761304521844-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/union.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index bae3c76..5676394 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -130,7 +130,7 @@ struct unionfs_sb_info {
 	int bend;
 
 	atomic_t generation;
-	struct rw_semaphore rwsem;
+	struct rw_semaphore rwsem; /* protects access to data+id fields */
 
 	struct unionfs_data *data;
 };
-- 
1.5.0.3.268.g3dda

