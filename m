Return-Path: <linux-kernel-owner+w=401wt.eu-S934332AbYBNWpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934332AbYBNWpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933525AbYBNWo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:44:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933268AbYBNWo5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:44:57 -0500
Date: Thu, 14 Feb 2008 23:44:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86.git fixes
Message-ID: <20080214224438.GA22139@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest x86 git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git

Find the shortlog and diffstat below.

Small fixes only. One generic file modified: we touch mm/memory.c's 
print_vma_addr() to fix a bug on 64-bit x86 that was found yesterday.

	Ingo

------------------>
Adrian Bunk (1):
      x86: make dump_pagetable() static

Balbir Singh (1):
      KVM is not seen under X86 config with latest git (32 bit compile)

Harvey Harrison (1):
      x86: include proper prototypes for rodata_test

Ingo Molnar (4):
      x86: fix "BUG: sleeping function called from invalid context" in print_vma_addr()
      x86: EFI set_memory_x()/set_memory_uc() fixes
      x86: fix gart_iommu_init()
      x86: cpa, fix out of date comment

Thomas Gleixner (1):
      x86: cpa: ensure page alignment

 arch/x86/Kconfig              |    4 ++--
 arch/x86/kernel/efi.c         |    4 ++--
 arch/x86/kernel/pci-gart_64.c |    9 +++++++++
 arch/x86/kernel/test_rodata.c |    2 +-
 arch/x86/kernel/traps_64.c    |    4 ++--
 arch/x86/mm/fault.c           |    2 +-
 arch/x86/mm/init_32.c         |    1 +
 arch/x86/mm/init_64.c         |    1 +
 arch/x86/mm/pageattr.c        |   17 +++++++++++++++--
 include/asm-x86/cacheflush.h  |    7 +++++--
 include/asm-x86/kdebug.h      |    1 -
 mm/memory.c                   |    7 +++++++
 12 files changed, 46 insertions(+), 13 deletions(-)
