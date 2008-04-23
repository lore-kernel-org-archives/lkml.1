Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYDWQf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYDWQf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbYDWQfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:35:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYDWQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:35:11 -0400
Date: Wed, 23 Apr 2008 17:35:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] VFS patches (third series, mountinfo merge)
Message-ID: <20080423163509.GZ27459@ZenIV.linux.org.uk>
References: <20080423002219.GW27459@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080423002219.GW27459@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 	Mountinfo series + noise removal in xattr.c (unused label from
ro-bind series).

Please pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:

Al Viro (1):
      remove unused label in xattr.c (noise from ro-bind)

Miklos Szeredi (5):
      [patch 2/7] vfs: mountinfo: add seq_file_root()
      [patch 3/7] vfs: mountinfo: add mount ID
      [patch 4/7] vfs: mountinfo: add mount peer group ID
      [patch 5/7] vfs: mountinfo: allow using process root
      [patch 7/7] vfs: mountinfo: show dominating group id

Ram Pai (2):
      [patch 1/7] vfs: mountinfo: add dentry_path()
      [patch 6/7] vfs: mountinfo: add /proc/<pid>/mountinfo

Diffstat:
 Documentation/filesystems/proc.txt |   38 +++++
 fs/dcache.c                        |  114 +++++++++++-----
 fs/namespace.c                     |  265 +++++++++++++++++++++++++++++++-----
 fs/pnode.c                         |   56 ++++++++-
 fs/pnode.h                         |    1 +
 fs/proc/base.c                     |  121 +++++++++--------
 fs/seq_file.c                      |   95 +++++++++++--
 fs/xattr.c                         |    1 -
 include/linux/dcache.h             |    2 +
 include/linux/mnt_namespace.h      |   12 ++
 include/linux/mount.h              |    2 +
 include/linux/seq_file.h           |    4 +
 12 files changed, 573 insertions(+), 138 deletions(-)
