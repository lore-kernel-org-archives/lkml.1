Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXBJGsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXBJGsk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 01:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752711AbXBJGsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 01:48:40 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:5927 "EHLO
	asav13.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXBJGsj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 01:48:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAOb5zEVKhRO4UGdsb2JhbACHIYcqAQEqki0BAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input patches for 2.6.20+
Date: Sat, 10 Feb 2007 01:48:34 -0500
User-Agent: KMail/1.9.3
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702100148.35793.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem.

Changelog:
----------
Akinobu Mita (1):
      Input: pc110pad - return proper error

Cyrill V. Gorcunov (1):
      Input: HIL - handle erros from input_register_device()

David Brownell (1):
      Input: ads7846 - be more compatible with the hwmon framework

Dmitry Torokhov (3):
      Input: i8042 - really suppress ACK/NAK during panic blink
      Input: i8042 - fix AUX IRQ delivery check

Imre Deak (5):
      Input: ads7846 - pluggable filtering logic
      Input: ads7846 - optionally leave Vref on during differential measurements
      Input: ads7846 - switch to using hrtimer
      Input: ads7846 - select correct SPI mode
      Input: ads7846 - detect pen up from GPIO state

Jaya Kumar (1):
      Input: add Atlas button driver

Jiri Slaby (2):
      Input: hid-ff - add support for Logitech Momo racing wheel
      Input: remove scan_keyb driver

Michael Leun (1):
      Input: wistron - add support for Fujitsu-Siemens Amilo D88x0

Phil Blundell (1):
      Input: gpio-keys - keyboard driver for GPIO buttons

Richard Purdie (1):
      Input: tsdev - schedule removal

Robert P. J. Day (1):
      Input: inport - use correct config option for ATIXL

Diffstat:
---------
 b/Documentation/feature-removal-schedule.txt |   15 +
 b/drivers/input/keyboard/Kconfig             |   19 +
 b/drivers/input/keyboard/Makefile            |    5 
 b/drivers/input/keyboard/gpio_keys.c         |  147 ++++++++++++
 b/drivers/input/keyboard/hilkbd.c            |  114 +++++-----
 b/drivers/input/misc/Kconfig                 |   10 
 b/drivers/input/misc/Makefile                |    1 
 b/drivers/input/misc/atlas_btns.c            |  170 +++++++++++++++
 b/drivers/input/misc/wistron_btns.c          |   20 +
 b/drivers/input/mouse/inport.c               |    2 
 b/drivers/input/mouse/pc110pad.c             |    2 
 b/drivers/input/serio/i8042.c                |    5 
 b/drivers/input/touchscreen/Kconfig          |    9 
 b/drivers/input/touchscreen/ads7846.c        |  306 +++++++++++++++++++--------
 b/drivers/input/tsdev.c                      |    4 
 b/drivers/usb/input/hid-ff.c                 |    1 
 b/drivers/usb/input/hid-lgff.c               |    1 
 b/include/asm-arm/hardware/gpio_keys.h       |   17 +
 b/include/linux/spi/ads7846.h                |    2 
 drivers/char/scan_keyb.c                     |  149 -------------
 drivers/char/scan_keyb.h                     |   15 -
 drivers/input/serio/i8042.c                  |    7 
 drivers/input/touchscreen/ads7846.c          |  275 +++++++++++++++---------
 include/linux/spi/ads7846.h                  |   10 
 24 files changed, 889 insertions(+), 417 deletions(-)


-- 
Dmitry
