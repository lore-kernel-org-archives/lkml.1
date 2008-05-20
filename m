Return-Path: <linux-kernel-owner+w=401wt.eu-S934921AbYETWd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934921AbYETWd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:33:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764123AbYETWdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:33:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:38926 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933767AbYETWdf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:33:35 -0400
Date: Tue, 20 May 2008 15:32:48 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB fixes for 2.6.26-rc3
Message-ID: <20080520223248.GB12383@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some USB patches for your 2.6.25-git tree.

They include:
	- bugfixes
	- new device ids
	- removing a device id from one driver and putting it in the
	  correct one.
	- a new driver, cdc-wdm, for wireless USB modems and phones.
	  This driver is self-contained and should cause no new
	  problems.  This is the majority of the diffstat below.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 drivers/net/usb/cdc_subset.c    |    2 +-
 drivers/usb/class/Kconfig       |   11 +
 drivers/usb/class/Makefile      |    1 +
 drivers/usb/class/cdc-wdm.c     |  740 +++++++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/pxa27x_udc.c |    3 +-
 drivers/usb/host/ehci-orion.c   |    2 +
 drivers/usb/serial/ch341.c      |    1 +
 drivers/usb/serial/ftdi_sio.c   |    1 +
 drivers/usb/serial/ftdi_sio.h   |    6 +
 drivers/usb/serial/option.c     |    7 +-
 drivers/usb/serial/pl2303.c     |    1 -
 drivers/usb/serial/pl2303.h     |    1 -
 include/linux/usb/cdc.h         |    9 +
 13 files changed, 780 insertions(+), 5 deletions(-)
 create mode 100644 drivers/usb/class/cdc-wdm.c

---------------

Arnaldo Carvalho de Melo (1):
      USB: OPTION: fix name of Onda MSA501HS HSDPA modem

Atsushi Nemoto (1):
      usb-serial: Use ftdi_sio driver for RATOC REX-USB60F

Greg Kroah-Hartman (1):
      USB: add TELIT HDSPA UC864-E modem to option driver

Ingo Molnar (1):
      USB: build fix

Lennert Buytenhek (1):
      USB: ehci-orion: the Orion EHCI root hub does have a Transaction Translator

Michael F. Robbins (1):
      USB: serial: ch341: New VID/PID for CH341 USB-serial

Oliver Neukum (1):
      USB: CDC WDM driver

karl beldan (1):
      USB: pxa27x_udc - Fix Oops

