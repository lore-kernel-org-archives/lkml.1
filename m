Return-Path: <linux-kernel-owner+w=401wt.eu-S1946295AbXBPXhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946295AbXBPXhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946296AbXBPXhB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:37:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51725 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946295AbXBPXhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:37:00 -0500
Date: Fri, 16 Feb 2007 15:35:42 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] more PCI patches for 2.6.20
Message-ID: <20070216233542.GB14708@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some more PCI patches against 2.6.20-git

They are a few additional quirks, a new sysfs file for NUMA machines,
and some documentation fixes.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h

 Documentation/kernel-parameters.txt |    6 ++
 Documentation/pci.txt               |    4 +-
 arch/i386/pci/common.c              |   88 +++++++++++++++++++++++++++++++++++
 drivers/pci/pci-driver.c            |    1 +
 drivers/pci/pci-sysfs.c             |   11 ++++
 drivers/pci/pci.c                   |   12 ++++-
 drivers/pci/setup-bus.c             |   27 ++++-------
 drivers/pci/setup-irq.c             |   18 ++++---
 fs/sysfs/file.c                     |    2 +-
 include/linux/pci.h                 |    3 +
 lib/kobject.c                       |    1 +
 11 files changed, 144 insertions(+), 29 deletions(-)

---------------

Andreas Block (1):
      PCI: PCI devices get assigned redundant IRQs

Andy Gospodarek (1):
      PCI: add systems for automatic breadth-first device sorting

Atsushi Nemoto (1):
      PCI: Make CARDBUS_MEM_SIZE and CARDBUS_IO_SIZE boot options

Brice Goglin (1):
      PCI: Make PCI device numa-node attribute visible in sysfs

Grant Grundler (1):
      PCI: pci.txt fix __devexit() usage

Randy Dunlap (1):
      PCI/sysfs/kobject kernel-doc fixes

