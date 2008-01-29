Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYA2M66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYA2M66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYA2M6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:58:48 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64428 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYA2M6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:58:47 -0500
Date: Tue, 29 Jan 2008 07:53:07 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 update
Message-ID: <20080129125307.GF6774@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
References: <E1JJjMo-00011j-EU@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JJjMo-00011j-EU@closure.thunk.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>fwiw, diffstat is confused by git's diff output; you need to use
>'diffstat -p1'

Argh, I have *got* to create a script that does this automatically.

Revised diffstat -p1 output follows...

						- Ted

 Documentation/filesystems/ext4.txt           |   20 
 Documentation/filesystems/proc.txt           |   39 
 fs/Kconfig                                   |    1 
 fs/afs/dir.c                                 |    9 
 fs/afs/inode.c                               |    3 
 fs/buffer.c                                  |   44 
 fs/ext2/super.c                              |   32 
 fs/ext3/super.c                              |   32 
 fs/ext4/Makefile                             |    4 
 fs/ext4/balloc.c                             |  251 +
 fs/ext4/dir.c                                |   14 
 fs/ext4/extents.c                            |  525 +--
 fs/ext4/file.c                               |   23 
 fs/ext4/group.h                              |    8 
 fs/ext4/ialloc.c                             |  161 
 fs/ext4/inode.c                              |  396 +-
 fs/ext4/ioctl.c                              |    7 
 fs/ext4/mballoc.c                            | 4552 +++++++++++++++++++++++++++
 fs/ext4/migrate.c                            |  570 +++
 fs/ext4/namei.c                              |  135 
 fs/ext4/resize.c                             |   28 
 fs/ext4/super.c                              |  389 +-
 fs/ext4/xattr.c                              |    4 
 fs/inode.c                                   |   39 
 fs/jbd2/checkpoint.c                         |   22 
 fs/jbd2/commit.c                             |  255 +
 fs/jbd2/journal.c                            |  368 ++
 fs/jbd2/recovery.c                           |  151 
 fs/jbd2/revoke.c                             |    6 
 fs/jbd2/transaction.c                        |   34 
 fs/read_write.c                              |    1 
 include/asm-arm/bitops.h                     |    2 
 include/asm-generic/bitops/ext2-non-atomic.h |    2 
 include/asm-generic/bitops/le.h              |    4 
 include/asm-m68k/bitops.h                    |    2 
 include/asm-m68knommu/bitops.h               |    2 
 include/asm-powerpc/bitops.h                 |    4 
 include/asm-s390/bitops.h                    |    2 
 include/linux/buffer_head.h                  |    2 
 include/linux/ext4_fs.h                      |  224 +
 include/linux/ext4_fs_extents.h              |   25 
 include/linux/ext4_fs_i.h                    |   25 
 include/linux/ext4_fs_sb.h                   |   55 
 include/linux/fs.h                           |   21 
 include/linux/jbd2.h                         |  135 
 lib/find_next_bit.c                          |   43 
 46 files changed, 7773 insertions(+), 898 deletions(-)
