Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZDMVJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZDMVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZDMVJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:09:47 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58353 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbZDMVJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:09:46 -0400
Date: Mon, 13 Apr 2009 16:09:39 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.30-rc2
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090413210939.A986BA24F540@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 62b8e680e61d3f48f2a12ee248ca03ea8f376926:
  David Howells (1):
        MN10300: Kill MN10300's own profiling Kconfig

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (9):
      xfs: validate log feature fields correctly
      xfs: fix double free of inode
      xfs: prevent unwritten extent conversion from blocking I/O completion
      xfs: inform the xfsaild of the push target before sleeping
      xfs: use xfs_sync_inodes() for device flushing
      xfs: make inode flush at ENOSPC synchronous
      xfs: block callers of xfs_flush_inodes() correctly
      xfs: flush delayed allcoation blocks on ENOSPC in create
      xfs: remove xfs_flush_space

Felix Blyakher (1):
      Merge branch 'master' into for-linus

 fs/xfs/linux-2.6/xfs_aops.c    |   38 +++++++++++---------
 fs/xfs/linux-2.6/xfs_aops.h    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c     |    9 +++++
 fs/xfs/linux-2.6/xfs_fs_subr.c |   14 ++++----
 fs/xfs/linux-2.6/xfs_lrw.c     |   18 +++++++++-
 fs/xfs/linux-2.6/xfs_sync.c    |   78 +++++++++++++++++-----------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    9 +++--
 fs/xfs/xfs_iget.c              |   23 +++++++-----
 fs/xfs/xfs_iomap.c             |   61 ++++++++-----------------------
 fs/xfs/xfs_iomap.h             |    3 +-
 fs/xfs/xfs_log.c               |   78 +++++++++++++++++++++++++---------------
 fs/xfs/xfs_mount.h             |    2 +-
 fs/xfs/xfs_vnodeops.c          |    7 ++++
 13 files changed, 180 insertions(+), 161 deletions(-)
