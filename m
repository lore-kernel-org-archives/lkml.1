Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbYIWVPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbYIWVPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYIWVO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:14:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:41964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbYIWVO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:14:57 -0400
Date: Tue, 23 Sep 2008 14:12:02 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB patches for 2.6.27-rc7
Message-ID: <20080923211202.GA2915@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.26-git tree.

These paches are:
	- regression fixes (both run-time and build-time)
	- new device ids added to some drivers
	- new usb-storage quirks (lots of new Nokia devices are
	  broken...)
	- remove a config option that should never have been added.
	- a minor documentation update.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -next and -mm trees for quite a
while, sorry for sitting on them for so long, too many conferences in
the past few weeks.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 Documentation/usb/anchors.txt         |   12 ++++++++++
 drivers/usb/core/hcd.c                |    3 +-
 drivers/usb/core/hub.c                |   39 ++++++++++++++------------------
 drivers/usb/gadget/fsl_usb2_udc.c     |    2 +-
 drivers/usb/gadget/omap_udc.c         |    4 +-
 drivers/usb/host/ehci-hcd.c           |   26 +++++++++++++--------
 drivers/usb/host/ehci-sched.c         |   32 +++++++++++---------------
 drivers/usb/musb/Kconfig              |    1 +
 drivers/usb/musb/musb_core.c          |    4 +-
 drivers/usb/musb/omap2430.c           |    4 +-
 drivers/usb/musb/omap2430.h           |    4 +-
 drivers/usb/serial/cp2101.c           |    3 ++
 drivers/usb/serial/ftdi_sio.c         |    3 ++
 drivers/usb/serial/ftdi_sio.h         |    5 ++++
 drivers/usb/serial/option.c           |    2 +
 drivers/usb/serial/sierra.c           |   12 ++++++----
 drivers/usb/serial/ti_usb_3410_5052.c |    2 +-
 drivers/usb/serial/usb-serial.c       |    4 ++-
 drivers/usb/storage/Kconfig           |   12 ----------
 drivers/usb/storage/Makefile          |    3 +-
 drivers/usb/storage/unusual_devs.h    |   30 +++++++++++++++++++++++-
 drivers/usb/storage/usb.c             |    2 -
 22 files changed, 124 insertions(+), 85 deletions(-)

---------------

Alan Stern (2):
      USB: unusual_devs addition for RockChip MP3 player
      USB: revert recovery from transient errors

Andreas Bombe (1):
      usb-serial: Add Siemens EF81 to PL-2303 hack triggers

Andrew Morton (1):
      USB: drivers/usb/musb/: disable it on SuperH

Chris Adams (1):
      usb serial: ti_usb_3410_5052 obviously broken by firmware changes

Craig Shelley (1):
      USB: SERIAL CP2101 add device IDs

David Almaroad (1):
      usb: unusual devs patch for Nokia 5310 Music Xpress

David Brownell (3):
      USB: ehci: fix some ehci hangs and crashes
      usb gadget: fix omap_udc DMA regression
      USB: fix EHCI periodic transfers

Felipe Balbi (1):
      usb: musb: fix include path

Filip Joelsson (1):
      USB: Fixing Nokia 3310c in storage mode

Gaetan Carlier (1):
      usb: ftdi_sio: add support for Domintell devices

Geoff Levand (1):
      USB: fix hcd interrupt disabling

Jaroslav Kysela (1):
      USB: ftdi_sio: Add 0x5050/0x0900 USB IDs (Papouch Quido USB 4/4)

Kevin Lloyd (3):
      USB Storage: Sierra: Non-configurable TRU-Install
      USB Serial: Sierra: Device addition & version rev
      USB Serial: Sierra: Add MC8785 VID/PID

Oliver Neukum (1):
      USB: update of Documentation/usb/anchors.txt

Otavio Salvador (1):
      USB: serial: add ZTE CDMA Tech id to option driver

Peter Korsgaard (1):
      USB: fsl_usb2_udc: fix VDBG() format string

Richard Nauber (1):
      USB: Fix the Nokia 6300 storage-mode.

Tony Murray (1):
      USB: Correct Sierra Wireless USB EVDO Modem Device ID

