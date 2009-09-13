Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbZIMSgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbZIMSgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 14:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZIMSgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 14:36:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:48657 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbZIMSgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 14:36:47 -0400
Date: Sun, 13 Sep 2009 20:36:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID patches for 2.6.32 merge window
Message-ID: <alpine.LNX.2.00.0909132014310.17028@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive HID patches accumulated for 2.6.32 merge window.

Thanks!

 drivers/hid/Kconfig             |   29 +--
 drivers/hid/Makefile            |    6 +-
 drivers/hid/hid-a4tech.c        |    4 +-
 drivers/hid/hid-apple.c         |    4 +-
 drivers/hid/hid-belkin.c        |    4 +-
 drivers/hid/hid-cherry.c        |    4 +-
 drivers/hid/hid-chicony.c       |    4 +-
 drivers/hid/hid-core.c          |   71 +++++--
 drivers/hid/hid-cypress.c       |    4 +-
 drivers/hid/hid-debug.c         |  439 ++++++++++++++++++++++++++++++++-------
 drivers/hid/hid-ezkey.c         |    4 +-
 drivers/hid/hid-gyration.c      |    4 +-
 drivers/hid/hid-ids.h           |   14 +-
 drivers/hid/hid-input.c         |   13 +-
 drivers/hid/hid-kensington.c    |    4 +-
 drivers/hid/hid-kye.c           |    4 +-
 drivers/hid/hid-lg.c            |    6 +-
 drivers/hid/hid-lgff.c          |    6 +-
 drivers/hid/hid-microsoft.c     |    4 +-
 drivers/hid/hid-monterey.c      |    4 +-
 drivers/hid/hid-ntrig.c         |   37 +++-
 drivers/hid/hid-petalynx.c      |    4 +-
 drivers/hid/hid-pl.c            |    4 +-
 drivers/hid/hid-samsung.c       |   43 ++++-
 drivers/hid/hid-sjoy.c          |    4 +-
 drivers/hid/hid-sony.c          |    4 +-
 drivers/hid/hid-sunplus.c       |    4 +-
 drivers/hid/hid-tmff.c          |   10 +-
 drivers/hid/hid-topseed.c       |    4 +-
 drivers/hid/hid-twinhan.c       |  147 +++++++++++++
 drivers/hid/hid-wacom.c         |    4 +-
 drivers/hid/hid-zpff.c          |    4 +-
 drivers/hid/usbhid/hid-core.c   |   12 +-
 drivers/hid/usbhid/hid-quirks.c |    2 +-
 drivers/hid/usbhid/hiddev.c     |    2 +-
 include/linux/hid-debug.h       |   48 +++--
 include/linux/hid.h             |   22 +--
 37 files changed, 755 insertions(+), 232 deletions(-)

Bruno Premont (1):
      HID: driver for Twinhan USB 6253:0100 remote control

H Hartley Sweeten (1):
      HID: local function should be static

Henning Glawe (1):
      HID: ignore Philips IEEE802.15.4 RF Dongle

Jan Scholz (1):
      HID: completely remove apple mightymouse from blacklist

Jarod Wilson (1):
      HID: ignore all recent SoundGraph iMON devices

Jiri Kosina (6):
      HID: use debugfs for report dumping descriptor
      HID: use debugfs for events/reports dumping
      HID: fix debugfs build with !CONFIG_DEBUG_FS
      HID: fix memory leak on error path in debug code
      HID: add force feedback support for Logitech WingMan Formula Force GP
      HID: support larger reports than 64 bytes in hiddev

Julia Lawall (2):
      HID: Drop NULL test on list_entry result
      HID: fix memory leak on error patch in debug code

Peter Huewe (1):
      HID: adding __init/__exit macros to module init/exit functions

Rafi Rubin (1):
      HID: ntrig tool separation and pen usages

Robert Schedel (1):
      HID: Support new variants of Samsung USB IR receiver (0419:0001)

Roel Kluin (1):
      HID: fix overrun in quirks initialization

Ruben Aos Garralda (1):
      HID: add rumble support for Thrustmaster Dual Trigger 3-in-1

Sergey Senozhatsky (1):
      HID: Avoid double spin_lock_init on usbhid->lock

