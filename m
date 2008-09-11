Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYIKMeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYIKMeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYIKMeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:34:05 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:58151 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754068AbYIKMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:34:02 -0400
Date: Thu, 11 Sep 2008 14:33:50 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       vigneshbabu@gmail.com, richard.genoud@gmail.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] fs/namespace.c: Drop code after return
Message-ID: <Pine.LNX.4.64.0809111433270.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The extra semicolon serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
---

 fs/namespace.c                |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 6e283c9..7e6151a 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1993,7 +1993,7 @@ static struct mnt_namespace *dup_mnt_ns(struct mnt_namespace *mnt_ns,
 	if (!new_ns->root) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
-		return ERR_PTR(-ENOMEM);;
+		return ERR_PTR(-ENOMEM);
 	}
 	spin_lock(&vfsmount_lock);
 	list_add_tail(&new_ns->list, &new_ns->root->mnt_list);
