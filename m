Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbZAIXVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbZAIXVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760244AbZAIXV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:21:27 -0500
Received: from kroah.org ([198.145.64.141]:54577 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759702AbZAIXVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:21:25 -0500
Date: Fri, 9 Jan 2009 15:20:21 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [GIT PATCH] driver core fixes for your 2.6-git tree
Message-ID: <20090109232021.GA10007@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 4 reverts of patches that were previously pulled into your git
tree.  They revert the ability for the driver core to have a private
area in struct device.

Thanks to Stefan Richter for pointing out the problems with the current
implementation, and for Alan Cox persuading me to rework the whole
thing, which I will do for the 2.6.30 release.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-core-2.6.git/

The patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h

------------

 drivers/base/base.h    |   26 --------------------------
 drivers/base/bus.c     |   40 +++++++++++++---------------------------
 drivers/base/core.c    |   45 +++++++++++++--------------------------------
 drivers/base/dd.c      |   13 +++++--------
 drivers/base/driver.c  |   13 +++----------
 include/linux/device.h |    7 ++++---
 6 files changed, 38 insertions(+), 106 deletions(-)

---------------

Greg Kroah-Hartman (4):
      Revert "driver core: move knode_bus into private structure"
      Revert "driver core: move knode_driver into private structure"
      Revert "driver core: move klist_children into private structure"
      Revert "driver core: create a private portion of struct device"

