Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbZDHPB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbZDHPB5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbZDHPAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:00:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:51561 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624AbZDHPAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:00:44 -0400
Message-ID: <49DCBBF1.8080903@kernel.org>
Date: Wed, 08 Apr 2009 08:00:01 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: make 64 bit to use default_inquire_remote_apic -resend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.inquire_remote_apic		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
@@ -362,7 +362,7 @@ struct apic apic_physflat =  {
 	.trampoline_phys_high		= DEFAULT_TRAMPOLINE_PHYS_HIGH,
 	.wait_for_init_deassert		= NULL,
 	.smp_callin_clear_local_apic	= NULL,
-	.inquire_remote_apic		= NULL,
+	.inquire_remote_apic		= default_inquire_remote_apic,
 
 	.read				= native_apic_mem_read,
 	.write				= native_apic_mem_write,
