Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbXAVUIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbXAVUIg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:08:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbXAVUIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:08:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:51096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXAVUIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:08:35 -0500
Date: Mon, 22 Jan 2007 12:07:46 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.20-rc5
Message-ID: <20070122200746.GA9936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes for 2.6.20-rc5

They include a small number of fixes for some USB bugs, and some new
device ids, all of the details are below.  I've also disabled the USB
multithreaded probe option, as it broke a number of people's machines.

Most of them have been in the -mm releases, but due to LCA, some of them
have not.

The gadget driver update looks big, but David says it fixes a number of
problems with it, and it's self-contained.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/usb/core/Kconfig           |   16 ------
 drivers/usb/core/hub.c             |    9 +---
 drivers/usb/host/ohci-ep93xx.c     |    2 +-
 drivers/usb/input/hid-core.c       |    4 ++
 drivers/usb/input/usbtouchscreen.c |   98 +++++++++++++++++++++--------------
 drivers/usb/net/asix.c             |   18 +++++--
 drivers/usb/net/rndis_host.c       |   23 +++++---
 drivers/usb/serial/option.c        |    3 +
 drivers/usb/storage/unusual_devs.h |   19 +++++++
 9 files changed, 114 insertions(+), 78 deletions(-)

---------------

Andres Salomon (1):
      USB: asix: Detect internal PHY and enable/use accordingly

Daniel Gollub (1):
      USB: rndis_host: fix crash while probing a Nokia S60 mobile

Daniel Ritz (1):
      usbtouchscreen: make ITM screens report BTN_TOUCH as zero when not touched

garrett_damore@tadpole.com (1):
      USB: add vendor/device id for Option GT Max 3.6 cards

Greg Kroah-Hartman (1):
      USB: disable USB_MULTITHREAD_PROBE

Manuel Osdoba (1):
      USB: unusual_devs.h entry for nokia 6233

Oliver Neukum (1):
      USB: make usbhid ignore Imation Disc Stakka

Pete Zaitcev (1):
      USB: unusual_devs.h for 0x046b:ff40

Petr Stetiar (1):
      USB: Fix for typo in ohci-ep93xx.c

