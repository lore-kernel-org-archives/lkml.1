Return-Path: <linux-kernel-owner+w=401wt.eu-S1764493AbZLQQed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764493AbZLQQed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762217AbZLQQeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:34:18 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:59409 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760255AbZLQQeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:34:16 -0500
Subject: [GIT PULL] backlight updates for 2.6.33
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Dec 2009 16:33:21 +0000
Message-Id: <1261067601.26215.37.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-backlight for-linus

for the backlight tree updates for 2.6.33. These are mainly minor
improvements, bugfixes or new device table entries. Most patches have
been in -mm for a while.

Thanks, Richard

 Documentation/laptops/thinkpad-acpi.txt |   51 +++++++-------------------------
 drivers/platform/x86/thinkpad_acpi.c    |   24 ++++++++++++++-
 drivers/video/backlight/adp5520_bl.c    |    2 -
 drivers/video/backlight/adx_bl.c        |    2 -
 drivers/video/backlight/atmel-pwm-bl.c  |    2 -
 drivers/video/backlight/backlight.c     |    2 -
 drivers/video/backlight/corgi_lcd.c     |    2 -
 drivers/video/backlight/cr_bllcd.c      |    4 +-
 drivers/video/backlight/da903x_bl.c     |    2 -
 drivers/video/backlight/generic_bl.c    |    2 -
 drivers/video/backlight/hp680_bl.c      |    2 -
 drivers/video/backlight/jornada720_bl.c |    2 -
 drivers/video/backlight/kb3886_bl.c     |    2 -
 drivers/video/backlight/locomolcd.c     |    2 -
 drivers/video/backlight/mbp_nvidia_bl.c |   20 +++++++++++-
 drivers/video/backlight/omap1_bl.c      |    2 -
 drivers/video/backlight/progear_bl.c    |    2 -
 drivers/video/backlight/pwm_bl.c        |   11 ++++--
 drivers/video/backlight/tosa_bl.c       |    2 -
 drivers/video/backlight/wm831x_bl.c     |    2 -
 include/linux/backlight.h               |   12 +++----
 include/linux/pwm_backlight.h           |    2 -
 22 files changed, 85 insertions(+), 69 deletions(-)

Ben Dooks (1):
      backlight: Pass device through notify callback in the pwm driver

Daniel Ritz (1):
      backlight: mbp_nvidia_bl - add two more MacBookPro variants

Emese Revfy (1):
      backlight: Constify struct backlight_ops

Henrique de Moraes Holschuh (1):
      backlight/thinkpad-acpi: issue backlight class events

Roel Kluin (1):
      backlight: PTR_ERR return of wrong pointer in cr_backlight_probe()


-- 
Richard Purdie
Intel Open Source Technology Centre

