Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbZCaIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbZCaIfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZCaIew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:34:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:45065 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZCaIeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:34:50 -0400
Date: Tue, 31 Mar 2009 10:34:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] HID updates for 2.6.30-rc1
Message-ID: <alpine.LNX.2.00.0903301629090.14346@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git for-linus

to receive fixes for HID code.

 Documentation/feature-removal-schedule.txt |    7 -
 drivers/hid/Kconfig                        |   40 ++-
 drivers/hid/Makefile                       |    7 +-
 drivers/hid/hid-a4tech.c                   |    2 -
 drivers/hid/hid-apple.c                    |   26 +-
 drivers/hid/hid-belkin.c                   |    2 -
 drivers/hid/hid-cherry.c                   |    2 -
 drivers/hid/hid-chicony.c                  |    2 -
 drivers/hid/hid-core.c                     |   37 ++-
 drivers/hid/hid-cypress.c                  |    2 -
 drivers/hid/hid-drff.c                     |  188 +++++++++++
 drivers/hid/hid-dummy.c                    |   78 -----
 drivers/hid/hid-ezkey.c                    |    2 -
 drivers/hid/hid-gaff.c                     |    2 -
 drivers/hid/hid-gyration.c                 |    2 -
 drivers/hid/hid-ids.h                      |   10 +
 drivers/hid/hid-kensington.c               |   63 ++++
 drivers/hid/hid-kye.c                      |   69 ++++
 drivers/hid/hid-lg.c                       |    2 -
 drivers/hid/hid-microsoft.c                |    2 -
 drivers/hid/hid-monterey.c                 |    2 -
 drivers/hid/hid-ntrig.c                    |    2 -
 drivers/hid/hid-petalynx.c                 |    2 -
 drivers/hid/hid-pl.c                       |   52 +++-
 drivers/hid/hid-samsung.c                  |    2 -
 drivers/hid/hid-sony.c                     |    2 -
 drivers/hid/hid-sunplus.c                  |    2 -
 drivers/hid/hid-tmff.c                     |    2 -
 drivers/hid/hid-topseed.c                  |    2 -
 drivers/hid/hid-zpff.c                     |    2 -
 drivers/hid/hidraw.c                       |   17 +-
 drivers/hid/usbhid/hid-core.c              |  475 ++++++++++++++++++++++------
 drivers/hid/usbhid/hiddev.c                |   22 ++-
 drivers/hid/usbhid/usbhid.h                |   14 +-
 include/linux/hid.h                        |   23 +-
 35 files changed, 851 insertions(+), 315 deletions(-)

Anssi Hannula (1):
      HID: add support for another version of 0e8f:0003 device in hid-pl

Jiri Kosina (5):
      HID: do not try to compile PM code with CONFIG_PM unset
      HID: hid_reset_resume() needs to be defined only when CONFIG_PM is set
      HID: bring back possibility to specify vid/pid ignore on module load
      HID: support for Kensington slimblade device
      HID: add support for Kye/Genius Ergo 525V

Jiri Slaby (1):
      HID: remove compat stuff

Oliver Neukum (4):
      HID: autosuspend support for USB HID
      HID: fix USB HID devices after STD with autosuspend
      HID: autosuspend -- fix lockup of hid on reset
      HID: fix race between usb_register_dev() and hiddev_open()

Paul Collins (1):
      HID: constify arrays of struct apple_key_translation

Pavel Machek (1):
      HID: make HID_DEBUG defaults consistent

Richard Walmsley (1):
      HID: DragonRise game controller force feedback driver

Ryan Finnie (1):
      HID: Support Apple mini aluminum keyboard

