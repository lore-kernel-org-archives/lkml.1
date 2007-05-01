Return-Path: <linux-kernel-owner+w=401wt.eu-S1030456AbXEAEwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030456AbXEAEwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423719AbXEAEwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:52:15 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:33432 "EHLO
	asav17.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030456AbXEAEwN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:52:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FABBkNkZKhRO4W2dsb2JhbACBeI4mKgIE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input updates for post-2.6.21
Date: Tue, 1 May 2007 00:52:09 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705010052.10009.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git

to receive updates for input subsystem.

Changelog:
----------

Andres Salomon (1):
      Input: psmouse - allow disabing certain protocol extensions

Cliff Brake (1):
      Input: ucb1400 - make delays configurable

Dmitry Torokhov (44):
      Input: psmouse - do not force stream mode
      Input: export 'uniq' in /proc/bus/input/devices
      Input: let driver core create class device attribute groups
      Input: simplify input_free_device()
      Input: i8042 - add HP Pavilion DV4017EA to the MUX blacklist
      Input: rework handle creation code
      Input: handlers - rename 'list' to 'client'
      Input: handlers - handle errors from input_open_device()
      Input: synaptics - export model bits
      Input: keyboard handler - use printk_ratelimit()
      Input: ALPS - handle errors from input_register_device()
      Input: mousedev - fix sudden warps with touchpads
      Input: i8042 - disable interfaces when switching to legacy mode
      Input: logips2pp - ignore mice reporting model as 0
      Input: gtco - handle errors from input_register_device()
      Input: logips2pp - add model 1 information
      Input: remove old USB touchscreen drivers
      Input: USB devices - handle errors when registering input devices
      Input: add input_{get|set}_drvdata() helpers
      Input: drivers/input/mice - don't access dev->private directly
      Input: drivers/input/touchscreen - don't access dev->private directly
      Input: drivers/input/joystick - don't access dev->private directly
      Input: drivers/input/keyboard - don't access dev->private directly
      Input: drivers/input/misc - don't access dev->private directly
      Input: drivers/usb/input - don't access dev->private directly
      Input: prepare to switching to struct device
      Input: keyboards - switch to using input_dev->dev.parent
      Input: USB devices - switch to using input_dev->dev.parent
      Input: mice - switch to using input_dev->dev.parent
      Input: touchscreens - switch to using input_dev->dev.parent
      Input: joysticks - switch to using input_dev->dev.parent
      Input: misc devices - switch to using input_dev->dev.parent
      Input: cobalt buttons - separate device and driver registration
      Input: lifebook - work properly on Panasonic CF-18
      Input: lifebook - activate 6-byte protocol on select models
      Input: lifebook - add signature of Panasonic CF-29
      Input: lifebook - split into 2 devices
      Input: i8042 - add Panasonic CF-29 to nomux list
      Input: i8042 - add Fujitsu touchscreen/touchpad PNP IDs
      Input: add input_set_capability() helper
      Input: update some documentation
      Input: add skeleton for simple polled devices
      Input: cobalt_btns - convert to use polldev library
      Merge master.kernel.org:/.../torvalds/linux-2.6

Eric Piel (5):
      Input: wistron - add support for TravelMate 610
      Input: wistron - add acerhk laptop database
      Input: wistron - introduce generic keymap
      Input: wistron - declare keymaps as initdata
      Input: wistron - fix typo in keymap for Acer TM610

Helge Deller (3):
      Input: HIL - various fixes for HIL drivers
      Input: HIL - cleanup coding style
      Input: HIL - fix rwlock recursion bug

Johann Deneux (1):
      Input: iforce - use usb_kill_urb instead of usb_unlink_urb

Karl Pickett (1):
      Input: ati_remote - make button repeat sensitivity configurable

Marvin Raaijmakers (1):
      Input: add getkeycode and setkeycode methods

Nicolas Ferre (1):
      Input: ads7846 - add support for the ads7843 touchscreen

Peter Osterlund (1):
      Input: sermouse - improve protocol error recovery

Peter Stokes (1):
      Input: add logical channel support for ATI Remote Wonder II

Robert P. J. Day (1):
      Input: remove no longer used power.c handler

Rodolfo Giometti (1):
      Input: add support for PXA27x keyboard controller

Roman Moravcik (1):
      Input: gpio_keys - add support for switches (EV_SW)

Stefan Lucke (1):
      Input: psmouse - add support for eGalax PS/2 touchscreen controller

Thomas Gleixner (1):
      Input: pxa27x - do not use deprecated SA_INTERRUPT flag

