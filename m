Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbYFLAVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbYFLAVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYFLAVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:21:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbYFLAVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:21:13 -0400
Date: Wed, 11 Jun 2008 17:10:55 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.26-rc5
Message-ID: <20080612001055.GB7615@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.25-git tree.

They include:
	- your resume fix for the USB core
	- build fix for the isight_firmware driver for some .configs
	- isight_firmware fix for invalid firmware loading
	- bugfix in the isp1760 host controller driver

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches, except yours, have been in the -mm tree for a
while, as well as -next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------


 drivers/usb/core/hub.c             |   46 ++++++++++++++++++++++++++++++++++-
 drivers/usb/host/isp1760-hcd.c     |    8 +++---
 drivers/usb/misc/Kconfig           |    1 +
 drivers/usb/misc/isight_firmware.c |   23 ++++++++++++-----
 4 files changed, 65 insertions(+), 13 deletions(-)

---------------

Ingo Molnar (1):
      USB: fix build bug in USB_ISIGHTFW

Linus Torvalds (1):
      USB: don't use reset-resume if drivers don't support it

Matthew Garrett (1):
      isight_firmware: Avoid crash on loading invalid firmware

Nate Case (1):
      USB: isp1760: Assign resource fields before adding hcd

