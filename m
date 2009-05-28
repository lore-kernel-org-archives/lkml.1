Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZE1Xpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZE1Xpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbZE1Xpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:45:34 -0400
Received: from kroah.org ([198.145.64.141]:33544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZE1Xpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:45:34 -0400
Date: Thu, 28 May 2009 16:41:55 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core patches for 2.6.30-rc7
Message-ID: <20090528234155.GA10930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two driver-core patches for your 2.6.30-rc7 tree.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------


 drivers/base/bus.c    |    4 +++-
 drivers/base/core.c   |    5 ++++-
 drivers/base/driver.c |    4 ++++
 fs/sysfs/file.c       |    2 +-
 4 files changed, 12 insertions(+), 3 deletions(-)

---------------

Andrew Morton (1):
      sysfs: file.c: use create_singlethread_workqueue()

Kay Sievers (1):
      Driver Core: do not oops when driver_unregister() is called for unregistered drivers

