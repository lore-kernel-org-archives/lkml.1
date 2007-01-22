Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbXAVUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbXAVUIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbXAVUIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:08:43 -0500
Received: from ns1.suse.de ([195.135.220.2]:47370 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453AbXAVUIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:08:42 -0500
Date: Mon, 22 Jan 2007 12:07:54 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.20-rc5
Message-ID: <20070122200754.GB9936@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a PCI quirk and two docmuentation updates for 2.6.20-rc5

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see it

thanks,

greg k-h

 Documentation/pci.txt    |  702 ++++++++++++++++++++++++++++++++++++----------
 drivers/pci/pci-driver.c |    3 +-
 drivers/pci/quirks.c     |    5 +
 3 files changed, 555 insertions(+), 155 deletions(-)

---------------

Grant Grundler (1):
      PCI: rework Documentation/pci.txt

Jean Delvare (1):
      PCI: Unhide the SMBus on the Asus P4P800-X

Randy Dunlap (1):
      PCI: fix pci-driver kernel-doc

