Return-Path: <linux-kernel-owner+w=401wt.eu-S933939AbZLFRLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933939AbZLFRLN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 12:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933910AbZLFRLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 12:11:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42084 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933894AbZLFRLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 12:11:12 -0500
Date: Sun, 6 Dec 2009 18:11:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] tracing: Fix event format export
Message-ID: <20091206171107.GA22298@elte.hu>
References: <20091113224009.GB23942@elte.hu>
 <tip-811cb50baf63461ce0bdb234927046131fc7fa8b@git.kernel.org>
 <1259851297.12870.134.camel@gandalf.stny.rr.com>
 <20091203145504.GA959@elte.hu>
 <1260116381.3461.16.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260116381.3461.16.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Thu, 2009-12-03 at 15:55 +0100, Ingo Molnar wrote:
> 
> > > Any reason that this did not make it into Mainline? 2.6.32 is out, and 
> > > Johannes Berg was depending on this for his users.
> > 
> > Yeah, it narrowly missed the last -rc (-rc8), and we only push 
> > post-final-rc fixes for serious show-stopper regressions.
> 
> You have an interesting definition of "narrowly missed":
> 
> $ git show v2.6.32-rc8
> ...
> Date:   Thu Nov 19 14:32:50 2009 -0800
> ...
> $ git show --pretty=fuller 811cb50baf63461ce0bdb234927046131fc7fa8b
> ...
> CommitDate: Fri Nov 13 22:20:34 2009 -0500

Yes, it came in late, after -rc7 and just two weeks before the final 
2.6.32 kernel was released. Please test linux-next or -tip more 
frequently if you want fixes to go upstream sooner.

> And Steven's pull request for this very simple fix was from the 14th. 
> That's 5 days until -rc8.

We are extra careful in late -rc's - and per Linus's request we are only 
pushing fixes for serious regressions, and even those we only push after 
careful testing. That's a few days commit life-time at minimum in the 
usual case.

> So maybe I have a personality problem, but suck it up -- you're wrong 
> this time.

No need to complain - the fix is upstream now and will be in 2.6.32.1 - 
within 1-2 weeks. If that's not fast enough for you then you can 
cherry-pick upstream commit 811cb50baf63461ce0bdb234927046131fc7fa8b 
into your tree right now.

Thanks,

	Ingo
