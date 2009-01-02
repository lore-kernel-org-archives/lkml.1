Return-Path: <linux-kernel-owner+w=401wt.eu-S1759121AbZABUr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121AbZABUr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 15:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZABUrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 15:47:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42881 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757698AbZABUrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 15:47:16 -0500
Date: Fri, 2 Jan 2009 21:46:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland Dreier <rdreier@cisco.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb: Add missing __init annotations
Message-ID: <20090102204649.GB21988@elte.hu>
References: <adamyedq8p3.fsf@cisco.com> <20090101130255.GA21886@uranus.ravnborg.org> <20090102192502.GF14249@elte.hu> <adasko1pjck.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adasko1pjck.fsf@cisco.com>
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


* Roland Dreier <rdreier@cisco.com> wrote:

> > > @@ -186,7 +186,7 @@ static void swiotlb_print_info(unsigned long bytes)
> > >   * Statically reserve bounce buffer space and initialize bounce buffer data
> > >   * structures for the software IO TLB used to implement the DMA API.
> > >   */
> > > -void __init
> > > +void __init __weak
> > >  swiotlb_init_with_default_size(size_t default_size)
> > 
> > This change looks unrealted to __init annotation described in the 
> > changelog. Was it intentional?
> 
> Yes, that was a thinko -- somehow while reading it I saw the __init 
> without __weak as being missing an annotation.  Should I resend a fixed 
> patch?

no need - so it wasnt needed to make a section warning go away - i.e. your 
patch sans the last hunk is tested to solve the problem, right?

	Ingo
