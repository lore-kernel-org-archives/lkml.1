Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZKJV3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZKJV3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 16:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZKJV3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 16:29:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43120 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbZKJV3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 16:29:34 -0500
Date: Tue, 10 Nov 2009 22:29:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Junio C Hamano <gitster@pobox.com>
Cc: Greg KH <gregkh@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
Message-ID: <20091110212903.GD23196@elte.hu>
References: <20091110034831.GB26809@elte.hu>
 <20091110041452.GA25575@suse.de>
 <1257863388.4184.220.camel@mulgrave.site>
 <4AF98C36.9040405@s5r6.in-berlin.de>
 <20091110193919.GC12686@suse.de>
 <20091110204537.GB18509@elte.hu>
 <7vhbt23x1m.fsf@alter.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7vhbt23x1m.fsf@alter.siamese.dyndns.org>
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


* Junio C Hamano <gitster@pobox.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > Yeah. This new tagging scheme doesnt really allow anything 'new' per se 
> > - it just helps the existing practice some more. All these commits were 
> > -stable candidates anyway, in exactly the same order - the only 
> > difference the new tagging scheme adds here is a more organized, 
> > in-upsream-Git way of communicating it to you.
> 
> I am just a bystander, but if it were truly in-upstream-git way, 
> wouldn't you be forking a branch from the tagged target release (the 
> latest of 2.6.32.X), and queuing only the changes meant for -stable to 
> it, and giving the name of the branch to git people and sending out 
> patches from that branch for e-mailed review and application?
> 
> There won't be any special tagging required, only a dedicated branch.
> 
> Or am I missing something?

There's no Git flow towards -stable. It's either forwarded emails, or 
tags in the upstream kernel. Also, _only_ commits that were pulled by 
Linus are eligible for -stable.

So the pull requests all first go to Linus - then can any commit flow to 
-stable.

But even if it was possible to send pull requests to Greg, marking 
commits as -stable candidates is more natural in the commit log itself.

That informs people ('hey, that's a dangerous patch, dont mark it for 
-stable!!' or 'hey, why isnt this commit tagged to stable??'), and it 
also ensures it that only commits from Linus's tree flow towards 
-stable.

	Ingo
