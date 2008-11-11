Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbYKKD6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbYKKD6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYKKD6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:58:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58811 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752323AbYKKD6N (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:58:13 -0500
Date: Tue, 11 Nov 2008 14:58:05 +1100
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, akpm@linux-foundation.org
Subject: [GIT PULL] XFS update for 2.6.28
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081111035805.EEC4B58FA24A@chook.melbourne.sgi.com>
From: lachlan@sgi.com (Lachlan McIlroy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pull request is a little more conservative than the last one!  Just
critical bug fixes this time.

The following changes since commit 3ad4f597058301c97f362e500a32f63f5c950a45:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../tiwai/sound-2.6

are available in the git repository at:

  git://oss.sgi.com:8090/xfs/xfs for-linus

Dave Chinner (1):
      [XFS] handle memory allocation failures during log initialisation

David Chinner (2):
      [XFS] Account for allocated blocks when expanding directories
      [XFS] XFS: Check for valid transaction headers in recovery

Lachlan McIlroy (2):
      [XFS] Fix use-after-free with log and quotas
      [XFS] Wait for all I/O on truncate to zero file size

 fs/xfs/xfs_da_btree.c    |    5 +++++
 fs/xfs/xfs_dir2.c        |    6 ++++++
 fs/xfs/xfs_inode.c       |    2 +-
 fs/xfs/xfs_log.c         |   39 ++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_log_recover.c |    8 +++++++-
 fs/xfs/xfs_mount.c       |    5 +++--
 6 files changed, 58 insertions(+), 7 deletions(-)
