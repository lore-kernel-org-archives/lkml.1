Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZD1Fzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZD1Fzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZD1FzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:55:24 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60323 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753905AbZD1FzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:55:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18934.39491.9616.529066@cargo.ozlabs.ibm.com>
Date: Tue, 28 Apr 2009 15:55:15 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: [git pull] Please pull powerpc.git merge branch
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from the 'merge' branch of

git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge

to get a collection of bug fixes for powerpc.

Thanks,
Paul.

 MAINTAINERS                           |    2 +
 arch/powerpc/boot/4xx.c               |   56 +++++++++++++++++++++++++--------
 arch/powerpc/boot/dts/gef_ppc9a.dts   |    1 +
 arch/powerpc/include/asm/elf.h        |    1 +
 arch/powerpc/include/asm/mmu.h        |    6 ----
 arch/powerpc/include/asm/ppc-opcode.h |   11 +-----
 arch/powerpc/kernel/cputable.c        |    2 +
 arch/powerpc/mm/tlb_nohash_low.S      |   16 +--------
 arch/powerpc/platforms/cell/Kconfig   |    5 ++-
 arch/powerpc/platforms/ps3/setup.c    |    4 --
 10 files changed, 54 insertions(+), 50 deletions(-)

Geoff Levand (1):
      powerpc/ps3: Fix build error on UP

Josh Boyer (1):
      maintainers: Fix PowerPC 4xx git tree

Kumar Gala (2):
      Revert "powerpc: Add support for early tlbilx opcode"
      powerpc: ppc32 needs elf_read_implies_exec()

Martyn Welch (1):
      powerpc/86xx: Add device_type entry to soc for ppc9a

Michael Ellerman (1):
      powerpc/cell: Select PCI for IBM_CELL_BLADE AND CELLEB

Stephen Rothwell (1):
      powerpc: fix for long standing bug noticed by gcc 4.4.0

Valentine Barshak (1):
      powerpc/44x: Correct memory size calculation for denali-based boards

