Return-Path: <linux-kernel-owner+w=401wt.eu-S1759596AbZLOKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596AbZLOKCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759587AbZLOKCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:02:12 -0500
Received: from relay.atmel.no ([80.232.32.139]:54326 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759465AbZLOKCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:02:11 -0500
Date: Tue, 15 Dec 2009 11:01:56 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: AVR32 Linux Kernel <kernel@avr32linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 update for 2.6.33
Message-ID: <20091215110156.7e63178b@hskinnemoen-d830>
Organization: Atmel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following changes.

Note that the patch "avr32: add two new at91 to cpu.h definition" has
already been applied through different channels because I was too slow,
so I did a merge to resolve the conflict rather than removing it from
the history.

Christoph Hellwig (1):
      avr32: convert to asm-generic/hardirq.h

Haavard Skinnemoen (2):
      Merge commit 'v2.6.32-rc3'
      Merge commit 'v2.6.32'

Hans-Christian Egtvedt (3):
      avr32: add support for ATNGW100 mkII board
      avr32: add default configurations for ATNGW100 mkII and EVKLCD10X
      avr32: update default configurations for ATNGW100, ATSTK1002 and ATSTK1006

Nelson Elhage (1):
      avr32: clean up linker script using standard macros.

Nicolas Ferre (1):
      avr32: add two new at91 to cpu.h definition

Peter Ma (3):
      avr32: re-instate MCI WP/CD pin assignments for ATNGW100
      avr32: function for independently setting up SPI slaves
      avr32: MRMT: correct setup of SPI slaves

 arch/avr32/Kconfig                                 |   13 +-
 arch/avr32/Makefile                                |    2 +-
 arch/avr32/boards/atngw100/Kconfig                 |   25 +-
 arch/avr32/boards/atngw100/evklcd10x.c             |    7 +-
 arch/avr32/boards/atngw100/mrmt.c                  |    1 +
 arch/avr32/boards/atngw100/setup.c                 |  121 ++-
 arch/avr32/configs/atngw100_defconfig              |  383 ++++--
 arch/avr32/configs/atngw100_evklcd100_defconfig    |  605 ++++++--
 arch/avr32/configs/atngw100_evklcd101_defconfig    |  599 ++++++--
 arch/avr32/configs/atngw100mkii_defconfig          | 1414 ++++++++++++++++++
 .../avr32/configs/atngw100mkii_evklcd100_defconfig | 1549 ++++++++++++++++++++
 .../avr32/configs/atngw100mkii_evklcd101_defconfig | 1549 ++++++++++++++++++++
 arch/avr32/configs/atstk1002_defconfig             |  415 ++++--
 arch/avr32/configs/atstk1006_defconfig             |  297 +++-
 arch/avr32/include/asm/hardirq.h                   |   19 +-
 arch/avr32/kernel/irq.c                            |    9 -
 arch/avr32/kernel/vmlinux.lds.S                    |   64 +-
 arch/avr32/mach-at32ap/at32ap700x.c                |   35 +-
 arch/avr32/mach-at32ap/include/mach/board.h        |    1 +
 19 files changed, 6389 insertions(+), 719 deletions(-)
 create mode 100644 arch/avr32/configs/atngw100mkii_defconfig
 create mode 100644 arch/avr32/configs/atngw100mkii_evklcd100_defconfig
 create mode 100644 arch/avr32/configs/atngw100mkii_evklcd101_defconfig
