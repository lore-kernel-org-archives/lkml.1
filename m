Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbZHAHXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbZHAHXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 03:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZHAHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 03:23:36 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:41469 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZHAHXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 03:23:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=reSIzY+wbpk/FK+EVpZkztITTv+2Bk/JMyXIBf04WSmsDEIcWeX5EAilhcRjHrA1+Y
         9PiMb6+b+9WOEsxEpMqg26j5cFWl/XK4ZTQJGxxrWOpFVi1zhuIK8ZwOYfJq/vZUh3dE
         +y/ozbHv9/Az8ONjsvE9pnEoZO9Nq0SKAtoVA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 3/5] tracing/filters: Cleanup useless headers
Date: Sat,  1 Aug 2009 09:23:26 +0200
Message-Id: <1249111408-8657-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup remaining headers inclusion that were only useful when
the filter framework and its tracing related filesystem user interface
weren't yet separated.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index b9aae72..a2f8bef 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -18,9 +18,6 @@
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  */
 
-#include <linux/debugfs.h>
-#include <linux/uaccess.h>
-#include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/mutex.h>
 
-- 
1.6.2.3

