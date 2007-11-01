Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbXKAWtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbXKAWtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXKAWtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:49:43 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59079 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753067AbXKAWtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:49:42 -0400
Date: Thu, 1 Nov 2007 23:49:24 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6.16.56
Message-ID: <20071101224924.GC7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Security fixes since 2.6.16.55:
- CVE-2007-3739: Don't allow the stack to grow into hugetlb reserved regions
- CVE-2007-4133: hugetlb: fix prio_tree unit


Location:
ftp://ftp.kernel.org/pub/linux/kernel/v2.6/

git tree:
git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.16.y.git

RSS feed of the git tree:
http://www.kernel.org/git/?p=linux/kernel/git/stable/linux-2.6.16.y.git;a=rss


Changes since 2.6.16.55:

Adam Litke (1):
      Don't allow the stack to grow into hugetlb reserved regions (CVE-2007-3739)

Adrian Bunk (4):
      drivers/video/macmodes.c:mac_find_mode() mustn't be __init
      Linux 2.6.16.56-rc1
      Linux 2.6.16.56-rc2
      Linux 2.6.16.56

Andreas Arens (1):
      DVB: get_dvb_firmware: update script for new location of tda10046 firmware

Arthur Othieno (1):
      hugetlbfs: add Kconfig help text

David Gibson (1):
      hugetlb: check for brk() entering a hugepage region

David S. Miller (2):
      [NET]: Zero length write() on socket should not simply return 0.
      [SPARC64]: Fix bugs in SYSV IPC handling in 64-bit processes.

Hugh Dickins (3):
      hugetlb: fix prio_tree unit (CVE-2007-4133)
      hugetlb: fix error return for brk() entering a hugepage region
      hugetlb: fix size=4G parsing

Ilpo Järvinen (2):
      [PKT_SCHED] RED: Fix overflow in calculation of queue average
      [TCP]: Fix fastpath_cnt_hint when GSO skb is partially ACKed

Jan Altenberg (1):
      m68knommu: ptrace.h typo fix

Ken Chen (2):
      x86: HUGETLBFS and DEBUG_PAGEALLOC are incompatible
      [IA64] fix ia64 is_hugepage_only_range

Kumar Gala (1):
      [POWERPC] Fix handling of stfiwx math emulation

Michael Krufky (1):
      DVB: get_dvb_firmware: update script for new location of sp8870 firmware

Mike Frysinger (1):
      alpha: fix epoll syscall enumerations

Randy Dunlap (1):
      hugetlbfs doc. update

Stephen Hemminger (1):
      [PKT_SCHED] cls_u32: error code isn't been propogated properly

Stephen Smalley (1):
      SELinux: clear parent death signal on SID transitions

Ulrich Drepper (1):
      make UML compile (FC6/x86-64)

Zhang Yanmin (1):
      [IA64] lazy_mmu_prot_update needs to be aware of huge pages


 Documentation/dvb/get_dvb_firmware |   26 +++++++++++++-------------
 Documentation/vm/hugetlbpage.txt   |   20 ++++++++++----------
 Makefile                           |    2 +-
 arch/i386/Kconfig.debug            |    2 +-
 arch/ia64/mm/hugetlbpage.c         |    7 +++----
 arch/ia64/mm/init.c                |    8 +++++++-
 arch/ppc/math-emu/math.c           |   13 +++++++++----
 arch/sparc64/kernel/sys_sparc.c    |   15 ++++-----------
 arch/um/include/kern_util.h        |    1 -
 arch/um/sys-x86_64/stub_segv.c     |    1 -
 drivers/video/macmodes.c           |    4 ++--
 fs/Kconfig                         |    6 ++++++
 fs/hugetlbfs/inode.c               |   25 +++++++++++--------------
 include/asm-alpha/unistd.h         |   11 ++++++++---
 include/asm-ia64/page.h            |    2 +-
 include/asm-m68knommu/ptrace.h     |    2 +-
 include/net/red.h                  |    2 +-
 mm/mmap.c                          |   10 ++++++++++
 net/ipv4/tcp_input.c               |    3 +++
 net/sched/cls_u32.c                |    2 +-
 net/socket.c                       |    2 --
 security/selinux/hooks.c           |    3 +++
 22 files changed, 95 insertions(+), 72 deletions(-)

