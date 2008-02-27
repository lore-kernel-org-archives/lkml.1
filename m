Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYB0UAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYB0UAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbYB0T7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:59:54 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:54556 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759381AbYB0T7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:59:51 -0500
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.25-rc3-git1-ext4-1 released
From: "Theodore Ts'o" <tytso@MIT.EDU>
Phone: (781) 391-3464
Message-Id: <E1JUSQn-0003mN-7U@closure.thunk.org>
Date: Wed, 27 Feb 2008 14:59:09 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've just released 2.6.25-rc3-git1-ext4-1.  It removes the patches that
have been pulled into mainline by Linus.

As a git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git 2.6.25-rc3-git1-ext4-1
http://git.kernel.org/?p=linux/kernel/git/tytso/ext4.git;a=shortlog;h=2.6.25-rc3-git1-ext4-1

As a patchset:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/2.6.25-rc3-git1-ext4-1

                                                - Ted

Akinobu Mita (3):
      ext4: use ext4_group_first_block_no()
      ext4: use ext4_get_group_desc()
      ext4: check ext4_journal_get_write_access() errors

Akira Fujita (4):
      ext4: online defrad header file changes
      ext4: online defrag-- Allocate new contiguous blocks with mballoc
      ext4: online defrag -- Move the file data to the new blocks
      Free space fragmentation functions

Alex Tomas (2):
      vfs: add basic delayed allocation support
      ext4: Add basic delayed allocation support

Andi Kleen (1):
      Convert ext4 to use unlocked_ioctl v2

Aneesh Kumar K.V (5):
      ext4:  Convert list_for_each_rcu() to list_for_each_entry_rcu()
      ext4: undo the stable boundary patch changes
      ext4: Use page_mkwrite vma_operations to get mmap write notification.
      ext4: Enable delalloc and mballoc by default.
      ext4: Show delalloc options

Eric Sandeen (1):
      ext4: reduce mballoc stack usage with noinline

Harvey Harrison (1):
      jbd2: sparse warnings in revoke.c, journal.c

Hisashi Hifumi (1):
      ext4: fdatasync should skip metadata writeout when overwriting

Marcin Slusarz (2):
      ext4: le*_add_cpu conversion
      ext4: convert byte order of constant instead of variable

Mingming Cao (3):
      ext4: remove extra define of ext4_new_blocks_old from mballoc.c
      jbd: blocks reservation fix for large block support
      jbd2: blocks reservation fix for large block support

Theodore Ts'o (2):
      ext4: New inode allocation for FLEX_BG meta-data groups.
      ext4: Stable/Unstable boundary

 fs/buffer.c                     |    3 +-
 fs/ext4/Makefile                |    2 +-
 fs/ext4/balloc.c                |   41 +-
 fs/ext4/defrag.c                | 2206 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/dir.c                   |    2 +-
 fs/ext4/extents.c               |   83 +-
 fs/ext4/file.c                  |   21 +-
 fs/ext4/fsync.c                 |    3 +
 fs/ext4/ialloc.c                |  108 ++-
 fs/ext4/inode.c                 |  191 +++-
 fs/ext4/ioctl.c                 |   25 +-
 fs/ext4/mballoc.c               |   70 +-
 fs/ext4/namei.c                 |    9 +-
 fs/ext4/resize.c                |    6 +-
 fs/ext4/super.c                 |   82 ++-
 fs/ext4/xattr.c                 |   12 +-
 fs/jbd/journal.c                |    7 +-
 fs/jbd2/journal.c               |   20 +-
 fs/jbd2/revoke.c                |    4 +-
 fs/mpage.c                      |  406 +++++++
 include/linux/ext4_fs.h         |  101 ++-
 include/linux/ext4_fs_extents.h |   23 +
 include/linux/ext4_fs_sb.h      |    3 +
 include/linux/mpage.h           |    2 +
 24 files changed, 3283 insertions(+), 147 deletions(-)
 create mode 100644 fs/ext4/defrag.c
