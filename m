Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbZEID25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbZEID25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZEID2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:28:15 -0400
Received: from kroah.org ([198.145.64.141]:41353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbZEID2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:28:13 -0400
Date: Fri, 8 May 2009 20:24:43 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING patches for 2.6.30-rc4 tree
Message-ID: <20090509032443.GC9000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some patches for your 2.6.30-rc4 git tree.

It contains:
	- a new device id.
	- documentation update to keep someone from getting unwanted
	  emails.
	- 2 bugfixes

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

thanks,

greg k-h

--------------

 drivers/staging/comedi/TODO            |    1 -
 drivers/staging/rt2870/rt2870.h        |    1 +
 drivers/staging/rtl8187se/r8180.h      |    2 +-
 drivers/staging/rtl8187se/r8180_core.c |   46 +++++--------------------------
 drivers/staging/winbond/wbusb.c        |    9 +++++-
 5 files changed, 17 insertions(+), 42 deletions(-)

---------------

Dave Hayes (1):
      Staging: rt2870: new device id

Greg Kroah-Hartman (1):
      Staging: comedi: David doesn't want to get comedi patches

Larry Finger (1):
      Staging: rtl8187se: Fix compilation warnings and procfs directory leak

Pekka Enberg (1):
      Staging: w35und: unregister device from the ieee80211 stack upon ->disconnect()

