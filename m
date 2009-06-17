Return-Path: <linux-kernel-owner+w=401wt.eu-S1763879AbZFQX12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763879AbZFQX12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760587AbZFQX0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:26:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61400 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbZFQX02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:26:28 -0400
Message-Id: <20090617232555.164629684@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 19:25:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/7] [GIT PULL][for 2.6.31] ring-buffer: various clean ups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Steven Rostedt (7):
      ring-buffer: use BUF_PAGE_HDR_SIZE in calculating index
      ring-buffer: remove useless warn on check
      ring-buffer: remove useless compile check for buffer_page size
      ring-buffer: check for less than two in size allocation
      ring-buffer: add locks around rb_per_cpu_empty
      ring-buffer: do not grab locks in nmi
      ring-buffer: have benchmark test print to trace buffer

----
 kernel/trace/ring_buffer.c           |   82 ++++++++++++++++++++++++---------
 kernel/trace/ring_buffer_benchmark.c |   37 ++++++++-------
 2 files changed, 78 insertions(+), 41 deletions(-)
-- 
