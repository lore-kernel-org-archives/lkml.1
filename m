Return-Path: <linux-kernel-owner+w=401wt.eu-S1752363AbXCSUq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbXCSUq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 16:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbXCSUq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 16:46:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:56363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbXCSUq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 16:46:58 -0400
Date: Mon, 19 Mar 2007 13:45:05 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: [GIT PATCH] USB fixes for 2.6.21-rc4
Message-ID: <20070319204505.GA10235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes and new device ids against 2.6.21-rc4.

These patches contain a fix for a regression that is on Adrian's list
with regards to usb-serial drivers oopsing, and they also add a number
of different device ids and other minor updates.

All of these have been in the -mm releases.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb-devel mailing list, if
anyone wants to see them.

thanks,

greg k-h

 drivers/usb/class/usblp.c          |    6 +++++-
 drivers/usb/misc/berry_charge.c    |    2 +-
 drivers/usb/net/dm9601.c           |    8 ++++++++
 drivers/usb/serial/airprime.c      |    4 ----
 drivers/usb/serial/mos7720.c       |    1 +
 drivers/usb/serial/option.c        |   15 +++++++++++++--
 drivers/usb/serial/usb-serial.c    |   11 +++++------
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 8 files changed, 43 insertions(+), 14 deletions(-)

---------------

Alan Stern (1):
      usblp: quirk flag and device entry for Seiko Epson M129C printer

Greg Kroah-Hartman (1):
      USB: new Novatel device ids for option driver

Jim Radford (1):
      USB: fix usb-serial regression

Jon Dowland (1):
      USB: two more device ids for dm9601 usbnet driver

Ken L Johnson (1):
      USB: berry_charge: correct dbg string for second magic command

Mark Glines (1):
      airprime: USB ID for Novatel EV620 mini PCI-E card

Oliver Neukum (1):
      USB: necessary update for mos7720 driver

Pete Zaitcev (1):
      USB: RAZR v3i unusual_devs

