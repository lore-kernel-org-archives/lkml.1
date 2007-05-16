Return-Path: <linux-kernel-owner+w=401wt.eu-S1761942AbXEPAzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761942AbXEPAzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 20:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbXEPAzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 20:55:05 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:36579 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760084AbXEPAzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 20:55:04 -0400
Date: Wed, 16 May 2007 09:54:26 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh64 updates
Message-ID: <20070516005426.GA18986@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh64-2.6.git

Which contains:

Milind Arun Choudhary (1):
      sh64: ROUND_UP macro cleanup in arch/sh64/kernel/pci_sh5.c

Paul Mundt (8):
      sh64: Wire up many new syscalls.
      sh64: Fixups for the irq_regs changes.
      sh64: dma-mapping updates.
      sh64: ppoll/pselect6() and restartable syscalls.
      sh64: Fixup sh-sci build.
      sh64: Update cayman defconfig.
      sh64: generic quicklist support.
      sh64: Add .gitignore entry for syscalltab.

Simon Arlott (1):
      spelling fixes: arch/sh64/

 arch/sh64/Kconfig                  |    3 +
 arch/sh64/configs/cayman_defconfig |  199 ++++++++++++++++++++++--------------
 arch/sh64/kernel/entry.S           |    4 +-
 arch/sh64/kernel/irq.c             |    4 +-
 arch/sh64/kernel/pci_sh5.c         |   17 ++--
 arch/sh64/kernel/pci_sh5.h         |    2 +-
 arch/sh64/kernel/process.c         |    2 +-
 arch/sh64/kernel/signal.c          |   33 +++++-
 arch/sh64/kernel/syscalls.S        |   36 ++++++-
 arch/sh64/kernel/time.c            |   18 ++--
 arch/sh64/lib/.gitignore           |    1 +
 arch/sh64/mach-cayman/irq.c        |    4 +-
 arch/sh64/mach-cayman/setup.c      |    2 +-
 arch/sh64/mm/fault.c               |    2 +-
 arch/sh64/mm/init.c                |    2 +-
 arch/sh64/mm/tlbmiss.c             |    4 +-
 include/asm-sh64/dma-mapping.h     |   14 ++-
 include/asm-sh64/irq_regs.h        |    1 +
 include/asm-sh64/pgalloc.h         |  100 ++++--------------
 include/asm-sh64/sci.h             |    1 +
 include/asm-sh64/thread_info.h     |    6 +
 include/asm-sh64/unistd.h          |   43 +++++++-
 mm/Kconfig                         |    2 +-
 23 files changed, 296 insertions(+), 204 deletions(-)
