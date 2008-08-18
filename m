Return-Path: <linux-kernel-owner+w=401wt.eu-S1752143AbYHRFB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbYHRFB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 01:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYHRFBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 01:01:51 -0400
Received: from ozlabs.org ([203.10.76.45]:41178 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbYHRFBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 01:01:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18601.560.540107.268646@drongo.ozlabs.ibm.com>
Date: Mon, 18 Aug 2008 15:01:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get fixes for various bugs on powerpc, as listed below.

Thanks,
Paul.

 arch/powerpc/include/asm/hvcall.h               |   22 +++++++++
 arch/powerpc/include/asm/irqflags.h             |    5 +-
 arch/powerpc/include/asm/mmu_context.h          |    1 
 arch/powerpc/include/asm/systbl.h               |    2 -
 arch/powerpc/kernel/head_32.S                   |    2 -
 arch/powerpc/kernel/lparcfg.c                   |    5 ++
 arch/powerpc/kernel/misc_32.S                   |    2 -
 arch/powerpc/kernel/module.c                    |   15 ------
 arch/powerpc/kernel/sys_ppc32.c                 |   57 -----------------------
 arch/powerpc/platforms/pseries/plpar_wrappers.h |   27 ++++++++++-
 arch/powerpc/platforms/pseries/setup.c          |   28 ++++++++---
 11 files changed, 78 insertions(+), 88 deletions(-)

Benjamin Herrenschmidt (2):
      powerpc: Fix loss of vdso on fork on 32-bit
      powerpc: Fix lockdep IRQ tracing bug

Brian King (1):
      powerpc: Fix CMM page loaning on 64k page kernel with 4k hardware pages

Christoph Hellwig (1):
      powerpc: Use generic compat_sys_old_readdir

Paul Collins (1):
      powerpc/kexec: Fix up KEXEC_CONTROL_CODE_SIZE missed during conversion

Robert Jennings (2):
      powerpc: Make CMO paging space pool ID and page size available
      powerpc: Add CMO enabled flag and paging space data to lparcfg

Rocky Craig (1):
      powerpc: Fix TLB invalidation on boot on 32-bit

Steven Rostedt (1):
      powerpc: Remove dead module_find_bug code

