Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbZJFS0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbZJFS0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbZJFS0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:26:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40702 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbZJFS0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:26:04 -0400
Date: Tue, 6 Oct 2009 20:24:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006182448.GB25732@elte.hu>
References: <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain> <20091006164028.GA23305@elte.hu> <20091006181218.GD24677@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006181218.GD24677@mit.edu>
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


* Theodore Tso <tytso@mit.edu> wrote:

> On Tue, Oct 06, 2009 at 06:40:28PM +0200, Ingo Molnar wrote:
> > 
> > Could we, for consistency's sake, make it:
> > 
> >  	2.6.32-rc3+00052-g0eca52a-dirty
> >  	2.6.32-rc3+
> > 
> > ? Or do we want to keep the old version string alone for some reason?
> 
> I'm a bit concerned that changing from what we've currently had:
> 
> >       2.6.29-00052-g0eca52a-dirty
> 
> might break some packaging scripts. [...]

( Sidenote: such scripts might as well need fixing then, even without 
  any upstream changes - adding a localversion file to the top level 
  directory (which many out of tree projects do) would possibly break 
  them as well. )

> [...]  I'm also personally used to that naming scheme; in fact at the 
> moment I'm using 2.6.32-rc1-00292-gb0390e2.  :-)

Yeah, i'm pretty happy with auto-localversion as well and use it 
everywhere. What i suggested is a small tweak to that: to make it more 
clear what people get during the merge window - when the string says 
"2.6.31-00292-gb0390e2". Plus a small tweak to the non-auto-localversion 
naming: to make the uname output more clear when people disable the 
auto-localversion option:

 Linux europe 2.6.31+ #2 SMP Tue Oct 6 19:26:58 CEST 2009 i686 i686 i386 GNU/Linux

versus the inaccurate:

 Linux europe 2.6.31 #2 SMP Tue Oct 6 19:26:58 CEST 2009 i686 i686 i386 GNU/Linux

string which we emit today.

	Ingo
