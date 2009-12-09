Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbZLIRYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbZLIRYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:24:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbZLIRYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:24:10 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:62915 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861AbZLIRYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:24:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=qA+kZ+4SCRLlCcpgvFLvSUrKbPfnxmZY+nYbwMylgz3U4f3DuDtMgHMLZ+DzH/0PAl
         bp4jW4uXXWEGJwMZI3fVcYwJ+OMTw4stoF2zg3ITa2DEVAACSdUj3KKIZ71gwUeb2Rko
         IudpqW2Yg8qh7V+nD3EJ2nJAzMZVaVDb+zwbY=
Date: Wed, 9 Dec 2009 09:17:29 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.33-rc0
Message-ID: <20091209171729.GA4456@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

Alan Jenkins (1):
      Input: keyboard - fix theoretical race on vt switch

Arnaud Patard (1):
      Input: add S3C24XX touchscreen driver

Ben Dooks (3):
      Input: gpio_keys - use dev_ macros to report information
      Input: gpio_keys - use <linux/gpio.h> instead of <asm/gpio.h>
      Input: gpio_keys - seperate individual button setup to make code neater

Daniel Mack (1):
      Input: gpio_keys - scan gpio state at probe and resume time

Daniel Silverstone (1):
      Input: usbtouchscreen - add support for Zytronic capacitive touchscreen

Dmitry Torokhov (22):
      Input: lkkbd - change formatting style to match the rest of the kernel
      Input: vsxxxaa - change formatting style to match the rest of the kernel
      Input: mark custom_data in ff_periodic_effect as __user
      Input: synaptic_i2c - make unnecessarily global functions static
      Input: input-polldev, matrix-keypad - include in kernel doc
      Input: touchkit_ps2 - do not advertise unsupported buttons
      Input: elantech - do not advertise relative events
      Input: lifebook - do not advertise unsupported buttons
      Input: psmouse - rework setting of BTN_MIDDLE capability
      Input: polled device - schedule first poll immediately
      Input: keyboard - add locking around event handling
      Input: keyboard - fix lack of locking when traversing handler->h_list
      Input: matrix-keypad - switch to using dev_pm_ops
      Input: psmouse - do not carry DMI data around
      DMI: allow omitting ident strings in DMI tables
      Input: i8042 - remove identification strings from DMI tables
      Input: atkbd - remove identification strings from DMI table
      Input: psmouse - remove identification strings from DMI tables
      Input: wistron - remove identification strings from DMI table
      Input: add generic support for sparse keymaps
      Input: wistron_btns - switch to using sparse keymap library
      Input: dm355evm_kbd - switch to using sparse keymap library

Jani Nikula (1):
      Input: add new keycodes useful in mobile devices

Jari Vanhala (1):
      Input: fix memory leak in force feedback core

Johannes Berg (1):
      Input: appletouch - give up maintainership

Marek Vasut (1):
      Input: ucb1400_ts - allow passing IRQ through platfrom_data

Maxim Levitsky (1):
      Input: ALPS - add support for touchpads with 4-directional button

Miguel Aguilar (1):
      Input: add DaVinci Keypad Driver

Márton Németh (1):
      Input: do not overwrite the first part of phys string

Nicolas Ferre (4):
      Input: atmel_tsadcc - rework setting touchscreen capabilities
      Input: atmel_tsadcc - use platform parameters
      AT91: add platform parameters for atmel_tsadcc in at91sam9rlek
      AT91: add touchscreen support for at91sam9g45ekes

Nicolas Léveillé (1):
      Input: xpad - add two new Xbox 360 devices

Oliver Neukum (1):
      Input: usbtouchscreen - remove unneeded usb_kill_urb

Pavel Machek (2):
      Input: ads7846 - fix pressure reporting
      Input: ads7846 - switch to using dev_vdbg()

Petr Štetiar (1):
      Input: usbtouchscreen - add support for ET&T TC5UH touchscreen controller

Roger Quadros (1):
      Input: force feedback - fix function name in comment

Samu Onkalo (3):
      Input: add open and close methods for polled devices
      Input: input-polldev - add sysfs interface for controlling poll interval
      Input: polled device - do not start polling if interval is zero

Thomas Chou (1):
      Input: add driver for Altera PS/2 controller

Tias Guns (1):
      Input: add driver for Dynapro serial touchscreen


