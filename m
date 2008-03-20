Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYCTWQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYCTWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbYCTWQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:16:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55183 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYCTWQQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:16:16 -0400
Date: Thu, 20 Mar 2008 23:15:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jon Masters <jcm@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320221535.GA320@elte.hu>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca> <20080320191205.GA13309@elte.hu> <1206040705.5225.20.camel@jcmlaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206040705.5225.20.camel@jcmlaptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jon Masters <jcm@redhat.com> wrote:

> > > There seems to be good arguments for markers to support 
> > > proprierary modules. So I am throwing this one-liner in and let's 
> > > see how people react. [...]
> > 
> > ugh, this is unbelievably stupid move technically - so a very strong 
> > NACK. Allowing marker use in unfixable modules (today it's placing 
> > markers into unfixable modules, tomorrow it's marker use by such 
> > modules) has only one clear and predictable effect: it turns marker 
> > calls into essential ABIs because when faced with any breakage in an 
> > unfixable module that makes use of a marker in some kernel subsystem 
> > then all the pressure is on those who _can_ fix their code - meaning 
> > the kernel subsystem maintainers that use markers.
> 
> Mathieu's previous comment was that this was to help improve the 
> quality of such drivers. Out of interest, why do you dislike markers 
> so much?

i'm not particularly interested in improving the quality of such 
drivers. I'm interested in improving the quality of _open_ code. And not 
making too many promises in advance about how our kernel internals will 
look like in the future is a fundamental aspect of that.

So i have no problems with export trivial or cast-into-stone aspects of 
the kernel - doing that simply has no negative effects on open code. But 
the details of markers are far from settled and far from trivial.

	Ingo
