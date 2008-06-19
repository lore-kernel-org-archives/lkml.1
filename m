Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbYFSM4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbYFSM4U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYFSM4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:56:12 -0400
Received: from emerald.lightlink.com ([64.57.176.19]:4866 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbYFSM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:56:12 -0400
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jun 2008 08:56:11 EDT
Date: Thu, 19 Jun 2008 08:33:04 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates vs. v2.6.26-rc6
Message-ID: <20080619123304.GF7306@mars.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get a few bugfixes, a couple of updates to abituguru3, and a couple of
documentation updates.

Hopefully this is the last you'll hear from me before 2.6.26 final.

Thanks & regards,

 Documentation/hwmon/sysfs-interface |   33 +++++++++++++--------------------
 MAINTAINERS                         |    6 +++---
 drivers/hwmon/abituguru3.c          |   18 +++++++++++++++---
 drivers/hwmon/adt7473.c             |    3 +++
 drivers/hwmon/lm75.c                |   20 +++++++++++++++-----
 drivers/hwmon/lm85.c                |   25 +++++++++++--------------
 6 files changed, 60 insertions(+), 45 deletions(-)

David Brownell (1):
      hwmon: (lm75) sensor reading bugfix

Hans de Goede (2):
      hwmon: (abituguru3) Identify Abit AW8D board as such
      hwmon: (abituguru3) update driver detection

Jean Delvare (3):
      hwmon: (lm85) Fix function RANGE_TO_REG()
      hwmon: (adt7473) Initialize max_duty_at_overheat before use
      hwmon: Update the sysfs interface documentation

Marc Hulsman (1):
      hwmon: (w83791d) new maintainer

-- 
Mark M. Hoffman
mhoffman@lightlink.com

