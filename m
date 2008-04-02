Return-Path: <linux-kernel-owner+w=401wt.eu-S1758072AbYDBWrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072AbYDBWrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYDBWqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:46:54 -0400
Received: from ns.suse.de ([195.135.220.2]:35050 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbYDBWqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:46:53 -0400
Date: Wed, 2 Apr 2008 15:46:48 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.25-rc8 git
Message-ID: <20080402224648.GA4796@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.25-rc8 git tree.

They include:
	- new device ids
	- usb-serial bugfixes for devices
	- usb suspend/resume bug that hit a number of people recently.
	- ohci timer sync bugfix

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

Most of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

Many thanks to Mark Lord and others for reporting the USB suspend issue,
and to Alan Stern and David Brownell for working very quickly to fix it.

thanks,

greg k-h

------------

 drivers/usb/host/ehci-hub.c           |    5 +++--
 drivers/usb/host/ohci-hcd.c           |    2 +-
 drivers/usb/host/ohci-q.c             |    2 +-
 drivers/usb/misc/usbtest.c            |    3 ++-
 drivers/usb/serial/cp2101.c           |    1 +
 drivers/usb/serial/keyspan.h          |    4 ++++
 drivers/usb/serial/ti_usb_3410_5052.c |    4 ++--
 drivers/usb/serial/visor.c            |    2 +-
 8 files changed, 15 insertions(+), 8 deletions(-)

---------------

Alan Stern (1):
      USB: fix bug in sg initialization in usbtest

Brad Sawatzky (1):
      USB: serial: fix regression in Visor/Palm OS module for kernels >= 2.6.24

Clark Rawlins (1):
      USB: Allow initialization of broken keyspan serial adapters.

David Brownell (1):
      USB: another ehci_iaa_watchdog fix

Florian Fainelli (1):
      USB: cp2101: Add identifiers for the Telegesys ETRX2USB

Richard Kennedy (1):
      USB: ohci: fix 2 timers to fire at jiffies + 1s

Robert Spanton (1):
      USB: serial: ti_usb_3410_5052: Correct TUSB3410 endpoint requirements.

