Return-Path: <linux-kernel-owner+w=401wt.eu-S1751002AbZINEYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751002AbZINEYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbZINEYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:24:47 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:36161 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZINEYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:24:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=OqDmxSL7Mm0vKiWAlCLMfuR7WAIRISlTMz68R91A70RSt51LMz5KaYG77k+Iy2ONde
         7c/geKIs7iVX9aXRToPNN6us4uuo6oH0cy8+j+ACVjqSGp7YfEOLc1GkgAEbO3Z+W15y
         erq2OQ3z5HqPt/pSewAKxSaiALB9jmpPE7Ktw=
Date: Sun, 13 Sep 2009 21:24:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc0
Message-ID: <20090914042444.GA21967@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem.

Changelog:
---------

Corbin Simpson (1):
      Input: xpad - add USB ID for the drumkit controller from Rock Band

Daniel Mack (1):
      Input: eeti_ts - allow active high irq lines

David Brownell (2):
      Input: dm355evm_keys - use threaded IRQs
      Input: add twl4030_keypad driver

Dmitry Torokhov (26):
      Input: sh_keysc - allow modifying keymap from userspace
      Input: pxa27x_keypad - remove extra clk_disable
      Driver Core: Make PM operations a const pointer
      Input: i8042 - switch to using dev_pm_ops
      Input: serio - switch to using dev_pm_ops
      Input: pxa27x_keypad - switch to using dev_pm_ops
      Input: tsc2007 - properly shut off interrupts/delayed work
      Input: tsc2007 - make get_pendown_state platform callback optional
      Input: serio - don't use serio->write() directly
      Input: wistron_btns - switch to using dev_pm_ops
      Input: hil_kbd - switch to use completion instead of semaphore
      Input: hil_kbd - prepare for merging with hil_ptr
      Input: combine hil_kbd and hil_ptr drivers
      Input: w90p910_keypad - adjust to use definitions from matrix_keypad.h
      Input: psmouse - allow defining read-only attributes
      Input: matrix-keypad - add function to build device keymap
      Input: atkbd - allow setting force-release bitmap via sysfs
      Input: wacom_w8001 - simplify querying logic
      Input: i8042 - bypass AUX IRQ delivery test on laptops
      Input: sunkbd - fix formatting
      Input: pxa27x_keypad - allow modifying keymap from userspace
      Input: i8042 - try disabling and re-enabling AUX port at close
      Input: i8042 - use boolean type where it makes sense
      Input: i8042 - use platform_driver_probe
      Input: psmouse - use boolean type
      Input: wistron_btns - add keymap for AOpen 1557

Florian Echtler (1):
      Input: usbtouchscreen - add support for e2i touchscreen controller

Hans J. Koch (1):
      Input: ucb1400_ts - fix a misleading function name

Henrik Rydberg (1):
      Input: bcm5974 - silence uninitialized variables warnings

Jim Persson (1):
      Input: usbtouchscreen - support for JASTEC/DigiTech DTR-02U USB touch controllers

Julia Lawall (2):
      Input: use resource_size when allocating resources
      Input: w90p910_keypad - move a dereference below a NULL test

Marek Vasut (2):
      Input: wm97xx - add Palm support to Mainstone accelerated touch
      Input: wm97xx - add possibility to control the GPIO_STATUS shift

Michael Hennerich (1):
      Input: add Blackfin rotary input driver

Mike Frysinger (1):
      Input: bf54x-keys - convert printk() to dev_*()

Mike Rapoport (1):
      Input: gpio_keys - swtich to dev_pm_ops

Paul Fox (1):
      Input: hgpk - forced recalibration for the OLPC touchpad

Richard Röjfors (4):
      Input: tsc2007 - remove HR timer
      Input: tsc2007 - make init/exit platform hw callbacks optional
      Input: tsc2007 - do not read coordinates during probe
      Input: tsc2007 - check if I2C communication works during probe

Roel Kluin (1):
      Input: tosakbd - fix cleaning up KEY_STROBEs after error

Stephen Kitt (1):
      Input: joydev - validate axis/button maps before clobbering current ones

Tai-hwa Liang (1):
      Input: add new driver for Sentelic Finger Sensing Pad

Wan ZongShun (3):
      Input: w90p910_ts - use clk API
      Input: add keypad driver for w90p910
      Input: w90p910_keypad - rename driver name to match platform


