Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZLARrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZLARrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZLARrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:47:14 -0500
Received: from kroah.org ([198.145.64.141]:58558 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbZLARrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:47:11 -0500
Date: Tue, 1 Dec 2009 09:43:47 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING fixes for 2.6.32-git
Message-ID: <20091201174347.GC31972@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging fixes for your 2.6.32-git tree.

There's 2 hyper-v driver bugfixes, and 2 documentation updates (to the
TODO file, and to comments in the hyper-v driver.)

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/hv/BlkVsc.c      |    1 +
 drivers/staging/hv/Channel.c     |   16 ++++------------
 drivers/staging/hv/ChannelMgmt.c |    2 +-
 drivers/staging/hv/NetVsc.c      |    1 +
 drivers/staging/hv/NetVsc.h      |    1 +
 drivers/staging/hv/StorVsc.c     |   10 +++++-----
 drivers/staging/hv/blkvsc_drv.c  |    1 +
 drivers/staging/hv/netvsc_drv.c  |    1 +
 drivers/staging/rtl8187se/TODO   |    3 +--
 drivers/staging/rtl8192su/TODO   |    3 +--
 drivers/staging/vt6655/TODO      |    5 ++---
 drivers/staging/vt6656/TODO      |    5 ++---
 12 files changed, 21 insertions(+), 28 deletions(-)

---------------

Bartlomiej Zolnierkiewicz (1):
      Staging: update TODO files

Dave Jones (1):
      Staging: hv: Fix argument order in incorrect memset invocations in hyperv driver.

Haiyang Zhang (2):
      Staging: hv: Fix vmbus event handler bug
      Staging: hv: Fix some missing author names

