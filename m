Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYFQWfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYFQWfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbYFQWfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:35:08 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50858 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760494AbYFQWfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:35:06 -0400
Date: Wed, 18 Jun 2008 01:33:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh: make pcibios_max_latency static
Message-ID: <20080617223340.GN25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global pcibios_max_latency static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
68ca774cb5441d414e0bbb837bfc35488bf68bd6 diff --git a/arch/sh/drivers/pci/pci.c b/arch/sh/drivers/pci/pci.c
index f57095a..d3839e6 100644
--- a/arch/sh/drivers/pci/pci.c
+++ b/arch/sh/drivers/pci/pci.c
@@ -135,7 +135,7 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
  *  If we set up a device for bus mastering, we need to check and set
  *  the latency timer as it may not be properly set.
  */
-unsigned int pcibios_max_latency = 255;
+static unsigned int pcibios_max_latency = 255;
 
 void pcibios_set_master(struct pci_dev *dev)
 {

