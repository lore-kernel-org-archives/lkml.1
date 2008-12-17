Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752052AbYLQT3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbYLQT3W (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbYLQT2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:28:45 -0500
Received: from kroah.org ([198.145.64.141]:54230 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751217AbYLQT2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:28:43 -0500
Date: Wed, 17 Dec 2008 11:27:44 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081217192744.GB24641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB patches for your 2.6-git tree.

These patches are:
	- new device ids for some USB drivers
	- documentation updates to reflect changes made in previous
	  2.6.28-rc releases
	- broken usb device fix for when using libusb
	- other minor USB fixes.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/usb/gadget_serial.txt   |    4 +-
 Documentation/usb/proc_usb_info.txt   |    6 ++-
 Documentation/usb/usbmon.txt          |   12 ++++---
 drivers/usb/class/usbtmc.c            |    1 +
 drivers/usb/core/driver.c             |    4 ++-
 drivers/usb/gadget/f_rndis.c          |    4 ++
 drivers/usb/serial/ftdi_sio.c         |    2 +
 drivers/usb/serial/ftdi_sio.h         |    6 +++
 drivers/usb/serial/pl2303.c           |    2 +
 drivers/usb/serial/pl2303.h           |    8 +++++
 drivers/usb/serial/ti_usb_3410_5052.c |   55 ++-------------------------------
 drivers/usb/storage/unusual_devs.h    |   16 +++++++++-
 include/linux/usb/ch9.h               |    8 +++-
 13 files changed, 63 insertions(+), 65 deletions(-)

---------------

Alan Cox (1):
      USB: tty: SprogII DCC controller identifiers

Alan Stern (2):
      usb-storage: update unusual_devs entry for Nokia 5310
      USB: skip Set-Interface(0) if already in altsetting 0

Andrew Ewert (1):
      USB: ftdi_sio: Adding Ewert Energy System's CANdapter PID

CSÉCSY László (1):
      USB: storage: unusual_devs.h: Nokia 3109c addition

David Brownell (1):
      USB: gadget: fix rndis working at high speed

Greg Kroah-Hartman (1):
      USB: fix problem with usbtmc driver not loading properly

Matthew Arnold (1):
      USB: add 5372:2303 to pl2303

Mike Provencher (1):
      USB: pl2303: add id for Hewlett-Packard LD220-HP POS pole display

Oliver Neukum (1):
      USB: set correct configuration in probe of ti_usb_3410_5052

Ozan Sener (1):
      USB: Unusual devs patch for Nokia 3500c

Pete Zaitcev (1):
      usbmon: drop bogus 0t from usbmon.txt

Peter Korsgaard (1):
      USB: Documentation/usb/gadget_serial.txt: update to match driver use_acm behaviour

Phil Endecott (1):
      USB: fix comment about endianness of descriptors

