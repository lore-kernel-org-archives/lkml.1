Return-Path: <linux-kernel-owner+w=401wt.eu-S1752492AbXBEL1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbXBEL1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 06:27:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbXBEL1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 06:27:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:58444 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752492AbXBEL1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 06:27:53 -0500
Date: Mon, 5 Feb 2007 12:28:04 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] HID and USB HID merge window update
Message-ID: <Pine.LNX.4.64.0702051213390.4276@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        master.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus
or
        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive the first part of HID and USB HID updates that are destined for
2.6.21 merge window. All of the patches have been in -mm for some time.

Thanks.

 drivers/hid/Kconfig          |   14 +
 drivers/hid/Makefile         |   11 +-
 drivers/hid/hid-core.c       |    8 +-
 drivers/hid/hid-debug.c      |  764 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hid/hid-input.c      |   35 ++-
 drivers/usb/input/Kconfig    |    8 +
 drivers/usb/input/Makefile   |    3 +
 drivers/usb/input/hid-core.c |   81 ++---
 drivers/usb/input/hid-ff.c   |    3 +
 drivers/usb/input/hid-plff.c |  129 +++++++
 include/linux/hid-debug.h    |  749 +----------------------------------------
 include/linux/hid.h          |   17 +-
 12 files changed, 1005 insertions(+), 817 deletions(-)

Anssi Hannula (3):
      hid: allow force feedback for multi-input devices
      hid: quirk for multi-input devices with unneeded output reports
      hid: force feedback driver for PantherLord USB/PS2 2in1 Adapter

Jiri Kosina (5):
      HID: hid debug from hid-debug.h to hid layer
      HID: API - fix leftovers of hidinput API in USB HID
      USB HID: remove hid_find_field_by_usage()
      USB HID: fix bogus comment in hid_get_class_descriptor()
      HID: move away from DEBUG defines in favor of CONFIG_HID_DEBUG

Soeren Sonnenburg (1):
      USB HID: handle multi-interface devices for Apple macbook pro properly

