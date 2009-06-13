Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbZFMOOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbZFMOOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 10:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbZFMOO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 10:14:29 -0400
Received: from relay.atmel.no ([80.232.32.139]:63481 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbZFMOO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 10:14:29 -0400
Date: Sat, 13 Jun 2009 16:14:16 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       AVR32 Linux Kernel <kernel@avr32linux.org>
Subject: [GIT PULL] AVR32 update
Message-ID: <20090613161416.0067de9a@hskinnemoen-d830>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following updates.

Ben Nizette (1):
      avr32: Fix clash in ATMEL_USART_ flags

Haavard Skinnemoen (2):
      Merge branch 'avr32-arch' of git://git.kernel.org/.../hskinnemoen/avr32-2.6
      avr32: Fix oops on unaligned user access

Jonas Larsson (2):
      atmel-mci: Add support for inverted detect pin
      avr32: Solves problem with inverted MCI detect pin on Merisc board

Mark Jackson (1):
      Fix MIMC200 board LCD init

Peter Ma (2):
      avr32: Change Atmel ATNGW100 config to add choice of add-on board
      avr32: Add support for Mediama RMTx add-on board for ATNGW100

Thomas Gleixner (1):
      avr32: remove obsolete hw_interrupt_type

 arch/avr32/boards/atngw100/Kconfig          |   27 +-
 arch/avr32/boards/atngw100/Kconfig_mrmt     |   80 ++
 arch/avr32/boards/atngw100/Makefile         |    1 +
 arch/avr32/boards/atngw100/mrmt.c           |  373 ++++++++
 arch/avr32/boards/atngw100/setup.c          |    5 +
 arch/avr32/boards/merisc/setup.c            |    7 +-
 arch/avr32/boards/mimc200/setup.c           |   29 +-
 arch/avr32/configs/atngw100_mrmt_defconfig  | 1363 +++++++++++++++++++++++++++
 arch/avr32/include/asm/hw_irq.h             |    2 +-
 arch/avr32/kernel/traps.c                   |   11 +-
 arch/avr32/mach-at32ap/include/mach/board.h |    2 +-
 drivers/mmc/host/atmel-mci.c                |   12 +-
 include/linux/atmel-mci.h                   |    2 +
 13 files changed, 1889 insertions(+), 25 deletions(-)
 create mode 100644 arch/avr32/boards/atngw100/Kconfig_mrmt
 create mode 100644 arch/avr32/boards/atngw100/mrmt.c
 create mode 100644 arch/avr32/configs/atngw100_mrmt_defconfig
