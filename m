Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZEDPUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZEDPUd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 11:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZEDPUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 11:20:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36062 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbZEDPUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 11:20:19 -0400
Message-Id: <20090504151933.728781787@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 04 May 2009 11:19:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/6] [GIT PULL v2] ring-buffer: speed ups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (6):
      ring-buffer: add counters for commit overrun and nmi dropped entries
      tracing: export stats of ring buffers to userspace
      ring-buffer: convert cpu buffer entries to local_t
      ring-buffer: record page entries in buffer page descriptor
      ring-buffer: have read page swap increment counter with page entries
      ring-buffer: disable writers when resetting buffers

----
 include/linux/ring_buffer.h |    2 +
 kernel/trace/ring_buffer.c  |  141 ++++++++++++++++++++++++-------------------
 kernel/trace/trace.c        |   42 +++++++++++++
 3 files changed, 123 insertions(+), 62 deletions(-)
-- 
