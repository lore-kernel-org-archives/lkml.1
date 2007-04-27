Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbXD0WwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbXD0WwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 18:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbXD0WwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 18:52:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54007 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516AbXD0WwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 18:52:20 -0400
Date: Fri, 27 Apr 2007 15:49:57 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Benedikt Spranger <b.spranger@linutronix.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: [GIT PATCH] UIO patches for 2.6.21
Message-ID: <20070427224957.GA17967@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the updated UIO (Userspace I/O driver framework) patches for
2.6.21.

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
 Documentation/DocBook/uio-howto.tmpl  |  498 +++++++++++++++++++++++
 drivers/Kconfig                       |    1 +
 drivers/Makefile                      |    1 +
 drivers/uio/Kconfig                   |   27 ++
 drivers/uio/Makefile                  |    2 +
 drivers/uio/uio.c                     |  702 +++++++++++++++++++++++++++++++++
 drivers/uio/uio_cif.c                 |  156 ++++++++
 include/linux/uio_driver.h            |   91 +++++
 9 files changed, 1482 insertions(+), 0 deletions(-)
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

