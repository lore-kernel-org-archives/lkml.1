Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZF3KzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZF3KzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 06:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZF3KzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 06:55:13 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:43936 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZF3KzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 06:55:12 -0400
Message-Id: <4A4A0B2E02000078000082FE@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 11:55:10 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] ix86: minor highmem related Kconfig cleanup
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a redundant conditional and consolidate a dependency.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc1/arch/x86/Kconfig	2009-06-26 17:49:41.000000000 +0200
+++ 2.6.31-rc1-x86-kconfig-cleanup/arch/x86/Kconfig	2009-06-23 14:07:12.000000000 +0200
@@ -1001,8 +1001,8 @@ config X86_CPU_DEBUG
 
 choice
 	prompt "High Memory Support"
-	default HIGHMEM4G if !X86_NUMAQ
 	default HIGHMEM64G if X86_NUMAQ
+	default HIGHMEM4G
 	depends on X86_32
 
 config NOHIGHMEM
@@ -1251,7 +1251,7 @@ source "mm/Kconfig"
 
 config HIGHPTE
 	bool "Allocate 3rd-level pagetables from highmem"
-	depends on X86_32 && (HIGHMEM4G || HIGHMEM64G)
+	depends on HIGHMEM
 	---help---
 	  The VM uses one page table entry for each page of physical memory.
 	  For systems with a lot of RAM, this can be wasteful of precious



