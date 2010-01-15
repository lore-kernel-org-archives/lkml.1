Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0AOGY6 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 01:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364Ab0AOGY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 01:24:57 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42930 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab0AOGY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 01:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WGRwBCU3LaaycvMIbXQ2yzqIKx6iCDp5uBr2+/6sOhT+rUxORUvyFA4Z0Mt+l0cxZk
         Edfp86dHX6mqvtgmEf4qIw3SQDrM+BrirDJpgbQbgeqlzESs48hPwfawH+xXuvRdCN4X
         eg0Qp3z/CR7UqkToyDWtUyDW8NUgtlVjpbQX4=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH] fix a typo in pci-dma.c
Date: Thu, 14 Jan 2010 22:16:16 -0800
Message-Id: <1263536176-9154-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
---
 arch/x86/kernel/pci-dma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 75e14e2..eec33a7 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -38,7 +38,7 @@ int iommu_detected __read_mostly = 0;
  * This variable becomes 1 if iommu=pt is passed on the kernel command line.
  * If this variable is 1, IOMMU implementations do no DMA translation for
  * devices and allow every device to access to whole physical memory. This is
- * useful if a user want to use an IOMMU only for KVM device assignment to
+ * useful if a user wants to use an IOMMU only for KVM device assignment to
  * guests and not for driver dma translation.
  */
 int iommu_pass_through __read_mostly;
-- 
1.6.5.GIT

