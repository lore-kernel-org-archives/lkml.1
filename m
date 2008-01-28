Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYA1PyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYA1PyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYA1PyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:54:11 -0500
Received: from styx.suse.cz ([82.119.242.94]:52388 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752120AbYA1PyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:54:09 -0500
Date: Mon, 28 Jan 2008 16:54:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID updates for 2.6.25 merge window
Message-ID: <Pine.LNX.4.64.0801281651520.22844@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-47462776-1201535558=:22844"
Content-ID: <Pine.LNX.4.64.0801281652570.22844@jikos.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-47462776-1201535558=:22844
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0801281652571.22844@jikos.suse.cz>

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-lin=
us

or
        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following patches for HID code. All of them have been in=20
-mm for some time.

 drivers/hid/Makefile            |    2 +-
 drivers/hid/hid-core.c          |   12 +-
 drivers/hid/hid-input-quirks.c  |  423 +++++++++++++++++++++++++++++++++++=
++++
 drivers/hid/hid-input.c         |  295 +++++++--------------------
 drivers/hid/usbhid/Kconfig      |    5 +-
 drivers/hid/usbhid/hid-quirks.c |  118 ++++++++++--
 drivers/hid/usbhid/hid-tmff.c   |    7 +-
 drivers/hid/usbhid/usbkbd.c     |    8 +
 drivers/hid/usbhid/usbmouse.c   |    8 +
 include/linux/hid.h             |   18 ++-
 10 files changed, 651 insertions(+), 245 deletions(-)

Bastien Nocera (1):
      HID: force hiddev creation for SONY PS3 controller

Carlos Corbacho (1):
      HID: Add support for Logitech Elite keyboards

Drew Fisher (1):
      HID: Microsoft Wireless Optical Desktop 3.0 quirk

Fengguang Wu (1):
      HID: the `bit' in hidinput_mapping_quirks() is an out parameter

Jan Kiszka (2):
      HID: Map MS Presenter 8000 bottom-side buttons
      HID: Refactor MS Presenter 8K key mapping

Jiri Kosina (10):
      HID: add full support for Genius KB-29E
      HID: refactor mapping to input subsystem for quirky devices
      HID: separate hid-input event quirks from generic code
      HID: hid-input quirk for BTC 8193
      HID: remove unused variable in quirk event handler
      HID: proper handling of MS 4k and 6k devices
      HID: remove redundant WARN_ON()s in order not to scare users
      HID: fix compilation of hidbp drivers without usbhid
      HID: MS Presenter mapping for PID 0x0701
      HID: Logitech Extreme 3D needs NOGET quirk

Li Zefan (1):
      HID: fix a potential bug in pointer casting

Michel D=C3=A4nzer (2):
      HID: Rename some code identifiers from PowerBook specific to Apple ge=
neric
      HID: Add support for Apple aluminum USB keyboards.

Nicolas Mailhot (1):
      HID: Blacklist the Gretag-Macbeth Huey display colorimeter

Pascal Terjan (1):
      HID: Use hid blacklist in usbmouse/usbkbd

Pavel Troller (1):
      HID: Implement horizontal wheel handling for A4 Tech X5-005D

Robert Schedel (1):
      HID: Support Samsung IR remote

Tobias Lorenz (1):
      HID: ADS/Tech Radio si470x needs blacklist entry
--336216065-47462776-1201535558=:22844--
