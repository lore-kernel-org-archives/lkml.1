Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYLAGVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYLAGVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 01:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYLAGVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 01:21:00 -0500
Received: from kroah.org ([198.145.64.141]:38000 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750929AbYLAGU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 01:20:58 -0500
Date: Sun, 30 Nov 2008 22:16:00 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.28-git
Message-ID: <20081201061600.GA9513@kroah.com>
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
	- revert ehci patch that was incorrect
	- fix for a different broken AMD USB controller
	- 2 gadget bugfixes
	- usb storage quirks
	- new device ids

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm tree for a few
releases.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------------

 drivers/usb/gadget/fsl_qe_udc.c    |    3 +++
 drivers/usb/gadget/fsl_usb2_udc.c  |    3 +++
 drivers/usb/host/ehci-pci.c        |    9 ++++++---
 drivers/usb/host/ehci.h            |   12 +++++-------
 drivers/usb/serial/option.c        |   35 +++++++++++++++++++++++++++++++++++
 drivers/usb/storage/unusual_devs.h |   19 +++++++++++++++++++
 6 files changed, 71 insertions(+), 10 deletions(-)

---------------

Alan Stern (1):
      USB: storage: unusual_devs entry for Mio C520-GPS

Anton Vorontsov (2):
      USB: fsl_qe_udc: Report disconnect before unbinding
      USB: fsl_usb2_udc: Report disconnect before unbinding

Greg Kroah-Hartman (2):
      Revert "USB: improve ehci_watchdog's side effect in CPU power management"
      USB: serial: add more Onda device ids to option driver

Shane Huang (1):
      USB: fix SB600 USB subsystem hang bug

Tobias Kunze Briseño (1):
      USB: usb-storage: unusual_devs entry for Nikon D2H

