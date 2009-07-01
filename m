Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZGAInW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZGAInW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbZGAInP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:43:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844AbZGAInO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:43:14 -0400
Date: Wed, 1 Jul 2009 10:43:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration
	dependency
Message-ID: <20090701084304.GC8171@elte.hu>
References: <20090622210302.4984.82798.stgit@localhost.localdomain> <20090630143806.9ab4519d.akpm@linux-foundation.org> <alpine.LFD.2.01.0906301440280.3605@localhost.localdomain> <4A4A8D91.8040009@redhat.com> <4A4A9D89.3090600@redhat.com> <20090630232359.GH17968@elte.hu> <4A4AA467.1010308@redhat.com> <4A4AA930.1060603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4AA930.1060603@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> Masami Hiramatsu wrote:
> > Ingo Molnar wrote:
> >> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> >>
> >>> Oops, I couldn't reproduce this bug on the latest -tip tree.
> >> maybe because i applied your fix already? ;-)
> > 
> > If so, I'll be happy. But I reverted that change and checked :-(
> > Maybe, that came from a combination of configs (but I've lost it...)
> 
> Ok, I found.
> Sorry, the problem has been fixed with below commit...
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=ac6ca5c86c63dd95acc6a34dff8d33c23b703a37

thx - i thus dropped this:

  130c5b2 kprobes: Fix kprobe selftest configuration dependency

Kept the other two patches - one for tracing/urgent (for .31), the 
other for tracing/core (.32). Agreed?

	Ingo
