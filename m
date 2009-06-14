Return-Path: <linux-kernel-owner+w=401wt.eu-S1762476AbZFNTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762476AbZFNTVU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760904AbZFNTVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:21:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758291AbZFNTVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:21:09 -0400
Date: Sun, 14 Jun 2009 21:21:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID patches for 2.6.31 merge window
Message-ID: <alpine.LNX.2.00.0906121821540.7457@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive updates for HID code that have been queued for 2.6.31 merge window.

There is nothing really outstanding, mostly adding support for a new hardware
and a few cleanups.

Thanks.

 drivers/hid/Kconfig           |   92 ++++++++++++---
 drivers/hid/Makefile          |   10 +-
 drivers/hid/hid-apple.c       |    4 -
 drivers/hid/hid-core.c        |    2 +
 drivers/hid/hid-debug.c       |   23 ++++-
 drivers/hid/hid-drff.c        |    8 ++
 drivers/hid/hid-gaff.c        |    8 ++
 drivers/hid/hid-ids.h         |    2 +
 drivers/hid/hid-lgff.c        |   10 ++-
 drivers/hid/hid-ntrig.c       |  222 +++++++++++++++++++++++++++++++++--
 drivers/hid/hid-sjoy.c        |  180 ++++++++++++++++++++++++++++
 drivers/hid/hid-tmff.c        |   17 ++-
 drivers/hid/hid-wacom.c       |  259 +++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-zpff.c        |    7 +
 drivers/hid/hidraw.c          |    5 +-
 drivers/hid/usbhid/hid-core.c |    7 +-
 include/linux/hid.h           |   36 ++++++
 17 files changed, 841 insertions(+), 51 deletions(-)

Bastien Nocera (1):
      HID: Wacom Graphire Bluetooth driver

Jiri Kosina (4):
      HID: fix hid-ff drivers so that devices work even without ff support
      HID: hidraw -- fix comment about accepted devices
      HID: no more reinitializtion is needed in post_reset
      HID: fix inverted wheel for bluetooth version of apple mighty mouse

Jussi Kivilinna (1):
      HID: force feedback support for SmartJoy PLUS PS2/USB adapter

Sergey Belyashov (2):
      HID: autocentering support for Logitech G25 Racing Wheel
      HID: autocentering support for Logitech Force 3D Pro

Stephane Chatty (2):
      HID: add new multitouch and digitizer contants
      HID: Multitouch support for the N-Trig touchscreen

