Return-Path: <linux-kernel-owner+w=401wt.eu-S1758568AbZFBDxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568AbZFBDxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 23:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbZFBDxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 23:53:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:51000 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755635AbZFBDxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 23:53:14 -0400
Date: Tue, 2 Jun 2009 13:53:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: akpm@linux-foundation.org, linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com
Subject: Re: [PATCH] hwrng: Add TX4939 RNG driver
Message-ID: <20090602035303.GC22831@gondor.apana.org.au>
References: <1243350141-883-1-git-send-email-anemo@mba.ocn.ne.jp> <20090529162907.9cb1bba2.akpm@linux-foundation.org> <20090601.014517.169682203.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090601.014517.169682203.anemo@mba.ocn.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 01:45:17AM +0900, Atsushi Nemoto wrote:
>
> >From the datasheet:
> 
> 	The quality of the random numbers generated immediately after
> 	reset can be insufficient.  Therefore, do not use random
> 	numbers obtained from the first and second generations; use
> 	the ones from the third or subsequent generation.
> 
> I will put this comment in the driver.

OK, I think you've resolved all my concerns.  Please cc me when
you resubmit.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
