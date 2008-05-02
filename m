Return-Path: <linux-kernel-owner+w=401wt.eu-S934910AbYEBRbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934910AbYEBRbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 13:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763712AbYEBRaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 13:30:52 -0400
Received: from ns1.suse.de ([195.135.220.2]:54416 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764022AbYEBRau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 13:30:50 -0400
Date: Fri, 2 May 2008 10:30:29 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.25-git
Message-ID: <20080502173029.GA12259@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more USB patches for your 2.6.25-git tree.

They include:
	- lots of tiny bugfixes
	- some new drivers
	- ub updates
	- device id updates

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 MAINTAINERS                        |    6 +
 drivers/block/ub.c                 |   63 +-
 drivers/usb/Makefile               |    2 +
 drivers/usb/atm/Kconfig            |    4 -
 drivers/usb/c67x00/Makefile        |    9 +
 drivers/usb/c67x00/c67x00-drv.c    |  243 ++++
 drivers/usb/c67x00/c67x00-hcd.c    |  412 ++++++
 drivers/usb/c67x00/c67x00-hcd.h    |  133 ++
 drivers/usb/c67x00/c67x00-ll-hpi.c |  480 +++++++
 drivers/usb/c67x00/c67x00-sched.c  | 1170 ++++++++++++++++++
 drivers/usb/c67x00/c67x00.h        |  294 +++++
 drivers/usb/core/message.c         |    4 +-
 drivers/usb/gadget/Kconfig         |   20 +
 drivers/usb/gadget/Makefile        |    1 +
 drivers/usb/gadget/ether.c         |    8 +-
 drivers/usb/gadget/file_storage.c  |   25 +-
 drivers/usb/gadget/pxa27x_udc.c    | 2404 ++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/pxa27x_udc.h    |  487 ++++++++
 drivers/usb/gadget/serial.c        |   90 ++-
 drivers/usb/gadget/zero.c          |  370 +++---
 drivers/usb/host/Kconfig           |   39 +
 drivers/usb/host/Makefile          |    4 +-
 drivers/usb/host/isp1760-hcd.c     | 2231 +++++++++++++++++++++++++++++++++
 drivers/usb/host/isp1760-hcd.h     |  206 +++
 drivers/usb/host/isp1760-if.c      |  298 +++++
 drivers/usb/host/ohci-hub.c        |    2 +-
 drivers/usb/host/uhci-hcd.c        |   74 +-
 drivers/usb/host/uhci-hcd.h        |    5 +-
 drivers/usb/misc/ldusb.c           |   28 +-
 drivers/usb/misc/usbtest.c         |  276 ++---
 drivers/usb/serial/aircable.c      |   98 +-
 drivers/usb/serial/airprime.c      |   63 +-
 drivers/usb/serial/ark3116.c       |   54 +-
 drivers/usb/serial/ch341.c         |    2 +-
 drivers/usb/serial/ftdi_sio.c      |    8 +
 drivers/usb/serial/ftdi_sio.h      |   11 +
 drivers/usb/serial/mos7840.c       |    5 +-
 drivers/usb/storage/Kconfig        |    3 +-
 drivers/usb/storage/libusual.c     |    2 +-
 drivers/usb/storage/onetouch.c     |    4 +-
 drivers/usb/storage/unusual_devs.h |   28 +-
 drivers/usb/storage/usb.c          |    3 +-
 include/linux/usb/c67x00.h         |   48 +
 include/linux/usb/ch9.h            |   12 +-
 include/linux/usb/gadget.h         |   21 +
 45 files changed, 9213 insertions(+), 537 deletions(-)
 create mode 100644 drivers/usb/c67x00/Makefile
 create mode 100644 drivers/usb/c67x00/c67x00-drv.c
 create mode 100644 drivers/usb/c67x00/c67x00-hcd.c
 create mode 100644 drivers/usb/c67x00/c67x00-hcd.h
 create mode 100644 drivers/usb/c67x00/c67x00-ll-hpi.c
 create mode 100644 drivers/usb/c67x00/c67x00-sched.c
 create mode 100644 drivers/usb/c67x00/c67x00.h
 create mode 100644 drivers/usb/gadget/pxa27x_udc.c
 create mode 100644 drivers/usb/gadget/pxa27x_udc.h
 create mode 100644 drivers/usb/host/isp1760-hcd.c
 create mode 100644 drivers/usb/host/isp1760-hcd.h
 create mode 100644 drivers/usb/host/isp1760-if.c
 create mode 100644 include/linux/usb/c67x00.h

---------------

Adrian Bunk (1):
      USB: storage/onetouch.c: make a function static

Alan Cox (1):
      usb_serial: some coding style fixes

Alan Stern (3):
      usb-storage: add unusual_devs entry for Samsung YP-U3
      USB: OHCI: work around bogus compiler warning
      USB: UHCI: disable remote wakeup when it's not needed

Andrew Lunn (2):
      USB: storage: UNUSUAL_DEVS() for PanDigital Picture frame.
      USB: storage: Update mailling list address

Daniel Walker (1):
      usb: ldusb: ld_usb semaphore to mutex

David Brownell (3):
      USB: usbtest displays diagnostics again
      usb serial gadget: CDC ACM fixes
      usb: gadget zero style fixups (mostly whitespace)

David Lopo (3):
      usb: gadget zero timer init fix
      USB GADGET/PERIPHERAL: g_file_storage Bulk-Only Transport compliance
      USB GADGET/PERIPHERAL: g_file_storage Bulk-Only Transport compliance, clear-feature ignore

Dmitry Torokhov (1):
      usb-storage: fix build failure in OneTouch driver

Leonardo Chiquitto (1):
      USB: airprime: unlock mutex instead of trying to lock it again

Pete Zaitcev (4):
      ub: Fix timeouts
      ub: Tune retries
      ub: Ignore bad residue
      ub: Cosmetics

Peter Korsgaard (3):
      USB: add Cypress c67x00 low level interface code
      USB: add Cypress c67x00 OTG controller core driver
      USB: add Cypress c67x00 OTG controller HCD driver

Peter Mack (1):
      USB: add more FTDI device ids

Robert Jarzmik (1):
      usb: pxa27x_udc driver

Robert P. J. Day (1):
      USB: Remove redundant dependencies on USB_ATM.

Roel Kluin (1):
      USB: mos7840: test and propagate set_uart_reg return value

Rohan Hart (1):
      USB: INTOVA Pixtreme camera mass storage device

Rusty Russell (1):
      usb: libusual kthread_run() called with wrong format.

Sarah Sharp (1):
      USB: Add the USB 2.0 extension descriptor.

Sebastian Siewior (1):
      USB: ISP1760 HCD driver

Yoshihiro Shimoda (1):
      USB: fix cannot work usb storage when using ohci-sm501

