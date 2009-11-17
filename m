Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbZKQXkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbZKQXkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 18:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZKQXkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 18:40:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539AbZKQXkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 18:40:31 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/3] tracepoint: Add signal events
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 17 Nov 2009 18:41:17 -0500
Message-ID: <20091117234117.30589.61311.stgit@dhcp-100-2-132.bos.redhat.com>
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

TODO:
- Add signal-wakeup event?

Thank you,

---

Masami Hiramatsu (3):
      tracepoint: Add signal loss events
      tracepoint: Add signal deliver event
      tracepoint: Move signal sending tracepoint to events/signal.h


 include/trace/events/sched.h  |   25 --------
 include/trace/events/signal.h |  133 +++++++++++++++++++++++++++++++++++++++++
 kernel/signal.c               |   27 ++++++--
 3 files changed, 153 insertions(+), 32 deletions(-)
 create mode 100644 include/trace/events/signal.h

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
