Return-Path: <linux-kernel-owner+w=401wt.eu-S1757220AbZCQVIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220AbZCQVIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 17:08:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756324AbZCQVH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 17:07:56 -0400
Received: from kroah.org ([198.145.64.141]:39595 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754240AbZCQVHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 17:07:55 -0400
Date: Tue, 17 Mar 2009 14:05:32 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090317210532.GA4634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for your 2.6-git tree.

Just a bunch of bugfixes and new device ids.  The EHCI and usbfs and
usbtmc bugs are being reported by users as problems, the others are
minor ones.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/atm/cxacru.c           |    3 ++-
 drivers/usb/class/usbtmc.c         |    4 +++-
 drivers/usb/core/devio.c           |   12 +++++++-----
 drivers/usb/host/ehci-q.c          |    3 ++-
 drivers/usb/host/ehci-sched.c      |   10 ++++------
 drivers/usb/image/mdc800.c         |    1 +
 drivers/usb/misc/adutux.c          |    6 +++---
 drivers/usb/misc/vstusb.c          |    1 +
 drivers/usb/serial/cp2101.c        |    1 +
 drivers/usb/serial/ftdi_sio.c      |    5 +++++
 drivers/usb/serial/ftdi_sio.h      |   20 ++++++++++++++++++++
 drivers/usb/serial/option.c        |   14 ++++++--------
 drivers/usb/storage/unusual_devs.h |   16 ++++++++++++++--
 drivers/usb/wusbcore/wa-xfer.c     |    4 +++-
 14 files changed, 72 insertions(+), 28 deletions(-)

---------------

Achilleas Kotsis (1):
      USB: Add device id for Option GTM380 to option driver

Alan Stern (2):
      USB: usbfs: keep async URBs until the device file is closed
      USB: EHCI: expedite unlinks when the root hub is suspended

Albert Pauw (1):
      USB: option.c: add ZTE 622 modem device

Axel Wachtler (1):
      USB: serial: add FTDI USB/Serial converter devices

Dan Williams (1):
      USB: Option: let cdc-acm handle Sony Ericsson F3507g / Dell 5530

Dirk Hohndel (1):
      USB: Add Vendor/Product ID for new CDMA U727 to option driver

Greg Kroah-Hartman (2):
      USB: usbtmc: fix stupid bug in open()
      USB: usbtmc: add protocol 1 support

Jan Dumon (1):
      USB: unusual_devs: Add support for GI 0431 SD-Card interface

Jiri Slaby (5):
      USB: atm/cxacru, fix lock imbalance
      USB: image/mdc800, fix lock imbalance
      USB: misc/adutux, fix lock imbalance
      USB: misc/vstusb, fix lock imbalance
      USB: wusbcore/wa-xfer, fix lock imbalance

Karsten Wiese (1):
      USB: EHCI: Fix isochronous URB leak

Michael Hennerich (1):
      USB: serial: ftdi: enable UART detection on gnICE JTAG adaptors blacklist interface0

Moritz Muehlenhoff (1):
      USB: Updated unusual-devs entry for USB mass storage on Nokia 6233

Robert M. Kenney (1):
      USB: serial: new cp2101 device id

Thomas Bartosik (1):
      USB: storage: Unusual USB device Prolific 2507 variation added

