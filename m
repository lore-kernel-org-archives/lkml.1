Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXK1WtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXK1WtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 17:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757726AbXK1Ws4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 17:48:56 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55018 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715AbXK1Ws4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 17:48:56 -0500
Date: Wed, 28 Nov 2007 14:47:46 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.24-rc3
Message-ID: <20071128224746.GA28410@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core bugfixes and documentation updates for
2.6.24-rc3.  It fixes a regression with CONFIG_PM being set and not set
that people have reported.

There's some other minor fixes, and an update for the UIO documentation.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/DocBook/Makefile       |    2 +-
 Documentation/DocBook/uio-howto.tmpl |   90 ++++++++++++----------------------
 drivers/base/core.c                  |    4 +-
 drivers/base/power/Makefile          |    3 +-
 drivers/base/power/main.c            |    8 +---
 drivers/base/power/power.h           |   28 ++++++++---
 drivers/char/Kconfig                 |    2 +-
 fs/sysfs/file.c                      |    6 ++-
 lib/kobject.c                        |    4 +-
 9 files changed, 68 insertions(+), 79 deletions(-)

---------------

Daniel Drake (1):
      create /sys/.../power when CONFIG_PM is set

Hans J Koch (2):
      UIO: fix up the UIO documentation
      UIO: add UIO documentation target to DocBook Makefile

Johannes Berg (1):
      kobject: two typo fixes

Kay Sievers (1):
      allow LEGACY_PTYS to be set to 0

Miao Xie (1):
      sysfs: fix off-by-one error in fill_read_buffer()

