Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188Ab0ATXum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab0ATXum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066Ab0ATXuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:50:13 -0500
Received: from kroah.org ([198.145.64.141]:33557 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab0ATXs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:48:59 -0500
Date: Wed, 20 Jan 2010 15:48:04 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [GIT PATCH] STAGING patches for 2.6.33-rc4
Message-ID: <20100120234804.GD32068@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some staging patches for your 2.6.33-rc4 tree.

They are:
	- regression bugfix for et131x driver
	- regression bugfix for asus_oled
	- fix the hv drivers to actually work on a SMP kernel.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/staging-2.6.git/

All of these patches have been in the linux-next and mm trees.

The patches will be sent as a follow-on to this message to the
driver-devel list for people to see.

thanks,

greg k-h

--------------

 drivers/staging/asus_oled/asus_oled.c       |   12 ++++--
 drivers/staging/et131x/et1310_address_map.h |   18 +++++++---
 drivers/staging/et131x/et1310_rx.c          |    6 ++--
 drivers/staging/hv/Hv.c                     |   50 +++++++++++++-------------
 drivers/staging/hv/Hv.h                     |    6 ++--
 drivers/staging/hv/Vmbus.c                  |   12 ++++---
 6 files changed, 59 insertions(+), 45 deletions(-)

---------------

Alan Cox (1):
      Staging: et131x: Fix 2.6.33rc1 regression in et131x

Eugeni Dodonov (1):
      Staging: asus_oled: fix oops in 2.6.32.2

Greg Kroah-Hartman (1):
      Staging: hv: fix smp problems in the hyperv core code

