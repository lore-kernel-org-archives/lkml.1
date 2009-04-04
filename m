Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZDDXFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZDDXFh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 19:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZDDXF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 19:05:29 -0400
Received: from mga06.intel.com ([134.134.136.21]:11477 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbZDDXF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 19:05:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,324,1235980800"; 
   d="scan'208";a="503655712"
Date: Sun, 5 Apr 2009 01:07:34 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tobias Klauser <tklauser@distanz.ch>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: [GIT] MFD pull request
Message-ID: <20090404230733.GB25441@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are a few mfd updates for rc1. Nothing outstanding, just the regular
WM835x updates and some DS1WM and PASIC3 changes.
This is my last pull request from git.o-hand.com. I moved the mfd tree to
git.kernel.org, as specified in the MAINTAINERS changes.

Thanks in advance for pullling.

The following changes since commit 6bb597507f9839b13498781e481f5458aea33620:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-next

Huang Weiyi (1):
      mfd: remove duplicated #include from pcf50633

Mark Brown (3):
      mfd: Use bulk read to fill WM8350 register cache
      mfd: Support active high IRQs on WM835x
      mfd: Use the value of the final spin when reading the AUXADC

Philipp Zabel (6):
      mfd: convert DS1WM to use MFD core
      mfd: convert PASIC3 to use MFD core
      pxa/magician: remove deprecated .bus_shift from PASIC3 platform_data
      mfd: remove unused PASIC3 bus_shift field
      mfd: remove DS1WM clock handling
      mfd: PASIC3: supply clock_rate to DS1WM via driver_data

Samuel Ortiz (2):
      mfd: fix MAINTAINERS entry
      mfd: fix da903x warning

Tobias Klauser (1):
      mfd: Storage class should be before const qualifier

 MAINTAINERS                     |    3 +-
 arch/arm/mach-pxa/magician.c    |    1 -
 drivers/mfd/Kconfig             |    1 +
 drivers/mfd/da903x.c            |    2 +-
 drivers/mfd/htc-pasic3.c        |  169 ++++++++++++++++-----------------------
 drivers/mfd/pcf50633-core.c     |    1 -
 drivers/mfd/t7l66xb.c           |    4 +-
 drivers/mfd/tc6393xb.c          |    2 +-
 drivers/mfd/twl4030-irq.c       |    2 +-
 drivers/mfd/wm8350-core.c       |   39 +++++++---
 drivers/w1/masters/ds1wm.c      |   58 ++++++-------
 include/linux/ds1wm.h           |   12 ---
 include/linux/mfd/ds1wm.h       |    6 ++
 include/linux/mfd/htc-pasic3.h  |    1 -
 include/linux/mfd/wm8350/core.h |    2 +
 15 files changed, 139 insertions(+), 164 deletions(-)
 delete mode 100644 include/linux/ds1wm.h
 create mode 100644 include/linux/mfd/ds1wm.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
