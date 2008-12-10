Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYLJGxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYLJGxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 01:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYLJGx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 01:53:28 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:42292 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbYLJGx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 01:53:27 -0500
Subject: Re: [PATCH][RT] Compile-time fix.
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Clark Williams <clark.williams@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Gregory Haskins <ghaskins@novell.com>, Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <1228890920.9542.2.camel@dd>
References: <alpine.DEB.1.10.0812090946210.16798@gandalf.stny.rr.com>
	 <1228890920.9542.2.camel@dd>
Content-Type: text/plain
Organization: The Big Corporation
Date: Tue, 09 Dec 2008 22:53:22 -0800
Message-Id: <1228892002.9542.4.camel@dd>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Compile-time fix.

Signed-off-by: Sven-Thorsten Dietrich <sdietrich@suse.de>

diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index 585feed..b74fdc2 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -14,7 +14,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/linkage.h>
 #include <linux/lockdep.h>
-
+#include <linux/spinlock.h>
 #include <asm/atomic.h>
 
 /*


