Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbXLMJf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbXLMJf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 04:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbXLMJfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 04:35:15 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:32365
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbXLMJfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 04:35:13 -0500
Message-Id: <47610B13.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 13 Dec 2007 09:36:03 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: eliminate unused exports
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 arch/x86/kernel/smp_32.c |    1 -
 arch/x86/kernel/smp_64.c |    3 ---
 2 files changed, 4 deletions(-)

--- linux-2.6.24-rc5/arch/x86/kernel/smp_32.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-flushtlb-exports/arch/x86/kernel/smp_32.c	2007-12-04 16:09:33.000000000 +0100
@@ -448,7 +448,6 @@ void flush_tlb_page(struct vm_area_struc
 
 	preempt_enable();
 }
-EXPORT_SYMBOL(flush_tlb_page);
 
 static void do_flush_tlb_all(void* info)
 {
--- linux-2.6.24-rc5/arch/x86/kernel/smp_64.c	2007-12-12 11:28:18.000000000 +0100
+++ 2.6.24-rc5-x86-flushtlb-exports/arch/x86/kernel/smp_64.c	2007-12-04 16:09:33.000000000 +0100
@@ -224,7 +224,6 @@ void flush_tlb_current_task(void)
 		flush_tlb_others(cpu_mask, mm, FLUSH_ALL);
 	preempt_enable();
 }
-EXPORT_SYMBOL(flush_tlb_current_task);
 
 void flush_tlb_mm (struct mm_struct * mm)
 {
@@ -245,7 +244,6 @@ void flush_tlb_mm (struct mm_struct * mm
 
 	preempt_enable();
 }
-EXPORT_SYMBOL(flush_tlb_mm);
 
 void flush_tlb_page(struct vm_area_struct * vma, unsigned long va)
 {
@@ -268,7 +266,6 @@ void flush_tlb_page(struct vm_area_struc
 
 	preempt_enable();
 }
-EXPORT_SYMBOL(flush_tlb_page);
 
 static void do_flush_tlb_all(void* info)
 {



