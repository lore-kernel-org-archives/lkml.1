Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbZFQSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbZFQSaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZFQSaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:30:18 -0400
Received: from mga06.intel.com ([134.134.136.21]:48191 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754373AbZFQSaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:30:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,239,1243839600"; 
   d="scan'208";a="423175081"
Date: Wed, 17 Jun 2009 20:32:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Daniel Ribeiro <drwyrm@gmail.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Thomas Gleixner <tglx@linutronix.de>, Adrian Bunk <bunk@kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>
Subject: [GIT] MFD pull request for 2.6.31-rc1
Message-ID: <20090617183218.GF25896@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.31 merge window.
The big changes there are 2 new drivers (PCAP, AB3100), and a fairly big asic3
update.

Thanks in advance for pulling those changes in.

The following changes since commit 65795efbd380a832ae508b04dba8f8e53f0b84d9:
  Linus Torvalds (1):
        Merge branch 'next-i2c' of git://aeryn.fluff.org.uk/bjdooks/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Adrian Bunk (1):
      mfd/pcf50633-gpio.c: add MODULE_LICENSE

Daniel Ribeiro (1):
      mfd: add PCAP driver

Linus Walleij (1):
      mfd: add U300 AB3100 core support

Mark Brown (3):
      mfd: Correct readability of WM8350 register 227
      mfd: Mark WM8350 mask revision as readable to match silicon
      mfd: Fix Kconfig help text for WM8350

Philipp Zabel (7):
      mfd: asic3: add asic3_set_register common operation
      mfd: asic3: add clock handling for MFD cells
      mfd: add ASIC3 IRQ numbers
      mfd: asic3: use resource_size macro instead of local variable
      mfd: asic3: remove SD/SDIO controller register definitions
      mfd: asic3: enable DS1WM cell
      mfd: asic3: enable SD/SDIO cell

Rakib Mullick (1):
      mfd: Mark clocks_init as non-init in twl4030-core.c

Samuel Ortiz (2):
      mfd: fix tmio related warnings
      mfd: early init for MFD running regulators

Thomas Gleixner (1):
      drivers/mfd: remove obsolete irq_desc_t typedef

 drivers/mfd/Kconfig          |   24 +-
 drivers/mfd/Makefile         |    5 +-
 drivers/mfd/ab3100-core.c    |  991 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/asic3.c          |  312 +++++++++++++-
 drivers/mfd/da903x.c         |    2 +-
 drivers/mfd/ezx-pcap.c       |  505 +++++++++++++++++++++
 drivers/mfd/pcf50633-core.c  |    2 +-
 drivers/mfd/pcf50633-gpio.c  |    3 +
 drivers/mfd/t7l66xb.c        |    2 +-
 drivers/mfd/tc6387xb.c       |    2 +-
 drivers/mfd/tc6393xb.c       |    2 +-
 drivers/mfd/twl4030-core.c   |    2 +-
 drivers/mfd/twl4030-irq.c    |    2 +-
 drivers/mfd/wm8350-regmap.c  |    4 +-
 drivers/mfd/wm8400-core.c    |    2 +-
 include/linux/mfd/ab3100.h   |  103 +++++
 include/linux/mfd/asic3.h    |  236 +----------
 include/linux/mfd/ezx-pcap.h |  256 +++++++++++
 include/linux/mfd/tmio.h     |    2 +-
 19 files changed, 2219 insertions(+), 238 deletions(-)
 create mode 100644 drivers/mfd/ab3100-core.c
 create mode 100644 drivers/mfd/ezx-pcap.c
 create mode 100644 include/linux/mfd/ab3100.h
 create mode 100644 include/linux/mfd/ezx-pcap.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
