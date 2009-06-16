Return-Path: <linux-kernel-owner+w=401wt.eu-S1752429AbZFPRxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbZFPRxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZFPRxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:53:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64023 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbZFPRxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:53:22 -0400
Message-Id: <20090616175133.317996432@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 16 Jun 2009 13:51:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/5] [GIT PULL] tracing/filters/ringbuffer: updates for 2.6.31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Could you run these through your tests. I ran them through mine and
they passed.

These should really make it into 31 since they all fix some bugs.

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Li Zefan (2):
      tracing/filters: free filter_string in destroy_preds()
      tracing/filters: fix race between filter setting and module unload

Steven Rostedt (3):
      ring-buffer: have benchmark test handle discarded events
      ring-buffer: remove unused variable
      ring-buffer: use commit counters for commit pointer accounting

----
 kernel/trace/ring_buffer.c           |  155 ++++++++++++++++-----------------
 kernel/trace/ring_buffer_benchmark.c |    8 +-
 kernel/trace/trace_events_filter.c   |   28 +++----
 3 files changed, 91 insertions(+), 100 deletions(-)
-- 
