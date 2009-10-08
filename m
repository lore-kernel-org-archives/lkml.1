Return-Path: <linux-kernel-owner+w=401wt.eu-S1759668AbZJHTMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668AbZJHTMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759236AbZJHTMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:12:34 -0400
Received: from relay1.sgi.com ([192.48.179.29]:50399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759195AbZJHTMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:12:33 -0400
Date: Thu, 8 Oct 2009 14:11:48 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200910081911.n98JBm1T019194@stout.americas.sgi.com>
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.32
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 0eca52a92735f43462165efe00a7e394345fb38e:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'master' into for-linus

Christoph Hellwig (3):
      xfs: implement ->dirty_inode to fix timestamp handling
      xfs: cleanup ->sync_fs
      xfs: stop calling filemap_fdatawait inside ->fsync

Dave Chinner (3):
      xfs: fix xfs_quiesce_data
      xfs: mark inodes dirty before issuing I/O
      xfs: make sure xfs_sync_fsdata covers the log

Eric Sandeen (1):
      fix readahead calculations in xfs_dir2_leaf_getdents()

 fs/xfs/linux-2.6/xfs_aops.c  |   38 ++++++++++++++++++++-------
 fs/xfs/linux-2.6/xfs_file.c  |    9 +-----
 fs/xfs/linux-2.6/xfs_iops.c  |   41 ++++++++++------------------
 fs/xfs/linux-2.6/xfs_lrw.c   |    2 +-
 fs/xfs/linux-2.6/xfs_super.c |   59 +++++++++++++++++++++++++++++-------------
 fs/xfs/linux-2.6/xfs_sync.c  |   36 ++++++++++++++++++-------
 fs/xfs/xfs_dfrag.c           |    8 +++---
 fs/xfs/xfs_dir2_leaf.c       |    4 ++-
 fs/xfs/xfs_inode.c           |    4 +-
 fs/xfs/xfs_inode.h           |    2 +-
 fs/xfs/xfs_inode_item.c      |   18 ++++++++-----
 fs/xfs/xfs_itable.c          |   21 +++++++++-----
 fs/xfs/xfs_vnodeops.c        |    6 ----
 13 files changed, 146 insertions(+), 102 deletions(-)
