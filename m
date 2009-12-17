Return-Path: <linux-kernel-owner+w=401wt.eu-S1764861AbZLQQY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764861AbZLQQY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762776AbZLQQY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:24:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55139 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759359AbZLQQY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:24:56 -0500
Date: Thu, 17 Dec 2009 16:24:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs pile 2
Message-ID: <20091217162454.GA18217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Misc bits and pieces, cleaning the table for scaling stuff...
Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ master
in a few minutes (or directly from hera)

Al Viro (1):
      dio: fix use-after-free

Christoph Hellwig (3):
      fix up O_SYNC comments
      fold do_sync_file_range into sys_sync_file_range
      kill I_LOCK

Erez Zadok (2):
      fsstack/ecryptfs: remove unused get_nlinks param to fsstack_copy_attr_all
      VFS/fsstack: handle 32-bit smp + preempt + large files in fsstack_copy_inode_size

Jeff Layton (1):
      vfs: remove extraneous NULL d_inode check from do_filp_open

Nick Piggin (2):
      fs: anon_inodes implement dname
      fs: no games with DCACHE_UNHASHED

Diffstat:
 arch/alpha/include/asm/fcntl.h |    2 +-
 arch/mips/include/asm/fcntl.h  |    2 +-
 arch/sparc/include/asm/fcntl.h |    2 +-
 fs/anon_inodes.c               |   17 ++++------
 fs/direct-io.c                 |    2 +-
 fs/ecryptfs/dentry.c           |    2 +-
 fs/ecryptfs/inode.c            |    6 ++--
 fs/ecryptfs/main.c             |    2 +-
 fs/gfs2/inode.c                |    2 +-
 fs/inode.c                     |   26 +++++++-------
 fs/jfs/jfs_txnmgr.c            |    2 +-
 fs/namei.c                     |    2 +-
 fs/ntfs/inode.c                |    6 ++--
 fs/pipe.c                      |   18 ----------
 fs/stack.c                     |   71 ++++++++++++++++++++++++++++++---------
 fs/sync.c                      |   59 +++++++++++++--------------------
 fs/ubifs/file.c                |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |    2 +-
 fs/xfs/xfs_iget.c              |    4 +-
 include/asm-generic/fcntl.h    |    2 +-
 include/linux/fs.h             |   40 +++++++++-------------
 include/linux/fs_stack.h       |    6 +--
 include/linux/writeback.h      |    3 +-
 net/socket.c                   |   19 -----------
 24 files changed, 136 insertions(+), 163 deletions(-)
