Return-Path: <linux-kernel-owner+w=401wt.eu-S1761923AbXKIGES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761923AbXKIGES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXKIGDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:03:38 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52859 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755062AbXKIGDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:03:37 -0500
Date: Fri, 9 Nov 2007 07:03:13 +0100
From: Adrian Bunk <bunk@kernel.org>
To: lenb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [2.6 patch] x86_64: remove acpi_pci_link_exit()
Message-ID: <20071109060313.GS26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pci_link_exit() is both unused and empty.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
16d6853a1facb9bcb7a4bc19daad6d3b852cace3 
diff --git a/arch/x86/kernel/acpi/sleep_64.c b/arch/x86/kernel/acpi/sleep_64.c
index 79475d2..da42de2 100644
--- a/arch/x86/kernel/acpi/sleep_64.c
+++ b/arch/x86/kernel/acpi/sleep_64.c
@@ -115,6 +115,3 @@ static int __init acpi_sleep_setup(char *str)
 
 __setup("acpi_sleep=", acpi_sleep_setup);
 
-void acpi_pci_link_exit(void)
-{
-}

