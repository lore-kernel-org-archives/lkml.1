Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZIVKIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZIVKIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 06:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZIVKI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 06:08:27 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:10645 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbZIVKI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 06:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JCAI3kmqTYtN5s0t5/yvakqjMaecF4aTdlYfBziDzt328Sl50jAyht6Vrye5oc5OJX
         8UI37LhCbTSIVy3+k8H/E5zW3Xs01OuC/ACwy1UsWatG3SLnkP28Ef4Rg0d0YZBIiA+k
         v1nZFYc7QToERpYKPANUfSpbniwoD6ncRhZWI=
MIME-Version: 1.0
Date: Tue, 22 Sep 2009 18:00:44 +0800
Message-ID: <3a3680030909220300h7cf18849q4d4702b9d4feaa67@mail.gmail.com>
Subject: [PATCH] tracing: Fix a comment and a trivial format issue in 
	tracepoint.h
From: Li Hong <lihong.hi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Li Hong <lihong.hi@gmail.com>

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 63a3f7a..2aac8a8 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -4,7 +4,7 @@
 /*
  * Kernel Tracepoint API.
  *
- * See Documentation/tracepoint.txt.
+ * See Documentation/trace/tracepoints.txt.
  *
  * (C) Copyright 2008 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
  *
@@ -36,7 +36,7 @@ struct tracepoint {
 #ifndef DECLARE_TRACE

 #define TP_PROTO(args...)	args
-#define TP_ARGS(args...)		args
+#define TP_ARGS(args...)	args

 #ifdef CONFIG_TRACEPOINTS

-- 
1.6.0.4
