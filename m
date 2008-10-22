Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbYJVR0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbYJVR0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbYJVRZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:25:43 -0400
Received: from kroah.org ([198.145.64.141]:56929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754660AbYJVRZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:25:42 -0400
Date: Wed, 22 Oct 2008 10:22:11 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] more USB patches for 2.6-git
Message-ID: <20081022172211.GB4000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few remaining USB patches for your 2.6-git tree.

These paches are:
	- a remaining ohci patch that needed a build fix before it could
	  be included (that's why it missed the last round of patches)
	- new device id updates / quirks
	- bugfixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/Kconfig                |    3 +-
 drivers/usb/atm/speedtch.c         |   12 ++
 drivers/usb/class/cdc-acm.c        |    3 +-
 drivers/usb/class/cdc-wdm.c        |    2 +
 drivers/usb/core/driver.c          |    3 +-
 drivers/usb/core/hub.c             |    2 +-
 drivers/usb/gadget/config.c        |    2 +-
 drivers/usb/gadget/pxa27x_udc.c    |    2 +-
 drivers/usb/gadget/s3c2410_udc.c   |    7 +-
 drivers/usb/host/Kconfig           |    1 -
 drivers/usb/host/ohci-hcd.c        |   21 ++
 drivers/usb/host/ohci-tmio.c       |  376 ++++++++++++++++++++++++++++++++++++
 drivers/usb/misc/usbtest.c         |    3 +-
 drivers/usb/serial/option.c        |   96 +++++++++
 drivers/usb/storage/initializers.c |    3 +-
 drivers/usb/storage/unusual_devs.h |  291 ++++++++++++++++++++++++++--
 16 files changed, 792 insertions(+), 35 deletions(-)
 create mode 100644 drivers/usb/host/ohci-tmio.c

---------------

Alan Stern (2):
      USB: Speedtouch: add pre_reset and post_reset routines
      USB: don't rebind drivers after failed resume or reset

Dmitry Baryshkov (1):
      USB: ohci: add support for tmio-ohci cell

Frédéric Marchal (1):
      USB: Unusual dev for Mio moov 330 gps

Mikhail Gusarov (1):
      USB: add ZTE MF626 USB GSM modem entry

Oliver Neukum (2):
      USB: cdc-wdm: make module autoload work
      USB: fix memory leak in cdc-acm

Phil Dibowitz (1):
      USB: storage: Avoid I/O errors when issuing SCSI ioctls to JMicron USB/ATA bridge

Randy Dunlap (1):
      usb/gadget: fix kernel-doc warning

Robert Jarzmik (1):
      USB: Fix unneeded endpoint check in pxa27x_udc

Zhaolei (1):
      USB: Fix debugfs_create_file's error checking method for usb/gadget/s3c2410_udc

fangxiaozhi (1):
      USB: support Huawei data card product IDs

roel kluin (1):
      USB: usbtest.c: length, sglen and vary are unsigned, so cannot be negative

