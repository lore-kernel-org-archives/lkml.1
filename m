Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYGXNG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYGXNG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYGXNGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:06:18 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:43278 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYGXNGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:06:17 -0400
Date: Thu, 24 Jul 2008 07:06:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request: Semaphore updates
Message-ID: <20080724130600.GB28269@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull the branch below?  All the changes except one stray
asm/semaphore.h -> linux/semaphore.h conversion have been in the
linux-next tree for a couple of months.  

The following changes since commit 338b9bb3adac0d2c5a1e180491d9b001d624c402:
  Linus Torvalds (1):
        Merge branch 'x86/auditsc' of git://git.kernel.org/.../frob/linux-2.6-roland

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore

Matthew Wilcox (5):
      Remove mention of semaphores from kernel-locking
      Add missing semaphore.h includes
      Remove use of asm/semaphore.h
      Remove asm/semaphore.h
      Remove __DECLARE_SEMAPHORE_GENERIC

 Documentation/DocBook/kernel-locking.tmpl  |   57 ++++++++++++----------------
 Documentation/feature-removal-schedule.txt |    8 ----
 arch/arm/mach-ns9xxx/clock.c               |    2 +-
 drivers/input/keyboard/hil_kbd.c           |    1 +
 drivers/input/misc/hp_sdc_rtc.c            |    1 +
 drivers/input/serio/hp_sdc.c               |    1 +
 include/asm-alpha/semaphore.h              |    1 -
 include/asm-arm/semaphore.h                |    1 -
 include/asm-avr32/semaphore.h              |    1 -
 include/asm-blackfin/semaphore.h           |    1 -
 include/asm-cris/semaphore.h               |    1 -
 include/asm-frv/semaphore.h                |    1 -
 include/asm-h8300/semaphore.h              |    1 -
 include/asm-ia64/semaphore.h               |    1 -
 include/asm-m32r/semaphore.h               |    1 -
 include/asm-m68k/semaphore.h               |    1 -
 include/asm-m68knommu/semaphore.h          |    1 -
 include/asm-mips/semaphore.h               |    1 -
 include/asm-mn10300/semaphore.h            |    1 -
 include/asm-parisc/semaphore.h             |    1 -
 include/asm-powerpc/semaphore.h            |    1 -
 include/asm-s390/semaphore.h               |    1 -
 include/asm-sh/semaphore.h                 |    1 -
 include/asm-sparc/semaphore.h              |    1 -
 include/asm-sparc64/semaphore.h            |    1 -
 include/asm-um/semaphore.h                 |    1 -
 include/asm-v850/semaphore.h               |    1 -
 include/asm-x86/semaphore.h                |    1 -
 include/asm-xtensa/semaphore.h             |    1 -
 include/linux/semaphore.h                  |    6 +--
 30 files changed, 30 insertions(+), 69 deletions(-)
 delete mode 100644 include/asm-alpha/semaphore.h
 delete mode 100644 include/asm-arm/semaphore.h
 delete mode 100644 include/asm-avr32/semaphore.h
 delete mode 100644 include/asm-blackfin/semaphore.h
 delete mode 100644 include/asm-cris/semaphore.h
 delete mode 100644 include/asm-frv/semaphore.h
 delete mode 100644 include/asm-h8300/semaphore.h
 delete mode 100644 include/asm-ia64/semaphore.h
 delete mode 100644 include/asm-m32r/semaphore.h
 delete mode 100644 include/asm-m68k/semaphore.h
 delete mode 100644 include/asm-m68knommu/semaphore.h
 delete mode 100644 include/asm-mips/semaphore.h
 delete mode 100644 include/asm-mn10300/semaphore.h
 delete mode 100644 include/asm-parisc/semaphore.h
 delete mode 100644 include/asm-powerpc/semaphore.h
 delete mode 100644 include/asm-s390/semaphore.h
 delete mode 100644 include/asm-sh/semaphore.h
 delete mode 100644 include/asm-sparc/semaphore.h
 delete mode 100644 include/asm-sparc64/semaphore.h
 delete mode 100644 include/asm-um/semaphore.h
 delete mode 100644 include/asm-v850/semaphore.h
 delete mode 100644 include/asm-x86/semaphore.h
 delete mode 100644 include/asm-xtensa/semaphore.h


-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
