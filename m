Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZEACYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZEACYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 22:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbZEACYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 22:24:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65360 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZEACYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 22:24:03 -0400
Message-Id: <20090501022210.851418183@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Apr 2009 22:22:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/3] [GIT PULL] tracing/ringbuffer: updates for tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Here's some udpates to the ring buffer. Mainly, exporting the
counters (and adding new ones) to userspace. We keep track of entries
and overruns but currently they only get displayed with the latency
format.

This adds them per cpu in the directory:

  /debugfs/tracing/per_cpu/cpuX/stats


Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (3):
      ring-buffer: add counters for commit overrun and nmi dropped entries
      tracing: export stats of ring buffers to userspace
      ring-buffer: make cpu buffer entries counter atomic

----
 include/linux/ring_buffer.h |    2 +
 kernel/trace/ring_buffer.c  |   70 +++++++++++++++++++++++++++++++++++-------
 kernel/trace/trace.c        |   42 +++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 12 deletions(-)
-- 
