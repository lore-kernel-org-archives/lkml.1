Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXEKQgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXEKQgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760202AbXEKQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:36:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:55491 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760145AbXEKQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:36:19 -0400
Date: Fri, 11 May 2007 18:38:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID and USB HID updates for 2.6.22 merge window
Message-ID: <Pine.LNX.4.64.0705111835130.11493@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'upstream-fixes' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

or
        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git upstream-fixes

to receive 2.6.22 merge window fixes for HID layer.

 drivers/hid/hid-input.c         |  101 +++++++++++++++++++++++++++++++++++++--
 drivers/hid/usbhid/Kconfig      |    4 +-
 drivers/hid/usbhid/hid-core.c   |   41 ++++++++++++----
 drivers/hid/usbhid/hid-lgff.c   |    2 +-
 drivers/hid/usbhid/hid-plff.c   |    2 +-
 drivers/hid/usbhid/hid-quirks.c |    7 +++
 drivers/hid/usbhid/hid-tmff.c   |    2 +-
 drivers/hid/usbhid/hid-zpff.c   |    2 +-
 drivers/hid/usbhid/hiddev.c     |   14 +++++
 drivers/hid/usbhid/usbkbd.c     |   21 ++++-----
 drivers/hid/usbhid/usbmouse.c   |    9 ++--
 include/linux/hid.h             |    1 +
 net/bluetooth/hidp/core.c       |    4 +-
 13 files changed, 171 insertions(+), 39 deletions(-)

Charles Pillar (1):
      HID: add input mappings for non-working keys on Logitech S510 remote

Dmitry Torokhov (2):
      USB HID: usb_buffer_free() cleanup
      HID: switch to using input_dev->dev.parent

Jan Kratochvil (1):
      USB HID: Logitech wheel 0x046d/0xc294 needs HID_QUIRK_NOGET quirk

Jiri Kosina (3):
      Bluetooth HID: HIDP - don't initialize force feedback
      USB HID: report descriptor of Cypress USB barcode readers needs fixup
      USB HID: hiddev - fix race between hiddev_send_event() and hiddev_release()

Marvin Raaijmakers (1):
      HID: add hooks for getkeycode() and setkeycode() methods

Noel Kothe (1):
      USB HID: update CONFIG_USB_HIDINPUT_POWERBOOK description

