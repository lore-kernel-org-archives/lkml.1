Return-Path: <linux-kernel-owner+w=401wt.eu-S1752752AbZJ2IIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbZJ2IIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZJ2IIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:08:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:52968 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbZJ2IIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:08:17 -0400
Date: Thu, 29 Oct 2009 08:07:30 GMT
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
In-Reply-To: <20091027204219.30545.82039.stgit@harusame>
References: <20091027204219.30545.82039.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Add pclmulq to x86 opcode map
Message-ID: <tip-82cb57028c864822c5a260f806d051e2ce28c86a@git.kernel.org>
Git-Commit-ID: 82cb57028c864822c5a260f806d051e2ce28c86a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82cb57028c864822c5a260f806d051e2ce28c86a
Gitweb:     http://git.kernel.org/tip/82cb57028c864822c5a260f806d051e2ce28c86a
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:42:19 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:46 +0100

x86: Add pclmulq to x86 opcode map

Add pclmulq opcode to x86 opcode map.

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
LKML-Reference: <20091027204219.30545.82039.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/x86-opcode-map.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index efef3ca..1f41246 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -672,6 +672,7 @@ Referrer: 3-byte escape 2
 40: dpps Vdq,Wdq,Ib (66)
 41: dppd Vdq,Wdq,Ib (66)
 42: mpsadbw Vdq,Wdq,Ib (66)
+44: pclmulq Vdq,Wdq,Ib (66)
 60: pcmpestrm Vdq,Wdq,Ib (66)
 61: pcmpestri Vdq,Wdq,Ib (66)
 62: pcmpistrm Vdq,Wdq,Ib (66)
