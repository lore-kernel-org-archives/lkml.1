Return-Path: <linux-kernel-owner+w=401wt.eu-S1758494AbYGPIB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758494AbYGPIB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYGPIBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:01:51 -0400
Received: from smtp.movial.fi ([62.236.91.34]:51419 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202AbYGPIBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:01:51 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3 part 2] [MIPS] make the pcibios_max_latency variable static
Date: Wed, 16 Jul 2008 11:01:49 +0300
Message-Id: <1216195309-13069-1-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1216141052-28005-2-git-send-email-dmitri.vorobiev@movial.fi>
References: <1216141052-28005-2-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Along with making the pcibios_max_latency variable static,
its declaration needs to be removed from the header file.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---

Hi Ralf,

Forgot about this one yesterday, sorry.

Dmitri

 include/asm-mips/pci.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/asm-mips/pci.h b/include/asm-mips/pci.h
index d3be834..c205875 100644
--- a/include/asm-mips/pci.h
+++ b/include/asm-mips/pci.h
@@ -173,6 +173,5 @@ static inline int pci_get_legacy_ide_irq(struct pci_dev *dev, int channel)
 }
 
 extern int pci_probe_only;
-extern unsigned int pcibios_max_latency;
 
 #endif /* _ASM_PCI_H */
-- 
1.5.6

