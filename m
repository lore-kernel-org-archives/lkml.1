Return-Path: <linux-kernel-owner+w=401wt.eu-S1754401AbZLVRdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbZLVRdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 12:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbZLVRdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 12:33:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40630 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428AbZLVRdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 12:33:53 -0500
Date: Tue, 22 Dec 2009 17:33:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches for -rc2
Message-ID: <20091222173349.GT18217@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted cleanups and fixes.  Please pull from
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ master

Al Viro (2):
      Fix f_flags/f_mode in case of lookup_instantiate_filp() from open(pathname, 3)
      Sanitize f_flags helpers

Alan Cox (1):
      jfs: Fix 32bit build warning

Andreas Gruenbacher (1):
      Remove obsolete comment in fs.h

Arnd Bergmann (1):
      fs/compat_ioctl.c: fix build error when !BLOCK

Evgeniy Polyakov (1):
      pohmelfs needs I_LOCK

Roland Dreier (2):
      alloc_file(): simplify handling of mnt_clone_write() errors
      anonfd: Allow making anon files read-only

 drivers/staging/pohmelfs/dir.c |    2 --
 fs/anon_inodes.c               |    4 ++--
 fs/compat_ioctl.c              |    2 --
 fs/eventfd.c                   |    2 +-
 fs/eventpoll.c                 |    2 +-
 fs/file_table.c                |    4 +---
 fs/internal.h                  |    7 +++++++
 fs/jfs/super.c                 |    2 +-
 fs/namei.c                     |    8 ++++----
 fs/open.c                      |   13 ++++++-------
 fs/signalfd.c                  |    2 +-
 fs/timerfd.c                   |    2 +-
 include/linux/fs.h             |    5 +++--
 include/linux/namei.h          |    2 --
 kernel/auditsc.c               |    1 -
 kernel/perf_event.c            |    2 +-
 security/tomoyo/file.c         |    1 -
 virt/kvm/kvm_main.c            |    4 ++--
 18 files changed, 31 insertions(+), 34 deletions(-)
