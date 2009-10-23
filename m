Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZJWHW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZJWHW4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 03:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbZJWHW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 03:22:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbZJWHWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 03:22:55 -0400
Date: Fri, 23 Oct 2009 09:22:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Koskinen Aaro (Nokia-D/Helsinki)" <aaro.koskinen@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v11 4/5] core: Add kernel message dumper to call on
	oopses and panics
Message-ID: <20091023072236.GA19169@elte.hu>
References: <20091016080935.GA3895@elte.hu> <1255681467.32489.360.camel@localhost> <20091016112556.6902b2dc@marrow.netinsight.se> <20091016101045.GA3263@elte.hu> <20091016140918.3981cfa2@marrow.netinsight.se> <1255952922.32489.505.camel@localhost> <20091019125017.GA9030@elte.hu> <alpine.LFD.2.00.0910220832580.9771@eeepc.linux-foundation.org> <20091022082500.602f9a7d@marrow.netinsight.se> <1256193368.29856.466.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256193368.29856.466.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Artem Bityutskiy <dedekind1@gmail.com> wrote:

> On Thu, 2009-10-22 at 08:25 +0200, Simon Kagstrom wrote:
> > On Thu, 22 Oct 2009 08:33:11 +0900 (JST)
> > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > 
> > > > > I wonder, via which tree this should go in. We are going to have mtdoops
> > > > > depend on this. Should we go one of these ways:
> > > > > 
> > > > >    * this patch goes to one of Ingo's tip trees, so we can pull it and
> > > > >      work on top.
> > > > >    * we have Ingo's / Linus' acks, and this goes via the MTD tree.
> > > > > ?
> > > > 
> > > > Either way is good to me. Linus, do you have any preferences?
> > > 
> > > Either works for me.
> > 
> > I would put it all through Artems MTD tree then so that we keep the new
> > API and the user of it close together then.
> > 
> > Thanks to everyone for the reviewing and suggestions!
> > 
> 
> It's dwmw2's tree actually. I just act as his secretary :-)
> 
> David, could you push this patch to your tree? Ingo's and Linus' acks 
> are there, AFAIU.

Yeah, the latest bits also have my:

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
