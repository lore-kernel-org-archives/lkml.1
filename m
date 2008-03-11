Return-Path: <linux-kernel-owner+w=401wt.eu-S1755763AbYCKAnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbYCKAnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 20:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYCKAm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 20:42:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbYCKAm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 20:42:57 -0400
Date: Mon, 10 Mar 2008 17:42:24 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net
Subject: [GIT PATCH] PCI fixes for 2.6.25-rc5 git tree
Message-ID: <20080311004224.GB17890@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are 2 PCI patches against your 2.6.25-rc5 git tree.

A pci.h header file fix from Andrew for a #define and a memory leak fix
for a pci hotplug driver.

Please pull from:
	master.kernel.org:/pub/scm/linux/kernel/git/gregkh/pci-2.6.git/

The full patches will be sent to the linux-pci mailing list, if anyone
wants to see them.

thanks,

greg k-h


-------------

 Documentation/pci.txt             |    4 ++--
 drivers/pci/hotplug/ibmphp_ebda.c |    1 +
 include/linux/pci.h               |    4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

---------------

Andrew Morton (1):
      PCI: rename DECLARE_PCI_DEVICE_TABLE to DEFINE_PCI_DEVICE_TABLE

Jesper Juhl (1):
      PCI Hotplug: Fix small mem leak in IBM Hot Plug Controller Driver

