Return-Path: <linux-kernel-owner+w=401wt.eu-S1756000AbZBJRhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000AbZBJRhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 12:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZBJRgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 12:36:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52661 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbZBJRgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 12:36:19 -0500
Message-Id: <20090210173618.650184076@goodmis.org>
References: <20090210173504.973802731@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 10 Feb 2009 12:35:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tobias Klauser <tklauser@distanz.ch>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/7] tracing: storage class should be before const qualifier
Content-Disposition: inline; filename=0004-tracing-storage-class-should-be-before-const-qualif.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace_sysprof.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 84ca9d8..4e2de4d 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -88,7 +88,7 @@ static void backtrace_address(void *data, unsigned long addr, int reliable)
 	}
 }
 
-const static struct stacktrace_ops backtrace_ops = {
+static const struct stacktrace_ops backtrace_ops = {
 	.warning		= backtrace_warning,
 	.warning_symbol		= backtrace_warning_symbol,
 	.stack			= backtrace_stack,
-- 
1.5.6.5

-- 
