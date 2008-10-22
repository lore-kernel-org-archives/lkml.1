Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYJVJpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYJVJpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 05:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbYJVJmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 05:42:24 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:35988 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbYJVJmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 05:42:23 -0400
Date: Wed, 22 Oct 2008 11:44:54 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [GIT] mfd pull request
Message-ID: <20081022094453.GB2864@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Could you please pull this final rc1 patchset for mfd ?
It contains one build fix from Stephen, for the wm8350.

The following changes since commit 2515ddc6db8eb49a79f0fe5e67ff09ac7c81eab4:
  Paul Mundt (1):
        binfmt_elf_fdpic: Update for cputime changes.

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-next

Arjan van de Ven (1):
      mfd: use pci_ioremap_bar() in sm501

David Brownell (3):
      mfd: twl4030 IRQ handling update
      mfd: rtc-twl4030 driver
      mfd: twl4030-gpio driver

Mark Brown (1):
      mfd: Don't store volatile bits in WM8350 register cache

Roel Kluin (1):
      mfd: check for platform_get_irq() return value in sm501

Stephen Rothwell (1):
      mfd: don't export wm3850 static functions

 drivers/gpio/Kconfig        |    7 +
 drivers/gpio/Makefile       |    1 +
 drivers/gpio/twl4030-gpio.c |  521 ++++++++++++++++++++++++++++++
 drivers/mfd/Makefile        |    2 +-
 drivers/mfd/sm501.c         |   25 +-
 drivers/mfd/twl4030-core.c  |  421 +-----------------------
 drivers/mfd/twl4030-irq.c   |  743 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/wm8350-core.c   |    5 +-
 drivers/rtc/Kconfig         |   10 +
 drivers/rtc/Makefile        |    1 +
 drivers/rtc/rtc-twl4030.c   |  564 ++++++++++++++++++++++++++++++++
 include/linux/i2c/twl4030.h |   28 +-
 12 files changed, 1897 insertions(+), 431 deletions(-)
 create mode 100644 drivers/gpio/twl4030-gpio.c
 create mode 100644 drivers/mfd/twl4030-irq.c
 create mode 100644 drivers/rtc/rtc-twl4030.c

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
