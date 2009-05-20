Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbZETSob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbZETSob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZETSoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:44:11 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:2367 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755228AbZETSoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:44:10 -0400
X-BigFish: VPS1(zzzz1202hzzz32i64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KJYHD7-01-2UL-01
From: Borislav Petkov <borislav.petkov@amd.com>
To: <akpm@linux-foundation.org>, <greg@kroah.com>, <mingo@elte.hu>
CC: <norsk5@yahoo.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <mchehab@redhat.com>, <aris@redhat.com>, edt@aei.ca,
       <linux-kernel@vger.kernel.org>, randy.dunlap@oracle.com,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 3/4] EDAC: do not enable modules by default
Date: Wed, 20 May 2009 20:43:56 +0200
Message-ID: <1242845037-1029-4-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.2.4
In-Reply-To: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 20 May 2009 18:44:00.0075 (UTC) FILETIME=[F07D49B0:01C9D97A]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent EDAC compilation units from being built by default and let the
user explicitly select the needed modules.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index d294421..bb2cff8 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -49,7 +49,6 @@ config EDAC_DEBUG_VERBOSE
 
 config EDAC_MM_EDAC
 	tristate "Main Memory EDAC (Error Detection And Correction) reporting"
-	default y
 	help
 	  Some systems are able to detect and correct errors in main
 	  memory.  EDAC can report statistics on memory error
-- 
1.6.2.4


