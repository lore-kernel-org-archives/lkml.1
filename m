Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbZLNJsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbZLNJsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754791AbZLNJse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:48:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:48309 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755384AbZLNJsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:48:32 -0500
Date: Mon, 14 Dec 2009 09:48:16 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, arjan@linux.intel.com,
       lizf@cn.fujitsu.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, arjan@linux.intel.com,
       rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <4B1DC55F.7060305@cn.fujitsu.com>
References: <4B1DC55F.7060305@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/urgent] tracing/power: Remove two exports
Message-ID: <tip-472bbe02c92a7a8299d7b16946277d98bb8f4bb7@git.kernel.org>
Git-Commit-ID: 472bbe02c92a7a8299d7b16946277d98bb8f4bb7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  472bbe02c92a7a8299d7b16946277d98bb8f4bb7
Gitweb:     http://git.kernel.org/tip/472bbe02c92a7a8299d7b16946277d98bb8f4bb7
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Tue, 8 Dec 2009 11:17:51 +0800
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sun, 13 Dec 2009 18:37:28 +0100

tracing/power: Remove two exports

trace_power_start and trace_power_end are used in
arch/x86/kernel/power.c, and this file can't be compiled
as a module, so these two tracepoints don't need to be
exported.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <4B1DC55F.7060305@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/power-traces.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index e06c6e3..9f4f565 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -14,7 +14,5 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/power.h>
 
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
-EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
 EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
 
