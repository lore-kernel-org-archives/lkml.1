Return-Path: <linux-kernel-owner+w=401wt.eu-S1762699AbYENRuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762699AbYENRuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 13:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYENRtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 13:49:51 -0400
Received: from mail.suse.de ([195.135.220.2]:55701 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758912AbYENRtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 13:49:50 -0400
Date: Wed, 14 May 2008 10:49:20 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] driver core fixes against 2.6.26-rc2
Message-ID: <20080514174920.GA25856@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two patches against your 2.6.26-rc2-git tree.

They do:
	- remove an unused list head in struct class now that struct
	  class_device is gone.
	- fix a bug at boot time with raid partitions.  This is a
	  regression from 2.6.24 that is now finally fixed.  Many thanks
	  to Kay for doing this work.  It will be added to the
	  2.6.25-stable tree as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Both of these patches have been in the -next and -mm trees for a while.

The patch will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 block/genhd.c          |    9 ++++++---
 drivers/base/class.c   |    1 -
 include/linux/device.h |    1 -
 include/linux/genhd.h  |    4 ++--
 init/do_mounts.c       |   27 ++++++++++++++++++++++++++-
 5 files changed, 34 insertions(+), 8 deletions(-)

---------------

Dave Young (1):
      Driver core: struct class remove children list

Kay Sievers (1):
      block: do_mounts - accept root=<non-existant partition>

