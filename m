Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850Ab0AYON4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0AYON4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:13:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022Ab0AYONz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:13:55 -0500
Received: from poutre.nerim.net ([62.4.16.124]:65056 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0AYONw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:13:52 -0500
Date: Mon, 25 Jan 2010 15:13:47 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon fixes for 2.6.33
Message-ID: <20100125151347.492690e4@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem fixes for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 drivers/hwmon/amc6821.c      |    1 -
 drivers/hwmon/asus_atk0110.c |   19 +++++++++----------
 drivers/hwmon/fschmd.c       |    7 +++++--
 drivers/hwmon/smsc47m1.c     |    2 +-
 4 files changed, 15 insertions(+), 14 deletions(-)

---------------

Dan Carpenter (1):
      hwmon: (amc6821) Double unlock bug

Hans de Goede (1):
      hwmon: (fschmd) Fix a memleak on multiple opens of /dev/watchdog

Jeff Mahoney (1):
      hwmon: (smsc47m1) Fix section mismatch

Luca Tettamanti (1):
      hwmon: (asus_atk0110) Do not fail if MBIF is missing

Thanks,
-- 
Jean Delvare
