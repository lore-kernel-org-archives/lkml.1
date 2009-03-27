Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZC0NTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZC0NTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 09:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZC0NSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 09:18:55 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56389 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbZC0NSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 09:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ihOd8DrtHS56g5sjGJag/MIEkygA3AmWU9cbZrXuH6fIw2RnaGHqELAyKWeUoE+RLS
         8MwQoQITDxsMzkEmVRYgkv59HB1LKeyD6NUYv5Goa6HM/BNx6x2DVYYhYpXrz+SIkLjo
         8LiRiYwaGuuwtMgH7OG6A99ibcbYZ/2ZMjIQk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] tracing/ftrace: fix missing include string.h
Date: Fri, 27 Mar 2009 14:18:40 +0100
Message-Id: <1238159920-7411-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building a kernel with tracing can raise the following warning on
tip/master:

kernel/trace/trace.c:1249: error: implicit declaration of function 'vbin_printf'

We are missing an include to string.h

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 2a81dec..704cd7f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -30,6 +30,7 @@
 #include <linux/percpu.h>
 #include <linux/splice.h>
 #include <linux/kdebug.h>
+#include <linux/string.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
-- 
1.6.1

