Return-Path: <linux-kernel-owner+w=401wt.eu-S970656AbXFHUER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970656AbXFHUER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 16:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXFHUEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 16:04:07 -0400
Received: from canuck.infradead.org ([209.217.80.40]:56220 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbXFHUEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 16:04:06 -0400
Date: Fri, 8 Jun 2007 13:04:07 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PATCH] Driver core fixes for 2.6.22-rc4
Message-ID: <20070608200407.GA22825@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some driver core fixes for 2.6.22-rc4

They contain:
	- documentation update
	- email fixes for a deceased maintainer
	- fixes for PHYSDEV for older class_devices that broke some
	  userspace tools unnecessarily
	- printk levels for kobjects.
	- fix compiler warning that like 10 people have emailed me
	  patches for.

All of these have been in the -mm tree for a number of weeks.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6.git/

Patches will be sent as a follow-on to this message to lkml for people
to see.

thanks,

greg k-h


 Documentation/driver-model/platform.txt            |   40 +++++++++++++
 Documentation/firmware_class/README                |    2 +-
 .../firmware_class/firmware_sample_driver.c        |    2 +-
 .../firmware_sample_firmware_class.c               |    4 +-
 drivers/base/class.c                               |   59 +++++++-------------
 drivers/base/core.c                                |   10 ++-
 drivers/base/dd.c                                  |   13 ----
 drivers/base/firmware_class.c                      |    4 +-
 lib/kobject.c                                      |   10 ++--
 9 files changed, 78 insertions(+), 66 deletions(-)

---------------

David Brownell (1):
      update Documentation/driver-model/platform.txt

Greg Kroah-Hartman (1):
      kobject: use the proper printk level for kobject error

Kay Sievers (1):
      Driver core: keep PHYSDEV for old struct class_device

Markus Rechberger (1):
      firmware: remove orphaned Email

Stephen Hemminger (1):
      Driver core: kill unused code

