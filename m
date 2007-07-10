Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbXGJH7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbXGJH7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 03:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbXGJH7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 03:59:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbXGJH7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 03:59:17 -0400
Subject: [GFS2/DLM] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <11839969822277-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 10 Jul 2007 08:50:58 +0100
Message-Id: <1184053859.8765.189.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes from the GFS2/DLM -nmw git
tree,

Steve.

--------------------------------------------------------------------
The following changes since commit 7dcca30a32aadb0520417521b0c44f42d09fe05c:
  Linus Torvalds (1):
        Linux 2.6.22

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Abhijith Das (4):
      [GFS2] Quotas non-functional - fix bug
      [GFS2] Quotas non-functional - fix another bug
      [GFS2] Fix deallocation issues
      [GFS2] System won't suspend with GFS2 file system mounted

Benjamin Marzinski (2):
      [GFS2] flush the glock completely in inode_go_sync
      [GFS2] fix jdata issues

Bob Peterson (1):
      [GFS2] remounting w/o acl option leaves acls enabled

David Teigland (15):
      [DLM] block scand during recovery [1/6]
      [DLM] add lock timeouts and warnings [2/6]
      [DLM] dlm_device interface changes [3/6]
      [DLM] cancel in conversion deadlock [4/6]
      [DLM] fix new_lockspace error exit [5/6]
      [DLM] wait for config check during join [6/6]
      [DLM] fix compile breakage
      [DLM] timeout fixes
      [DLM] canceling deadlocked lock
      [DLM] dumping master locks
      [DLM] show default protocol
      [GFS2] set plock owner in GETLK info
      [GFS2] return conflicts for GETLK
      [DLM] don't require FS flag on all nodes
      [DLM] dump more lock values

Fabio Massimo Di Nitto (1):
      [GFS2] latest gfs2-nmw headers break userland build

Josef Bacik (2):
      [DLM] keep dlm from panicing when traversing rsb list in debugfs
      [DLM] fix reference counting

Nate Diller (1):
      [GFS2] use zero_user_page

Patrick Caulfield (3):
      [DLM] fix socket shutdown
      [DLM] variable allocation
      [DLM] Telnet to port 21064 can stop all lockspaces

Robert Peterson (7):
      [GFS2] kernel changes to support new gfs2_grow command
      [GFS2] Kernel changes to support new gfs2_grow command (part 2)
      [GFS2] Addendum patch 2 for gfs2_grow
      [GFS2] Can't mount GFS2 file system on AoE device
      [GFS2] Journaled file write/unstuff bug
      [GFS2] assertion failure after writing to journaled file, umount
      [GFS2] Addendum to the journaled file/unmount patch

S. Wendy Cheng (1):
      [GFS2] Fix gfs2_block_truncate_page err return

Satyam Sharma (1):
      [DLM] fix a couple of races

Steven Whitehouse (13):
      [GFS2] Reduce size of struct gdlm_lock
      [GFS2] Clean up inode number handling
      [DLM] Compile fix
      [GFS2] Make the log reserved blocks depend on block size
      [GFS2] Fix sign problem in quota/statfs and cleanup _host structures
      [GFS2] Add nanosecond timestamp feature
      [GFS2] Fix typo in rename of directories
      [GFS2] Fix bug in error path of inode
      [GFS2] Recovery for lost unlinked inodes
      [GFS2] Remove bogus '\0' in rgrp.c
      [GFS2] Use zero_user_page() in stuffed_readpage()
      [GFS2] Simplify multiple glock aquisition
      [GFS2] Small fixes to logging code

Wendy Cheng (3):
      [GFS2] inode size inconsistency
      [GFS2] Obtaining no_formal_ino from directory entry
      [GFS2] Remove i_mode passing from NFS File Handle

