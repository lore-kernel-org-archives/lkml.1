Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbZJZX33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbZJZX33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZJZX31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:29:27 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:45498 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018AbZJZX3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:29:23 -0400
From: Alex Williamson <alex.williamson@hp.com>
Subject: [PATCH 5/5] intel-iommu: Quiet unnecessary output
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, alex.williamson@hp.com
Date: Mon, 26 Oct 2009 17:25:19 -0600
Message-ID: <20091026232519.9646.31781.stgit@nehalem.aw>
In-Reply-To: <20091026232401.9646.90540.stgit@nehalem.aw>
References: <20091026232401.9646.90540.stgit@nehalem.aw>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alex Williamson <alex.williamson@hp.com>
---

 drivers/pci/intel-iommu.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a7f4476..77f4b25 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1983,7 +1983,8 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
 	   range which is reserved in E820, so which didn't get set
 	   up to start with in si_domain */
 	if (domain == si_domain && hw_pass_through) {
-		printk("Ignoring identity map for HW passthrough device %s [0x%Lx - 0x%Lx]\n",
+		printk(KERN_INFO
+		       "Ignoring identity map for HW passthrough device %s [0x%Lx - 0x%Lx]\n",
 		       pci_name(pdev), start, end);
 		return 0;
 	}

