Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbYDVNKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbYDVNKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763265AbYDVNJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:09:40 -0400
Received: from styx.suse.cz ([82.119.242.94]:48349 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763229AbYDVNJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:09:37 -0400
Date: Tue, 22 Apr 2008 15:09:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID patches for 2.6.26 merge window
Message-ID: <Pine.LNX.4.64.0804221159580.12972@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive patches for HID code that are intended for 2.6.26 merge window.
They have been in -mm and linux-next for some time.

 drivers/hid/hid-core.c          |   19 ++-
 drivers/hid/hid-debug.c         |    2 +-
 drivers/hid/hid-input-quirks.c  |   24 +++-
 drivers/hid/usbhid/Kconfig      |   12 ++-
 drivers/hid/usbhid/Makefile     |    3 +
 drivers/hid/usbhid/hid-core.c   |   69 ++++++----
 drivers/hid/usbhid/hid-ff.c     |    3 +
 drivers/hid/usbhid/hid-lg2ff.c  |  114 ++++++++++++++++
 drivers/hid/usbhid/hid-quirks.c |   85 ++++++++----
 drivers/hid/usbhid/hiddev.c     |  286 ++++++++++++++++++++-------------------
 drivers/hid/usbhid/usbhid.h     |    3 +-
 include/linux/Kbuild            |    2 +
 include/linux/hid.h             |   17 ++-
 include/linux/hidraw.h          |    1 +
 14 files changed, 431 insertions(+), 209 deletions(-)

Adrian Bunk (1):
      HID: make hid_input_field and usbhid_modify_dquirk static

Anssi Hannula (2):
      HID: only dump report traffic with debug level 2
      HID: force feedback driver for Logitech Rumblepad 2

Jean Delvare (1):
      HID: fix build failure in hiddev_ioctl with gcc 3.2

Jim Duchek (1):
      HID: quirk for MS Wireless Desktop Receiver (model 1028)

Jiri Kosina (7):
      HID: Sunplus Wireless Desktop needs report descriptor fixup
      HID: fix misplaced rdesc quirk
      HID: pass numbered reports properly to hidraw
      HID: Logitech diNovo Mini pad support
      HID: ThrustMaster FF driver is no longer experimental
      HID: WiseGroup 866 Dual Joypad needs output reports quirk
      HID: remove 60x GTCO devices from blacklist

Jiri Slaby (3):
      HID: fix sparse warnings
      HID: make function from dbg_hid
      HID: move wait from hid to usbhid

Mike Frysinger (1):
      HID: export headers properly

Oliver Neukum (1):
      HID: fix race between open() and disconnect() in usbhid

Pekka Sarnila (1):
      HID: fixup fullspeed interval on highspeed Afatech DVB-T IR kbd

Pete Zaitcev (1):
      HID: patch to add NOGET for DMI/Acomdata

Robert Schedel (1):
      HID: Suppress hidinput for Samsung IR control

