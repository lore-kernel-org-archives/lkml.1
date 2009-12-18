Return-Path: <linux-kernel-owner+w=401wt.eu-S933122AbZLRWEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122AbZLRWEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:04:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZLRWEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:04:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56747 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbZLRWEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:04:13 -0500
Date: Fri, 18 Dec 2009 23:03:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf record: We should fork only if a program was
 specified to run
Message-ID: <20091218220350.GA21131@elte.hu>
References: <1261168944-6615-1-git-send-email-acme@infradead.org>
 <1261169561.20899.630.camel@laptop>
 <20091218205853.GD19708@ghostprotocols.net>
 <1261170818.20899.657.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261170818.20899.657.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > Because we want this to work:
> > 
> > [root@doppio linux-2.6-tip]# perf record -a -f sleep 2
> > [ perf record: Woken up 1 times to write data ]
> > [ perf record: Captured and wrote 0.243 MB perf.data (~10599 samples) ]
> > [root@doppio linux-2.6-tip]#
> > 
> > See, no hands mother! I.e. it is system wide, but just for 2 seconds,
> > its clever, but I like it, and it always worked :-)
> 
> Ah, right.. yes, totally forgot about that.

I use the 'perf record -a -f sleep 1' trick all the time to capture a 
system-wide snippet of a particular workload.

	Ingo
