Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbXGIU2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbXGIU2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 16:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbXGIU17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 16:27:59 -0400
Received: from styx.suse.cz ([82.119.242.94]:42447 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753967AbXGIU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 16:27:58 -0400
Date: Mon, 9 Jul 2007 22:32:19 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID updates for 2.6.23 merge window
Message-ID: <Pine.LNX.4.64.0707092210160.11634@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

or
        master.kernel.org:/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive 2.6.23 merge window update for HID layer. All the patches have 
been sitting in -mm for some time.

 drivers/hid/Kconfig             |   10 ++-
 drivers/hid/hid-core.c          |   93 ++++++++++----------
 drivers/hid/hid-debug.c         |   15 +++
 drivers/hid/hid-input.c         |  125 ++++++++++++++++++++++-----
 drivers/hid/usbhid/hid-core.c   |  111 ++++++-----------------
 drivers/hid/usbhid/hid-lgff.c   |   10 +-
 drivers/hid/usbhid/hid-pidff.c  |    1 +
 drivers/hid/usbhid/hid-quirks.c |  185 ++++++++++++++++++++++++++++++++++++---
 drivers/hid/usbhid/hid-tmff.c   |    2 +-
 drivers/hid/usbhid/hid-zpff.c   |    8 +--
 drivers/hid/usbhid/hiddev.c     |    2 +-
 drivers/hid/usbhid/usbkbd.c     |    6 +-
 include/linux/hid.h             |   56 ++++++++----
 13 files changed, 425 insertions(+), 199 deletions(-)

Alan Stern (1):
      USB HID: avoid flush_scheduled_work()

Diogo Kastrup (1):
      HID: fix autocentering of PID devices

Hans de Goede (1):
      HID: fix mismatch between hid-input HUT find/search mapping and the HUT

Jan Engelhardt (1):
      HID: Use menuconfig objects

Jiri Kosina (8):
      HID: make debugging output runtime-configurable
      HID: input mapping for Chicony KU-0418 tactical pad
      HID: force hid-input for Microsoft SideWinder GameVoice device
      HID: support for Petalynx Maxter remote control
      HID: Add NOGET quirk for all NCR devices
      HID: separate quirks for report descriptor fixup
      HID: Logitech keyboard 0xc311 needs reset leds quirk
      HID: handle cases of volume knobs generating relative values

Julien Eyries (1):
      HID: support for Gameron dual psx adaptor

Ryo Dairiki (1):
      HID: support for logitech cordless desktop LX500 special mapping

