Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbZLCP1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbZLCP1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZLCP1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:27:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:57220 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbZLCP1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:27:13 -0500
Date: Thu, 3 Dec 2009 16:27:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: linux-kernel@vger.kernel.org
Subject: What's in hid.git for 2.6.33
Message-ID: <alpine.LNX.2.00.0912031622310.3755@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

below is a summary of what is currently queued in hid.git tree for 2.6.33.

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

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
