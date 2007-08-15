Return-Path: <linux-kernel-owner+w=401wt.eu-S965101AbXHOXlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965101AbXHOXlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 19:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964880AbXHOXlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 19:41:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:4876 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762020AbXHOXla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 19:41:30 -0400
Date: Thu, 16 Aug 2007 07:40:21 +0800
From: Herbert Xu <herbert.xu@redhat.com>
To: Chris Snook <csnook@redhat.com>
Cc: satyam@infradead.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, segher@kernel.crashing.org
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070815234021.GA28775@gondor.apana.org.au>
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C32618.2080108@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2007 at 12:13:12PM -0400, Chris Snook wrote:
>
> Part of the motivation here is to fix heisenbugs.  If I knew where they 

By the same token we should probably disable optimisations
altogether since that too can create heisenbugs.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
