Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZJLHD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZJLHD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753428AbZJLHD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:03:27 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:41706 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbZJLHD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:03:26 -0400
Subject: [PATCH 0/5] PCI: add domain support to aer_inject and other fixups
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, pci-linux@vger.kernel.org
Date: Mon, 12 Oct 2009 01:02:49 -0600
Message-ID: <20091012070248.27029.78378.stgit@bob.kio>
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

Andrew Patterson (5):
      PCI: add pci_get_domain_bus_and_slot function
      PCI: add support for PCI domains to aer_inject
      PCI: maintain backwards compatibility with aer-inject user-land tool
      PCI: use better error return values in aer_inject
      PCI: fix memory leak in aer_inject


 drivers/pci/pcie/aer/aer_inject.c |   56 ++++++++++++++++++++++++++-----------
 drivers/pci/search.c              |   34 +++++++++++-----------
 include/linux/pci.h               |    8 +++++
 3 files changed, 63 insertions(+), 35 deletions(-)


--
Andrew Patterson
