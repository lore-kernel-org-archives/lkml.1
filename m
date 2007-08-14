Return-Path: <linux-kernel-owner+w=401wt.eu-S933911AbXHNByT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911AbXHNByT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 21:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbXHNBx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 21:53:59 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:26092 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863AbXHNBx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 21:53:57 -0400
Date: Mon, 13 Aug 2007 21:50:28 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates against ~v2.6.23-rc2-git
Message-ID: <20070814015028.GA7748@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get four bugfixes.  This takes care of all known hwmon regressions, and
hopefully it's the last you'll hear from me before v2.6.23 goes final.

This patch series was also posted to the lm-sensors list yesterday:
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-August/020843.html

Thanks & regards,

 drivers/hwmon/smsc47m1.c  |    2 +
 drivers/hwmon/w83627ehf.c |   56 +++++++++++++++++++++++++-------------------
 drivers/hwmon/w83781d.c   |    4 +-
 3 files changed, 36 insertions(+), 26 deletions(-)

Jean Delvare (2):
      hwmon: (w83627ehf) don't assume bank 0
      hwmon: (smsc47m1) restore missing name attribute

Mark M. Hoffman (2):
      hwmon: fix w83781d temp sensor type setting
      hwmon: (w83627ehf) read fan_div values during probe

-- 
Mark M. Hoffman
mhoffman@lightlink.com

