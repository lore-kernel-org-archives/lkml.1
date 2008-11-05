Return-Path: <linux-kernel-owner+w=401wt.eu-S1756740AbYKEThk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740AbYKEThk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754723AbYKEThc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:37:32 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:2810 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbYKEThb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:37:31 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch] x86: mention ACPI in top-level Kconfig menu
Date: Wed, 5 Nov 2008 13:37:27 -0600
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811051237.28514.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mention ACPI in the top-level menu to give a clue as to where
it lives.  This matches what ia64 does.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e60c59b..60d40fb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1494,7 +1494,7 @@ config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
 
-menu "Power management options"
+menu "Power management and ACPI"
 	depends on !X86_VOYAGER
 
 config ARCH_HIBERNATION_HEADER
