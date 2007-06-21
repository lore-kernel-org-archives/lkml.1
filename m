Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbXFUVQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbXFUVQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756233AbXFUVQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:16:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48685 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082AbXFUVQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:16:10 -0400
Date: Thu, 21 Jun 2007 23:15:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Chuck Ebbert <cebbert@redhat.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Miklos Szeredi <miklos@szeredi.hu>,
       chris@atlee.ca, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [patch] spinlock debug: make looping nicer
Message-ID: <20070621211525.GA9973@elte.hu>
References: <20070621160817.GA22897@elte.hu> <467AAB04.2070409@redhat.com> <alpine.LFD.0.98.0706211024370.3593@woody.linux-foundation.org> <20070621202917.a2bfbfc7.dada1@cosmosbay.com> <alpine.LFD.0.98.0706211135360.3593@woody.linux-foundation.org> <alpine.LFD.0.98.0706211230130.3593@woody.linux-foundation.org> <20070621200941.GB22303@elte.hu> <alpine.LFD.0.98.0706211311350.3593@woody.linux-foundation.org> <20070621204234.GA1510@elte.hu> <alpine.LFD.0.98.0706211352530.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706211352530.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 21 Jun 2007, Ingo Molnar wrote:
> > 
> > btw., back then we also tried a spin_is_locked() based inner loop 
> > but it didnt help the ->tree_lock lockups either. In any case i very 
> > much agree that the 'nicer' looping should be added again - the 
> > patch below does that. (build and boot tested)
> 
> Ok, I'm definitely not going to apply it right now, though.

yeah, very much so. Lots of distros ship with spinlock debugging enabled 
(at least in their betas), we dont want to break that accidentally.

	Ingo
