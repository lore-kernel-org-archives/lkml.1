Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbZEGWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbZEGWcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762607AbZEGW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:19804 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757507AbZEGW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470486"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 13/14] x86: make CONFIG_RELOCATABLE the default
Date: Thu,  7 May 2009 15:27:01 -0700
Message-Id: <1241735222-6640-14-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Remove the EXPERIMENTAL tag from CONFIG_RELOCATABLE and make it the
default.  Relocatable kernels have been used for a while now, and
should now have identical semantics to non-relocatable kernels when
loaded by a non-relocating bootloader.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cd76de1..d3c8b0d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1500,8 +1500,8 @@ config PHYSICAL_START
 	  Don't change this unless you know what you are doing.
 
 config RELOCATABLE
-	bool "Build a relocatable kernel (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
+	bool "Build a relocatable kernel"
+	default y
 	---help---
 	  This builds a kernel image that retains relocation information
 	  so it can be loaded someplace besides the default 1MB.
-- 
1.6.0.6

