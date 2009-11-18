Return-Path: <linux-kernel-owner+w=401wt.eu-S1756460AbZKRBEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756460AbZKRBEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:04:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbZKRBEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:04:09 -0500
Received: from kroah.org ([198.145.64.141]:38456 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbZKRBD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:03:59 -0500
Date: Tue, 17 Nov 2009 17:00:53 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bugfixes for 2.6.32-git
Message-ID: <20091118010053.GB16719@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few bugfixes for your 2.6.32-git tree.

These fix:
	- xhci issues
	- cdc_acm issues
	- usbmon bug
	- new device id for option driver

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the linux-next and mm trees for a
while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/cdc-acm.c  |   18 ++++++++++++------
 drivers/usb/host/ohci-hcd.c  |    5 +++++
 drivers/usb/host/ohci-pci.c  |   20 ++++++++++++++++++++
 drivers/usb/host/ohci-q.c    |   18 ++++++++++++------
 drivers/usb/host/ohci.h      |    9 +++++++++
 drivers/usb/host/xhci-mem.c  |   10 ++++++----
 drivers/usb/host/xhci-ring.c |    7 +++++--
 drivers/usb/mon/mon_bin.c    |   11 +++++++----
 drivers/usb/serial/option.c  |    2 ++
 9 files changed, 78 insertions(+), 22 deletions(-)

---------------

Alan Stern (1):
      USB: usbmon: fix bug in mon_buff_area_shrink

Francesco Lavra (1):
      USB: cdc_acm: Fix memory leak after hangup

Henry Gebhardt (1):
      USB: cdc_acm: Fix race condition when opening tty

Libin Yang (1):
      USB: ohci: quirk AMD prefetch for USB 1.1 ISO transfer

Sarah Sharp (3):
      USB: xhci: Fix bug memory free after failed initialization.
      USB: xhci: Fix TRB physical to virtual address translation.
      USB: xhci: Fix scratchpad deallocation.

Zhang Le (1):
      USB: option.c: add support for D-Link DWM-162-U5

