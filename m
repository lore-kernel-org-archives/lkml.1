Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZAILgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZAILgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 06:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZAILgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 06:36:08 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:53441 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbZAILgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 06:36:07 -0500
X-Greylist: delayed 821 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 06:36:06 EST
Subject: [GIT PULL] Backlight updates for 2.6.29
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 11:22:46 +0000
Message-Id: <1231500166.5317.8.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.29. This includes a new driver,
various bugfixes/tweaks, restructuring of one of the drivers and
suspend/resume improvements to the core cleaning up the code.

Thanks, Richard

 drivers/video/backlight/Kconfig         |   15 +-
 drivers/video/backlight/Makefile        |    2 
 drivers/video/backlight/backlight.c     |   73 +++++++++----
 drivers/video/backlight/corgi_bl.c      |  169 --------------------------------
 drivers/video/backlight/cr_bllcd.c      |   18 +--
 drivers/video/backlight/generic_bl.c    |  147 +++++++++++++++++++++++++++
 drivers/video/backlight/hp680_bl.c      |   20 +--
 drivers/video/backlight/mbp_nvidia_bl.c |    1 
 drivers/video/backlight/progear_bl.c    |   20 +--
 drivers/video/backlight/tdo24m.c        |   94 ++++++++++++++++-
 drivers/video/backlight/tosa_lcd.c      |   27 ++++-
 drivers/video/backlight/vgg2432a4.c     |    2 
 include/linux/backlight.h               |   16 +++
 include/linux/spi/tdo24m.h              |   13 ++
 14 files changed, 370 insertions(+), 247 deletions(-)

Akinobu Mita (3):
      backlight: hp680_bl - Use platform_device_register_simple()
      backlight: progear_bl - Use platform_device_register_simple()
      backlight: crbllcd_bl - Use platform_device_register_simple()

Denis V. Lunev (1):
      backlight: Value of ILI9320_RGB_IF2 register should not be hardcoded

Dmitry Eremin-Solenikov (1):
      backlight: Support VGA/QVGA mode switching in tosa_lcd

Mike Rapoport (1):
      backlight: add support for Toppoly TDO35S series to tdo24m lcd driver

Pavel Machek (1):
      backlight: Catch invalid input in sysfs attributes

Richard Purdie (2):
      backlight: Add suspend/resume support to the backlight core
      backlight: Rename the corgi backlight driver to generic

Zhang Rui (1):
      bd->props.brightness doesn't reflect the actual backlight level.



