Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbZHPSBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbZHPSBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 14:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZHPSBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 14:01:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56181 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbZHPSBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 14:01:33 -0400
Date: Sun, 16 Aug 2009 18:00:51 GMT
From: tip-bot for Leonardo Potenza <lpotenza@inwind.it>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       lpotenza@inwind.it, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       lpotenza@inwind.it, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200908161855.48302.lpotenza@inwind.it>
References: <200908161855.48302.lpotenza@inwind.it>
Subject: [tip:x86/urgent] x86: Annotate section mismatch warnings in kernel/apic/x2apic_uv_x.c
Message-ID: <tip-52459ab91363343af8ae252766e9da762344a2e7@git.kernel.org>
Git-Commit-ID: 52459ab91363343af8ae252766e9da762344a2e7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 16 Aug 2009 18:00:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  52459ab91363343af8ae252766e9da762344a2e7
Gitweb:     http://git.kernel.org/tip/52459ab91363343af8ae252766e9da762344a2e7
Author:     Leonardo Potenza <lpotenza@inwind.it>
AuthorDate: Sun, 16 Aug 2009 18:55:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 16 Aug 2009 19:44:13 +0200

x86: Annotate section mismatch warnings in kernel/apic/x2apic_uv_x.c

The function uv_acpi_madt_oem_check() has been marked __init,
the struct apic_x2apic_uv_x has been marked __refdata.

The aim is to address the following section mismatch messages:

WARNING: arch/x86/kernel/apic/built-in.o(.data+0x1368): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .cpuinit.text:uv_wakeup_secondary()
The variable apic_x2apic_uv_x references
the function __cpuinit uv_wakeup_secondary()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: arch/x86/kernel/built-in.o(.data+0x68e8): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .cpuinit.text:uv_wakeup_secondary()
The variable apic_x2apic_uv_x references
the function __cpuinit uv_wakeup_secondary()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

WARNING: arch/x86/built-in.o(.text+0x7b36f): Section mismatch in reference from the function uv_acpi_madt_oem_check() to the function .init.text:early_ioremap()
The function uv_acpi_madt_oem_check() references
the function __init early_ioremap().
This is often because uv_acpi_madt_oem_check lacks a __init
annotation or the annotation of early_ioremap is wrong.

WARNING: arch/x86/built-in.o(.text+0x7b38d): Section mismatch in reference from the function uv_acpi_madt_oem_check() to the function .init.text:early_iounmap()
The function uv_acpi_madt_oem_check() references
the function __init early_iounmap().
This is often because uv_acpi_madt_oem_check lacks a __init
annotation or the annotation of early_iounmap is wrong.

WARNING: arch/x86/built-in.o(.data+0x8668): Section mismatch in reference from the variable apic_x2apic_uv_x to the function .cpuinit.text:uv_wakeup_secondary()
The variable apic_x2apic_uv_x references
the function __cpuinit uv_wakeup_secondary()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
LKML-Reference: <200908161855.48302.lpotenza@inwind.it>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 832e908..6011593 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -46,7 +46,7 @@ static int early_get_nodeid(void)
 	return node_id.s.node_id;
 }
 
-static int uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
+static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	if (!strcmp(oem_id, "SGI")) {
 		if (!strcmp(oem_table_id, "UVL"))
@@ -253,7 +253,7 @@ static void uv_send_IPI_self(int vector)
 	apic_write(APIC_SELF_IPI, vector);
 }
 
-struct apic apic_x2apic_uv_x = {
+struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
 	.probe				= NULL,
