Return-Path: <linux-kernel-owner+w=401wt.eu-S1762667AbZFKKvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762667AbZFKKvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbZFKKvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:51:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37500 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757940AbZFKKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:51:30 -0400
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Thu, 11 Jun 2009 11:51:29 +0100
Message-Id: <1244717489.29604.805.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes. I have one other patch (not
in this tree) for the current merge window and I'll send that once the
tracing code upon which it depends has been merged,

Steve.

--------------------------------------------------------------------------------
The following changes since commit a4d7749be5de4a7261bcbe3c7d96c748792ec455:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Abhijith Das (2):
      GFS2: Fix timestamps on write
      GFS2: smbd proccess hangs with flock() call.

Steven Whitehouse (23):
      GFS2: Update the rw flags
      GFS2: Optimise writepage for metadata
      GFS2: Something nonlinear this way comes!
      GFS2: Move journal live test at transaction start
      GFS2: Add commit= mount option
      GFS2: Remove a couple of unused sysfs entries
      GFS2: Umount recovery race fix
      GFS2: Update docs
      GFS2: Don't warn when delete inode fails on ro filesystem
      GFS2: Improve resource group error handling
      GFS2: Add a rgrp bitmap full flag
      GFS2: Be more aggressive in reclaiming unlinked inodes
      GFS2: Clean up some file names
      GFS2: Merge mount.c and ops_super.c into super.c
      GFS2: Move gfs2_rmdiri into ops_inode.c
      GFS2: Move gfs2_readlinki into ops_inode.c
      GFS2: Move gfs2_unlink_ok into ops_inode.c
      GFS2: Remove lockstruct subdir from gfs2 sysfs files
      GFS2: Remove args subdir from gfs2 sysfs files
      GFS2: Remove unused variable
      GFS2: Fix locking issue mounting gfs2meta fs
      GFS2: Fix cache coherency between truncate and O_DIRECT read
      GFS2: Merge gfs2_get_sb into gfs2_get_sb_meta

 Documentation/filesystems/gfs2-glocks.txt |    2 +-
 Documentation/filesystems/gfs2.txt        |   19 +-
 fs/gfs2/Kconfig                           |    1 +
 fs/gfs2/Makefile                          |    4 +-
 fs/gfs2/{ops_address.c => aops.c}         |   21 +-
 fs/gfs2/bmap.c                            |   12 +-
 fs/gfs2/{ops_dentry.c => dentry.c}        |    0
 fs/gfs2/dir.c                             |   11 +-
 fs/gfs2/eattr.c                           |   14 +-
 fs/gfs2/{ops_export.c => export.c}        |    0
 fs/gfs2/{ops_file.c => file.c}            |   36 +-
 fs/gfs2/glock.c                           |   21 +-
 fs/gfs2/glops.c                           |   20 +-
 fs/gfs2/incore.h                          |   27 +-
 fs/gfs2/inode.c                           |  150 +-----
 fs/gfs2/inode.h                           |   52 +-
 fs/gfs2/log.c                             |    6 +-
 fs/gfs2/lops.c                            |   14 +-
 fs/gfs2/main.c                            |    8 +
 fs/gfs2/meta_io.c                         |  105 +++-
 fs/gfs2/mount.c                           |  185 ------
 fs/gfs2/ops_address.h                     |   23 -
 fs/gfs2/ops_fstype.c                      |   68 +--
 fs/gfs2/ops_inode.c                       |  146 +++++
 fs/gfs2/ops_super.c                       |  723 -----------------------
 fs/gfs2/quota.c                           |    1 -
 fs/gfs2/recovery.c                        |  102 +---
 fs/gfs2/recovery.h                        |    2 +-
 fs/gfs2/rgrp.c                            |  141 +++--
 fs/gfs2/rgrp.h                            |   47 +-
 fs/gfs2/super.c                           |  903 ++++++++++++++++++++++++++++-
 fs/gfs2/sys.c                             |  245 +++------
 fs/gfs2/trans.c                           |    9 +-
 33 files changed, 1534 insertions(+), 1584 deletions(-)
 rename fs/gfs2/{ops_address.c => aops.c} (98%)
 rename fs/gfs2/{ops_dentry.c => dentry.c} (100%)
 rename fs/gfs2/{ops_export.c => export.c} (100%)
 rename fs/gfs2/{ops_file.c => file.c} (97%)
 delete mode 100644 fs/gfs2/mount.c
 delete mode 100644 fs/gfs2/ops_address.h
 delete mode 100644 fs/gfs2/ops_super.c


