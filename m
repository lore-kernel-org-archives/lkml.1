Return-Path: <linux-kernel-owner+w=401wt.eu-S1764781AbZDDAO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764781AbZDDAO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbZDDAOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:14:18 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62735 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbZDDAOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:14:17 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Fri, 03 Apr 2009 17:13:37 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86: make 64 bit to use default_inquire_remote_apic
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-id: <49D6A631.2020706@sun.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: restore old behavior

for flat and phys_flat

Signed-off-by: Yinhai Lu <yinghai@kernel.org.

---
 arch/x86/kernel/apic/apic_flat_64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic_flat_64.c
+++ linux-2.6/arch/x86/kernel/apic/apic_flat_64.c
@@ -212,7 +212,7 @@ struct apic apic_flat =  {
     .trampoline_phys_high        = DEFAULT_TRAMPOLINE_PHYS_HIGH,
     .wait_for_init_deassert        = NULL,
     .smp_callin_clear_local_apic    = NULL,
-    .inquire_remote_apic        = NULL,
+    .inquire_remote_apic        = default_inquire_remote_apic,
 
     .read                = native_apic_mem_read,
     .write                = native_apic_mem_write,
@@ -362,7 +362,7 @@ struct apic apic_physflat =  {
     .trampoline_phys_high        = DEFAULT_TRAMPOLINE_PHYS_HIGH,
     .wait_for_init_deassert        = NULL,
     .smp_callin_clear_local_apic    = NULL,
-    .inquire_remote_apic        = NULL,
+    .inquire_remote_apic        = default_inquire_remote_apic,
 
     .read                = native_apic_mem_read,
     .write                = native_apic_mem_write,
