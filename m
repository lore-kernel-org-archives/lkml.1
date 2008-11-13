Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbYKMXEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbYKMXEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 18:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbYKMXDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 18:03:48 -0500
Received: from kroah.org ([198.145.64.141]:51838 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752510AbYKMXDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 18:03:44 -0500
Date: Thu, 13 Nov 2008 15:02:59 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081113230259.GA3681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB patches for your 2.6-git tree.

These patches are:
	- lots of new device ids for different drivers
	- usb storage quirks
	- documentation fixes
	- ehci fixes
	- ps3 shutdown fix
	- musb driver fixes (this is the majority of these patches)
	- misc fixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/block/ub.c                  |   20 ++++-
 drivers/net/usb/asix.c              |    4 +
 drivers/usb/class/cdc-acm.c         |    9 +-
 drivers/usb/core/message.c          |    1 +
 drivers/usb/core/sysfs.c            |    2 +-
 drivers/usb/core/urb.c              |    4 +-
 drivers/usb/gadget/f_acm.c          |    4 +
 drivers/usb/host/Kconfig            |   23 ++----
 drivers/usb/host/ehci-hcd.c         |   25 +++---
 drivers/usb/host/ehci-ps3.c         |    1 +
 drivers/usb/host/ehci-sched.c       |    4 +-
 drivers/usb/host/isp1760-if.c       |   22 +++---
 drivers/usb/host/ohci-ps3.c         |    3 +-
 drivers/usb/host/r8a66597-hcd.c     |    5 +-
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 drivers/usb/misc/vstusb.c           |    2 +-
 drivers/usb/musb/musb_core.c        |    6 +-
 drivers/usb/musb/musb_debug.h       |    4 +-
 drivers/usb/musb/musb_host.c        |  159 ++++++++++++++++++++++-------------
 drivers/usb/musb/musb_host.h        |    1 +
 drivers/usb/musb/omap2430.c         |    2 +
 drivers/usb/musb/tusb6010.c         |    2 +-
 drivers/usb/serial/cp2101.c         |    2 +
 drivers/usb/serial/option.c         |    6 ++
 drivers/usb/storage/Kconfig         |    4 +-
 drivers/usb/storage/unusual_devs.h  |   22 +++++
 include/linux/usb.h                 |    2 +
 27 files changed, 218 insertions(+), 122 deletions(-)

---------------

Ajay Kumar Gupta (3):
      usb: musb: Fix for isochronous IN transfer
      usb: musb: Removes compilation warning in gadget mode
      usb: musb: fix BULK request on different available endpoints

Alan Stern (4):
      USB: don't register endpoints for interfaces that are going away
      USB: unusual_devs entry for Argosy USB mass-storage interface
      USB: EHCI: fix handling of dead controllers
      USB: EHCI: fix divide-by-zero bug

Albert Comerma (1):
      USB: SISUSB2VGA driver: add 0x0711, 0x0903

Brandon Philips (1):
      USB: cdc-acm.c: fix recursive lock in acm_start_wb error path

Craig Shelley (1):
      USB: CP2101 Add device ID for AMB2560

Damir N Abdullin (1):
      + usb-serial-cp2101-add-enfora-gsm2228.patch added to -mm tree

David Brownell (1):
      USB: gadget: cdc-acm deadlock fix

Felipe Balbi (2):
      usb: musb: tusb6010: kill compile warning
      usb: musb: fix debug global variable name

Geoff Levand (1):
      USB: Fix PS3 USB shutdown problems

Greg Kroah-Hartman (1):
      USB: vstusb: fix compiler warning on x86-64

Jason Cooper (1):
      USB: net: asix: add support for Cables-to-Go USB Ethernet adapter

Leslie Watter (1):
      USB: Add YISO u893 usb modem vendor and product IDs to option driver

Paul Bolle (1):
      USB: storage: adjust comment in Kconfig

Paul Ready (1):
      USB: add Nikon D300 camera to unusual_devs

Pete Zaitcev (1):
      ub: stub pre_reset and post_reset to fix oops

Rabin Vincent (1):
      USB: mention URB_FREE_BUFFER in usb_free_urb documentation

Ricky Wong (1):
      usb: unusual devs patch for Nokia 7610 Supernova

Sebastian Andrzej Siewior (1):
      USB: remove optional bus bindings in isp1760, fixing runtime warning

Yoshihiro Shimoda (1):
      usb: r8a66597-hcd: fix wrong data access in SuperH on-chip USB

