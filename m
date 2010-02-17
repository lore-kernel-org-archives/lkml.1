Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab0BQAD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:03:56 -0500
Received: from kroah.org ([198.145.64.141]:38513 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933598Ab0BQACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:02:43 -0500
Date: Tue, 16 Feb 2010 16:02:06 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.33-rc8
Message-ID: <20100217000206.GB31137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two 2.6.33-rc8 patches for the driver core:

They fix:
	- memory leak fix for when struct class is removed from the
	  system.
	- regression fix for sysfs loosing their attributes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

Both of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for
people to see.

thanks,

greg k-h

------------

 drivers/base/class.c |    2 ++
 fs/sysfs/inode.c     |   35 +++++++++++++++++------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

---------------

Eric W. Biederman (1):
      sysfs: sysfs_sd_setattr set iattrs unconditionally

Laurent Pinchart (1):
      class: Free the class private data in class_release

