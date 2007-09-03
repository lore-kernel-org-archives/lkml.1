Return-Path: <linux-kernel-owner+w=401wt.eu-S1756438AbXICCYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756438AbXICCYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753707AbXICCYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:24:21 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57581 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbXICCYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:20 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de
Subject: [GIT PULL -mm] Unionfs/fsstack/eCryptfs updates/cleanups/fixes
Date: Sun,  2 Sep 2007 22:20:23 -0400
Message-Id: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a series of patches related to Unionfs, which include three
small VFS/fsstack patches and one eCryptfs patch; the rest are Unionfs
patches.  The patches here represent several months of work and testing
under various conditions, especially low-memory, SMP, and preemption
situations with an assortment of lower systems: ext2/3/4, xfs, reiserfs,
nfs, jffs2, ramfs, tmpfs, cramfs, and squashfs.

You can pull from 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

As I already mentioned to Andrew, some of these patches should go into
Linus's tree, but the remainder depends on them.

Additionally, as Andrew said earlier today, let's figure out whether or not
Unionfs gets merged.


For Linus:
      VFS: export release_open_intent symbol
      VFS/fsstack: remove 3rd argument to fsstack_copy_attr_all
      VFS/fsstack: cpp endif comments

For Andrew:
      Unionfs: fixed compilation error
      Unionfs: do not use fsstack_copy_attr_all
      Unionfs: copyright corrections and updates
      Unionfs: cpp endif comments
      Unionfs: cache-coherency - update inode times
      Unionfs: cache-coherency - dentries
      Unionfs: cache-coherency - file flush
      Unionfs: cache-coherency and fixes for unionfs_rename
      Unionfs: documentation updates
      Unionfs: copyup updates
      Unionfs: file_revalidate updates
      Unionfs: implement f/async
      Unionfs: minor file_release updates
      Unionfs: interpose updates
      Unionfs: unionfs_ioctl bug fixes
      Unionfs: partial_lookup update
      Unionfs: lower nameidata support
      Unionfs: mmap fixes
      Unionfs: handling lower vfsmount fixes
      Unionfs: mount-time option parsing fix
      Unionfs: remove old nfsro option
      Unionfs: readonly branch test fix
      Unionfs: minor remount fixes
      Unionfs: extended attributes fixes
      Unionfs: use file f_path field
      Unionfs: assorted comment and style updates
      Unionfs: update unionfs version number
      Unionfs: debugging and validation of fan-out invariants
      Unionfs: unionfs_create rewrite


Josef 'Jeff' Sipek, on behalf of the Unionfs team.

jsipek@cs.sunysb.edu
