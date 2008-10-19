Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbYJSVrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbYJSVrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 17:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYJSVrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 17:47:23 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:44859 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbYJSVrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 17:47:22 -0400
Date: Sun, 19 Oct 2008 23:49:57 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ian Molton <spyro@f2s.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Eric Miao <eric.miao@marvell.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [GIT] mfd pull request
Message-ID: <20081019214957.GB4558@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull the mfd updates ?

The following changes since commit 0cfd81031a26717fe14380d18275f8e217571615:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-next

Andrew Morton (2):
      mfd: ucb1400 needs GPIO
      mfd: further unbork the ucb1400 ac97_bus dependencies

Ben Dooks (1):
      mfd: update sm501 debugging/low information messages

David Brownell (2):
      mfd: TWL4030 core driver
      mfd: twl4030-core irq simplification

Dmitry Baryshkov (4):
      mfd: provide and use setup hook for tc6393xb
      mfd: do tcb6393xb state restore on resume only if requested
      mfd: add OHCI cell to tc6393xb
      mfd: support tmiofb cell on tc6393xb

Eric Miao (1):
      mfd: add base support for Dialog DA9030/DA9034 PMICs

Ian Molton (2):
      mfd: reduce stack usage in mfd-core.c
      mfd: update TMIO drivers to use the clock API

Mark Brown (1):
      mfd: Don't use NO_IRQ in WM8350

Randy Dunlap (1):
      mfd: ucb1400 sound driver uses/depends on AC97_BUS:

Samuel Ortiz (1):
      mfd: Fix htc-egpio compile warning

 arch/arm/mach-pxa/include/mach/tosa.h |    2 -
 arch/arm/mach-pxa/tosa.c              |   37 +-
 drivers/input/touchscreen/Kconfig     |    2 +-
 drivers/mfd/Kconfig                   |   16 +
 drivers/mfd/Makefile                  |    2 +
 drivers/mfd/da903x.c                  |  563 ++++++++++++++++
 drivers/mfd/htc-egpio.c               |    2 +-
 drivers/mfd/mfd-core.c                |   15 +-
 drivers/mfd/sm501.c                   |    6 +-
 drivers/mfd/t7l66xb.c                 |   40 +-
 drivers/mfd/tc6387xb.c                |   47 +-
 drivers/mfd/tc6393xb.c                |  296 +++++++--
 drivers/mfd/twl4030-core.c            | 1193 +++++++++++++++++++++++++++++++++
 drivers/mfd/wm8350-core.c             |    2 +-
 include/linux/i2c/twl4030.h           |  339 ++++++++++
 include/linux/mfd/da903x.h            |  201 ++++++
 include/linux/mfd/t7l66xb.h           |    2 -
 include/linux/mfd/tc6387xb.h          |    3 -
 include/linux/mfd/tc6393xb.h          |   17 +-
 19 files changed, 2687 insertions(+), 98 deletions(-)
 create mode 100644 drivers/mfd/da903x.c
 create mode 100644 drivers/mfd/twl4030-core.c
 create mode 100644 include/linux/i2c/twl4030.h
 create mode 100644 include/linux/mfd/da903x.h

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
