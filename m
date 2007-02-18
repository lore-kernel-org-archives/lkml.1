Return-Path: <linux-kernel-owner+w=401wt.eu-S1161060AbXBRHEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161060AbXBRHEv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 02:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161083AbXBRHEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 02:04:51 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:10847 "EHLO
	asav09.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161060AbXBRHEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 02:04:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAC6J10VKhRO4UGdsb2JhbACHHodKAQEqkxIBAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Input patches for 2.6.20
Date: Sun, 18 Feb 2007 02:04:48 -0500
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702180204.48643.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling from:

        git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for input subsystem.

Changelog:
----------

Cyrill V. Gorcunov (1):
      Input: HIL - fix improper call to release_region()

Dmitry Torokhov (5):
      Input: psmouse - properly reset mouse on shutdown/suspend
      Input: i8042 - let serio bus suspend ports
      Input: do not lock device when showing name, phys and uniq
      Input: hid-lgff - treat devices as joysticks unless told otherwise
      Input: remove obsolete setup parameters from input drivers

Philipp Zabel (1):
      Input: gpio-keys - switch to common GPIO API

Valentin Zagura (1):
      Input: HID - add support for Logitech Formula Force EX

Diffstat:
---------

 b/drivers/input/input.c               |   17 +---------
 b/drivers/input/joystick/amijoy.c     |    2 -
 b/drivers/input/joystick/analog.c     |    2 -
 b/drivers/input/joystick/db9.c        |    4 --
 b/drivers/input/joystick/gamecon.c    |    6 ---
 b/drivers/input/joystick/turbografx.c |    4 --
 b/drivers/input/keyboard/Kconfig      |    6 +--
 b/drivers/input/keyboard/atkbd.c      |    4 --
 b/drivers/input/keyboard/gpio_keys.c  |   15 ++++-----
 b/drivers/input/keyboard/hilkbd.c     |    2 +
 b/drivers/input/mouse/inport.c        |    2 -
 b/drivers/input/mouse/logibm.c        |    2 -
 b/drivers/input/mouse/psmouse-base.c  |    6 ---
 b/drivers/input/mouse/psmouse.h       |    1 
 b/drivers/input/mouse/synaptics.c     |    1 
 b/drivers/input/serio/i8042.c         |    7 ----
 b/drivers/input/serio/serio.c         |   36 +++++++++++++++++++++
 b/drivers/usb/input/Kconfig           |    6 +++
 b/drivers/usb/input/hid-ff.c          |    3 +
 b/drivers/usb/input/hid-lgff.c        |   10 +++---
 b/include/linux/serio.h               |    6 ---
 drivers/input/mouse/psmouse-base.c    |   28 +++++++++++++++++
 drivers/input/serio/i8042.c           |   56 +++++++++++++++++-----------------
 drivers/usb/input/hid-lgff.c          |    2 +
 24 files changed, 124 insertions(+), 104 deletions(-)

-- 
Dmitry