Diffstat:
--------

 Documentation/input/sentelic.txt                   |  475 +++++++++++
 arch/arm/mach-pxa/include/mach/pxa27x_keypad.h     |    7 +-
 .../arm/mach-w90x900/include/mach/w90p910_keypad.h |   15 +
 arch/blackfin/include/asm/bfin_rotary.h            |   39 +
 drivers/base/platform.c                            |    2 +-
 drivers/base/power/main.c                          |    8 +-
 drivers/input/joydev.c                             |  106 ++-
 drivers/input/joystick/xpad.c                      |    2 +
 drivers/input/keyboard/Kconfig                     |   26 +-
 drivers/input/keyboard/Makefile                    |    2 +
 drivers/input/keyboard/atkbd.c                     |   43 +-
 drivers/input/keyboard/bf54x-keys.c                |   26 +-
 drivers/input/keyboard/gpio_keys.c                 |   19 +-
 drivers/input/keyboard/hil_kbd.c                   |  607 +++++++++-----
 drivers/input/keyboard/lkkbd.c                     |   62 +-
 drivers/input/keyboard/matrix_keypad.c             |   15 +-
 drivers/input/keyboard/pxa27x_keypad.c             |  217 +++---
 drivers/input/keyboard/sh_keysc.c                  |   22 +-
 drivers/input/keyboard/sunkbd.c                    |  142 ++--
 drivers/input/keyboard/tosakbd.c                   |   18 +-
 drivers/input/keyboard/twl4030_keypad.c            |  480 +++++++++++
 drivers/input/keyboard/w90p910_keypad.c            |  281 +++++++
 drivers/input/misc/Kconfig                         |   10 +
 drivers/input/misc/Makefile                        |    1 +
 drivers/input/misc/bfin_rotary.c                   |  283 +++++++
 drivers/input/misc/cobalt_btns.c                   |    2 +-
 drivers/input/misc/dm355evm_keys.c                 |   42 +-
 drivers/input/misc/wistron_btns.c                  |   84 ++-
 drivers/input/mouse/Kconfig                        |   16 +-
 drivers/input/mouse/Makefile                       |    2 +-
 drivers/input/mouse/alps.c                         |   20 +-
 drivers/input/mouse/alps.h                         |    4 +-
 drivers/input/mouse/bcm5974.c                      |   31 +-
 drivers/input/mouse/elantech.c                     |    2 +-
 drivers/input/mouse/elantech.h                     |    4 +-
 drivers/input/mouse/hgpk.c                         |   61 ++-
 drivers/input/mouse/hgpk.h                         |    6 +-
 drivers/input/mouse/hil_ptr.c                      |  447 ----------
 drivers/input/mouse/lifebook.c                     |    8 +-
 drivers/input/mouse/lifebook.h                     |    4 +-
 drivers/input/mouse/logips2pp.c                    |   41 +-
 drivers/input/mouse/logips2pp.h                    |    4 +-
 drivers/input/mouse/psmouse-base.c                 |  113 ++-
 drivers/input/mouse/psmouse.h                      |   30 +-
 drivers/input/mouse/sentelic.c                     |  867 ++++++++++++++++++++
 drivers/input/mouse/sentelic.h                     |   98 +++
 drivers/input/mouse/synaptics.c                    |   34 +-
 drivers/input/mouse/synaptics.h                    |    2 +-
 drivers/input/mouse/touchkit_ps2.c                 |    4 +-
 drivers/input/mouse/touchkit_ps2.h                 |    4 +-
 drivers/input/mouse/trackpoint.c                   |    2 +-
 drivers/input/mouse/trackpoint.h                   |    4 +-
 drivers/input/mouse/vsxxxaa.c                      |    8 +-
 drivers/input/serio/at32psif.c                     |    2 +-
 drivers/input/serio/i8042-x86ia64io.h              |   71 ++-
 drivers/input/serio/i8042.c                        |  242 ++++---
 drivers/input/serio/libps2.c                       |   15 +-
 drivers/input/serio/serio.c                        |   23 +-
 drivers/input/touchscreen/Kconfig                  |   16 +-
 drivers/input/touchscreen/atmel_tsadcc.c           |    8 +-
 drivers/input/touchscreen/eeti_ts.c                |   22 +-
 drivers/input/touchscreen/h3600_ts_input.c         |    9 +-
 drivers/input/touchscreen/mainstone-wm97xx.c       |   53 +-
 drivers/input/touchscreen/tsc2007.c                |  264 +++---
 drivers/input/touchscreen/ucb1400_ts.c             |    5 +-
 drivers/input/touchscreen/usbtouchscreen.c         |   81 ++
 drivers/input/touchscreen/w90p910_ts.c             |   34 +-
 drivers/input/touchscreen/wacom_w8001.c            |  121 +--
 drivers/input/touchscreen/wm97xx-core.c            |    6 +-
 drivers/pci/pci-driver.c                           |   16 +-
 include/linux/device.h                             |    9 +-
 include/linux/i2c/twl4030.h                        |   19 +-
 include/linux/input/eeti_ts.h                      |    9 +
 include/linux/input/matrix_keypad.h                |   32 +
 include/linux/libps2.h                             |    1 +
 include/linux/serio.h                              |    2 -
 include/linux/wm97xx.h                             |    7 +
 77 files changed, 4347 insertions(+), 1572 deletions(-)
 create mode 100644 Documentation/input/sentelic.txt
 create mode 100644 arch/arm/mach-w90x900/include/mach/w90p910_keypad.h
 create mode 100644 arch/blackfin/include/asm/bfin_rotary.h
 create mode 100644 drivers/input/keyboard/twl4030_keypad.c
 create mode 100644 drivers/input/keyboard/w90p910_keypad.c
 create mode 100644 drivers/input/misc/bfin_rotary.c
 delete mode 100644 drivers/input/mouse/hil_ptr.c
 create mode 100644 drivers/input/mouse/sentelic.c
 create mode 100644 drivers/input/mouse/sentelic.h
 create mode 100644 include/linux/input/eeti_ts.h

-- 
Dmitry

