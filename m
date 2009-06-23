Return-Path: <linux-kernel-owner+w=401wt.eu-S1757474AbZFWMtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474AbZFWMtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbZFWMtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:49:00 -0400
Received: from miranda.se.axis.com ([193.13.178.8]:50281 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbZFWMtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:49:00 -0400
Date: Tue, 23 Jun 2009 14:48:20 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: [GIT PULL] CRIS updates for 2.6.31
Message-ID: <20090623124820.GC12383@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Please pull the below repo for a small number of CRIS-fixes.

The following changes since commit ccc0d38ec13d4649d4168c1db590137df53ad783:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://www.jni.nu/cris.git for-linus

Jesper Nilsson (3):
      CRISv32: Add arch optimized strcmp.
      CRISv32: Fix potential null reference in cryptocop driver.
      CRISv32: irq.c - Move end brace outside #endif

Roel Kluin (2):
      CRIS: assignment/is equal confusion
      CRISv10: remove redundant tests on unsigned

 arch/cris/arch-v10/kernel/dma.c            |    4 ++--
 arch/cris/arch-v32/drivers/cryptocop.c     |    4 ++--
 arch/cris/arch-v32/kernel/irq.c            |    2 +-
 arch/cris/arch-v32/lib/Makefile            |    2 +-
 arch/cris/arch-v32/lib/strcmp.S            |   21 +++++++++++++++++++++
 arch/cris/include/arch-v32/arch/spinlock.h |    6 +++---
 arch/cris/include/asm/string.h             |    6 ++++++
 7 files changed, 36 insertions(+), 9 deletions(-)
 create mode 100644 arch/cris/arch-v32/lib/strcmp.S

Thanks!

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
