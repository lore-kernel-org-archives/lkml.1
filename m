Return-Path: <linux-kernel-owner+w=401wt.eu-S934046AbYBBXqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046AbYBBXqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764314AbYBBXqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:46:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764072AbYBBXqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:46:05 -0500
Date: Sat, 2 Feb 2008 15:43:57 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Frank Seidel <fseidel@suse.de>, Dave Young <hidave.darkstar@gmail.com>,
       Tsugikazu Shibata <tshibata@ab.jp.nec.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: [GIT PATCH] driver core fixes against 2.6.24-git
Message-ID: <20080202234357.GA21721@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 10 patches against your current git tree that fix some more build
issues (with CONFIG_SYSFS=n), update some documentation, and refresh the
nozomi driver with some fixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 Documentation/driver-model/platform.txt     |    6 +-
 Documentation/ja_JP/stable_kernel_rules.txt |   79 ++++++++++++
 drivers/base/core.c                         |   40 ++----
 drivers/base/driver.c                       |    9 +-
 drivers/base/power/main.c                   |    1 +
 drivers/base/power/power.h                  |    1 -
 drivers/char/nozomi.c                       |  172 +++++++++-----------------
 include/linux/device.h                      |    6 +
 kernel/Makefile                             |    3 +-
 lib/kobject.c                               |    2 +-
 10 files changed, 167 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/ja_JP/stable_kernel_rules.txt

---------------

Cornelia Huck (1):
      Driver core: Remove unneeded get_{device,driver}() calls.

Dave Young (2):
      kobject: kerneldoc comment fix
      driver core: convert to use class_find_device api

Frank Seidel (2):
      nozomi driver update
      nozomi: finish constification

Jan Engelhardt (1):
      nozomi: constify driver

Paul Mundt (1):
      kobject: Always build in kernel/ksysfs.o.

Rafael J. Wysocki (1):
      PM: Export device_pm_schedule_removal

Stephen Rothwell (1):
      Driver core: Update some prototypes in platform.txt

Tsugikazu Shibata (1):
      Add ja_JP translation of stable_kernel_rules.txt

