Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbZJIS6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbZJIS6N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbZJIS6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:58:12 -0400
Received: from poutre.nerim.net ([62.4.16.124]:49535 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbZJIS6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:58:11 -0400
Date: Fri, 9 Oct 2009 20:57:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon fixes for 2.6.32
Message-ID: <20091009205722.5434b5c2@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem fixes for Linux 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus


 MAINTAINERS                  |    2 +-
 drivers/hwmon/Kconfig        |    2 +-
 drivers/hwmon/asus_atk0110.c |  339 +++++++++++++++++++++++++++++++++++-------
 drivers/hwmon/sht15.c        |    7 +-
 4 files changed, 292 insertions(+), 58 deletions(-)

---------------

Jean Delvare (1):
      MAINTAINERS: Fix Riku Voipio's address

Luca Tettamanti (2):
      hwmon: (asus_atk0110) Refactor the code
      hwmon: (asus_atk0110) Enable the EC

Mark Brown (1):
      hwmon: (s3c-hwmon) Disable build for S3C64xx

Rakib Mullick (1):
      hwmon: (sht15) Fix spurious section mismatch warning

Thanks,
-- 
Jean Delvare
