Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZJTXUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZJTXUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 19:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZJTXUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 19:20:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZJTXUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 19:20:30 -0400
Message-Id: <20091020231933.203083200@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 20 Oct 2009 19:19:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] perf tools: trace parse fix and debug compiling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
perf/core


Steven Rostedt (2):
      perf tools: add make DEBUG=1 to remove the -O6 cflag
      perf tools: use strsep over strtok_r for parsing single line

----
 tools/perf/Makefile                 |    9 ++++++++-
 tools/perf/util/trace-event-parse.c |    9 ++++++---
 2 files changed, 14 insertions(+), 4 deletions(-)
