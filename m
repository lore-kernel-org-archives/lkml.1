Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbYCYGGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbYCYGGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbYCYGGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:06:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:44974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbYCYGGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:06:31 -0400
Date: Mon, 24 Mar 2008 23:04:43 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.25-rc6 git
Message-ID: <20080325060443.GA20741@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.25-rc6 git tree.

It includes:
	- more device id updates
	- minor bugfixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/net/usb/rtl8150.c          |    2 +-
 drivers/usb/core/message.c         |    5 ++++-
 drivers/usb/core/quirks.c          |    3 +++
 drivers/usb/gadget/inode.c         |    4 ++--
 drivers/usb/host/ehci-pci.c        |   14 ++++++++++++++
 drivers/usb/serial/pl2303.c        |    1 +
 drivers/usb/serial/pl2303.h        |    1 +
 drivers/usb/serial/sierra.c        |   18 ++++++++++++++----
 drivers/usb/storage/isd200.c       |    1 +
 drivers/usb/storage/transport.c    |    3 ++-
 drivers/usb/storage/unusual_devs.h |   11 +++++++++++
 include/linux/usb/quirks.h         |    3 +++
 include/linux/usb_usual.h          |    4 +++-
 13 files changed, 60 insertions(+), 10 deletions(-)

---------------

Alan Stern (1):
      USB: new quirk flag to avoid Set-Interface

Boaz Harrosh (1):
      USB: isd200: fix memory leak in isd200_get_inquiry_data

Constantin Baranov (1):
      USB: add support for Motorola ROKR Z6 cellphone in mass storage mode

Kevin Lloyd (1):
      USB: sierra: add another device id

Max Arnold (1):
      USB: pl2303: another product ID

Oliver Neukum (1):
      USB: sierra: dma fixes

Rene Herman (1):
      USB: ehci: stop vt6212 bus hogging

Robert P. J. Day (1):
      USB: Fix cut-and-paste error in rtl8150.c

Roy Hashimoto (1):
      USB: fix gadgetfs class request delegation

