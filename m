Return-Path: <linux-kernel-owner+w=401wt.eu-S934520AbZJNXIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934520AbZJNXIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762128AbZJNXIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:08:09 -0400
Received: from kroah.org ([198.145.64.141]:41605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761137AbZJNXII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:08:08 -0400
Date: Wed, 14 Oct 2009 16:04:32 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes for 2.6.32-git
Message-ID: <20091014230432.GB8865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 2 bugfixes for the driver core code for your .32 git tree.

They do:
	- fix sysfs_move_dir()
	- fix sysfs interrupt context issue that was being triggered by
	  users.


Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

All of these patches have been in the linux-next and mm trees for a
long time.

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 fs/sysfs/dir.c  |    3 ++-
 fs/sysfs/file.c |   14 ++++++++------
 2 files changed, 10 insertions(+), 7 deletions(-)

---------------

Cornelia Huck (1):
      sysfs: Allow sysfs_move_dir(..., NULL) again.

Neil Brown (1):
      sysfs: Allow sysfs_notify_dirent to be called from interrupt context.

