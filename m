Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbXJUGpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbXJUGpS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 02:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751296AbXJUGpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 02:45:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40050 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbXJUGpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 02:45:06 -0400
Date: Sun, 21 Oct 2007 07:45:03 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [GIT PULL] audit updates
Message-ID: <20071021064503.GV8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull audit updates (predicate for watching subtrees) from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b43

When that gets merged, mm.b41 can be dropped from -mm tree.

Shortlog:

Author: Al Viro <viro@zeniv.linux.org.uk>
    [PATCH] pass dentry to audit_inode()/audit_inode_child()
    [PATCH] new helpers - collect_mounts() and release_collected_mounts()
    [PATCH] new helper - inotify_clone_watch()
    [PATCH] new helper - inotify_evict_watch()
    [PATCH] audit: watching subtrees

Diffstat:
 fs/dcache.c              |    2 +-
 fs/debugfs/inode.c       |    2 +-
 fs/inotify.c             |   43 +++
 fs/namei.c               |   10 +-
 fs/namespace.c           |   22 +-
 fs/open.c                |    4 +-
 fs/pnode.h               |    1 +
 fs/xattr.c               |    8 +-
 include/linux/audit.h    |   19 +-
 include/linux/dcache.h   |    1 +
 include/linux/fs.h       |    2 +
 include/linux/fsnotify.h |    9 +-
 include/linux/inotify.h  |    2 +
 init/Kconfig             |    4 +
 ipc/mqueue.c             |    8 +-
 kernel/Makefile          |    1 +
 kernel/audit.c           |   87 +++++
 kernel/audit.h           |   34 ++-
 kernel/audit_tree.c      |  903 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/auditfilter.c     |   64 +++-
 kernel/auditsc.c         |  225 ++++++++++++-
 21 files changed, 1411 insertions(+), 40 deletions(-)
 create mode 100644 kernel/audit_tree.c

