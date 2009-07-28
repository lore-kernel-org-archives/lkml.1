Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZG1Vjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZG1Vjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZG1Vjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:39:53 -0400
Received: from kroah.org ([198.145.64.141]:44376 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754983AbZG1Vjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:39:35 -0400
Date: Tue, 28 Jul 2009 14:38:26 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.31-rc4-git
Message-ID: <20090728213826.GC13090@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core patches for your tree.

Just some tiny bugfixes and a documentation fix.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/filesystems/sysfs.txt |    3 ++-
 drivers/base/firmware_class.c       |    1 -
 drivers/base/sys.c                  |    2 +-
 fs/sysfs/dir.c                      |    2 ++
 lib/dynamic_debug.c                 |    2 +-
 5 files changed, 6 insertions(+), 4 deletions(-)

---------------

Lucian Adrian Grijincu (1):
      driver core: documentation: make it clear that sysfs is optional

Ming Lei (1):
      driver core: firmware_class:fix memory leak of page pointers array

Peter Oberparleiter (1):
      sysfs: fix hardlink count on device_move

Roel Kluin (1):
      Dynamic debug: fix typo: -/->

Xiaotian Feng (1):
      driver core: sysdev: do not send KOBJ_ADD uevent if kobject_init_and_add fails