akpm@linux-foundation.org (2):
      [GFS2] gfs2_lookupi() uninitialised var fix
      [GFS2] git-gfs2-nmw-build-fix

 fs/dlm/Makefile                |    1 +
 fs/dlm/config.c                |   25 ++-
 fs/dlm/config.h                |    1 +
 fs/dlm/debug_fs.c              |  186 +++++++++++++++-
 fs/dlm/dlm_internal.h          |   17 ++
 fs/dlm/lock.c                  |  470 +++++++++++++++++++++++++++++++---------
 fs/dlm/lock.h                  |   13 +-
 fs/dlm/lockspace.c             |   86 ++++++--
 fs/dlm/lowcomms.c              |   23 ++-
 fs/dlm/main.c                  |   11 +-
 fs/dlm/member.c                |   11 +-
 fs/dlm/netlink.c               |  153 +++++++++++++
 fs/dlm/rcom.c                  |   13 +-
 fs/dlm/recoverd.c              |    4 +-
 fs/dlm/user.c                  |  129 +++++++++---
 fs/gfs2/Makefile               |    2 +-
 fs/gfs2/bmap.c                 |   23 +-
 fs/gfs2/daemon.c               |   11 +
 fs/gfs2/dir.c                  |   69 +++++--
 fs/gfs2/dir.h                  |    9 +-
 fs/gfs2/eattr.c                |   14 +-
 fs/gfs2/glock.c                |  123 +++++------
 fs/gfs2/glock.h                |    1 +
 fs/gfs2/glops.c                |    2 +-
 fs/gfs2/incore.h               |   81 ++++++-
 fs/gfs2/inode.c                |  288 +++++++++++++++++-------
 fs/gfs2/inode.h                |   30 ++-
 fs/gfs2/locking/dlm/lock.c     |   11 +-
 fs/gfs2/locking/dlm/lock_dlm.h |    2 +-
 fs/gfs2/locking/dlm/mount.c    |    2 +-
 fs/gfs2/locking/dlm/plock.c    |    8 +-
 fs/gfs2/locking/dlm/thread.c   |   11 +-
 fs/gfs2/log.c                  |  129 +++++++++---
 fs/gfs2/lops.c                 |   49 ++--
 fs/gfs2/lops.h                 |   23 ++
 fs/gfs2/meta_io.c              |    8 +-
 fs/gfs2/meta_io.h              |    2 +-
 fs/gfs2/mount.c                |   25 +-
 fs/gfs2/ondisk.c               |  251 ---------------------
 fs/gfs2/ops_address.c          |   69 +++++-
 fs/gfs2/ops_address.h          |    2 +-
 fs/gfs2/ops_dentry.c           |   24 +--
 fs/gfs2/ops_export.c           |   63 +++---
 fs/gfs2/ops_export.h           |   22 --
 fs/gfs2/ops_file.c             |    4 +-
 fs/gfs2/ops_fstype.c           |   33 ++--
 fs/gfs2/ops_fstype.h           |    1 +
 fs/gfs2/ops_inode.c            |   30 ++--
 fs/gfs2/ops_super.c            |    8 +-
 fs/gfs2/ops_vm.c               |    2 +-
 fs/gfs2/quota.c                |   57 +++++-
 fs/gfs2/recovery.c             |   22 ++-
 fs/gfs2/rgrp.c                 |  377 ++++++++++++++++++++++++--------
 fs/gfs2/rgrp.h                 |    1 +
 fs/gfs2/super.c                |   79 +++++--
 fs/gfs2/super.h                |    2 +-
 fs/gfs2/util.c                 |    6 +-
 include/linux/Kbuild           |    1 +
 include/linux/dlm.h            |   14 +-
 include/linux/dlm_device.h     |   22 ++-
 include/linux/dlm_netlink.h    |   56 +++++
 include/linux/gfs2_ondisk.h    |  142 +-----------
 62 files changed, 2247 insertions(+), 1107 deletions(-)
 create mode 100644 fs/dlm/netlink.c
 delete mode 100644 fs/gfs2/ondisk.c
 delete mode 100644 fs/gfs2/ops_export.h
 create mode 100644 include/linux/dlm_netlink.h


