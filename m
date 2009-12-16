Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbZLPWTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbZLPWTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZLPWTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:19:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbZLPWTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:19:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/3] perf/trace: bugfixes
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Wed, 16 Dec 2009 17:23:54 -0500
Message-ID: <20091216222354.14459.82110.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are several bugfixes for perf-probe and kprobe tracer.

Thank you,

---

Masami Hiramatsu (3):
      perf probe: Check new event name
      kprobe-tracer: Check new event/group name
      perf probe: Check debugpath is correct


 kernel/trace/trace_kprobe.c   |   30 ++++++++++++++++++++++++------
 tools/perf/builtin-probe.c    |    4 ++++
 tools/perf/util/probe-event.c |   14 ++++++++++++++
 3 files changed, 42 insertions(+), 6 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
