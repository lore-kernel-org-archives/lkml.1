Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZA3KSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZA3KSf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbZA3KRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54371 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbZA3KRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:49 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Mark ES7000 subarch broken
Date: Fri, 30 Jan 2009 11:17:10 +0100
Message-Id: <1233310639-27916-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-4-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In preparation for removal

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa234a5..a753336 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -366,7 +366,7 @@ config X86_SUMMIT
 
 config X86_ES7000
 	bool "Support for Unisys ES7000 IA32 series"
-	depends on X86_32_NON_STANDARD
+	depends on X86_32_NON_STANDARD && BROKEN
 	help
 	  Support for Unisys ES7000 systems.  Say 'Y' here if this kernel is
 	  supposed to run on an IA32-based Unisys ES7000 system.
-- 
1.5.6.5

