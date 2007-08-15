Return-Path: <linux-kernel-owner+w=401wt.eu-S937003AbXHOXvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937003AbXHOXvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762959AbXHOXvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:51:31 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45932 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757973AbXHOXv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:51:29 -0400
Date: Wed, 15 Aug 2007 16:51:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Herbert Xu <herbert.xu@redhat.com>
Cc: Chris Snook <csnook@redhat.com>, satyam@infradead.org, clameter@sgi.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       torvalds@linux-foundation.org, netdev@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de, heiko.carstens@de.ibm.com,
       davem@davemloft.net, schwidefsky@de.ibm.com, wensong@linux-vs.org,
       horms@verge.net.au, wjiang@resilience.com, cfriesen@nortel.com,
       zlynx@acm.org, rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070815235125.GT9645@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070815234021.GA28775@gondor.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 07:40:21AM +0800, Herbert Xu wrote:
> On Wed, Aug 15, 2007 at 12:13:12PM -0400, Chris Snook wrote:
> >
> > Part of the motivation here is to fix heisenbugs.  If I knew where they 
> 
> By the same token we should probably disable optimisations
> altogether since that too can create heisenbugs.

Precisely the point -- use of volatile (whether in casts or on asms)
in these cases are intended to disable those optimizations likely to
result in heisenbugs.  But they are also intended to leave other
valuable optimizations in force.

						Thanx, Paul
