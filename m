Return-Path: <linux-kernel-owner+w=401wt.eu-S1759190AbXGITe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759190AbXGITe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 15:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXGITev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 15:34:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39471 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXGITev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 15:34:51 -0400
To: torvalds@linux-foundation.org
Subject: [git pull] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20070709193443.C9B6482BFA@kleikamp.austin.ibm.com>
Date: Mon,  9 Jul 2007 14:34:43 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com (Dave Kleikamp)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This will update the following files:

 fs/jfs/endian24.h     |    2 
 fs/jfs/jfs_debug.c    |   28 --
 fs/jfs/jfs_debug.h    |    2 
 fs/jfs/jfs_dinode.h   |   42 +--
 fs/jfs/jfs_dmap.c     |  419 +++++++++++++++++++--------------------
 fs/jfs/jfs_dmap.h     |  118 +++++------
 fs/jfs/jfs_dtree.c    |  105 ++++-----
 fs/jfs/jfs_dtree.h    |    2 
 fs/jfs/jfs_extent.c   |  102 ++++-----
 fs/jfs/jfs_filsys.h   |   13 -
 fs/jfs/jfs_imap.c     |  296 +++++++++++++--------------
 fs/jfs/jfs_imap.h     |   98 ++++-----
 fs/jfs/jfs_incore.h   |    4 
 fs/jfs/jfs_logmgr.c   |   90 ++++----
 fs/jfs/jfs_logmgr.h   |   26 +-
 fs/jfs/jfs_metapage.c |    3 
 fs/jfs/jfs_mount.c    |    6 
 fs/jfs/jfs_txnmgr.c   |  302 ++++++++++++++--------------
 fs/jfs/jfs_txnmgr.h   |    2 
 fs/jfs/jfs_types.h    |   20 -
 fs/jfs/jfs_umount.c   |    2 
 fs/jfs/jfs_xtree.c    |  428 +++++++++++++++++++---------------------
 fs/jfs/jfs_xtree.h    |   48 ++--
 fs/jfs/namei.c        |   26 +-
 fs/jfs/resize.c       |   48 ++--
 fs/jfs/xattr.c        |    9 
 26 files changed, 1096 insertions(+), 1145 deletions(-)

through these ChangeSets:

Commit: 288e4d838d1e999c0515f85a337cacb2be233071 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Wed, 13 Jun 2007 10:17:50 -0500 

    JFS: Update print_hex_dump() syntax
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: 209e101bf408a50acc426e32c8252daefacde5b0 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Wed, 06 Jun 2007 16:30:17 -0500 

    JFS: use print_hex_dump() rather than private dump_mem() function
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

Commit: f720e3ba558680cc7dd3995d005bdc8ee2ef46af 
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com> Wed, 06 Jun 2007 15:28:35 -0500 

    JFS: Whitespace cleanup and remove some dead code
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

