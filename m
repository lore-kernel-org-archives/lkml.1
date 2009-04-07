Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZDGOtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZDGOtj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZDGOt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:49:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34150 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752931AbZDGOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:49:29 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 00/11] Second serial updates (please discard previous)
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Apr 2009 16:47:58 +0100
Message-ID: <20090407154715.18020.44616.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This time hopefully without a corrupt header which confused everything.

---

Adrian Bunk (1):
      tty: Correct inline types for tty_driver_kref_get()

Alan Cox (2):
      lanana: assign a device name and numbering for MAX3100
      serqt: initial clean up pass for tty side

Breno Leitao (1):
      Here are some cleanups, mainly removing unused variables and silly

Christian Pellegrin (1):
      Add support for the MAX3100 SPI UART.

Claudio Scordino (1):
      tty: Use the generic RS485 ioctl on CRIS

Mike Frysinger (3):
      Adjust path to gpio headers
      KGDB_SERIAL_CONSOLE check for module
      Change KCONFIG name

Sonic Zhang (2):
      Both software emulated and hardware based CTS and RTS are enabled in
      Only CTS bit is affected.


 Documentation/devices.txt                          |    4 
 .../mach-bf518/include/mach/bfin_serial_5xx.h      |   10 
 .../mach-bf527/include/mach/bfin_serial_5xx.h      |   36 --
 .../mach-bf533/include/mach/bfin_serial_5xx.h      |   29 -
 .../mach-bf537/include/mach/bfin_serial_5xx.h      |   37 --
 .../mach-bf538/include/mach/bfin_serial_5xx.h      |   10 
 .../mach-bf548/include/mach/bfin_serial_5xx.h      |  117 +----
 .../mach-bf561/include/mach/bfin_serial_5xx.h      |   29 -
 arch/cris/include/asm/ioctls.h                     |    5 
 arch/cris/include/asm/rs485.h                      |    8 
 arch/cris/include/asm/termios.h                    |    1 
 drivers/serial/Kconfig                             |   47 ++
 drivers/serial/Makefile                            |    1 
 drivers/serial/bfin_5xx.c                          |  282 ++++++++-----
 drivers/serial/crisv10.c                           |   79 +++-
 drivers/serial/crisv10.h                           |    2 
 drivers/serial/jsm/jsm_neo.c                       |   14 -
 drivers/serial/jsm/jsm_tty.c                       |   19 -
 drivers/staging/serqt_usb/serqt_usb.c              |  449 +++++++-------------
 include/linux/serial_core.h                        |    3 
 include/linux/tty_driver.h                         |    3 
 21 files changed, 547 insertions(+), 638 deletions(-)

-- 
