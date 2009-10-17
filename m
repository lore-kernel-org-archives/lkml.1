Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZJQAH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZJQAH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbZJQAHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:07:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZJQAHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:07:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 3/9] x86: Add MMX/SSE opcode groups to
	opcode map
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:07:36 -0400
Message-ID: <20091017000736.16556.29061.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing MMX/SSE opcode groups to x86 opcode map.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
