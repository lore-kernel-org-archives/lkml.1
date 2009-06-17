Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbZFQRpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbZFQRpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbZFQRo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:44:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:60066 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZFQRoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:44:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 17 Jun 2009 19:44:47 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: What's in linux1394-2.6.git? -- Part II.0/3
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
Message-ID: <tkrat.c0f2f763744b1215@s5r6.in-berlin.de>
References: <tkrat.70eb865eb2fae29b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is some more in linux1394's for-next branch for which I plan to
send a pull request on Monday.  There is Jay Fenlason's IPv4 over
FireWire implementation for the newer firewire stack in it (May 18),
trivial stylistic changes by me (June 07; sorry for being slow with
integration), small fixes to the new driver and to newly discovered bugs
of firewire-core (June 14..16).

This code has not been seen on LKML yet, hence I will post the combined
diff in replies to this message.

Repo URL:
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-next

Gitweb:
    http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git

Shortlog and diffstat:

Jay Fenlason (1):
      firewire: add IPv4 support

Stefan Richter (9):
      firewire: net: add Kconfig item, rename driver
      firewire: net: style changes
      firewire: net: allow for unordered unit discovery
      firewire: net: remove unused code
      firewire: net: adjust net_device ops
      firewire: core: fix DMA unmapping in iso buffer removal
      firewire: core: fix iso context shutdown on card removal
      firewire: net: fix card driver reloading
      firewire: net: better FIFO address range check and rcodes

 drivers/firewire/Kconfig     |   12 +
 drivers/firewire/Makefile    |    4 +-
 drivers/firewire/core-card.c |   20 +-
 drivers/firewire/core-iso.c  |   11 +-
 drivers/firewire/core.h      |   87 ---
 drivers/firewire/net.c       | 1655 ++++++++++++++++++++++++++++++++++++++++++
 drivers/ieee1394/Kconfig     |    2 +-
 include/linux/firewire.h     |   87 +++
 8 files changed, 1780 insertions(+), 98 deletions(-)
 create mode 100644 drivers/firewire/net.c

-- 
Stefan Richter
-=====-==--= -==- =---=
http://arcgraph.de/sr/

