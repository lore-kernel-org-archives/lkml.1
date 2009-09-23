Return-Path: <linux-kernel-owner+w=401wt.eu-S1752952AbZIWVTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbZIWVTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZIWVTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:19:00 -0400
Received: from bamako.nerim.net ([62.4.17.28]:61108 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbZIWVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:19:00 -0400
Date: Wed, 23 Sep 2009 23:19:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rudolf Marek <r.marek@assembler.cz>,
       Hans de Goede <hdegoede@redhat.com>
Subject: [GIT PULL] hwmon updates for 2.6.32, round 2
Message-ID: <20090923231901.2bb8f0f4@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem updates for Linux 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

I've just pushed it there, should be there in a short moment.

Main changes are the removal of the legacy fsc drivers, and more CPU
models supported by the coretemp driver.

 Documentation/feature-removal-schedule.txt |    8 -
 Documentation/hwmon/coretemp               |    4 +-
 Documentation/hwmon/fscher                 |  169 -------
 drivers/hwmon/Kconfig                      |   34 +--
 drivers/hwmon/Makefile                     |    2 -
 drivers/hwmon/adm1031.c                    |   40 ++
 drivers/hwmon/coretemp.c                   |   57 ++-
 drivers/hwmon/fscher.c                     |  680 ----------------------------
 drivers/hwmon/fscpos.c                     |  654 --------------------------
 drivers/hwmon/ltc4215.c                    |    2 +-
 drivers/hwmon/ltc4245.c                    |    3 +-
 11 files changed, 93 insertions(+), 1560 deletions(-)
 delete mode 100644 Documentation/hwmon/fscher
 delete mode 100644 drivers/hwmon/fscher.c
 delete mode 100644 drivers/hwmon/fscpos.c

---------------

Huaxu Wan (1):
      hwmon: (coretemp) Add Lynnfield CPU

Ira Snyder (1):
      hwmon: (adm1031) Add sysfs files for temperature offsets

Ira W. Snyder (2):
      hwmon: (ltc4215) Clear faults at startup
      hwmon: (ltc4245) Clear faults at startup

Jean Delvare (1):
      hwmon: Delete deprecated FSC drivers

Rudolf Marek (2):
      hwmon: (coretemp) Fix Atom CPUs support
      hwmon: (coretemp) Add support for Penryn mobile CPUs

Thanks,
-- 
Jean Delvare
