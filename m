Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXHOMGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXHOMGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 08:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXHOMFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 08:05:45 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1754 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754072AbXHOMFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 08:05:43 -0400
Date: Wed, 15 Aug 2007 20:04:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Satyam Sharma <satyam@infradead.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       ak@suse.de, heiko.carstens@de.ibm.com, davem@davemloft.net,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070815120422.GA21649@gondor.apana.org.au>
References: <20070809131423.GA9927@shell.boston.redhat.com> <Pine.LNX.4.64.0708141529310.32693@schroedinger.engr.sgi.com> <alpine.LFD.0.999.0708150417240.6482@enigma.security.iitk.ac.in> <46C2D6F3.3070707@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C2D6F3.3070707@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 12:35:31PM +0200, Stefan Richter wrote:
> 
> LDD3 says on page 125:  "The following operations are defined for the
> type [atomic_t] and are guaranteed to be atomic with respect to all
> processors of an SMP computer."
> 
> Doesn't "atomic WRT all processors" require volatility?

Not at all.  We also require this to be atomic without any
hint of volatility.

	extern int foo;
	foo = 4;

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
