Return-Path: <linux-kernel-owner+w=401wt.eu-S1757561AbYEGMFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561AbYEGMFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 08:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYEGMFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 08:05:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40166 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYEGMFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 08:05:18 -0400
To: akpm@linux-foundation.org
CC: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: unprivileged mounts git tree
Message-Id: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 07 May 2008 14:05:13 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a git tree of the unprivileged mounts patchset:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts

Could this be added to -mm (and dropped if it's in the way of
something) for some testing and added visibility until it's reviewed
by Christoph/Al?

I'm not reposting the whole patchset, since it's essentially the same
as the last submission, only updated to the latest git.  But if
somebody wants it I can post them.

Thanks,
Miklos


 Documentation/filesystems/fuse.txt |   88 ++++++++-
 Documentation/filesystems/proc.txt |   40 ++++
 fs/filesystems.c                   |   60 ++++++
 fs/fuse/inode.c                    |   21 ++
 fs/internal.h                      |    3 +-
 fs/namespace.c                     |  366 +++++++++++++++++++++++++++---------
 fs/pnode.c                         |   22 ++-
 fs/pnode.h                         |    2 +
 fs/super.c                         |   26 ---
 include/linux/fs.h                 |    7 +
 include/linux/mount.h              |    4 +
 kernel/sysctl.c                    |   16 ++
 12 files changed, 527 insertions(+), 128 deletions(-)

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

