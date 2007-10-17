Return-Path: <linux-kernel-owner+w=401wt.eu-S935323AbXJQRab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935323AbXJQRab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 13:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762586AbXJQRaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 13:30:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47797 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070AbXJQRaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 13:30:16 -0400
Date: Wed, 17 Oct 2007 19:30:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bug] block subsystem related crash with latest -git
Message-ID: <20071017173001.GA1266@elte.hu>
References: <20071017154655.GA13394@elte.hu> <alpine.LFD.0.999.0710170929270.26902@woody.linux-foundation.org> <20071017165949.GF15552@kernel.dk> <20071017170804.GG15552@kernel.dk> <20071017172158.GH15552@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017172158.GH15552@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > -			sg = next_sg;
> > -			next_sg = sg_next(sg);
> > +			if (!sg)
> > +				sg = sglist;
> > +			else
> > +				sg = sg_next(sg);
> >  
> >  			memset(sg, 0, sizeof(*sg));
> >  			sg->page = bvec->bv_page;
> > 
> 
> Scratch that, it cannot work... I'll think up a different approach.

too late, crashed my box with it already :-)

	Ingo
