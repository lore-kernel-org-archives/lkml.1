Return-Path: <linux-kernel-owner+w=401wt.eu-S1753657AbZJKI7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbZJKI7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 04:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZJKI7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 04:59:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33585 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbZJKI7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 04:59:35 -0400
Date: Sun, 11 Oct 2009 10:58:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, lizf@cn.fujitsu.com
Subject: Re: [RFC][PATCH 5/9] perf trace: Add Perl scripting support
Message-ID: <20091011085846.GF14995@elte.hu>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com> <1254809398-8078-6-git-send-email-tzanussi@gmail.com> <20091006130059.GD15320@elte.hu> <1254888565.28917.135.camel@tropicana> <20091007141332.GA21320@infradead.org> <1254974493.6841.17.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254974493.6841.17.camel@tropicana>
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


* Tom Zanussi <tzanussi@gmail.com> wrote:

> On Wed, 2009-10-07 at 10:13 -0400, Christoph Hellwig wrote:
> > On Tue, Oct 06, 2009 at 11:09:25PM -0500, Tom Zanussi wrote:
> > > > I think we also want to have a 'perf -s *' kind of thing to get a list 
> > > > of all available language modules.
> > > > 
> > > 
> > > I knew somebody would point that out (and suggest a better way ;-)  That
> > > all makes sense - I'll make these changes in the next version.
> > 
> > I'm a bit worried about linking two million scripting language into the
> > main perf binary.  Can't we just have seaprate perlperf / pythonperf,
> > rubyperf, awkperf binaries that only contain the scripting support?
> 
> Yeah, that's a good point. [...]

No, we want to keep a single core binary, it has many advantages. Git 
has gone through a very painful conversion from many spread out git-* 
commands back into a central binary. So we avoided that mistake in perf 
from the get go. We are not going to add separate perf-* commands.

ad-hoc extensions using separate perf-* scripts are fine of course and i 
use that myself. But once a facility is part of core perf it wants to 
move into the binary. Especially something as central as scripting 
support.

Thanks,

	Ingo
