Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbXEXAgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbXEXAgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbXEXAgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:18 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40188 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXEXAgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:17 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [GIT PULL -mm] Unionfs cleanups and fixes
Date: Wed, 23 May 2007 20:35:50 -0400
Message-Id: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches consist of mostly cleanups of the Unionfs code, as
well as fixes for several harder to hit bugs (resource/memory leaks).

As before, there is a git repo at:

git://git.kernel.org/pub/scm/linux/kernel/git/jsipek/unionfs.git

(master.kernel.org:/pub/scm/linux/kernel/git/jsipek/unionfs.git)

There are 21 new commits:

	Unionfs: Correctly decrement refcounts of mnt's upon branch management
	Unionfs: Removed a trailing whitespace
	Unionfs: Actually catch bad use of unionfs_mnt{get,put}
	Unionfs: Remove defunct unionfs_put_inode super op
	Unionfs: Documentation update regarding overlapping branches and new lookup code
	Unionfs: Disallow setting leftmost branch to readonly
	Unionfs: Use krealloc instead of open-coding the functionality
	Unionfs: Call realloc unconditionally
	Unionfs: Don't leak resources when copyup fails partially
	Unionfs: Prefix external functions with 'extern' properly
	Unionfs: Combine unionfs_write with __unionfs_write.
	Unionfs: Move unionfs_query_file to commonfops.c
	Unionfs: Rename our "do_rename" to __unionfs_rename
	Unionfs: Rename Unionfs's double_lock_dentry to avoid confusion
	Unionfs: Consistent pointer declaration spacing
	Unionfs: Added numerous comments
	Unionfs: Cleanup of strings and comments
	Unionfs: Add missing copyright notices
	Unionfs: Every printk should prefix with "unionfs: " consistently
	Unionfs: Coding style fixes
	Unionfs: Tiny documentation fixups

Thanks,

Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

