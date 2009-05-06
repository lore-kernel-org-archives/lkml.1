Return-Path: <linux-kernel-owner+w=401wt.eu-S1761366AbZEFO5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761366AbZEFO5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760780AbZEFOwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:52:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:38422 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760757AbZEFOwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:52:32 -0400
Date: Wed, 6 May 2009 14:51:52 GMT
From: tip-bot for Christoph Hellwig <hch@lst.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, hch@lst.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       hch@lst.de, rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:tracing/core] tracing: small trave_events sample Makefile cleanup
Message-ID: <tip-35cf723e99c0e26ddf51f037dffaa4ff2c2c9106@git.kernel.org>
Git-Commit-ID: 35cf723e99c0e26ddf51f037dffaa4ff2c2c9106
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 06 May 2009 14:51:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  35cf723e99c0e26ddf51f037dffaa4ff2c2c9106
Gitweb:     http://git.kernel.org/tip/35cf723e99c0e26ddf51f037dffaa4ff2c2c9106
Author:     Christoph Hellwig <hch@lst.de>
AuthorDate: Wed, 6 May 2009 12:33:38 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 6 May 2009 16:48:56 +0200

tracing: small trave_events sample Makefile cleanup

Use -I$(src) to add the current directory the include path.

[ Impact: cleanup ]

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 samples/trace_events/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/samples/trace_events/Makefile b/samples/trace_events/Makefile
index 06c6dea..0d428dc 100644
--- a/samples/trace_events/Makefile
+++ b/samples/trace_events/Makefile
@@ -1,8 +1,6 @@
 # builds the trace events example kernel modules;
 # then to use one (as root):  insmod <module_name.ko>
 
-PWD := $(shell pwd)
-
-CFLAGS_trace-events-sample.o := -I$(PWD)/samples/trace_events/
+CFLAGS_trace-events-sample.o := -I$(src)
 
 obj-$(CONFIG_SAMPLE_TRACE_EVENTS) += trace-events-sample.o
