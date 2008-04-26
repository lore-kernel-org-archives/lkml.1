Return-Path: <linux-kernel-owner+w=401wt.eu-S1760751AbYDZCCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760751AbYDZCCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 22:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbYDZCCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 22:02:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44709 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbYDZCCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 22:02:22 -0400
Date: Sat, 26 Apr 2008 03:02:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] VFS patches
Message-ID: <20080426020221.GF5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Tonight's pile: getting ->umount_begin() back to sanity, race fixes
around execve(), general cleanups.  Please, pull from

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:

Al Viro (5):
      restore sane ->umount_begin() API
      close race in unshare_files()
      sanitize handling of shared descriptor tables in failing execve()
      sanitize unshare_files/reset_files_struct
      sanitize locate_fd()

Igor Mammedov (1):
      cifs: timeout dfs automounts +little fix.

Diffstat:

 fs/9p/vfs_super.c      |    7 ++---
 fs/binfmt_elf.c        |   23 +------------------
 fs/binfmt_misc.c       |   18 +--------------
 fs/binfmt_som.c        |   10 --------
 fs/cifs/cifs_dfs_ref.c |   29 +++++++++++++++++------
 fs/cifs/cifsfs.c       |   10 ++-----
 fs/cifs/cifsproto.h    |    8 +-----
 fs/exec.c              |   28 ++++++++++-------------
 fs/fcntl.c             |   40 +++++++++++---------------------
 fs/fuse/inode.c        |    5 +--
 fs/namespace.c         |    9 ++++---
 fs/nfs/super.c         |    8 ++----
 include/linux/file.h   |    3 +-
 include/linux/fs.h     |    5 +---
 kernel/exit.c          |    6 +---
 kernel/fork.c          |   58 +++++++++++++++++++----------------------------
 16 files changed, 95 insertions(+), 172 deletions(-)

