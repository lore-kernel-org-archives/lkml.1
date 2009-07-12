Return-Path: <linux-kernel-owner+w=401wt.eu-S1753001AbZGLWkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbZGLWkv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 18:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbZGLWkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 18:40:19 -0400
Received: from kroah.org ([198.145.64.141]:34689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbZGLWj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 18:39:57 -0400
Date: Sun, 12 Jul 2009 15:37:26 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] STAGING fixes for 2.6.31-rc2-git tree
Message-ID: <20090712223726.GC16600@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few patches for the drivers/staging/ section of the kernel,
for your git tree.

The majority are fixes for things that people have reported, and now
there should not be any build errors for this portion of the tree.  If
anyone still has any problems, please let me know.

There are also a few new device ids that people have reported as working
as well.

All of these are contained within the drivers/staging tree, and have
been in the linux-next and -mm trees for a while now.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

thanks,

greg k-h

--------------

 drivers/staging/comedi/drivers/jr3_pci.c           |    2 +
 drivers/staging/comedi/drivers/s626.c              |   35 +++++++++++--------
 drivers/staging/meilhaus/TODO                      |    2 +-
 drivers/staging/rspiusb/rspiusb.c                  |   14 ++------
 drivers/staging/rt2870/rt2870.h                    |    1 +
 .../rtl8187se/ieee80211/ieee80211_softmac_wx.c     |   12 +++---
 drivers/staging/rtl8192su/Kconfig                  |    2 +-
 .../staging/rtl8192su/ieee80211/ieee80211_module.c |    1 -
 .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |   14 ++++----
 drivers/staging/rtl8192su/r8192U_core.c            |   23 ++++++++-----
 drivers/staging/rtl8192su/r8192U_pm.c              |    8 +++-
 drivers/staging/serqt_usb2/serqt_usb2.c            |    8 +++--
 drivers/staging/stlc45xx/stlc45xx.c                |   27 ++++-----------
 drivers/staging/vt6655/device_main.c               |   10 +++---
 14 files changed, 80 insertions(+), 79 deletions(-)

---------------

Alan Cox (1):
      Staging: vt6655: compile fix

Alexander Beregalov (2):
      Staging: comedi: jr3_pci.c: add required includes
      Staging: stlc45xx: convert config_interface to bss_info_changed, fixing a build error

Bartlomiej Zolnierkiewicz (1):
      Staging: rtl8192su: convert to net_device_ops

Bill Pemberton (2):
      Staging: serqt_usb2: fix qt_close parameters in serqt_usb2
      Staging: serqt_usb2: declare qt_open static in serqt_usb2

Dan Aloni (2):
      Staging: prevent rtl8187se from crashing dev_ioctl() in SIOCGIWNAME
      Staging: prevent rtl8192su from crashing dev_ioctl in SIOCGIWNAME

Greg Kroah-Hartman (1):
      Staging: meilhaus: add email address to TODO

Herton Ronaldo Krzesinski (1):
      Staging: comedi: s626: use subvendor:subdevice ids for SAA7146 board

Jorrit Schippers (1):
      Staging: rt2870: Add USB ID for Sitecom WL-608

Pete Zaitcev (1):
      Staging: rspiusb: use NULL virtual address instead of a bogus one

