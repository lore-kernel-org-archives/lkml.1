Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab0BPQmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 11:42:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:63719 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0BPQmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 11:42:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=C5bt2Gst4wMA:10 a=VwQbUJbxAAAA:8 a=DvTXKYSeVZZISn_AhEoA:9 a=cFJ6jE9udrUeANXhosRTg3L7_J0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100216164122.891864374@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 16 Feb 2010 11:41:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3][GIT PULL][v2.6.34] tracing: updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Li Zefan (1):
      ftrace: Allow to remove a single function from function graph filter

Steven Rostedt (2):
      tracing: Add correct/incorrect to sort keys for branch annotation output
      tracing: Add notrace to TRACE_EVENT implementation functions

----
 include/trace/ftrace.h      |   31 +++++++++++++++-----------
 kernel/trace/ftrace.c       |   51 ++++++++++++++++++++++++++----------------
 kernel/trace/trace.h        |    3 +-
 kernel/trace/trace_branch.c |   19 ++++++++++++++-
 4 files changed, 68 insertions(+), 36 deletions(-)
