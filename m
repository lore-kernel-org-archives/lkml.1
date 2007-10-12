Return-Path: <linux-kernel-owner+w=401wt.eu-S933285AbXJLWtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285AbXJLWtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbXJLWVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:21:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:53455 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932784AbXJLWVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:21:47 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 53/75] sysfs: fix comments of sysfs_add/remove_one()
Date: Fri, 12 Oct 2007 15:16:57 -0700
Message-Id: <11922276913288-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276862914-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs_add/remove_one() now link and unlink the target dirent into and
from the children list.  Update comments accordingly.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5d95aa8..fc615ee 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -410,10 +410,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
  *	@sd: sysfs_dirent to be added
  *
  *	Get @acxt->parent_sd and set sd->s_parent to it and increment
- *	nlink of parent inode if @sd is a directory.  @sd is NOT
- *	linked into the children list of the parent.  The caller
- *	should invoke sysfs_link_sibling() after this function
- *	completes if @sd needs to be on the children list.
+ *	nlink of parent inode if @sd is a directory and link into the
+ *	children list of the parent.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
@@ -453,9 +451,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
  *	@sd: sysfs_dirent to be added
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
- *	directory.  @sd is NOT unlinked from the children list of the
- *	parent.  The caller is repsonsible for removing @sd from the
- *	children list before calling this function.
+ *	directory.  @sd is unlinked from the children list.
  *
  *	This function should be called between calls to
  *	sysfs_addrm_start() and sysfs_addrm_finish() and should be
-- 
1.5.3.4