Yoichi Yuasa (1):
      Input: add driver for MIPS Cobalt back panel buttons

Diffstat:
---------

 Documentation/input/input-programming.txt      |  125 +++--
 arch/mips/cobalt/Makefile                      |    2 +-
 arch/mips/cobalt/buttons.c                     |   54 ++
 drivers/char/keyboard.c                        |  101 ++--
 drivers/input/Makefile                         |    1 -
 drivers/input/evbug.c                          |   32 +-
 drivers/input/evdev.c                          |  233 +++++----
 drivers/input/input.c                          |  266 +++++++---
 drivers/input/joydev.c                         |  185 ++++---
 drivers/input/joystick/a3d.c                   |    9 +-
 drivers/input/joystick/adi.c                   |    9 +-
 drivers/input/joystick/analog.c                |    9 +-
 drivers/input/joystick/cobra.c                 |    9 +-
 drivers/input/joystick/db9.c                   |    7 +-
 drivers/input/joystick/gamecon.c               |    7 +-
 drivers/input/joystick/gf2k.c                  |   10 +-
 drivers/input/joystick/grip.c                  |    9 +-
 drivers/input/joystick/grip_mp.c               |   11 +-
 drivers/input/joystick/guillemot.c             |    9 +-
 drivers/input/joystick/iforce/iforce-ff.c      |   10 +-
 drivers/input/joystick/iforce/iforce-main.c    |   26 +-
 drivers/input/joystick/iforce/iforce-packets.c |   22 +-
 drivers/input/joystick/iforce/iforce-serio.c   |    2 +-
 drivers/input/joystick/iforce/iforce-usb.c     |   13 +-
 drivers/input/joystick/iforce/iforce.h         |    2 +-
 drivers/input/joystick/interact.c              |    8 +-
 drivers/input/joystick/magellan.c              |    3 +-
 drivers/input/joystick/sidewinder.c            |    9 +-
 drivers/input/joystick/spaceball.c             |    3 +-
 drivers/input/joystick/spaceorb.c              |    3 +-
 drivers/input/joystick/stinger.c               |    3 +-
 drivers/input/joystick/tmdc.c                  |    9 +-
 drivers/input/joystick/turbografx.c            |    7 +-
 drivers/input/joystick/twidjoy.c               |    4 +-
 drivers/input/joystick/warrior.c               |    3 +-
 drivers/input/keyboard/Kconfig                 |    9 +
 drivers/input/keyboard/Makefile                |    1 +
 drivers/input/keyboard/aaed2000_kbd.c          |    9 +-
 drivers/input/keyboard/atkbd.c                 |    7 +-
 drivers/input/keyboard/corgikbd.c              |    3 +-
 drivers/input/keyboard/gpio_keys.c             |   22 +-
 drivers/input/keyboard/hil_kbd.c               |   89 ++--
 drivers/input/keyboard/hilkbd.c                |    6 +-
 drivers/input/keyboard/lkkbd.c                 |    7 +-
 drivers/input/keyboard/locomokbd.c             |    2 +-
 drivers/input/keyboard/newtonkbd.c             |    3 +-
 drivers/input/keyboard/omap-keypad.c           |    3 +-
 drivers/input/keyboard/pxa27x_keyboard.c       |  258 +++++++++
 drivers/input/keyboard/spitzkbd.c              |    3 +-
 drivers/input/keyboard/stowaway.c              |    3 +-
 drivers/input/keyboard/sunkbd.c                |    8 +-
 drivers/input/keyboard/xtkbd.c                 |    3 +-
 drivers/input/misc/Kconfig                     |   23 +-
 drivers/input/misc/Makefile                    |    2 +
 drivers/input/misc/cobalt_btns.c               |  172 ++++++
 drivers/input/misc/input-polldev.c             |  171 ++++++
 drivers/input/misc/ixp4xx-beeper.c             |   11 +-
 drivers/input/misc/m68kspkr.c                  |    2 +-
 drivers/input/misc/pcspkr.c                    |    2 +-
 drivers/input/misc/sparcspkr.c                 |    6 +-
 drivers/input/misc/uinput.c                    |   10 +-
 drivers/input/misc/wistron_btns.c              |  685 +++++++++++++++++++++---
 drivers/input/mouse/Kconfig                    |   61 ++-
 drivers/input/mouse/Makefile                   |    8 +-
 drivers/input/mouse/alps.c                     |   13 +-
 drivers/input/mouse/alps.h                     |   18 +-
 drivers/input/mouse/hil_ptr.c                  |   97 ++--
 drivers/input/mouse/lifebook.c                 |  195 ++++++-
 drivers/input/mouse/lifebook.h                 |   11 +
 drivers/input/mouse/logips2pp.c                |    7 +-
 drivers/input/mouse/logips2pp.h                |    7 +
 drivers/input/mouse/psmouse-base.c             |   50 ++-
 drivers/input/mouse/psmouse.h                  |    1 +
 drivers/input/mouse/sermouse.c                 |   19 +-
 drivers/input/mouse/synaptics.c                |  109 +++--
 drivers/input/mouse/synaptics.h                |   18 +-
 drivers/input/mouse/touchkit_ps2.c             |  100 ++++
 drivers/input/mouse/touchkit_ps2.h             |   24 +
 drivers/input/mouse/trackpoint.h               |    9 +-
 drivers/input/mouse/vsxxxaa.c                  |    3 +-
 drivers/input/mousedev.c                       |  439 +++++++++------
 drivers/input/power.c                          |  166 ------
 drivers/input/serio/hil_mlc.c                  |  505 ++++++++++--------
 drivers/input/serio/hp_sdc.c                   |  427 +++++++++-------
 drivers/input/serio/hp_sdc_mlc.c               |  227 ++++----
 drivers/input/serio/i8042-x86ia64io.h          |   24 +
 drivers/input/serio/i8042.c                    |    7 +
 drivers/input/touchscreen/ads7846.c            |   30 +-
 drivers/input/touchscreen/corgi_ts.c           |    3 +-
 drivers/input/touchscreen/elo.c                |    3 +-
 drivers/input/touchscreen/gunze.c              |    2 +-
 drivers/input/touchscreen/h3600_ts_input.c     |    9 +-
 drivers/input/touchscreen/mtouch.c             |    2 +-
 drivers/input/touchscreen/penmount.c           |    3 +-
 drivers/input/touchscreen/touchright.c         |    2 +-
 drivers/input/touchscreen/touchwin.c           |    2 +-
 drivers/input/touchscreen/ucb1400_ts.c         |   26 +-
 drivers/input/tsdev.c                          |  175 ++++---
 drivers/usb/input/Makefile                     |    5 +-
 drivers/usb/input/acecad.c                     |   28 +-
 drivers/usb/input/aiptek.c                     |   38 +-
 drivers/usb/input/appletouch.c                 |   29 +-
 drivers/usb/input/ati_remote.c                 |   42 ++-
 drivers/usb/input/ati_remote2.c                |   16 +-
 drivers/usb/input/gtco.c                       |  634 ++++++++++------------
 drivers/usb/input/itmtouch.c                   |  271 ----------
 drivers/usb/input/kbtab.c                      |   22 +-
 drivers/usb/input/keyspan_remote.c             |   29 +-
 drivers/usb/input/mtouchusb.c                  |  332 ------------
 drivers/usb/input/powermate.c                  |   27 +-
 drivers/usb/input/touchkitusb.c                |  392 --------------
 drivers/usb/input/usbtouchscreen.c             |   10 +-
 drivers/usb/input/wacom_sys.c                  |   22 +-
 drivers/usb/input/xpad.c                       |   22 +-
 drivers/usb/input/yealink.c                    |   13 +-
 include/asm-arm/arch-pxa/pxa27x_keyboard.h     |   13 +
 include/linux/gpio_keys.h                      |    3 +-
 include/linux/hp_sdc.h                         |    1 +
 include/linux/input-polldev.h                  |   46 ++
 include/linux/input.h                          |   52 +-
 120 files changed, 4334 insertions(+), 3250 deletions(-)
 create mode 100644 arch/mips/cobalt/buttons.c
 create mode 100644 drivers/input/keyboard/pxa27x_keyboard.c
 create mode 100644 drivers/input/misc/cobalt_btns.c
 create mode 100644 drivers/input/misc/input-polldev.c
 create mode 100644 drivers/input/mouse/touchkit_ps2.c
 create mode 100644 drivers/input/mouse/touchkit_ps2.h
 delete mode 100644 drivers/input/power.c
 delete mode 100644 drivers/usb/input/itmtouch.c
 delete mode 100644 drivers/usb/input/mtouchusb.c
 delete mode 100644 drivers/usb/input/touchkitusb.c
 create mode 100644 include/asm-arm/arch-pxa/pxa27x_keyboard.h
 create mode 100644 include/linux/input-polldev.h

-- 
Dmitry
