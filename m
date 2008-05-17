Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYEQHTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYEQHTT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 03:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYEQHTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 03:19:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42236 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbYEQHTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 03:19:08 -0400
Date: Sat, 17 May 2008 08:19:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs patches
Message-ID: <20080517071907.GY13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc VFS fixes.  Please, pull from 
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Summary:
Al Viro (8):
      take init_files to fs/file.c
      dup_fd() fixes, part 1
      dup_fd() part 2
      dup_fd() - part 3
      dup_fd() part 4 - race fix
      avoid multiplication overflows and signedness issues for max_fds
      get rid of leak in compat_execve()
      return to old errno choice in mkdir() et.al.

WANG Cong (2):
      [Patch] fs/binfmt_elf.c: fix a wrong free
      [Patch] fs/binfmt_elf.c: fix wrong return values

Diffstat:
 arch/alpha/kernel/init_task.c     |    1 -
 arch/arm/kernel/init_task.c       |    1 -
 arch/avr32/kernel/init_task.c     |    1 -
 arch/blackfin/kernel/init_task.c  |    1 -
 arch/cris/kernel/process.c        |    1 -
 arch/frv/kernel/init_task.c       |    1 -
 arch/h8300/kernel/init_task.c     |    1 -
 arch/ia64/kernel/init_task.c      |    1 -
 arch/m32r/kernel/init_task.c      |    1 -
 arch/m68k/kernel/process.c        |    1 -
 arch/m68knommu/kernel/init_task.c |    1 -
 arch/mips/kernel/init_task.c      |    1 -
 arch/mn10300/kernel/init_task.c   |    1 -
 arch/parisc/kernel/init_task.c    |    1 -
 arch/powerpc/kernel/init_task.c   |    1 -
 arch/s390/kernel/init_task.c      |    1 -
 arch/sh/kernel/init_task.c        |    1 -
 arch/sparc/kernel/init_task.c     |    1 -
 arch/sparc64/kernel/init_task.c   |    1 -
 arch/um/kernel/init_task.c        |    1 -
 arch/v850/kernel/init_task.c      |    1 -
 arch/x86/kernel/init_task.c       |    1 -
 arch/xtensa/kernel/init_task.c    |    1 -
 fs/binfmt_elf.c                   |    9 +-
 fs/compat.c                       |    4 +-
 fs/exec.c                         |   12 ++-
 fs/file.c                         |  152 ++++++++++++++++++++++++++++++++++++-
 fs/namei.c                        |   12 ++-
 include/linux/binfmts.h           |    1 +
 include/linux/fdtable.h           |    1 +
 include/linux/init_task.h         |   23 +------
 kernel/fork.c                     |  130 -------------------------------
 kernel/sysctl.c                   |    5 +-
 33 files changed, 180 insertions(+), 192 deletions(-)

