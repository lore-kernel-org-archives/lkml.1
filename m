Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZADA7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZADA7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZADA7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:59:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:51014 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750805AbZADA67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:58:59 -0500
Date: Sun, 4 Jan 2009 01:58:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID updates for 2.6.29
Message-ID: <alpine.LNX.1.10.0901040115060.5377@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the following updates of HID code that have been planned for 
2.6.29.

This batch contains mostly added support for new quirky devices and various
rather easy fixes all over the code.

Thanks!

 drivers/hid/Kconfig             |   70 ++++++++-------
 drivers/hid/Makefile            |    5 +-
 drivers/hid/hid-bright.c        |   71 ---------------
 drivers/hid/hid-core.c          |  120 +++++++++++++++++++++++---
 drivers/hid/hid-dell.c          |   76 ----------------
 drivers/hid/hid-dummy.c         |    6 ++
 drivers/hid/hid-gaff.c          |  185 +++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-ids.h           |   21 +++--
 drivers/hid/hid-lg.c            |    7 --
 drivers/hid/hid-ntrig.c         |   82 +++++++++++++++++
 drivers/hid/hid-sony.c          |    2 +-
 drivers/hid/hid-topseed.c       |   77 ++++++++++++++++
 drivers/hid/hidraw.c            |   32 ++++++-
 drivers/hid/usbhid/Kconfig      |    2 +-
 drivers/hid/usbhid/hid-core.c   |   34 +++++---
 drivers/hid/usbhid/hid-quirks.c |    1 +
 drivers/hid/usbhid/hiddev.c     |  135 +++++++++++++++++++++--------
 drivers/hid/usbhid/usbhid.h     |   10 ++
 include/linux/hid.h             |   16 ++--
 include/linux/hidraw.h          |    2 +
 20 files changed, 685 insertions(+), 269 deletions(-)

Alan Stern (1):
      HID: automatically call usbhid_set_leds in usbhid driver

Alexey Klimov (1):
      HID: don't allow DealExtreme usb-radio be handled by usb hid driver

David Brownell (1):
      HID: switch specialized drivers from "default y" to !EMBEDDED

Hannes Eder (1):
      HID: avoid sparse warning in HID_COMPAT_LOAD_DRIVER

Jiri Kosina (6):
      HID: ignore mouse interface for unibody macbooks
      HID: non-input reports can also be numbered
      HID: add phys and name ioctls to hidraw
      HID: set proper dev.parent in hidraw
      HID: fix default Kconfig setting for TopSpeed driver
      HID: fix error condition propagation in hid-sony driver

Jiri Slaby (4):
      HID: move usbhid flags to usbhid.h
      HID: usbhid, use usb_endpoint_xfer_int
      HID: use GFP_KERNEL in hid_alloc_buffers
      HID: add dynids facility

Kay Sievers (1):
      HID: struct device - replace bus_id with dev_name(), dev_set_name()

Lev Babiev (1):
      HID: driver for TopSeed Cyberlink quirky remote

Lukasz Lubojanski (1):
      HID: force feedback driver for GreenAsia 0x12 PID

Matt Helsley (1):
      HID: add proper support for pensketch 12x9 tablet

Oliver Neukum (2):
      HID: hiddev cleanup -- handle all error conditions properly
      HID: fix reference count leak hidraw

Parag Warudkar (1):
      HID: make boot protocol drivers depend on EMBEDDED

Rafi Rubin (1):
      HID: add n-trig digitizer support

