Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbXLUQhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbXLUQhw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 11:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbXLUQhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 11:37:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34702 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbXLUQhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 11:37:42 -0500
Date: Fri, 21 Dec 2007 17:33:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071221163337.GA8660@elte.hu>
References: <1197049846.1645.68.camel@localhost.localdomain> <20071211143336.GA17866@elte.hu> <Pine.LNX.4.64.0712131416280.25120@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu> <20071221122628.GA18002@elte.hu> <Pine.LNX.4.64.0712210818360.29372@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712210818360.29372@schroedinger.engr.sgi.com>
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


* Christoph Lameter <clameter@sgi.com> wrote:

> On Fri, 21 Dec 2007, Ingo Molnar wrote:
> 
> > and this is not the only regression:
> > 
> >     http://lkml.org/lkml/2007/10/4/290
> > 
> > _6%_ TPC-C regression. That's _a lot_ in TPC-C terms.
> > 
> > and just like in this case there were very clear profiles posted. I 
> > proffer, reading back the whole thread, that if you fix hackbench 
                                                 ^^^^^^^^^^^^^^^^^^^^
> > you have fixed TPC-C as well.
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> There are patches pending to address these issues. AFAICT Intel is 
> testing if the regression is still there. There is no way for me to 
> verify what is going on there and there is the constant difficulty of 
> getting detailed information about what is going on at Intel. Every 
> couple of month I get a result from that test. Its a really crappy 
> situation where a lot of confusing information is passed around.

of course there is a way to find out, and that's why i mailed you: fix 
the hackbench regression and i'm quite sure you'll improve the TPC-C 
numbers as well. It shows the same kind of overhead in the profile and 
takes just a few seconds to run. Are your pending SLUB patches in 
2.6.24-rc5-mm1 already?

	Ingo
