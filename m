Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYKTFyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYKTFyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbYKTFx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:53:56 -0500
Received: from kroah.org ([198.145.64.141]:51812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752110AbYKTFxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:53:55 -0500
Date: Wed, 19 Nov 2008 21:50:26 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.28-git
Message-ID: <20081120055026.GA10709@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB fixes against your current git tree.

These patches are:
	- fix for broken AMD USB controllers
	- musb bugfix
	- rndis bugfix to keep Windows from blue-screening
	- new device ids
	- usb-storage quirks

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm tree for a few
releases.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------------

 drivers/usb/gadget/f_rndis.c       |    3 +--
 drivers/usb/host/ehci-pci.c        |   21 +++++++++++++++++++++
 drivers/usb/mon/mon_bin.c          |    5 ++++-
 drivers/usb/musb/musb_host.c       |    2 +-
 drivers/usb/serial/cp2101.c        |    1 +
 drivers/usb/storage/unusual_devs.h |   11 +++++++++--
 6 files changed, 37 insertions(+), 6 deletions(-)

---------------

Alan Stern (2):
      USB: storage: updates unusual_devs entry for the Nokia 6300
      USB: storage: update unusual_devs entries for Nokia 5300 and 5310

Andiry Xu (1):
      USB: fix SB700 usb subsystem hang bug

David Brownell (1):
      USB: gadget rndis: stop windows self-immolation

Felipe Balbi (1):
      usb: musb: fix bug in musb_schedule

M Kondrin (1):
      USB: ACE1001 patch for cp2101.c

Pete Zaitcev (1):
      USB: usbmon: fix read(2)

Richard Röjfors (1):
      USB: gadget rndis: send notifications

