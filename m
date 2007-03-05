Return-Path: <linux-kernel-owner+w=401wt.eu-S1750926AbXCEB6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750926AbXCEB6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbXCEB6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:58:32 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38341 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbXCEBzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:10 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs updates
Date: Sun,  4 Mar 2007 20:54:50 -0500
Message-Id: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches (also available though the git tree) address a number
of code cleanliness issues with Unionfs.

You can pull from 'master' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

to receive the following:

Erez Zadok (6):
      fs/unionfs: Fix a memory leak & null pointer dereference
      fs/unionfs/: Fix a memory leak in unionfs_read_super
      fs/unionfs/: Fix copyup_deleted_file dentry leak
      fs/unionfs/: mntput in __cleanup_dentry
      fs/unionfs/: Fix dentry leak in copyup_named_dentry
      fs/unionfs/: Fix unlocking in error paths

Josef 'Jeff' Sipek (7):
      fs/unionfs/: Don't grab dentry private data mutex in unionfs_d_release
      fs/unionfs/: Several small cleanups in unionfs_interpose
      fs/unionfs/: Rename unionfs_d_revalidate_wrap
      fs/unionfs/: Remove alloc_filldir_node
      fs/unionfs/: Use SEEK_{SET,CUR} instead of hardcoded values
      fs/unionfs/: Check return value of d_path
      fs/unionfs/: Miscellaneous coding style fixes

 fs/unionfs/commonfops.c |   22 ++++++++++++++++++----
 fs/unionfs/copyup.c     |   17 +++++++++++++----
 fs/unionfs/dentry.c     |   15 ++++-----------
 fs/unionfs/dirfops.c    |    6 +++---
 fs/unionfs/lookup.c     |   11 +++++++++--
 fs/unionfs/main.c       |   18 ++++++------------
 fs/unionfs/rdstate.c    |    8 +-------
 fs/unionfs/super.c      |    8 ++++++--
 fs/unionfs/union.h      |    2 +-
 9 files changed, 61 insertions(+), 46 deletions(-)

Josef 'Jeff' Sipek.

jsipek@cs.sunysb.edu


