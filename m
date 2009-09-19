Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZISVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZISVd7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbZISVd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:33:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:39574 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbZISVd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:33:58 -0400
Date: Sat, 19 Sep 2009 14:33:32 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [GIT PATCH] driver core patch for 2.6.31-git
Message-ID: <20090919213332.GA7668@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is one driver core patch

It fixes the problem that Ingo found with devtmpfs and makes it so
that a user can boot a kernel using devtmpfs and no version of udev
on the system, making this option a much more useful thing.

Thanks to Ingo for reporting and testing this, and for Eric's review
comments, which Kay has made in this patch as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patch will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------


 arch/x86/kernel/cpuid.c             |    4 ++--
 arch/x86/kernel/microcode_core.c    |    2 +-
 arch/x86/kernel/msr.c               |    4 ++--
 block/bsg.c                         |    4 ++--
 block/genhd.c                       |    8 ++++----
 drivers/base/core.c                 |   19 ++++++++++++-------
 drivers/base/devtmpfs.c             |   24 ++++++++++++++++--------
 drivers/block/aoe/aoechr.c          |    4 ++--
 drivers/block/pktcdvd.c             |    6 +++---
 drivers/char/hw_random/core.c       |    2 +-
 drivers/char/mem.c                  |   29 +++++++++++++++++++----------
 drivers/char/misc.c                 |   10 ++++++----
 drivers/char/raw.c                  |    4 ++--
 drivers/char/tty_io.c               |   11 +++++++++++
 drivers/gpu/drm/drm_sysfs.c         |    4 ++--
 drivers/hid/usbhid/hiddev.c         |    4 ++--
 drivers/input/input.c               |    4 ++--
 drivers/md/dm-ioctl.c               |    2 +-
 drivers/media/dvb/dvb-core/dvbdev.c |    4 ++--
 drivers/net/tun.c                   |    2 +-
 drivers/usb/class/usblp.c           |    4 ++--
 drivers/usb/core/file.c             |    8 ++++----
 drivers/usb/core/usb.c              |    4 ++--
 drivers/usb/misc/iowarrior.c        |    4 ++--
 drivers/usb/misc/legousbtower.c     |    4 ++--
 include/linux/device.h              |    7 ++++---
 include/linux/genhd.h               |    2 +-
 include/linux/miscdevice.h          |    3 ++-
 include/linux/usb.h                 |    4 ++--
 sound/sound_core.c                  |    4 ++--
 30 files changed, 116 insertions(+), 79 deletions(-)

---------------

Kay Sievers (1):
      Driver-Core: extend devnode callbacks to provide permissions

