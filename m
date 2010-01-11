Return-Path: <linux-kernel-owner+w=401wt.eu-S1752901Ab0AKOqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab0AKOqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479Ab0AKOqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:46:03 -0500
Received: from relay1.sgi.com ([192.48.179.29]:33367 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752417Ab0AKOqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:46:01 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201001111445.o0BEjt7M024641@stout.americas.sgi.com>
Date: Mon, 11 Jan 2010 08:45:55 -0600
To: torvalds@linux-foundation.org
Subject: [GIT PULL] XFS update 2 for 2.6.33-rc3
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3 bug fixes and a tracing change that reduces text footprint
by about 40% for XFS.

					-Alex

The following changes since commit 3c8ad49b015eb115fbd6982f56d530f53cf57f84:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../roland/infiniband

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (2):
      xfs: use DECLARE_EVENT_CLASS
      xfs: fix timestamp handling in xfs_setattr

Dave Chinner (2):
      xfs: Don't flush stale inodes
      xfs: Ensure we force all busy extents in range to disk

 fs/xfs/linux-2.6/xfs_acl.c   |    3 +-
 fs/xfs/linux-2.6/xfs_trace.h | 1141 ++++++++++++++++++++++--------------------
 fs/xfs/xfs_alloc.c           |   44 +-
 fs/xfs/xfs_inode.c           |   10 +-
 fs/xfs/xfs_vnodeops.c        |   93 ++--
 5 files changed, 666 insertions(+), 625 deletions(-)
