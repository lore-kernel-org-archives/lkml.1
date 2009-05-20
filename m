Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbZETSon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbZETSon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZETSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:44:14 -0400
Received: from sg2ehsobe002.messaging.microsoft.com ([207.46.51.76]:23879 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757097AbZETSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:44:13 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KJYHD6-02-V44-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 2/4] amd64_edac: do not enable module by default
Date: Wed, 20 May 2009 20:43:55 +0200
Message-ID: <1242845037-1029-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 May 2009 18:43:59.0622 (UTC) FILETIME=[F0382A60:01C9D97A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While at it, fix a link failure when !K8_NB.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 1c5a325..d294421 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -60,11 +60,10 @@ config EDAC_MM_EDAC
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && X86 && PCI
-	default m
+	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI
 	help
-	Support for error detection and correction on the AMD 64
-	Families of Memory Controllers (K8, F10h and F11h)
+	  Support for error detection and correction on the AMD 64
+	  Families of Memory Controllers (K8, F10h and F11h)
 
 config EDAC_AMD64_ERROR_INJECTION
 	bool "Sysfs Error Injection facilities"
-- 
1.6.2.4


