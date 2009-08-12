Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZHLGNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZHLGNm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 02:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbZHLGNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 02:13:41 -0400
Received: from relay2.sgi.com ([192.48.179.30]:39453 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751418AbZHLGNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 02:13:40 -0400
Date: Wed, 12 Aug 2009 01:13:31 -0500
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.31-rc6
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090812061331.F29EAA1FAFA7@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 7cb7beb31aa3d941833b6a6e553687422c31e4b6:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../fyu/linux-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (11):
      xfs: avoid memory allocation under m_peraglock in growfs code
      xfs: switch to NOFS allocation under i_lock in xfs_getbmap
      xfs: switch to NOFS allocation under i_lock in xfs_da_state_alloc
      xfs: switch to NOFS allocation under i_lock in xfs_da_buf_make
      xfs: switch to NOFS allocation under i_lock in xfs_dir_cilookup_result
      xfs: switch to NOFS allocation under i_lock in xfs_buf_associate_memory
      xfs: switch to NOFS allocation under i_lock in xfs_attr_rmtval_set
      xfs: switch to NOFS allocation under i_lock in xfs_readlink_bmap
      xfs: switch to NOFS allocation under i_lock in xfs_attr_rmtval_get
      xfs: check for dinode realtime flag corruption
      xfs: fix spin_is_locked assert on uni-processor builds

Eric Sandeen (1):
      use XFS_CORRUPTION_ERROR in xfs_btree_check_sblock

 fs/xfs/linux-2.6/xfs_buf.c |    2 +-
 fs/xfs/xfs_attr.c          |    8 +++++---
 fs/xfs/xfs_bmap.c          |    2 +-
 fs/xfs/xfs_btree.c         |    4 ++--
 fs/xfs/xfs_da_btree.c      |    6 +++---
 fs/xfs/xfs_dir2.c          |    2 +-
 fs/xfs/xfs_fsops.c         |   20 ++++++++++++++------
 fs/xfs/xfs_inode.c         |   10 ++++++++++
 fs/xfs/xfs_log.c           |    2 +-
 fs/xfs/xfs_vnodeops.c      |    4 +++-
 10 files changed, 41 insertions(+), 19 deletions(-)
