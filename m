Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbZF3VFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbZF3VFG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZF3VE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:04:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbZF3VE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:04:56 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/3] kprobes: trivial bugfixes and cleanup
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 30 Jun 2009 17:07:58 -0400
Message-ID: <20090630210757.17851.409.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are trivial bugfix and cleanup patches for kprobes which
I've found in kprobes-tracer and kprobes-jump optimization
developement.
Please apply it.

Thank you,
 
---
 
Masami Hiramatsu (3):
      kprobes: cleanup: use list instead of hlist for insn_pages
      kprobes: no need to unlock kprobe_insn_mutex
      kprobes: fix kprobe selftest configuration dependency


 kernel/kprobes.c  |   36 ++++++++++++------------------------
 lib/Kconfig.debug |    1 +
 2 files changed, 13 insertions(+), 24 deletions(-)

-- 
Masami Hiramatsu
 
Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
 
e-mail: mhiramat@redhat.com

