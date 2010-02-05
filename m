Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933422Ab0BECBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 21:01:33 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:58086 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932739Ab0BECBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 21:01:32 -0500
Date: Thu, 4 Feb 2010 20:59:14 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.33
Message-ID: <20100205015913.GA2770@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4B6B7BD5.0180:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The master branch of the btrfs unstable tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

Has a small collection of fixes.  These are mostly bugs, but I put in
one of Josef's safer performance tweaks as well.

Aneesh Kumar K.V (1) commits (+3/-1):
    Btrfs: apply updated fallocate i_size fix

Josef Bacik (1) commits (+2/-44):
    Btrfs: do not try and lookup the file extent when finishing ordered io

Miao Xie (1) commits (+8/-2):
    Btrfs: remove BUG_ON() due to mounting bad filesystem

Roel Kluin (1) commits (+1/-1):
    Btrfs: make error return negative in btrfs_sync_file()

Zheng Yan (2) commits (+5/-6):
    Btrfs: fix race between allocate and release extent buffer. (+1/-2)
    Btrfs: Fix oopsen when dropping empty tree. (+4/-4)

Total: (6) commits

 fs/btrfs/disk-io.c     |    7 +++++-
 fs/btrfs/extent-tree.c |    8 +++----
 fs/btrfs/extent_io.c   |    3 --
 fs/btrfs/file.c        |    2 -
 fs/btrfs/inode.c       |   50 ++++---------------------------------------------
 fs/btrfs/relocation.c  |    3 +-
 6 files changed, 19 insertions(+), 54 deletions(-)
