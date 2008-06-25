Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbYFYDc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbYFYDc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFYDcu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:32:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbYFYDcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:32:50 -0400
Date: Wed, 25 Jun 2008 04:32:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches
Message-ID: <20080625033249.GB28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc fixes + several obvious cleanups + dcache.c locking annotation
fixes.  Please, pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Diffstat:
 fs/block_dev.c         |   12 +++++++-
 fs/dcache.c            |   68 ++++++++++++++++++++++++------------------------
 fs/locks.c             |    6 ----
 fs/namei.c             |   26 +++++++++---------
 fs/pipe.c              |   10 +++----
 fs/utimes.c            |   59 +++++++++++++++++++----------------------
 include/linux/dcache.h |    2 +-
 include/linux/fs.h     |    2 -
 8 files changed, 90 insertions(+), 95 deletions(-)

Shortlog:
Al Viro (1):
      fix cgroup-inflicted breakage in block_dev.c

Andreas Gruenbacher (1):
      [patch 3/3] vfs: make d_path() consistent across mount operations

Denis V. Lunev (1):
      [patch 4/4] flock: remove unused fields from file_lock_operations

Jan Blunck (1):
      [patch 1/4] vfs: path_{get,put}() cleanups

Jan Engelhardt (1):
      [patch 2/4] fs: make struct file arg to d_path const

Marcin Slusarz (1):
      [patch 3/4] vfs: fix ERR_PTR abuse in generic_readlink

Michael Kerrisk (4):
      [patch for 2.6.26 2/4] vfs: utimensat(): be consistent with utime() for immutable and append-only files
      [patch for 2.6.26 1/4] vfs: utimensat(): ignore tv_sec if tv_nsec == UTIME_OMIT or UTIME_NOW
      [patch for 2.6.26 3/4] vfs: utimensat(): fix error checking for {UTIME_NOW,UTIME_OMIT} case
      [patch for 2.6.26 4/4] vfs: utimensat(): fix write access check for futimens()

Miklos Szeredi (2):
      [patch 1/3] vfs: dcache sparse fixes
      [patch 2/3] vfs: dcache cleanups
