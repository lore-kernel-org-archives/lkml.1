Return-Path: <linux-kernel-owner+w=401wt.eu-S1757875AbXJNOA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875AbXJNOA3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 10:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756326AbXJNOAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 10:00:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:44765 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756273AbXJNOAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 10:00:20 -0400
Date: Sun, 14 Oct 2007 16:00:10 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID updates for 2.6.24
Message-ID: <Pine.LNX.4.64.0710141557310.20620@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID code for 2.6.24.

 drivers/hid/Kconfig             |   19 ++
 drivers/hid/Makefile            |    2 +
 drivers/hid/hid-core.c          |   16 ++
 drivers/hid/hid-debug.c         |   40 ++--
 drivers/hid/hid-input.c         |   92 ++++++++-
 drivers/hid/hidraw.c            |  401 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/Kconfig      |   11 +-
 drivers/hid/usbhid/hid-core.c   |   54 +++++-
 drivers/hid/usbhid/hid-ff.c     |    5 +-
 drivers/hid/usbhid/hid-plff.c   |   24 ++-
 drivers/hid/usbhid/hid-quirks.c |   33 ++++
 drivers/hid/usbhid/hid-tmff.c   |  161 ++++++++++++----
 drivers/hid/usbhid/hiddev.c     |   12 ++
 include/linux/hid.h             |    7 +
 include/linux/hidraw.h          |   86 +++++++++
 include/linux/input.h           |    2 +
 16 files changed, 877 insertions(+), 88 deletions(-)

Alfred E. Heggestad (1):
      USBHID: add CM109 device to blacklist

Anssi Hannula (1):
      HID: use hid-plff driver for GreenAsia 0e8f:0003 devices

Dmitry Torokhov (1):
      HID: add support for Thrustmaster FGT Force Feedback wheel

Ilya Frolov (1):
      HID: Add GeneralTouch touchscreen to the blacklist

Jiri Kosina (8):
      USB HID: provide hook for hidraw write()
      HID: add hidraw interface
      Input: add KEY_SPELLCHECK
      HID: add support for Microsoft Natural Ergonomic Keyboard 4000
      HID: fix whitespace damage
      HID: ignore all non-LED usages in output fields in hid-input
      HID: Report usage codes of keys as EV_MSC scancode events
      HID: fix input mapping for Microsoft Ergonomic Keyboard

Joe Perches (1):
      HID: trivial fixes in hid-debug

Khelben Blackstaff (2):
      Input: add KEY_LOGOFF
      HID: add support for Microsoft Wireless Laser Keyboard 6000

Mariusz Kozlowski (1):
      HID: hidraw_connect() memleak fix

Mike Crowe (1):
      USBHID: Add HID_QUIRK_NOGET for ELO Touch Screen 2700 display

Oliver Neukum (1):
      HID: minimal autosuspend support for USB HID devices

Philip Langdale (1):
      HID: hiddev: Add 32bit ioctl compatibilty

Stelian Pop (1):
      HID: enable hiddev for the SantaRosa MacBookPro IR receiver

Tomoya Adachi (1):
      USBHID: report descriptor fix for MacBook JIS keyboard

