Return-Path: <linux-kernel-owner+w=401wt.eu-S1759313AbZAVWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313AbZAVWn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZAVWnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:43:20 -0500
Received: from relay2.sgi.com ([192.48.179.30]:39017 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752039AbZAVWnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:43:19 -0500
Date: Thu, 22 Jan 2009 16:43:14 -0600
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.29-rc3
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090122224314.11896155705D@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit f3b8436ad9a8ad36b3c9fa1fe030c7f38e5d3d0b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (7):
      xfs: fix dentry aliasing issues in open_by_handle
      xfs: use mnt_want_write in compat_attrmulti ioctl
      xfs: add a separate lock class for the per-mount list of dquots
      xfs: lockdep annotations for xfs_dqlock2
      xfs: add a lock class for group/project dquots
      xfs: fix bad_features2 fixups for the root filesystem
      xfs: sanity check attr fork size

Dave Chinner (1):
      Long btree pointers are still 64 bit on disk

Eric Sandeen (1):
      [XFS] Remove the rest of the macro-to-function indirections.

 fs/xfs/Kconfig                 |    1 +
 fs/xfs/linux-2.6/xfs_ioctl.c   |  305 ++++++++++++++++++----------------------
 fs/xfs/linux-2.6/xfs_ioctl.h   |   15 ++-
 fs/xfs/linux-2.6/xfs_ioctl32.c |  184 ++++++++-----------------
 fs/xfs/linux-2.6/xfs_super.c   |   17 ++-
 fs/xfs/quota/xfs_dquot.c       |   38 ++++--
 fs/xfs/quota/xfs_dquot.h       |   10 ++
 fs/xfs/quota/xfs_qm.c          |    9 ++
 fs/xfs/xfs_ag.h                |    6 +-
 fs/xfs/xfs_alloc_btree.c       |    2 +-
 fs/xfs/xfs_attr.c              |   26 ++--
 fs/xfs/xfs_bmap.c              |  166 +++++++++++-----------
 fs/xfs/xfs_bmap.h              |    2 -
 fs/xfs/xfs_bmap_btree.c        |   10 +-
 fs/xfs/xfs_bmap_btree.h        |    4 -
 fs/xfs/xfs_btree.c             |   16 +-
 fs/xfs/xfs_da_btree.c          |    8 +-
 fs/xfs/xfs_ialloc.c            |    6 +-
 fs/xfs/xfs_ialloc.h            |    2 -
 fs/xfs/xfs_ialloc_btree.h      |    1 -
 fs/xfs/xfs_inode.c             |   19 ++-
 fs/xfs/xfs_inode_item.h        |    4 -
 fs/xfs/xfs_iomap.c             |   10 +-
 fs/xfs/xfs_itable.c            |    6 +-
 fs/xfs/xfs_mount.c             |   26 ++--
 fs/xfs/xfs_mount.h             |    9 +-
 fs/xfs/xfs_rename.c            |    2 +-
 fs/xfs/xfs_rtalloc.c           |    2 +-
 fs/xfs/xfs_rw.h                |    1 -
 fs/xfs/xfs_sb.h                |    2 +-
 fs/xfs/xfs_vnodeops.c          |   20 ++--
 31 files changed, 441 insertions(+), 488 deletions(-)
