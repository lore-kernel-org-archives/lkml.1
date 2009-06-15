Return-Path: <linux-kernel-owner+w=401wt.eu-S1760164AbZFOLYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164AbZFOLYc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 07:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbZFOLYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 07:24:23 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:36731 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZFOLYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 07:24:23 -0400
Subject: [GIT PULL] voltage regulator updates for 2.6.31-rc1
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 15 Jun 2009 12:24:21 +0100
Message-Id: <1245065061.21421.90.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following voltage regulator updates for 2.6.31-rc1. 

This update contains new drivers for the LP3971 and Maxim 1586 PMICs and
a userspace consumer driver allowing fine grained regulator control by
applications. Also noteworthy are list_voltage() support for fixed
regulators and subsys_initcall() for regulator drivers

Thanks

Liam

---

The following changes since commit 45e3e1935e2857c54783291107d33323b3ef33c8:
  Linus Torvalds (1):
        Merge branch 'master' of git://git.kernel.org/.../sam/kbuild-next

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Greg Kroah-Hartman (1):
      regulator: remove driver_data direct access of struct device

Liam Girdwood (2):
      regulator: build fix for powerpc - renamed show_state
      regulator: lp3971 - fix driver link error when built-in.

Marek Szyprowski (1):
      LP3971 PMIC regulator driver (updated and combined version)

Mark Brown (3):
      regulator: Move regulator drivers to subsys_initcall()
      regulator: Support list_voltage for fixed voltage regulator
      regulator: Set MODULE_ALIAS for regulator drivers

Mike Rapoport (1):
      regulator: add userspace-consumer driver

Philipp Zabel (2):
      regulator/max1586: support increased V3 voltage range
      regulator/max1586: fix V3 gain calculation integer overflow

Robert Jarzmik (1):
      Maxim 1586 regulator driver

 drivers/regulator/Kconfig                    |   26 ++
 drivers/regulator/Makefile                   |    3 +
 drivers/regulator/da903x.c                   |    2 +-
 drivers/regulator/fixed.c                    |   18 +-
 drivers/regulator/lp3971.c                   |  562 ++++++++++++++++++++++++++
 drivers/regulator/max1586.c                  |  282 +++++++++++++
 drivers/regulator/pcf50633-regulator.c       |    2 +-
 drivers/regulator/userspace-consumer.c       |  200 +++++++++
 drivers/regulator/virtual.c                  |    1 +
 drivers/regulator/wm8350-regulator.c         |    1 +
 drivers/regulator/wm8400-regulator.c         |    8 +-
 include/linux/regulator/lp3971.h             |   51 +++
 include/linux/regulator/max1586.h            |   63 +++
 include/linux/regulator/userspace-consumer.h |   25 ++
 14 files changed, 1236 insertions(+), 8 deletions(-)
 create mode 100644 drivers/regulator/lp3971.c
 create mode 100644 drivers/regulator/max1586.c
 create mode 100644 drivers/regulator/userspace-consumer.c
 create mode 100644 include/linux/regulator/lp3971.h
 create mode 100644 include/linux/regulator/max1586.h
 create mode 100644 include/linux/regulator/userspace-consumer.h


