Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYGOQ56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYGOQ56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758657AbYGOQ5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:57:35 -0400
Received: from smtp.movial.fi ([62.236.91.34]:53424 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758623AbYGOQ5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:57:34 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [MIPS] make the pcibios_max_latency variable static
Date: Tue, 15 Jul 2008 19:57:30 +0300
Message-Id: <1216141052-28005-2-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1216141052-28005-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pcibios_max_latency variable is needlessly defined global,
and this patch makes it static.

Build-tested using malta_defconfig.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 arch/mips/pci/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
index 358ad62..0187b8c 100644
--- a/arch/mips/pci/pci.c
+++ b/arch/mips/pci/pci.c
@@ -205,7 +205,7 @@ static int pcibios_enable_resources(struct pci_dev *dev, int mask)
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain crappy BIOSes forget to set it properly.
  */
-unsigned int pcibios_max_latency = 255;
+static unsigned int pcibios_max_latency = 255;
 
 void pcibios_set_master(struct pci_dev *dev)
 {
-- 
1.5.6

