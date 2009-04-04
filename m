Return-Path: <linux-kernel-owner+w=401wt.eu-S1760716AbZDDJe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbZDDJe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 05:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbZDDJeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 05:34:20 -0400
Received: from relay.atmel.no ([80.232.32.139]:63221 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbZDDJeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 05:34:19 -0400
Date: Sat, 4 Apr 2009 11:33:27 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] AVR32 update
Message-ID: <20090404113327.30d7f1aa@hskinnemoen-d830>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git avr32-arch

to receive the following updates. This includes support for a new
board, as well as platform glue for two new drivers that went in
through the ALSA tree.

Haavard Skinnemoen (1):
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6 into avr32-arch

Hans-Christian Egtvedt (10):
      avr32: fix 15-bit LCDC pin mask to use MSB lines
      avr32: add pin mask for 18-bit color on the LCD controller
      avr32: set pin mask to alternative 18 bpp for EVKLCD10x boards
      avr32: configure MCI detect and write protect pins for EVKLCD10x boards
      avr32: use GPIO line PB15 on EVKLCD10x boards for backlight
      avr32: fix timing LCD parameters for EVKLCD10X boards
      atmel-usba-udc: use gpio_is_valid() to check vbus_pin I/O line
      avr32: use gpio_is_valid() to check USBA vbus_pin I/O line
      avr32: at32ap700x: setup DMA for ABDAC in the machine code
      avr32: at32ap700x: setup DMA for AC97C in the machine code

Jonas Larsson (2):
      Add Merisc board support
      Add RTC support for Merisc boards

Peter Ma (2):
      avr32: add RTS/CTS/CLK pin selection for the USARTs
      avr32: add hardware handshake support to atmel_serial

 arch/avr32/Kconfig                               |   14 +
 arch/avr32/Makefile                              |    1 +
 arch/avr32/boards/atngw100/evklcd10x.c           |   50 +-
 arch/avr32/boards/atngw100/setup.c               |    7 +-
 arch/avr32/boards/atstk1000/atstk1002.c          |    6 +-
 arch/avr32/boards/atstk1000/atstk1003.c          |    6 +-
 arch/avr32/boards/atstk1000/atstk1004.c          |    6 +-
 arch/avr32/boards/favr-32/setup.c                |    9 +-
 arch/avr32/boards/hammerhead/setup.c             |    6 +-
 arch/avr32/boards/merisc/Kconfig                 |    5 +
 arch/avr32/boards/merisc/Makefile                |    1 +
 arch/avr32/boards/merisc/display.c               |   65 ++
 arch/avr32/boards/merisc/flash.c                 |  139 +++
 arch/avr32/boards/merisc/merisc.h                |   18 +
 arch/avr32/boards/merisc/merisc_sysfs.c          |   65 ++
 arch/avr32/boards/merisc/setup.c                 |  297 ++++++
 arch/avr32/boards/mimc200/setup.c                |    8 +-
 arch/avr32/configs/merisc_defconfig              | 1237 ++++++++++++++++++++++
 arch/avr32/mach-at32ap/at32ap700x.c              |  112 ++-
 arch/avr32/mach-at32ap/include/mach/at32ap700x.h |   52 +-
 arch/avr32/mach-at32ap/include/mach/board.h      |   24 +-
 drivers/serial/atmel_serial.c                    |    9 +-
 drivers/usb/gadget/atmel_usba_udc.c              |   14 +-
 23 files changed, 2049 insertions(+), 102 deletions(-)
 create mode 100644 arch/avr32/boards/merisc/Kconfig
 create mode 100644 arch/avr32/boards/merisc/Makefile
 create mode 100644 arch/avr32/boards/merisc/display.c
 create mode 100644 arch/avr32/boards/merisc/flash.c
 create mode 100644 arch/avr32/boards/merisc/merisc.h
 create mode 100644 arch/avr32/boards/merisc/merisc_sysfs.c
 create mode 100644 arch/avr32/boards/merisc/setup.c
 create mode 100644 arch/avr32/configs/merisc_defconfig
