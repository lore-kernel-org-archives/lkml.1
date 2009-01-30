Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZA3KSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZA3KSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbZA3KRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:52 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54357 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZA3KRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:49 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Mark NUMAQ broken
Date: Fri, 30 Jan 2009 11:17:09 +0100
Message-Id: <1233310639-27916-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-3-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In preparation from removal

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index afaf2cb..fa234a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -347,7 +347,7 @@ config X86_BIGSMP
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	depends on X86_32_NON_STANDARD
+	depends on X86_32_NON_STANDARD && BROKEN
 	select NUMA
 	select X86_MPPARSE
 	help
-- 
1.5.6.5

