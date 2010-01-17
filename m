Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978Ab0AQH5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab0AQH5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 02:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124Ab0AQH5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 02:57:35 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60341 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0AQH5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 02:57:34 -0500
Date: Sun, 17 Jan 2010 07:57:29 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20100117075728.GO19799@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted fixes (plus an obvious fs/9p cleanup).  Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (12):
      fix autofs/afs/etc. magic mountpoint breakage
      Kill 9p readlink()
      hppfs: handle ->put_link()
      Unrot uml mconsole a bit
      Fix ACC_MODE() for real
      Fix the -ESTALE handling in do_filp_open()
      Fix configfs leak
      may_umount() needs namespace_sem
      attach_recursive_mnt() needs to hold vfsmount_lock over set_mnt_shared()
      mnt_flags fixes in do_remount()
      CIFS shouldn't make mountpoints shrinkable
      do_add_mount() should sanitize mnt_flags

OGAWA Hirofumi (1):
      ecryptfs: Fix refcnt leak on ecryptfs_follow_link() error path

Diffstat:
 arch/um/drivers/mconsole_kern.c |   49 ++++++++++++++------------------------
 fs/9p/vfs_inode.c               |   41 +-------------------------------
 fs/cifs/cifs_dfs_ref.c          |    3 +-
 fs/configfs/symlink.c           |    4 ++-
 fs/ecryptfs/inode.c             |   24 +++++++++---------
 fs/hppfs/hppfs.c                |   18 +++++++++----
 fs/namei.c                      |   23 ++++++++---------
 fs/namespace.c                  |   14 ++++++++--
 fs/proc/base.c                  |    1 -
 include/linux/fs.h              |    2 +-
 security/tomoyo/tomoyo.c        |    7 +----
 11 files changed, 71 insertions(+), 115 deletions(-)
