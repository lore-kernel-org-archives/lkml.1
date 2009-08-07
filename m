Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbZHGX11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbZHGX11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 19:27:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZHGX1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 19:27:13 -0400
Received: from kroah.org ([198.145.64.141]:42916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993AbZHGX1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 19:27:11 -0400
Date: Fri, 7 Aug 2009 16:26:07 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.or
Subject: [GIT PATCH] STAGING fixes for 2.6.31-rc5-git tree
Message-ID: <20090807232607.GB31885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few patches for the drivers/staging/ section of the kernel,
for your git tree.

These patches do:
	- revert a change in the tree that broke a lot of users of the
	  rt2870 driver
	- build dependancy fixes
	- rtl8192su build error fix
	- new device id for rt2870
	- buffer overflow for rspiusb driver

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/b3dfg/Kconfig                      |    1 +
 drivers/staging/heci/Kconfig                       |    1 +
 drivers/staging/rspiusb/rspiusb.c                  |    2 +
 drivers/staging/rt2860/rt_linux.h                  |   13 +---
 drivers/staging/rt2870/2870_main_dev.c             |   67 +++++++++++++-------
 drivers/staging/rt2870/common/2870_rtmp_init.c     |   33 +++++-----
 drivers/staging/rt2870/common/rtusb_io.c           |    3 +-
 drivers/staging/rt2870/rt2870.h                    |    9 ++-
 drivers/staging/rtl8192su/ieee80211.h              |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211.h    |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    3 +-
 drivers/staging/rtl8192su/r8192U_core.c            |    2 +-
 12 files changed, 80 insertions(+), 58 deletions(-)

---------------

Greg Kroah-Hartman (1):
      Staging: rtl8192su: fix build error

Jakob Gruber (1):
      Staging: rt2870: Add USB ID for Linksys, Planex Communications, Belkin

Jeff Mahoney (1):
      staging: add dependencies on PCI for drivers that require it

Mike Galbraith (1):
      Staging: rt2870: Revert d44ca7 Removal of kernel_thread() API

Roel Kluin (1):
      Staging: rspiusb: Fix buffer overflow

