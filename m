Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYJWOG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYJWOG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbYJWOGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:06:51 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:54537 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYJWOGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:06:50 -0400
Date: Thu, 23 Oct 2008 16:05:59 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] AVR32 update for 2.6.28-rc1, round 2
Message-ID: <20081023160559.77f79a84@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Oct 2008 14:05:45.0640 (UTC) FILETIME=[717EEA80:01C93518]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following updates. This includes support for four new
boards and a couple of fixes.

I'm seeing some jffs2-related build failures, but they don't seem to be
related to the arch code.

Alex Raimondi (1):
      avr32: Fix bug in LCD pin setup on port C

Haavard Skinnemoen (6):
      avr32: Kconfig: Remove pointless if around atstk1000 include
      avr32: Add defconfig for the mimc200 board
      avr32: Add defconfig for the favr-32 board
      avr32: Scale loops_per_jiffy when cpu frequency changes
      avr32: Fix GPIO initcall breakage
      Merge branches 'boards' and 'fixes' of git://git.kernel.org/.../hskinnemoen/avr32-2.6

Hans-Christian Egtvedt (2):
      avr32: Add support for EVKLCD10X addon boards
      avr32: add support for EarthLCD Favr-32 board

Mark Jackson (2):
      avr32: Fix MIMC200 board use of SPD network pins
      avr32: Add MIMC200 board support

 arch/avr32/Kconfig                              |   12 +-
 arch/avr32/Makefile                             |    2 +
 arch/avr32/boards/atngw100/Kconfig              |   35 +
 arch/avr32/boards/atngw100/Makefile             |    3 +-
 arch/avr32/boards/atngw100/evklcd10x.c          |  155 +++
 arch/avr32/boards/atngw100/setup.c              |    7 +-
 arch/avr32/boards/atstk1000/atstk1002.c         |    2 -
 arch/avr32/boards/atstk1000/atstk1003.c         |    2 -
 arch/avr32/boards/atstk1000/atstk1004.c         |    2 -
 arch/avr32/boards/favr-32/Kconfig               |   22 +
 arch/avr32/boards/favr-32/Makefile              |    1 +
 arch/avr32/boards/favr-32/flash.c               |   98 ++
 arch/avr32/boards/favr-32/setup.c               |  352 +++++++
 arch/avr32/boards/mimc200/Makefile              |    1 +
 arch/avr32/boards/mimc200/flash.c               |  143 +++
 arch/avr32/boards/mimc200/fram.c                |   80 ++
 arch/avr32/boards/mimc200/setup.c               |  237 +++++
 arch/avr32/configs/atngw100_evklcd100_defconfig | 1264 +++++++++++++++++++++++
 arch/avr32/configs/atngw100_evklcd101_defconfig | 1264 +++++++++++++++++++++++
 arch/avr32/configs/favr-32_defconfig            | 1235 ++++++++++++++++++++++
 arch/avr32/configs/mimc200_defconfig            | 1109 ++++++++++++++++++++
 arch/avr32/mach-at32ap/at32ap700x.c             |   11 +-
 arch/avr32/mach-at32ap/cpufreq.c                |   14 +
 arch/avr32/mach-at32ap/include/mach/board.h     |   10 +-
 24 files changed, 6046 insertions(+), 15 deletions(-)
 create mode 100644 arch/avr32/boards/atngw100/Kconfig
 create mode 100644 arch/avr32/boards/atngw100/evklcd10x.c
 create mode 100644 arch/avr32/boards/favr-32/Kconfig
 create mode 100644 arch/avr32/boards/favr-32/Makefile
 create mode 100644 arch/avr32/boards/favr-32/flash.c
 create mode 100644 arch/avr32/boards/favr-32/setup.c
 create mode 100644 arch/avr32/boards/mimc200/Makefile
 create mode 100644 arch/avr32/boards/mimc200/flash.c
 create mode 100644 arch/avr32/boards/mimc200/fram.c
 create mode 100644 arch/avr32/boards/mimc200/setup.c
 create mode 100644 arch/avr32/configs/atngw100_evklcd100_defconfig
 create mode 100644 arch/avr32/configs/atngw100_evklcd101_defconfig
 create mode 100644 arch/avr32/configs/favr-32_defconfig
 create mode 100644 arch/avr32/configs/mimc200_defconfig

Haavard
