Return-Path: <linux-kernel-owner+w=401wt.eu-S934494AbXHVWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494AbXHVWVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934073AbXHVWTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:19:51 -0400
Received: from canuck.infradead.org ([209.217.80.40]:37074 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934036AbXHVWTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:19:50 -0400
Date: Wed, 22 Aug 2007 15:08:11 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.23-rc3
Message-ID: <20070822220811.GC30603@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a some PCI patches against your 2.6.23-rc3 git tree.

They contain a number of quirk updates and some other minor fixes.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h


 Documentation/DocBook/deviceiobook.tmpl |    3 ++-
 drivers/pci/hotplug/cpqphp_ctrl.c       |    4 +---
 drivers/pci/pci.h                       |    8 +-------
 drivers/pci/probe.c                     |   18 +++++++++---------
 drivers/pci/quirks.c                    |    7 +++++--
 include/asm-i386/io.h                   |    3 +++
 include/linux/pci.h                     |    4 ++++
 include/linux/pci_ids.h                 |    3 +++
 lib/iomap.c                             |   15 ++++++++++++++-
 9 files changed, 42 insertions(+), 23 deletions(-)

---------------

Bernhard Kaindl (1):
      PCI: lets kill the 'PCI hidden behind bridge' message

Brice Goglin (1):
      PCI: make pcie_get_readrq visible in pci.h

Ingo Molnar (1):
      pci/hotplug/cpqphp_ctrl.c: remove stale BKL use

Jean Delvare (1):
      PCI: Run k8t_sound_hostbridge quirk only when needed

Kumar Gala (1):
      PCI: Move prototypes for pci_bus_find_capability to include/linux/pci.h

Marian Balakowicz (1):
      PCI: quirk_e100_interrupt() called too early

Rolf Eike Beer (1):
      PCI: Document pci_iomap()

Tejun Heo (3):
      PCI: disable MSI on RS690
      PCI: disable MSI on RD580
      PCI: disable MSI on RX790

