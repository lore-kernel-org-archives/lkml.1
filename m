Return-Path: <linux-kernel-owner+w=401wt.eu-S964831AbXBOCLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964831AbXBOCLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964835AbXBOCLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:11:17 -0500
Received: from imf16aec.mail.bellsouth.net ([205.152.59.64]:61267 "EHLO
	imf16aec.mail.bellsouth.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964831AbXBOCLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:11:16 -0500
Date: Wed, 14 Feb 2007 20:11:06 -0600
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net
Subject: [PATCH 0/6] atl1: bugfix, cleanup, enhancement
Message-ID: <20070215021106.GA9753@osprey.hogchain.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2007-01-26)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

Please accept the following patchset for the atl1 network device driver.

* Drop unnecessary NET_PCI config
* Fix incorrect hash table address
* Read MAC address from register
* Remove unused define
* Add Attansic L1 device id to pci_ids
* Bump version number

This patchset contains changes to the following files.

 drivers/net/Kconfig          |    2 +-
 drivers/net/atl1/atl1_hw.c   |   37 +++++++++++++++++++++----------------
 drivers/net/atl1/atl1_main.c |    5 ++---
 include/linux/pci_ids.h      |    1 +
 4 files changed, 25 insertions(+), 20 deletions(-)

