Return-Path: <linux-kernel-owner+w=401wt.eu-S1759128AbZF1Ql3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759128AbZF1Ql3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZF1Q2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:36 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1179 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZF1Q2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:17 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, autofs@linux.kernel.org
Subject: [PATCH 54/62] fs/autofs/dirhash.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:59 -0700
Message-Id: <4a9aa1ca3ca167d2bb45515d61e9f88b7e0c0e78.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/autofs/dirhash.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/autofs/dirhash.c b/fs/autofs/dirhash.c
index 2316e94..e947915 100644
--- a/fs/autofs/dirhash.c
+++ b/fs/autofs/dirhash.c
@@ -90,7 +90,7 @@ struct autofs_dir_ent *autofs_expire(struct super_block *sb,
 			DPRINTK(("autofs: not expirable (not a mounted directory): %s\n", ent->name));
 			continue;
 		}
-		while (d_mountpoint(path.dentry) && follow_down(&path));
+		while (d_mountpoint(path.dentry) && follow_down(&path))
 			;
 		umount_ok = may_umount(path.mnt);
 		path_put(&path);
-- 
1.6.3.1.10.g659a0.dirty

