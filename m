Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbZBDKmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbZBDKmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbZBDKmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:42:24 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:37563 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZBDKmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:42:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=G/bQAaZ5bjwJWCsjejkm/kuouzVyevGxg0xDGYHwRRpkUgU/lOsFSXmA3uhGBWB9Bm
         7HmcbvwUCw/MyDxSoL8j81y2PgQT6bE0EKH0Y3wfQ5lUacyin+xJSTHHmOneURJ+qPJM
         Jp3nDLlkC7h9e7fHM1fn3605M+fb3i40HyR/E=
MIME-Version: 1.0
Date: Wed, 4 Feb 2009 18:42:20 +0800
X-Google-Sender-Auth: 982cc8e0303f74ed
Message-ID: <386072610902040242l4ab4882fhbc06dc5865c17b45@mail.gmail.com>
Subject: [GIT PULL] Blackfin fixing and updates for 2.6.29-rc3+
From: Bryan Wu <cooloney@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 MAINTAINERS                                      |    2 +-
 arch/blackfin/Kconfig                            |   52 ++-
 arch/blackfin/Makefile                           |  106 +++--
 arch/blackfin/configs/BF518F-EZBRD_defconfig     |    9 +-
 arch/blackfin/configs/BF526-EZBRD_defconfig      |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig      |    2 +-
 arch/blackfin/configs/BF533-EZKIT_defconfig      |    2 +-
 arch/blackfin/configs/BF533-STAMP_defconfig      |    2 +-
 arch/blackfin/configs/BF537-STAMP_defconfig      |    2 +-
 arch/blackfin/configs/BF538-EZKIT_defconfig      |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig      |    2 +-
 arch/blackfin/configs/BF561-EZKIT_defconfig      |    2 +-
 arch/blackfin/configs/CM-BF527_defconfig         |  445 ++++++++++++-----
 arch/blackfin/include/asm/checksum.h             |   34 +-
 arch/blackfin/include/asm/delay.h                |   35 +--
 arch/blackfin/include/asm/gpio.h                 |   58 ---
 arch/blackfin/include/asm/kgdb.h                 |   53 +--
 arch/blackfin/include/asm/mem_init.h             |    2 +-
 arch/blackfin/include/asm/pda.h                  |    1 +
 arch/blackfin/include/asm/reboot.h               |    2 +-
 arch/blackfin/kernel/Makefile                    |    2 +
 arch/blackfin/kernel/bfin_dma_5xx.c              |    7 +
 arch/blackfin/kernel/bfin_gpio.c                 |  578 +++++++++-------------
 arch/blackfin/kernel/cplb-mpu/cplbinit.c         |    4 +-
 arch/blackfin/kernel/cplb-nompu/cplbmgr.c        |   12 +-
 arch/blackfin/kernel/irqchip.c                   |    8 +-
 arch/blackfin/kernel/reboot.c                    |   30 +-
 arch/blackfin/kernel/setup.c                     |   12 +-
 arch/blackfin/kernel/traps.c                     |   39 +-
 arch/blackfin/mach-bf518/boards/ezbrd.c          |   59 ++-
 arch/blackfin/mach-bf518/include/mach/portmux.h  |    2 +
 arch/blackfin/mach-bf527/boards/cm_bf527.c       |   18 +-
 arch/blackfin/mach-bf527/boards/ezbrd.c          |   18 +-
 arch/blackfin/mach-bf527/boards/ezkit.c          |   18 +-
 arch/blackfin/mach-bf527/include/mach/portmux.h  |    2 +
 arch/blackfin/mach-bf533/boards/blackstamp.c     |    4 -
 arch/blackfin/mach-bf533/boards/stamp.c          |    4 -
 arch/blackfin/mach-bf533/include/mach/portmux.h  |    5 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c       |    6 +
 arch/blackfin/mach-bf537/boards/generic_board.c  |   12 +-
 arch/blackfin/mach-bf537/boards/minotaur.c       |    8 +-
 arch/blackfin/mach-bf537/boards/pnav10.c         |   10 +-
 arch/blackfin/mach-bf537/boards/stamp.c          |   14 +-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c      |   10 +-
 arch/blackfin/mach-bf537/include/mach/portmux.h  |    1 +
 arch/blackfin/mach-bf538/include/mach/portmux.h  |    1 +
 arch/blackfin/mach-bf548/boards/ezkit.c          |    4 -
 arch/blackfin/mach-bf548/include/mach/anomaly.h  |    1 +
 arch/blackfin/mach-bf548/include/mach/bf548.h    |   12 +
 arch/blackfin/mach-bf548/include/mach/gpio.h     |   12 +-
 arch/blackfin/mach-bf548/include/mach/portmux.h  |    1 +
 arch/blackfin/mach-bf561/include/mach/defBF561.h |    2 +
 arch/blackfin/mach-bf561/include/mach/portmux.h  |    1 +
 arch/blackfin/mach-common/clocks-init.c          |    3 +-
 arch/blackfin/mach-common/entry.S                |    9 +-
 arch/blackfin/mach-common/head.S                 |   84 ++--
 arch/blackfin/mach-common/interrupt.S            |    2 +-
 arch/blackfin/mach-common/ints-priority.c        |   11 +-
 arch/blackfin/mach-common/pm.c                   |   11 +-
 59 files changed, 985 insertions(+), 867 deletions(-)

