Return-Path: <linux-kernel-owner+w=401wt.eu-S1761570AbXFQTMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761570AbXFQTMc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761151AbXFQTKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:00 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36867 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760023AbXFQTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:09:57 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs cleanups, fixes, and mmap
Date: Sun, 17 Jun 2007 15:09:07 -0400
Message-Id: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches consist of mostly cleanups and bug fixes of the
Unionfs code. The major improvement is the new mmap implementation, as well
as a major locking overhaul.

As before, there is a git repo at:

git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

(master.kernel.org:/pub/scm/linux/kernel/git/jsipek/unionfs.git)

There are 16 new commits:

Erez Zadok (9):
      Unionfs: Don't revalidate dropped dentries
      Unionfs: Retry lookup for different silly-renamed files
      Unionfs: Set lower inodes correctly after branch management succeeds
      Unionfs: call statfs on lower file system properly
      MAINTAINERS: Add Erez Zadok as a maintainer of Unionfs
      Unionfs: Add standard copyright comment to include/linux/union_fs.h
      Unionfs: Remove unnecessary #define
      Unionfs: merge find_new_branch_index and branch_id_to_idx into one function
      Unionfs: Revalidate dentries passed to all inode/super operations

Josef 'Jeff' Sipek (5):
      Unionfs: Cleanup new_dentry_private_data
      Unionfs: Change free_dentry_private_info to take a struct dentry
      Unionfs: Add BUG_ONs to unionfs_lower_*
      Unionfs: Change the semantics of sb info's rwsem
      Unionfs: Remove superfluous check for NULL pointer

Randy Dunlap (1):
      unionfs section mismatch

Yiannis Pericleous (1):
      Unionfs: mmap implementation

Thanks,

Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
