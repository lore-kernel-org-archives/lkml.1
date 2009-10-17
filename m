Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZJQKGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZJQKGV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbZJQKGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:06:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33089 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753900AbZJQKFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:05:55 -0400
Date: Sat, 17 Oct 2009 10:05:28 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091017000736.16556.29061.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000736.16556.29061.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Add MMX/SSE opcode groups to opcode map
Message-ID: <tip-8c95bc3e206cff7a55edd2fc5f0e2b305d57903f@git.kernel.org>
Git-Commit-ID: 8c95bc3e206cff7a55edd2fc5f0e2b305d57903f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:05:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c95bc3e206cff7a55edd2fc5f0e2b305d57903f
Gitweb:     http://git.kernel.org/tip/8c95bc3e206cff7a55edd2fc5f0e2b305d57903f
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 16 Oct 2009 20:07:36 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:53:58 +0200

x86: Add MMX/SSE opcode groups to opcode map

Add missing MMX/SSE opcode groups to x86 opcode map.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091017000736.16556.29061.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/lib/x86-opcode-map.txt |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 78a0daf..e7285d8 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -777,12 +777,22 @@ GrpTable: Grp11
 EndTable
 
 GrpTable: Grp12
+2: psrlw Nq,Ib (11B) | psrlw Udq,Ib (66),(11B)
+4: psraw Nq,Ib (11B) | psraw Udq,Ib (66),(11B)
+6: psllw Nq,Ib (11B) | psllw Udq,Ib (66),(11B)
 EndTable
 
 GrpTable: Grp13
+2: psrld Nq,Ib (11B) | psrld Udq,Ib (66),(11B)
+4: psrad Nq,Ib (11B) | psrad Udq,Ib (66),(11B)
+6: pslld Nq,Ib (11B) | pslld Udq,Ib (66),(11B)
 EndTable
 
 GrpTable: Grp14
+2: psrlq Nq,Ib (11B) | psrlq Udq,Ib (66),(11B)
+3: psrldq Udq,Ib (66),(11B)
+6: psllq Nq,Ib (11B) | psllq Udq,Ib (66),(11B)
+7: pslldq Udq,Ib (66),(11B)
 EndTable
 
 GrpTable: Grp15
