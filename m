Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbXE0U1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbXE0U1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 16:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXE0U1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 16:27:12 -0400
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:54253 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752101AbXE0U1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 16:27:12 -0400
Date: Sun, 27 May 2007 22:28:29 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.22
Message-ID: <20070527222829.28e193c9@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the hwmon subsystem fixes for Linux 2.6.22 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

 drivers/hwmon/Kconfig     |    2 +-
 drivers/hwmon/applesmc.c  |    7 ++++++-
 drivers/hwmon/coretemp.c  |   32 +++++++++++++++++++++++++++++---
 drivers/hwmon/ds1621.c    |    8 ++++----
 drivers/hwmon/hwmon-vid.c |    4 +++-
 drivers/hwmon/w83627hf.c  |    4 +++-
 6 files changed, 46 insertions(+), 11 deletions(-)

---------------

Jean Delvare (4):
      hwmon/ds1621: Fix swapped temperature limits
      hwmon/w83627hf: Be quiet when no chip is found
      hwmon-vid: Don't spam the logs when VRM version is missing
      hwmon/applesmc: Simplify dependencies

Nicolas Boichat (1):
      hwmon/applesmc: Handle name file creation error and deletion

Rudolf Marek (1):
      hwmon/coretemp: Add more safety checks

Thanks,
-- 
Jean Delvare
