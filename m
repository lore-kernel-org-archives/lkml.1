Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbZKTV2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbZKTV2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755602AbZKTV2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:28:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576AbZKTV2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:28:44 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v3 0/3] tracepoint: Add signal events
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Fri, 20 Nov 2009 16:31:08 -0500
Message-ID: <20091120213108.14708.97871.stgit@dhcp-100-2-132.bos.redhat.com>
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
