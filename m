Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZEID2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZEID2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbZEID2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:28:13 -0400
Received: from kroah.org ([198.145.64.141]:41350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbZEID2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:28:12 -0400
Date: Fri, 8 May 2009 20:24:37 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.30-rc4
Message-ID: <20090509032437.GB9000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few driver-core patches for your 2.6.30-rc4 tree.

They revert 2 patches in the platform driver core that turned out to be
the wrong thing to do.  There is also some minor documentation patches,
and a Kconfig fix.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------


 Documentation/sysfs-rules.txt   |    2 +-
 drivers/base/platform.c         |   22 +++-------------------
 include/linux/device.h          |    9 ++-------
 include/linux/platform_device.h |    1 -
 lib/Kconfig.debug               |    1 -
 5 files changed, 6 insertions(+), 29 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Revert driver core: move platform_data into platform_device

Henrik Austad (1):
      Doc/sysfs-rules: Swap the order of the words so the sentence makes more sense

Jason Baron (1):
      Remove old PRINTK_DEBUG config item

Ming Lei (1):
      Revert driver core: fix passing platform_data

Randy Dunlap (1):
      Driver core: platform: fix kernel-doc warnings

