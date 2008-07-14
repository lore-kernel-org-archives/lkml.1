Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYGNQFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYGNQFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbYGNQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:05:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbYGNQFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:05:08 -0400
Subject: [GFS2] Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 14 Jul 2008 17:03:39 +0100
Message-Id: <1216051419.4011.267.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following patches. The only difference since the
recent posting is David Howells' patch to fix a warning (a one-liner),

Steve.

The following changes since commit 543cf4cb3fe6f6cae3651ba918b9c56200b257d0:
  Linus Torvalds (1):
        Linux 2.6.26-rc8

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git

Bob Peterson (1):
      [GFS2] kernel panic mounting volume

David Howells (1):
      [GFS2] Fix GFS2's use of do_div() in its quota calculations

Harvey Harrison (1):
      [GFS2] trivial sparse lock annotations

Li Xiaodong (1):
      [GFS2] Remove unused declaration

Miklos Szeredi (1):
      [GFS2] don't call permission()

Steven Whitehouse (14):
      [GFS2] Clean up the glock core
      [GFS2] Fix ordering bug in lock_dlm
      [GFS2] No lock_nolock
      [GFS2] Fix ordering of args for list_add
      [GFS2] Revise readpage locking
      [GFS2] Remove remote lock dropping code
      [GFS2] Remove obsolete conversion deadlock avoidance code
      [GFS2] Remove all_list from lock_dlm
      [GFS2] Glock documentation
      [GFS2] Fix module building
      [GFS2] Fix delayed demote race
      [GFS2] Allow local DF locks when holding a cached EX glock
      [GFS2] Replace rgrp "recent list" with mru list
      [GFS2] Remove support for unused and pointless flag

 Documentation/filesystems/gfs2-glocks.txt |  114 ++
 fs/gfs2/Kconfig                           |   18 +-
 fs/gfs2/Makefile                          |    1 -
 fs/gfs2/gfs2.h                            |    5 -
 fs/gfs2/glock.c                           | 1643 ++++++++++++-----------------
 fs/gfs2/glock.h                           |   11 +-
 fs/gfs2/glops.c                           |   70 +-
 fs/gfs2/incore.h                          |   38 +-
 fs/gfs2/inode.c                           |   11 +-
 fs/gfs2/inode.h                           |    2 +-
 fs/gfs2/locking.c                         |   52 +-
 fs/gfs2/locking/dlm/lock.c                |  368 +++++--
 fs/gfs2/locking/dlm/lock_dlm.h            |   18 +-
 fs/gfs2/locking/dlm/mount.c               |   14 +-
 fs/gfs2/locking/dlm/sysfs.c               |   13 -
 fs/gfs2/locking/dlm/thread.c              |  331 +------
 fs/gfs2/locking/nolock/Makefile           |    3 -
 fs/gfs2/locking/nolock/main.c             |  238 -----
 fs/gfs2/log.c                             |    2 +
 fs/gfs2/log.h                             |    2 +
 fs/gfs2/main.c                            |    2 -
 fs/gfs2/meta_io.c                         |   14 +-
 fs/gfs2/meta_io.h                         |    1 +
 fs/gfs2/ops_address.c                     |   40 +-
 fs/gfs2/ops_file.c                        |   38 +-
 fs/gfs2/ops_fstype.c                      |    8 +-
 fs/gfs2/ops_inode.c                       |   25 +-
 fs/gfs2/ops_super.c                       |    4 +-
 fs/gfs2/quota.c                           |    2 +-
 fs/gfs2/recovery.c                        |    5 +-
 fs/gfs2/rgrp.c                            |  108 +--
 fs/gfs2/super.c                           |    4 +-
 fs/gfs2/sys.c                             |   16 -
 include/linux/lm_interface.h              |    6 -
 34 files changed, 1275 insertions(+), 1952 deletions(-)
 create mode 100644 Documentation/filesystems/gfs2-glocks.txt
 delete mode 100644 fs/gfs2/locking/nolock/Makefile
 delete mode 100644 fs/gfs2/locking/nolock/main.c


