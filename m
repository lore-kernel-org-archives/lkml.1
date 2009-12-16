Return-Path: <linux-kernel-owner+w=401wt.eu-S1759901AbZLPWf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759901AbZLPWf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbZLPWfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:35:25 -0500
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:54520 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZLPWfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:35:24 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19SlUqWs+FaWRGD13ajPaKS
Date: Wed, 16 Dec 2009 14:35:20 -0800
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-omap@vger.kernel.org
Subject: [GIT PULL] omap build fixes
Message-ID: <20091216223520.GV4575@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull omap build fixes from:

git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

In addition to the three build fixes, there's also a suspend fix
for omap serial init.

Regards,

Tony


The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
  Stephen Rothwell (1):
        mfd: compile fix for twl4030 renaming

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git omap-fixes-for-linus

Balaji T K (1):
      mfd: twl: fix twl4030 rename for remaining driver, board files

Mika Westerberg (1):
      OMAP3: serial - fix bug introduced in

Olof Johansson (1):
      omap3: Allow EHCI to be built on OMAP3

Thomas Weber (1):
      USB ehci: replace mach header with plat

 arch/arm/mach-omap2/Kconfig                  |    1 +
 arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
 arch/arm/mach-omap2/board-igep0020.c         |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
 arch/arm/mach-omap2/serial.c                 |    7 ++++---
 drivers/usb/host/ehci-omap.c                 |    2 +-
 drivers/video/omap/lcd_ldp.c                 |    4 ++--
 drivers/video/omap/lcd_omap2evm.c            |   10 +++++-----
 drivers/video/omap/lcd_omap3beagle.c         |    2 +-
 drivers/video/omap/lcd_omap3evm.c            |   10 +++++-----
 drivers/video/omap/lcd_overo.c               |    2 +-
 sound/soc/omap/sdp3430.c                     |    6 +++---
 15 files changed, 29 insertions(+), 27 deletions(-)
