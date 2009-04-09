Return-Path: <linux-kernel-owner+w=401wt.eu-S1760784AbZDIF3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760784AbZDIF3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbZDIF3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:29:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47220 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbZDIF3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:29:36 -0400
Date: Thu, 9 Apr 2009 07:29:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH][RESEND] tracing: consolidate documents
Message-ID: <20090409052912.GG5352@elte.hu>
References: <49DD6E2B.6090200@cn.fujitsu.com> <49DD70E0.9080302@cn.fujitsu.com> <49DD728D.8030608@cn.fujitsu.com> <20090409041319.GE20692@elte.hu> <84144f020904082216hfb5f5ene87781f9aaf7e76c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020904082216hfb5f5ene87781f9aaf7e76c@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> On Thu, Apr 9, 2009 at 7:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Li Zefan <lizf@cn.fujitsu.com> wrote:
> >
> >> Li Zefan wrote:
> >> > Move tracepoints.txt, ftrace.txt and mmiotrace.txt to the new
> >> > directory trace/
> >> >
> >>
> >> Should we also move kmemtrace.txt to trace/, or leave it in vm/?
> >
> > Eduard, Pekka, any preferences?
> >
> > Are symbolic links in Documentation/ frowned upon? I think it would
> > be best to have the file in both places:
> >
> > We do want to direct people interested in Documentation/vm/ to
> > kmemtrace ... and we do want to let people who are interested in
> > Documentation/trace/ that there's kmemtrace.
> >
> > Tracing and instrumentation is generally a multi-subsystem thing.
> 
> I'm not sure a symbolic link is necessary. Just put it under trace/.

ok - i've amended the commit and have added your Ack - thanks!

	Ingo
