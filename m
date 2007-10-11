Return-Path: <linux-kernel-owner+w=401wt.eu-S1758610AbXJKVjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758610AbXJKVjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 17:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754721AbXJKVi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 17:38:59 -0400
Received: from tim.rpsys.net ([194.106.48.114]:33801 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbXJKVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 17:38:58 -0400
Subject: [GIT PULL] Backlight updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Oct 2007 22:38:11 +0100
Message-Id: <1192138691.11368.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.24. This includes a new driver,
changes to an existing driver and some other fixes.

Thanks, Richard

 arch/arm/mach-pxa/corgi.c           |   18 +
 arch/arm/mach-pxa/spitz.c           |   18 +
 drivers/video/backlight/Kconfig     |   23 +-
 drivers/video/backlight/Makefile    |    2 
 drivers/video/backlight/backlight.c |    2 
 drivers/video/backlight/corgi_bl.c  |   22 +-
 drivers/video/backlight/cr_bllcd.c  |   35 ++-
 drivers/video/backlight/lcd.c       |    2 
 drivers/video/backlight/ltv350qv.c  |  330 ++++++++++++++++++++++++++++++++++++
 drivers/video/backlight/ltv350qv.h  |   95 ++++++++++
 include/asm-arm/arch-pxa/sharpsl.h  |    6 
 include/linux/backlight.h           |    9 
 12 files changed, 518 insertions(+), 44 deletions(-)

Adrian Bunk (1):
      backlight/leds: Make two structs static

Haavard Skinnemoen (1):
      backlight: Add Samsung LTV350QV LCD driver

Jesper Juhl (1):
      backlight: Fix cr_bllcd allocations and error paths

Richard Purdie (1):
      backlight: Convert corgi backlight driver into a more generic driver


