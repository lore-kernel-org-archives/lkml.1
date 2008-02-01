Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbYBAJu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbYBAJu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbYBAJuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:50:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52064 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbYBAJuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:50:50 -0500
Date: Fri, 1 Feb 2008 10:50:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: x86: Why have __copy_from_user_ll_nocache* been exported?
Message-ID: <20080201095034.GA29960@elte.hu>
References: <20080131201430.GA9375@cs181133002.pp.htv.fi> <20080131203122.GA6457@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131203122.GA6457@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > And that from a person who on the other hand wants to introduce (and 
> > tries to force on other people) deprecation periods for unused 
> > EXPORT_SYMBOL's.
> 
> why does this bother you? The API makes total sense. This is a 
> completely sensible API (with a full implementation) to use 
> non-temporal copies. I mean, if this was some legacy API that nobody 
> uses anymore i'd agree, but this is about the ability to access 
> user-space memory via SSE2+ non-temporal stores.

Adrian, you have still not answered the (obvious) question: why do such 
currently-unused exports bother you?

	Ingo
