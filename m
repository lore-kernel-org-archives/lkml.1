Return-Path: <linux-kernel-owner+w=401wt.eu-S1755050AbZINIIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbZINIIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 04:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZINIIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 04:08:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbZINIIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 04:08:12 -0400
Subject: GFS2: Pull request
From: Steven Whitehouse <swhiteho@redhat.com>
To: torvalds@linux-foundation.org
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 14 Sep 2009 09:08:10 +0100
Message-Id: <1252915690.6052.257.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please consider pulling the following changes,

Steve.

-------------------------------------------------------------------------------
The following changes since commit 894ef820b10d77e2d6d717342fc408bdd9825139:
  Randy Dunlap (1):
        dm-log-userspace: fix printk format warning

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git master

Bob Peterson (1):
      GFS2: Add "-o errors=panic|withdraw" mount options

Roel Kluin (1):
      GFS2: jumping to wrong label?

Steven Whitehouse (13):
      GFS2: Add online uevent to GFS2
      GFS2: Add some more info to uevents
      GFS2: Improve error handling in inode allocation
      GFS2: Replace assertion with proper error handling
      GFS2: Add sysfs link to device
      GFS2: Add a document explaining GFS2's uevents
      GFS2: Add explanation of extended attr on-disk format
      GFS2: Clean up of extended attribute support
      GFS2: Rename eattr.[ch] as xattr.[ch]
      GFS2: Remove no_formal_ino generating code
      GFS2: Be extra careful about deallocating inodes
      GFS2: Remove unused sysfs file
      GFS2: Whitespace fixes

Wengang Wang (1):
      GFS2: free disk inode which is deleted by remote node -V2

 Documentation/filesystems/gfs2-uevents.txt |  100 +++++++
 fs/gfs2/Makefile                           |    2 +-
 fs/gfs2/acl.c                              |  106 +++----
 fs/gfs2/dentry.c                           |   18 ++
 fs/gfs2/eaops.c                            |  157 ----------
 fs/gfs2/eaops.h                            |   30 --
 fs/gfs2/export.c                           |   36 +--
 fs/gfs2/file.c                             |    1 -
 fs/gfs2/incore.h                           |   15 +-
 fs/gfs2/inode.c                            |  159 +----------
 fs/gfs2/ops_fstype.c                       |   66 ++---
 fs/gfs2/ops_inode.c                        |   82 +++---
 fs/gfs2/rgrp.c                             |   82 +++++-
 fs/gfs2/rgrp.h                             |    6 +-
 fs/gfs2/super.c                            |   46 +++-
 fs/gfs2/super.h                            |    5 +-
 fs/gfs2/sys.c                              |   31 ++-
 fs/gfs2/util.c                             |   41 ++-
 fs/gfs2/{eattr.c => xattr.c}               |  425 ++++++++++++++++------------
 fs/gfs2/{eattr.h => xattr.h}               |   54 +---
 include/linux/gfs2_ondisk.h                |   22 ++
 21 files changed, 678 insertions(+), 806 deletions(-)
 create mode 100644 Documentation/filesystems/gfs2-uevents.txt
 delete mode 100644 fs/gfs2/eaops.c
 delete mode 100644 fs/gfs2/eaops.h
 rename fs/gfs2/{eattr.c => xattr.c} (79%)
 rename fs/gfs2/{eattr.h => xattr.h} (53%)


