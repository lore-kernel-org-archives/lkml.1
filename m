Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbZFPUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbZFPUQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbZFPUQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:16:06 -0400
Received: from claw.goop.org ([74.207.240.146]:40562 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbZFPUQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:16:04 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 05/16] x86/acpi: acpi_parse_madt_ioapic_entries: remove redundant braces
Date: Tue, 16 Jun 2009 13:15:44 -0700
Message-Id: <1245183355-25808-6-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
In-Reply-To: <1245183355-25808-1-git-send-email-jeremy@goop.org>
References: <1245183355-25808-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

We don't put braces around a single statement.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/acpi/boot.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 6310861..2410469 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1249,9 +1249,8 @@ static int __init acpi_parse_madt_ioapic_entries(void)
 	 * If MPS is present, it will handle them,
 	 * otherwise the system will stay in PIC mode
 	 */
-	if (acpi_disabled || acpi_noirq) {
+	if (acpi_disabled || acpi_noirq)
 		return -ENODEV;
-	}
 
 	if (!cpu_has_apic)
 		return -ENODEV;
-- 
1.6.2.2

