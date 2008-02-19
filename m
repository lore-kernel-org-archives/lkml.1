Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbYBSNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbYBSNdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYBSNdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:33:05 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40128 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYBSNdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:33:03 -0500
To: sfr@canb.auug.org.au, akpm@linux-foundation.org
CC: hch@infradead.org, serue@us.ibm.com, haveblue@us.ibm.com,
       linuxram@us.ibm.com, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: git tree with VFS stuff
Message-Id: <E1JRSaC-0005T2-Ew@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 Feb 2008 14:32:28 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've created a git tree with the following mounts related stuff:

  - read-only bind mounts
  - /proc/<pid>/mountinfo
  - unprivileged mounts

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfsstuff.git master

I guess, giving these a spin in linux-next wouldn't hurt?

Thanks,
Miklos


Dave Hansen (33):
      reiserfs: eliminate private use of struct file in xattr
      hppfs pass vfsmount to dentry_open()
      check for null vfsmount in dentry_open()
      fix up new filp allocators
      do namei_flags calculation inside open_namei()
      merge open_namei() and do_filp_open()
      r/o bind mounts: stub functions
      r/o bind mounts: create helper to drop file write access
      r/o bind mounts: drop write during emergency remount
      r/o bind mounts: elevate write count for vfs_rmdir()
      r/o bind mounts: elevate write count for callers of vfs_mkdir()
      r/o bind mounts: elevate mnt_writers for unlink callers
      r/o bind mounts: elevate write count for xattr_permission() callers
      r/o bind mounts: elevate write count for ncp_ioctl()
      r/o bind mounts: write counts for time functions
      r/o bind mounts: elevate write count for do_utimes()
      r/o bind mounts: write count for file_update_time()
      r/o bind mounts: write counts for link/symlink
      r/o bind mounts: elevate write count for ioctls()
      r/o bind mounts: elevate write count for open()s
      r/o bind mounts: get write access for vfs_rename() callers
      r/o bind mounts: elevate write count for chmod/chown callers
      r/o bind mounts: write counts for truncate()
      r/o bind mounts: elevate count for xfs timestamp updates
      r/o bind mounts: make access() use new r/o helper
      r/o bind mounts: check mnt instead of superblock directly
      r/o bind mounts: get callers of vfs_mknod/create()
      r/o bind mounts: track numbers of writers to mounts
      r/o bind mounts: honor mount writer counts at remount
      r/o bind mounts: debugging for missed calls
      ehea-fix
      fixes for missed struct paths from akpm
      Revert "ehea-fix"

Miklos Szeredi (10):
      unprivileged mounts: add user mounts to the kernel
      unprivileged mounts: allow unprivileged umount
      unprivileged mounts: propagate error values from clone_mnt
      unprivileged mounts: account user mounts
      unprivileged mounts: allow unprivileged bind mounts
      unprivileged mounts: allow unprivileged mounts
      unprivileged mounts: add sysctl tunable for "safe" property
      unprivileged mounts: make fuse safe
      unprivileged mounts: propagation: inherit owner from parent
      unprivileged mounts: add "no submounts" flag

Ram Pai (1):
      vfs-create-proc-pid-mountinfo

