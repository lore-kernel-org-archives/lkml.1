Return-Path: <linux-kernel-owner+w=401wt.eu-S1765485AbYBUXsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765485AbYBUXsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763132AbYBUXrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:47:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48837 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760968AbYBUXrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:47:15 -0500
Date: Thu, 21 Feb 2008 15:47:00 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.25-rc2 git
Message-ID: <20080221234700.GC7128@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.25-rc2 git tree.

It includes:
	- lots of device id updates for the wireless usb-serial cards
	- more quirk additions
	- bugfixes in various drivers

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

A lot of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c        |   10 ++++----
 drivers/usb/class/usblp.c          |    1 +
 drivers/usb/core/quirks.c          |   12 ++++++++++
 drivers/usb/gadget/ether.c         |    1 +
 drivers/usb/gadget/printer.c       |    2 +-
 drivers/usb/host/Kconfig           |    5 +--
 drivers/usb/host/ehci-hcd.c        |   26 +++++++++++-----------
 drivers/usb/misc/ldusb.c           |    2 +
 drivers/usb/misc/trancevibrator.c  |    4 ++-
 drivers/usb/serial/ftdi_sio.c      |    4 +-
 drivers/usb/serial/option.c        |   43 +++++++++++++++++++++++++++++++++--
 drivers/usb/serial/sierra.c        |    1 -
 drivers/usb/storage/protocol.c     |   27 ++++++++++++----------
 drivers/usb/storage/transport.c    |   11 ---------
 drivers/usb/storage/unusual_devs.h |   34 +++++++++++++++++++++++++++-
 15 files changed, 130 insertions(+), 53 deletions(-)

---------------

Adrian Bunk (1):
      USB: g_printer, fix empty if statement

Alan Stern (3):
      USB: usb-storage: don't clear-halt when Get-Max-LUN stalls
      USB: quirks and unusual_devs entry for Actions flash drive
      USB: usb-storage: don't access beyond the end of the sg buffer

Andy Shevchenko (1):
      USB: usb: yet another Dell wireless CDMA/EVDO modem

Anton Vorontsov (2):
      USB: POWERPC: ehci: fix ppc build
      ehci-fsl: add PPC_MPC837x to default y

Dan Williams (1):
      USB: option: Add Kyocera KPC680 ids

David Brownell (1):
      USB: fix previous sparse fix which was incorrect

Jan Altenberg (1):
      USB: gadget: queue usb USB_CDC_GET_ENCAPSULATED_RESPONSE message

Kevin Lloyd (1):
      USB: serial: move zte MF330 from sierra to option

Konstantin Kletschke (1):
      USB: storage: Nikon D80 new FW still needs Fixup

Oliver Neukum (5):
      USB: Sane memory allocation in option driver
      USB: fix pm counter leak in usblp
      USB: fix usb open suspend race in cdc-acm
      USB: fix error handling in trancevibrator
      USB: quirks for known quirky audio devices

Peter Korsgaard (1):
      USB: ehci-fsl: mpc834x config symbol is PPC_MPC834x, not MPC834x

Robert Spitzenpfeil (1):
      USB: usb-storage: unusual_devs entry for Oracom MP3 player

Roel Kluin (1):
      USB: ftdi_sio.c add missing '|'

Stefan Bader (1):
      USB: option: Added vendor id for Dell 5720 broadband modem

Stephen Ware (1):
      USB: add new vernier product id to ldusb.c

Warren Turkal (1):
      USB: Add another Novatel U727 ID to the device table for usbserial

