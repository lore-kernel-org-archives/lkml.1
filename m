Return-Path: <linux-kernel-owner+w=401wt.eu-S1946297AbXBPXhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946297AbXBPXhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946303AbXBPXhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:37:24 -0500
Received: from mail.suse.de ([195.135.220.2]:39366 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946297AbXBPXhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:37:11 -0500
Date: Fri, 16 Feb 2007 15:35:53 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] more Driver core patches for 2.6.20
Message-ID: <20070216233553.GC14708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more driver core and debugfs patches and a serial port
device id addition for 2.6.20-git.

All of these have been in the -mm tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

 drivers/base/bus.c          |   22 ++++----
 drivers/base/class.c        |    3 +-
 drivers/pcmcia/at91_cf.c    |    2 +-
 drivers/pcmcia/soc_common.c |    8 ++--
 drivers/serial/serial_cs.c  |    5 ++
 fs/debugfs/file.c           |   12 ++++
 fs/debugfs/inode.c          |   82 ++++++++++++++++++++++++++----
 fs/partitions/check.c       |    9 +--
 include/linux/debugfs.h     |   10 ++++
 include/linux/device.h      |    1 +
 include/linux/kmod.h        |    2 +
 include/linux/module.h      |   53 ++++++++++++++++---
 include/linux/moduleparam.h |   12 ++++
 include/pcmcia/ciscode.h    |    1 +
 kernel/kmod.c               |  120 +++++++++++++++++++++++++++++++++++++++++++
 kernel/module.c             |   47 ++++++++++-------
 kernel/params.c             |   29 ++++++-----
 lib/kobject.c               |    2 +-
 18 files changed, 343 insertions(+), 77 deletions(-)

---------------

Alexey Dobriyan (1):
      pcmcia: some class_device fallout

Andrew Morton (1):
      Driver core: device_add_attrs() cleanup

Cornelia Huck (1):
      debugfs: Remove misleading comments.

Greg Kroah-Hartman (1):
      Driver.h copyright update

Kay Sievers (1):
      Driver core: let request_module() send a /sys/modules/kmod/-uevent

Mariusz Kozlowski (1):
      Driver: remove redundant kobject_unregister checks

Martin Stoilov (1):
      kobject: kobj->k_name verification fix

Peter Oberparleiter (1):
      debugfs: implement symbolic links

Randy Dunlap (1):
      sysfs: fix build errors: uevent with CONFIG_SYSFS=n

Sergei Organov (1):
      serial: Add PCMCIA IDs for Quatech DSP-100 dual RS232 adapter.

