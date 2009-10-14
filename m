Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbZJNXIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbZJNXIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 19:08:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762117AbZJNXII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 19:08:08 -0400
Received: from kroah.org ([198.145.64.141]:41603 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbZJNXIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 19:08:07 -0400
Date: Wed, 14 Oct 2009 16:04:27 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [GIT PATCH] USB bugfixes for 2.6.32-git
Message-ID: <20091014230427.GA8865@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few bugfixes for your 2.6.32-git tree.

These fix:
	- usb-storage bug that a number of people hit
	- whci bug fixes
	- ehci bugfix
	- proper vendor/product id for the EEM gadget
	- new device ids.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/

The full patches will be sent to the linux-usb mailing list, if anyone
wants to see them.

thanks,

greg k-h

------------

 ...fs-class-usb_host => sysfs-class-uwb_rc-wusbhc} |    4 +-
 drivers/usb/gadget/ether.c                         |    9 +---
 drivers/usb/host/ehci-sched.c                      |   12 +++---
 drivers/usb/host/whci/asl.c                        |   23 ++++++++---
 drivers/usb/host/whci/pzl.c                        |   24 ++++++++---
 drivers/usb/serial/option.c                        |    4 ++
 drivers/usb/storage/transport.c                    |   17 ++++++++-
 drivers/usb/wusbcore/security.c                    |   41 +++++++++----------
 8 files changed, 82 insertions(+), 52 deletions(-)
 rename Documentation/ABI/testing/{sysfs-class-usb_host => sysfs-class-uwb_rc-wusbhc} (88%)

---------------

Benjamin Herrenschmidt (1):
      usb-storage: Workaround devices with bogus sense size

Brian Niebuhr (1):
      USB: gadget: Fix EEM driver comments and VID/PID

David Vrabel (3):
      USB: rename Documentation/ABI/.../sysfs-class-usb_host
      USB: whci-hcd: handle early deletion of endpoints
      USB: whci-hcd: always do an update after processing a halted qTD

Huzaifa Sidhpurwala (1):
      USB: option: Support for AIRPLUS MCD650 Datacard

Sarah Sharp (1):
      USB: ehci: Fix IST boundary checking interval math.

Stefano Panella (1):
      USB: wusb: don't use the stack to read security descriptor

