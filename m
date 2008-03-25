Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbYCYISE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbYCYISE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 04:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbYCYIRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 04:17:55 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59718 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbYCYIRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:17:54 -0400
Date: Tue, 25 Mar 2008 08:17:52 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches
Message-ID: <20080325081752.GJ10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

misc VFS fixes for 2.6.25.  Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (5):
      restore export of do_kern_mount()
      sanitize hppfs
      double dput() on failure exit in tiny-shmem
      double iput() on failure exit in hugetlb
      get stack footprint of pathname resolution back to relative sanity

Christoph Hellwig (1):
      check for null vfsmount in dentry_open()

Dave Hansen (2):
      hppfs pass vfsmount to dentry_open()
      fix up new filp allocators

Jeff Mahoney (1):
      reiserfs: eliminate private use of struct file in xattr

Diffstat:
 fs/anon_inodes.c      |   18 +-
 fs/file_table.c       |    6 +
 fs/hppfs/hppfs_kern.c |  435 +++++++++++++++++++++++--------------------------
 fs/hugetlbfs/inode.c  |    2 +-
 fs/namei.c            |   63 ++++----
 fs/open.c             |   12 ++
 fs/pipe.c             |   19 +-
 fs/reiserfs/xattr.c   |  110 ++++---------
 fs/super.c            |    1 +
 mm/tiny-shmem.c       |    2 +
 10 files changed, 302 insertions(+), 366 deletions(-)

