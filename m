Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752545AbYLRKnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbYLRKnU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYLRKnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:43:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35866 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300AbYLRKnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:43:03 -0500
Date: Thu, 18 Dec 2008 10:43:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] MFD updates
Message-ID: <20081218104301.GA12649@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Not for human consumption.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d9f27a08919b6ea6e5266b3e32596286766715b2:
  Samuel Ortiz (1):
        mfd: Fix twl4030-core.c build error

are available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-sameo

Mark Brown (6):
      mfd: Pass driver_data onto child devices
      mfd: Register WM8400 codec device
      mfd: Add WM8352 support
      mfd: Handle missing WM8350 platform data
      mfd: Support configurable numbers of DCDCs and ISINKs on WM8350
      mfd: Add WM8351 support

 drivers/mfd/Kconfig                  |   33 +
 drivers/mfd/mfd-core.c               |    1 +
 drivers/mfd/wm8350-core.c            |  139 ++-
 drivers/mfd/wm8350-i2c.c             |    2 +
 drivers/mfd/wm8350-regmap.c          | 2096 ++++++++++++++++++++++++++++++++++
 drivers/mfd/wm8400-core.c            |   31 +-
 drivers/regulator/wm8350-regulator.c |    7 +
 include/linux/mfd/wm8350/core.h      |    8 +
 include/linux/mfd/wm8350/pmic.h      |    4 +
 9 files changed, 2299 insertions(+), 22 deletions(-)
