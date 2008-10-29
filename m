Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYJ2Lfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYJ2Lfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 07:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYJ2Lfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 07:35:45 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:34972 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYJ2Lfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 07:35:44 -0400
Date: Wed, 29 Oct 2008 12:34:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
Message-ID: <20081029113434.GA31673@kernel.dk>
References: <20081027094111.GU22217@kernel.dk> <4905A961.9000603@goop.org> <20081027115659.GZ22217@kernel.dk> <20081029080603J.fujita.tomonori@lab.ntt.co.jp> <20081029083713.GE6364@elte.hu> <49082BBC.60302@goop.org> <20081029105113.GA15981@elte.hu> <20081029112504.GA1935@elte.hu> <20081029112745.GT22217@kernel.dk> <20081029113016.GA3751@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029113016.GA3751@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Oct 29 2008, Ingo Molnar wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > 
> > > > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > > 
> > > > >> does it have any dependency on:
> > > > >>
> > > > >>   Subject: [PATCH 1/2] bio: define __BIOVEC_PHYS_MERGEABLE
> > > > >
> > > > > No, they're independent.  Defining __BIOVEC_PHYS_MERGEABLE will be 
> > > > > useful for the Xen changes I need to make in the wake of Tomo's 
> > > > > patch.
> > > > 
> > > > ok - applied to tip/x86/xen, thanks Jeremy! (also added Jens's 
> > > > Acked-by)
> > > 
> > > build failure, zapped it:
> > > 
> > > fs/bio.c: In function '__bio_add_page':
> > > fs/bio.c:443: error: implicit declaration of function '__BIOVEC_PHYS_MERGEABLE'
> > 
> > What patch(es) did you apply?
> 
> the one i replied to (2/2), and which one Jeremy said was independent 
> of 1/2. Not so much it appears.

OK, those two are definitely connected, since the first one defines
__BIOVEC_PHYS_MERGEABLE :-)

The one I acked was in the mail I replied to, Tomos patch.

-- 
Jens Axboe

