Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXGJFCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXGJFCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 01:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXGJFCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 01:02:14 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:30422 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbXGJFCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 01:02:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPAPCukkZKhRO4R2dsb2JhbACPKQEBGw0GEQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for post-2.6.22
Date: Tue, 10 Jul 2007 01:02:06 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707100102.06803.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Let's see if I manage to create pull request that can be cut-n-pasted...]


Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or

	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem.

Changelog:
---------

Adrian Bunk (1):
      Input: xpad - make xpad_play_effect() static

Andi Drebes (1):
      Input: grip-mp - use ARRAY_SIZE

Andrew Morton (2):
      Input: serio_raw - shut up errorneous warning
      Input: tsdev - fix broken usec-to-millisecs conversion

Aristeu Rozanski (1):
      Input: psmouse - add support for Cortron PS/2 Trackballs

Dmitry Torokhov (12):
      Input: aiptek - do not try to export associated event device
      Input: aiptek - remove vendor and product attributes from sysfs
      Input: aiptek - use attribute group
      Input: aiptek - do not check for NULL in attribute methods
      Input: aiptek - use maps in attributes
      Input: aiptek - kill aiptek_convert_from_2s_complement()
      Input: aiptek - use array to list all buttons
      Input: wistron - convert to use input-polldev
      Input: wistron - add support for querying/changing keymap
      Input: convert from class devices to standard devices
      Input: xpad - fix report for dpad and inverted Y and RY axes on xbox 360
      Input: ppc-beep - switch to using input_dev->dev.parent

Eric Piel (2):
      Input: wriston - reduce polling frequency
      Input: wistron - add LED support

Hans de Goede (1):
      Input: atkbd - change mapping for e032 from KEY_WWW to KEY_HOMEPAGE

Hans-Christian Egtvedt (1):
      Input: add gpio-mouse driver

Jan Kratochvil (4):
      USB: Add USB_DEVICE_INTERFACE_PROTOCOL macro
      Input: xpad - add support for Xbox 360 gamepad
      Input: xpad - add Xbox360 gamepad rumble support
      Input: xpad - fix check for succesful usb_buffer_alloc

Mark Vytlacil (1):
      Input: aiptek - fix relative mode parsing

Mike Rapoport (1):
      Input: pxa27x_keyboard - fix compile error

Ondrej Zary (1):
      Input: usbtouchscreen - add support for IRTOUCHSYSTEMS touchscreens

Ping Cheng (1):
      Input: wacom - add support for the new Bamboo tablets

Rene van Paassen (10):
      Input: aiptek - correct documentation on reports
      Input: aiptek - correct the proximity and validity checks
      Input: aiptek - fixed mouse button defines
      Input: aiptek - use set_bit instead of bitwise or
      Input: aiptek - put sensible warnings in probe
      Input: aiptek - use only absolute misc reports
      Input: aiptek - correct the tool switching code
      Input: aiptek - tolerate newlines in sysfs files
      Input: aiptek - rework the function key code
      Input: aiptek - update driver version

Robert P. J. Day (1):
      Input: update MAINTAINERS to explicitly mention touchscreens

Diffstat:
--------

 MAINTAINERS                                |    2 +-
 drivers/char/keyboard.c                    |    4 +-
 drivers/input/evdev.c                      |   84 ++--
 drivers/input/input.c                      |  136 ++--
 drivers/input/joydev.c                     |   84 ++--
 drivers/input/joystick/Kconfig             |    7 +
 drivers/input/joystick/grip_mp.c           |    4 +-
 drivers/input/joystick/xpad.c              |  281 +++++++--
 drivers/input/keyboard/atkbd.c             |    4 +-
 drivers/input/keyboard/pxa27x_keyboard.c   |    2 +-
 drivers/input/misc/Kconfig                 |    6 +-
 drivers/input/misc/wistron_btns.c          |  359 +++++++---
 drivers/input/mouse/Kconfig                |   16 +
 drivers/input/mouse/Makefile               |    1 +
 drivers/input/mouse/gpio_mouse.c           |  196 ++++++
 drivers/input/mouse/psmouse-base.c         |   29 +
 drivers/input/mouse/psmouse.h              |    1 +
 drivers/input/mousedev.c                   |  242 ++++---
 drivers/input/serio/serio_raw.c            |    2 +-
 drivers/input/tablet/aiptek.c              |  991 ++++++++++------------------
 drivers/input/tablet/wacom.h               |    8 +-
 drivers/input/tablet/wacom_sys.c           |    6 +
 drivers/input/tablet/wacom_wac.c           |   47 ++-
 drivers/input/tablet/wacom_wac.h           |    1 +
 drivers/input/touchscreen/Kconfig          |    6 +
 drivers/input/touchscreen/usbtouchscreen.c |   33 +
 drivers/input/tsdev.c                      |   90 ++--
 include/linux/gpio_mouse.h                 |   61 ++
 include/linux/input.h                      |   20 +-
 include/linux/usb.h                        |   16 +
 sound/ppc/beep.c                           |   10 +-
 31 files changed, 1618 insertions(+), 1131 deletions(-)
 create mode 100644 drivers/input/mouse/gpio_mouse.c
 create mode 100644 include/linux/gpio_mouse.h


-- 
Dmitry
