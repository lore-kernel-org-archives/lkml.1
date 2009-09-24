Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbZIXTtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbZIXTtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbZIXTto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:49:44 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54837 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZIXTtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JpVtphp0FkRTfQfsQE4IOElEn6TVGiMsbwLhddY5kJWHeOPb5QbH2Kh9mz7YLzfIq8
         T0v13HlJKe9VFPkmkpV91xMlCfXEBM5xI15AG3PHiuaPYXG84tHpHCeEYmi4SGo7pyW7
         z0rXatK7tA/QdfDtmWF404aZyjDJkeflkxepY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/5 v2] tracing/filters: Cleanup useless headers
Date: Thu, 24 Sep 2009 21:49:32 +0200
Message-Id: <1253821775-8618-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup remaining headers inclusion that were only useful when
the filter framework and its tracing related filesystem user interface
weren't yet separated.

v2: Keep module.h, needed for EXPORT_SYMBOL_GPL

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events_filter.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2324578..189663d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -18,8 +18,6 @@
  * Copyright (C) 2009 Tom Zanussi <tzanussi@gmail.com>
  */
 
-#include <linux/debugfs.h>
-#include <linux/uaccess.h>
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/mutex.h>
-- 
1.6.2.3

