Return-Path: <linux-kernel-owner+w=401wt.eu-S1753814AbZKTJFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbZKTJFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:05:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZKTJFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:05:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38252 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZKTJF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:05:29 -0500
Date: Fri, 20 Nov 2009 10:03:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 1/2] perf: Add 'perf kmem' tool
Message-ID: <20091120090353.GE19778@elte.hu>
References: <4B064AF5.9060208@cn.fujitsu.com>
 <20091120081440.GA19778@elte.hu>
 <84144f020911200019p4978c8e8tc593334d974ee5ff@mail.gmail.com>
 <20091120083053.GB19778@elte.hu>
 <4B0657A4.2040606@cs.helsinki.fi>
 <4B06590C.7010109@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B06590C.7010109@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> > (2) doing "perf kmem record" on machine A (think embedded here) and 
> > then "perf kmem report" on machine B. I haven't tried kmemtrace-user 
> > for a while but it did support both of them quite nicely at some 
> > point.
> 
> Everything needed and machine-specific will be recorded in perf.data, 
> so this should already been supported. I'll try it.

Right now the DSOs are not recorded in the perf.data - but it would be 
useful to add it and to turn perf.data into a self-sufficient capture of 
all relevant data, which can be analyzed on any box.

	Ingo
