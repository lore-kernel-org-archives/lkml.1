Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbXGVPAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbXGVPAw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:00:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbXGVPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:00:45 -0400
Received: from tim.rpsys.net ([194.106.48.114]:55605 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbXGVPAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:00:44 -0400
Subject: [GIT PULL #2] Backlight updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 16:00:28 +0100
Message-Id: <1185116428.6819.35.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

This converts the backlight/lcd class away from struct class_device and
includes a couple of bugfixes.

Thanks,

Richard (Backlight maintainer)

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

Andrew Morton (1):
      leds: cr_bllcd.c: build fix

David Brownell (1):
      backlight: Fix order of Kconfig entries

Richard Purdie (1):
      backlight: Convert from struct class_device to struct device

