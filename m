Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZLWTuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZLWTuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755566AbZLWTu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:50:28 -0500
Received: from kroah.org ([198.145.64.141]:39855 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753576AbZLWTu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:50:27 -0500
Date: Wed, 23 Dec 2009 11:49:55 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.33-git
Message-ID: <20091223194955.GB18101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some 2.6.33-rc1 patches for the driver core:

Nothing major here:
	- fixes for devtmpfs warnings on lockdep and command line
	  options
	- documentation updates
	- api change to make attributes const.  This is added now so
	  that subsystem maintainers can queue up patches for .34.  This
	  was submitted now at the recommendation of Stephen Rothwell.
	- stable kernel rules clarification in the documentation

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/driver-model/driver.txt |    4 ++--
 Documentation/filesystems/sysfs.txt   |   12 ++++++------
 Documentation/stable_kernel_rules.txt |   24 ++++++++++++++++++++++--
 drivers/base/bus.c                    |    2 +-
 drivers/base/core.c                   |   16 +++++++++++-----
 drivers/base/devtmpfs.c               |   19 ++++++++++---------
 drivers/base/driver.c                 |    4 ++--
 drivers/base/platform.c               |    1 +
 fs/super.c                            |    3 ++-
 fs/sysfs/bin.c                        |    6 ++++--
 include/linux/device.h                |   12 ++++++------
 include/linux/sysfs.h                 |    9 +++++----
 12 files changed, 72 insertions(+), 40 deletions(-)

---------------

Kay Sievers (2):
      vfs: get_sb_single() - do not pass options twice
      devtmpfs: unlock mutex in case of string allocation error

Michael Hennerich (1):
      Driver core: export platform_device_register_data as a GPL symbol

Phil Carmody (4):
      Driver core: device_attribute parameters can often be const*
      Driver core: bin_attribute parameters can often be const*
      Driver core: driver_attribute parameters can often be const*
      driver core: Prevent reference to freed memory on error path

Sebastian Andrzej Siewior (1):
      Doc/stable rules: add new cherry-pick logic

Thomas Gleixner (2):
      devtmpfs: Convert dirlock to a mutex
      Driver-core: Fix bogus 0 error return in device_add()

