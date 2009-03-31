Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZCaIjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZCaIjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbZCaIjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:39:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:45286 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbZCaIje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:39:34 -0400
Date: Tue, 31 Mar 2009 10:39:31 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial tree for 2.6.30-rc1
Message-ID: <alpine.LNX.2.00.0903301629400.14346@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-250249038-1238423411=:14346"
Content-ID: <alpine.LNX.2.00.0903311039060.14346@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-250249038-1238423411=:14346
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0903311039061.14346@wotan.suse.de>

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive accumulated trivial fixes all over the tree. All the changes are
either simple documentation updates (acked by the appropriate people), simple
typo fixes or trivial code fixes acked by the corresponding maintainers.

 CREDITS                                            |   10 ++++++-
 Documentation/00-INDEX                             |    4 +-
 Documentation/cgroups/00-INDEX                     |   18 +++++++++++++++
 Documentation/cgroups/cgroups.txt                  |   10 ++++----
 Documentation/cgroups/cpusets.txt                  |   12 +++++-----
 Documentation/cgroups/devices.txt                  |    2 +-
 Documentation/cgroups/memcg_test.txt               |    2 +-
 Documentation/cgroups/memory.txt                   |    2 +-
 Documentation/filesystems/ext3.txt                 |   14 ++++++++++-
 Documentation/ia64/kvm.txt                         |    2 +-
 Documentation/kernel-parameters.txt                |    4 +-
 .../dts-bindings/fsl/cpm_qe/qe/firmware.txt        |    2 +-
 Documentation/scheduler/sched-rt-group.txt         |    2 +-
 Documentation/vm/numa_memory_policy.txt            |    3 +-
 Documentation/vm/page_migration                    |    3 +-
 Documentation/x86/x86_64/fake-numa-for-cpusets     |    5 ++-
 MAINTAINERS                                        |   11 +++++++++
 arch/arm/mach-netx/include/mach/netx-regs.h        |    2 +-
 arch/arm/mach-omap1/Kconfig                        |    2 +-
 arch/avr32/Kconfig                                 |    6 ++--
 arch/blackfin/Kconfig                              |    6 ++--
 arch/cris/Kconfig                                  |    6 ++--
 arch/cris/arch-v32/Kconfig                         |    2 +-
 arch/cris/arch-v32/drivers/Kconfig                 |    2 +-
 arch/cris/arch-v32/mach-fs/Kconfig                 |    2 +-
 arch/h8300/kernel/timer/tpu.c                      |    2 +-
 arch/mips/Kconfig                                  |    2 +-
 arch/mips/sgi-ip27/ip27-smp.c                      |    2 +-
 arch/powerpc/Kconfig                               |    2 +-
 arch/powerpc/platforms/Kconfig                     |    2 +-
 arch/powerpc/sysdev/bestcomm/Kconfig               |    4 +-
 arch/sh/Kconfig                                    |    4 +-
 arch/sparc/kernel/head_64.S                        |    2 +-
 arch/x86/Kconfig                                   |    4 +-
 drivers/acpi/thermal.c                             |    2 +-
 drivers/ata/Kconfig                                |    2 +-
 drivers/base/sys.c                                 |    2 +-
 drivers/char/bsr.c                                 |    2 +-
 drivers/gpio/Kconfig                               |    6 ++--
 drivers/hid/Kconfig                                |    2 +-
 drivers/hwmon/f75375s.c                            |    4 +-
 drivers/input/Kconfig                              |    2 +-
 drivers/input/mouse/gpio_mouse.c                   |    2 +-
 drivers/input/touchscreen/ads7846.c                |    2 +-
 drivers/isdn/mISDN/Kconfig                         |   10 +++++---
 drivers/isdn/mISDN/l1oip_codec.c                   |    2 +-
 drivers/leds/Kconfig                               |    6 ++--
 drivers/leds/leds-pca9532.c                        |    4 +-
 drivers/media/common/tuners/Kconfig                |    2 +-
 drivers/media/dvb/frontends/Kconfig                |    2 +-
 drivers/media/dvb/frontends/drx397xD.c             |    2 +-
 drivers/mfd/Kconfig                                |    2 +-
 drivers/misc/Kconfig                               |    6 ++--
 drivers/mmc/host/Kconfig                           |    2 +-
 drivers/mtd/nand/diskonchip.c                      |    2 +-
 drivers/mtd/tests/mtd_oobtest.c                    |   24 ++++++++++----------
 drivers/mtd/tests/mtd_readtest.c                   |    2 +-
 drivers/net/sb1250-mac.c                           |    2 +-
 drivers/net/skfp/h/hwmtm.h                         |    2 +-
 drivers/net/tg3.c                                  |    2 +-
 drivers/net/wan/farsync.c                          |    2 +-
 drivers/net/wireless/ipw2x00/ipw2100.c             |    2 +-
 drivers/net/wireless/ipw2x00/ipw2200.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c        |    2 +-
 drivers/net/wireless/libertas/cmd.c                |    2 +-
 drivers/pci/pci.c                                  |    2 +-
 drivers/platform/x86/thinkpad_acpi.c               |    2 +-
 drivers/power/bq27x00_battery.c                    |    2 +-
 drivers/scsi/Kconfig                               |    4 +-
 drivers/serial/Kconfig                             |    2 +-
 drivers/staging/Kconfig                            |    4 +-
 drivers/staging/comedi/Kconfig                     |    4 +-
 drivers/staging/go7007/Kconfig                     |    4 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/staging/panel/Kconfig                      |    2 +-
 drivers/usb/atm/ueagle-atm.c                       |    2 +-
 drivers/usb/gadget/Kconfig                         |    2 +-
 drivers/usb/serial/ChangeLog.history               |    2 +-
 drivers/usb/serial/Kconfig                         |    4 +-
 drivers/usb/wusbcore/security.c                    |    2 +-
 drivers/uwb/Kconfig                                |    4 +-
 drivers/xen/Kconfig                                |    2 +-
 fs/bio.c                                           |    3 +-
 fs/ext4/Kconfig                                    |    2 +-
 fs/file_table.c                                    |    1 -
 fs/fs-writeback.c                                  |    2 +-
 fs/proc/nommu.c                                    |    2 +-
 fs/ubifs/Kconfig                                   |    4 +-
 include/linux/cgroup.h                             |    5 +++-
 include/linux/jbd.h                                |    2 +-
 include/linux/libata.h                             |    2 +-
 include/linux/pwm.h                                |    2 +-
 include/linux/usb/wusb.h                           |    3 +-
 init/Kconfig                                       |    8 +++---
 kernel/power/disk.c                                |    4 +-
 kernel/trace/Kconfig                               |    9 +++----
 kernel/trace/ftrace.c                              |    2 +-
 mm/page_alloc.c                                    |    2 +-
 net/Kconfig                                        |    2 +-
 net/ipv6/Kconfig                                   |   18 +++++++-------
 net/mac80211/Kconfig                               |    2 +-
 net/netfilter/Kconfig                              |    2 +-
 net/phonet/Kconfig                                 |    2 +-
 net/sunrpc/Kconfig                                 |    2 +-
 net/wimax/Kconfig                                  |    2 +-
 sound/oss/pss.c                                    |    2 +-
 sound/sh/aica.c                                    |    2 +-
 sound/soc/blackfin/Kconfig                         |    2 +-
 109 files changed, 226 insertions(+), 177 deletions(-)

