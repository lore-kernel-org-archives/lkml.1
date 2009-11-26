Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZKZV0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZKZV0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZKZV0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:26:23 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39594 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbZKZV0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:26:22 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Pull request blackfin.git (for-linus branch)
Date: Thu, 26 Nov 2009 16:26:24 -0500
Message-Id: <1259270784-29793-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit a8a8a669ea13d792296737505adc43ccacf3a648:
  Linus Torvalds (1):
        Merge branch 'i2c-pnx-fixes' of git://git.fluff.org/bjdooks/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin.git for-linus

André Goddard Rosa (1):
      Blackfin: fix cache Kconfig typo

Graf Yang (1):
      Blackfin: fix SMP build error in start_thread()

Jie Zhang (1):
      Blackfin: fix typo in ptrace poking

Michael Hennerich (1):
      Blackfin: fix suspend/resume failure with some on-chip ROMs

Mike Frysinger (3):
      Blackfin: update anomaly lists
      Blackfin: work around testset anomaly 05000477
      Blackfin: check for anomaly 05000475

Roel Kluin (1):
      Blackfin: fix memset in smp_send_reschedule() and -stop()

 arch/blackfin/kernel/bfin_dma_5xx.c             |    9 ++++++-
 arch/blackfin/kernel/cplb-mpu/cplbinit.c        |    2 +-
 arch/blackfin/kernel/process.c                  |    2 +-
 arch/blackfin/kernel/ptrace.c                   |    2 +-
 arch/blackfin/mach-bf518/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf527/include/mach/anomaly.h |   20 +++++++++++++----
 arch/blackfin/mach-bf533/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf537/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf538/include/mach/anomaly.h |   18 ++++++++++++---
 arch/blackfin/mach-bf548/include/mach/anomaly.h |   23 ++++++++++++++++----
 arch/blackfin/mach-bf561/atomic.S               |   14 +++++++++++-
 arch/blackfin/mach-bf561/include/mach/anomaly.h |   25 ++++++++++++++++++----
 arch/blackfin/mach-common/arch_checks.c         |    5 ++++
 arch/blackfin/mach-common/smp.c                 |    6 +---
 14 files changed, 138 insertions(+), 42 deletions(-)
