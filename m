Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZCMDUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZCMDUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbZCMDUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:20:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZCMDUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:20:34 -0400
Date: Fri, 13 Mar 2009 04:20:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Mike Travis <travis@sgi.com>
Subject: Re: [PULL] x86 cpumask work
Message-ID: <20090313032015.GD18760@elte.hu>
References: <200903121453.45163.rusty@rustcorp.com.au> <200903130924.48885.rusty@rustcorp.com.au> <20090313005743.GE19544@elte.hu> <200903131316.26455.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903131316.26455.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 13 March 2009 11:27:43 Ingo Molnar wrote:
> > 
> > * Rusty Russell <rusty@rustcorp.com.au> wrote: 
> > > Missing a core patch (it even got a compile warning with that 
> > > config).
> > So it's manual work and sometimes i notice them amongst a 
> > boatload of other warnings, sometimes i dont.
> 
> Me too :( I thought you were starting a de-warning tree?  I'd 
> be happy to send you patches (particularly, exporting 
> deprecated symbols should not give a warning!).

Yeah - i have a de-warning tree, but it's not yet fully up and 
running for -tip qa automation.

> > > But there's something else wrong.  Firing up my 64-bit 
> > > test box now.
> > 
> > Great - so you can reproduce. Thanks,
> 
> Yep, and I'm running some stress tests as well now.
> 
> Perhaps throw away that tree, and I'll feed you a new one (the 
> core patch needs to go at the front), but I can work either 
> way.

Ok, i dropped it back to d95c357.

Suggestion for future workflow: we wouldnt have these somewhat 
stressful (and stressful to you mostly!), large hickups and 
history-less trees if you sent stuff more gradually and not so 
close to the merge window. You exposed some of your changes to 
linux-next but that's not nearly enough testing in practice for 
x86-affecting patches.

	Ingo
