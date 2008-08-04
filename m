Return-Path: <linux-kernel-owner+w=401wt.eu-S1759195AbYHDRK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759195AbYHDRK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 13:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbYHDRKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 13:10:39 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:51102 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758798AbYHDRKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 13:10:38 -0400
Date: Tue, 5 Aug 2008 01:10:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>, dwmw2@infradead.org,
       austin_zhang@linux.intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate	CRC32c algorithm by new crypto API.
Message-ID: <20080804171017.GA13725@gondor.apana.org.au>
References: <1217866496.29139.75.camel@think.oraclecorp.com> <E1KQ3Be-0003T3-00@gondolin.me.apana.org.au> <20080804100605.4f0921f4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080804100605.4f0921f4@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 10:06:05AM -0700, Arjan van de Ven wrote:
> 
> well you still have that indirect function call
> 
> for libcrc32 we could alternatives() that...

I don't see why you couldn't do that for the crypto API too
if you wanted to.  That way it would benefit all crypto users
rather than just the crc32c (note the extra c) users.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
