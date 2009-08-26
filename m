Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZHZDiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZHZDiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZHZDiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:38:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53305
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbZHZDiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:38:15 -0400
Date: Tue, 25 Aug 2009 20:38:28 -0700 (PDT)
Message-Id: <20090825.203828.211231142.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these sparc bug fixes.

Thanks!

The following changes since commit 4075ea8c54a7506844a69f674990241e7766357b:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../bp/bp

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (7):
      sparc: Fix cleanup crash in bbc_envctrl_cleanup()
      sparc64: Sign extend length arg to truncate syscalls when compat.
      sparc: Use page_fault_out_of_memory() for VM_FAULT_OOM.
      sparc32: Kill trap table freeing code.
      sparc32: Update defconfig.
      sparc64: Update defconfig.
      sparc64: Validate linear D-TLB misses.

Mathieu Desnoyers (1):
      sparc: sys32.S incorrect compat-layer splice() system call

 arch/sparc/configs/sparc32_defconfig |   74 ++++++++++++++++++++--------------
 arch/sparc/configs/sparc64_defconfig |   59 +++++++++++++++-----------
 arch/sparc/include/asm/pgtable_64.h  |   12 ++++-
 arch/sparc/kernel/ktlb.S             |   42 +++++++++++++++++--
 arch/sparc/kernel/sun4d_smp.c        |   22 ----------
 arch/sparc/kernel/sun4m_smp.c        |   26 ------------
 arch/sparc/kernel/sys32.S            |    4 +-
 arch/sparc/kernel/systbls_64.S       |    4 +-
 arch/sparc/mm/fault_32.c             |    7 ++-
 arch/sparc/mm/fault_64.c             |    7 ++-
 arch/sparc/mm/init_64.c              |   43 +++++++++++---------
 arch/sparc/mm/init_64.h              |    7 ++-
 drivers/sbus/char/bbc_envctrl.c      |   11 ++++-
 13 files changed, 175 insertions(+), 143 deletions(-)
