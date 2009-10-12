Return-Path: <linux-kernel-owner+w=401wt.eu-S933073AbZJLTOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073AbZJLTOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbZJLTOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:14:33 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:10114 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZJLTOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:14:33 -0400
Subject: [PATCH v2 0/4] PCI: add domain support to aer_inject and other fixups
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, linux-pci@vger.kernel.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org
Date: Mon, 12 Oct 2009 13:13:54 -0600
Message-ID: <20091012191354.14959.47024.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds PCI domain (segment) support to the aer_inject
driver, changes its error return values to provide more meaningful errors
to the user, and fixes a memory leak.

This patchset is intended for 2.6.33.

Changlog:

v2
  -- Merged backwards compatibilty patch with the add domain support patch.


Andrew Patterson (4):
      PCI: add pci_get_domain_bus_and_slot function
      PCI: add support for PCI domains to aer_inject
      PCI: use better error return values in aer_inject
      PCI: fix memory leak in aer_inject


 drivers/pci/pcie/aer/aer_inject.c |   56 ++++++++++++++++++++++++++-----------
 drivers/pci/search.c              |   34 +++++++++++-----------
 include/linux/pci.h               |    8 +++++
 3 files changed, 63 insertions(+), 35 deletions(-)


--
Andrew Patterson
