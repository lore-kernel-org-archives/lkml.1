Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbZLJSRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbZLJSRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 13:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760874AbZLJSRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 13:17:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50686 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZLJSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 13:17:49 -0500
Date: Thu, 10 Dec 2009 19:16:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel <utrace-devel@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091210181638.GA17986@elte.hu>
References: <20091130151650.GA24316@elte.hu>
 <20091130152910.GB10331@redhat.com>
 <20091201161132.GA24897@elte.hu>
 <20091201170002.GD10331@redhat.com>
 <20091201170954.GA4699@elte.hu>
 <20091201174534.GE10331@redhat.com>
 <20091201211518.GA32376@elte.hu>
 <20091208215829.GA19793@redhat.com>
 <20091210074158.GI16874@elte.hu>
 <y0mhbryamt2.fsf@fche.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mhbryamt2.fsf@fche.csb>
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


* Frank Ch. Eigler <fche@redhat.com> wrote:

> 
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > [...]  Since the speed of development in this area is truly glacial
> > at the moment and the practical advantages that i can experience
> > personally (directly as a Linux user and indirectly as a maintainer)
> > are miniscule so far, caution is warranted IMO. [...]
> 
> If the "caution" you suggest is operationally equivalent to 
> discouraging even miniscule improvements, is it any wonder that 
> progress is glacial?

I think you might be mixing up cause and causation ;-)

> The gdbstub prototype was constructed for two reasons: to demonstrate 
> utrace usage now, and in the future to be incrementally useful (over 
> ptrace, by moving into fast kernel-space operations like 
> multithreading control, gdb-tracepoint support, other stuff).  #1 is 
> about done.  With respect to #2, we can certainly commit to ongoing 
> work on improvements, provided the community shows interest and 
> goodwill.

What i'd like to see is measurable benefits to users, developers and 
maintainers. I'd like to see the same for SystemTap too btw.

	Ingo
