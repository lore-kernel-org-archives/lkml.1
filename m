Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab0CCQAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:00:45 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41572 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab0CCQAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:00:44 -0500
Subject: [GIT PULL] regulator updates for 2.6.34
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 16:00:39 +0000
Message-ID: <1267632039.3185.36.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator updates for 2.6.34. This
update includes new PMIC drivers for the MAX8649 and WM8994. Other
notable additions include a new API call to query regulator enable times
and a notifier for regulator shutdown. Also included are numerous misc
fixes.

Thanks

Liam

---    

The following changes since commit 3a5b27bf6f29574d667230c7e76e4b83fe3014e0:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Adrian Hunter (1):
      regulator: Add 'start-up time' to fixed voltage regulators

Alberto Panizzo (2):
      regulator: add voltage selection capability to mc13783 regulators v2 .
      regulator: mc13783: consider Power Gates as digital regulators.

Alex Chiang (1):
      regulator: trivial: fix typos in user-visible Kconfig text

Dmitry Torokhov (13):
      Regulators: virtual - use sysfs attribute groups
      Regulators: ab3100 - fix probe and remove annotations
      Regulators: fixed - annotate probe and remove methods
      Regulators: twl-regulator - mark probe function as __devinit
      Regulators: tps65023-regulator - mark probe method as __devinit
      Regulators: tps6507x-regulator - mark probe method as __devinit
      Regulators: lp3971 - fail if platform data was not supplied
      Regulators: max1586 - annotate probe and remove methods
      Regulators: max8660 - annotate probe and remove methods
      Regulators: pcap-regulator - clean up driver data after removal
      Regulators: wm831x-xxx - clean up driver data after removal
      Regulators: wm8994 - clean up driver data after removal
      Regulators: wm8400 - cleanup platform driver data handling

Haojian Zhuang (1):
      regulator: enable max8649 regulator driver

Mark Brown (7):
      regulator: Add notifier event on regulator disable
      regulator: Allow regulators to specify the time taken to ramp on enable
      regulator: Implement enable_time() for WM835x ISINKs
      regulator: Add WM8994 regulator support
      regulator: Convert fixed voltage regulator to use enable_time()
      regulator: Assume regulators are enabled if they don't report anything
      regulator: Provide optional dummy regulator for consumers

Rajendra Nayak (1):
      twl6030: regulator: Configure STATE register instead of REMAP

Tobias Klauser (1):
      regulator/lp3971: Storage class should be before const qualifier

 drivers/regulator/Kconfig              |   29 ++-
 drivers/regulator/Makefile             |    3 +
 drivers/regulator/ab3100.c             |    6 +-
 drivers/regulator/core.c               |   79 +++++-
 drivers/regulator/dummy.c              |   66 +++++
 drivers/regulator/dummy.h              |   31 +++
 drivers/regulator/fixed.c              |   30 ++-
 drivers/regulator/lp3971.c             |   68 +++---
 drivers/regulator/max1586.c            |    9 +-
 drivers/regulator/max8649.c            |  408 ++++++++++++++++++++++++++++
 drivers/regulator/max8660.c            |   11 +-
 drivers/regulator/mc13783-regulator.c  |  465 +++++++++++++++++++++++++++++--
 drivers/regulator/pcap-regulator.c     |    8 +-
 drivers/regulator/tps65023-regulator.c |   35 ++--
 drivers/regulator/tps6507x-regulator.c |   34 +--
 drivers/regulator/twl-regulator.c      |   22 +-
 drivers/regulator/virtual.c            |   64 +++---
 drivers/regulator/wm831x-dcdc.c        |   12 +
 drivers/regulator/wm831x-isink.c       |    3 +
 drivers/regulator/wm831x-ldo.c         |    5 +
 drivers/regulator/wm8350-regulator.c   |   46 ++++
 drivers/regulator/wm8400-regulator.c   |    7 +-
 drivers/regulator/wm8994-regulator.c   |  307 +++++++++++++++++++++
 include/linux/mfd/mc13783.h            |    2 +
 include/linux/regulator/consumer.h     |    4 +-
 include/linux/regulator/driver.h       |    6 +
 include/linux/regulator/fixed.h        |    2 +
 include/linux/regulator/max8649.h      |   44 +++
 28 files changed, 1622 insertions(+), 184 deletions(-)
 create mode 100644 drivers/regulator/dummy.c
 create mode 100644 drivers/regulator/dummy.h
 create mode 100644 drivers/regulator/max8649.c
 create mode 100644 drivers/regulator/wm8994-regulator.c
 create mode 100644 include/linux/regulator/max8649.h


