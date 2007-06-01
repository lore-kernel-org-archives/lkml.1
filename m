Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXFAMJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXFAMJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXFAMJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:09:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:59061 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbXFAMJ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:09:27 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 1 Jun 2007 14:09:03 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] ieee1394 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.b48f5c718ecc4c84@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates to the old and the new IEEE 1394 subsystem:

  - fix hang in s2ram,
  - port a sysfs attribute from sbp2 to firewire-sbp2,
  - fix userspace-exported headers,
  - list new firewire stack in MAINTAINERS.

I'm sorry that the s2ram fix is rather large for an -rc fix but I think
it is acceptable in preparation of the very first release of the new
firewire stack.  Things will get back to normal from now on.


The diff will follow in a reply.  The stat and shortlog:

 MAINTAINERS                   |    8 ++
 drivers/firewire/fw-card.c    |    5 -
 drivers/firewire/fw-cdev.c    |   17 +++-
 drivers/firewire/fw-device.h  |    1 +
 drivers/firewire/fw-ohci.c    |  187 +++++++++++++++++++++-----------
 drivers/firewire/fw-sbp2.c    |   53 +++++++++
 drivers/ieee1394/nodemgr.c    |    7 +-
 drivers/ieee1394/nodemgr.h    |    1 +
 drivers/ieee1394/sbp2.c       |   31 +++++-
 include/linux/Kbuild          |    2 +
 include/linux/firewire-cdev.h |   14 ++-
 11 files changed, 247 insertions(+), 79 deletions(-)

Kristian Høgsberg (3):
      firewire: Implement suspend/resume PCI driver hooks.
      firewire: Change struct fw_cdev_iso_packet to not use bitfields.
      firewire: Install firewire-constants.h and firewire-cdev.h for userspace.

Stefan Richter (4):
      ieee1394: fix calculation of sysfs attribute "address"
      ieee1394: sbp2: offer SAM-conforming target port ID in sysfs
      firewire: fw-sbp2: implement sysfs ieee1394_id
      firewire: add to MAINTAINERS

-- 
Stefan Richter
-=====-=-=== -==- ----=
http://arcgraph.de/sr/

