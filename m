Return-Path: <linux-kernel-owner+w=401wt.eu-S1755757Ab0ARBMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab0ARBMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932088Ab0ARBMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:12:46 -0500
Received: from relay1.sgi.com ([192.48.179.29]:58700 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755416Ab0ARBMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:12:42 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201001180112.o0I1CaCH001417@stout.americas.sgi.com>
Date: Sun, 17 Jan 2010 19:12:36 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.33-rc4
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7284ce6c9f6153d1777df5f310c959724d1bd446:
  Linus Torvalds (1):
        Linux 2.6.33-rc4

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Dave Chinner (7):
      xfs: reclaim inodes under a write lock
      xfs: Avoid inodes in reclaim when flushing from inode cache
      xfs: reclaim all inodes by background tree walks
      xfs: Remove inode iolock held check during allocation
      xfs: fix stale inode flush avoidance
      xfs: fix missing error check in xfs_rtfree_range
      xfs: xfs_swap_extents needs to handle dynamic fork offsets

 fs/xfs/linux-2.6/xfs_super.c   |   14 ++--
 fs/xfs/linux-2.6/xfs_sync.c    |  183 +++++++++++++++++++---------------------
 fs/xfs/linux-2.6/xfs_sync.h    |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_dfrag.c             |  106 ++++++++++++++++++++----
 fs/xfs/xfs_iget.c              |    1 -
 fs/xfs/xfs_inode.c             |   21 ++++--
 fs/xfs/xfs_rtalloc.c           |    2 +
 8 files changed, 201 insertions(+), 130 deletions(-)
