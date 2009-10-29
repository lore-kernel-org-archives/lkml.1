Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbZJ2IH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbZJ2IH6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZJ2IH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:07:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:52946 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZJ2IHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:07:54 -0400
Date: Thu, 29 Oct 2009 08:06:57 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091027204204.30545.97296.stgit@harusame>
References: <20091027204204.30545.97296.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Fix SSE opcode map bug
Message-ID: <tip-7f387d3f2421781610588faa2f49ae5f1737b137@git.kernel.org>
Git-Commit-ID: 7f387d3f2421781610588faa2f49ae5f1737b137
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f387d3f2421781610588faa2f49ae5f1737b137
Gitweb:     http://git.kernel.org/tip/7f387d3f2421781610588faa2f49ae5f1737b137
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:42:04 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:45 +0100

x86: Fix SSE opcode map bug

Fix superscripts position because some superscripts of SSE
opcode are not put in correct position.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091027204204.30545.97296.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/x86-opcode-map.txt |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 701c467..efef3ca 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -401,9 +401,9 @@ Referrer: 2-byte escape
 62: punpckldq Pq,Qd | punpckldq Vdq,Wdq (66)
 63: packsswb Pq,Qq | packsswb Vdq,Wdq (66)
 64: pcmpgtb Pq,Qq | pcmpgtb Vdq,Wdq (66)
-65: pcmpgtw Pq,Qq | pcmpgtw(66) Vdq,Wdq
+65: pcmpgtw Pq,Qq | pcmpgtw Vdq,Wdq (66)
 66: pcmpgtd Pq,Qq | pcmpgtd Vdq,Wdq (66)
-67: packuswb Pq,Qq | packuswb(66) Vdq,Wdq
+67: packuswb Pq,Qq | packuswb Vdq,Wdq (66)
 68: punpckhbw Pq,Qd | punpckhbw Vdq,Wdq (66)
 69: punpckhwd Pq,Qd | punpckhwd Vdq,Wdq (66)
 6a: punpckhdq Pq,Qd | punpckhdq Vdq,Wdq (66)
@@ -425,8 +425,8 @@ Referrer: 2-byte escape
 79: VMWRITE Gd/q,Ed/q
 7a:
 7b:
-7c: haddps(F2) Vps,Wps | haddpd(66) Vpd,Wpd
-7d: hsubps(F2) Vps,Wps | hsubpd(66) Vpd,Wpd
+7c: haddps Vps,Wps (F2) | haddpd Vpd,Wpd (66)
+7d: hsubps Vps,Wps (F2) | hsubpd Vpd,Wpd (66)
 7e: movd/q Ed/q,Pd | movd/q Ed/q,Vdq (66) | movq Vq,Wq (F3)
 7f: movq Qq,Pq | movdqa Wdq,Vdq (66) | movdqu Wdq,Vdq (F3)
 # 0x0f 0x80-0x8f
@@ -574,7 +574,7 @@ Referrer: 3-byte escape 1
 01: phaddw Pq,Qq | phaddw Vdq,Wdq (66)
 02: phaddd Pq,Qq | phaddd Vdq,Wdq (66)
 03: phaddsw Pq,Qq | phaddsw Vdq,Wdq (66)
-04: pmaddubsw Pq,Qq | pmaddubsw (66)Vdq,Wdq
+04: pmaddubsw Pq,Qq | pmaddubsw Vdq,Wdq (66)
 05: phsubw Pq,Qq | phsubw Vdq,Wdq (66)
 06: phsubd Pq,Qq | phsubd Vdq,Wdq (66)
 07: phsubsw Pq,Qq | phsubsw Vdq,Wdq (66)
