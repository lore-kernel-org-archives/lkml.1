Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbZIWEFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbZIWEFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 00:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbZIWEFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 00:05:46 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:38220 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZIWEFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 00:05:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Qw/yu5Br5zvb5nwsZXMirB/CMVxITZVxQo8dU6aWkN6iYCC8l0GTyxP8ZH73AcCq+L
         s+Ah2qtLQqPx2vXrrh5jgqFejIHb4ZQa5s6Tz5J/DZSWHTX+24swV88uKduW8JqjkDVA
         KLEwRsu3yqoS9TDne7AmD8CIl5iAXmuvtGSPk=
Date: Tue, 22 Sep 2009 21:05:43 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
Subject: [git pull] Input updates for 2.6.32-rc0
Message-ID: <20090923040543.GC1458@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
or
	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive 2nd round of updates for the input subsystem. You will get a
few new input drivers for embedded platforms and generic suspend/resume
for input devices.

Changelog:
---------

Dmitry Torokhov (6):
      Input: libps2 - additional locking for i8042 ports
      Input: add generic suspend and resume for input devices
      Input: atkbd - rely on input core to restore state on resume
      Input: synaptics_i2c - switch to using __cancel_delayed_work()
      Input: dm355evm_keys - remove dm355evm_keys_hardirq
      Input: max7359 - use threaded IRQs

Javier Herrero (1):
      Input: add driver for OpenCores Keyboard Controller

Joonyoung Shim (1):
      Input: add touchscreen driver for MELFAS MCS-5000 controller

Kim Kyuwon (1):
      Input: add driver for Maxim MAX7359 key switch controller

Michael Hennerich (2):
      Input: ad7879 - add support for AD7889
      Input: add driver for ADP5588 QWERTY I2C Keypad

Raphael Derosso Pereira (1):
      Input: add driver for Atmel AT42QT2160 Sensor Chip


Diffstat:
--------

 drivers/input/input.c                   |   64 +++++-
 drivers/input/keyboard/Kconfig          |   40 +++
 drivers/input/keyboard/Makefile         |    4 +
 drivers/input/keyboard/adp5588-keys.c   |  361 ++++++++++++++++++++++++++++
 drivers/input/keyboard/atkbd.c          |   25 --
 drivers/input/keyboard/max7359_keypad.c |  330 +++++++++++++++++++++++++
 drivers/input/keyboard/opencores-kbd.c  |  180 ++++++++++++++
 drivers/input/keyboard/qt2160.c         |  397 +++++++++++++++++++++++++++++++
 drivers/input/misc/dm355evm_keys.c      |   26 +--
 drivers/input/mouse/sentelic.c          |   18 +-
 drivers/input/mouse/synaptics_i2c.c     |   51 +++--
 drivers/input/serio/i8042.c             |   41 ++++
 drivers/input/serio/libps2.c            |   28 ++-
 drivers/input/touchscreen/Kconfig       |   17 +-
 drivers/input/touchscreen/Makefile      |    1 +
 drivers/input/touchscreen/ad7879.c      |    6 +-
 drivers/input/touchscreen/mcs5000_ts.c  |  318 +++++++++++++++++++++++++
 drivers/leds/leds-clevo-mail.c          |    8 +
 drivers/platform/x86/acer-wmi.c         |    2 +
 include/linux/i2c/adp5588.h             |   92 +++++++
 include/linux/i2c/mcs5000_ts.h          |   24 ++
 include/linux/i8042.h                   |   30 +++
 include/linux/input.h                   |    2 +-
 include/linux/libps2.h                  |    2 +
 24 files changed, 1987 insertions(+), 80 deletions(-)
 create mode 100644 drivers/input/keyboard/adp5588-keys.c
 create mode 100644 drivers/input/keyboard/max7359_keypad.c
 create mode 100644 drivers/input/keyboard/opencores-kbd.c
 create mode 100644 drivers/input/keyboard/qt2160.c
 create mode 100644 drivers/input/touchscreen/mcs5000_ts.c
 create mode 100644 include/linux/i2c/adp5588.h
 create mode 100644 include/linux/i2c/mcs5000_ts.h

-- 
Dmitry

