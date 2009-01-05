Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbZAENuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbZAENuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZAENuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:50:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59323 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856AbZAENuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:50:23 -0500
Date: Mon, 5 Jan 2009 14:50:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
Message-ID: <20090105135011.GA4190@elte.hu>
References: <1231066898.27852.29.camel@jaswinder.satnam> <20090104172114.GA32425@elte.hu> <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com> <20090104203433.GC1132@elte.hu> <1231131855.16019.2.camel@jaswinder.satnam> <20090105131521.GC6014@elte.hu> <3f9a31f40901050522h4389894w69e41fa9645ce8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901050522h4389894w69e41fa9645ce8c@mail.gmail.com>
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


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Mon, Jan 5, 2009 at 6:45 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Jaswinder Singh Rajput <jaswinder@infradead.org> wrote:
> >
> >> On Sun, 2009-01-04 at 21:34 +0100, Ingo Molnar wrote:
> >> > yeah - i mentioned it to you before that there are such cases.
> >> >
> >>
> >> OK, so here is new patch excluding smp.h:
> >
> > Could you please instead fix the smp.h assumption so that we dont hit this
> > in the future? Then we can apply your original patch.
> 
> Sure, I will do it.
> 
> > [ Do you need the
> > specific .config that hits this? Can dig it out if necessary. ]
> 
> If you provide me that .config file then it will be very helpful for
> cross-checking.

hm, cannot find it - there's been too many other bugs in that timeframe so 
i'd have to try a dozen configs to find out which one it was.

It's not a big problem i think: i'd suggest you fix the problem pinpointed 
by the build error i sent to you - and if anything else happens with newer 
patches i'll send you a full config for those problems. This area is thick 
include file spaghetti that will need a few iterations to sort out.

	Ingo
