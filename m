Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZEID2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZEID2W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZEID2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:28:12 -0400
Received: from kroah.org ([198.145.64.141]:41349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071AbZEID2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:28:11 -0400
Date: Fri, 8 May 2009 20:24:32 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.30-rc4
Message-ID: <20090509032432.GA9000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some USB fixes for your 2.6.30-rc4 tree.

More device ids, and some bugfixes for problems that people have
reported recently.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/Makefile               |    2 ++
 drivers/usb/atm/cxacru.c           |   10 ++++++++--
 drivers/usb/gadget/usbstring.c     |    6 +++---
 drivers/usb/serial/ftdi_sio.c      |   20 ++++++++++++++++----
 drivers/usb/serial/ftdi_sio.h      |    6 ++++++
 drivers/usb/storage/unusual_devs.h |    5 +++--
 6 files changed, 38 insertions(+), 11 deletions(-)

---------------

Alan Stern (2):
      USB: Gadget: fix UTF conversion in the usbstring library
      usb-serial: ftdi_sio: fix reference counting of ftdi_private

Andy Lutomirski (1):
      USB: Fix makefile so that CONFIG_WDM and CONFIG_TMC work.

Nicolas Pitre (1):
      USB: ftdi_sio: add vendor/product id for the Marvell SheevaPlug

Phil Dibowitz (1):
      USB: unusual_devs: extend nokia 6288 bcd range

Simon Arlott (1):
      USB: cxacru: Fix negative dB output

