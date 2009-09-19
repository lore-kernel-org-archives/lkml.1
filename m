Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZISJvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZISJvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 05:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbZISJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 05:51:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40097 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZISJvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 05:51:22 -0400
Date: Sat, 19 Sep 2009 11:51:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 8/8] perf: Add the timechart tool
Message-ID: <20090919095115.GA24433@elte.hu>
References: <20090912130306.5d0086ea@infradead.org> <20090912130713.6a77bbc0@infradead.org> <20090919094816.GB2295@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090919094816.GB2295@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0367]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


there's also a few other infrastructure things that should be improved:

 - struct wake_event / trace_entry / wakeup_entry / sched_switch etc. 
   are all present in the existing tracing bits or in builtin-sched. 
   These should be factored out into common facilities and shared 
   between perf timechart and perf sched. We in essence want a good 
   facility to access tracepoint data.

 - the kernel side scheduler tracepoints relied on here should be 
   updated from TRACE_EVENT to TRACE_EVENT_ABI. (TRACE_EVENT_ABI should 
   just be an alias of TRACE_EVENT)

	Ingo
