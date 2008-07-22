Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYGVPeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYGVPeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 11:34:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbYGVPd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 11:33:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42369 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbYGVPd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 11:33:56 -0400
Date: Tue, 22 Jul 2008 17:33:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: rename PTE_MASK to PTE_PFN_MASK
Message-ID: <20080722153336.GA18757@elte.hu>
References: <200807221431.58991.rusty@rustcorp.com.au> <488566EA.5040805@goop.org> <200807221540.47161.rusty@rustcorp.com.au> <4885774E.3000909@goop.org> <873am2kr4n.fsf@saeurebad.de> <4885F43B.7060307@goop.org> <8763qyj6br.fsf@saeurebad.de> <87wsjehrhs.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsjehrhs.fsf@saeurebad.de>
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


* Johannes Weiner <hannes@saeurebad.de> wrote:

> Johannes Weiner <hannes@saeurebad.de> writes:
> 
> > Hi,
> >
> > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> >
> >> Johannes Weiner wrote:
> >>> PTE_PFN_MASK is not symmetric to PAGE_MASK.
> >>
> >> No, it isn't.  Is there anything about the name that suggests that it
> >> should be?  PTE_PFN_MASK is for operating on pteval_t-typed values
> >> extracted from ptes; PAGE_MASK is for operating on addresses.
> >
> > I meant the naming scheme, not the functionality.
> >
> > The thing PAGE_MASK and PTE_MASK have in common is that they are masks
> > and their names indicate what is masked away when applied.
> >
> > So PAGE_MASK suggests that it masks out page details.  And PTE_MASK
> > suggests that it masks out PTE details.
> >
> > PTE_PFN_MASK masks suggests that it masks out the flags, according 
> > to the existing naming convention.  But it does the opposite.
> 
> As you explained me how PAGE_MASK was meant, scratch the above ;)

btw., feel free to send a patch that adds more comments that makes it 
obvious at first sight if someone takes a look at the defines.

	Ingo
