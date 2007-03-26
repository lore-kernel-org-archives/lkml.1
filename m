Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbXCZVVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbXCZVVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 17:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbXCZVVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 17:21:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51008 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbXCZVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 17:21:30 -0400
Date: Mon, 26 Mar 2007 14:19:25 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.21-rc5
Message-ID: <20070326211925.GA13549@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some PCI fixes against 2.6.21-rc5

They fix some "problem" hardware, fix a warning message to display the
correct information, and update the PCI documentation.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h


 Documentation/power/pci.txt    |   17 +++++++----------
 arch/i386/pci/common.c         |    8 ++++++++
 drivers/pci/pcie/portdrv_pci.c |    2 +-
 drivers/pci/quirks.c           |   18 +++++++-----------
 4 files changed, 23 insertions(+), 22 deletions(-)

---------------

Jean Delvare (1):
      PCI: Stop unhiding the SMBus on Toshiba laptops

Jonathan Corbet (1):
      PCI: Fix up PCI power management doc

Matt Domsch (1):
      pci: set pci=bfsort for PowerEdge R900

Prarit Bhargava (1):
      PCI: Fix warning message in PCIE port driver

