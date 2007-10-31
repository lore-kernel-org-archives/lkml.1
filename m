Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbXJaFKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbXJaFKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXJaFKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:10:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55668 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbXJaFKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:10:42 -0400
Date: Tue, 30 Oct 2007 22:09:54 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.24-rc1
Message-ID: <20071031050954.GA3791@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core bugfixes and tweaks for 2.6.24-rc1.  It fixes
the much-reported sysfs traceback when renaming network devices when
CONFIG_SYSFS_DEPRECATED is enabled.

There is also a documentation translation and typo fix, and some other
minor things.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/SubmittingPatches       |    4 +-
 Documentation/ja_JP/SubmittingPatches |  556 +++++++++++++++++++++++++++++++++
 drivers/base/class.c                  |   18 -
 drivers/base/core.c                   |    6 +-
 fs/sysfs/dir.c                        |    4 +-
 fs/sysfs/sysfs.h                      |    2 -
 include/linux/device.h                |    4 -
 lib/kobject.c                         |   13 +
 8 files changed, 576 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ja_JP/SubmittingPatches

---------------

Adrian Bunk (1):
      sysfs: make sysfs_{get,put}_active() static

Greg Kroah-Hartman (2):
      Driver core: remove class_device_*_bin_file
      kobject: check for duplicate names in kobject_rename

Kay Sievers (1):
      Driver Core: fix bug in device_rename() for SYSFS_DEPRECATED=y

Keiichi Kii (2):
      fix typo in SubmittingPatches
      add SubmittingPatches to Documentation/ja_JP

