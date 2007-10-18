Return-Path: <linux-kernel-owner+w=401wt.eu-S932397AbXJRAiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbXJRAiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 20:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758635AbXJRAh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 20:37:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43517 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438AbXJRAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 20:37:55 -0400
Date: Thu, 18 Oct 2007 01:37:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] audit patches (first series)
Message-ID: <20071018003751.GL8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adds new predicate ("event happened in subtree under <pathname>").
audit-subtree stuff; sat in -mm for several months.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git/ audit.b42

Al Viro <viro@zeniv.linux.org.uk>
    [PATCH] audit: watching subtrees
    [PATCH] new helper - inotify_evict_watch()
    [PATCH] new helper - inotify_clone_watch()
    [PATCH] new helpers - collect_mounts() and release_collected_mounts()
    [PATCH] pass dentry to audit_inode()/audit_inode_child()

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
