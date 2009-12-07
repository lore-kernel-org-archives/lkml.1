Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZLGRw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZLGRw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 12:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbZLGRw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 12:52:56 -0500
Received: from cantor.suse.de ([195.135.220.2]:48500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754959AbZLGRwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 12:52:55 -0500
Date: Mon, 7 Dec 2009 18:53:00 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID
Message-ID: <alpine.LNX.2.00.0912071842200.3755@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive patches for HID code queued for 2.6.33. Thanks!

 drivers/hid/hid-core.c          |    9 +++++++--
 drivers/hid/hid-cypress.c       |    2 ++
 drivers/hid/hid-ids.h           |    7 +++++++
 drivers/hid/hid-lg.c            |   33 +++++++++++++++++++++++++++++++++
 drivers/hid/usbhid/hid-core.c   |   12 ++++++------
 drivers/hid/usbhid/hid-pidff.c  |    5 ++---
 drivers/hid/usbhid/hid-quirks.c |    4 +++-
 drivers/hid/usbhid/hiddev.c     |    5 -----
 include/linux/hid.h             |    1 +
 9 files changed, 61 insertions(+), 17 deletions(-)

Anssi Hannula (1):
      HID: pidff - fix unnecessary loop iterations on reset

Jiri Kosina (7):
      HID: fix MODULE_AUTHOR usage in HID modules
      HID: remove useless DRIVER_VERSION macro
      HID: fixup quirk for NCR devices
      HID: remove BKL from hiddev_ioctl_usage()
      HID: support Logitech/3DConnexion SpaceTraveler and SpaceNavigator
      HID: make Media key on Logitech DiNovo Mini work
      HID: add support for Acan FG-8100 barcode reader

Keith Rutkowski (1):
      HID: add NOGET quirk for another device from CH Products

Lamarque Vieira Souza (1):
      HID: blacklist Acer Ferrari 4005 optical mouse

Peter Hutterer (1):
      HID: add multi-input quirk for NextWindow Touchscreen.
