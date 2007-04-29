Return-Path: <linux-kernel-owner+w=401wt.eu-S1161497AbXD2Wvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161497AbXD2Wvj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161521AbXD2Wvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:51:39 -0400
Received: from styx.suse.cz ([82.119.242.94]:37218 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161497AbXD2Wvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:51:38 -0400
Date: Mon, 30 Apr 2007 00:52:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID and USB HID updates for 2.6.22 merge window
Message-ID: <Pine.LNX.4.64.0704292348550.7370@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive 2.6.22 merge window updates for HID core layer and  USB HID layer. 
The patches have been in -mm for quite some time.

 drivers/hid/Kconfig                           |    2 +
 drivers/hid/Makefile                          |    4 +
 drivers/hid/hid-core.c                        |    9 +-
 drivers/hid/hid-input.c                       |   27 +-
 drivers/hid/usbhid/Kconfig                    |  149 +++
 drivers/hid/usbhid/Makefile                   |   35 +
 drivers/hid/usbhid/hid-core.c                 | 1114 +++++++++++++++++++
 drivers/{usb/input => hid/usbhid}/hid-ff.c    |    2 +
 drivers/{usb/input => hid/usbhid}/hid-lgff.c  |    1 +
 drivers/{usb/input => hid/usbhid}/hid-pidff.c |    0 
 drivers/{usb/input => hid/usbhid}/hid-plff.c  |    0 
 drivers/hid/usbhid/hid-quirks.c               |  681 ++++++++++++
 drivers/{usb/input => hid/usbhid}/hid-tmff.c  |    0 
 drivers/{usb/input => hid/usbhid}/hid-zpff.c  |    0 
 drivers/{usb/input => hid/usbhid}/hiddev.c    |    0 
 drivers/{usb/input => hid/usbhid}/usbhid.h    |    0 
 drivers/{usb/input => hid/usbhid}/usbkbd.c    |   13 +-
 drivers/{usb/input => hid/usbhid}/usbmouse.c  |   15 +-
 drivers/usb/Makefile                          |    3 -
 drivers/usb/input/Kconfig                     |  145 ---
 drivers/usb/input/Makefile                    |   28 -
 drivers/usb/input/hid-core.c                  | 1477 -------------------------
 include/linux/hid.h                           |   14 +-
 23 files changed, 2054 insertions(+), 1665 deletions(-)

Alan Stern (1):
      USB HID: fix retry & reset logic

Chris Clayton (1):
      HID: enable dead keys on a belkin wireless keyboard

Daniel P. Engel (1):
      USB HID: add QUIRK_HIDDEV for Belkin Flip KVM

Dmitry Torokhov (1):
      USB HID: usbkbd/usbmouse - handle errors when registering devices

Jiri Kosina (7):
      USB HID: move usbhid code from drivers/usb/input to drivers/hid/usbhid
      USB HID: consolidate vendor/product ids
      USB HID: extend quirk for Logitech S510 keyboard
      USB HID: Logitech MX3000 keyboard needs report descriptor quirk
      USB HID: add FF support for Logitech Force 3D Pro Joystick
      HID: update copyright and authorship macro
      USB HID: don't warn on idVendor == 0

Paul Walmsley (5):
      USB HID: specify explicit size for hid_blacklist.quirks
      USB HID: encapsulate quirk handling into hid-quirks.c
      USB HID: clarify static quirk handling as squirks
      USB HID: add support for dynamically-created quirks
      USB HID: add 'quirks' module parameter

Paul Zaremba (1):
      USB HID: EMS USBII device needs HID_QUIRK_MULTI_INPUT

Pete Zaitcev (1):
      USB HID: numlock quirk for dell W7658 keyboard

Ronny Peine (1):
      USB HID: Thustmaster firestorm dual power v1 support

Sam Liddicott (1):
      USB HID: add support for WiseGroup MP-8800 Quad Joypad

Simon Budig (1):
      HID: introduce proper zeroing of unused bits in output reports
