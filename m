Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZBQIp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZBQIp1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZBQIpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:45:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:18055 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZBQIpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:45:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,222,1233561600"; 
   d="scan'208";a="490553968"
Date: Tue, 17 Feb 2009 09:47:29 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Jean Delvare <khali@linux-fr.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Roel Kluin <roel.kluin@gmail.com>, Julia Lawall <julia@diku.dk>
Subject: [GIT] MFD pull request
Message-ID: <20090217084728.GA2818@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I have some bug fixes for the mfd code. Could you please pull them in:

The following changes since commit d2f8d7ee1a9b4650b4e43325b321801264f7c37a:
  Linus Torvalds (1):
        Linux 2.6.29-rc5

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Alexey Dobriyan (1):
      mfd: fix sm501 section mismatches

Jean Delvare (1):
      mfd: terminate pcf50633 i2c_device_id list

Julia Lawall (1):
      mfd: Fix egpio kzalloc return test

Mark Brown (5):
      mfd: Initialise WM8350 interrupts earlier
      mfd: Improve diagnostics for WM8350 ID register probe
      mfd: Mark WM835x USB_SLV_500MA bit as accessible
      mfd: Fix TWL4030 build on some ARM variants
      mfd: Ensure all WM8350 IRQs are masked at startup

Philipp Zabel (1):
      mfd: fix htc-egpio iomem resource handling using resource_size

Rakib Mullick (1):
      mfd: Fix sm501_register_gpio section mismatch

Roel Kluin (1):
      mfd: wm8350 tries reaches -1

 drivers/mfd/htc-egpio.c     |    4 +-
 drivers/mfd/pcf50633-core.c |    1 +
 drivers/mfd/sm501.c         |   26 +++++++++++-----------
 drivers/mfd/twl4030-core.c  |    2 +-
 drivers/mfd/wm8350-core.c   |   48 +++++++++++++++++++++++++++++++-----------
 drivers/mfd/wm8350-regmap.c |    2 +-
 6 files changed, 53 insertions(+), 30 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
