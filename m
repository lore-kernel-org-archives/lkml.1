Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbZAHQtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbZAHQtr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZAHQtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:49:10 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:64525 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753206AbZAHQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:49:07 -0500
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Squashfs pull request for 2.6.29
Message-Id: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Thu, 08 Jan 2009 16:48:51 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider pulling my linux-next branch

git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git

The patches have been posted to LKML and linux-fsdevel over the last
couple of months and have been reviewed and changed as requested.
Diffstat below.

Squashfs is a compressed read-only filesystem. It compresses metadata
and data, and uses up to 1 MiB block sizes for greater compression.

This is a comparison of Squashfs against Cramfs:

				Squashfs		Cramfs

Max filesystem size:		2^64			256 MiB
Max file size:			~ 2 TiB			16 MiB
Max files:			unlimited		unlimited
Max directories:		unlimited		unlimited
Max entries per directory:	unlimited		unlimited
Max block size:			1 MiB			4 KiB
Metadata compression:		yes			no
Directory indexes:		yes			no
Sparse file support:		yes			no
Tail-end packing (fragments):	yes			no
Exportable (NFS etc.):		yes			no
Hard link support:		yes			no
"." and ".." in readdir:	yes			no
Real inode numbers:		yes			no
32-bit uids/gids:		yes			no
File creation time:		yes			no
Xattr and ACL support:		no			no

Thanks

Phillip

 Documentation/filesystems/squashfs.txt |  225 ++++++++++++++
 MAINTAINERS                            |    7 +
 fs/Kconfig                             |   52 ++++
 fs/Makefile                            |    1 +
 fs/squashfs/Makefile                   |    8 +
 fs/squashfs/block.c                    |  274 +++++++++++++++++
 fs/squashfs/cache.c                    |  412 ++++++++++++++++++++++++++
 fs/squashfs/dir.c                      |  235 +++++++++++++++
 fs/squashfs/export.c                   |  155 ++++++++++
 fs/squashfs/file.c                     |  502 ++++++++++++++++++++++++++++++++
 fs/squashfs/fragment.c                 |   98 +++++++
 fs/squashfs/id.c                       |   94 ++++++
 fs/squashfs/inode.c                    |  346 ++++++++++++++++++++++
 fs/squashfs/namei.c                    |  242 +++++++++++++++
 fs/squashfs/squashfs.h                 |   90 ++++++
 fs/squashfs/squashfs_fs.h              |  381 ++++++++++++++++++++++++
 fs/squashfs/squashfs_fs_i.h            |   45 +++
 fs/squashfs/squashfs_fs_sb.h           |   76 +++++
 fs/squashfs/super.c                    |  440 ++++++++++++++++++++++++++++
 fs/squashfs/symlink.c                  |  118 ++++++++
 init/do_mounts_rd.c                    |   14 +
 21 files changed, 3815 insertions(+), 0 deletions(-)

