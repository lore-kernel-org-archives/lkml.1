Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbXCZVY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbXCZVY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932444AbXCZVY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:24:59 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53735 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281AbXCZVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:24:58 -0400
Date: Mon, 26 Mar 2007 14:22:36 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.21-rc5
Message-ID: <20070326212236.GA13681@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against 2.6.21-rc5.

These patches fix a number of reported problems and compiler warnings in
the current tree.

Yes, hte omap_udc. and uhci patches seem a bit "big" but both David and
Alan ensure me that they are correct and needed for the 2.6.21 final
release.

All of these have been in the -mm releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h

 drivers/usb/core/quirks.c     |    3 +-
 drivers/usb/gadget/omap_udc.c |  103 +++++++++++++++++++++++++++++++++++++----
 drivers/usb/host/uhci-debug.c |   26 ++++++----
 drivers/usb/host/uhci-hcd.c   |    3 +-
 drivers/usb/host/uhci-q.c     |   94 ++++++++++----------------------------
 drivers/usb/serial/airprime.c |    1 -
 drivers/usb/serial/ftdi_sio.c |    6 ++-
 drivers/usb/serial/generic.c  |    7 ++-
 8 files changed, 145 insertions(+), 98 deletions(-)

---------------

Alan Stern (1):
      UHCI: Fix problem caused by lack of terminating QH

David Brownell (3):
      USB: omap_udc: workaround dma_free_coherent() bogosity
      USB: fix usb-serial/generic build warning
      USB: fix usb-serial/ftdi build warning

Jon K Hellan (1):
      USB: remove duplicated device id in airprime driver

Oliver Neukum (1):
      USB: another entry for the quirk list

