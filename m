Return-Path: <linux-kernel-owner+w=401wt.eu-S1757416AbZDLNXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbZDLNXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZDLNWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:22:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbZDLNWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:22:49 -0400
Date: Sun, 12 Apr 2009 15:21:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git-pull -tip] x86: declaration patches
Message-ID: <20090412132150.GD20281@elte.hu>
References: <1239381184.23116.5.camel@ht.satnam> <20090410172925.GA24446@uranus.ravnborg.org> <1239388390.3169.43.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239388390.3169.43.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Fri, 2009-04-10 at 19:29 +0200, Sam Ravnborg wrote:
> 
> > The above is a lot ifdefs just to:
> > 1) use asmlinkage only on 64 bit
> > 2) hide the prototype if do not implement the function
> > 
> > Is there any relevant cost associated with asmlinkage or could we just make it
> > always asmlinkage?
> > 
> 
> Ok fixed asmlinkage issue.
> 
> and also fixed thomas's comment issue.
> 
> So here is new pull request:
> The following changes since commit 7fd61bdf06572f1ca681aa35f5c86531a821ea75:
>   Ingo Molnar (1):
>         Merge branch 'x86/urgent'

Looks good - i've applied this as a single patch to tip:x86/cleanups 
because it's now all simple enough, and because i had to fix a few 
details in the individual subject lines. So it was easier to do it 
in one bunch based on the shortlog.

Thanks,

	Ingo
