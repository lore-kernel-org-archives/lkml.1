Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYHDOE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYHDOE4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 10:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYHDOEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 10:04:47 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:59486 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753359AbYHDOEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 10:04:46 -0400
Date: Mon, 4 Aug 2008 22:04:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Austin Zhang <austin_zhang@linux.intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Message-ID: <20080804140435.GA11227@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain> <1217844725.3454.580.camel@pmac.infradead.org> <1217846139.20845.25.camel@localhost.localdomain> <1217846726.3454.589.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217846726.3454.589.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 11:45:26AM +0100, David Woodhouse wrote:
> 
> Are we deprecating libcrc32c, then? Or just turning it into a wrapper
> around the crypto code?

It will be removed.

> Either way, does it really make sense to force all crc32 users to pull
> in the whole crypto framework? Some may get fractious about that...

There only three crc32c users in the kernel tree and the crypto
interface will serve the perfectly.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
