Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbZDQMyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbZDQMyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 08:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753958AbZDQMyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 08:54:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46049 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbZDQMyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 08:54:08 -0400
Date: Fri, 17 Apr 2009 14:53:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, mathieu.desnoyers@polymtl.ca,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/4] tracing: pass proto and args to DEFINE_TRACE
Message-ID: <20090417125338.GA24283@elte.hu>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-4-git-send-email-jeremy@goop.org> <20090417064820.GA20685@infradead.org> <49E828B0.90402@goop.org> <20090417070513.GA24860@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417070513.GA24860@infradead.org>
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


* Christoph Hellwig <hch@infradead.org> wrote:

> Then again I'd really wish we could get Steve's recents bits 
> merged for various reasons. [...]

I symphathise with your desire to have the latest and greatest stuff 
upstream right now (i get asked this all the time - _everyone_ wants 
their important stuff upstream, yesterday (and everyone else's 
unstable unnecessary crap should wait)), but there's no way we'll 
rush these new tracing features upstream now. They are not yet 
complete and there's a set of new users whose needs have to be 
observed and designed in.

That is how the upstream development cycle works: stuff added after 
the merge window goes upstream in the next merge window, at the 
earliest. (I.e. in about 2 months from now.)

> [...] The whole DEFINE_TRACE thing only appeared in 2.6.30 and 
> releasing that one kernel with the half-baked inferior version 
> sounds like a really bad idea.

The current upstream code in .30 is fully functional and useful to 
all the subsystems that are making use of it - so your attack on it 
is a bit puzzling to me.

You showed up when, some two weeks ago or so, in the merge window? 
That's generally pretty much the worst time to ask for more 
features. The moral of the story is really: if you feel strongly 
about features in an area, get involved sooner.

Module support (which your complaint really boils down to) was never 
really popular with users of this stuff: the pre-.30 facilities were 
exported to modules all along, but were rarely used from that angle 
(for understandable reasons). Most tracing code contributions and 
enhancements came from the direction of non-modular core kernel 
facilities.

Linus doesnt even _use_ modular kernels - neither do i ;)

Yes, once a facility proves to be successful (this is about the 
fifth version - it all evolved gradually along several kernel 
releases), everyone jumps on it and wants new features, preferably 
yesterday.

Thanks,

	Ingo
