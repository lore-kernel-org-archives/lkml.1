Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbZE1Xp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbZE1Xp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 19:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZE1Xph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 19:45:37 -0400
Received: from kroah.org ([198.145.64.141]:33546 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075AbZE1Xpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 19:45:35 -0400
Date: Thu, 28 May 2009 16:42:00 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.30-rc7
Message-ID: <20090528234200.GB10930@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's some USB fixes for your 2.6.30-rc7 tree.

Some bugfixes for usb-serial drivers, and new device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------


 drivers/usb/Makefile                |    1 -
 drivers/usb/class/cdc-acm.c         |    3 +++
 drivers/usb/gadget/atmel_usba_udc.c |    5 +++--
 drivers/usb/host/isp1760-hcd.c      |   24 ++++++++++++++++++++++--
 drivers/usb/serial/usb-serial.c     |    1 +
 5 files changed, 29 insertions(+), 5 deletions(-)

---------------

Alan Stern (1):
      usb-serial: fix crash when sub-driver updates firmware

Haavard Skinnemoen (1):
      USB: atmel_usb_udc: Use kzalloc() to allocate ep structures

Martin Fuzzey (1):
      USB: atmel-usba-udc : fix control out requests.

Mike Frysinger (1):
      Revert "USB: Correct Makefile to make isp1760 buildable"

Warren Free (1):
      USB: isp1760: urb_dequeue doesn't always find the urbs

Xiao Kaijian (1):
      USB: Yet another Conexant Clone to add to cdc-acm.c

