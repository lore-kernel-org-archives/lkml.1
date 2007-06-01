Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXFABO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXFABO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbXFABOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:14:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbXFABOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:14:49 -0400
Date: Thu, 31 May 2007 18:16:12 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI patches for 2.6.22-rc3
Message-ID: <20070601011612.GA28262@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some bugfixes for PCI your 2.6.22-rc3 git tree.

All of these have been in the -mm tree for a month or so.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h

 arch/i386/pci/fixup.c   |   11 +++++++++++
 drivers/pci/msi.c       |    2 +-
 drivers/pci/quirks.c    |    2 ++
 drivers/pci/search.c    |    3 ++-
 include/linux/pci_ids.h |    2 ++
 5 files changed, 18 insertions(+), 2 deletions(-)

---------------

Andy Gospodarek (1):
      PCI: disable MSI by default on systems with Serverworks HT1000 chips

Ben Gardner (1):
      PCI: Fix pci_find_present

Dan Williams (1):
      msi: fix ARM compile

Ivan Kokshaysky (1):
      PCI: i386: fixup for Siemens Nixdorf AG FSC Multiprocessor Interrupt Controllers

Jay Cliburn (1):
      PCI: quirk disable MSI on via vt3351

