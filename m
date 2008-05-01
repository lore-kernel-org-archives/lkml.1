Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYEAMYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYEAMYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYEAMXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:23:55 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:20624 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbYEAMXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:23:55 -0400
X-Greylist: delayed 1332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 08:23:54 EDT
Date: Thu, 1 May 2008 07:58:12 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lm-sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PATCH] hwmon update against v2.6.25
Message-ID: <20080501115812.GJ6034@mars.solarsys.private>
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

You'll get a relatively small number of minor changes, all of which have been
in -next for many weeks.

Also, there is a larger pile of changes queued in my email, most of which have
been reviewed by other hwmon contributors even.  It is absolutely my fault for
not getting through this pile by now.  To all hwmon contributors, I apologize.
I have done a crappy job as maintainer this past month.

Linus: I'll ask you to pull again between rc1 and rc2, in order to kill that
backlog.  However, I understand if you choose to reject that request.

Thanks & regards,

 Documentation/hwmon/w83l785ts |    3 +-
 drivers/hwmon/adt7473.c       |   45 +++++++++++++++++++++---------------------
 drivers/hwmon/asb100.c        |    4 ---
 drivers/hwmon/lm75.c          |    5 ----
 drivers/hwmon/smsc47b397.c    |   17 +++++++++++++--
 drivers/hwmon/w83793.c        |   26 +++++++++++++-----------
 drivers/hwmon/w83l785ts.c     |    4 +--
 7 files changed, 56 insertions(+), 48 deletions(-)

Craig Kelley (1):
      hwmon: (smsc47b397) add a new chip id (0x8c)

Jean Delvare (3):
      hwmon: (w83l785ts) Don't ask the user to report failures
      hwmon: (w83793) VID and VRM handling cleanups
      hwmon: (lm75) Fix an incorrect comment

Mark M. Hoffman (3):
      hwmon: (asb100) Remove some dead code
      hwmon: (adt7473) minor cleanup / refactoring
      Merge branch 'smsc47b397-new-id' into release

-- 
Mark M. Hoffman
mhoffman@lightlink.com

