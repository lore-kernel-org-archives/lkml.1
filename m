Return-Path: <linux-kernel-owner+w=401wt.eu-S1758713AbZAVWRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713AbZAVWRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZAVWRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:17:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52305 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918AbZAVWRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:17:42 -0500
Date: Thu, 22 Jan 2009 23:16:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       David Brown <lkml@davidb.org>, Phil Oester <kernel@linuxace.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>,
       Christoph Hellwig <hch@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Message-ID: <20090122221641.GA31487@elte.hu>
References: <20090109193738.GA9827@linode.davidb.org> <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu> <20090110165033.GA23943@logfs.org> <20090110101235.7ca24c44.akpm@linux-foundation.org> <20090110221528.GA31774@elte.hu> <Pine.LNX.4.64.0901111022590.30201@anakin> <20090111153920.GC7401@elte.hu> <20090111163018.GA9300@suse.de> <20090122215041.GA29369@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090122215041.GA29369@redhat.com>
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


* Dave Jones <davej@redhat.com> wrote:

> We've already demonstrated "look how much stuff we can merge" time and 
> time again, but no-one ever seems to have a proposal for how we increase 
> the amount of review code gets before it's merged.

I think i agree with you in some ways (more review is always good), but 
there's a very important aspect where i think you are quite wrong:

The first step towards increasing review activity is to increase the 
readability of the code - so that is _can_ be reviewed quickly and 
efficiently.

But talking down such efforts with:

>   (and I mean real review here, not checkpatch & codingstyle crap)

is a shoot-own-foot excercise.

You are attacking the very foundation of proper high-level review. Yes, 
there can be bad types of syntactic cleanups but most of the efforts add 
real value to the code and should not be dismissed just because they stay 
on the local level.

"real review" only becomes easy if the code _is reviewable to begin with_: 
if it is written in standard coding patterns where we almost 
sub-consciously recognize bad constructs and bad practices.

I've seen it time and again that if the code is cleaned up visually, real 
review and real improvements follow eventually. It's a gradual process and 
you just cannot do "real review" efficiently without what you call the 
"checkpatch crap".

In fact, i claim that doing "real review" on butt-ugly code is a waste of 
time and resources, and that it is also _harmful_. By doing real review on 
something that is not even right stylistically, you insert value into it. 
That way you _encourage_ that author of that ugly piece of code to 
contribute more code in the same fashion. You indirectly harm Linux that 
way because you encourage bad taste.

I strongly support the notion that high-level review is only warranted on 
code that is reviewable and looks tasteful, and that code which doesnt 
meet basic style should not be merged at all.

Code that 'looks good' can of course still be utter crap - but that crap 
is usually easily noticed, and often the crap portion does not permeate 
the whole code base. But if we have code that _does not even look good_ 
then crap can hide for a long time. (obscured by filth, so to speak.)

I know plenty of in-tree examples of 5-10 years old code that has remained 
butt-ugly and unhackable for 5-10 years and which has an above-average 
proportion of bugs and regressions.

	Ingo
