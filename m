Return-Path: <linux-kernel-owner+w=401wt.eu-S1763509AbXGRXZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763509AbXGRXZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935224AbXGRXYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:24:52 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34750 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934907AbXGRXYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:24:50 -0400
Date: Wed, 18 Jul 2007 16:23:33 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [GIT PATCH] UIO patches for 2.6.22
Message-ID: <20070718232332.GA4620@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the UIO (Userspace I/O driver framework) patches for 2.6.22

They have been revamped from the last time you have seen them, and they
include a real driver, the Hilscher CIF DeviceNet and Profibus card
controller, which is being used in production systems with this driver
framework right now.  The kernel driver they replaced was a total mess,
with over 60+ ioctls to try to control the different aspects of the
device.  See the last patch in this series for more details on this
driver.

These patches include full documentation, are self-contained from the
rest of the kernel, and have been in the -mm tree for the past few
months with no complaints.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/uio-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/DocBook/kernel-api.tmpl |    4 +
 Documentation/DocBook/uio-howto.tmpl  |  611 ++++++++++++++++++++++++++++
 drivers/Kconfig                       |    1 +
 drivers/Makefile                      |    1 +
 drivers/uio/Kconfig                   |   29 ++
 drivers/uio/Makefile                  |    2 +
 drivers/uio/uio.c                     |  701 +++++++++++++++++++++++++++++++++
 drivers/uio/uio_cif.c                 |  156 ++++++++
 include/linux/uio_driver.h            |   91 +++++
 9 files changed, 1596 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/DocBook/uio-howto.tmpl
 create mode 100644 drivers/uio/Kconfig
 create mode 100644 drivers/uio/Makefile
 create mode 100644 drivers/uio/uio.c
 create mode 100644 drivers/uio/uio_cif.c
 create mode 100644 include/linux/uio_driver.h

---------------

Hans J. Koch (2):
      UIO: Add the User IO core code
      UIO: Documentation

Hans-Jürgen Koch (1):
      UIO: Hilscher CIF card driver

