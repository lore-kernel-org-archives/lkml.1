Return-Path: <linux-kernel-owner+w=401wt.eu-S932174AbZISLg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbZISLg4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZISLgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:36:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:50810 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684AbZISLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:36:36 -0400
Date: Sat, 19 Sep 2009 13:34:10 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: [git pull] incremental updates to timechart
Message-ID: <20090919133410.7b23e270@infradead.org>
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

Hi Ingo,

a few incremental updates to timechart are now in my git tree; mostly based
on your review feedback. The individual patches will be sent as reply to this email


The following changes since commit a98c33c37d5973f2c4edeac7426b9a944d668fe1:
  Ingo Molnar (1):
        Merge branch 'tracing/urgent'

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-timechart master

Arjan van de Ven (5):
      perf: Add "perf timechart record"
      perf: Be consistent about minimum text size in the svghelper
      trace: Move the end point of a C state in the power tracer
      perf: Add timechart help text and add timechart to "perf help"
      perf: Use a define for the maximum length of a trace event

 arch/x86/kernel/process.c                   |    3 --
 drivers/cpuidle/cpuidle.c                   |    2 +
 tools/perf/Documentation/perf-timechart.txt |   35 ++++++++++++++++++++
 tools/perf/builtin-timechart.c              |   47 ++++++++++++++++++++++----
 tools/perf/command-list.txt                 |    1 +
 tools/perf/util/header.c                    |    7 ++--
 tools/perf/util/svghelper.c                 |   24 +++++++------
 7 files changed, 94 insertions(+), 25 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-timechart.txt


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
