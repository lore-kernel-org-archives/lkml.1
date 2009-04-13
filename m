Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZDMXkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZDMXkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbZDMXkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:40:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56816 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753869AbZDMXkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:40:41 -0400
Date: Tue, 14 Apr 2009 01:40:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing, boottrace: Move include/trace/boot.h to
	include/linux/boottrace.h
Message-ID: <20090413234027.GH817@elte.hu>
References: <49E2B763.8060706@cn.fujitsu.com> <20090413142531.GC5977@nowhere> <20090413222436.GF8514@elte.hu> <alpine.DEB.2.00.0904131907020.3041@gandalf.stny.rr.com> <20090413232807.GE817@elte.hu> <alpine.DEB.2.00.0904131933110.3041@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904131933110.3041@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Tue, 14 Apr 2009, Ingo Molnar wrote:
> > 
> > The sane thing would be to put event headers into 
> > include/trace/events/ and put more generic/utility headers into 
> > include/trace/.
> > 
> > Reserving a full subdirectory for one singular purpose is a needless 
> > waste of a nice (and unique) name-space resource.
> 
> That's fine with me too. I just want the trace points to be easily 
> seen. But by making a sub directory, wont we need to have all 
> users of tracepoints do something like:
> 
> #include <trace/events/sched.h>
> 
> That might be fine too.

Yes - it would allow the dropping of the annoyingly repetitive 
_event string from those definition files as well?

	Ingo
