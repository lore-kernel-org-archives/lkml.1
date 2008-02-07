Return-Path: <linux-kernel-owner+w=401wt.eu-S933134AbYBGUGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134AbYBGUGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933074AbYBGUDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:33 -0500
Received: from cantor.suse.de ([195.135.220.2]:37462 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057AbYBGUDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:30 -0500
Date: Thu, 7 Feb 2008 12:01:40 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       kay.sievers@vrfy.org, Michael_E_Brown@dell.com, rdreier@cisco.com,
       htejun@gmail.com
Subject: [GIT PATCH] driver core fixes against 2.6.24-git
Message-ID: <20080207200140.GA4572@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's 3 patches against your current git tree that fix some more
problems that have cropped up:
	- whole_disk attribute file causes oopses when read from.
	- the firmware class name change broke Dell machines that were
	  working just fine.
	- we shouldn't BUG on a programming error in sysfs by the
	  caller, do a WARN_ON instead.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/firmware_class.c |    3 ++-
 fs/partitions/check.c         |   17 ++++++++++-------
 fs/sysfs/group.c              |    7 ++++++-
 3 files changed, 18 insertions(+), 9 deletions(-)

---------------

Greg Kroah-Hartman (2):
      Block: Fix whole_disk attribute bug
      sysfs: remove BUG_ON() from sysfs_remove_group()

Michael E Brown (1):
      Driver core: Revert "Fix Firmware class name collision"

