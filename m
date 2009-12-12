Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbZLMBUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbZLMBUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 20:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932136AbZLMBUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 20:20:31 -0500
Received: from mail.perches.com ([173.55.12.10]:1142 "HELO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933062AbZLMBUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 20:20:30 -0500
Subject: [PATCH] ftrace.h: Use common pr_info fmt string
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 13:06:13 -0800
Message-ID: <1260651974.2637.4.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduces fmt string space a bit

Signed-off-by: Joe Perches <joe@perches.com>
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index d1b3de9..c4eca38 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -733,7 +733,7 @@ static int ftrace_raw_reg_event_##call(struct ftrace_event_call *unused)\
 	ret = register_trace_##call(ftrace_raw_event_##call);		\
 	if (ret)							\
 		pr_info("event trace: Could not activate trace point "	\
-			"probe to " #call "\n");			\
+			"probe to %s\n", #call);			\
 	return ret;							\
 }									\
 									\


