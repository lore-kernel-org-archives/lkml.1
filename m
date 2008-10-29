Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbYJ2WmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbYJ2WmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 18:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbYJ2WmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 18:42:03 -0400
Received: from kroah.org ([198.145.64.141]:43720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752041AbYJ2WmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 18:42:00 -0400
Date: Wed, 29 Oct 2008 15:38:16 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20081029223816.GA21657@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few USB patches for your 2.6-git tree.

These patches are:
	- build warning fix
	- new device quirk for usb storage
	- 2 bugfixes in the the USB core

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these have been in the -next and -mm releases for a while.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/usb/class/usbtmc.c         |    2 +-
 drivers/usb/core/hcd.c             |   35 ++++++++++++++++++++++++++++++++---
 drivers/usb/core/hcd.h             |    1 +
 drivers/usb/core/hub.c             |    4 ++++
 drivers/usb/core/urb.c             |   22 ++++++++++++++++++++++
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 6 files changed, 67 insertions(+), 4 deletions(-)

---------------

Alan Stern (2):
      USB: fix crash when URBs are unlinked after the device is gone
      USB: prevent autosuspend during hub initialization

Chris Malley (1):
      USB: usbtmc: Use explicit unsigned type for input buffer instead of char*

Jens Taprogge (1):
      USB: Unusual dev for the "Kyocera / Contax SL300R T*" digital camera.

