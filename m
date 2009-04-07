Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZDGNhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZDGNhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 09:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZDGNhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 09:37:22 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:21453 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbZDGNhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 09:37:22 -0400
Date: Tue, 7 Apr 2009 15:37:09 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] More hwmon updates for 2.6.30
Message-ID: <20090407153709.5cdc8c1a@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem updates for Linux 2.6.30 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 drivers/acpi/acpica/nsxfeval.c |    3 +-
 drivers/hwmon/Kconfig          |   12 +
 drivers/hwmon/Makefile         |    1 +
 drivers/hwmon/asus_atk0110.c   | 1009 ++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/lm95241.c        |  112 ++---
 include/acpi/acpixf.h          |    2 -
 6 files changed, 1070 insertions(+), 69 deletions(-)
 create mode 100644 drivers/hwmon/asus_atk0110.c

---------------

Jean Delvare (1):
      hwmon: (lm95241) Convert to new-style i2c driver

Luca Tettamanti (1):
      hwmon: Add Asus ATK0110 support

Thanks,
-- 
Jean Delvare
