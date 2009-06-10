Return-Path: <linux-kernel-owner+w=401wt.eu-S1761636AbZFJT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761636AbZFJT4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbZFJTzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:55:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761265AbZFJTzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:55:24 -0400
Message-Id: <20090610195311.767699959@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 10 Jun 2009 15:53:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 0/3] [GIT PULL][for 2.6.32] lockless ring buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here it is, the long awaited lockless ring buffer algorithm.

Please pull the latest tip/tracing/ring-buffer tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ring-buffer


Steven Rostedt (3):
      ring-buffer: make the buffer a true circular link list
      ring-buffer: make lockless
      ring-buffer: add design document

----
 Documentation/trace/ring-buffer-design.txt |  949 +++++++++++++++++++++++++++
 include/linux/ring_buffer.h                |    1 -
 kernel/trace/ring_buffer.c                 |  951 +++++++++++++++++++++++-----
 kernel/trace/trace.c                       |    3 -
 4 files changed, 1735 insertions(+), 169 deletions(-)
-- 
