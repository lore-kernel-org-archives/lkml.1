Return-Path: <linux-kernel-owner+w=401wt.eu-S935530AbZLPV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935530AbZLPV0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbZLPV0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:26:16 -0500
Received: from relay2.sgi.com ([192.48.179.30]:55086 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756127AbZLPV0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:26:15 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <200912162126.nBGLQAbZ012632@stout.americas.sgi.com>
Date: Wed, 16 Dec 2009 15:26:10 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.33-rc1
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more XFS update for -rc1, now that the new XFS tracing code has
been committed.

					-Alex

The following changes since commit 5ac4d630eb87656bd4dc313b910776d54d88ea28:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.dk/linux-2.6-block

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: check for not fully initialized inodes in xfs_ireclaim
      xfs: kill xfs_bmbt_rec_32/64 types

Dave Chinner (2):
      xfs: improve metadata I/O merging in the elevator
      XFS: Free buffer pages array unconditionally

 fs/xfs/linux-2.6/xfs_buf.c |   10 +++++++---
 fs/xfs/linux-2.6/xfs_buf.h |    1 +
 fs/xfs/xfs_bmap_btree.h    |   14 +++-----------
 fs/xfs/xfs_iget.c          |   12 ++++++++----
 fs/xfs/xfs_inode_item.h    |    6 +++---
 fs/xfs/xfs_log.c           |    2 ++
 include/linux/fs.h         |    1 +
 7 files changed, 25 insertions(+), 21 deletions(-)
