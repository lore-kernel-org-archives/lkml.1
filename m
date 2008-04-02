Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYDBH3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYDBH3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYDBH3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:29:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYDBH3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:29:11 -0400
Date: Wed, 2 Apr 2008 09:28:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402072846.GA16454@elte.hu>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI> <20080402072456.GI12774@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080402072456.GI12774@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Wed, Apr 02 2008, Pekka J Enberg wrote:
> > On Wed, 2 Apr 2008, Jens Axboe wrote:
> > > Good catch, I wonder why it didn't complain in my testing. I've added a
> > > patch to fix that, please see it here:
> > 
> > You probably don't have kmemcheck in your kernel ;-)
> 
> Ehm no, you are right :)

... and you can get kmemcheck by testing on x86.git/latest:

  http://people.redhat.com/mingo/x86.git/README

;-)

	Ingo
