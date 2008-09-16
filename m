Return-Path: <linux-kernel-owner+w=401wt.eu-S1753716AbYIPJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbYIPJmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIPJmF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 05:42:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50509 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751203AbYIPJmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 05:42:04 -0400
Date: Tue, 16 Sep 2008 10:42:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] WM8400 support v2
Message-ID: <20080916094201.GA15271@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: Adapt.  Enjoy.  Survive.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches against the regulator development tree add basic support
for the WM8400, an audio CODEC and PMU targeted at multimedia systems,
covering basic PMIC functionality only.  Since the functionality of the
device covers multiple subsystems with arbitration required a core
driver is provided in drivers/mfd.

I think I've covered all the issues raised last time, erring on the side
of split headers rather than unifying them, details in the individual
patches.

The following changes since commit fa83aec82558c7d5822c47e52db3f1f6b104a930:
  Liam Girdwood (1):
        maintainers: update email address for Liam Girdwood

are available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-lrg

Mark Brown (2):
      mfd: Core support for the WM8400 AudioPlus HiFi CODEC and PMU
      regulator: Add WM8400 regulator support

 drivers/mfd/Kconfig                  |    8 +
 drivers/mfd/Makefile                 |    2 +
 drivers/mfd/wm8400-core.c            |  457 +++++++++++++
 drivers/regulator/Kconfig            |    8 +-
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/wm8400-regulator.c |  367 +++++++++++
 include/linux/mfd/wm8400-audio.h     | 1186 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8400-private.h   |  936 +++++++++++++++++++++++++++
 include/linux/mfd/wm8400.h           |   40 ++
 9 files changed, 3004 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mfd/wm8400-core.c
 create mode 100644 drivers/regulator/wm8400-regulator.c
 create mode 100644 include/linux/mfd/wm8400-audio.h
 create mode 100644 include/linux/mfd/wm8400-private.h
 create mode 100644 include/linux/mfd/wm8400.h
