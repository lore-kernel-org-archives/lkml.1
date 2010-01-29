Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942Ab0A2RhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab0A2RhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 12:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191Ab0A2RhM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 12:37:12 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:53070 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0A2RhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 12:37:10 -0500
Date: Fri, 29 Jan 2010 12:35:25 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-btrfs@vger.kernel.org
Subject: [GIT PULL] Btrfs updates for 2.6.33
Message-ID: <20100129173525.GA2819@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B631CA1.00F4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

The btrfs-unstable master branch has some updates:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git master

It will pull into either 2.6.32 or 2.6.33-git.

These are bug fixes, mostly around btrfs multi-device code and replacing
failed drives.  It also includes a fix for the orphan cleanup fix in the
last pull, this version is much better.

Outside of fixes, this adds mount -o compress-force, which won't back
off compressing files when part of the file doesn't compress well.

Aneesh Kumar K.V (1) commits (+9/-4):
    Btrfs: Use correct values when updating inode i_size on fallocate

Chris Mason (1) commits (+11/-2):
    Btrfs: Add mount -o compress-force

Josef Bacik (4) commits (+15/-10):
    Btrfs: do not mark the chunk as readonly if in degraded mode (+5/-0)
    Btrfs: check total number of devices when removing missing (+2/-2)
    Btrfs: check return value of open_bdev_exclusive properly (+2/-2)
    Btrfs: run orphan cleanup on default fs root (+6/-6)

Miao Xie (1) commits (+0/-14):
    Btrfs: remove tree_search() in extent_map.c

Yang Hongyang (1) commits (+1/-0):
    Btrfs: fix a memory leak in btrfs_init_acl

Total: (8) commits

 fs/btrfs/acl.c        |    1 +
 fs/btrfs/ctree.h      |    1 +
 fs/btrfs/disk-io.c    |    6 ++++++
 fs/btrfs/extent_map.c |   14 --------------
 fs/btrfs/inode.c      |   22 +++++++++++-----------
 fs/btrfs/super.c      |    9 ++++++++-
 fs/btrfs/volumes.c    |   13 +++++++++----
 7 files changed, 36 insertions(+), 30 deletions(-)
