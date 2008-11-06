Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYKFOwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYKFOwB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 09:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751082AbYKFOvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 09:51:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47665 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbYKFOvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 09:51:52 -0500
Date: Thu, 6 Nov 2008 15:51:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] vmap: cope with vm_unmap_aliases before
	vmalloc_init()
Message-ID: <20081106145132.GH13023@elte.hu>
References: <49010D41.1080305@goop.org> <4911EB5C.4030901@goop.org> <20081106100234.GM4890@elte.hu> <200811062141.01437.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811062141.01437.nickpiggin@yahoo.com.au>
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Thursday 06 November 2008 21:02, Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > Jeremy Fitzhardinge wrote:
> > >> Xen can end up calling vm_unmap_aliases() before vmalloc_init() has
> > >> been called.  In this case its safe to make it a simple no-op.
> > >>
> > >> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > >
> > > Ping?  Nick, Ingo: do you want to pick these up, or shall I send them to
> > > Linus myself?
> >
> > i've applied them to tip/core/urgent and will send them to Linus
> > unless Nick or Andrew has objections.
> 
> Thanks, yeah ack from me on those. I'm generally expecting Andrew to 
> pick up and merge mm patches, but I guess he wasn't cc'ed this time. 
> Anyway, if Ingo gets them upstream, that would be fine too.

linux-mm was Cc:-ed - but the crux of the changes was in Xen code, so 
i guess Andrew was looking at me and i was looking at him, expecting 
the other guy to do the work ;-)

anyway, it's all queued up and tested now.

	Ingo
