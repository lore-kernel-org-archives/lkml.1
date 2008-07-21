Return-Path: <linux-kernel-owner+w=401wt.eu-S932492AbYGUFOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932492AbYGUFOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760445AbYGUFOf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:14:35 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:34111 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760439AbYGUFOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:14:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:user-agent;
        b=lfwE5oltBMGNtQ/m9orc0joRgUkti4nITr9PiWfeeCP2XX36rlqeX5SpHputKo7nv/
         pE/30QxcPjkbbLpl5cS0dV9wXhphwEU1yZsNTK8McpYevpIbT6jNm8358gRXfh9zSbmz
         J5EYlI6I/qlY1CvUjRmHxRV0uBJkBbrPQFtnU=
Date: Mon, 21 Jul 2008 01:14:29 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.27-rc0
Message-ID: <20080721051428.GC14432@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
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

Adam Dawidowski (1):
      Input: fix force feedback upload issue in compat mode

Adrian Bunk (4):
      Input: remove CVS keywords
      Input: hil_mlc.c - make code static
      Input: hp_sdc_mlc.c - make a struct static
      Input: q40kbd - make q40kbd_lock static

Andres Salomon (1):
      Input: hil_ptr - check return value of input_register_device()

Carlos Corbacho (1):
      Input: i8042 - add Dritek quirk for Acer Aspire 5720

Claudio Nieder (1):
      Input: add driver for Tabletkiosk Sahara TouchIT-213 touchscreen

Daniel Ritz (1):
      Input: usbtouchscreen - ignore eGalax screens supporting HID protocol

Dmitry Baryshkov (1):
      Input: gpio-keys debouncing support

Dmitry Torokhov (10):
      HWMON: hdaps - set up phys and bus type of input device
      Input: gameport - remove rescan/reconnect facilities
      Input: libps2 - remove delayed command execution
      Input: atkbd - use ushort instead of uchar keymap
      Input: serio - remove pending events when unregistering driver
      Input: don't reset sync flag when ignoring event
      Input: evbug - identify device by its sysfs ID
      Input: atamouse - various cleanups
      Input: i8042 - add Medion NAM 2070 to noloop blacklist
      Input: i8042 - add Arima-Rioworks HDAMB board to noloop list

Eric Miao (1):
      Input: pxa27x_keypad - add wakeup support

Harvey Harrison (3):
      Input: replace remaining __FUNCTION__ occurrences
      Input: wacom - make one-bit signed bitfields unsigned
      Input: use clamp_val() macro in ff-memless.c

Helge Deller (1):
      Input: add option to disable HP SDC driver

Jiri Kosina (4):
      Input: i8042 - add Intel D845PESV to nopnp list
      Input: atkbd - fix HP 2133 not sending release event for video switch
      Input: i8042 - add Acer Aspire 1360 to nomux blacklist
      Input: i8042 - add Gericom Bellagio to nomux blacklist

Joe Perches (1):
      Input: remove unused defines

Johannes Berg (1):
      Input: appletouch - miscellaneous code cleanups

John Linn (1):
      Input: add new serio driver for Xilinx XPS PS2 IP

Julia Lawall (1):
      Input: gtco - eliminate early return

Magnus Damm (1):
      Input: add support for SuperH MigoR touchscreen

Mark Brown (2):
      Input: wm9712 - no pressure measurement with 5-wire mode
      Input: add microphone insert switch definition

Matthew Garrett (1):
      Input: add switch for dock events

Niels de Vos (1):
      Input: serio - trivial documentation fix

Oliver Neukum (1):
      Input: yealink - reliably kill urbs

Pau Oliva Fora (1):
      Input: add HTC Shift Touchscreen Driver

Ping Cheng (1):
      Input: wacom - cleanup handling of tablet IDs

Richard Lemon (1):
      Input: Add driver for iNexio serial touchscreen.

Rodney Lorrimar (2):
      Input: adbhid - fix capslock key state after suspend
      Input: adbhid - capslock and power button fix

Sven Anders (1):
      Input: appletouch - simplify touchpad type detection

Thomas Bogendoerfer (2):
      Input: new driver for SGI O2 volume buttons
      Input: sgi_btns - add support for SGI Indy volume buttons

Éric Piel (1):
      Input: wistron - generate normal key event if bluetooth or wifi not present


