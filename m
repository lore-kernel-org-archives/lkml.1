Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbYGYN51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbYGYN51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 09:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbYGYN5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 09:57:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54272 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750934AbYGYN5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 09:57:17 -0400
Subject: [GIT PULL] Voltage and Current regulator framework
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       pHilipp Zabel <philipp.zabel@gmail.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 14:57:14 +0100
Message-Id: <1216994234.31838.114.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the voltage and current regulator framework along with
the bq24022 regulator driver.

This framework is designed to provide a generic interface to voltage and
current regulators within the Linux 2.6 kernel. It's intended to provide
voltage and current control to client or consumer drivers and also
provide status information to user space applications through a sysfs
interface.

The intention is to allow systems to dynamically control regulator
output in order to save power and prolong battery life. This applies to
both voltage regulators (where voltage output is controllable) and
current sinks (where current output is controllable).

This framework has been in Andrews mm tree and Linux-next without
incident.

Thanks!

Liam

====

The following changes since commit fb2e405fc1fc8b20d9c78eaa1c7fd5a297efde43:
  Adrian Bunk (1):
        fix fs/nfs/nfsroot.c compilation

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git reg-for-linus

Liam Girdwood (11):
      regulator: consumer device interface
      regulator: regulator driver interface
      regulator: machine driver interface
      regulator: regulator framework core
      regulator: core kbuild files
      regulator: documentation - overview
      regulator: documentation - consumer interface
      regulator: documentation - regulator driver
      regulator: documentation - machine
      regulator: documentation - ABI
      regulator: maintainers - add maintainers for regulator framework.

Mark Brown (3):
      regulator: fixed regulator interface
      regulator: add support for fixed regulators.
      regulator: regulator test harness

Philipp Zabel (1):
      regulator: TI bq24022 Li-Ion Charger driver

 Documentation/ABI/testing/sysfs-class-regulator |  315 ++++
 Documentation/power/regulator/consumer.txt      |  182 +++
 Documentation/power/regulator/machine.txt       |  101 ++
 Documentation/power/regulator/overview.txt      |  171 ++
 Documentation/power/regulator/regulator.txt     |   30 +
 MAINTAINERS                                     |    9 +
 arch/arm/Kconfig                                |    2 +
 drivers/Makefile                                |    1 +
 drivers/regulator/Kconfig                       |   59 +
 drivers/regulator/Makefile                      |   12 +
 drivers/regulator/bq24022.c                     |  167 ++
 drivers/regulator/core.c                        | 1903 +++++++++++++++++++++++
 drivers/regulator/fixed.c                       |  129 ++
 drivers/regulator/virtual.c                     |  345 ++++
 include/linux/regulator/bq24022.h               |   21 +
 include/linux/regulator/consumer.h              |  284 ++++
 include/linux/regulator/driver.h                |   99 ++
 include/linux/regulator/fixed.h                 |   22 +
 include/linux/regulator/machine.h               |  104 ++
 19 files changed, 3956 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-regulator
 create mode 100644 Documentation/power/regulator/consumer.txt
 create mode 100644 Documentation/power/regulator/machine.txt
 create mode 100644 Documentation/power/regulator/overview.txt
 create mode 100644 Documentation/power/regulator/regulator.txt
 create mode 100644 drivers/regulator/Kconfig
 create mode 100644 drivers/regulator/Makefile
 create mode 100644 drivers/regulator/bq24022.c
 create mode 100644 drivers/regulator/core.c
 create mode 100644 drivers/regulator/fixed.c
 create mode 100644 drivers/regulator/virtual.c
 create mode 100644 include/linux/regulator/bq24022.h
 create mode 100644 include/linux/regulator/consumer.h
 create mode 100644 include/linux/regulator/driver.h
 create mode 100644 include/linux/regulator/fixed.h
 create mode 100644 include/linux/regulator/machine.h

