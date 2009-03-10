Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbZCJNwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbZCJNwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753699AbZCJNv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:51:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60592 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206AbZCJNv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:51:58 -0400
Date: Tue, 10 Mar 2009 14:51:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: prasad@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090310135117.GC3850@elte.hu>
References: <20090305043726.GA17747@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305043726.GA17747@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_00,URIBL_BLACK autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	2.0 URIBL_BLACK            Contains an URL listed in the URIBL blacklist
	[URIs: info.name]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's also a few checkpatch warnings that need to be 
addressed:

ERROR: do not use assignment in if condition
#1084: FILE: arch/x86/kernel/ptrace.c:581:
+	else if ((thbi = alloc_thread_hw_breakpoint(tsk)) == 
NULL)

WARNING: suspect code indent for conditional statements (16, 16)
#2836: FILE: kernel/trace/trace_ksym.c:324:
+		if (strncmp(entry->ksym_hbkpt->info.name, 
KSYM_SELFTEST_ENTRY,
[...]
+		kfree(entry->ksym_hbkpt->info.name);

	Ingo
