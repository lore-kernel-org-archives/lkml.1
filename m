Return-Path: <linux-kernel-owner+w=401wt.eu-S1760014AbZGHQIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbZGHQIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759389AbZGHQGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:06:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:53285 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759375AbZGHQGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:06:18 -0400
Subject: [PATCH 38/44] includecheck fix: include/linux, ftrace.h
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1247063308.4382.12.camel@ht.satnam>
References: <1247063308.4382.12.camel@ht.satnam>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 21:22:01 +0530
Message-Id: <1247068321.4382.102.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix the following 'make includecheck' warning:

  include/linux/ftrace.h: linux/sched.h is included more than once.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/ftrace.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dc3b132..3c0924a 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -446,7 +446,6 @@ static inline void unpause_graph_tracing(void) { }
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
 
 #ifdef CONFIG_TRACING
-#include <linux/sched.h>
 
 /* flags for current->trace */
 enum {
-- 
1.6.0.6



