Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbXIKQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbXIKQp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXIKQps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:45:48 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58389 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXIKQps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:45:48 -0400
Date: Tue, 11 Sep 2007 09:42:54 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.23-rc6
Message-ID: <20070911164254.GA31978@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.23-rc6 git tree.

They do the following:
	- more quirk updates for broken devices.
	- device id updates
	- bugfix for dynamic device ids from userspace

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h


 drivers/usb/core/driver.c           |    2 +-
 drivers/usb/core/quirks.c           |   25 +++++++++++++++++++++++++
 drivers/usb/gadget/serial.c         |   25 +++++++++++++++----------
 drivers/usb/misc/sisusbvga/sisusb.c |    1 +
 drivers/usb/serial/bus.c            |    2 +-
 drivers/usb/serial/ftdi_sio.c       |    1 +
 drivers/usb/serial/ftdi_sio.h       |    8 ++++++++
 drivers/usb/serial/option.c         |    3 +++
 drivers/usb/serial/oti6858.c        |   15 ---------------
 drivers/usb/storage/unusual_devs.h  |   30 ++++++++++++++++++++++++++++++
 10 files changed, 85 insertions(+), 27 deletions(-)

---------------

Alan Cox (1):
      USB: oti6858: Remove broken ioctl code in -mm tree and also the broken fixes

Alan Stern (2):
      USB: prevent Thomson card reader from autosuspending
      USB: prevent Genesys USB-IDE from autosuspending

David Brownell (1):
      USB: fix serial gadget ACM breakage

Greg Kroah-Hartman (1):
      USB: option: Add Dell HSDPA 5520 to driver

Jaime Velasco Juan (1):
      USB: option: Add a new device ID for the HUAWEI E220 HSDPA modem.

Lamarque Vieira Souza (1):
      USB: More USB_QUIRK_RESET_RESUME devices

Massimiliano Ghilardi (1):
      USB Mass Storage: limit "Rockchip ROCK MP3" device (071b:3203) max I/O to 64 sectors per command

Matt Colyer (1):
      USB: Add iPhone device id to the quirk list.

Nathael Pajani (1):
      USB: fix linked list insertion bugfix for usb core

Oliver Neukum (2):
      USB: quirky flash drive
      USB: another quirky device (LCD display)

Ortwin Glück (1):
      USB: Nikon D40 Quirks

Pierre Castella (1):
      USB: ftdi_sio: add of a new product/manufacturer, TML

Ricardo Barberis (1):
      USB: Add Sony Ericsson P1i to unusual_devs.h

Satyam Sharma (1):
      USB: drivers/usb/serial/bus.c: Fix incompatible pointer type warning

samson yeung (1):
      usb/misc/sisusbvga: add product ID of TARGUS/MCT device

