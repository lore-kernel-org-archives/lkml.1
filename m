Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbZHGTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbZHGTBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932908AbZHGTBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:01:53 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:44739 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932854AbZHGTBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:01:52 -0400
Date: Fri, 7 Aug 2009 15:01:09 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Btrfs fixes for 2.6.31-rc
Message-ID: <20090807190109.GI17129@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt015.oracle.com [141.146.116.24]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010206.4A7C79F7.014C:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

Linus, please pull these from the master branch of:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable.git

These are relatively small bug fixes, including two fixes for 
tree-log recovery on mount (one oops and one infinite loop).

Bartlomiej Zolnierkiewicz (1) commits (+1/-2):
    Btrfs: remove superfluous NULL pointer check in btrfs_rename()

Chris Mason (1) commits (+17/-4):
    Btrfs: make sure the async caching thread advances the key

Josef Bacik (1) commits (+64/-9):
    Btrfs: fix btrfs_remove_from_free_space corner case

Julia Lawall (1) commits (+3/-3):
    Btrfs: correct error-handling zlib error handling

Yan Zheng (1) commits (+7/-2):
    Btrfs: fix balancing oops when invalidate_inode_pages2 returns EBUSY

Total: (5) commits

 fs/btrfs/extent-tree.c      |   21 ++++++++++--
 fs/btrfs/free-space-cache.c |   73 ++++++++++++++++++++++++++++++++++++++------
 fs/btrfs/inode.c            |    3 -
 fs/btrfs/relocation.c       |    9 ++++-
 fs/btrfs/zlib.c             |    6 +--
 5 files changed, 92 insertions(+), 20 deletions(-)
