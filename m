Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYCUQVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYCUQVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 12:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYCUQU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 12:20:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47617 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbYCUQU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 12:20:57 -0400
Date: Fri, 21 Mar 2008 17:20:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080321162033.GA28593@elte.hu>
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

   git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git for-linus

Thanks!

	Ingo

------------------>
Chuck Lever (1):
      x86: fix {clear,copy}_user_page() declarations in page.h

Coleman Kane (1):
      x86: add the DFF (Desktop Form Factor) Dell Optiplex 745 to the reboot errata list

Heinz-Ado Arnolds (1):
      x86: fix reboot problem with Dell Optiplex 745, 0KW626 board

Jiri Slaby (1):
      x86: fix fault_msg nul termination

Mathieu Desnoyers (1):
      x86: cast cmpxchg and cmpxchg_local result for 386 and 486

Matti Linnanvuori (1):
      sync_bitops: fix wrong comments [Bug 10247]

Pavel Machek (1):
      x86: fix long standing bug with usb after hibernation with 4GB ram

Randy Dunlap (1):
      x86/visws: fix printk format warnings

Yinghai Lu (5):
      x86: fix dma_alloc_pages
      x86: tight online check in setup_per_cpu_areas
      x86: reserve dma32 early for gart
      x86: trim mtrr don't close gap for resource allocation.
      x86_64: free_bootmem should take phys

Zbigniew Luszpinski (1):
      x86: hpet clock enable quirk on nVidia nForce 430

 arch/x86/kernel/aperture_64.c   |    3 ++
 arch/x86/kernel/cpu/mtrr/main.c |    3 +-
 arch/x86/kernel/e820_32.c       |   26 ++++++++++++++++++
 arch/x86/kernel/e820_64.c       |   27 +++++++++++++++++++
 arch/x86/kernel/head_32.S       |    2 +-
 arch/x86/kernel/pci-dma_64.c    |   54 +++++++++++++++++++++++++++++++++++---
 arch/x86/kernel/quirks.c        |    2 +
 arch/x86/kernel/reboot.c        |   18 +++++++++++++
 arch/x86/kernel/setup64.c       |   14 ++++++----
 arch/x86/kernel/setup_64.c      |    2 +
 arch/x86/mach-visws/traps.c     |    5 ++-
 arch/x86/mm/numa_64.c           |    3 +-
 include/asm-x86/cmpxchg_32.h    |   32 ++++++++++++++--------
 include/asm-x86/e820_32.h       |    2 +
 include/asm-x86/e820_64.h       |    2 +
 include/asm-x86/page.h          |    4 +-
 include/asm-x86/pci_64.h        |    1 +
 include/asm-x86/sync_bitops.h   |    9 +------
 18 files changed, 170 insertions(+), 39 deletions(-)
