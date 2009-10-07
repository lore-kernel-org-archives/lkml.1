Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbZJGSwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbZJGSwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZJGSv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 14:51:59 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:65255 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628AbZJGSv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 14:51:59 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+oe8sXa0/dJaeMhqzCt+iY
Date: Wed, 7 Oct 2009 11:51:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Subject: [GIT PULL] omap fixes for v2.6.32-rc3
Message-ID: <20091007185112.GJ7899@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull omap fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Regards,

Tony


The following changes since commit 374576a8b6f865022c0fd1ca62396889b23d66dd:
  Linus Torvalds (1):
        Linux 2.6.32-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Artem Bityutskiy (1):
      OMAP3: PM: introduce a new powerdomain walk helper

Daniel Walker (1):
      omap: iovmm: Add missing mutex_unlock

Hiroshi DOYU (1):
      omap: iovmm: Fix incorrect spelling

Jon Hunter (1):
      OMAP3: PM: Prevent hang in prcm_interrupt_handler

Kevin Hilman (1):
      OMAP3: PM: Enable GPIO module-level wakeups

Paul Walmsley (2):
      OMAP3: PM: PRCM interrupt: check MPUGRPSEL register
      OMAP3: PM: PRCM interrupt: only handle selected PRCM interrupts

Rajendra Nayak (1):
      omap: Lock DPLL5 at boot

Sergio Aguirre (1):
      omapfb: Condition mutex acquisition

Tommi Rantala (2):
      omapfb: Blizzard: fix pointer to be const
      omapfb: Blizzard: constify register address tables

Tony Lindgren (2):
      omap: Fix incorrect 730 vs 850 detection
      Merge branch 'pm-fixes-32' of git://git.kernel.org/.../khilman/linux-omap-pm into omap-fixes-for-linus

Vikram Pandita (1):
      OMAP3: PM: USBHOST: clear wakeup events on both hosts

ye janboe (1):
      omap: SRAM: flush the right address after memcpy in omap_sram_push

 arch/arm/mach-omap2/clock34xx.c               |   35 +++++
 arch/arm/mach-omap2/pm-debug.c                |    4 +-
 arch/arm/mach-omap2/pm34xx.c                  |  187 ++++++++++++++-----------
 arch/arm/mach-omap2/powerdomain.c             |   39 ++++--
 arch/arm/plat-omap/include/mach/cpu.h         |   37 ++---
 arch/arm/plat-omap/include/mach/powerdomain.h |    2 +
 arch/arm/plat-omap/iovmm.c                    |    9 +-
 arch/arm/plat-omap/sram.c                     |    3 +-
 drivers/video/omap/blizzard.c                 |   10 +-
 drivers/video/omap/omapfb_main.c              |   22 ++-
 10 files changed, 212 insertions(+), 136 deletions(-)
