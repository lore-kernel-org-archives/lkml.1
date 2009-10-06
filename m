Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbZJFSSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbZJFSSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbZJFSSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:18:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59590 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011AbZJFSSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:18:07 -0400
Date: Tue, 6 Oct 2009 20:16:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006181637.GA25732@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <4ACB7B4D.8080203@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACB7B4D.8080203@s5r6.in-berlin.de>
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


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Linus Torvalds wrote:
> > So how about this?
> > 
> > It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial 
> > way:
> > 
> >  - if it is set, things work the way they always have, and you get a 
> >    extended kernel release like
> > 
> > 	2.6.32-rc3-00052-g0eca52a-dirty
> > 
> >  - but if it is _not_ set,
> [...]
> >    we append just "+", so you get a version number like
> > 
> > 	2.6.32-rc3+
> [...]
> > The "+" could be anything else, of course. The diff is pretty obvious, you 
> > can argue about exactly _what_ you'd like to see as a suffix for "and then 
> > some".
> 
> The "+" suffix is already in informal use with a different meaning. 
> It's customary to write "For feature XY, you need kernel 2.6.31+" as a 
> shorthand for "kernel 2.6.31 or any later release".

'+' is also informally used to denote addition and a whole ton of other 
things. (and likewise all other ASCII characters)

The primary context in where it's used, uname output and "I used kernel 
v2.6.31+" statements is pretty unambigous i think.

	Ingo
