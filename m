Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbZLFR5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbZLFR5D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:57:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbZLFR5C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:57:02 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57264 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917AbZLFR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:57:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 6 Dec 2009 18:56:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [git pull] FireWire updates post 2.6.32
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Message-ID: <tkrat.71d11155e1b4d897@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following minor IEEE 1394/ FireWire subsystem update.

Akinobu Mita (1):
      ieee1394: Use hweight32

Stefan Richter (9):
      firewire: cdev: fix memory leak in an error path
      firewire: normalize style of queue_work wrappers
      firewire: cdev: normalize variable names
      firewire: optimize config ROM creation
      firewire: core: clarify generate_config_rom usage
      firewire: core: optimize Topology Map creation
      firewire: core: WARN on wrong usage of core transaction functions
      firewire: ohci: 0 may be a valid DMA address
      firewire: cdev: reduce stack usage by ioctl_dispatch

 drivers/firewire/core-card.c        |   75 ++++++++----------
 drivers/firewire/core-cdev.c        |  113 ++++++++++++++++-----------
 drivers/firewire/core-topology.c    |   17 +++--
 drivers/firewire/core-transaction.c |   19 ++---
 drivers/firewire/core.h             |    9 +-
 drivers/firewire/ohci.c             |   39 ++++++----
 drivers/firewire/sbp2.c             |    9 ++-
 drivers/ieee1394/ohci1394.c         |    8 +--
 include/linux/firewire.h            |   17 +----
 9 files changed, 159 insertions(+), 147 deletions(-)
-- 
Stefan Richter
-=====-==--= ==-- --==-
http://arcgraph.de/sr/

