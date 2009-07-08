Return-Path: <linux-kernel-owner+w=401wt.eu-S1759061AbZGHWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759061AbZGHWcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZGHWbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47044 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758134AbZGHWbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:41 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [1/8] x86: mce: Make CONFIG_X86_ANCIENT_MCE dependent on CONFIG_X86_MCE
Message-Id: <20090708223137.C80841D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add a missing depency for ANCIENT_MCE. It didn't matter
in practice because the ANCIENT code wasn't compiled without
X86_MCE, but it's better to express that clearly in
Kconfig.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -826,7 +826,7 @@ config X86_MCE_AMD
 
 config X86_ANCIENT_MCE
 	def_bool n
-	depends on X86_32
+	depends on X86_32 && X86_MCE
 	prompt "Support for old Pentium 5 / WinChip machine checks"
 	---help---
 	  Include support for machine check handling on old Pentium 5 or WinChip
