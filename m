Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088Ab0AJWEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0AJWEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 17:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959Ab0AJWEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 17:04:15 -0500
Received: from bamako.nerim.net ([62.4.17.28]:60306 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab0AJWEP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 17:04:15 -0500
Date: Sun, 10 Jan 2010 23:04:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.33
Message-ID: <20100110230412.321d6c43@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

The asus_atk0110 changes aren't fixes stricto sensu, however they
should make future bug investigation and fixes much easier so I still
think it's OK to merge it now.

 Documentation/hwmon/k10temp  |   17 ++-
 drivers/hwmon/Kconfig        |    2 +-
 drivers/hwmon/adt7462.c      |    2 +-
 drivers/hwmon/asus_atk0110.c |  289 ++++++++++++++++++++++++++++++++++--------
 drivers/hwmon/coretemp.c     |   16 ++-
 drivers/hwmon/k10temp.c      |   40 +++++-
 drivers/hwmon/k8temp.c       |    2 +-
 drivers/hwmon/sis5595.c      |    2 +-
 drivers/hwmon/via686a.c      |    2 +-
 drivers/hwmon/vt8231.c       |    2 +-
 10 files changed, 299 insertions(+), 75 deletions(-)

---------------

Clemens Ladisch (1):
      hwmon: (k10temp) Blacklist more family 10h processors

Luca Tettamanti (2):
      hwmon: (asus_atk0110) Refactor interface probe code
      hwmon: (asus_atk0110) Add debugfs interface

Márton Németh (1):
      hwmon: Make PCI device ids constant

Roger Blofeld (1):
      hwmon: (adt7462) Fix pin 28 monitoring

Yong Wang (1):
      hwmon: (coretemp) Fix TjMax for Atom N450/D410/D510 CPUs

Thanks,
-- 
Jean Delvare