Bernd Schmidt (1):
      Blackfin arch: fix bug - traps test case 19 for exception 0x2d fails

Bryan Wu (1):
      Blackfin arch: Add ANOMALY_05000380 to BF54x to kill the compile warning

Grace Pan (1):
      Blackfin arch: Add in cflag to support mlong-calls for kgdb_test

Graf Yang (3):
      Blackfin arch: Fix bug - BF518 port F, G, and H have different
mux offset compare to BF527
      Blackfin arch: Fix bug - 561 SMP kernel can't boot from jffs2
      Blackfin arch: add platform device bfin_mii-bus and KSZ8893M
switch driver platform resources to board files

Jie Zhang (2):
      Blackfin arch: Add one more check on `fp' to prevent double fault
      Blackfin arch: fix 2 bugs related to debug

Michael Hennerich (9):
      Blackfin arch: Fix Bug - Kernel does not boot if re-program clocks
      Blackfin arch: Fix Bug - request lines with
peripheral_request_list, but don't get freed with peripheral_free_list
      Blackfin arch: reset POLAR setting when acquiring a gpio for the
first time
      Blackfin arch: Faster Implementation of csum_tcpudp_nofold()
      Blackfin arch: Update CM-BF527 kernel config
      Blackfin arch: Add BF561 PPI POLS, POLC Masks
      Blackfin arch: Update Copyright information
      Blackfin arch: Fix udelay implementation
      Blackfin arch: Remove outdated code

Mike Frysinger (15):
      Blackfin arch: scrub comments/whitespace/cvs keywords
      Blackfin arch: add support for mobile ddr bf54x parts
      Blackfin arch: line up machine-/cpu- vars after BF54xM addition
      Blackfin arch: fix bug - Dmacopy failed in BF537-STAMP
      Blackfin arch: cleanup bf54x ifdef mess in gpio code
      MAINTIANERS: Blackfin: remove subscribers-only marking
      Blackfin arch: sync reboot handler with version in u-boot
      Blackfin arch: bfin_reset->_bfin_reset redirection no longer needed
      Blackfin arch: drop CONFIG_I2C_BOARDINFO ifdefs
      Blackfin arch: fixup board init function name
      Blackfin arch: read SYSCR on newer parts that mirror the bits of
SWRST in it
      Blackfin arch: base SIC_IWR# programming on whether the MMR exists
      Blackfin arch: build jtag tty driver as a module by default
      Blackfin arch: cplb mananger: use a do...while loop rather than a for loop
      Blackfin arch: define bfin_memmap as static since it is only used here

Robin Getz (5):
      Blackfin arch: Print out where the bootmode is coming from (for
easier debugging).
      Blackfin arch: don't accidently re-enable interrupts
      Blackfin arch: Fix URL
      Blackfin arch: Add a few more instructions that can cause the
trace buffer to be discontiguous
      Blackfin arch: Add ability to count and display number of NMI interrupts

Sonic Zhang (2):
      Blackfin arch: enable bfin_eth in bf51x by default
      Blackfin arch: Fix bug - Run "reboot" hangs bf518-ezbrd

Uwe Kleine-Koenig (1):
      Blackfin arch: explicit add a might sleep to gpio_free

Thanks
-Bryan
