Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505Ab0AGTBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0AGTBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:01:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265Ab0AGTBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:01:09 -0500
Received: from mail.windriver.com ([147.11.1.11]:60153 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0AGTBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:01:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] blackfin kgdb fixes for 2.6.33-rc3
Date: Thu,  7 Jan 2010 12:59:52 -0600
Message-Id: <1262890796-25053-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 07 Jan 2010 19:00:39.0095 (UTC) FILETIME=[B3C9A470:01CA8FCB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the kgdb git tree fixes for 2.6.33-rc3

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Summary: 

* Fix builds of blackfin with CONFIG_KGDB=y
* Grammar fixes from Randy which go into the generated docs

This series fixes the build issues and cleans the up duplicated code
between the kgdb core and the blackfin architecture specific kgdb
implementation.

Thanks,
Jason.

Short log follows:

--- 

The following changes since commit 2c1f1895ef2aa8f0e5497893eff71304aef332e1:
  Linus Torvalds (1):
        Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (2):
      maccess,probe_kernel: Allow arch specific override probe_kernel_(read|write)
      blackfin,kgdb,probe_kernel: Cleanup probe_kernel_read/write

Randy Dunlap (1):
      kgdb: Fix kernel-doc format error in kgdb.h

Sonic Zhang (1):
      blackfin,kgdb: Do not put PC in gdb_regs into retx.

 arch/blackfin/kernel/kgdb.c |  207 +------------------------------------------
 arch/blackfin/mm/Makefile   |    2 +-
 arch/blackfin/mm/maccess.c  |   97 ++++++++++++++++++++
 include/linux/kgdb.h        |    7 +-
 include/linux/uaccess.h     |    4 +-
 mm/maccess.c                |   11 ++-
 6 files changed, 114 insertions(+), 214 deletions(-)
 create mode 100644 arch/blackfin/mm/maccess.c
