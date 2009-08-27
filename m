Return-Path: <linux-kernel-owner+w=401wt.eu-S1752130AbZH0DDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbZH0DDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 23:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZH0DDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 23:03:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZH0DDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 23:03:22 -0400
Message-ID: <4A95F71C.1060607@cn.fujitsu.com>
Date: Thu, 27 Aug 2009 11:01:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] tracing: block-able ring_buffer consumer
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The first patch fixes a bug of splice_read for ring_buffer, and makes
rb_get_reader_page() can be easily used by block-able/poll-able codes.

The other patches make consumer block-able and poll-able.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 b/include/linux/ftrace.h      |    6 ++
 b/include/linux/ring_buffer.h |    4 +
 b/kernel/timer.c              |    2
 b/kernel/trace/ring_buffer.c  |   29 +++++++------
 b/kernel/trace/trace.c        |   39 ++++++++++++++++--
 include/linux/ring_buffer.h   |    3 +
 kernel/trace/ring_buffer.c    |   89 ++++++++++++++++++++++++++++++++++++++++++
 kernel/trace/trace.c          |    9 ++++
 8 files changed, 163 insertions(+), 18 deletions(-)




