Return-Path: <linux-kernel-owner+w=401wt.eu-S934305AbZKXVyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934305AbZKXVyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:54:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933989AbZKXVyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:54:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32783 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979AbZKXVyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:54:07 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v4 0/3] tracepoint: Add signal events
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 24 Nov 2009 16:56:38 -0500
Message-ID: <20091124215638.30449.3838.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add signal related tracepoints including
signal generation, delivery, and loss. First patch also
moves signal-sending tracepoint from events/sched.h to
events/signal.h.

Changes in v4
- Fix typo of task_struct pointer

Changes in v3
- Add Docbook style comments

Changes in v2
- Add siginfo arguments

Thank you,

---

Masami Hiramatsu (3):
      tracepoint: Add signal loss events
      tracepoint: Add signal deliver event
      tracepoint: Move signal sending tracepoint to events/signal.h


 Documentation/DocBook/tracepoint.tmpl |    5 +
 include/trace/events/sched.h          |   25 -----
 include/trace/events/signal.h         |  173 +++++++++++++++++++++++++++++++++
 kernel/signal.c                       |   27 ++++-
 4 files changed, 198 insertions(+), 32 deletions(-)
 create mode 100644 include/trace/events/signal.h

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
