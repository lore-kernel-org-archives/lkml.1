Return-Path: <linux-kernel-owner+w=401wt.eu-S932967AbZIDGrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbZIDGrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 02:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932917AbZIDGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 02:47:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:44045 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825AbZIDGqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:46:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="184025137"
Subject: [PATCH 17/18] Add MODULE_DEVICE_TABLE() so ioatdma module is
	autoloaded
To: linux-kernel@vger.kernel.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Roland Dreier <rolandd@cisco.com>,
       maciej.sosnowski@intel.com
Date: Thu, 03 Sep 2009 23:46:01 -0700
Message-ID: <20090904064601.7141.18599.stgit@dwillia2-linux.ch.intel.com>
In-Reply-To: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
User-Agent: StGit/0.14.3.289.g7daff
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>

The ioatdma module is missing aliases for the PCI devices it supports,
so it is not autoloaded on boot.  Add a MODULE_DEVICE_TABLE() to get
these aliases.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dma/ioat/pci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index aad2fde..8d96533 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -73,6 +73,7 @@ static struct pci_device_id ioat_pci_tbl[] = {
 
 	{ 0, }
 };
+MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);
 
 static int __devinit ioat_pci_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *id);

