Return-Path: <linux-kernel-owner+w=401wt.eu-S1759906AbXIKQqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759906AbXIKQqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbXIKQpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:45:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42426 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbXIKQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:45:49 -0400
Date: Tue, 11 Sep 2007 09:43:02 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.23-rc6
Message-ID: <20070911164302.GB31978@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a some PCI fixes against your 2.6.23-rc6 git tree.

They contain some bugfixes for devinit, compiler warning fixes, some
quirk updates, and a new device id.

All of these have been in the -mm tree for a while.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h


 arch/i386/pci/irq.c     |    1 +
 arch/i386/pci/pcbios.c  |    2 +-
 drivers/pci/probe.c     |    2 +-
 drivers/pci/quirks.c    |   16 ++++++++++++++--
 include/linux/aer.h     |   25 ++++++++++++++++++++-----
 include/linux/pci_ids.h |    2 ++
 6 files changed, 39 insertions(+), 9 deletions(-)

---------------

Jason Gaston (1):
      PCI: irq and pci_ids patch for Intel Tolapai

Ralf Baechle (2):
      PCI: remove devinit from pci_read_bridge_bases
      PCI: Remove __devinit from pcibios_get_irq_routing_table

Randy Dunlap (1):
      PCI AER: fix warnings when PCIEAER=n

gw.kernel@tnode.com (1):
      PCI: unhide SMBus on Compaq Deskpro EP 401963-001 motherboard

