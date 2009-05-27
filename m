Return-Path: <linux-kernel-owner+w=401wt.eu-S1759830AbZE0Fdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830AbZE0Fdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbZE0Fda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:33:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45253 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274AbZE0Fda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:33:30 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] Blackfin fixes for 2.6.30
Date: Wed, 27 May 2009 01:33:30 -0400
Message-Id: <1243402410-25008-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit cd86a536c81e9300d984327517548ca0652eebf9:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

Mike Frysinger (6):
      Blackfin: hook up preadv/pwritev syscalls
      MAINTAINERS: update Blackfin items
      MAINTAINERS: drop (subscribers-only) markings on Blackfin lists
      Blackfin: ignore generated vmlinux.lds
      Blackfin: drop unneeded asm/.gitignore
      Blackfin: fix strncmp.o build error

 MAINTAINERS                          |   18 +++++++++---------
 arch/blackfin/include/asm/.gitignore |    1 -
 arch/blackfin/include/asm/unistd.h   |    4 +++-
 arch/blackfin/kernel/.gitignore      |    1 +
 arch/blackfin/lib/strncmp.c          |    3 +--
 arch/blackfin/mach-common/entry.S    |    2 ++
 6 files changed, 16 insertions(+), 13 deletions(-)
 delete mode 100644 arch/blackfin/include/asm/.gitignore
 create mode 100644 arch/blackfin/kernel/.gitignore
