Return-Path: <linux-kernel-owner+w=401wt.eu-S1762694AbXGJDS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762694AbXGJDS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758893AbXGJDSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:18:20 -0400
Received: from terminus.zytor.com ([192.83.249.54]:51090 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013AbXGJDST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:18:19 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 11/33] x86-64: add CONFIG_PHYSICAL_ALIGN for consistency with i386
Date: Mon,  9 Jul 2007 19:51:50 -0700
Message-Id: <11840370903975-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840369841576-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
Message-Id: <bbeadd1995da049cf6880ab58794f84ec8785a08.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Add CONFIG_PHYSICAL_ALIGN (currently as a hardcoded constant) to provide
consistency with i386.  This value is manifest in the bzImage header.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86_64/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 5ce9443..8bdd25a 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -427,6 +427,10 @@ config NR_CPUS
 	  This is purely to save memory - each supported CPU requires
 	  memory in the static kernel configuration.
 
+config PHYSICAL_ALIGN
+	hex
+	default "0x200000"
+
 config HOTPLUG_CPU
 	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
 	depends on SMP && HOTPLUG && EXPERIMENTAL
-- 
1.5.2.2

