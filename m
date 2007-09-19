Return-Path: <linux-kernel-owner+w=401wt.eu-S1756853AbXISVZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853AbXISVZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752394AbXISVZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:25:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52800 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbXISVZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:25:00 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 2/6] Unionfs: remove unnecessary comment
Date: Wed, 19 Sep 2007 17:24:36 -0400
Message-Id: <11902370813337-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
References: <1190237080683-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Acked-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
---
 fs/unionfs/fanout.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index c5bf454..afeb9f6 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -320,7 +320,6 @@ static inline void unionfs_copy_attr_times(struct inode *upper)
 			upper->i_ctime = lower->i_ctime;
 		if (timespec_compare(&upper->i_atime, &lower->i_atime) < 0)
 			upper->i_atime = lower->i_atime;
-		/* XXX: should we notify_change on our upper inode? */
 	}
 }
 
-- 
1.5.2.2

