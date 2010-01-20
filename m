Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423Ab0ATXtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab0ATXtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:49:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752867Ab0ATXs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:48:57 -0500
Received: from kroah.org ([198.145.64.141]:33550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab0ATXs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:48:56 -0500
Date: Wed, 20 Jan 2010 15:47:49 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.33-rc4
Message-ID: <20100120234749.GA32068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for the 2.6.33-rc4 tree.

They consist of a number of bug fixes, with some new device ids as well.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/devices.c         |    2 +-
 drivers/usb/core/hcd.c             |   18 ++++++++++++++++++
 drivers/usb/core/hub.c             |   18 ++++++++----------
 drivers/usb/core/message.c         |    8 ++++----
 drivers/usb/core/sysfs.c           |    6 ++++++
 drivers/usb/host/ehci-hcd.c        |    5 +++--
 drivers/usb/host/ehci-hub.c        |   20 +++++++++++++++++++-
 drivers/usb/host/ehci-q.c          |   11 ++++++++---
 drivers/usb/host/fhci-hcd.c        |    3 ++-
 drivers/usb/host/isp1362-hcd.c     |   25 ++++++++++++++++---------
 drivers/usb/host/isp1760-hcd.c     |    6 +++---
 drivers/usb/host/uhci-hcd.c        |   15 ++++++++++++++-
 drivers/usb/host/uhci-hub.c        |    2 +-
 drivers/usb/serial/generic.c       |   10 ++++++----
 drivers/usb/storage/unusual_devs.h |    7 -------
 drivers/usb/storage/usb.c          |    3 ++-
 include/linux/usb.h                |    1 +
 17 files changed, 112 insertions(+), 48 deletions(-)

---------------

Alan Stern (4):
      USB: fix bitmask merge error
      USB: EHCI: fix handling of unusual interrupt intervals
      USB: EHCI & UHCI: fix race between root-hub suspend and port resume
      USB: add missing delay during remote wakeup

Alexander Beregalov (1):
      USB: FHCI: avoid NULL pointer dereference

Colin Tuckley (1):
      USB: Fix level of isp1760 Reloading ptd error message

Greg Kroah-Hartman (1):
      USB: add speed values for USB 3.0 and wireless controllers

Johan Hovold (1):
      usb: serial: fix memory leak in generic driver

Lothar Wassmann (2):
      USB: isp1362: better 64bit printf warning fixes
      USB: isp1362: fix build failure on ARM systems via irq_flags cleanup

Oliver Neukum (1):
      USB: Don't use GFP_KERNEL while we cannot reset a storage device

Ryan May (1):
      USB: fix usbstorage for 2770:915d delivers no FAT

Sarah Sharp (1):
      USB: Fix duplicate sysfs problem after device reset.

Stefani Seibold (1):
      USB: serial: fix USB serial fix kfifo_len locking

