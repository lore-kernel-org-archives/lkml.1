Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbXFLXWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbXFLXWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 19:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbXFLXWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 19:22:34 -0400
Received: from ns.suse.de ([195.135.220.2]:48685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbXFLXWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 19:22:33 -0400
Date: Tue, 12 Jun 2007 16:21:59 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, htejun@gmail.com, sandeen@sandeen.net
Subject: [GIT PATCH] sysfs fixes for 2.6.22-rc4
Message-ID: <20070612232159.GA12971@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some sysfs fixes for 2.6.22-rc4

They are based on a set of patches from Tejun that have been in the -mm
tree for a while and fix a nasty sysfs problem that people have been
hitting in the real world (Google has hit this a lot and spent a lot of
time and effort in tracking this down, I'd really like to say thanks for
the help here.)

Tejun and Eric have backported a small set of patches that fix this for
your current tree, with the larger, more intrusive patches queued up for
after 2.6.22 is out.

Tejun and I have beat on these patches a lot and have not found any
problems.  I know it's late in the series for them, but under the
circumstances, it seems reasonable.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 fs/sysfs/dir.c   |   38 +++++++++++++++++++++++++++++++-------
 fs/sysfs/inode.c |   21 +++++++++++++++++++--
 fs/sysfs/mount.c |    1 +
 fs/sysfs/sysfs.h |    2 ++
 4 files changed, 53 insertions(+), 9 deletions(-)

---------------

Eric Sandeen (1):
      sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses

Tejun Heo (2):
      sysfs: fix condition check in sysfs_drop_dentry()
      sysfs: fix race condition around sd->s_dentry, take#2

