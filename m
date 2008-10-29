Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbYJ2Lag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbYJ2Lag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 07:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYJ2La2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 07:30:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYJ2La1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 07:30:27 -0400
Date: Wed, 29 Oct 2008 12:30:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with
	BIOVEC_PHYS_MERGEABLE
Message-ID: <20081029113016.GA3751@elte.hu>
References: <20081027094111.GU22217@kernel.dk> <4905A961.9000603@goop.org> <20081027115659.GZ22217@kernel.dk> <20081029080603J.fujita.tomonori@lab.ntt.co.jp> <20081029083713.GE6364@elte.hu> <49082BBC.60302@goop.org> <20081029105113.GA15981@elte.hu> <20081029112504.GA1935@elte.hu> <20081029112745.GT22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029112745.GT22217@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Oct 29 2008, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > 
> > > >> does it have any dependency on:
> > > >>
> > > >>   Subject: [PATCH 1/2] bio: define __BIOVEC_PHYS_MERGEABLE
> > > >
> > > > No, they're independent.  Defining __BIOVEC_PHYS_MERGEABLE will be 
> > > > useful for the Xen changes I need to make in the wake of Tomo's 
> > > > patch.
> > > 
> > > ok - applied to tip/x86/xen, thanks Jeremy! (also added Jens's 
> > > Acked-by)
> > 
> > build failure, zapped it:
> > 
> > fs/bio.c: In function '__bio_add_page':
> > fs/bio.c:443: error: implicit declaration of function '__BIOVEC_PHYS_MERGEABLE'
> 
> What patch(es) did you apply?

the one i replied to (2/2), and which one Jeremy said was independent 
of 1/2. Not so much it appears.

	Ingo
