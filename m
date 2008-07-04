Return-Path: <linux-kernel-owner+w=401wt.eu-S1759136AbYGDBb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbYGDBb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 21:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbYGDBa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 21:30:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:40501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931AbYGDBay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 21:30:54 -0400
Date: Thu, 3 Jul 2008 18:29:14 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.26-rc8
Message-ID: <20080704012914.GA29349@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.26-git tree.

They are all bugfixes or new device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c         |    3 --
 drivers/usb/core/hcd.c              |   38 +++++++++++++++++++++++++---------
 drivers/usb/core/hub.c              |   15 +++----------
 drivers/usb/host/ehci.h             |   19 +++++++++--------
 drivers/usb/host/ohci-hcd.c         |   15 ++++++++++++-
 drivers/usb/host/ohci-q.c           |   12 +++++++++++
 drivers/usb/misc/sisusbvga/sisusb.c |    2 -
 drivers/usb/serial/ftdi_sio.c       |    1 +
 drivers/usb/serial/ftdi_sio.h       |    3 ++
 drivers/usb/serial/ipaq.c           |    7 +++++-
 drivers/usb/serial/option.c         |    1 +
 drivers/usb/serial/pl2303.c         |    1 +
 drivers/usb/serial/pl2303.h         |    1 +
 drivers/usb/storage/unusual_devs.h  |    8 +++++++
 14 files changed, 89 insertions(+), 37 deletions(-)

---------------

Alan Stern (1):
      USB: don't lose disconnections during suspend

Ben Dooks (1):
      OHCI: Fix problem if SM501 and another platform driver is selected

David Brownell (2):
      USB: ehci - fix timer regression
      USB: ohci - record data toggle after unlink

Greg Kroah-Hartman (2):
      USB: another option device id
      USB: add a pl2303 device id

Jon K Hellan (1):
      USB: New device ID for ftdi_sio driver

Matthieu CASTET (1):
      USB: mass storage: new id for US_SC_CYP_ATACB

Oliver Neukum (3):
      USB: fix cdc-acm resume()
      USB: fix Oops on loading ipaq module since 2.6.26
      USB: adding comment for ipaq forcing number of ports

Stefan Becker (1):
      USB: fix interrupt disabling for HCDs with shared interrupt handlers

Will Newton (1):
      sisusbvga: Fix oops on disconnect.

