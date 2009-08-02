Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZHBUya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZHBUya (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZHBUy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:54:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43294 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbZHBUy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:54:29 -0400
Date: Sun, 2 Aug 2009 17:47:01 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Anton Blanchard <anton@samba.org>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, benh@kernel.crashing.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, paulus@samba.org,
       williams@redhat.com
Subject: Re: [PATCH] basic perf support for sparc
Message-ID: <20090802204701.GE25334@ghostprotocols.net>
References: <20090729112509.GN4148@kernel.dk> <20090729192814.GT4148@kernel.dk> <20090801011429.GA4685@kryten> <20090801082048.GX12579@kernel.dk> <20090801182216.GA25334@ghostprotocols.net> <20090802184148.GB17241@elte.hu> <20090802194454.GC28572@bombadil.infradead.org> <20090802195043.GD24486@elte.hu> <20090802201132.GE28572@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090802201132.GE28572@bombadil.infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Aug 02, 2009 at 04:11:32PM -0400, Kyle McMartin escreveu:
> On Sun, Aug 02, 2009 at 09:50:43PM +0200, Ingo Molnar wrote:
> > We are sticking to a given version of the API. We could turn that 
> > into a function pointer and fill it in during startup via dlopen(). 
> > If it's NULL then we dont call it and assume a value of NULL.
> > 
> > Mind submitting such a version of your fix? It would nicely decrease 
> > the build requirements cross section surface of perf.
> > 
> 
> Assuming I remember how to use dlopen/dlsym, this might work.
> Unfortunately I can't easily test anything this weekend, so
> I don't actually know if it works... but it links ok.
> 
> cheers, Kyle

Doesn't seem to work, tried with firefox, with matching
xulrunner-debuginfo package installed and symbols didn't got properly
demangled, gotta be afk now, but will try to figure this out later.

[]s.

- Arnaldo
