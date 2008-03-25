Return-Path: <linux-kernel-owner+w=401wt.eu-S1756281AbYCYGHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbYCYGHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbYCYGGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:06:39 -0400
Received: from mail.suse.de ([195.135.220.2]:36063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756733AbYCYGGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:06:38 -0400
Date: Mon, 24 Mar 2008 23:06:20 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.25-rc6 git tree
Message-ID: <20080325060620.GC20741@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two PCI fixes for your 2.6.25-rc6 git tree.

They are:
	- revert a troublesome PCI patch
	- iommu lockdep reporting fix

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

All of these patches have been in the -mm tree for a while, as well as
-next.

thanks,

greg k-h


-------------

 drivers/pci/intel-iommu.c |    7 +++++++
 drivers/pci/pci.c         |   21 ---------------------
 include/linux/pci.h       |    4 ----
 3 files changed, 7 insertions(+), 25 deletions(-)

---------------

Andrew Morton (1):
      PCI: revert "pcie: utilize pcie transaction pending bit"

Mark Gross (1):
      PCI: iova: lockdep false alarm fix

