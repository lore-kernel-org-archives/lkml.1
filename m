Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZJ0HLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZJ0HLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756468AbZJ0HLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:11:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:42714 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbZJ0HLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:11:40 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 18:10:52 +1100
Message-ID: <1256627452.11607.90.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Some of these might have been better in -rc4 or earlier, all my fault
for having some backlog that I'm still going through. So we have some
bug fixes (not necessarily regressions but also generally simple
enough that I decided to go for 2.6.32 anyways) and a few very trivial
Kconfig cleanups (outside of arch/powerpc but related to our symbols)
from Kumar that could go anytime.

The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Andreas Schwab (2):
      powerpc: Fix segment mapping in vdso32
      powerpc: Align vDSO base address

Benjamin Herrenschmidt (1):
      powerpc/ppc64: Use preempt_schedule_irq instead of preempt_schedule

Josh Boyer (1):
      powerpc/booke: Fix xmon single step on PowerPC Book-E

Kumar Gala (7):
      powerpc: Add a Book-3E 64-bit defconfig
      powerpc: Fix compile errors found by new ppc64e_defconfig
      powerpc: Limit hugetlbfs support to PPC64 Book-3S machines
      powerpc: Limit memory hotplug support to PPC64 Book-3S machines
      powerpc: Minor cleanup to init/Kconfig
      powerpc: Minor cleanup to sound/ppc/Kconfig
      powerpc: Minor cleanup to lib/Kconfig.debug

Michael Neuling (1):
      powerpc/perf_events: Fix priority of MSR HV vs PR bits

Stephen Rothwell (1):
      powerpc/iseries: Remove compiler version dependent hack

 arch/powerpc/configs/ppc64e_defconfig   | 2199 +++++++++++++++++++++++++++++++
 arch/powerpc/kernel/entry_64.S          |   41 +-
 arch/powerpc/kernel/pci_64.c            |    2 +
 arch/powerpc/kernel/perf_event.c        |   17 +-
 arch/powerpc/kernel/process.c           |    2 +-
 arch/powerpc/kernel/setup_64.c          |    1 -
 arch/powerpc/kernel/vdso.c              |   11 +-
 arch/powerpc/kernel/vdso32/vdso32.lds.S |    4 +-
 arch/powerpc/platforms/iseries/Makefile |   11 +-
 arch/powerpc/platforms/iseries/dt.c     |   56 +-
 arch/powerpc/xmon/xmon.c                |   20 +-
 fs/Kconfig                              |    2 +-
 init/Kconfig                            |    2 +-
 lib/Kconfig.debug                       |    2 +-
 mm/Kconfig                              |    2 +-
 sound/ppc/Kconfig                       |    2 +-
 16 files changed, 2294 insertions(+), 80 deletions(-)
 create mode 100644 arch/powerpc/configs/ppc64e_defconfig