Diffstat:
--------

 Documentation/input/gameport-programming.txt   |    2 -
 Documentation/input/input.txt                  |    1 -
 Documentation/input/joystick-api.txt           |    2 -
 Documentation/input/joystick-parport.txt       |    1 -
 Documentation/input/joystick.txt               |    1 -
 MAINTAINERS                                    |    6 +
 drivers/char/keyboard.c                        |    2 +
 drivers/hwmon/hdaps.c                          |    2 +
 drivers/input/evbug.c                          |   12 +-
 drivers/input/evdev.c                          |  101 ++++++-
 drivers/input/ff-memless.c                     |    4 +-
 drivers/input/gameport/emu10k1-gp.c            |    2 -
 drivers/input/gameport/gameport.c              |   22 --
 drivers/input/gameport/lightning.c             |    2 -
 drivers/input/gameport/ns558.c                 |    2 -
 drivers/input/input.c                          |    2 +-
 drivers/input/joystick/a3d.c                   |    2 -
 drivers/input/joystick/amijoy.c                |    2 -
 drivers/input/joystick/cobra.c                 |    2 -
 drivers/input/joystick/db9.c                   |    2 -
 drivers/input/joystick/gf2k.c                  |    2 -
 drivers/input/joystick/grip.c                  |    2 -
 drivers/input/joystick/grip_mp.c               |    2 -
 drivers/input/joystick/guillemot.c             |    2 -
 drivers/input/joystick/iforce/iforce-ff.c      |    2 -
 drivers/input/joystick/iforce/iforce-main.c    |    2 -
 drivers/input/joystick/iforce/iforce-packets.c |    2 -
 drivers/input/joystick/iforce/iforce-serio.c   |    2 -
 drivers/input/joystick/iforce/iforce-usb.c     |    8 +-
 drivers/input/joystick/iforce/iforce.h         |    2 -
 drivers/input/joystick/interact.c              |    2 -
 drivers/input/joystick/joydump.c               |    2 -
 drivers/input/joystick/magellan.c              |    2 -
 drivers/input/joystick/spaceball.c             |    2 -
 drivers/input/joystick/spaceorb.c              |    2 -
 drivers/input/joystick/stinger.c               |    2 -
 drivers/input/joystick/tmdc.c                  |    2 -
 drivers/input/joystick/turbografx.c            |    2 -
 drivers/input/joystick/twidjoy.c               |    4 -
 drivers/input/joystick/warrior.c               |    2 -
 drivers/input/joystick/xpad.c                  |   12 +-
 drivers/input/keyboard/amikbd.c                |    2 -
 drivers/input/keyboard/atkbd.c                 |   46 +++-
 drivers/input/keyboard/gpio_keys.c             |   89 +++++--
 drivers/input/keyboard/lkkbd.c                 |    6 +-
 drivers/input/keyboard/pxa27x_keypad.c         |   15 +-
 drivers/input/keyboard/sunkbd.c                |    2 -
 drivers/input/keyboard/xtkbd.c                 |    2 -
 drivers/input/misc/Kconfig                     |   10 +
 drivers/input/misc/Makefile                    |    1 +
 drivers/input/misc/ati_remote.c                |   18 +-
 drivers/input/misc/ati_remote2.c               |   18 +-
 drivers/input/misc/keyspan_remote.c            |   20 +-
 drivers/input/misc/powermate.c                 |    6 +-
 drivers/input/misc/sgi_btns.c                  |  178 +++++++++++
 drivers/input/misc/wistron_btns.c              |   19 ++-
 drivers/input/misc/yealink.c                   |   50 ++--
 drivers/input/mouse/appletouch.c               |  299 +++++++++----------
 drivers/input/mouse/atarimouse.c               |   27 +-
 drivers/input/mouse/hil_ptr.c                  |   37 ++-
 drivers/input/mouse/inport.c                   |    2 -
 drivers/input/mouse/logibm.c                   |    2 -
 drivers/input/mouse/pc110pad.c                 |    2 -
 drivers/input/mouse/sermouse.c                 |    2 -
 drivers/input/serio/Kconfig                    |   10 +
 drivers/input/serio/Makefile                   |    1 +
 drivers/input/serio/ct82c710.c                 |    2 -
 drivers/input/serio/hil_mlc.c                  |    6 +-
 drivers/input/serio/hp_sdc.c                   |    9 +
 drivers/input/serio/hp_sdc_mlc.c               |    2 +-
 drivers/input/serio/i8042-x86ia64io.h          |   67 ++++-
 drivers/input/serio/libps2.c                   |   52 ----
 drivers/input/serio/q40kbd.c                   |    4 +-
 drivers/input/serio/rpckbd.c                   |    2 -
 drivers/input/serio/serio.c                    |    9 +-
 drivers/input/serio/xilinx_ps2.c               |  380 ++++++++++++++++++++++++
 drivers/input/tablet/acecad.c                  |    4 +-
 drivers/input/tablet/aiptek.c                  |    6 +-
 drivers/input/tablet/gtco.c                    |    2 +-
 drivers/input/tablet/kbtab.c                   |    6 +-
 drivers/input/tablet/wacom.h                   |    2 +-
 drivers/input/tablet/wacom_sys.c               |    6 +-
 drivers/input/tablet/wacom_wac.c               |   39 ++--
 drivers/input/touchscreen/Kconfig              |   46 +++
 drivers/input/touchscreen/Makefile             |    4 +
 drivers/input/touchscreen/gunze.c              |    2 -
 drivers/input/touchscreen/h3600_ts_input.c     |    2 -
 drivers/input/touchscreen/htcpen.c             |  255 ++++++++++++++++
 drivers/input/touchscreen/inexio.c             |  207 +++++++++++++
 drivers/input/touchscreen/migor_ts.c           |  250 ++++++++++++++++
 drivers/input/touchscreen/touchit213.c         |  234 +++++++++++++++
 drivers/input/touchscreen/usbtouchscreen.c     |   42 ++-
 drivers/input/touchscreen/wm9712.c             |   18 +-
 drivers/macintosh/adbhid.c                     |   61 ++++-
 include/linux/gameport.h                       |    1 -
 include/linux/gpio_keys.h                      |    1 +
 include/linux/input.h                          |    9 +-
 include/linux/joystick.h                       |    2 -
 include/linux/libps2.h                         |    1 -
 include/linux/serio.h                          |    4 +-
 100 files changed, 2283 insertions(+), 550 deletions(-)
 create mode 100644 drivers/input/misc/sgi_btns.c
 create mode 100644 drivers/input/serio/xilinx_ps2.c
 create mode 100644 drivers/input/touchscreen/htcpen.c
 create mode 100644 drivers/input/touchscreen/inexio.c
 create mode 100644 drivers/input/touchscreen/migor_ts.c
 create mode 100644 drivers/input/touchscreen/touchit213.c

-- 
Dmitry
