Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbYCKAng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbYCKAng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbYCKAnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:43:03 -0400
Received: from mx1.suse.de ([195.135.220.2]:58625 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbYCKAnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:43:00 -0400
Date: Mon, 10 Mar 2008 17:42:32 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.25-rc5 git
Message-ID: <20080311004232.GC17890@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB fixes against your 2.6.25-rc5 git tree.

It includes:
	- more device id updates
	- documentation updates
	- headerfile fixes
	- ehci driver fixes for "broken" hardware
	- minor bugfixes

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

A lot of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list (note the
address change), if anyone wants to see them.

thanks,

greg k-h

------------


 Documentation/usb/usb-help.txt  |    8 ++---
 drivers/usb/gadget/Kconfig      |    2 +-
 drivers/usb/host/ehci-hcd.c     |   62 ++++++++++++++++++++++++--------
 drivers/usb/serial/cypress_m8.c |    2 +
 drivers/usb/serial/cypress_m8.h |    4 ++
 drivers/usb/serial/ftdi_sio.c   |    1 +
 drivers/usb/serial/ftdi_sio.h   |    3 ++
 drivers/usb/serial/generic.c    |   10 +++--
 drivers/usb/serial/option.c     |   75 ++++++++++++++++++++++++++++++++-------
 drivers/usb/storage/sddr55.c    |    4 +-
 include/linux/usb/Kbuild        |    2 +-
 include/linux/usb/gadget.h      |    4 --
 sound/usb/usbaudio.c            |    2 +
 13 files changed, 133 insertions(+), 46 deletions(-)

---------------

Andrew Morton (1):
      USB: drivers/usb/storage/sddr55.c: fix uninitialized var warnings

David Brownell (1):
      USB: fix ehci unlink regressions

Dirk DeSchepper (1):
      USB: option: add novatel device ids

Dmitry Shapin (1):
      USB: cypress_m8: add UPS Powercom (0d9f:0002)

Jim Meyering (1):
      USB: usbaudio: handle kcalloc failure

Li Yang (1):
      USB: fsl_usb2_udc: fix broken Kconfig

Mirko Bordignon (1):
      USB: new ftdi_sio device id

Pete Zaitcev (1):
      USB: fix usb-serial generic recursive lock

Robert P. J. Day (3):
      USB: g_printer.h does not need to be "unifdef"ed.
      USB: Remove __KERNEL__ check from non-exported gadget.h.
      USB:Update mailing list information in documentation

