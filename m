Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZJCCbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZJCCbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZJCCbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:31:31 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60874 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZJCCba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:31:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TWw1bhb09xCzUwEFhHN/Thj/nCJitaG9XhGXNUbbOoMji0hh1eInJ46HcTCL2Bgao7
         LzK9q/uRMOw9pEOvZ1lmUZ+NiKShisF6rNcvUQCAS02NGmxxBHSMiaN6BI9ZvnGKWfnp
         NgD+EGwBzoxryxgnvAq1ASMpmDwR1IToOdwYI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [GIT PULL] tracing/kprobes: kprobes fixes
Date: Sat,  3 Oct 2009 04:31:28 +0200
Message-Id: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the tracing/kprobes tree that can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes

(I'm just waiting a bit before pushing the perf probe patches
while we discuss some syntax things).

Thanks.

Masami Hiramatsu (3):
      tracing/kprobes: Use global event perf buffers in kprobe tracer
      x86: Add VIA processor instructions in opcodes decoder
      tracing/ftrace: Fix to check create_event_dir() when adding new events

 arch/x86/lib/x86-opcode-map.txt |    8 +++-
 kernel/trace/trace_events.c     |   25 +++++----
 kernel/trace/trace_kprobe.c     |  115 +++++++++++++++++++++++++--------------
 3 files changed, 94 insertions(+), 54 deletions(-)