Diffstat:
--------

 Documentation/DocBook/device-drivers.tmpl    |   13 +
 MAINTAINERS                                  |    7 -
 arch/arm/mach-at91/at91sam9g45_devices.c     |   51 +++
 arch/arm/mach-at91/at91sam9rl_devices.c      |   10 +-
 arch/arm/mach-at91/board-sam9m10g45ek.c      |   12 +
 arch/arm/mach-at91/board-sam9rlek.c          |   12 +-
 arch/arm/mach-at91/include/mach/board.h      |    7 +-
 arch/arm/mach-davinci/include/mach/keyscan.h |   41 +++
 drivers/char/keyboard.c                      |  213 ++++++-----
 drivers/firmware/dmi_scan.c                  |   15 +-
 drivers/hid/usbhid/usbkbd.c                  |    2 +-
 drivers/input/Kconfig                        |   28 +-
 drivers/input/Makefile                       |    1 +
 drivers/input/ff-core.c                      |    3 +-
 drivers/input/input-polldev.c                |  137 +++++++-
 drivers/input/input.c                        |   37 ++-
 drivers/input/joystick/xpad.c                |    3 +
 drivers/input/keyboard/Kconfig               |   10 +
 drivers/input/keyboard/Makefile              |    1 +
 drivers/input/keyboard/atkbd.c               |   26 +-
 drivers/input/keyboard/davinci_keyscan.c     |  337 +++++++++++++++++
 drivers/input/keyboard/gpio_keys.c           |  134 +++++---
 drivers/input/keyboard/lkkbd.c               |  496 ++++++++++++-------------
 drivers/input/keyboard/matrix_keypad.c       |   17 +-
 drivers/input/misc/Kconfig                   |    2 +
 drivers/input/misc/ati_remote.c              |    2 +-
 drivers/input/misc/dm355evm_keys.c           |  150 +++-----
 drivers/input/misc/powermate.c               |    2 +-
 drivers/input/misc/wistron_btns.c            |  256 +++++---------
 drivers/input/mouse/alps.c                   |  100 ++++--
 drivers/input/mouse/elantech.c               |    1 +
 drivers/input/mouse/hgpk.c                   |   13 -
 drivers/input/mouse/lifebook.c               |   55 ++--
 drivers/input/mouse/lifebook.h               |    4 +
 drivers/input/mouse/logips2pp.c              |    4 +-
 drivers/input/mouse/psmouse-base.c           |   41 ++-
 drivers/input/mouse/sentelic.c               |    1 +
 drivers/input/mouse/synaptics.c              |   31 +-
 drivers/input/mouse/synaptics.h              |    1 +
 drivers/input/mouse/synaptics_i2c.c          |    6 +-
 drivers/input/mouse/touchkit_ps2.c           |    3 +-
 drivers/input/mouse/trackpoint.c             |   13 +-
 drivers/input/mouse/vsxxxaa.c                |  374 +++++++++-----------
 drivers/input/serio/Kconfig                  |    8 +
 drivers/input/serio/Makefile                 |    1 +
 drivers/input/serio/altera_ps2.c             |  200 +++++++++++
 drivers/input/serio/i8042-x86ia64io.h        |  143 ++++----
 drivers/input/sparse-keymap.c                |  250 +++++++++++++
 drivers/input/touchscreen/Kconfig            |   37 ++-
 drivers/input/touchscreen/Makefile           |    4 +-
 drivers/input/touchscreen/ads7846.c          |   25 +-
 drivers/input/touchscreen/atmel_tsadcc.c     |   47 ++-
 drivers/input/touchscreen/dynapro.c          |  206 +++++++++++
 drivers/input/touchscreen/s3c2410_ts.c       |  457 ++++++++++++++++++++++++
 drivers/input/touchscreen/ucb1400_ts.c       |   11 +-
 drivers/input/touchscreen/usbtouchscreen.c   |  104 ++++++-
 drivers/mfd/ucb1400_core.c                   |    7 +
 include/linux/input-polldev.h                |   22 +-
 include/linux/input.h                        |   13 +-
 include/linux/input/matrix_keypad.h          |    3 +
 include/linux/input/sparse-keymap.h          |   62 ++++
 include/linux/serio.h                        |    1 +
 include/linux/ucb1400.h                      |    4 +
 63 files changed, 3110 insertions(+), 1167 deletions(-)
 create mode 100644 arch/arm/mach-davinci/include/mach/keyscan.h
 create mode 100644 drivers/input/keyboard/davinci_keyscan.c
 create mode 100644 drivers/input/serio/altera_ps2.c
 create mode 100644 drivers/input/sparse-keymap.c
 create mode 100644 drivers/input/touchscreen/dynapro.c
 create mode 100644 drivers/input/touchscreen/s3c2410_ts.c
 create mode 100644 include/linux/input/sparse-keymap.h

-- 
Dmitry

