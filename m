Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbYJXO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbYJXO6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYJXO6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:58:24 -0400
Received: from styx.suse.cz ([82.119.242.94]:37646 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbYJXO6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:58:23 -0400
Date: Fri, 24 Oct 2008 16:58:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID updates
Message-ID: <alpine.LNX.1.10.0810241550020.27479@jikos.suse.cz>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive post-rc1 updates for the HID code.

The most important thing is a fix for regression which made it impossible 
for appletouch driver to bind to some of the devices it supports, because 
generic driver grabbed them by mistake. Apart from that, a few simple 
fixes and two new quirks for devices that are not standard-compliant.

Thanks!

 drivers/hid/Kconfig           |    2 -
 drivers/hid/hid-apple.c       |   63 ++++++++++++++--------------------------
 drivers/hid/hid-core.c        |   43 ++++++++++++++++++++++++++-
 drivers/hid/hid-gyration.c    |    4 ++-
 drivers/hid/hid-ids.h         |    5 ++-
 drivers/hid/hid-lg.c          |    5 ---
 drivers/hid/hid-sony.c        |   44 ++++++++++++++++++++++++++++-
 drivers/hid/hidraw.c          |    3 +-
 drivers/hid/usbhid/hid-core.c |    3 ++
 drivers/hid/usbhid/hiddev.c   |    3 +-
 include/linux/hid.h           |    6 ++++
 11 files changed, 124 insertions(+), 57 deletions(-)

Andi Kleen (1):
      HID: Remove "default m" for Thrustmaster and Zeroplus

Dan Nicholson (1):
      Revert "HID: Invert HWHEEL mappings for some Logitech mice"

Jiri Kosina (3):
      HID: add support for another Gyration remote control
      HID: quirk for OLED devices present in ASUS G50/G70/G71
      HID: Add support for Sony Vaio VGX-TP1E

Jiri Slaby (5):
      HID: fix hidraw_exit section mismatch
      HID: add hid_type to general hid struct
      HID: fix hidbus/appletouch device binding regression
      HID: fix lock imbalance in hidraw
      HID: fix lock imbalance in hiddev

