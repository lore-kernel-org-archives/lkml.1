Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZIQUOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZIQUOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZIQUNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:13:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:56492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbZIQUNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:13:37 -0400
Date: Thu, 17 Sep 2009 22:13:37 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       lizf@cn.fujitsu.com
Subject: [git pull] timechart for -tip
Message-ID: <20090917221337.7a7b3c81@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull the timechart patches into -tip;
they have been posted to lkml last week, but since then some merge conflicts have been resolved,
as well as the feedback from Li Zefan have been incorporated.

The following changes since commit c6da392f3d7f51e059e1ce80fcb2614e3c8a8a0d:
  Ingo Molnar (1):
        Merge branch 'tracing/core'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-timechart master

Arjan van de Ven (8):
      perf: Add a timestamp to fork events
      perf: Store trace event name/id pairs in perf.data
      perf: Allow perf utilities to have "callback" options without arguments
      perf: Add a sample_event type to the event_union
      trace: Convert the power tracer into an event tracer
      perf: Add a SVG helper library file
      perf: Add a perf record --timechart option
      perf: Add the timechart tool

 Documentation/trace/power.txt              |   17 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    7 +-
 arch/x86/kernel/process.c                  |   28 +-
 include/linux/perf_counter.h               |    2 +
 include/trace/events/power.h               |   81 ++
 kernel/perf_counter.c                      |   11 +-
 kernel/trace/Makefile                      |    2 +-
 kernel/trace/power-traces.c                |   20 +
 kernel/trace/trace.h                       |    3 -
 kernel/trace/trace_entries.h               |   17 -
 kernel/trace/trace_power.c                 |  218 ------
 scripts/tracing/power.pl                   |  108 ---
 tools/perf/Makefile                        |    8 +
 tools/perf/builtin-record.c                |   28 +
 tools/perf/builtin-timechart.c             | 1120 ++++++++++++++++++++++++++++
 tools/perf/builtin.h                       |    1 +
 tools/perf/perf.c                          |    1 +
 tools/perf/util/event.h                    |    8 +
 tools/perf/util/header.c                   |   59 ++
 tools/perf/util/header.h                   |    6 +
 tools/perf/util/parse-events.c             |   25 +
 tools/perf/util/parse-options.h            |    2 +
 tools/perf/util/svghelper.c                |  382 ++++++++++
 tools/perf/util/svghelper.h                |   25 +
 24 files changed, 1789 insertions(+), 390 deletions(-)
 delete mode 100644 Documentation/trace/power.txt
 create mode 100644 include/trace/events/power.h
 create mode 100644 kernel/trace/power-traces.c
 delete mode 100644 kernel/trace/trace_power.c
 delete mode 100644 scripts/tracing/power.pl
 create mode 100644 tools/perf/builtin-timechart.c
 create mode 100644 tools/perf/util/svghelper.c
 create mode 100644 tools/perf/util/svghelper.h


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
