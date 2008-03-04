Return-Path: <linux-kernel-owner+w=401wt.eu-S933967AbYCDXT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933967AbYCDXT3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934896AbYCDXPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:15:42 -0500
Received: from ns2.suse.de ([195.135.220.15]:42569 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934870AbYCDXPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:15:39 -0500
Date: Tue, 4 Mar 2008 15:15:14 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.25-rc3 git
Message-ID: <20080304231514.GB3073@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.25-rc3 git tree.

It includes:
	- more device id updates
	- quirk file cleanup
	- minor bugfixes for host controllers
	- other minor fixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

A lot of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/Kconfig        |    9 ++--
 drivers/usb/core/quirks.c       |   21 +++++----
 drivers/usb/gadget/printer.c    |    1 -
 drivers/usb/gadget/pxa2xx_udc.c |   88 ++++++++++++++++++++++-----------------
 drivers/usb/gadget/pxa2xx_udc.h |    4 +-
 drivers/usb/host/ehci-q.c       |    2 +-
 drivers/usb/host/isp116x-hcd.c  |   15 +++----
 drivers/usb/host/isp116x.h      |    1 -
 drivers/usb/serial/ftdi_sio.c   |   25 +++++++++++
 drivers/usb/serial/ftdi_sio.h   |    7 +++
 drivers/usb/serial/mos7840.c    |   15 ++++++-
 drivers/usb/serial/option.c     |    4 ++
 drivers/usb/storage/protocol.c  |    2 +-
 include/linux/usb.h             |    3 +-
 14 files changed, 129 insertions(+), 68 deletions(-)

---------------

Alan Stern (3):
      USB: update Kconfig entry for USB_SUSPEND
      USB: spruce up the device blacklist
      usb-storage: update earlier scatter-gather bug fix

Anti Sullin (1):
      USB: isp116x: fix enumeration on boot

Daniel Kozák (1):
      USB: Add support for AXESSTEL MV110H CDMA modem

David Ludlow (1):
      usb: Add support for the mos7820/7840-based B&B USB/RS485 converter to mos7840.c

Dmitry Baryshkov (1):
      USB: pxa2xx_udc: fix misuse of clock enable/disable calls

Kevin Vance (1):
      USB: ftdi_sio: Workaround for broken Matrix Orbital serial port

Lei Ming (1):
      USB: fix comment of struct usb_interface

Misha Zhilin (1):
      USB: ehci: handle large bulk URBs correctly (again)

Sven Andersen (1):
      USB: ftdi_sio - really enable EM1010PC

Tony Jones (1):
      USB: remove incorrect struct class_device from the printer gadget

