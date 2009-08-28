Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbZH1Ui3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbZH1Ui3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZH1UiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:38:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48684 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZH1UiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:38:14 -0400
Message-Id: <20090828203736.440768383@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 28 Aug 2009 16:37:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: minor updates for 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (2):
      tracing: remove legacy select of MARKERS by context switch tracing
      tracing: only show tracing_max_latency when latency tracer configured

----
 kernel/trace/Kconfig |    1 -
 kernel/trace/trace.c |   92 +++++++++++++++++++++++++++-----------------------
 kernel/trace/trace.h |    2 +
 3 files changed, 52 insertions(+), 43 deletions(-)
-- 