Adam Buchbinder (1):
      trivial: Fix misspelling of "Celsius".

Alberto Bertogli (1):
      trivial: Fix typo in bio_split()'s documentation

Alexey Zaytsev (3):
      trivial: Fix dubious bitwise 'or' usage spotted by sparse.
      trivial: Fix dubious bitwise 'or' usage spotted by sparse.
      trivial: Fix dubious bitwise 'and' usage spotted by sparse.

Chris Samuel (1):
      trivial: cgroups: documentation typo and spelling corrections

Hannes Eder (2):
      trivial: NULL noise: drivers/media/dvb/frontends/drx397xD_fw.h
      trivial: NULL noise: drivers/mtd/tests/mtd_*test.c

Jochen Hein (1):
      trivial: Update contact info for Jochen Hein

Kazuo Moriwaka (1):
      trivial: jbd header comment typo fix for JBD_PARANOID_IOFAIL

Mark Vels (1):
      trivial: PWM: fix of #endif comment

Masatake YAMATO (1):
      trivial: fix a pdlfush -> pdflush typo in comment

Matt LaPlante (1):
      trivial: fix typos/grammar errors in Kconfig texts

Nick Andrew (1):
      trivial: Fix misspelling of firmware

Niels de Vos (1):
      trivial: MTD: remove EOL from MODULE_DESCRIPTION

Pavel Machek (1):
      trivial: document ext3 semantics of 'ro' option a bit better

Riku Voipio (1):
      trivial: Update my email address

Tero Roponen (1):
      trivial: remove unused variable 'path' in alloc_file()

Thadeu Lima de Souza Cascardo (2):
      trivial: Give the right path in Documentation example
      trivial: fix where cgroup documentation is not correctly referred to

Tobias Klauser (3):
      trivial: h8300: Storage class should be before const qualifier
      trivial: drivers/char/bsr.c: Storage class should be before const qualifier
      trivial: wusb: Storage class should be before const qualifier

Uwe Kleine-Koenig (2):
      trivial: fix typo "virual" -> "virtual"
      trivial: fix typo "resgister" -> "register"

Uwe Kleine-König (3):
      trivial: fix typo "thier" -> "their"
      trivial: fix typo "kernal" -> "kernel"
      trivial: fix typo "varaible" -> "variable"
--168427776-250249038-1238423411=:14346--
