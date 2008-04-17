Return-Path: <linux-kernel-owner+w=401wt.eu-S934379AbYDQSXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbYDQSXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757085AbYDQSXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:23:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756278AbYDQSXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:23:01 -0400
Date: Thu, 17 Apr 2008 20:22:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [git pull] kgdb light for v2.6.26
Message-ID: <20080417182246.GB15158@elte.hu>
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


Linus, please pull the kgdb-light git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git

[ i kept the v2.6.25 history because it demonstrates the flux in this 
  codebase during v2.6.25 - it was quite low. ]

Thanks,

	Ingo

------------------>
Andrew Morton (1):
      kgdb: Kconfig fix

Ingo Molnar (2):
      uaccess: add probe_kernel_write()
      x86: kgdb support

Jason Wessel (17):
      kgdb: core
      consoles: polling support, kgdboc
      kgdb: document parameters
      kgdb: fix kgdboc dynamic module configuration
      kgdb: fix NMI hangs
      kgdb: clocksource watchdog
      kgdb: print breakpoint removed on exception
      kgdb: add x86 HW breakpoints
      kgdb: fix optional arch functions and probe_kernel_*
      kgdb: kgdboc pl011 I/O module
      kgdb: fix several kgdb regressions
      kgdb: add kgdb internal test suite
      kgdb: add documentation
      kgdb: allow static kgdbts boot configuration
      kgdb: documentation fixes
      kgdb: fix SMP NMI kgdb_handle_exception exit race
      kgdb: always use icache flush for sw breakpoints

 Documentation/DocBook/Makefile      |    2 +-
 Documentation/DocBook/kgdb.tmpl     |  447 +++++++++
 Documentation/kernel-parameters.txt |    5 +
 MAINTAINERS                         |    6 +
 arch/x86/Kconfig                    |    1 +
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/kgdb.c              |  571 ++++++++++++
 arch/x86/kernel/setup64.c           |   16 +
 arch/x86/kernel/traps_32.c          |    2 +
 arch/x86/kernel/traps_64.c          |    9 +-
 drivers/char/tty_io.c               |   47 +
 drivers/misc/Makefile               |    1 +
 drivers/misc/kgdbts.c               | 1090 ++++++++++++++++++++++
 drivers/serial/8250.c               |   58 ++
 drivers/serial/Kconfig              |    3 +
 drivers/serial/Makefile             |    1 +
 drivers/serial/amba-pl011.c         |   30 +
 drivers/serial/kgdboc.c             |  168 ++++
 drivers/serial/serial_core.c        |   74 ++-
 include/asm-x86/kdebug.h            |    1 +
 include/asm-x86/kgdb.h              |   81 ++
 include/linux/clocksource.h         |    1 +
 include/linux/kgdb.h                |  281 ++++++
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   12 +
 include/linux/uaccess.h             |   22 +
 kernel/Makefile                     |    1 +
 kernel/kgdb.c                       | 1700 +++++++++++++++++++++++++++++++++++
 kernel/time/clocksource.c           |   12 +
 lib/Kconfig.debug                   |    2 +
 lib/Kconfig.kgdb                    |   58 ++
 mm/Makefile                         |    2 +-
 mm/maccess.c                        |   55 ++
 33 files changed, 4757 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/DocBook/kgdb.tmpl
 create mode 100644 arch/x86/kernel/kgdb.c
 create mode 100644 drivers/misc/kgdbts.c
 create mode 100644 drivers/serial/kgdboc.c
 create mode 100644 include/asm-x86/kgdb.h
 create mode 100644 include/linux/kgdb.h
 create mode 100644 kernel/kgdb.c
 create mode 100644 lib/Kconfig.kgdb
 create mode 100644 mm/maccess.c

