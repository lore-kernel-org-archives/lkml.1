Return-Path: <linux-kernel-owner+w=401wt.eu-S1759968AbXLQS5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968AbXLQS5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755025AbXLQS5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:57:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33771 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbXLQS5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:57:34 -0500
Date: Mon, 17 Dec 2007 10:56:45 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.24-rc5
Message-ID: <20071217185645.GA4330@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes and changes against your 2.6.24-rc5 git tree.

These are all a bunch of minor fixes and new device ids being added, as
well as some documentation fixes.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------

 drivers/usb/core/hcd-pci.c         |    2 +-
 drivers/usb/core/hub.c             |    6 +++---
 drivers/usb/gadget/at91_udc.c      |    2 ++
 drivers/usb/host/ehci-fsl.c        |    2 +-
 drivers/usb/host/ohci-hcd.c        |   23 +++++++++++++----------
 drivers/usb/host/ohci-ppc-of.c     |    2 +-
 drivers/usb/host/ohci-ssb.c        |    2 +-
 drivers/usb/host/r8a66597-hcd.c    |    2 +-
 drivers/usb/host/uhci-hcd.c        |    9 ++++-----
 drivers/usb/serial/cp2101.c        |    5 +++--
 drivers/usb/serial/option.c        |    4 ++--
 drivers/usb/serial/sierra.c        |    2 +-
 drivers/usb/storage/scsiglue.c     |   12 +++++++++---
 drivers/usb/storage/unusual_devs.h |   15 +++++++--------
 include/linux/usb.h                |    1 +
 include/linux/usb_usual.h          |    5 ++++-
 16 files changed, 54 insertions(+), 40 deletions(-)

---------------

Alan Stern (2):
      USB: fix locking loop by avoiding flush_scheduled_work
      USB: use IRQF_DISABLED for HCD interrupt handlers

Benjamin Herrenschmidt (1):
      usb: Remove broken optimisation in OHCI IRQ handler

Doug Maxey (1):
      usb-storage: Fix devices that cannot handle 32k transfers

Greg Kroah-Hartman (1):
      USB: revert portions of "UNUSUAL_DEV: Sync up some reported devices from Ubuntu"

Jaime Velasco Juan (1):
      USB: option: Bind to the correct interface of the Huawei E220

Jeff Long (1):
      USB: cp2101: new device id

Nicolas Ferre (1):
      USB: at91_udc: correct hanging while disconnecting usb cable

Randy Dunlap (1):
      usb.h: fix kernel-doc warning

agilmore@wirelessbeehive.com (1):
      USB: sierra: fix product id

