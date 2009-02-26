Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbZBZU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbZBZU1k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758556AbZBZU1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:27:24 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45131 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbZBZU1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:27:23 -0500
Date: Thu, 26 Feb 2009 21:27:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] signals: don't copy siginfo_t on dequeue
Message-ID: <20090226202711.GB23446@elte.hu>
References: <20090226184433.GA15644@damson.getinternet.no> <20090226185053.GD31413@elte.hu> <19f34abd0902261110n7b73eabdpf5b963594fc821c8@mail.gmail.com> <20090226201905.GA8548@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226201905.GA8548@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 02/26, Vegard Nossum wrote:
> >
> > 2009/2/26 Ingo Molnar <mingo@elte.hu>:
> > >
> > > I.e. shouldnt we have seen a speedup, due to not having to copy
> > > the siginfo structure?
> 
> I am puzzled by these numbers too. I can't understand how this 
> patch can make any difference.

Measurement noise perhaps. Especially such microbenchmarks can 
be very sensitive to cache layout, etc.

	Ingo
