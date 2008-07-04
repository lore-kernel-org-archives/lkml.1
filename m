Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYGDLnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYGDLnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 07:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGDLnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 07:43:25 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:47929 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752491AbYGDLnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 07:43:24 -0400
Date: Fri, 4 Jul 2008 19:43:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: use kernel-provided bitops, unaligned access helpers
Message-ID: <20080704114315.GA6266@gondor.apana.org.au>
References: <1215119038.16647.23.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215119038.16647.23.camel@brick>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 02:03:57PM -0700, Harvey Harrison wrote:
> Remove the private implementation of 32-bit rotation and unaligned
> access with byteswapping.
> 
> As a bonus, fixes sparse warnings:
> crypto/camellia.c:602:2: warning: cast to restricted __be32
> crypto/camellia.c:603:2: warning: cast to restricted __be32
> crypto/camellia.c:604:2: warning: cast to restricted __be32
> crypto/camellia.c:605:2: warning: cast to restricted __be32
> crypto/camellia.c:710:2: warning: cast to restricted __be32
> crypto/camellia.c:711:2: warning: cast to restricted __be32
> crypto/camellia.c:712:2: warning: cast to restricted __be32
> crypto/camellia.c:713:2: warning: cast to restricted __be32
> crypto/camellia.c:714:2: warning: cast to restricted __be32
> crypto/camellia.c:715:2: warning: cast to restricted __be32
> crypto/camellia.c:716:2: warning: cast to restricted __be32
> crypto/camellia.c:717:2: warning: cast to restricted __be32
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Patch applied.  BTW, this driver should perhaps use align mask
instead rather than handling unaligned data on its own.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
