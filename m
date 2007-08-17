Return-Path: <linux-kernel-owner+w=401wt.eu-S1764454AbXHQACm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764454AbXHQACm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 20:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbXHQACa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 20:02:30 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3251 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753510AbXHQAC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 20:02:28 -0400
Date: Fri, 17 Aug 2007 08:02:09 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Paul Mackerras <paulus@samba.org>, Satyam Sharma <satyam@infradead.org>,
       Christoph Lameter <clameter@sgi.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070817000209.GC11594@gondor.apana.org.au>
References: <18115.45316.702491.681906@cargo.ozlabs.ibm.com> <alpine.LFD.0.999.0708160800130.24380@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0708160815510.24380@enigma.security.iitk.ac.in> <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <20070816053945.GB32442@gondor.apana.org.au> <18115.62741.807704.969977@cargo.ozlabs.ibm.com> <20070816070907.GA964@gondor.apana.org.au> <46C40587.7050708@s5r6.in-berlin.de> <20070816081049.GA1431@gondor.apana.org.au> <46C4AA26.4060707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C4AA26.4060707@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 03:48:54PM -0400, Chris Snook wrote:
>
> >Can you find an actual atomic_read code snippet there that is
> >broken without the volatile modifier?
> 
> A whole bunch of atomic_read uses will be broken without the volatile 
> modifier once we start removing barriers that aren't needed if volatile 
> behavior is guaranteed.

Could you please cite the file/function names so we can
see whether removing the barrier makes sense?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
