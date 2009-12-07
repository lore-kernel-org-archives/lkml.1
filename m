Return-Path: <linux-kernel-owner+w=401wt.eu-S935470AbZLGQ5t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935470AbZLGQ5t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:57:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935384AbZLGQ5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:57:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935285AbZLGQ5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:57:46 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX PATCH -tip 0/5] perf-probe/x86 insn decoder bugfixes
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Mon, 07 Dec 2009 12:00:27 -0500
Message-ID: <20091207170027.19230.39491.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here are several bugfixes which are reported on LKML
for perf-probe and x86 insn decoder.

Thank you,

---

Juha Leppanen (1):
      perf probe: Fix strtailcmp() to compare s1[0] and s2[0]

Masami Hiramatsu (4):
      perf probe: Use pr_debug for debug message
      perf probe: Check e_snprintf() format string
      perf probe: Fix event namelist to duplicate string
      x86 insn: Delete empty or incomplete inat-tables.c


 arch/x86/lib/Makefile          |    2 +-
 tools/perf/builtin-probe.c     |    4 ++--
 tools/perf/util/probe-event.c  |    9 +++++++--
 tools/perf/util/probe-finder.c |    2 +-
 4 files changed, 11 insertions(+), 6 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
