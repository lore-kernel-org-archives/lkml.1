Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXCJEFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXCJEFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXCJEFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:05:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:36162 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965834AbXCJEFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:05:35 -0500
Date: Fri, 9 Mar 2007 20:03:56 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.21-rc3
Message-ID: <20070310040356.GB30638@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some PCI fixes against 2.6.21-rc3

They fix a problem that shows up with the libata drivers and fix a number of
section mismatches.

All of these have been in the -mm tree.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h


 drivers/pci/pci.c              |   15 ++++++++-------
 drivers/pci/pcie/aer/aerdrv.c  |    6 +++---
 drivers/pci/pcie/portdrv_pci.c |    6 +++---
 drivers/pci/search.c           |    2 +-
 4 files changed, 15 insertions(+), 14 deletions(-)

---------------

Sam Ravnborg (3):
      pcie: fix section mismatch warning
      PCI: aer: fix section mismatch warning
      pci: fix section mismatch warning

Tejun Heo (1):
      PCI: allow multiple calls to pcim_pin_device()

