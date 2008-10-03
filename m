Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbYJCAqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbYJCAqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 20:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbYJCAp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 20:45:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbYJCAp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 20:45:58 -0400
Date: Thu, 2 Oct 2008 17:45:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-10-02-16-17 uploaded
Message-Id: <20081002174556.18ccee0d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0810021705460.26309@shark.he.net>
References: <200810022318.m92NI14X031834@imap1.linux-foundation.org>
	<Pine.LNX.4.64.0810021705460.26309@shark.he.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 17:17:16 -0700 (PDT)
"Randy.Dunlap" <rdunlap@xenotime.net> wrote:

> I'll work on some patches for them as time permits...
> or you could drop them, push them back to their submitters...

That tree's such a dog's breakfast that I haven't even tried to compile
it, and I hope not to do so until Stephen returns and puts it all back
together again.

I should have asked Stephen to try to find someone to keep it all
ticking over while he is away.

This one:

build-r9491.out:/home/rdunlap/linsrc/mmotm-2008-1002-1617/include/linux/stacktrace.h:13: warning:
 'struct task_struct' declared inside parameter list

is an honest-to-goodness, should-be-fixed-yesterday upstream bug.


From: Andrew Morton <akpm@linux-foundation.org>

include/linux/stacktrace.h:13: warning:
 'struct task_struct' declared inside parameter list

Reported-by: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stacktrace.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/stacktrace.h~include-linux-stacktraceh-declare-struct-task_struct include/linux/stacktrace.h
--- a/include/linux/stacktrace.h~include-linux-stacktraceh-declare-struct-task_struct
+++ a/include/linux/stacktrace.h
@@ -1,6 +1,8 @@
 #ifndef __LINUX_STACKTRACE_H
 #define __LINUX_STACKTRACE_H
 
+struct task_struct;
+
 #ifdef CONFIG_STACKTRACE
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
_

