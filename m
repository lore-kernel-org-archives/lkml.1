Return-Path: <linux-kernel-owner+w=401wt.eu-S1761390AbYFQWec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761390AbYFQWec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760253AbYFQWcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:32:31 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46816 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760619AbYFQWca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:32:30 -0400
Date: Wed, 18 Jun 2008 01:31:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh: make EARLY_PCI_OP's static
Message-ID: <20080617223103.GL25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global EARLY_PCI_OP's static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bc7fc605abf94396ac4b30eaa5270e0f42d15924 diff --git a/arch/sh/drivers/pci/pci-auto.c b/arch/sh/drivers/pci/pci-auto.c
index ea40470..cf48b12 100644
--- a/arch/sh/drivers/pci/pci-auto.c
+++ b/arch/sh/drivers/pci/pci-auto.c
@@ -78,7 +78,7 @@ static struct pci_dev *fake_pci_dev(struct pci_channel *hose,
 }
 
 #define EARLY_PCI_OP(rw, size, type)					\
-int early_##rw##_config_##size(struct pci_channel *hose,		\
+static int early_##rw##_config_##size(struct pci_channel *hose,		\
 	int top_bus, int bus, int devfn, int offset, type value)	\
 {									\
 	return pci_##rw##_config_##size(				\

