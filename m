Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYIJIB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYIJIB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYIJIBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:01:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYIJIBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:01:21 -0400
Date: Wed, 10 Sep 2008 10:00:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hugh@veritas.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH tip] x86: unsigned long pte_pfn
Message-ID: <20080910080055.GB15255@elte.hu>
References: <Pine.LNX.4.64.0809082100090.30216@blonde.site> <48C589D2.5030905@goop.org> <Pine.LNX.4.64.0809091612410.19349@blonde.site> <48C6A9C2.7000401@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C6A9C2.7000401@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> > [PATCH tip] x86: unsigned long pte_pfn
> >
> > pte_pfn() has always been of type unsigned long, even on 32-bit PAE;
> > but in the current tip/next/mm tree it works out to be unsigned long
> > long on 64-bit, which gives an irritating warning if you try to printk
> > a pfn with the usual %lx.
> >
> > Now use the same pte_pfn() function, moved from pgtable-3level.h
> > to pgtable.h, for all models: as suggested by Jeremy Fitzhardinge.
> > And pte_page() can well move along with it (remaining a macro to
> > avoid dependence on mm_types.h).
> >
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> >   
> Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>

applied to tip/x86/mm, thanks guys!

	Ingo
