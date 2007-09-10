Return-Path: <linux-kernel-owner+w=401wt.eu-S965348AbXIJQD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348AbXIJQD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964847AbXIJQDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:03:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42964 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964836AbXIJQDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:03:45 -0400
Date: Mon, 10 Sep 2007 18:02:17 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
Message-ID: <20070910180217.7cc9878b@laptopd505.fenrus.org>
In-Reply-To: <200709101538.25132.vda.linux@googlemail.com>
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com>
	<200709101156.30010.vda.linux@googlemail.com>
	<20070910155156.2c1453fc@laptopd505.fenrus.org>
	<200709101538.25132.vda.linux@googlemail.com>
Organization: Intel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 15:38:23 +0100
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> On Monday 10 September 2007 15:51, Arjan van de Ven wrote:
> > On Mon, 10 Sep 2007 11:56:29 +0100
> > Denys Vlasenko <vda.linux@googlemail.com> wrote:
> > 
> > > 
> > > Well, if you insist on having it again:
> > > 
> > > Waiting for atomic value to be zero:
> > > 
> > >         while (atomic_read(&x))
> > >                 continue;
> > > 
> > 
> > and this I would say is buggy code all the way.
> >
> > Not from a pure C level semantics, but from a "busy waiting is
> > buggy" semantics level and a "I'm inventing my own locking"
> > semantics level.
> 
> After inspecting arch/*, I cannot agree with you.

the arch/ people obviously are allowed to do their own locking stuff...
BECAUSE THEY HAVE TO IMPLEMENT THAT!


the arch maintainers know EXACTLY how their hw behaves (well, we hope)
so they tend to be the exception to many rules in the kernel....
