Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbZGCSlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbZGCSlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZGCSlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:41:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36870 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842AbZGCSlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:41:36 -0400
Date: Fri, 3 Jul 2009 20:41:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703184124.GA4085@elte.hu>
References: <20090703102234.GA32128@elte.hu> <20090703114431.37abd528@lxorguk.ukuu.org.uk> <20090703131727.GA3207@elte.hu> <20090703143746.0379b2ee@lxorguk.ukuu.org.uk> <20090703144754.GA13246@elte.hu> <20090703160230.093e422c@lxorguk.ukuu.org.uk> <20090703154845.GB13580@elte.hu> <20090703171117.574677de@lxorguk.ukuu.org.uk> <20090703162443.GB21399@elte.hu> <20090703192947.7921a515@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090703192947.7921a515@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > +       if( tty->count == 1 && port->count != 1) {
> > 
> > and you pushed that piece of code upstream, and you called 
> > checkpatch a religion - so apparently you were not using that 
> > tool and apparently you think it's fine to push such changes 
> > upstream.
> 
> The discussion started about something else - a piece of 
> non-compilable proposal code you space reviewed and didn't even 
> notice wasn't compileable or sane.
> 
> I'm sort of amused you went back through my commits to find that 
> example, and its certainly one that should have been fixed in the 
> final submit. I can't be bothered to write a perl script to 
> checkpatch all your commits and I suspect they all pass anyway.

FYI, it took me less than 10 seconds to find that commit, i didnt 
have to go to any trouble or perl script - i just searched for the 
same bad pattern i saw here.

You should consider putting in some automation into your workflow if 
you have some time - it really helps. I was surprised how much 
easily fixable crap various measures of automation found in my own 
patches. The tools are there to use them, not to ignore, ridicule or 
fight them, and for kernel oldbies there's absolutely no valid 
excuse to not use them IMHO.
 
It's a bit sad you are making such a big deal out of my criticism 
though. Your criticism about the x86/MTRR code was spot on, mind 
doing some more review on arch/x86/?

	Ingo
