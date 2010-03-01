Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296Ab0CAIDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:03:50 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:39565 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0CAIDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:03:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=D9so3PEXzj4QvFT6kJkIhZKgYZaWnxLwMgY4B+H7MHeySHjNga8XcbmsNgqDEOaE9O
         +zU6mWyxXowaPxFBmP1NLnjDxxsI5+zLQNJkaYONC/3GHyAIq73gKy2rFnMcy42RSQv9
         Ih8nWCCkf/69z0xSN1X3HHlCJepID/mrWMuYc=
Date: Mon, 1 Mar 2010 00:03:43 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.34-rc0
Message-ID: <20100301080342.GH765@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive first round of updates for the input subsystem.

Changelog:
---------

Alberto Panizzo (1):
      Input: add imx-keypad driver to support the IMX Keypad Port

Andrew Clayton (1):
      Input: rotary-encoder - set gpio direction for each requested gpio

Bastian Blank (1):
      Input: wacom - get features from driver info

Benjamin Valentin (1):
      Input: xpad - add rumble support for original xbox controller

David Härdeman (1):
      Input: winbond-cir - fix suspend/resume

Dmitry Torokhov (26):
      Input: serio - use device core to create 'id' attribute group
      Input: serio - let device core tell us if device was registered
      Input: serio - use list_first_entry() helper
      Input: serio - use pr_xxx() and dev_xxx() helpers
      Input: gameport - let device core tell us if device was registered
      Input: gameport - make use of list_first_entry() helper
      Input: gameport - switch to using pr_xxx() and dev_xxx()
      Input: automatically reset KEY_RESERVED bit for all input devices
      Input: cleanse capabilities bits before registering device
      Input: psmouse - remove unused 'autocal' parameter from hgpk protocol
      Input: atkbd - switch to dev_err() and friends
      Input: elo - switch to using dev_xxx() when printing messages
      Input: implement input filters
      Input: Mac button emulation - implement as an input filter
      Input: Mac button emulation  - allow compiling as a module
      Input: add match() method to input hanlders
      Input: uinput - mark as non-seekable
      Input: mark input interfaces as non-seekable
      Input: wacom - constify product features data
      Input: gamecon - fix some formatting issues
      Input: gamecon - simplify coordinate calculation for PSX
      Input: gamecon - simplify pad type handling
      Input: gamecon - constify some of the setup structures
      Input: gamecon - use pr_err() and friends
      Input: add KEY_WPS_BUTTON definition
      Input: atkbd - release previously reserved keycodes 248 - 254

Eric Miao (2):
      Input: mark {corgi,spitz,tosa}kbd drivers deprecated
      Input: schedule corgi_ssp and corgi_ts to be removed

Grazvydas Ignotas (1):
      Input: ads7846 - add regulator support

H Hartley Sweeten (1):
      Input: ep93xx_keypad - cleanup and use matrix_keypad helpers

Jason Childs (1):
      Input: wacom - use per-device instance of wacom_features

Magnus Damm (5):
      Input: sh_keysc - add mode 4 and mode 5 support
      Input: sh_keysc - factor out hw access functions
      Input: sh_keysc - switch to using bitmaps
      Input: sh_keysc - update the driver with mode 6
      Input: sh_keysc - enable building on SH-Mobile ARM

Mark Brown (1):
      Input: wm97xx - provide coordinate logs for accelerated I/O

Michael Hennerich (1):
      Input: ADP5588 - add support for ADP5587 devices

Mika Westerberg (1):
      Input: gpio-keys - add support for disabling gpios through sysfs

Márton Németh (6):
      Input: make i2c device ids constant
      Input: xilinx_ps2 - make Open Firmware device ids constant
      Input: make PCI device ids constant
      Input: ns558 - make pnp device ids constant
      Input: xen-kbdfront - make xenbus device ids constant
      Input: make USB device ids constant

Nicolas Léveillé (1):
      Input: xpad - allow using triggers as buttons rather than axes

Ondrej Zary (4):
      Input: usbtouchscreen - convert from usb_device to usb_interface
      Input: usbtouchscreen - find input endpoint automatically
      Input: usbtouchscreen - add NEXIO (or iNexio) support
      Input: usbtouchscreen - fix leaks and check return value of usb_submit_urb()

