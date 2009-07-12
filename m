Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbZGLWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbZGLWkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbZGLWkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:40:06 -0400
Received: from kroah.org ([198.145.64.141]:34686 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZGLWj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:39:56 -0400
Date: Sun, 12 Jul 2009 15:37:18 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.31-rc2-git
Message-ID: <20090712223717.GB16600@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core patches for your tree.

All tiny stuff, fixing bugs, and finally removing the BUS_ID_SIZE define
that no longer is in use.

All of the non-driver-core touching patches have been sent to the
various subsystem maintainers and gotten acks for them with the
exception of the sparc change, which for some reason did not get an ack,
but was ignored.  As the patch is only hard coding the BUS_ID_SIZE
value, no functionalty is changed in the code at all.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/driver-model/driver.txt |    4 ++--
 arch/sparc/kernel/vio.c               |    7 ++++++-
 drivers/base/devres.c                 |    3 +++
 drivers/base/firmware_class.c         |    6 ++++--
 drivers/power/wm97xx_battery.c        |    4 ++--
 drivers/video/omap/omapfb_main.c      |   14 +++++++-------
 fs/partitions/check.c                 |    2 +-
 include/linux/device.h                |    2 --
 sound/soc/codecs/wm8988.c             |    4 ++--
 9 files changed, 27 insertions(+), 19 deletions(-)

---------------

Alexander Beregalov (1):
      wm97xx_batery: replace driver_data with dev_get_drvdata()

Benjamin Herrenschmidt (1):
      devres: WARN() and return, don't crash on device_del() of uninitialized device

Greg Kroah-Hartman (2):
      Sound: remove direct access of driver_data
      omap: video: remove direct access of driver_data

Heiko Carstens (1):
      partitions: fix broken uevent_suppress conversion

Jiri Slaby (1):
      Firmware: firmware_class, fix lock imbalance

Kay Sievers (2):
      sparc: remove driver-core BUS_ID_SIZE
      Driver Core: remove BUS_ID_SIZE

vibi sreenivasan (1):
      driver model: fix show/store prototypes in doc.

