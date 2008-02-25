Return-Path: <linux-kernel-owner+w=401wt.eu-S1758217AbYBYR7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbYBYR7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757921AbYBYR6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:58:50 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:36962 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894AbYBYR6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:58:49 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 25 Feb 2008 18:58:25 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
Message-ID: <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates for the firewire and the ieee1394
subsystems.  This queue consists of fixes developed between end of
January and February 20.  Therefore several of these updates were not
yet visible in -mm.  But all of them showed up in -next (behind planned
post 2.6.25 stuff), most of them AFAIK also in Fedora test kernels.

The queue improves the SBP-2 driver's reliability during device
recognition and during bus topology changes.

All patches have been seen on LKML and linux1394-devel but I will follow
up with the combined full log and diff.  Diffstat and shortlog:

 Documentation/debugging-via-ohci1394.txt |   17 +-
 drivers/firewire/fw-cdev.c               |   17 +-
 drivers/firewire/fw-device.c             |   48 ++-
 drivers/firewire/fw-device.h             |    2 +-
 drivers/firewire/fw-sbp2.c               |  358 +++++++++++++++++-----
 drivers/ieee1394/sbp2.c                  |   15 +
 drivers/ieee1394/sbp2.h                  |    2 +
 7 files changed, 350 insertions(+), 109 deletions(-)

Stefan Richter (19):
      firewire: fw-sbp2: unsigned int vs. unsigned
      firewire: fw-sbp2: fix logout before login retry
      firewire: fix "kobject_add failed for fw* with -EEXIST"
      firewire: fw-sbp2: don't retry login or reconnect after unplug
      firewire: log GUID of new devices
      firewire: fw-sbp2: add INQUIRY delay workaround
      ieee1394: sbp2: add INQUIRY delay workaround
      firewire: fw-sbp2: wait for completion of fetch agent reset
      firewire: fw-sbp2: log bus_id at management request failures
      firewire: fw-sbp2: don't add scsi_device twice
      firewire: fw-sbp2: logout and login after failed reconnect
      firewire: fw-sbp2: sort includes
      firewire: fw-sbp2: enforce a retry of __scsi_add_device if bus generation changed
      firewire: fw-sbp2: (try to) avoid I/O errors during reconnect
      firewire: fw-sbp2: fix NULL pointer deref. in slave_alloc
      firewire: fw-sbp2: fix NULL pointer deref. in scsi_remove_device
      ieee1394: sbp2: fix rescan-scsi-bus
      Documentation: correction to debugging-via-ohci1394
      firewire: fix NULL pointer deref. and resource leak

Thanks,
-- 
Stefan Richter
-=====-==--- --=- ==--=
http://arcgraph.de/sr/

