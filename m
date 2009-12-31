Return-Path: <linux-kernel-owner+w=401wt.eu-S1751823AbZLaMDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbZLaMDk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 07:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751735AbZLaMDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 07:03:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49428 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZLaMDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 07:03:38 -0500
Date: Thu, 31 Dec 2009 13:03:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20091231120322.GA23326@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,



Please pull the latest x86-fixes-for-linus git tree from:



   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus



You'll get a conflict in arch/x86/include/asm/uv/uv_hub.h (you merged a v1 

version of the patch from email - the conflicts are trivial, please pick my 

version).



Thanks,



	Ingo



---

 arch/x86/boot/compressed/Makefile  |    1 +

 arch/x86/include/asm/uv/uv_hub.h   |   86 ++++++++++++++++++++----------------

 arch/x86/kernel/amd_iommu_init.c   |   10 ++++

 arch/x86/kernel/apic/x2apic_uv_x.c |   12 +++---

 arch/x86/kernel/process.c          |    4 +-

 arch/x86/kernel/process_32.c       |   14 +++---

 arch/x86/kernel/process_64.c       |   24 +++++-----

 arch/x86/mm/kmemcheck/error.c      |   19 ++++----

 arch/x86/tools/chkobjdump.awk      |   16 +++++-

 drivers/char/agp/amd64-agp.c       |    9 ++--

 lib/dma-debug.c                    |    5 ++

 11 files changed, 118 insertions(+), 82 deletions(-)





FUJITA Tomonori (1):

      x86/agp: Fix agp_amd64_init() initialization with CONFIG_GART_IOMMU enabled



H. Peter Anvin (1):

      x86, compress: Force i386 instructions for the decompressor



Ingo Molnar (1):

      Merge branch 'iommu/fixes' of git://git.kernel.org/.../joro/linux-2.6-iommu into x86/urgent



Joerg Roedel (2):

      x86/amd-iommu: Fix initialization failure panic

      Merge branches 'dma-debug/fixes' and 'amd-iommu/fixes' into iommu/fixes



Masami Hiramatsu (1):

      x86: Fix objdump version check in chkobjdump.awk for different formats.



Mike Travis (1):

      x86: SGI UV: Fix writes to led registers on remote uv hubs



Pekka Enberg (2):

      x86: Use KERN_DEFAULT log-level in __show_regs()

      x86, kmemcheck: Use KERN_WARNING for error reporting



Shaun Ruffell (1):

      dma-debug: Do not add notifier when dma debugging is disabled.



