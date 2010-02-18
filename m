Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab0BRLjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:39:07 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:33618
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757944Ab0BRLjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:39:00 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMab9bhzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KY1CCJ-02-FSQ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 10/10] KVM: SVM: Remove newlines from nested trace points
Date: Thu, 18 Feb 2010 12:38:35 +0100
Message-ID: <1266493115-28386-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 18 Feb 2010 11:38:37.0718 (UTC) FILETIME=[E92A2B60:01CAB08E]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tracing infrastructure adds its own newlines. Remove
them from the trace point printk format strings.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/trace.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6ad30a2..12f8d2d 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -413,7 +413,7 @@ TRACE_EVENT(kvm_nested_vmrun,
 	),
 
 	TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
-		  "event_inj: 0x%08x npt: %s\n",
+		  "event_inj: 0x%08x npt: %s",
 		__entry->rip, __entry->vmcb, __entry->nested_rip,
 		__entry->int_ctl, __entry->event_inj,
 		__entry->npt ? "on" : "off")
@@ -447,7 +447,7 @@ TRACE_EVENT(kvm_nested_vmexit,
 		__entry->exit_int_info_err	= exit_int_info_err;
 	),
 	TP_printk("rip: 0x%016llx reason: %s ext_inf1: 0x%016llx "
-		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x\n",
+		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
 		  __entry->rip,
 		  ftrace_print_symbols_seq(p, __entry->exit_code,
 					   kvm_x86_ops->exit_reasons_str),
@@ -482,7 +482,7 @@ TRACE_EVENT(kvm_nested_vmexit_inject,
 	),
 
 	TP_printk("reason: %s ext_inf1: 0x%016llx "
-		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x\n",
+		  "ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x",
 		  ftrace_print_symbols_seq(p, __entry->exit_code,
 					   kvm_x86_ops->exit_reasons_str),
 		__entry->exit_info1, __entry->exit_info2,
@@ -504,7 +504,7 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
 		__entry->rip	=	rip
 	),
 
-	TP_printk("rip: 0x%016llx\n", __entry->rip)
+	TP_printk("rip: 0x%016llx", __entry->rip)
 );
 
 /*
@@ -526,7 +526,7 @@ TRACE_EVENT(kvm_invlpga,
 		__entry->address	=	address;
 	),
 
-	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx\n",
+	TP_printk("rip: 0x%016llx asid: %d address: 0x%016llx",
 		  __entry->rip, __entry->asid, __entry->address)
 );
 
@@ -547,7 +547,7 @@ TRACE_EVENT(kvm_skinit,
 		__entry->slb		=	slb;
 	),
 
-	TP_printk("rip: 0x%016llx slb: 0x%08x\n",
+	TP_printk("rip: 0x%016llx slb: 0x%08x",
 		  __entry->rip, __entry->slb)
 );
 
-- 
1.6.6