Ping Cheng (1):
      Input: wacom - add device type to device name string

Scott Moreau (1):
      Input: gamecon - add rumble support for N64 pads

Tai-hwa Liang (1):
      Input: update Sentelic protocol documentation

Thadeu Lima de Souza Cascardo (1):
      Input: uinput - remove BKL from uinput_open function

Tobias Klauser (1):
      Input: xilinx_ps2 - use resource_size

Vasily Khoruzhick (2):
      Input: s3c24xx_ts - re-enable IRQ on resume
      Input: s3c24xx_ts - report touch only when stylus is down


Diffstat:
--------

 Documentation/feature-removal-schedule.txt        |   23 +
 Documentation/input/sentelic.txt                  |  124 ++++-
 arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h |   14 +-
 drivers/char/keyboard.c                           |   29 +-
 drivers/input/evdev.c                             |    2 +
 drivers/input/gameport/emu10k1-gp.c               |    2 +-
 drivers/input/gameport/fm801-gp.c                 |    2 +-
 drivers/input/gameport/gameport.c                 |   98 ++--
 drivers/input/gameport/ns558.c                    |    2 +-
 drivers/input/input.c                             |   90 +++-
 drivers/input/joydev.c                            |   34 +-
 drivers/input/joystick/Kconfig                    |    1 +
 drivers/input/joystick/gamecon.c                  |  664 ++++++++++++++-------
 drivers/input/joystick/xpad.c                     |  253 +++++---
 drivers/input/keyboard/Kconfig                    |   33 +-
 drivers/input/keyboard/Makefile                   |    1 +
 drivers/input/keyboard/adp5588-keys.c             |    6 +-
 drivers/input/keyboard/atkbd.c                    |  309 +++++-----
 drivers/input/keyboard/ep93xx_keypad.c            |   40 +-
 drivers/input/keyboard/gpio_keys.c                |  318 ++++++++++-
 drivers/input/keyboard/imx_keypad.c               |  594 ++++++++++++++++++
 drivers/input/keyboard/qt2160.c                   |    2 +-
 drivers/input/keyboard/sh_keysc.c                 |  145 +++--
 drivers/input/misc/apanel.c                       |    2 +-
 drivers/input/misc/rotary_encoder.c               |   14 +
 drivers/input/misc/uinput.c                       |    4 +-
 drivers/input/misc/winbond-cir.c                  |  213 ++++----
 drivers/input/mouse/hgpk.c                        |    4 -
 drivers/input/serio/pcips2.c                      |    2 +-
 drivers/input/serio/serio.c                       |  131 ++---
 drivers/input/serio/xilinx_ps2.c                  |    6 +-
 drivers/input/tablet/gtco.c                       |    2 +-
 drivers/input/tablet/wacom.h                      |    5 +-
 drivers/input/tablet/wacom_sys.c                  |   70 ++-
 drivers/input/tablet/wacom_wac.c                  |  408 +++++++------
 drivers/input/tablet/wacom_wac.h                  |   17 +-
 drivers/input/touchscreen/Kconfig                 |    6 +-
 drivers/input/touchscreen/ads7846.c               |   28 +-
 drivers/input/touchscreen/elo.c                   |  225 ++++----
 drivers/input/touchscreen/mainstone-wm97xx.c      |    3 +
 drivers/input/touchscreen/s3c2410_ts.c            |   31 +-
 drivers/input/touchscreen/tsc2007.c               |    2 +-
 drivers/input/touchscreen/usbtouchscreen.c        |  317 +++++++++-
 drivers/input/touchscreen/zylonite-wm97xx.c       |    3 +
 drivers/input/xen-kbdfront.c                      |    2 +-
 drivers/macintosh/Kconfig                         |    7 +-
 drivers/macintosh/mac_hid.c                       |  266 ++++++---
 include/linux/gameport.h                          |    1 -
 include/linux/gpio_keys.h                         |    1 +
 include/linux/input.h                             |   17 +-
 include/linux/input/sh_keysc.h                    |    7 +-
 include/linux/kbd_kern.h                          |    3 -
 include/linux/serio.h                             |    1 -
 53 files changed, 3250 insertions(+), 1334 deletions(-)
 create mode 100644 drivers/input/keyboard/imx_keypad.c

-- 
Dmitry

