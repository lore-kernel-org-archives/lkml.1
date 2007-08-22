Return-Path: <linux-kernel-owner+w=401wt.eu-S932786AbXHVWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932786AbXHVWUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933402AbXHVWTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:19:40 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37068 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbXHVWTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:19:39 -0400
Date: Wed, 22 Aug 2007 15:07:47 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.23-rc3
Message-ID: <20070822220747.GA30603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core fixes and documentation updates against your
2.6.23-rc3 git tree.

They fix a reference counting bug in the module sysfs code, a fix for a
sysfs WARN_ON() issue and some documentation updates.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h



 Documentation/HOWTO             |    4 +-
 Documentation/SubmittingPatches |    2 +-
 Documentation/ko_KR/HOWTO       |  623 +++++++++++++++++++++++++++++++++++++++
 fs/sysfs/bin.c                  |    7 +-
 fs/sysfs/dir.c                  |   21 +-
 kernel/module.c                 |    3 +-
 6 files changed, 640 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/ko_KR/HOWTO

---------------

Alan Stern (1):
      sysfs: don't warn on removal of a nonexistent binary file

Alexey Dobriyan (1):
      Fix Off-by-one in /sys/module/*/refcnt

Minchan Kim (1):
      HOWTO: korean translation of Documentation/HOWTO

Qi Yong (1):
      HOWTO: latest lxr url address changed

Tejun Heo (1):
      sysfs: fix locking in sysfs_lookup() and sysfs_rename_dir()

