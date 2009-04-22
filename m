Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbZDVKlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbZDVKlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 06:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZDVKlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 06:41:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39455 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZDVKlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 06:41:13 -0400
Date: Wed, 22 Apr 2009 12:41:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2 v3] tracing/events: provide string with undefined
	size support
Message-ID: <20090422104101.GF1115@elte.hu>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <1240117295-6873-2-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0904211749580.10097@gandalf.stny.rr.com> <alpine.DEB.2.00.0904211759540.10097@gandalf.stny.rr.com> <20090421221241.GA6744@nowhere> <alpine.DEB.2.00.0904211820410.9714@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904211820410.9714@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 22 Apr 2009, Frederic Weisbecker wrote:
>
> > Thanks!
> > Then, may be I should wait for Ingo's pull (if he accepts)
> > before sending a delta to add the parenthesis around __get_str().
> 
> It would probably be better to just make the fix now. Just put the 
> fix in a separate branch to avoid race conditions (if Ingo already 
> did a pull ;-)

Yeah - doing a -v2 (-v3, -v4 ;-) COW branch and then removing them 
once they served their purpose does the trick here.

While i generally dont get surprised (negatively ;) by seeing more 
(or less) stuff in a branch than expected from the pull request (i 
review it all anyway), it's good to practice the COW pull workflow 
so that if you send stuff to Linus or others who expect COW there's 
no mistakes.

	Ingo
