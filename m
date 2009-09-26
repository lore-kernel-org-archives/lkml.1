Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZIZQLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZIZQLI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZIZQLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:11:07 -0400
Received: from dan.rpsys.net ([93.97.175.187]:61408 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669AbZIZQLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:11:06 -0400
Subject: [GIT PULL] backlight updates for 2.6.32
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Sep 2009 17:10:49 +0100
Message-Id: <1253981449.7598.60.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree update for 2.6.32. This adds some new drivers,
adds backlight event notifications for userspace and adds some new
devices IDs to existing drivers.

Thanks, Richard

 drivers/acpi/video.c                    |    4 +
 drivers/platform/x86/eeepc-laptop.c     |    2 +-
 drivers/video/backlight/Kconfig         |   33 +++
 drivers/video/backlight/Makefile        |    4 +
 drivers/video/backlight/adp5520_bl.c    |  377 +++++++++++++++++++++++++++++++
 drivers/video/backlight/adx_bl.c        |  178 +++++++++++++++
 drivers/video/backlight/backlight.c     |   42 ++++
 drivers/video/backlight/da903x_bl.c     |   20 +-
 drivers/video/backlight/hp680_bl.c      |    2 +-
 drivers/video/backlight/lms283gf05.c    |  242 ++++++++++++++++++++
 drivers/video/backlight/mbp_nvidia_bl.c |   36 +++
 drivers/video/backlight/wm831x_bl.c     |  250 ++++++++++++++++++++
 include/linux/backlight.h               |    7 +
 include/linux/spi/lms283gf05.h          |   28 +++
 14 files changed, 1213 insertions(+), 12 deletions(-)
 create mode 100644 drivers/video/backlight/adp5520_bl.c
 create mode 100644 drivers/video/backlight/adx_bl.c
 create mode 100644 drivers/video/backlight/lms283gf05.c
 create mode 100644 drivers/video/backlight/wm831x_bl.c
 create mode 100644 include/linux/spi/lms283gf05.h


Henrik Rydberg (1):
      backlight: mbp_nvidia_bl: add support for MacBookAir 1,1

Henrique de Moraes Holschuh (1):
      backlight: extend event support to also support poll()

Marek Vasut (1):
      backlight: spi driver for LMS283GF05 LCD

Mario Schwalbe (1):
      backlight: Add support for new Apple machines.

Mark Brown (1):
      backlight: Add WM831x backlight driver

Matthew Garrett (3):
      backlight: Allow drivers to update the core, and generate events on changes
      backlight/acpi: Update the backlight state when we change brightness
      backlight/eeepc-laptop: Update the backlight state when we change brightness

Michael Hennerich (1):
      backlight: new driver for ADP5520/ADP5501 MFD PMICs

Mike Rapoport (1):
      backlight: switch to da903x driver to dev_pm_ops

Thierry Reding (1):
      backlight: Add support for the Avionic Design Xanthos backlight device.

Uwe Kleine-König (1):
      backlight: move hp680-bl's probe function to .devinit.text


-- 
Richard Purdie
Intel Open Source Technology Centre

