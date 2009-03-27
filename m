Return-Path: <linux-kernel-owner+w=401wt.eu-S1754970AbZC0FAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbZC0FAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZC0FAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:00:32 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38812 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751808AbZC0FAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:00:31 -0400
Date: Fri, 27 Mar 2009 13:00:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] [HWRNG] fixed timeriomem-rng to use a phys address
	rather than virt
Message-ID: <20090327050024.GA26198@gondor.apana.org.au>
References: <20090321132803.GN22563@woodchuck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321132803.GN22563@woodchuck>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 01:28:03PM +0000, Alexander Clouter wrote:
> [HWRNG] fixed timeriomem-rng to use a phys address rather than virt
> 
> There is no ioremap'ing or anything in timeriomem-rng.c as I foolishly
> used already remapped virtual addresses instead of passing the physical
> address to be polled.
> 
> This patch fixes this flaw and lets developers do the Right Thing(tm).
> 
> Signed-off-by: Alexander Clouter <alex@digriz.org.uk>

Applied to crypto-2.6.  Thanks Alexander.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
