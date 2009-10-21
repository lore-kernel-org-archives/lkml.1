Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbZJUOh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbZJUOh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 10:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbZJUOhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 10:37:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbZJUOhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 10:37:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/4] tracing: couple of minor fixies
Date: Wed, 21 Oct 2009 16:36:37 +0200
Message-Id: <1256135801-1849-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

sending few minor fixes.

1/4 - tracing: updating *ppos instead of filp->f_pos
2/4 - tracing: fix trace_seq_printf return value
3/4 - tracing: comment typo and documentation example fix
4/4 - tracing: removing cpu arg from rb_time_stamp function

wbr,
jirka

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 Documentation/trace/ftrace.txt |    2 ++
 include/linux/trace_seq.h      |    2 +-
 kernel/trace/ftrace.c          |    2 +-
 kernel/trace/ring_buffer.c     |   12 ++++++------
 kernel/trace/trace.c           |    8 ++++----
 kernel/trace/trace_output.c    |    2 +-
 6 files changed, 15 insertions(+), 13 deletions(-)
