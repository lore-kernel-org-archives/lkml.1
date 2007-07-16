Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXGPIjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXGPIjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 04:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbXGPIji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 04:39:38 -0400
Received: from tim.rpsys.net ([194.106.48.114]:46880 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754744AbXGPIjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 04:39:37 -0400
Subject: [GIT PULL] Backlight updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 16 Jul 2007 09:39:27 +0100
Message-Id: <1184575167.9602.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

This converts the backlight/lcd class away from struct class_device and
includes a Kconfig bugfix.

Thanks,

Richard

 drivers/acpi/video.c                 |    4 -
 drivers/usb/misc/appledisplay.c      |    4 -
 drivers/video/aty/aty128fb.c         |    2 
 drivers/video/aty/atyfb_base.c       |    2 
 drivers/video/aty/radeon_backlight.c |    4 -
 drivers/video/backlight/Kconfig      |   26 ++++---
 drivers/video/backlight/backlight.c  |  125 ++++++++++++++---------------------
 drivers/video/backlight/cr_bllcd.c   |    2 
 drivers/video/backlight/lcd.c        |  112 ++++++++++++++-----------------
 drivers/video/nvidia/nv_backlight.c  |    2 
 drivers/video/riva/fbdev.c           |    2 
 include/linux/backlight.h            |   11 ++-
 include/linux/lcd.h                  |   14 ++-
 13 files changed, 148 insertions(+), 162 deletions(-)

David Brownell (1):
      backlight: Fix order of Kconfig entries

Richard Purdie (1):
      backlight: Convert from struct class_device to struct device


