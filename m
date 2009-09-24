Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbZIXVVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbZIXVVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 17:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZIXVVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 17:21:06 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:53851 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbZIXVVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 17:21:05 -0400
Date: Thu, 24 Sep 2009 23:20:28 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: [GIT PULL] CRIS updates for 2.6.32
Message-ID: <20090924212028.GS29076@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Please pull the below repo for some minor CRIS-fixes.

Thanks!

The following changes since commit adda766193ea1cf3137484a9521972d080d0b7af:
  Linus Torvalds (1):
        Merge branch 'release' of git://git.kernel.org/.../lenb/linux-acpi-2.6

are available in the git repository at:

  git://repo.or.cz/cris-mirror.git for-linus

Arnd Bergmann (1):
      CRIS: add pgprot_noncached

Christoph Hellwig (1):
      CRIS: convert to asm-generic/hardirq.h

Ingo Molnar (1):
      CRIS: fix defconfig build failure

Jesper Nilsson (2):
      CRISv10: Don't autonegotiate if autonegotiation is off
      CRIS: Cleanup linker script using new linker script macros.

Stoyan Gaydarov (1):
      ARRAY_SIZE changes

 arch/cris/arch-v10/kernel/time.c      |    1 -
 arch/cris/arch-v32/kernel/smp.c       |    2 -
 arch/cris/arch-v32/kernel/time.c      |    1 -
 arch/cris/arch-v32/mach-a3/io.c       |    2 +-
 arch/cris/arch-v32/mach-fs/io.c       |    2 +-
 arch/cris/include/arch-v10/arch/mmu.h |    9 ++++---
 arch/cris/include/arch-v32/arch/mmu.h |   10 +++++---
 arch/cris/include/asm/hardirq.h       |   12 +---------
 arch/cris/include/asm/pgtable.h       |    2 +
 arch/cris/kernel/irq.c                |    5 ----
 arch/cris/kernel/vmlinux.lds.S        |   37 +++++++-------------------------
 drivers/net/cris/eth_v10.c            |   20 +++++++++++++++--
 drivers/serial/crisv10.c              |    1 +
 13 files changed, 43 insertions(+), 61 deletions(-)

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
