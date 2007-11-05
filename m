Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbXKEV74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbXKEV74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXKEV7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:59:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34736 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbXKEV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:59:46 -0500
Date: Mon, 5 Nov 2007 13:56:01 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.24-rc1
Message-ID: <20071105215601.GA4612@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a some PCI patches against your 2.6.24-rc1 git tree.

They are a bunch of quirk updates from David Miller, a new config item
to help Jeff Garzik start to cleanup the isdn drivers and let him take
those patches through his tree, and a few other minor bugfixes.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h

-------------

 drivers/isdn/hisax/Kconfig        |   18 ++++++------
 drivers/isdn/hisax/avm_pci.c      |    4 +-
 drivers/isdn/hisax/diva.c         |    6 ++--
 drivers/isdn/hisax/elsa.c         |    4 +-
 drivers/isdn/hisax/gazel.c        |    4 ++-
 drivers/isdn/hisax/niccy.c        |    7 +++--
 drivers/isdn/hisax/sedlbauer.c    |    4 +-
 drivers/net/tg3.c                 |    9 ------
 drivers/pci/Kconfig               |   11 ++++++++
 drivers/pci/hotplug/Kconfig       |    6 ++--
 drivers/pci/hotplug/cpqphp_ctrl.c |   16 +++++------
 drivers/pci/msi.c                 |   18 ++++++++----
 drivers/pci/pci-driver.c          |    5 +--
 drivers/pci/quirks.c              |   51 ++++++++++++++++++++++++++++++++++---
 drivers/pci/search.c              |    9 ++++++
 drivers/scsi/Kconfig              |    2 +-
 drivers/serial/8250_pci.c         |    5 +++-
 include/linux/pci.h               |   14 ++++++++-
 include/linux/pci_ids.h           |    5 +---
 19 files changed, 134 insertions(+), 64 deletions(-)

---------------

Adrian Bunk (2):
      PCI: make pci_match_device() static
      PCI Hotplug: cpqhp_pushbutton_thread(): remove a pointless if() check

David Miller (5):
      PCI: Revert "PCI: disable MSI by default on systems with Serverworks HT1000 chips"
      PCI: Add MSI quirk for ServerWorks HT1000 PCIX bridge.
      PCI: Add quirk for devices which disable MSI when INTX_DISABLE is set.
      PCI: Add MSI INTX_DISABLE quirks for ATI SB700/800 SATA and IXP SB400 USB
      PCI: Remove 3 incorrect MSI quirks.

Dirk Hohndel (1):
      PCI: pciserial_resume_one ignored return value of pci_enable_device

Jeff Garzik (1):
      PCI: Add Kconfig option to disable deprecated pci_find_* API

