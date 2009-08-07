Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZHGX1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZHGX1N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 19:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756576AbZHGX1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 19:27:11 -0400
Received: from kroah.org ([198.145.64.141]:42913 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755950AbZHGX1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 19:27:10 -0400
Date: Fri, 7 Aug 2009 16:25:23 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.31-rc5-git
Message-ID: <20090807232523.GA31885@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your kernel tree.

They fix:
	- some ehci warnings that people (including myself) are seeing.
	- musb driver fixes
	- new device ids
	- cdc-acm bugfix that solves a regression that was reported
	- other minor fixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------


 arch/arm/configs/omap3_evm_defconfig |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c |    5 +++++
 arch/arm/mach-omap2/usb-musb.c       |   21 ---------------------
 drivers/usb/class/cdc-acm.c          |   10 +++++-----
 drivers/usb/class/cdc-acm.h          |    2 ++
 drivers/usb/core/devio.c             |   10 ++++++----
 drivers/usb/host/ehci-hcd.c          |    3 ++-
 drivers/usb/host/ehci-q.c            |   15 +++++++--------
 drivers/usb/host/ehci-sched.c        |    1 +
 drivers/usb/musb/Kconfig             |    1 +
 drivers/usb/serial/ftdi_sio.c        |    3 +++
 drivers/usb/serial/ftdi_sio.h        |   14 ++++++++++++++
 drivers/usb/serial/pl2303.c          |    1 +
 drivers/usb/serial/pl2303.h          |    4 ++++
 drivers/usb/storage/unusual_devs.h   |    7 +++++++
 15 files changed, 59 insertions(+), 40 deletions(-)

---------------

Alan Stern (3):
      USB: usbfs: fix -ENOENT error code to be -ENODEV
      USB: EHCI: fix two new bugs related to Clear-TT-Buffer
      USB: EHCI: fix counting of transaction error retries

Dhaval Vasa (1):
      USB: ftdi_sio: add product_id for Marvell OpenRD Base, Client

Gupta, Ajay Kumar (1):
      USB: musb: fix the nop registration for OMAP3EVM

Khanh-Dang Nguyen Thu Lam (1):
      USB: pl2303: New vendor and product id

Marko Hänninen (1):
      USB: ftdi_sio: add vendor and product id for Bayer glucose meter serial converter cable

Michael Buesch (1):
      USB: devio: Properly do access_ok() checks

Oliver Neukum (1):
      USB: fix oops on disconnect in cdc-acm

Rogerio Brito (1):
      USB: storage: include Prolific Technology USB drive in unusual_devs list

