Return-Path: <linux-kernel-owner+w=401wt.eu-S932582AbZAOVbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932582AbZAOVbF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbZAOVaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:30:52 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:35998 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZAOVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:30:51 -0500
Date: Thu, 15 Jan 2009 22:30:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.29
Message-ID: <20090115223042.5106b964@hyperion.delvare>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.29 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 Documentation/hwmon/adt7475 |   87 +++
 drivers/hwmon/Kconfig       |   10 +
 drivers/hwmon/Makefile      |    2 +
 drivers/hwmon/abituguru3.c  |   24 +-
 drivers/hwmon/adt7475.c     | 1221 +++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/k8temp.c      |   55 ++-
 6 files changed, 1384 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/hwmon/adt7475
 create mode 100644 drivers/hwmon/adt7475.c

---------------

Alistair John Strachan (3):
      hwmon: (abituguru3) Match partial DMI board name strings
      hwmon: (abituguru3) Enable DMI probing feature on IN9 32X MAX
      hwmon: (abituguru3) Fix CONFIG_DMI=n fallback to probe

Andreas Herrmann (3):
      hwmon: (k8temp) Warn about fam F rev F errata
      hwmon: (k8temp) Fix wrong sensor selection for AMD K8 RevF/RevG CPUs
      hwmon: (k8temp) Fix temperature reporting for (most) K8 RevG CPUs

Jordan Crouse (1):
      hwmon: Add a driver for the ADT7475 hardware monitoring chip

Thanks,
-- 
Jean Delvare
