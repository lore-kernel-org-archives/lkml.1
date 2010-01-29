Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079Ab0A2Cjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0A2Cjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567Ab0A2Cjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:39:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:39297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0A2Cjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:39:51 -0500
Date: Fri, 29 Jan 2010 02:39:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs fixes
Message-ID: <20100129023948.GO19799@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted filesystem fixes (mostly around ->get_sb() and ->remount_fs())
Please, pull from
git.kernel.org://pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (8):
      Fix a leak in affs_fill_super()
      Fix remount races with symlink handling in affs
      fix affs parse_options()
      Fix failure exits in bfs_fill_super()
      get rid of pointless checks after simple_pin_fs()
      fix leak in romfs_fill_super()
      fix oops in fs/9p late mount failure
      Fix failure exit in ipathfs

Diffstat:
 drivers/infiniband/hw/ipath/ipath_fs.c |    4 +--
 fs/9p/vfs_super.c                      |    3 +-
 fs/affs/affs.h                         |    2 +-
 fs/affs/namei.c                        |    7 +++-
 fs/affs/super.c                        |   31 ++++++++++++++++------
 fs/affs/symlink.c                      |    7 +++-
 fs/bfs/inode.c                         |   43 +++++++++++++++----------------
 fs/debugfs/inode.c                     |   11 +------
 fs/romfs/super.c                       |    1 +
 security/inode.c                       |   11 +------
 10 files changed, 62 insertions(+), 58 deletions(-)
