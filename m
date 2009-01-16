Return-Path: <linux-kernel-owner+w=401wt.eu-S935740AbZAPPVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935740AbZAPPVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761120AbZAPPVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:21:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60847 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760809AbZAPPVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:21:24 -0500
Date: Fri, 16 Jan 2009 16:21:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116152103.GA28643@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > maybe we could drive this via the filter API? Something like:
> > 
> >    echo "*btrfs*:stacktrace" >> set_filter_functions
> > 
> > Would automatically mean that those functions will all generate 
> > stacktraces too. Note how safe this API is by default: the filter is used 
> > for a narrow scope of functions anwyay. To get it for all kernel functions 
> > one would have to do:
> > 
> >    echo "*:stacktrace" >> set_filter_functions
> > 
> > Which one cannot do accidentally.
> > 
> > What do you think?
> 
> Now that I see only a 1/2 sec lag, do you still think this is necessary?
> 
> Maybe I should go back and see why it was so bad before?
> 
> But I do notice that not all functions produce a valid stack trace. 
> Maybe it would be better to add that api :-?

yes - i think that API would be more intuitive, and that way people could 
mix more interesting functions (with stack traces) with less important 
functions (no stack traces).

	Ingo
