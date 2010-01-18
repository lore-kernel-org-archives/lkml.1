Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788Ab0ARMpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab0ARMpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 07:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139Ab0ARMpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 07:45:23 -0500
Received: from mga05.intel.com ([192.55.52.89]:25540 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458Ab0ARMpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 07:45:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,295,1262592000"; 
   d="scan'208";a="532195088"
Date: Mon, 18 Jan 2010 13:46:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Ian Molton <ian@mnementh.co.uk>, Magnus Damm <damm@opensource.se>,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>,
       Dan Carpenter <error27@gmail.com>
Subject: [GIT] [2.6.33] MFD pull request
Message-ID: <20100118124654.GA8036@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the MFD fixes for 2.6.33.
We have 3 wm835x fixes, one mc13783 locking mistake, and the CNF area
abstraction code for the tmio drivers.
The latter is needed for the sh_mobile_sdhi driver to build properly.

Thanks in advance for pulling.

The following changes since commit 7dc9c484a71525794ca05cf7a47f283f1b54cd12:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../viro/vfs-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-linus

Alberto Panizzo (1):
      mfd: Unlock mc13783 before subsystems initialisation, at probe time.

Dan Carpenter (1):
      mfd: WM8350 off by one bug

Ian Molton (1):
      mfd: tmio_mmc hardware abstraction for CNF area

Mark Brown (2):
      mfd: Correct WM835x ISINK ramp time defines
      mfd: WM835x GPIO direction register is not locked

 drivers/mfd/Makefile            |    6 +-
 drivers/mfd/asic3.c             |   40 ++++++++++---
 drivers/mfd/mc13783-core.c      |    4 +-
 drivers/mfd/t7l66xb.c           |   55 ++++++++++++------
 drivers/mfd/tc6387xb.c          |  119 +++++++++++++++++++++++++++++----------
 drivers/mfd/tc6393xb.c          |   56 +++++++++++++++---
 drivers/mfd/tmio_core.c         |   52 +++++++++++++++++
 drivers/mfd/wm8350-core.c       |    3 +-
 drivers/mfd/wm8350-irq.c        |    4 +-
 drivers/mmc/host/tmio_mmc.c     |   59 ++++++-------------
 drivers/mmc/host/tmio_mmc.h     |   46 ++-------------
 include/linux/mfd/tmio.h        |   39 +++++++++++++
 include/linux/mfd/wm8350/pmic.h |   28 +++++-----
 13 files changed, 342 insertions(+), 169 deletions(-)
 create mode 100644 drivers/mfd/tmio_core.c


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
