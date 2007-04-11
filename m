Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXDKJhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXDKJhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXDKJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:37:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:26823 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbXDKJhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:37:24 -0400
X-IronPort-AV: i="4.14,393,1170651600"; 
   d="scan'208"; a="34580463:sNHT21383292"
Subject: [PATCH 1/5] blackfin arch: add missing Blackfin support in lib
	Kconfig debug CONFIG_FRAME_POINTER
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 11 Apr 2007 17:39:51 +0800
Message-Id: <1176284391.29581.26.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 lib/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 558a22e..87afd62 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -385,7 +385,7 @@ config DEBUG_LIST
 
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
-	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH)
+	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN)
 	default y
 	help
 	  If you say Y here the resulting kernel image will be slightly larger
-- 
1.5.0.5

