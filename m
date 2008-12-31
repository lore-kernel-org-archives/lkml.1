Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbYLaIPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbYLaIPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYLaIPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:15:30 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbYLaIP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:15:28 -0500
Date: Wed, 31 Dec 2008 09:14:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>,
       Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -tip] fix compilation error
Message-ID: <20081231081458.GB12942@elte.hu>
References: <1230648007.10677.1.camel@jaswinder.satnam> <20081230205230.GA6151@nowhere> <495AA87D.9060704@kernel.org> <495ABDF8.2070703@kernel.org> <20081231004722.GA28472@nowhere> <495AC45D.8010102@kernel.org> <20081231014747.GB28472@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081231014747.GB28472@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Dec 30, 2008 at 05:01:17PM -0800, H. Peter Anvin wrote:
> > Frederic Weisbecker wrote:
> > > On Tue, Dec 30, 2008 at 04:34:00PM -0800, H. Peter Anvin wrote:
> > >> H. Peter Anvin wrote:
> > >>> Applied to tip:tracing/kmemtrace2.
> > >>>
> > >> Hm, there still seems to be a build failure, in particular
> > >> trace_output.h is missing.  It looks to me at the moment as if just
> > >> removing the #include works; assuming that compiles I will check that in
> > >> to tip:tracing/kmemtrace2 as well.
> > >>
> > >> 	-hpa
> > > 
> > > While I worked on this tracer, I had to base the thing against tracing/kmemtrace
> > > because I needed the kmemtrace bits.
> > > But I saw that this topic was a bit out of sync against tip/master, some updates from
> > > Steven were not merged. But I didn't wonder, thinking that Ingo would resolve the
> > > conflicts. But it seems there were some lost stuffs :-)
> > > 
> > > I'm checking it and will send a patch to solve the rest...
> > > 
> > 
> > If it's only the trace_output.h #include removal, don't worry about it;
> > I'm about to commit that patch, but it would be good if you could check
> > out the tracing/kmemtrace2 branch afterwards.
> 
> 
> Yes this topic builds well after your patch. So it was just this header.

Could you check whether latest tip/master is still OK? I had these 
problems resolved locally (but forgot to push them out), and now i also 
had to do a few conflict resolutions with latest -git, hopefully i have 
not lost hpa's fixes ...

	Ingo
